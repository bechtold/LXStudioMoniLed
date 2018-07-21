@LXCategory("Texture")
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
