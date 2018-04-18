LXModel buildModel(JSONObject stripData) { //<>//
  // A three-dimensional grid model
  return new GridModel3D(stripData);
}

public static class GridModel3D extends LXModel {
  
  public final static int SIZE = 20;
  
  public GridModel3D(JSONObject stripData) {
    super(new Fixture(stripData));
  }
  
  public static class Fixture extends LXAbstractFixture {
    
    Fixture(JSONObject stripData) {
      addElement(stripData);   
    }
    
    private void addElement(JSONObject subElement){
      addElement(subElement, 0, 0, 0); 
    }
    
    private void addElement(JSONObject elementData, int offSetX, int offSetY, int offSetZ){
      String name = elementData.getString("name", "anonymous");
      String nname = name;
      
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
      
      addPoints(stripModel);
      
    }
  }
}