import codeanticode.gsvideo.*; //linux

GSCapture video; //linux

int ancho = 1280; 
int alto = 1024; 
int area = ancho*alto; 
int tiempo = 8;
boolean screengrab = false;
 
void setup() 
{ 
  size(ancho, alto); 
  background(0); 
  video = new GSCapture(this, ancho, alto, 10, "/dev/video1"); //linux
  video.play(); //linux only
} 
 
void draw() {
  if (screengrab) saveImage();
  loadPixels(); 
  for (int i=0;i<area;i++) 
  { 
    int rgb = pixels[i];
    int vid = video.pixels[i];
    // we can make this more efficient with byte math:
    if (red(vid) > red(rgb)) rgb = color(red(vid),green(rgb),blue(rgb));
    if (green(vid) > green(rgb)) rgb = color(red(rgb),green(vid),blue(rgb));
    if (blue(vid) > blue(rgb)) rgb = color(red(rgb),green(rgb),blue(vid));
    pixels[i] = rgb;
  } 
  updatePixels();
  if (screengrab) {
    image( video, 0, 0 ); 
    screengrab = false;
  }
} 

void mousePressed() {
   screengrab = true;
}

void saveImage() 
  { 
    StringBuilder builder = new StringBuilder();
    builder.append(year());
    builder.append("-"+month());
    builder.append("-"+day());
    builder.append("-"+hour());
    builder.append("-"+minute());
    save(builder.toString()+".png");
  } 

public void captureEvent(GSCapture c) { //linux
  c.read();
}

void keyPressed() {
  if (key == CODED) {
  }
  if (key == RETURN || key == ENTER) {
    image( video, 0, 0 ); 
  } else if (key == ' ') {
    screengrab = true;
  }
}
