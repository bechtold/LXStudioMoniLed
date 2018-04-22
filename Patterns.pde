public abstract class OLFPAPattern extends LXPattern {
  
  protected final JSONModel model;
  
  public OLFPAPattern(LX lx) {
    super(lx);
    this.model = (JSONModel) lx.model;
  }
  
  public abstract String getAuthor();
}

public class PatternSolid extends OLFPAPattern {
  public String getAuthor(){
    return "Oskar Bechtold";
  }
  
  public final CompoundParameter h = new CompoundParameter("Hue", 0, 360);
  public final CompoundParameter s = new CompoundParameter("Sat", 0, 100);
  public final CompoundParameter b = new CompoundParameter("Brt", 100, 100);
  
  public PatternSolid(LX lx) {
    super(lx);
    addParameter("h", this.h);
    addParameter("s", this.s);
    addParameter("b", this.b);
  }
  
  public void run(double deltaMs) {
    setColors(LXColor.hsb(this.h.getValue(), this.s.getValue(), this.b.getValue()));
  }
}

/**
 * Trying to implement the iterator class
 **/
public class Ozterator extends OLFPAPattern {    
  public String getAuthor(){
    return "Oskar Bechtold";
  }
  
  long lastMillis = 0;
  int lastIndex = 0;
  
  public final CompoundParameter speed =
    new CompoundParameter("Speed", .5, .001, 1)
    .setDescription("Speed of motion");

  public final BooleanParameter clear =
    new BooleanParameter("Clear", false)
    .setDescription("Should LEDs be cleared at all");

  public Ozterator(LX lx) {
    super(lx);
    addParameter("clear", this.clear);
    addParameter("speed", this.speed);
  }
  
  public void run (double deltaMs) {
    long currentMillis = java.lang.System.currentTimeMillis();
    
    if(currentMillis - lastMillis > 1000*this.speed.getValue()) {
      
      if(this.clear.isOn()){
        setColors(#000000);
      }

      int currentIndex = lastIndex + 1;
      if(currentIndex >= model.points.length) {
        currentIndex = 0;
      }
      
      int r = 255;
      colors[currentIndex] = LXColor.rgb(r, 0, 0);

      lastMillis = currentMillis;
      lastIndex = currentIndex;
    }
      
  }
}


/**
 * Set point with slider
 **/
public class OzSlider extends OLFPAPattern {
  public String getAuthor(){
    return "Oskar Bechtold";
  }
  
  public final DiscreteParameter index = new DiscreteParameter("Index", 0, model.points.length); 
  
  public OzSlider(LX lx) {
    super(lx);
    addParameter("Index", this.index);
  }
  
  public void run (double deltaMs) {
    setColors(#000000);
    setColor(this.index.getValuei(), #ffffff);
  }
}

/**
 * Set on random point at a time
 **/
public class OzRandom extends OLFPAPattern {
  public String getAuthor(){
    return "Oskar Bechtold";
  }

  long lastMillis = 0;

  public final CompoundParameter speed =
    new CompoundParameter("Speed", .5, .01, 1)
    .setDescription("Speed of motion");

  public final BooleanParameter clear =
    new BooleanParameter("Clear", false)
    .setDescription("Should LEDs be cleared at all");

  public final BooleanParameter flash =
    new BooleanParameter("Flash", false)
    .setDescription("Should LEDs be instantly be cleared");

  public final CompoundParameter amount =
    new CompoundParameter("Amount", 2, 1, 50)
    .setDescription("Amount of random pixels spawned");
    
  public final CompoundParameter h = new CompoundParameter("Hue", 0, 360);

    
  public OzRandom(LX lx) {
    super(lx);
    addParameter("speed", this.speed);
    addParameter("clear", this.clear);
    addParameter("flash", this.flash);
    addParameter("amount", this.amount);
    addParameter("hue", this.h);
  }
  
  public void run (double deltaMs) {
    if(this.flash.isOn() && this.clear.isOn()) {
      // clear all
      setColors(#000000);
    }

    long currentMillis = java.lang.System.currentTimeMillis();
    
    if(currentMillis - lastMillis > 1000*this.speed.getValue()) {
      if(this.clear.isOn()) {
        // clear all
        setColors(#000000);
      }

      for (int i = 0; i < this.amount.getValue(); i++) {
        // random number,   could use "import java.util.concurrent.ThreadLocalRandom;"
        int index = java.util.concurrent.ThreadLocalRandom.current().nextInt(0, model.points.length);
        setColor(index, LXColor.hsb(this.h.getValue(), 100, 100));
      }
      
      lastMillis = currentMillis;
    }
  }
}

/**
 * Animate strips
 * TODO: strips are not yet accessible
 **/
public class OzStrips extends OLFPAPattern {
  public String getAuthor(){
    return "Oskar Bechtold";
  }
  
  long lastMillis = 0;
  int lastIndex = 0;

  public final CompoundParameter speed =
    new CompoundParameter("Speed", .5, .01, 1)
    .setDescription("Speed of motion");

  public final BooleanParameter clear =
    new BooleanParameter("Clear", false)
    .setDescription("Should LEDs be cleared at all");

  public OzStrips(LX lx) {
    super(lx);
    addParameter("speed", this.speed);
    addParameter("clear", this.clear);
  }
  
  public void run(double deltaMs) {
    long currentMillis = java.lang.System.currentTimeMillis();
    if(currentMillis - lastMillis > 1000*this.speed.getValue()) {
      if(this.clear.isOn()) {
        // clear all
        setColors(#000000);
      }
      
      int currentIndex = lastIndex;
      JSONModel.Fixture mofix = (JSONModel.Fixture)model.fixtures.get(0);
      //println(mofix.elements.size());
      JSONElement.Fixture elfix = (JSONElement.Fixture)mofix.elements.get(1).fixtures.get(0);
      //println(elfix.strips.size());
      if(currentIndex >= elfix.strips.size()) {
        currentIndex = 0;
      }

      setColor(elfix.strips.get(currentIndex), #ff0000);
      
      
      lastMillis = currentMillis;
      lastIndex = currentIndex + 1;
    }
  }
}

//public class PatternTumbler extends LXPattern {
//  public String getAuthor() {
//    return "Mark C. Slee";
//  }
  
//  private LXModulator azimuthRotation = startModulator(new SawLFO(0, 1, 15000).randomBasis());
//  private LXModulator thetaRotation = startModulator(new SawLFO(0, 1, 13000).randomBasis());
  
//  public PatternTumbler(LX lx) {
//    super(lx);
//  }
    
//  public void run(double deltaMs) {
//    float azimuthRotation = this.azimuthRotation.getValuef();
//    float thetaRotation = this.thetaRotation.getValuef();
//    for (Leaf leaf : model.leaves) {
//      float tri1 = LXUtils.trif(azimuthRotation + leaf.point.azimuth / PI);
//      float tri2 = LXUtils.trif(thetaRotation + (PI + leaf.point.theta) / PI);
//      float tri = max(tri1, tri2);
//      setColor(leaf, LXColor.gray(100 * tri * tri));
//    }
//  }
//}
