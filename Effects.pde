import java.awt.Color;

public abstract class JSONEffect extends LXEffect {
  
  JSONModel model = (JSONModel) lx.model;
  
  public JSONEffect(LX lx) {
    super(lx);
  }

}


@LXCategory("Texture")
public class Sizzle extends LXEffect {
  
  public final CompoundParameter amount = new CompoundParameter("Amount", .5)
    .setDescription("Intensity of the effect");
    
  public final CompoundParameter speed = new CompoundParameter("Speed", .5)
    .setDescription("Speed of the effect");
  
  private final int[] buffer = new ModelBuffer(lx).getArray();
  
  private float base = 0;
  
  public Sizzle(LX lx) {
    super(lx);
    addParameter("amount", this.amount);
    addParameter("speed", this.speed);
  }
  
  public void run(double deltaMs, double amount) {
      double amt = amount * this.amount.getValue();
    if (amt > 0) {
      base += deltaMs * .01 * speed.getValuef();
      for (int i = 0; i < this.buffer.length; ++i) {
        int val = (int) min(0xff, 500 * noise(i, base));
        this.buffer[i] = 0xff000000 | val | (val << 8) | (val << 16);
      }
      MultiplyBlend.multiply(this.colors, this.buffer, amt, this.colors);
    }
  }
}

@LXCategory("Form")
public static class Strobe extends LXEffect {
  
  public enum Waveshape {
    TRI,
    SIN,
    SQUARE,
    UP,
    DOWN
  };
  
  public final EnumParameter<Waveshape> mode = new EnumParameter<Waveshape>("Shape", Waveshape.TRI);
  
  public final CompoundParameter frequency = (CompoundParameter)
    new CompoundParameter("Freq", 1, .05, 10).setUnits(LXParameter.Units.HERTZ);  
  
  public final CompoundParameter depth = (CompoundParameter)
    new CompoundParameter("Depth", 0.5)
    .setDescription("Depth of the strobe effect");
    
  private final SawLFO basis = new SawLFO(1, 0, new FunctionalParameter() {
    public double getValue() {
      return 1000 / frequency.getValue();
  }});
        
  public Strobe(LX lx) {
    super(lx);
    addParameter("mode", this.mode);
    addParameter("frequency", this.frequency);
    addParameter("depth", this.depth);
    startModulator(basis);
  }
  
  @Override
  protected void onEnable() {
    basis.setBasis(0).start();
  }
  
  private LXWaveshape getWaveshape() {
    switch (this.mode.getEnum()) {
    case SIN: return LXWaveshape.SIN;
    case TRI: return LXWaveshape.TRI;
    case UP: return LXWaveshape.UP;
    case DOWN: return LXWaveshape.DOWN;
    case SQUARE: return LXWaveshape.SQUARE;
    }
    return LXWaveshape.SIN;
  }
  
  private final float[] hsb = new float[3];
  
  @Override
  public void run(double deltaMs, double amount) {
    float amt = this.enabledDamped.getValuef() * this.depth.getValuef();
    if (amt > 0) {
      float strobef = basis.getValuef();
      strobef = (float) getWaveshape().compute(strobef);
      strobef = lerp(1, strobef, amt);
      if (strobef < 1) {
        if (strobef == 0) {
          for (int i = 0; i < colors.length; ++i) {
            colors[i] = LXColor.BLACK;
          }
        } else {
          for (int i = 0; i < colors.length; ++i) {
            LXColor.RGBtoHSB(colors[i], hsb);
            hsb[2] *= strobef;
            colors[i] = Color.HSBtoRGB(hsb[0], hsb[1], hsb[2]);
          }
        }
      }
    }
  }
}

@LXCategory("Color")
public class LSD extends LXEffect {
  
  public final BoundedParameter scale = new BoundedParameter("Scale", 10, 5, 40);
  public final BoundedParameter speed = new BoundedParameter("Speed", 4, 1, 6);
  public final BoundedParameter range = new BoundedParameter("Range", 1, .7, 2);
  
  public LSD(LX lx) {
    super(lx);
    addParameter(scale);
    addParameter(speed);
    addParameter(range);
    this.enabledDampingAttack.setValue(500);
    this.enabledDampingRelease.setValue(500);
  }
  
  final float[] hsb = new float[3];

  private float accum = 0;
  private int equalCount = 0;
  private float sign = 1;
  
  @Override
  public void run(double deltaMs, double amount) {
    float newAccum = (float) (accum + sign * deltaMs * speed.getValuef() / 4000.);
    if (newAccum == accum) {
      if (++equalCount >= 5) {
        equalCount = 0;
        sign = -sign;
        newAccum = accum + sign*.01;
      }
    }
    accum = newAccum;
    float sf = scale.getValuef() / 1000.;
    float rf = range.getValuef();
    for (LXPoint p :  model.points) {
      LXColor.RGBtoHSB(colors[p.index], hsb);
      float h = rf * noise(sf*p.x, sf*p.y, sf*p.z + accum);
      int c2 = LX.hsb(h * 360, 100, hsb[2]*100);
      if (amount < 1) {
        colors[p.index] = LXColor.lerp(colors[p.index], c2, amount);
      } else {
        colors[p.index] = c2;
      }
    }
  }
}

@LXCategory("Color")
public class SolidColor extends LXEffect {
  public String getAuthor(){
    return "Oskar Bechtold";
  }

  public final CompoundParameter h = new CompoundParameter("Hue", 0, 360);
  public final CompoundParameter s = new CompoundParameter("Sat", 0, 100);
  public final CompoundParameter b = new CompoundParameter("Brt", 100, 100);

  public SolidColor(LX lx) {
    super(lx);
    addParameter("h", this.h);
    addParameter("s", this.s);
    addParameter("b", this.b);
  }

