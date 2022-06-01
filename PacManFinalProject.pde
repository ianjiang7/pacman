int EMPTY = 0;
int WALL = 1;
int SPAWN = 2;
int DOOR = 3;

color blue = color(0,0,255);
color black = color(0);
color red = color(255,0,0);

int diameter = 5;

int PacSpawnCol, PacSpawnRow;
int purpleSpawnRow, purpleSpawnCol;
int orangeSpawnRow, orangeSpawnCol;
int redSpawnRow, redSpawnCol;
int blueSpawnRow, blueSpawnCol;

int cols, rows;
int BWidth, BHeight;
String[] lines;

Map m;
Pellets p;
PacMan pac;
Ghost purpleG, orangeG, redG, lightBlueG; 
void setup() {
  size(600,600);
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
  
  purpleSpawnCol = 14;
  purpleSpawnRow = 13;
  redSpawnCol = 14;
  redSpawnRow = 12;
  orangeSpawnCol = 15;
  orangeSpawnRow = 13;
  blueSpawnCol = 13;
  blueSpawnRow = 13;
  
  purpleG = new Ghost(purpleSpawnRow, purpleSpawnCol, 10, color(230,140,255));
  purpleG.display();
  redG = new Ghost(redSpawnRow, redSpawnCol, 10, color(200, 0, 0));
  redG.display();
  lightBlueG = new Ghost(blueSpawnRow, blueSpawnCol, 10, color(130,200,255));
  lightBlueG.display();
  orangeG = new Ghost(orangeSpawnRow, orangeSpawnCol, 10, color(255,140,0));
  orangeG.display();
}

void draw() {
  m.display();
  p.display();
  pac.display();
  //pac.keyPressed();
  pac.move();
  purpleG.display();
  redG.display();
  lightBlueG.display();
  orangeG.display();
  pac.inWall(pac.x,pac.y,m.blocks[20][14]);
}

void keyPressed() {
  pac.keyPressed(); 
}
