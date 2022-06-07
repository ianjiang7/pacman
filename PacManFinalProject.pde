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

int eatenPellets;


Map m;
Pellets p;
PacMan pac;
Ghost pinkG, orangeG, redG, lightBlueG;
Ghost[] ghosts;
void setup() {
  size(560,588);
  background(0);
  
  eatenPellets = 0;
  
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
   pac = new PacMan(PacSpawnRow, PacSpawnCol, BWidth);
  pac.display();
  p = new Pellets();
    p.ReadFile();

  p.display();
  
 
  
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
  ghosts = new Ghost[4];
  ghosts[0] = pinkG;
  ghosts[1] = redG;
  ghosts[2] = orangeG;
  ghosts[3] = lightBlueG;
  mode = CHASE;
}

void draw() {
  if (eatenPellets == p.total) {
    println("p");
    println(eatenPellets);
  }
  else {
  m.display();

  p.display();
  pac.display();
  //pac.keyPressed();
  pac.move();
  
 
  for(int i = 0;i < 4;i++) {
    //if(i ==2) continue;
    if(ghosts[i].inSpawn) {
      ghosts[i].spawnMove();
    }
    else{
      if(mode == BLUE) {
        if (ghosts[i].blue) { //when ghost is blue
          ghosts[i].blueMove(); 
          println(ghosts[i].eaten);
        }
        else if (ghosts[i].eaten) { //when ghost has been eaten
          ghosts[i].eatenMove();
        }
        else { //when ghost has been respawned after being eaten
          ghosts[i].scatterMove();
        }
      }
      if(mode == SCATTER) {
        ghosts[i].scatterMove();
        
      }
      if (mode == CHASE) {
        ghosts[i].chaseMove();
      }
    }
    ghosts[i].display();
  }
  }
}

void keyPressed() {
  pac.keyPressed(); 
}
