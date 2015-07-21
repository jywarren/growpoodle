import codeanticode.gsvideo.*; //linux

GSCapture video; //linux

int ancho = 1280; 
int alto = 720; 
int area = ancho*alto; 
int tiempo = 8;
boolean screengrab = false;
color[] mirrorpix = new color[area]; 
 
void setup() 
{ 
  size(ancho, alto); 
  background(0); 
  video = new GSCapture(this, ancho, alto, "/dev/video0"); //linux, removed a legacy parameter
  video.start(); //linux only, updated function from play to start 
} 
 
void draw() 
{
  if (screengrab) saveImage();
  loadPixels(); 
  
  //Mirror the pixels from the video feed
  //for loop for width=ancho
  for (int i = 0; i < ancho; i++) 
  {
     // Begin loop for height
     for (int j = 0; j < alto; j++) 
     {   
       mirrorpix[j*ancho+i] = video.pixels[(ancho - i - 1) + j*ancho]; // Reversing x to mirror the image
     }
   }
 
   //Grab and save the lighter colors
  for (int i=0;i<area;i++) 
  { 
    int rgb = pixels[i];
    int vid = mirrorpix[i];
    if (red(vid) > red(rgb)) rgb = color(red(vid),green(rgb),blue(rgb));
    if (green(vid) > green(rgb)) rgb = color(red(rgb),green(vid),blue(rgb));
    if (blue(vid) > blue(rgb)) rgb = color(red(rgb),green(rgb),blue(vid));
    pixels[i] = rgb;
  } 
  
  updatePixels();
  
  //what to do after a screenshot is saved/how the growpoodle is cleared
  if (screengrab) {
    PImage mirrored = new PImage(ancho, alto); //make a new blank PImage
    mirrored.pixels = mirrorpix; //set its pixels to be our mirrored video feed frame
    image( mirrored, 0, 0 ); 
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
    builder.append("-"+second());//added the ability to take a screenshot every second
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

