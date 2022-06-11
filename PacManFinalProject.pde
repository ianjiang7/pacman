import processing.sound.*;

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
int highScore = 0;
int blueStartFrameCount;
boolean dead;
boolean started = false;
int deadTime;
SpriteSheet s;
Map m;
Pellets p;
PacMan pac;
Ghost pinkG, orangeG, redG, lightBlueG;
Ghost[] ghosts;

//sound
SoundFile eatP;
SoundFile eatPow;
SoundFile start;
SoundFile bGhost;
SoundFile death;
SoundFile ghostM;
SoundFile eatGhost;
void setup() {
  frameCount = 0;
  size(560,608);
  eatP = new SoundFile(this, "munch_1.wav");
  eatPow = new SoundFile(this, "power_pellet.wav");
  start = new SoundFile(this, "game_start.wav");
  bGhost = new SoundFile(this, "retreating.wav");
  death = new SoundFile(this, "death_1.wav");
  ghostM = new SoundFile(this, "siren_1.wav");
  eatGhost = new SoundFile(this, "eat_ghost.wav");
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
  //m.display();
  pac = new PacMan(PacSpawnRow, PacSpawnCol);
  //pac.display();
  p = new Pellets();
    p.ReadFile();

  //p.display();
  
 
  
  pinkSpawnCol = 14;
  pinkSpawnRow = 13;
  redSpawnCol = 14;
  redSpawnRow = 12;
  orangeSpawnCol = 15;
  orangeSpawnRow = 13;
  blueSpawnCol = 13;
  blueSpawnRow = 13;
  
  pinkG = new PinkGhost(pinkSpawnRow, pinkSpawnCol, BWidth);
  redG = new RedGhost(redSpawnRow, redSpawnCol, BWidth);
  lightBlueG = new LightBlueGhost(blueSpawnRow, blueSpawnCol, BWidth);
  orangeG = new OrangeGhost(orangeSpawnRow, orangeSpawnCol, BWidth);

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

  if(started && frameCount == 2) {
    m.display();
    p.display();
    for(int i = 0; i < 4; i++){ ghosts[i].display();}
    pac.display();
    start.play();
    int n = millis();
    while(millis() - n < 4000) {}
  }
  if(dead) {
    if(deadTime + 1 == frameCount) death.play();
    m.display();
    p.display();
    for(int i = 0; i < ghosts.length; i++) {ghosts[i].display();}
    if(frameCount - deadTime == 110) {
      dead = false;
      if(pacLives != 0) {
        pacLives--;
        pac = new PacMan(PacSpawnRow, PacSpawnCol);
        pinkG = new PinkGhost(pinkSpawnRow, pinkSpawnCol, BWidth);
        redG = new RedGhost(redSpawnRow, redSpawnCol, BWidth);
        lightBlueG = new LightBlueGhost(blueSpawnRow, blueSpawnCol, BWidth);
        orangeG = new OrangeGhost(orangeSpawnRow, orangeSpawnCol, BWidth);
        ghosts = new Ghost[4];
        ghosts[0] = pinkG;
        ghosts[1] = redG;
        ghosts[2] = orangeG;
        ghosts[3] = lightBlueG;
      }
    }
    else{
      PImage ani = s.get(3+((frameCount-deadTime)/10),0);
      image(ani,pac.pos.x-BWidth/2,pac.pos.y-BHeight/2,BWidth,BHeight);
    }
   
  }
  else if(!started) {
    textAlign(CENTER,CENTER);
    text("Press SPACE to Start Game", width/2, height/2);
    if (keyPressed) {
      if(key == ' ') {
        started = true;
        setup();
      }
    }
  }
  else{
    if (eatenPellets == p.total || pacLives == 0) {
      started = false;
      if (score > highScore) {
        highScore = score;
      }
      println("GAME OVER");
      textAlign(CENTER,CENTER);
      text("GAME OVER!", width/2, height/2);
      text("Press \"n\" For New Game", width/2, height/2 + 50);
      if (keyPressed) {
        if(key == 'n' || key == 'N') {
          started = true;
          setup();
        }
      }
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
          else if(i == 2 && eatenPellets > p.total/3 || frameCount > 600) {
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
            if((blueStartFrameCount - frameCount) % 120 == 0){ bGhost.amp(.5); bGhost.play();}
            if (ghosts[i].blue) { //when ghost is blue
              ghosts[i].blueMove(); 
              //println(ghosts[i].eaten);
            }
            else if (ghosts[i].eaten) { //when ghost has been eaten
              ghosts[i].eatenMove();
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
  textAlign(LEFT, TOP);
  text("SCORE: " + str(score),10,588,float(width),20.0);
  text("HIGH SCORE: " + str(highScore), 90, 588, float(width), 20.);
  text("LIVES LEFT: " + str(pacLives), 200, 588, float(width), 20.);
  }

}

void keyPressed() {

  if(started)
    pac.keyPressed(); 
}
