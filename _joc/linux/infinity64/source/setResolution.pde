public int sketchWidth() {
  return 1200;
}
 
public int sketchHeight() {
  return 720;
}

void getResolution()
{
   ScreenWidth = width;
   ScreenHeight = height; 
}

void changeAppIcon(PImage img) {
  final PGraphics pg = createGraphics(16, 16, JAVA2D);

  pg.beginDraw();
  pg.image(img, 0, 0, 16, 16);
  pg.endDraw();

  frame.setIconImage(pg.image);
}
