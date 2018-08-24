public static class Planes {
  public enum Plane {
    XY,
    ZY,
    XZ,
    YZ,
    YX,
    ZX
  }
}

//@LXCategory(LXCategory.FORM)
@LXCategory("Oz")
public class GraphicEqualizerPattern extends LXPattern {


  public final EnumParameter<Planes.Plane> plane =
    new EnumParameter<Planes.Plane>("Plane", Planes.Plane.XY)
    .setDescription("Which plane the equalizer renders on");

  public final CompoundParameter gain =
    new CompoundParameter("Gain", 1, 0, 3)
    .setDescription("Amount of gain-scaling");

  public final CompoundParameter center =
    new CompoundParameter("Center", 0)
    .setDescription("Center point on the axis");

  public final CompoundParameter fade = (CompoundParameter)
    new CompoundParameter("Fade", 0.1)
    .setExponent(2)
    .setDescription("Amount of fade");

  public final CompoundParameter sharp = (CompoundParameter)
    new CompoundParameter("Sharp", 0.9)
    .setExponent(2)
    .setDescription("Amount of sharpness");

  public GraphicEqualizerPattern(LX lx) {
    super(lx);
    addParameter("gain", this.gain);
    addParameter("center", this.center);
    addParameter("fade", this.fade);
    addParameter("sharp", this.sharp);
    addParameter("plane", this.plane);
  }

  @Override
  public void run(double deltaMs) {
    GraphicMeter eq = lx.engine.audio.meter;
    float center = this.center.getValuef();
    float fade = 100 / this.fade.getValuef();
    float sharp = 100 / (1 - this.sharp.getValuef());
    float gain = this.gain.getValuef();
    Planes.Plane plane = this.plane.getEnum();

    float v1 = 0, v2 = 0;
    for (LXPoint p : model.points) {
      switch (plane) {
      case XY: v1 = p.xn; v2 = p.yn; break;
      case ZY: v1 = p.zn; v2 = p.yn; break;
      case XZ: v1 = p.xn; v2 = p.zn; break;
      case YZ: v1 = p.yn; v2 = p.zn; break;
      case YX: v1 = p.yn; v2 = p.xn; break;
      case ZX: v1 = p.zn; v2 = p.xn; break;
      }
      float level = gain * eq.getBandf((int) (v1 * (eq.numBands - 1)));
      float value = Math.abs(v2 - center);
      if (value > level) {
        colors[p.index] = LXColor.BLACK;
      } else {
        colors[p.index] = LXColor.gray(Math.min(100, Math.min((level-value) * sharp, value * fade)));
      }
    }
  }

}
