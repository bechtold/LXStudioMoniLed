public static abstract class OLFPAPattern extends LXPattern {
  
  protected final JSONModel model;
  
  public OLFPAPattern(LX lx) {
    super(lx);
    this.model = (JSONModel) lx.model;
  }
  
  public abstract String getAuthor();
}

@LXCategory("Oz")
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
@LXCategory("Oz")
public class Ozterator extends OLFPAPattern {    
  public String getAuthor(){
    return "Oskar Bechtold";
  }
  
  long lastMillis = 0;
  int lastIndex = 0;
  
  public final CompoundParameter speed =
    new CompoundParameter("Speed", .5, .1, 1)
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
    
    if(currentMillis - lastMillis > (1000-1000*this.speed.getValue())) {
      
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
@LXCategory("Oz")
public class OzSlider extends OLFPAPattern {
  public String getAuthor(){
    return "Oskar Bechtold";
  }
  
  //public final DiscreteParameter index = new DiscreteParameter("Index", 0, model.points.length); 
  public final CompoundParameter index = new CompoundParameter("Index", 90, model.points.length-1); 
  
  public OzSlider(LX lx) {
    super(lx);
    addParameter("Index", this.index);
  }
  
  public void run (double deltaMs) {
    setColors(#000000);
    //setColor(this.index.getValuei(), #ffffff);
    setColor((int)this.index.getValue(), #ffffff);
  }
}

/**
 * Set random point(s) at a time.
 **/
@LXCategory("Oz")
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
    
    if(currentMillis - lastMillis > (1000-1000*this.speed.getValue())) {
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
 **/
@LXCategory("Oz")
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

/**
 * Animate pixels on an axis
 **/
@LXCategory("Oz")
public class OzAxis extends LXPattern implements CustomDeviceUI {
 
  private final BooleanParameter enableX =
  new BooleanParameter("Enable X axis")
    .setDescription("Whether enable the X axis.");
  private final BooleanParameter enableY =
  new BooleanParameter("Enable Y axis")
    .setDescription("Whether enable the Y axis.");
  private final BooleanParameter enableZ =
  new BooleanParameter("Enable Z axis")
    .setDescription("Whether enable the Z axis.");

  public final CompoundParameter xPos = new CompoundParameter("X", 0);
  public final CompoundParameter yPos = new CompoundParameter("Y", 0);
  public final CompoundParameter zPos = new CompoundParameter("Z", 0);

  public OzAxis(LX lx) {
    super(lx);
    addParameter("enableX", this.enableX);
    addParameter("xPos", xPos);
    addParameter("enableY", this.enableY);
    addParameter("yPos", yPos);
    addParameter("enableZ", this.enableZ);
    addParameter("zPos", zPos);
  }

  @Override
  public void buildDeviceUI(UI ui, UI2dContainer device) {
    device.setContentWidth(70);
    
    final UIButton enableXButton = (UIButton)
      new UIButton(0, 0, 30, 30)
      .setParameter(this.enableX)
      .setLabel("X")
      //.setEnabled(this.midi.isOn())
      .addToContainer(device);     
    final UIKnob xPosKnob = (UIKnob) new UIKnob(30, 0)
      .setParameter(this.xPos)
      .setEnabled(this.enableX.isOn())
      .addToContainer(device);
    this.enableX.addListener(new LXParameterListener() {
      public void onParameterChanged(LXParameter p) {
        xPosKnob.setEnabled(enableX.isOn());
      }
    });
    
    final UIButton enableYButton = (UIButton)
      new UIButton(0, 50, 30, 30)
      .setParameter(this.enableY)
      .setLabel("Y")
      //.setEnabled(this.midi.isOn())
      .addToContainer(device);     
    final UIKnob yPosKnob = (UIKnob) new UIKnob(30, 50)
      .setParameter(this.yPos)
      .setEnabled(this.enableY.isOn())
      .addToContainer(device);
    this.enableY.addListener(new LXParameterListener() {
      public void onParameterChanged(LXParameter p) {
        yPosKnob.setEnabled(enableY.isOn());
      }
    });

    final UIButton enableZButton = (UIButton)
      new UIButton(0, 100, 30, 30)
      .setParameter(this.enableZ)
      .setLabel("Z")
      //.setEnabled(this.midi.isOn())
      .addToContainer(device);     
    final UIKnob zPosKnob = (UIKnob) new UIKnob(30, 100)
      .setParameter(this.zPos)
      .setEnabled(this.enableZ.isOn())
      .addToContainer(device);
    this.enableZ.addListener(new LXParameterListener() {
      public void onParameterChanged(LXParameter p) {
        zPosKnob.setEnabled(enableZ.isOn());
      }
    });

  }
  
  public void run(double deltaMs) {
    float x = this.xPos.getValuef();
    float y = this.yPos.getValuef();
    float z = this.zPos.getValuef();
    for (LXPoint p : model.points) {
      //print("x:"+x+", y:"+y+", z:"+z);
      float d = 1;
      if(enableX.isOn()) {
        d = abs(p.xn - x);
      }
      //print(" -> d:"+d);
      if(enableY.isOn()){
        d = min(d, abs(p.yn - y));
      }
      //print(" -> d:"+d);
      if(enableZ.isOn()){
        d = min(d, abs(p.zn - z));
      }
      //print(" -> d:"+d);
      //d = abs(p.zn - z);
      //colors[p.index] = palette.getColor(p, max(0, 100 - 1000*d));
      colors[p.index] = palette.getColor(max(0, 100-1000*d));
      //println("");
    }
  }
}

@LXCategory("Oz")
public class OzHeadless extends LXPattern {

   private final LXModulator hue = startModulator(new SawLFO(0, 360, 9000));
   private final LXModulator brightness = startModulator(new SinLFO(10, 100, 4000));
   private final LXModulator yPos = startModulator(new SinLFO(0, 1, 5000));
   private final LXModulator width = startModulator(new SinLFO(.4, 1, 3000));

   public OzHeadless(LX lx) {
     super(lx);
   }

   @Override
   public void run(double deltaMs) {
     float hue = this.hue.getValuef();
     float brightness = this.brightness.getValuef();
     float yPos = this.yPos.getValuef();
     float falloff = 100 / (this.width.getValuef());
     for (LXPoint p : model.points) {
       colors[p.index] = LX.hsb(hue, 100, Math.max(0, brightness - falloff * Math.abs(p.yn - yPos)));
     }
   }
 }
 
public static abstract class RotationPattern extends OLFPAPattern {
  
  protected final CompoundParameter rate = (CompoundParameter)
  new CompoundParameter("Rate", .25, .01, 2)
    .setExponent(2)
    .setUnits(LXParameter.Units.HERTZ)
    .setDescription("Rate of the rotation");
    
  protected final SawLFO phase = new SawLFO(0, TWO_PI, new FunctionalParameter() {
    public double getValue() {
      return 1000 / rate.getValue();
    }
  });
  
  protected RotationPattern(LX lx) {
    super(lx);
    startModulator(this.phase);
    addParameter("rate", this.rate);
  }
}

@LXCategory("Form")
public static class Helix extends RotationPattern {
  public String getAuthor(){
    return "Oskar Bechtold";
  }
    
  private final CompoundParameter size = (CompoundParameter)
    new CompoundParameter("Size", 2*FEET, 6*INCHES, 8*FEET)
    .setDescription("Size of the corkskrew");
    
  private final CompoundParameter coil = (CompoundParameter)
    new CompoundParameter("Coil", 1, .25, 2.5)
    .setExponent(.5)
    .setDescription("Coil amount");
    
  private final DampedParameter dampedCoil = new DampedParameter(coil, .2);
  
  public Helix(LX lx) {
    super(lx);
    addParameter("size", this.size);
    addParameter("coil", this.coil);
    startModulator(dampedCoil);
    setColors(0);
  }
  
  public void run(double deltaMs) {
    float phaseV = this.phase.getValuef();
    float sizeV = this.size.getValuef();
    float falloff = 100 / sizeV;
    float coil = this.dampedCoil.getValuef();
    
    JSONModel.Fixture model_fixture = (JSONModel.Fixture)model.fixtures.get(0);
    JSONElement.Fixture element_fixture = (JSONElement.Fixture)model_fixture.elements.get(1).fixtures.get(0);

    for (JSONStrip strip : element_fixture.strips) {
      float yp = -sizeV + ((phaseV + (TWO_PI + PI + coil * 0)) % TWO_PI) / TWO_PI * (model.yRange + 2*sizeV);
      float yp2 = -sizeV + ((phaseV + TWO_PI + coil * 0) % TWO_PI) / TWO_PI * (model.yRange + 2*sizeV);
      for (LXPoint p : strip.points) {
        float d1 = 100 - falloff*abs(p.y - yp);
        float d2 = 100 - falloff*abs(p.y - yp2);
        float b = max(d1, d2);
        colors[p.index] = b > 0 ? LXColor.gray(b) : #000000;
      }
    }
  }
}
