//Create a characteristics of the sketch (big or small mountains)
int iter = 32; //Number of iteration
int waveRep = 8;
int sz = 672;
float step = sz/iter;
float start;

void setup() {
  size(672, 672);
  colorMode(HSB, 360, 100, 100); // Change to HSB to produce different shades of colors
  noLoop();
  noStroke();
}

void draw() {
  background(10, 10, 80);
  
  start = -100;
  float H = random(0, 360);
  float S = random(80, 100);
  float B = 10;
  int side = int(random(1,2)); // This variable is to random which side of canvas the ellipse will appear first
  
  //Alternate 2 sides with colours of the same shade
  for (int i=0; i<iter; ++i) {
    pushMatrix();
    translate(0, start - step);
    float Hi = random(H-10, H+10);
    fill ( Hi, S - i*(100/iter), B+i*(100/iter));
    float wd = random(672, 1500);
    float ht = random (300, 500);
    noStroke();
    if (side == 1) {
      if (i%2 == 0) {
        createFan(random(0, step), start, Hi, S - (i-1)*(100/iter), B+ (i-1)*(100/iter), wd, ht);
        //ellipse(random(0, step), start, wd, ht);
        
        //stroke(Hi, S - (i-1)*(100/iter), B+ (i-1)*(100/iter));
        //strokeWeight(2);
        //for (int n = 0; n < waveRep; ++n) {
        //  ht -= 40;
        //  ellipse(random(0, step), start, wd, ht);
        //}
      } else {
        createFan(random(sz-step, sz), start+2*step, Hi, S - (i-1)*(100/iter), B+ (i-1)*(100/iter), wd, ht);
        //ellipse(random(sz-step, sz), start+2*step, wd, ht);
        
        //stroke(Hi, S - (i-1)*(100/iter), B+ (i-1)*(100/iter));
        //strokeWeight(2);
        
        //for (int n = 0; n < waveRep; ++n) {
        //  ht -= 40;
        //  ellipse(random(sz-step, sz), start+2*step, wd, ht);
        //}
      }
    } else {
      if (i%2 == 0) {
        ellipse(random(sz-step, sz), start+2*step, wd, ht);
        
        stroke(Hi, S - (i-1)*(100/iter), B+ (i-1)*(100/iter));
        strokeWeight(2);
        
        for (int n = 0; n < waveRep; ++n) {
          ht -= 40;
          ellipse(random(sz-step, sz), start+2*step, wd, ht);
        }        
      } else {
        ellipse(random(0, step), start, wd, ht);
        
        stroke(Hi, S - (i-1)*(100/iter), B+ (i-1)*(100/iter));
        strokeWeight(2);
        for (int n = 0; n < waveRep; ++n) {
          ht -= 40;
          ellipse(random(0, step), start, wd, ht);
        }
      }
    }
    
    start += step;
    popMatrix();
  }
  
  //Draw the big cricle to create a frame for the sketch
  stroke(0,0,90);
  noFill();
  strokeWeight(200);
  ellipse(width/2, height/2, sz+100, sz+100);
  //Consider creating the texture for pattern (paper maybe?)
}

//Create a function createFan() to reduce the code length
void createFan(float x, float y, float H, float S, float B, float wd, float ht) {
  ellipse(x, y, wd, ht);
        
  stroke(H, S, B);
  strokeWeight(2);
  for (int n = 0; n < waveRep; ++n) {
    ht -= 40;
    ellipse(x, y, wd, ht);
  }
}

//Redraw when mouse is pressed
void mousePressed() {
  redraw();
}
