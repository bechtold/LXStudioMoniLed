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

  JSONModel.Fixture model_fixture = (JSONModel.Fixture)model.fixtures.get(0);

  public final CompoundParameter element_selector =
    new CompoundParameter("Element", 0, 0, model_fixture.elements.size() - 1)
    .setDescription("Select the affected Element");
  
  public final CompoundParameter speed =
    new CompoundParameter("Speed", 500, 1, 1000)
    .setDescription("Speed of motion");

  public final BooleanParameter clear =
    new BooleanParameter("Clear", false)
    .setDescription("Should LEDs be cleared at all");

  public OzStrips(LX lx) {
    super(lx);
    addParameter("speed", this.speed);
    addParameter("clear", this.clear);
    addParameter("element", this.element_selector);
}
  
  public void run(double deltaMs) {
    long currentMillis = java.lang.System.currentTimeMillis();
    if(currentMillis - lastMillis > (1000 - this.speed.getValue()) ) {
      if(this.clear.isOn()) {
        // clear all
        setColors(#000000);
      }
      
      int currentIndex = lastIndex;
      //println(mofix.elements.size());
      JSONElement.Fixture element_fixture = (JSONElement.Fixture)model_fixture.elements.get((int)this.element_selector.getValue()).fixtures.get(0);
      //println(elfix.strips.size());
      if(currentIndex >= element_fixture.strips.size()) {
        currentIndex = 0;
      }

      setColor(element_fixture.strips.get(currentIndex), #0000ff);
      
      
      lastMillis = currentMillis;
      lastIndex = currentIndex + 1;
    }
  }
}

public class TestAxis extends LXPattern {
 
  public final CompoundParameter xPos = new CompoundParameter("X", 0);
  public final CompoundParameter yPos = new CompoundParameter("Y", 0);
  public final CompoundParameter zPos = new CompoundParameter("Z", 0);

  public TestAxis(LX lx) {
    super(lx);
    addParameter("xPos", xPos);
    addParameter("yPos", yPos);
    addParameter("zPos", zPos);
  }

  public void run(double deltaMs) {
    float x = this.xPos.getValuef();
    float y = this.yPos.getValuef();
    float z = this.zPos.getValuef();
    for (LXPoint p : model.points) {
      //print("x:"+x+", y:"+y+", z:"+z);
      //float d = abs(p.xn - x);
      //print(" -> d:"+d);
      //d = min(d, abs(p.yn - y));
      //print(" -> d:"+d);
      //d = min(d, abs(p.zn - z));
      //print(" -> d:"+d);
      float d = abs(p.zn - z);
      //colors[p.index] = palette.getColor(p, max(0, 100 - 1000*d));
      colors[p.index] = palette.getColor(max(0, 100-1000*d));
      //println();
    }
  }
}