  final float[] hsb = new float[3];

  @Override
  public void run(double deltaMs, double amount) {
    for (LXPoint p :  model.points) {
      
      LXColor.RGBtoHSB(colors[p.index], hsb);
      int c2 = LX.hsb((float)this.h.getValue(), (float)this.s.getValue(), (float)(hsb[2]*this.b.getValue()));

      if (amount < 1) {
        colors[p.index] = LXColor.lerp(colors[p.index], c2, amount);
      } else {
        colors[p.index] = c2;
      }
    //colors[p.index] = LXColor.hsb(this.h.getValue(), this.s.getValue(), this.b.getValue());
    //setColors(LXColor.hsb(this.h.getValue(), this.s.getValue(), this.b.getValue()));
    }
  }
}

@LXCategory("Filter")
public class FilterElement extends JSONEffect {
  JSONModel.Fixture model_fixture = model.getFixture();

  public final CompoundParameter element_selector =
    new CompoundParameter("Element", 0, 0, model_fixture.elements.size() - 1)
    .setDescription("Select the affected Element");
    
  public final BooleanParameter invert = 
    new BooleanParameter("invert", false)
    .setDescription("Invert element selection");
    
    public FilterElement(LX lx) {
      super(lx);
      addParameter("invert", this.invert);
      addParameter("element", this.element_selector);
    }

  
  // move to model
  public List<JSONElement> getElements() {
    return model_fixture.elements;
  }
  public JSONElement getElement() {
    JSONElement element = (JSONElement)model_fixture.elements.get((int)this.element_selector.getValue());
    return element;
  }

  public List<JSONElement> getElementsNotSelected() {
    List<JSONElement> elements = new ArrayList<JSONElement>();
    
    for(JSONElement element : getElements()) {
      if(element != (JSONElement)model_fixture.elements.get((int)this.element_selector.getValue())) {
        elements.add(element);
      }
    }
    return elements;
  }

  //  public JSONElement.Fixture getElementFixture() {
  //    JSONElement.Fixture element_fixture = (JSONElement.Fixture)getElement().fixtures.get(0);
  //    return element_fixture;
  //  }
    
  //  public List<JSONStrip> getElementStrips(){
  //    return getElementFixture().strips;
  //  }
    
  //  public List<LXPoint> getElementPoints() {
  //    println("test");
  //    List<LXPoint> points = new ArrayList<LXPoint>();
  //    for (JSONStrip strip: getElementStrips()) {
  //      for (LXPoint p : strip.points) {
  //        points.add(p);
  //      }
  //    }
  //    return points;
  //  }
    
    
  //  public boolean selectByElement() {
  //    return this.select_by_element.isOn();
  //  }
    
  //  public double elementValue(){
  //    return this.element_selector.getValue();
  //  }
    
  //  public int elementIndexMin() {
  //    return getElementPoints().get(0).index;
  //  }
    
  //  public int elementIndexMax() {
  //    return getElementPoints().get(getElementPoints().size()-1).index;
  //  }
    
  //  boolean select_by_changed = this.select_by_element.isOn();
  //  double selector_changed = this.element_selector.getValue();
    
  //  /**
  //   * Returns true if "By Element" or "Element" parameters have changed (and resets them);
  //   */
  //  public boolean elementSelectorChanged() {
  //    boolean ret = (selectByElement() != this.select_by_changed) || selector_changed != elementValue();
  //    if(ret) {
  //      this.select_by_changed = selectByElement();
  //      this.selector_changed = elementValue();
  //    }
  //    return ret;
  //  }

  @Override
  public void run(double deltaMs, double amount) {
    if(this.invert.isOn()) {
      for (JSONElement element : getElementsNotSelected()) {
        setColor(element, #000000);
      }
    } else {
      setColor(getElement(), #000000);
    }

  }
}

@LXCategory("Filter")
public class FilterGroups extends JSONEffect {
  JSONModel.Fixture model_fixture = model.getFixture();

  public final CompoundParameter group_selector =
    new CompoundParameter("Group", 0, 0, model_fixture.groups.size() - 1)
    .setDescription("Select the affected group");
    
  public final BooleanParameter invert = 
    new BooleanParameter("invert", false)
    .setDescription("Invert group selection");
    
    public FilterGroups(LX lx) {
      super(lx);
      addParameter("invert", this.invert);
      addParameter("group", this.group_selector);
    }

  
  // move to model
  public LinkedHashMap<String, List<JSONElement>> getGroups() {
    //println(model_fixture.groups.size());
    return model_fixture.groups;
  }

  public List<JSONElement> getElementsInSelectedGroup() {
    List<JSONElement> elements = new ArrayList<JSONElement>();

    int selected_index = (int)this.group_selector.getValue();
    
    int i = 0;
    // since maps are not gettable by index we have to iterate over them to find the elements
    for (Object key : getGroups().keySet()) {
      if(selected_index == i) {
        return getGroups().get(key);
      }
      i++;
    }

    return elements;
  }

  public List<JSONElement> getElementsNotSelected() {
    List<JSONElement> elements = new ArrayList<JSONElement>();
    
    int selected_index = (int)this.group_selector.getValue();
    
    int i = 0;
    // since maps are not gettable by index we have to iterate over them to find the elements
    for (Object key : getGroups().keySet()) {
      if(selected_index != i) {
        elements.addAll(getGroups().get(key));
      }
      i++;
    }

    return elements;
  }

  @Override
  public void run(double deltaMs, double amount) {
    if(this.invert.isOn()) {
      for (JSONElement element : getElementsNotSelected()) {
        setColor(element, #000000);
      }
    } else {
      for(JSONElement element : getElementsInSelectedGroup()) {
        setColor(element, #000000);
      }
    }

  }
}
