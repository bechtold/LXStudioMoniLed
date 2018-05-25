import java.util.List; //<>//

LXModel buildModel(JSONObject stripData) {
  // A three-dimensional grid model
  return new JSONModel(stripData);
}

/**
 * Class to hold a single universe configuration data
 */
public static class UniverseConfig {
  
  /**
   * Maximum number of LEDs per universe.
   */
   public static final int LEDS_PER_UNIVERSE = 170;

  /**
   * indices array to be given to the ArtNetDatagram constructor
   */
  public int[] indices = new int[LEDS_PER_UNIVERSE];

  /**
   * @Constructor
   * initializes indices array with -1 to not output anything by default;
   */
  public UniverseConfig() {
    for (int i=0; i<LEDS_PER_UNIVERSE; i++) {
      indices[i] = -1;
    }
  }

  /**
   * Adds model to the universe configuration
   * @param universeOffset The how manieth universe this is. Needed to calculate where to start selecting pixels in the model
   * @param rest How many pixels are n the last universe. Needed to break the loop at the end.
   */
  public void addModel(LXModel model, int offset, boolean reverse, int universeOffset, int universesNeeded, int rest) {
    //print("addModel");
    //print(" offset: ");
    //print(offset);
    //print(", universeOffset ");
    //print(universeOffset);
    //print(", modelLength ");
    //println(model.points.length);
    
      for (int i = 0; i < LEDS_PER_UNIVERSE; i++) {
        LXPoint point;
        if(reverse == true){
          // In the list of all leds start with respect of the already existing universes.
          int index = i + offset + LEDS_PER_UNIVERSE * universeOffset;
          // Break after the last led in th last needed universe.
          if (universeOffset+1 >= universesNeeded && index >= LEDS_PER_UNIVERSE * universeOffset + rest) break;
          // Break when last pixel is reached.
          if (index >= model.points.length) break;
          //TODO calc index with universeOffset
          point = model.points[model.points.length - 1 - index];
        } else {
          // In the list of all leds start with respect of the already existing universes.
          int index = i + offset + LEDS_PER_UNIVERSE * universeOffset;
          // Break after the last led in th last needed universe.
          if (universeOffset+1 >= universesNeeded && index >= LEDS_PER_UNIVERSE * universeOffset + rest) break;
          // Break when last pixel is reached.
          if (index >= model.points.length) break;
          //print(", index: ");
          //print(index);
          //print(", i: ");
          //print(i);
          //print(", length: ");
          //println(model.points.length);
          point = model.points[index];
        }
        indices[i+offset] = point.index;
      }  
  }
}

/**
 * Class to hold ArtNet configuration data
 */
public static class ArtnetConfig {

  /**
   * Storage that holds the actual data
   */
  public static HashMap<String, HashMap<Integer, UniverseConfig>> storage = new HashMap<String, HashMap<Integer, UniverseConfig>>();

  /**
   * add LX-Model to the Artnet configuration
   *
   */
  public void addModel(LXModel model, String ip, int universe, boolean reverse, int offset) {
    HashMap<Integer, UniverseConfig> ipConfig = storage.get(ip);
    if (ipConfig == null) ipConfig = new HashMap<Integer, UniverseConfig>();
    
    // calculate how many universes are needed TODO: check if universe exists and use for calculation
    int length = model.points.length + offset;
    // before dividing you need to convert at least one int to float to get a float :-D
    int universesNeeded = ceil((float)length / UniverseConfig.LEDS_PER_UNIVERSE);
    int rest = length % UniverseConfig.LEDS_PER_UNIVERSE;
    //print("Lenght: ");
    //print(length);
    //print(", L/U: ");
    //print(UniverseConfig.LEDS_PER_UNIVERSE);
    //print(", universesNeeded: ");
    //println(universesNeeded);
    
    // Add universes
    for(int i = 0; i < universesNeeded; i++) {
      UniverseConfig universeConfig = ipConfig.get(universe + i);
      if (universeConfig == null) universeConfig = new UniverseConfig();

      universeConfig.addModel(model, offset, reverse, universe+i, universesNeeded, rest);
      ipConfig.put(universe + i, universeConfig);
      storage.put(ip, ipConfig);
    }
    
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

       //TODO Check ArtNetConfig
      JSONObject artnetConfigData = stripData.getJSONObject("artnet");
      if(artnetConfigData != null){
        artnetConfig.addModel(
          stripModel,
          artnetConfigData.getString("ip", "127.0.0.1"),
          artnetConfigData.getInt("universe", 0),
          artnetConfigData.getBoolean("reverse", false),
          artnetConfigData.getInt("offset", 0));
      }
    }
  }
}
