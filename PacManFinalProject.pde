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
int R = 20;
int P = 21;
int O = 22;
int LB = 23;
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
int pacLives;
int score;
int blueStartFrameCount;
boolean dead;
int deadTime;
SpriteSheet s;
Map m;
Pellets p;
PacMan pac;
Ghost pinkG, orangeG, redG, lightBlueG;
Ghost[] ghosts;
void setup() {
  size(560,608);
  background(0);
  dead = false;
  score = 0;
  eatenPellets = 0;
  pacLives = 3;
  lines = loadStrings("map.txt");
  cols = lines[0].length();
  rows = lines.length;
  BWidth = 20;
  BHeight = 20;
  
  PacSpawnCol = 14;
  PacSpawnRow = 21;
  
  s = new SpriteSheet("sprite.png");
  m = new Map();
  m.ReadMap();
  m.display();
  pac = new PacMan(PacSpawnRow, PacSpawnCol);
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
  mode = SCATTER;
  
  textAlign(LEFT,TOP);
}

void draw() {
  background(0);
  if(dead) {
    m.display();
    p.display();
    for(int i = 0; i < ghosts.length; i++) {ghosts[i].display();}
    if(frameCount - deadTime == 110) {
      dead = false;
      if(pacLives != 0) {
        pacLives--;
        pac = new PacMan(PacSpawnRow, PacSpawnCol);
      }
    }
    else{
      PImage ani = s.get(3+((frameCount-deadTime)/10),0);
      image(ani,pac.pos.x-BWidth/2,pac.pos.y-BHeight/2,BWidth,BHeight);
    }
   
  }
  else{
  if (eatenPellets == p.total || pacLives == 0) {
    println("GAME OVER");
    textAlign(CENTER,CENTER);
    text("GAME OVER!", width/2, height/2);
  }
  else {
  m.display();

  p.display();
  pac.display();
  pac.move();
  
  //println(ghosts[3].nextPos.x,ghosts[3].nextPos.y, ghosts[3].pos, ghosts[3].vel);
  for(int i = 0;i < 4;i++) {
    //println(ghosts[i].eaten,ghosts[i].blue,ghosts[i].inSpawn);
    if(ghosts[i].inSpawn) {
      if (frameCount - blueStartFrameCount == 480) {
        mode = SCATTER;
        ghosts[i].blue = false;
        
      }
      if(i == 3 && (eatenPellets >= 30 || frameCount > 240)){
        ghosts[i].spawnMove();
      }
      else if(i == 2 && eatenPellets > p.total/3) {
        ghosts[i].spawnMove();
      }
      else if(i == 0 || i == 1) {
        ghosts[i].spawnMove(); 
      }
    }
    else{
      if (mode != BLUE && frameCount%200 == 0) mode = CHASE;
      if (mode != BLUE && frameCount%600 ==0) mode = SCATTER;
      //println(mode);
      if (frameCount - blueStartFrameCount == 480) {
        mode = SCATTER;
        ghosts[i].blue = false;
        if(ghosts[i].pos.x * 2 % 2 != 0) {
          ghosts[i].pos.x += .5;
        }
        if(ghosts[i].pos.y * 2 % 2 != 0) {
           ghosts[i].pos.y += .5;
        }
        if(ghosts[i].prevPos.x * 2 % 2 != 0) {
          ghosts[i].prevPos.x += .5 * int(ghosts[i].vel.y);
        }   
        if(ghosts[i].prevPos.y * 2 % 2 != 0) {
          ghosts[i].prevPos.y += .5  * int(ghosts[i].vel.y);
        }
        
      }
      if(mode == BLUE) {
        if (ghosts[i].blue) { //when ghost is blue
          ghosts[i].blueMove(); 
          //println(ghosts[i].eaten);
        }
        else if (ghosts[i].eaten) { //when ghost has been eaten
          ghosts[i].eatenMove();
        }
        else { //when ghost has been respawned after being eaten
          ghosts[i].scatterMove();
        }
      }
      if(mode == SCATTER) {
        if (ghosts[i].eaten) ghosts[i].eatenMove();
        else ghosts[i].scatterMove();
      }
      if (mode == CHASE) {
        if (ghosts[i].eaten) ghosts[i].eatenMove();
        else ghosts[i].chaseMove();
      }
    }
    ghosts[i].display();
    if(ghosts[i].killPac()) {
      dead = true;
      deadTime = frameCount;
      break;
    }
  }
  }
  fill(255);
  textSize(13);
  text("SCORE: " + str(score),10,588,float(width),20.0);
  text("LIVES LEFT: " + str(pacLives), 100, 588, float(width), 20);
  }

}

void keyPressed() {
  pac.keyPressed(); 
}
