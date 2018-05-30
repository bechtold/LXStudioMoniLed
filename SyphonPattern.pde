/**
 * Maybe a syphon input pattern.
 */
@LXCategory("Oz")
public class SyphonPattern extends LXPattern {
  public SyphonPattern(LX lx) {
    super(lx);
  }
  
  public void run(double deltaMs) {
      for (LXPoint p : model.points) {
        if( syphonImage != null && syphonImage.pixels != null) {
          //calculating pixel array index from x and y positions of points ignoring y for now
          int x = (int)map(p.x, model.xMin, model.xMax, 0, syphonImage.pixelWidth);
          int y = (int)map(p.y, model.yMin, model.yMax, 0, syphonImage.pixelHeight); // PGrapics starts top left, points might start at bottom left
          int index = (int)(y*syphonImage.pixelWidth+x);
          //int index = (int)(p.y*pg.pixelWidth+p.x);
          if(index < syphonImage.pixels.length) {
            int col = syphonImage.pixels[index];
            colors[p.index] = col;
          }
        
        }
        //pg.pixels[p.index] = palette.getColor(brightness(55));
      }
  }
}
