//////////////////////////////////  
//                              //
//   -~=Nguyen Thanh Trung=~-   //
//                              //
//////////////////////////////////
//
//   Recommended Watching Time
//         1 - 1.5mins
//
//////////////////////////////////

Cell[][] grid;
CellCore[] cores;

int cols = 30;
int rows = 30;
int coreNum = 60;
float w; // The width of cell square
float H = random(0, 360);

void setup() {
  size(660, 660);
  frameRate(20);
  w = width/cols;
  colorMode(HSB, 360, 100, 100); //Change to HSB to produce different shades of colors
  noStroke();
  grid = new Cell[cols][rows];
  for (int i = 0; i < cols; i++) {
    for (int j=0; j < rows; j++) {
      grid[i][j] = new Cell(i*w, j*w, w, w, random(H-20, H+20), random(20, 100), random(20, 100));
    }
  }
  
  cores = new CellCore[coreNum];
  for (int k=0; k < coreNum; k++) {
    cores[k] = new CellCore(w*random(30), w*random(30), w, w, random(0,360), random(20,100), random(20,100));
  }
}

void draw() {
  background(0);
  for (int i = 0; i< cols; i++) {
    for (int j = 0; j< rows; j++) {
      grid[i][j].display();
    }
  }
  for (int k=0; k< coreNum; k++) {
    cores[k].move();
  }
  if (similarHue()) {
    float avgHue = averageHue();
    float newHue = random(360);
    while( abs(newHue - avgHue) <=40) { // The new hue need to be intersting by being different to the current avgHue
      newHue = random(360);
    }
    for (int k=0; k< coreNum; k++) { 
      cores[k].changeColour(newHue, random(20,100), random(20,100));
    }
  }
}

class Cell {
  float x, y;
  float w, h;
  float hue;
  float brightness;
  float saturation;
  
  //Cell constructor
  Cell(float tempX, float tempY, float tempW, float tempH, float tempHue, float tempS, float tempB) {
    x = tempX;
    y = tempY;
    w = tempW;
    h = tempH;
    hue = tempHue;
    saturation = tempS;
    brightness = tempB;
    
  }
  
  void display() {
    fill(hue, saturation, brightness);
    rect(x,y,w,h);
  }
}

// CellCore is basically a Cell. Also it can move and transfer colour.
class CellCore extends Cell{
  CellCore(float x, float y, float w, float h, float hue, float saturation, float brightness) {
    super(x,y,w,h, hue, saturation, brightness);
  }
  
  void changeColour(float hue, float saturation, float brightness) {
    super.hue = hue;
    super.saturation = saturation;
    super.brightness = brightness;
  }
  
  void move() {
    float angle = (TWO_PI / 4) * floor( random( 4 )); //This is to random the direction of movement: up, down, left right
    float prevX = x;
    float prevY = y; 
    
    // New position of the core cell
    x += cos( angle ) * w; 
    y += sin( angle ) * w;
    
    if ( x < 0 || x > width ) {
      x = prevX;
    } 
    
    if ( y < 0 || y > height) {
      y = prevY;
    }
    
    int i = int(x/w);
    int j = int(y/w);
    
    hue = 0.05*grid[i][j].hue + 0.95*hue;
    
    //If saturation value of cell and core cell are similar then a new random one will be generated
    if ( abs(grid[i][j].saturation - saturation) <=2) {
      saturation = random(saturation-20,saturation+20);
    } else {
      saturation = 0.8*grid[i][j].saturation + 0.2*saturation;
    }
    
    //If brightness values of cell and core cell are similar then a new random one will be generated
    if ( abs(grid[i][j].brightness - brightness) <=2) {
      brightness = random(brightness-10, brightness+10);
    } else {
      brightness = 0.8*grid[i][j].brightness + 0.2*brightness;
    }
    
    // The core cell transfer the new colour hue, saturation and brightness to the cell of grid under it
    grid[i][j].hue = hue;
    grid[i][j].saturation = saturation;
    grid[i][j].brightness = brightness;
  } 
}

float averageHue() {
  float totalHue =0;
  for (int i = 0; i < cols; i++) {
    for (int j=0; j < rows; j++) {
      totalHue += grid[i][j].hue;
    }
  } 
  return totalHue/(cols*rows);
}

// Hue of sample cell is used to compare with other cells in grid to determine the dominance of any colour
boolean similarHue() {
  int sampleI = int(random(cols));
  int sampleJ = int(random(rows));
  int similarCount = 0;
  for (int i = 0; i < cols; i++) {
    for (int j=0; j < rows; j++) {
      if (abs(grid[i][j].hue - grid[sampleI][sampleJ].hue) <= 40 ) {
        similarCount ++;
        if (similarCount >= 0.99*cols*rows) {
          return true;
        }
      }
    }
  }
  return false;
} 