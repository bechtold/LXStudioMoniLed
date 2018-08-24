@LXCategory(LXCategory.TEXTURE)
public class Noise extends OLFPAPattern {
  public String getAuthor(){
    return "Oskar Bechtold";
  }

  public final CompoundParameter scale =
    new CompoundParameter("Scale", 10, 5, 40);
    
  private final LXParameter scaleDamped =
    startModulator(new DampedParameter(this.scale, 5, 10)); 
  
  public final CompoundParameter floor =
    new CompoundParameter("Floor", 0, -2, 2)
    .setDescription("Lower bound of the noise");
    
  private final LXParameter floorDamped =
    startModulator(new DampedParameter(this.floor, .5, 2));    
  
  public final CompoundParameter range =
    new CompoundParameter("Range", 1, .2, 4)
    .setDescription("Range of the noise");
  
  private final LXParameter rangeDamped =
    startModulator(new DampedParameter(this.range, .5, 4));
  
  public final CompoundParameter xSpeed = (CompoundParameter)
    new CompoundParameter("XSpd", 0, -6, 6)
    .setDescription("Rate of motion on the X-axis")
    .setPolarity(LXParameter.Polarity.BIPOLAR);
  
  public final CompoundParameter ySpeed = (CompoundParameter)
    new CompoundParameter("YSpd", 0, -6, 6)
    .setDescription("Rate of motion on the Y-axis")
    .setPolarity(LXParameter.Polarity.BIPOLAR);
  
  public final CompoundParameter zSpeed = (CompoundParameter)
    new CompoundParameter("ZSpd", 1, -6, 6)
    .setDescription("Rate of motion on the Z-axis")
    .setPolarity(LXParameter.Polarity.BIPOLAR);
  
  public final CompoundParameter xOffset = (CompoundParameter)
    new CompoundParameter("XOffs", 0, -1, 1)
    .setDescription("Offset of symmetry on the X-axis")
    .setPolarity(LXParameter.Polarity.BIPOLAR);
  
  public final CompoundParameter yOffset = (CompoundParameter)
    new CompoundParameter("YOffs", 0, -1, 1)
    .setDescription("Offset of symmetry on the Y-axis")
    .setPolarity(LXParameter.Polarity.BIPOLAR);
  
  public final CompoundParameter zOffset = (CompoundParameter)
    new CompoundParameter("ZOffs", 0, -1, 1)
    .setDescription("Offset of symmetry on the Z-axis")
    .setPolarity(LXParameter.Polarity.BIPOLAR);
  
  public Noise(LX lx) {
    super(lx);
    addParameter("scale", this.scale);
    addParameter("floor", this.floor);
    addParameter("range", this.range);
    addParameter("xSpeed", this.xSpeed);
    addParameter("ySpeed", this.ySpeed);
    addParameter("zSpeed", this.zSpeed);
    addParameter("xOffset", this.xOffset);
    addParameter("yOffset", this.yOffset);
    addParameter("zOffset", this.zOffset);
  }
  
  private class Accum {
    private float accum = 0;
    private int equalCount = 0;
    
    void accum(double deltaMs, float speed) {
      if (speed != 0) {
        float newAccum = (float) (this.accum + deltaMs * speed * 0.00025);
        if (newAccum == this.accum) {
          if (++this.equalCount >= 5) {
            this.equalCount = 0;
            newAccum = 0;
          }
        }
        this.accum = newAccum;
      }
    }
  };
  
  private final Accum xAccum = new Accum();
  private final Accum yAccum = new Accum();
  private final Accum zAccum = new Accum();
    
  @Override
  public void run(double deltaMs) {
    xAccum.accum(deltaMs, xSpeed.getValuef());
    yAccum.accum(deltaMs, ySpeed.getValuef());
    zAccum.accum(deltaMs, zSpeed.getValuef());
    
    float sf = scaleDamped.getValuef() / 1000.;
    float rf = rangeDamped.getValuef();
    float ff = floorDamped.getValuef();
    float xo = xOffset.getValuef();
    float yo = yOffset.getValuef();
    float zo = zOffset.getValuef();
    for (LXPoint p :  model.points) {
      float b = ff + rf * noise(sf*p.x + xo - xAccum.accum, sf*p.y + yo - yAccum.accum, sf*p.z + zo - zAccum.accum);
      colors[p.index] = LXColor.gray(constrain(b*100, 0, 100));
    }
  }
}

