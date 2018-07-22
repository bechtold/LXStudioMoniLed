public static abstract class OLFPAPattern extends LXPattern {
  
  protected final JSONModel model;
  
  public OLFPAPattern(LX lx) {
    super(lx);
    this.model = (JSONModel) lx.model;
  }
  
  public abstract String getAuthor();
}

public static abstract class ElementPattern extends OLFPAPattern {
  JSONModel.Fixture model_fixture = (JSONModel.Fixture)model.fixtures.get(0);

  public final CompoundParameter element_selector =
    new CompoundParameter("Element", 0, 0, model_fixture.elements.size() - 1)
    .setDescription("Select the affected Element");
    
  public final BooleanParameter select_by_element = 
    new BooleanParameter("By Element", false)
    .setDescription("Should only LEDs in specific Element be selected?");
    
    public ElementPattern(LX lx) {
      super(lx);
      addParameter("select_by_element", this.select_by_element);
      addParameter("element", this.element_selector);
    }

    public JSONElement getElement() {
      println((int)this.element_selector.getValue());
      JSONElement element = (JSONElement)model_fixture.elements.get((int)this.element_selector.getValue());
      return element;
    }

    public JSONElement.Fixture getElementFixture() {
      JSONElement.Fixture element_fixture = (JSONElement.Fixture)getElement().fixtures.get(0);
      return element_fixture;
    }
    
    public List<JSONStrip> getElementStrips(){
      return getElementFixture().strips;
    }
    
    public List<LXPoint> getElementPoints() {
      println("test");
      List<LXPoint> points = new ArrayList<LXPoint>();
      for (JSONStrip strip: getElementStrips()) {
        for (LXPoint p : strip.points) {
          points.add(p);
        }
      }
      return points;
    }
    
    
    public boolean selectByElement() {
      return this.select_by_element.isOn();
    }
    
    public double elementValue(){
      return this.element_selector.getValue();
    }
    
    public int elementIndexMin() {
      return getElementPoints().get(0).index;
    }
    
    public int elementIndexMax() {
      return getElementPoints().get(getElementPoints().size()-1).index;
    }
    
    boolean select_by_changed = this.select_by_element.isOn();
    double selector_changed = this.element_selector.getValue();
    
    /**
     * Returns true if "By Element" or "Element" parameters have changed (and resets them);
     */
    public boolean elementSelectorChanged() {
      boolean ret = (selectByElement() != this.select_by_changed) || selector_changed != elementValue();
      if(ret) {
        this.select_by_changed = selectByElement();
        this.selector_changed = elementValue();
      }
      return ret;
    }

}

//@LXCategory("Oz")
//public class PatternSolid extends OLFPAPattern {
//  public String getAuthor(){
//    return "Oskar Bechtold";
//  }
//
//  public final CompoundParameter h = new CompoundParameter("Hue", 0, 360);
//  public final CompoundParameter s = new CompoundParameter("Sat", 0, 100);
//  public final CompoundParameter b = new CompoundParameter("Brt", 100, 100);
//
//  public PatternSolid(LX lx) {
//    super(lx);
//    addParameter("h", this.h);
//    addParameter("s", this.s);
//    addParameter("b", this.b);
//  }
//
//  public void run(double deltaMs) {
//    setColors(LXColor.hsb(this.h.getValue(), this.s.getValue(), this.b.getValue()));
//  }
//}

/**
 * Trying to implement the iterator class
 **/
@LXCategory("Oz")
public class IteratorSimple extends OLFPAPattern {    
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

