import java.util.List; //<>//

LXModel buildModel(JSONObject stripData) {
  // A three-dimensional grid model
  return new JSONModel(stripData);
}

public static class UniverseConfig {

  public int[] indices = new int[170];

  public UniverseConfig() {
    for (int i=0; i<170; i++) {
      indices[i] = -1;
    }
  }

  public UniverseConfig(LXModel model, int address) {
    this.addModel(model, address);
  }

  public void addModel(LXModel model, int address) {
    for (int i = 0; i < model.points.length; i++) {
      LXPoint point = model.points[i];
      indices[i+address] = point.index;
    }
  }
}

public static class ArtnetConfig {

  public static HashMap<String, HashMap<Integer, UniverseConfig>> storage = new HashMap<String, HashMap<Integer, UniverseConfig>>();

  public void addModel(LXModel model, String ip, int universe, int address) {
    HashMap<Integer, UniverseConfig> ipConfig = storage.get(ip);
    if (ipConfig == null) ipConfig = new HashMap<Integer, UniverseConfig>();
    UniverseConfig universeConfig = ipConfig.get(universe);
    if (universeConfig == null) universeConfig = new UniverseConfig();
    universeConfig.addModel(model, address);
    ipConfig.put(universe, universeConfig);
    storage.put(ip, ipConfig);
    //System.out.println(storage);
    //    System.out.println(storage.get("127.0.0.1"));
  }
}


/**
 * JSONModel
 */
public static class JSONModel extends LXModel {
  public String name;

  public JSONModel(JSONObject modelData) {
    super(new Fixture(modelData));
    this.name = modelData.getString("name", "");
  }

  public static class Fixture extends LXAbstractFixture {
    private final List<JSONElement> elements = new ArrayList<JSONElement>();

    Fixture(JSONObject modelData) {
      addElements(modelData, 0, 0, 0);
    }

    /**
     * Extract elements from JSONArray then add them 
     */
    private void addElements(JSONObject modelData, int offSetX, int offSetY, int offSetZ) {
      int posX = modelData.getInt("x", 0) + offSetX;
      int posY = modelData.getInt("y", 0) + offSetY;
      int posZ = modelData.getInt("z", 0) + offSetZ;

      JSONArray elementsData = modelData.getJSONArray("elements");
      if (elementsData != null) addElements(elementsData, posX, posY, posZ);
    }

    /**
     * Add elements from JSONArray including offset 
     */
    private void addElements(JSONArray elementsData, int offSetX, int offSetY, int offSetZ) {
      for (int i = 0; i < elementsData.size(); i++) {
        JSONObject elementData = elementsData.getJSONObject(i);
        JSONElement element = new JSONElement(elementData, offSetX, offSetY, offSetZ);
        addPoints(element);
        elements.add(element);
      }
    }
  }
}

/**
 * JSONElement  
 */
public static class JSONElement extends LXModel {
  public String name;

  public JSONElement(JSONObject elementData) {
    super(new Fixture(elementData));
    this.name = elementData.getString("name", "");
  }
  public JSONElement(JSONObject elementData, int offSetX, int offSetY, int offSetZ) {
    super(new Fixture(elementData, offSetX, offSetY, offSetZ));
    this.name = elementData.getString("name", "");
  }

  public static class Fixture extends LXAbstractFixture {
    private final List<JSONStrip> strips = new ArrayList<JSONStrip>();

    Fixture(JSONObject elementData) {
      addStrips(elementData, 0, 0, 0);
    }
    Fixture(JSONObject elementData, int offSetX, int offSetY, int offSetZ) {
      addStrips(elementData, offSetX, offSetY, offSetZ);
    }

    /**
     * Extract strips from JSONArray then add them 
     */
    private void addStrips(JSONObject elementData, int offSetX, int offSetY, int offSetZ) {
      int posX = elementData.getInt("x", 0) + offSetX;
      int posY = elementData.getInt("y", 0) + offSetY;
      int posZ = elementData.getInt("z", 0) + offSetZ;

      JSONArray stripsData = elementData.getJSONArray("strips");
      if (stripsData != null) addStrips(stripsData, posX, posY, posZ);
    }

    /**
     * Add strips from JSONArray including offset 
     */
    private void addStrips(JSONArray stipsData, int offSetX, int offSetY, int offSetZ) {
      for (int i = 0; i < stipsData.size(); i++) {
        JSONObject stripData = stipsData.getJSONObject(i);
        //println(stripData);
        JSONStrip strip = new JSONStrip(stripData, offSetX, offSetY, offSetZ);
        addPoints(strip);
        strips.add(strip);
      }
    }
  }
}



/**
 * JSONStrip
 */
public static class JSONStrip extends LXModel {
  public static ArtnetConfig artnetConfig = new ArtnetConfig();
  public String name;

  public JSONStrip(JSONObject stripData) {
    super(new Fixture(stripData));
    this.name = stripData.getString("name", "");
  }

  public JSONStrip(JSONObject stripData, int offSetX, int offSetY, int offSetZ) {
    super(new Fixture(stripData, offSetX, offSetY, offSetZ));
    this.name = stripData.getString("name", "");
  }

  public static class Fixture extends LXAbstractFixture {
    private StripModel stripModel = null;

    Fixture(JSONObject stripData) {
      addStrip(stripData, 0, 0, 0);
    }

    Fixture(JSONObject stripData, int offSetX, int offSetY, int offSetZ) {
      addStrip(stripData, offSetX, offSetY, offSetZ);
    }

    private void addStrip(JSONObject stripData, int offSetX, int offSetY, int offSetZ) {

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

      stripModel = new StripModel(stripMetrics);
      addPoints(stripModel);

//       TODO Check ArtNetConfig
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