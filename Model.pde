import java.util.List; //<>//

LXModel buildModel(JSONObject stripData) {
  // A three-dimensional grid model
  return new JSONStripModel(stripData);
}

public static class UniverseConfig {
    public int[] indices = new int[170];

    public UniverseConfig(){}
    
    public UniverseConfig(LXModel model, int address){
      this.addModel(model, address);
    }
    
    public void addModel(LXModel model, int address){
      for(int i = 0; i < model.points.length; i++){
        LXPoint point = model.points[i];
        indices[i+address] = point.index;
      }
    } 
  }

public static class ArtnetConfig{
 
  public static HashMap<String, HashMap<Integer, UniverseConfig>> storage = new HashMap<String, HashMap<Integer, UniverseConfig>>();

  public void addModel(LXModel model, String ip, int universe, int address){
    HashMap<Integer, UniverseConfig> ipConfig = storage.get(ip);
    if(ipConfig == null) ipConfig = new HashMap<Integer, UniverseConfig>();
    UniverseConfig universeConfig = ipConfig.get(universe);
    if(universeConfig == null) universeConfig = new UniverseConfig();
    universeConfig.addModel(model, address);
    ipConfig.put(universe, universeConfig);
    storage.put(ip, ipConfig);
    //System.out.println(storage);
//    System.out.println(storage.get("127.0.0.1"));
  }
  
}

public static class JSONStripModel extends LXModel {
  
  public static ArtnetConfig artnetConfig = new ArtnetConfig();
  
  public JSONStripModel(JSONObject stripData) {
    super(new Fixture(stripData));
  }
  
  public static class Fixture extends LXAbstractFixture {
    private final List<StripModel> strips = new ArrayList<StripModel>();

    Fixture(JSONObject stripData) {
      addElement(stripData);   
    }
    
    private void addElement(JSONObject subElement){
      addElement(subElement, 0, 0, 0); 
    }
    
    private void addElement(JSONObject elementData, int offSetX, int offSetY, int offSetZ){

      int posX = elementData.getInt("x", 0) + offSetX;
      int posY = elementData.getInt("y", 0) + offSetY;
      int posZ = elementData.getInt("z", 0) + offSetZ;
      
      JSONArray subElements = elementData.getJSONArray("elements");
      if(subElements != null) addElements(subElements, posX, posY, posZ);
      JSONArray stripsData = elementData.getJSONArray("strips");
      if(stripsData != null) addStrips(stripsData, posX, posY, posZ);
      
    }
    
    private void addElements(JSONArray elementsData, int offSetX, int offSetY, int offSetZ){
      for (int i = 0; i < elementsData.size(); i++) {
        JSONObject subElement = elementsData.getJSONObject(i);
        addElement(subElement, offSetX, offSetY, offSetZ);
      }
    }
    
    private void addStrips(JSONArray stipsData, int offSetX, int offSetY, int offSetZ){
      for (int i = 0; i < stipsData.size(); i++) {
        JSONObject stripData = stipsData.getJSONObject(i);
        addStrip(stripData, offSetX, offSetY, offSetZ);
      }
    }
    
    private void addStrip(JSONObject stripData, int offSetX, int offSetY, int offSetZ){
      
      int numLeds = stripData.getInt("leds", 0);
      
      JSONObject startPoint = stripData.getJSONObject("start");
      JSONObject endPoint = stripData.getJSONObject("end");
      
      float spacingX = (endPoint.getInt("x", 0) - startPoint.getInt("x", 0))/numLeds;
      float spacingY = (endPoint.getInt("y", 0) - startPoint.getInt("y", 0))/numLeds;
      float spacingZ = (endPoint.getInt("z", 0) - startPoint.getInt("z", 0))/numLeds;
      
      int posX = offSetX + stripData.getInt("x", 0) + startPoint.getInt("x", 0);
      int posY = offSetY + stripData.getInt("y", 0) + startPoint.getInt("y", 0);
      int posZ = offSetZ + stripData.getInt("z", 0) + startPoint.getInt("z", 0);      
      
      StripModel.Metrics stripMetrics = new StripModel.Metrics(numLeds);
      
      stripMetrics.setOrigin(posX, posY, posZ);
      stripMetrics.setSpacing(spacingX, spacingY, spacingZ);
      
      StripModel stripModel = new StripModel(stripMetrics);
      
      strips.add(stripModel);
      addPoints(stripModel);
      
      JSONObject artnetConfigData = stripData.getJSONObject("artnet");
      
      if(artnetConfigData != null){
        
        artnetConfig.addModel(
          stripModel, 
          artnetConfigData.getString("ip", "127.0.0.1"), 
          artnetConfigData.getInt("universe", 0), 
          artnetConfigData.getInt("address", 1));

      }
    }
  }
}
