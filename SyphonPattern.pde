public static class Planes {
  public enum plane {
    X_Y,
    Y_Z,
    X_Z
  };
}  

/**
 * Maybe a syphon input pattern.
 */
@LXCategory("Oz")
public class SyphonPattern extends LXPattern {
  
  public final EnumParameter<Planes.plane> plane = new EnumParameter<Planes.plane>("Plane", Planes.plane.X_Z);

  public SyphonPattern(LX lx) {
    super(lx);
    addParameter("plane", this.plane);
  }
  
  public void run(double deltaMs) {
    if( syphonImage != null && syphonImage.pixels != null && syphonNew) {
      int sW = syphonImage.pixelWidth;
      int sH = syphonImage.pixelHeight;
      
      for (LXPoint p : model.points) {
          //calculating pixel array index from x and y positions of points ignoring y for now
          float tmp_x = 0;
          float tmp_y = 0;
          float tmp_xMin = 0;
          float tmp_xMax = 0;
          float tmp_yMin = 0;
          float tmp_yMax = 0;
          int x = 0;
          int y = 0;
          int index = 0;
          
          switch(this.plane.getEnum()) {
            case X_Y: 
              tmp_x = p.x;
              tmp_y = p.y;
              tmp_xMin = model.xMin;
              tmp_xMax = model.xMax;
              tmp_yMin = model.yMin;
              tmp_yMax = model.yMax;
              x = (int)map(tmp_x, tmp_xMin, tmp_xMax, 0, sW-1);
              y = (int)map(tmp_y, tmp_yMin, tmp_yMax, 0, sH-1); // PGrapics starts top left, points might start at bottom left
              index = (int)((sH-y-1)*sW + x);
              break;
            case Y_Z: 
              tmp_x = p.z;
              tmp_y = p.y;
              tmp_xMin = model.zMin;
              tmp_xMax = model.zMax;
              tmp_yMin = model.yMin;
              tmp_yMax = model.yMax;
              x = (int)map(tmp_x, tmp_xMin, tmp_xMax, 0, sW-1);
              y = (int)map(tmp_y, tmp_yMin, tmp_yMax, 0, sH-1); // PGrapics starts top left, points might start at bottom left
              index = (int)((sH-y-1)*sW + x);
              break;
            case X_Z:
              tmp_x = p.x;
              tmp_y = p.z;
              tmp_xMin = model.xMin;
              tmp_xMax = model.xMax;
              tmp_yMin = model.zMin;
              tmp_yMax = model.zMax;
              x = (int)map(tmp_x, tmp_xMin, tmp_xMax, 0, sW-1);
              y = (int)map(tmp_y, tmp_yMin, tmp_yMax, 0, sH-1); // PGrapics starts top left, points might start at bottom left
              index = (int)(y*sW + x);
              break;
          }
          
          //int index = (int)(p.y*pg.pixelWidth+p.x);
          int col = syphonImage.pixels[index];
          colors[p.index] = col;
        
        }
        syphonNew = false;
      }
  }
}