  public IteratorSimple(LX lx) {
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
 * Trying to implement the iterator class
 **/
@LXCategory("Oz")
public class IteratorAdvanced extends ElementPattern { 
  public String getAuthor(){
    return "Oskar Bechtold";
  }
  
  long lastMillis = 0;
  int lastIndex = 0;
  
  public final CompoundParameter speed =
    new CompoundParameter("Speed", 10, 1, 1000)
    .setDescription("Speed of motion");

  public final BooleanParameter clear =
    new BooleanParameter("Clear", false)
    .setDescription("Should LEDs be cleared at all");

  int min = selectByElement() ? elementIndexMin() : 0;
  int max = selectByElement() ? elementIndexMax() : lx.total;
      
  private LXModulator index = startModulator(new SawLFO(min, max, new FunctionalParameter() {
    @Override
    public double getValue() {
      return (1000 / speed.getValue()) * max;
    }
  }));

  public IteratorAdvanced(LX lx) {
    super(lx);
    addParameter("clear", this.clear);
    addParameter("speed", this.speed);
  }
  
  public void run (double deltaMs) {
    if(this.clear.isOn()){
      setColors(#000000);
    }
    
    if(this.select_by_element.isOn() && this.elementSelectorChanged()) {
      min = elementIndexMin();
      max = elementIndexMax();

      index = startModulator(new SawLFO(min, max, new FunctionalParameter() {
        @Override
        public double getValue() {
          return (1000 / speed.getValue()) * (max-min);
        }
      }));
      
    } else if( this.elementSelectorChanged()) {
      min = 0;
      max = lx.total;

      index = startModulator(new SawLFO(min, max, new FunctionalParameter() {
        @Override
        public double getValue() {
          return (1000 / speed.getValue()) * (max-min);
        }
      })); 

    }

    this.colors[(int)this.index.getValue()] = 0xFFFFFFFF;
      
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
public class OzRandom extends ElementPattern {
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
        int min = selectByElement() ? elementIndexMin() : 0;
        int max = selectByElement() ? elementIndexMax() : model.points.length;

        int index = java.util.concurrent.ThreadLocalRandom.current().nextInt(min, max);
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
 
public static abstract class RotationPattern extends ElementPattern {
  
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
    
    JSONElement.Fixture element_fixture = (JSONElement.Fixture)model_fixture.elements.get((int)this.element_selector.getValue()).fixtures.get(0);

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

@LXCategory("Form")
public static class Helix2 extends RotationPattern {
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
  
  public Helix2(LX lx) {
    super(lx);
    addParameter("size", this.size);
    addParameter("coil", this.coil);
    
    removeParameter("select_by_element");
    removeParameter("element");
    
    startModulator(dampedCoil);
    setColors(0);
  }
  
  public void run(double deltaMs) {
    float phaseV = this.phase.getValuef();
    float sizeV = 5*this.size.getValuef();
    float falloff = 100 / sizeV;
    float coil = this.dampedCoil.getValuef();
    
    JSONElement.Fixture element_fixture1 = (JSONElement.Fixture)model_fixture.elements.get(1).fixtures.get(0);
    JSONElement.Fixture element_fixture2 = (JSONElement.Fixture)model_fixture.elements.get(2).fixtures.get(0);
    List<JSONStrip> strips = new ArrayList<JSONStrip>();
    strips.addAll(element_fixture1.strips);
    strips.addAll(element_fixture2.strips);

    for (JSONStrip strip : strips) {
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

@LXCategory("Form")
public static class Warble extends RotationPattern {
    public String getAuthor(){
    return "Oskar Bechtold";
  }
 
  private final CompoundParameter size = (CompoundParameter)
    new CompoundParameter("Size", 2*FEET, 6*INCHES, 12*FEET)
    .setDescription("Size of the warble");
    
  private final CompoundParameter depth = (CompoundParameter)
    new CompoundParameter("Depth", .4, 0, 1)
    .setExponent(2)
    .setDescription("Depth of the modulation");
  
  private final CompoundParameter interp = 
    new CompoundParameter("Interp", 1, 1, 3)
    .setDescription("Interpolation on the warble");
    
  private final DampedParameter interpDamped = new DampedParameter(interp, .5, .5);
  private final DampedParameter depthDamped = new DampedParameter(depth, .4, .4);
    
  public Warble(LX lx) {
    super(lx);
    startModulator(this.interpDamped);
    startModulator(this.depthDamped);
    addParameter("size", this.size);
    addParameter("interp", this.interp);
    addParameter("depth", this.depth);
    removeParameter("select_by_element");
    removeParameter("element");
    
    setColors(0);
  }
  
  public void run(double deltaMs) {
    float phaseV = this.phase.getValuef();
    float interpV = this.interpDamped.getValuef();
    int mult = floor(interpV);
    float lerp = interpV % mult;
    float falloff = 10 / size.getValuef();
    float depth = this.depthDamped.getValuef();
    
    JSONElement.Fixture element_fixture1 = (JSONElement.Fixture)model_fixture.elements.get(1).fixtures.get(0);
    JSONElement.Fixture element_fixture2 = (JSONElement.Fixture)model_fixture.elements.get(2).fixtures.get(0);
    List<JSONStrip> strips = new ArrayList<JSONStrip>();
    strips.addAll(element_fixture1.strips);
    strips.addAll(element_fixture2.strips);

    int i= 0;
    for (JSONStrip strip : strips) {   
      //float y1 = model.yRange * depth * sin(phaseV + mult * rail.theta);
      //float y2 = model.yRange * depth * sin(phaseV + (mult+1) * rail.theta);
      // replaced theta with i for now

      float y1 = model.yRange * depth * sin(phaseV + mult * i);
      float y2 = model.yRange * depth * sin(phaseV + (mult+1) * i);
      float yo = lerp(y1, y2, lerp);
      for (LXPoint p : strip.points) {
        colors[p.index] = LXColor.gray(max(0, 100 - falloff*abs(p.y - model.cy - yo)));
      }
      i++;
    }
  }
}

@LXCategory("Form")
public class Bouncing extends OLFPAPattern {
  public String getAuthor(){
    return "Oskar Bechtold";
  }
  
  JSONModel.Fixture model_fixture = (JSONModel.Fixture)model.fixtures.get(0);

  public final CompoundParameter element_selector =
    new CompoundParameter("Element", 0, 0, model_fixture.elements.size() - 1)
    .setDescription("Select the affected Element");

  public CompoundParameter gravity = (CompoundParameter)
    new CompoundParameter("Gravity", -200, -10, -400)
    .setExponent(2)
    .setDescription("Gravity factor");
  
  public CompoundParameter size =
    new CompoundParameter("Length", 2*FEET, 1*FEET, 8*FEET)
    .setDescription("Length of the bouncers");
  
  public CompoundParameter amp =
    new CompoundParameter("Height", model.yRange, 1*FEET, model.yRange)
    .setDescription("Height of the bounce");
  
  public Bouncing(LX lx) {
    super(lx);
    addParameter("element", this.element_selector);
    addParameter("gravity", this.gravity);
    addParameter("size", this.size);
    addParameter("amp", this.amp);

    JSONElement.Fixture element_fixture = (JSONElement.Fixture)model_fixture.elements.get((int)this.element_selector.getValue()).fixtures.get(0);

    for (JSONStrip strip : element_fixture.strips) {
      addLayer(new Bouncer(lx, strip, element_selector));
    }
  }
  
  class Bouncer extends LXLayer {
    
    private final JSONStrip strip;
    private final Accelerator position;
    CompoundParameter element_selector;
    
    Bouncer(LX lx, JSONStrip strip, CompoundParameter element_selector) {
      super(lx);
      this.strip = strip;
      this.position = new Accelerator(strip.yMax, 0, gravity);
      this.element_selector = element_selector;
      startModulator(position);
    }
    
    public void run(double deltaMs) {
      if (position.getValue() < 0) {
        position.setValue(-position.getValue());
        position.setVelocity(sqrt(abs(2 * (amp.getValuef() - random(0, 2*FEET)) * gravity.getValuef()))); 
      }
      float h = palette.getHuef();
      float falloff = 100. / size.getValuef();

      JSONElement.Fixture element_fixture = (JSONElement.Fixture)model_fixture.elements.get((int)this.element_selector.getValue()).fixtures.get(0);
      for (JSONStrip strip : element_fixture.strips) {
        for (LXPoint p : strip.points) {
          float b = 100 - falloff * abs(p.y - position.getValuef());
          if (b > 0) {
            addColor(p.index, LXColor.gray(b));
          }
        }
      }
    }
  }
    
  public void run(double deltaMs) {
    setColors(LXColor.BLACK);
  }
}

@LXCategory("Form")
public class Tron extends OLFPAPattern {
  public String getAuthor(){
    return "Oskar Bechtold";
  }
  
  private final static int MIN_DENSITY = 5;
  private final static int MAX_DENSITY = 80;
  
  private CompoundParameter period = (CompoundParameter)
    new CompoundParameter("Speed", 150000, 400000, 50000)
    .setExponent(.5)
    .setDescription("Speed of movement");
    
  private CompoundParameter size = (CompoundParameter)
    new CompoundParameter("Size", 2*FEET, 6*INCHES, 5*FEET)
    .setExponent(2)
    .setDescription("Size of strips");
    
  private CompoundParameter density = (CompoundParameter)
    new CompoundParameter("Density", 25, MIN_DENSITY, MAX_DENSITY)
    .setDescription("Density of tron strips");
    
  public Tron(LX lx) {  
    super(lx);
    addParameter("period", this.period);
    addParameter("size", this.size);
    addParameter("density", this.density);    
    for (int i = 0; i < MAX_DENSITY; ++i) {
      addLayer(new Mover(lx, i));
    }
  }
  
  class Mover extends LXLayer {
    
    final int index;
    
    final TriangleLFO pos = new TriangleLFO(0, lx.total, period);
    
    private final MutableParameter targetBrightness = new MutableParameter(100); 
    
    private final DampedParameter brightness = new DampedParameter(this.targetBrightness, 50); 
    
    Mover(LX lx, int index) {
      super(lx);
      this.index = index;
      startModulator(this.brightness);
      startModulator(this.pos.randomBasis());
    }
    
    public void run(double deltaMs) {
      this.targetBrightness.setValue((density.getValuef() > this.index) ? 100 : 0);
      float maxb = this.brightness.getValuef();
      if (maxb > 0) {
        float pos = this.pos.getValuef();
        float falloff = maxb / size.getValuef();
        for (LXPoint p : model.points) {
          float b = maxb - falloff * LXUtils.wrapdistf(p.index, pos, model.points.length);
          if (b > 0) {
            addColor(p.index, LXColor.gray(b));
          }
        }
      }
    }
  }
  
  public void run(double deltaMs) {
    setColors(#000000);
  }
}

@LXCategory("Form")
public static class Rings extends OLFPAPattern {
    public String getAuthor(){
    return "Oskar Bechtold";
  }

  public final CompoundParameter amplitude =
    new CompoundParameter("Amplitude", 1);
    
  public final CompoundParameter speed = (CompoundParameter)
    new CompoundParameter("Speed", 10000, 20000, 1000)
    .setExponent(.25);
  
  public Rings(LX lx) {
    super(lx);
    for (int i = 0; i < 2; ++i) {
      addLayer(new Ring(lx));
    }
    addParameter("amplitude", this.amplitude);
    addParameter("speed", this.speed);
  }
  
  public void run(double deltaMs) {
    setColors(#000000);
  }
  
  class Ring extends LXLayer {
    
    private LXProjection proj = new LXProjection(model);
    private final SawLFO yRot = new SawLFO(0, TWO_PI, 9000 + 2000 * Math.random());
    private final SinLFO zRot = new SinLFO(-1, 1, speed);
    private final SinLFO zAmp = new SinLFO(PI / 10, PI/4, 13000 + 3000 * Math.random());
    private final SinLFO yOffset = new SinLFO(-2*FEET, 2*FEET, 12000 + 5000*Math.random());
    
    public Ring(LX lx) {
      super(lx);
      startModulator(yRot.randomBasis());
      startModulator(zRot.randomBasis());
      startModulator(zAmp.randomBasis());
      startModulator(yOffset.randomBasis());
    }
    
    public void run(double deltaMs) {
      proj.reset().center().rotateY(yRot.getValuef()).rotateZ(amplitude.getValuef() * zAmp.getValuef() * zRot.getValuef());
      float yOffset = this.yOffset.getValuef();
      float falloff = 100 / (2*FEET);
      for (LXVector v : proj) {
        float b = 100 - falloff * abs(v.y - yOffset);  
        if (b > 0) {
          addColor(v.index, LXColor.gray(b));
        }
      }
    }
  }
}

public class Bugs extends OLFPAPattern {
  public String getAuthor(){
    return "Oskar Bechtold";
  }

  public final CompoundParameter speed = (CompoundParameter)
    new CompoundParameter("Speed", 10, 20, 1)
    .setDescription("Speed of the bugs");
  
  public final CompoundParameter size =
    new CompoundParameter("Size", .1, .02, .4)
    .setDescription("Size of the bugs");
  
  public Bugs(LX lx) {
    super(lx);
    // todo implement element_selector
    JSONModel.Fixture model_fixture = (JSONModel.Fixture)model.fixtures.get(0);
    JSONElement.Fixture element_fixture1 = (JSONElement.Fixture)model_fixture.elements.get(1).fixtures.get(0);
    JSONElement.Fixture element_fixture2 = (JSONElement.Fixture)model_fixture.elements.get(2).fixtures.get(0);
    List<JSONStrip> strips = new ArrayList<JSONStrip>();
    strips.addAll(element_fixture1.strips);
    strips.addAll(element_fixture2.strips);

    for (JSONStrip strip : strips) {
      for (int i = 0; i < 10; ++i) {
        addLayer(new Layer(lx, strip));
      }
    }
    addParameter("speed", this.speed);
    addParameter("size", this.size);
  }
  
  class RandomSpeed extends FunctionalParameter {
    
    private final float rand;
    
    RandomSpeed(float low, float hi) {
      this.rand = random(low, hi);
    }
    
    public double getValue() {
      return this.rand * speed.getValue();
    }
  }
  
  class Layer extends LXLayer {
    
    private final JSONStrip strip;
    private final LXModulator pos = startModulator(new SinLFO(
      startModulator(new SinLFO(0, .5, new RandomSpeed(500, 1000)).randomBasis()),
      startModulator(new SinLFO(.5, 1, new RandomSpeed(500, 1000)).randomBasis()),
      new RandomSpeed(3000, 8000)
    ).randomBasis());
    
    private final LXModulator size = startModulator(new SinLFO(
      startModulator(new SinLFO(.1, .3, new RandomSpeed(500, 1000)).randomBasis()),
      startModulator(new SinLFO(.5, 1, new RandomSpeed(500, 1000)).randomBasis()),
      startModulator(new SinLFO(4000, 14000, random(3000, 18000)).randomBasis())
    ).randomBasis());
    
    Layer(LX lx, JSONStrip strip) {
      super(lx);
      this.strip = strip;
    }
    
    public void run(double deltaMs) {
      float size = Bugs.this.size.getValuef() * this.size.getValuef();
      float falloff = 100 / max(size, (1.5*INCHES / model.yRange));
      float pos = this.pos.getValuef();
      for (LXPoint p : this.strip.points) {
        float b = 100 - falloff * abs(p.yn - pos);
        if (b > 0) {
          addColor(p.index, LXColor.gray(b));
        }
      }
    }
  }
  
  public void run(double deltaMs) {
    setColors(#000000);
  }
}
