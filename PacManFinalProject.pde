//describes blocks
int EMPTY = 0;
int WALL = 1;
int SPAWN = 2;
int DOOR = 3;

//ghost modes
int mode;
int BLUE = 4;
int SCATTER = 5;
int CHASE = 6;
int EATEN = 7;

color blue = color(0,0,255);
color black = color(0);
color red = color(255,0,0);

int diameter = 5;

int PacSpawnCol, PacSpawnRow;
int pinkSpawnRow, pinkSpawnCol;
int orangeSpawnRow, orangeSpawnCol;
int redSpawnRow, redSpawnCol;
int blueSpawnRow, blueSpawnCol;

int cols, rows;
int BWidth, BHeight;
String[] lines;

Map m;
Pellets p;
PacMan pac;
Ghost pinkG, orangeG, redG, lightBlueG; 
void setup() {
  size(560,588);
  background(0);
  
  lines = loadStrings("map.txt");
  cols = lines[0].length();
  rows = lines.length;
  BWidth = width / cols;
  BHeight = height / rows;
  
  PacSpawnCol = 14;
  PacSpawnRow = 21;
  
  m = new Map();
  m.ReadMap();
  m.display();
  p = new Pellets();
    p.ReadFile();

  p.display();
  
  pac = new PacMan(PacSpawnRow, PacSpawnCol, BWidth);
  pac.display();
  
  pinkSpawnCol = 14;
  pinkSpawnRow = 13;
  redSpawnCol = 14;
  redSpawnRow = 12;
  orangeSpawnCol = 15;
  orangeSpawnRow = 13;
  blueSpawnCol = 13;
  blueSpawnRow = 13;
  
  pinkG = new PinkGhost(pinkSpawnRow, pinkSpawnCol, BWidth);
  pinkG.display();
  redG = new RedGhost(redSpawnRow, redSpawnCol, BWidth);

  redG.display();
  lightBlueG = new LightBlueGhost(blueSpawnRow, blueSpawnCol, BWidth);
  lightBlueG.display();
  orangeG = new OrangeGhost(orangeSpawnRow, orangeSpawnCol, BWidth);
  orangeG.display();
  
  mode = SCATTER;
}

void draw() {
  m.display();
  p.display();
  pac.display();
  //pac.keyPressed();
  pac.move();
  pinkG.display();
  redG.display();
  lightBlueG.display();
  orangeG.display();
  
  if (mode == BLUE) {
    redG.blueMove();
    redG.display();
    //orangeG.blueMove();
    //orangeG.display();
    //lightBlueG.blueMove();
    //lightBlueG.display();
    //pinkG.blueMove();
    //pinkG.display();
  }
  if (mode == SCATTER) {
    //redG.scatterMove();
    //redG.display();
    //pinkG.scatterMove();
    //pinkG.display();
    lightBlueG.scatterMove();
    lightBlueG.display();
    //orangeG.scatterMove();
    //orangeG.display();
  }
}

void keyPressed() {
  pac.keyPressed(); 
}
