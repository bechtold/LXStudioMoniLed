public class ArtNetControlPattern extends LXPattern {
  
  protected final JSONModel model;
  
  private ArtNetClient artnet;
    
  private JSONModel.Fixture model_fixture;
  
  private ArrayList<LXModel> stripList = new ArrayList();
  
  public ArtNetControlPattern(LX lx){
    super(lx);
    this.model = (JSONModel) lx.model;
    
    this.model_fixture = (JSONModel.Fixture) model.fixtures.get(0);

    //walk all elements
    for(int i = 0; i<model_fixture.elements.size();i++){
      JSONElement.Fixture element_fixture = (JSONElement.Fixture) model_fixture.elements.get(i).fixtures.get(0);
      for(int j = 0; j < element_fixture.strips.size(); j++){
        this.stripList.add(element_fixture.strips.get(j));
      }
    }
    
    System.out.println();
    
    this.artnet = new ArtNetClient();
    this.artnet.start();
   }
   
   public String getAuthor(){
     return "Jan Müller";
   }
   
   public void run(double deltaMs) {
     byte[] data = artnet.readDmxData(0, 0);
     for(int i = 0; i < this.stripList.size(); i++){
       int address = i*3;
       int valueR = (data[address] & 0xFF);
       int valueG = (data[address + 1] & 0xFF);
       int valueB = (data[address + 1] & 0xFF);
       setColor(this.stripList.get(i), color(valueR, valueG, valueB));
     }
   }
  
}