@LXCategory(LXCategory.TEXTURE)
public class Sparkle extends OLFPAPattern {
  public String getAuthor(){
    return "Oskar Bechtold";
  }

  public final SinLFO[] sparkles = new SinLFO[60]; 
  private final int[] map = new int[model.size];
  
  public Sparkle(LX lx) {
    super(lx);
    for (int i = 0; i < this.sparkles.length; ++i) {
      this.sparkles[i] = (SinLFO) startModulator(new SinLFO(0, random(50, 120), random(2000, 7000)));
    }
    for (int i = 0; i < model.size; ++i) {
      this.map[i] = (int) constrain(random(0, sparkles.length), 0, sparkles.length-1);
    }
  }
  
  public void run(double deltaMs) {
    for (LXPoint p : model.points) {
      colors[p.index] = LXColor.gray(constrain(this.sparkles[this.map[p.index]].getValuef(), 0, 100));
    }
  }
}

@LXCategory(LXCategory.TEXTURE)
public class Starlight extends OLFPAPattern {
  public String getAuthor(){
    return "Oskar Bechtold";
  }
  
  public final CompoundParameter speed = new CompoundParameter("Speed", 1, 2, .5);
  public final CompoundParameter base = new CompoundParameter("Base", -10, -20, 100);
  
  public final LXModulator[] brt = new LXModulator[50];
  private final int[] map1 = new int[model.size];
  private final int[] map2 = new int[model.size];
  
  public Starlight(LX lx) {
    super(lx);
    for (int i = 0; i < this.brt.length; ++i) {
      this.brt[i] = startModulator(new SinLFO(this.base, random(50, 120), new FunctionalParameter() {
        private final float rand = random(1000, 5000);
        public double getValue() {
          return rand * speed.getValuef();
        }
      }).randomBasis());
    }
    for (int i = 0; i < model.size; ++i) {
      this.map1[i] = (int) constrain(random(0, this.brt.length), 0, this.brt.length-1);
      this.map2[i] = (int) constrain(random(0, this.brt.length), 0, this.brt.length-1);
    }
    addParameter("speed", this.speed);
    addParameter("base", this.base);
  }
  
  public void run(double deltaMs) {
    for (LXPoint p : model.points) {
      int i = p.index;
      float brt = this.brt[this.map1[i]].getValuef() + this.brt[this.map2[i]].getValuef(); 
      colors[i] = LXColor.gray(constrain(.5*brt, 0, 100));
    }
  }
}

@LXCategory(LXCategory.TEXTURE)
public class Jitters extends OLFPAPattern {
  public String getAuthor(){
    return "Oskar Bechtold";
  }
  
  public final CompoundParameter period = (CompoundParameter)
    new CompoundParameter("Period", 200, 2000, 50)
    .setExponent(.5)
    .setDescription("Speed of the motion");
    
  public final CompoundParameter size =
    new CompoundParameter("Size", 8, 3, 20)
    .setDescription("Size of the movers");
    
  public final CompoundParameter contrast =
    new CompoundParameter("Contrast", 100, 50, 300)
    .setDescription("Amount of contrast");    
  
  final LXModulator pos = startModulator(new SawLFO(0, 1, period));
  
  final LXModulator sizeDamped = startModulator(new DampedParameter(size, 30));
  
  public Jitters(LX lx) {
    super(lx);
    addParameter("period", this.period);
    addParameter("size", this.size);
    addParameter("contrast", this.contrast);
  }
  
  public void run(double deltaMs) {
    float size = this.sizeDamped.getValuef();
    float pos = this.pos.getValuef();
    float sizeInv = 1 / size;
    float contrast = this.contrast.getValuef();
    boolean inv = false;

    // todo implement element_selector
    JSONModel.Fixture model_fixture = (JSONModel.Fixture)model.fixtures.get(0);
    List<MoniLed.JSONElement> elements = model_fixture.elements;

    for (int i = 0; i < elements.size(); i++) {
      println(i);
      JSONElement.Fixture element_fixture = (JSONElement.Fixture)elements.get(i).fixtures.get(0);
      for (JSONStrip strip : element_fixture.strips) {
        inv = !inv;
        float pv = inv ? pos : (1-pos);
        int j = 0;
        for (LXPoint p : strip.points) {
          float pd = (j % size) * sizeInv;
          colors[p.index] = LXColor.gray(max(0, 100 - contrast * LXUtils.wrapdistf(pd, pv, 1)));
          ++j;
        }
      }
    }
  }
}
