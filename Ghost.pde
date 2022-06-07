float bigNum = 200000; //used to initialize dist0, dist1, and dist2 in scatterMove

class Ghost {
  PVector pos;
  PVector prevVel;
  PVector prevPos;
  PVector nextPos;//coordinates of the center of the next box
  PVector vel;
  PVector scatterTarget;
  PVector chaseTarget;
  PVector eatenTarget; //where the ghosts go when they've been eaten
  //PVector nextVel;
  //vel.x/nextVel.x and vel.y/nextVel.y can be -1, 0, or 1
  int row, col;
  color c;
  int size;
  boolean inSpawn;
  boolean blue; //need a blue boolean because individual ghosts can be not blue if they respawn during blue mode
  boolean eaten;
  //size just needs to be switched to width and height when we replace the circle with PImage
  //ghosts cannot stop moving or reverse direction
  //all ghosts have a target for scatter mode
  //all ghosts move the same during frightened (blue ghost) and eaten mode but scatter and chase is dif for each ghost
  
  Ghost(int arow, int acol, int asize, color ac) {
    row = arow;
    col = acol;
    pos = new PVector(col*BWidth + BWidth/2, row*BHeight + BHeight/2);
    prevVel = new PVector(0, 0);
    prevPos = new PVector(0,0);
    nextPos = new PVector(col*BWidth + BWidth/2, row*BHeight + BHeight/2 -  BHeight);
    vel = new PVector(0,-1); //up and to the left?
    //nextVel = vel;
    scatterTarget = new PVector(0, 0);
    setChaseTarget();
    eatenTarget = new PVector(redSpawnCol*BWidth + BWidth/2 , redSpawnRow*BHeight + BHeight/2 + BHeight);
    c = ac;
    size = asize;
    inSpawn = true;
    blue = false; //changes to true when pac man eats power pellet
    eaten = false; //changes to true when mode == BLUE && ghost intersects w pac
  }

  boolean inWall(int x, int y, Block b) {
     if(b.type == WALL || (b.type == SPAWN && !eaten)) {//need the eaten because ghosts that are trying to respawn need to get back into the spawn zone
       if(x-(BWidth/2) < b.xpos+BWidth && x+(BWidth/2) > b.xpos && y-(BHeight/2) < b.ypos+BHeight && y+(BHeight/2) > b.ypos)
         return true;
      }
      return false;
  }
  
  boolean inWall(int x, int y) {
    if (col > 0 && col < 27) {
      return (inWall(x,y,m.blocks[row-1][col]) ||
              inWall(x,y,m.blocks[row][col-1]) || 
              inWall(x,y,m.blocks[row][col+1]) ||
              inWall(x,y,m.blocks[row+1][col]) ||
              inWall(x,y,m.blocks[row-1][col-1]) ||
              inWall(x,y,m.blocks[row-1][col+1]) ||
              inWall(x,y,m.blocks[row+1][col-1]) ||
              inWall(x,y,m.blocks[row+1][col+1])
              );
    }
    else if (col == 27 || col == 0) {
      return (inWall(x,y,m.blocks[row-1][col]) || inWall(x,y,m.blocks[row+1][col]));
    } 
    return false;
  }
  
  void spawnMove() {
    //nextPos.x = redSpawnCol * BWidth + BWidth/2;
    //nextPos.y = redSpawnRow * BHeight - BHeight + BHeight/2;
    vel.x = 0;
    vel.y = -1;
   if(m.blocks[row-1][col].type != WALL || !(pos.x == col * BWidth + BWidth/2 && pos.y == row * BHeight + BHeight/2)) {
      prevVel = vel;
      prevPos = pos;
      pos.add(vel);
      setPos(findRow(int(pos.y)), findCol(int(pos.x)));
   }
   else{
     nextPos.x = pos.x;
     nextPos.y = pos.y;
     inSpawn = false;
     
   }
  }
  
  void move() {
    if(pos.x > width) {
      pos.x = 0;
      nextPos.x = BWidth/2;
    }
    if(pos.x < 0) {
      pos.x = width;
      nextPos.y = width - BWidth/2;
    }
    if (checkNextMove(vel)) {
      prevVel = vel;
      prevPos = pos;
      pos.add(vel);
    }
    //println(chaseTarget);
    setPos(findRow(int(pos.y)), findCol(int(pos.x)));
  }
  
  
  void display() {
    fill(c);
    if (blue) {
      fill(50, 100, 255);
    }
    if (eaten) {
      fill(255);
    }
    circle(pos.x, pos.y, size);
  }
  
  void blueMove() {
    if(!inNext()) {
      move(); 
    }
    else{
      println("0:" + vel);
      vel = getRandomVel();
      while(PVector.add(pos,vel) == prevPos)
        vel = getRandomVel();
      nextPos.x += vel.x * BWidth;
      nextPos.y += vel.y * BHeight;
      move();
      println("1:" + vel);
    }
    setEaten();
  }
  
  boolean inNext() {
    return pos.x == nextPos.x && pos.y == nextPos.y;
  }
  
  PVector getRandomVel() {
    boolean b = false;
    while(!b) {
      int n = int(random(4));
      if(col == 0) {
        return new PVector(-1,0); 
      }
      if(col == 27){
        return new PVector(1,0); 
      }
      if(n == 0){
        if(m.blocks[row-1][col].type != WALL && vel.y != 1 && m.blocks[row-1][col].type != SPAWN) {
          return new PVector(0,-1);
        }
      }
      if(n == 1){
        if(m.blocks[row+1][col].type != WALL && vel.y != -1 && m.blocks[row+1][col].type != SPAWN) {
          return new PVector(0,1);
        }
      }
      if(n == 2){
        if(m.blocks[row][col-1].type != WALL && vel.x != 1 && m.blocks[row][col-1].type != SPAWN) {
          return new PVector(-1,0);
        }
      }
      if(n == 3){
        if(m.blocks[row][col+1].type != WALL && vel.x != -1 && m.blocks[row][col+1].type != SPAWN) {
          return new PVector(1,0);
        }
      }
    }
    return new PVector(0,0);
  }
  
  int findRow(int y) {
    int loopingY = 0;
    int rowC = 0;
    while(loopingY < y) {
      loopingY += BHeight;
      rowC++;
    }
    return rowC -1;
  }
  
  int findCol(int x) {
    int loopingX = 0;
    int colC = 0;
    while(loopingX < x) {
      loopingX += BWidth;
      colC++;
    }
    return colC - 1;
  }
  
  void setPos(int arow, int acol) {
     row = arow;
     col = acol;
  }
  
  boolean checkNextMove(PVector next) {
    PVector test = PVector.add(pos, next);
    if (test == prevPos) {
      return false;
    }
    else return !inWall(int(pos.x+next.x), int(pos.y+next.y)); 
  }
  
  void setEaten() { //eaten also needs to be set to false once it reaches eatenTarget, also once it reaches eatenTarget, inSpawn needs to be set to true
    if (blue) {
      if (intersectWPac()) { //might reset eaten to false if ghost stops intersecting with pac man like when pac moves away
        eaten = true;
        blue = false;
      }
      //else {
      //  eaten = false;
      //}
    }
    //else {
    //  eaten = false;
    //}
  } //need for later (maybe?)
  
  boolean intersectWPac() {
    //println("  " + str(pos.dist(pac.pos) < BWidth));
    return pos.dist(pac.pos) < BWidth;
  }
  
  void eatenMove() {
    PVector[] validMoves = new PVector[3];
    if(pos.dist(eatenTarget) == 0) {
      inSpawn = true;
      eaten = false;
    }
    else if (!inNext()) {
      move();
    }
    else {
      PVector oldVel = vel.copy();
      PVector testVel = new PVector(0,1);
      int checked = 0;
      if (PVector.mult(oldVel, -1).y!=testVel.y && checkNextMove(testVel)) {
        validMoves[checked] = testVel.copy();
        checked++;
      }
      testVel = new PVector(-1, 0);
      if (PVector.mult(oldVel, -1).x!=testVel.x && checkNextMove(testVel)) {
        validMoves[checked] = testVel.copy();
        checked++;
      }
      testVel = new PVector(0, -1);
      if (PVector.mult(oldVel, -1).y!=testVel.y && checkNextMove(testVel)) {
        validMoves[checked] = testVel.copy();
        checked++;
      }
      testVel = new PVector(1, 0);
      if (PVector.mult(oldVel, -1).x!=testVel.x && checkNextMove(testVel)) {
        validMoves[checked] = testVel.copy();
        checked++;
      }
      float dist0 = bigNum, dist1 = bigNum, dist2 = bigNum;
      if (validMoves[0] != null) {
        dist0 = PVector.dist(PVector.add(pos, validMoves[0]), eatenTarget);
        if (validMoves[1] != null) {
          dist1 = PVector.dist(PVector.add(pos, validMoves[1]), eatenTarget);
          if (validMoves[2] != null) {
            dist2 = PVector.dist(PVector.add(pos, validMoves[2]), eatenTarget);
          }
        }
      }
      int leastIndex = 0; //index with smallest distance
      float min = min(dist0, dist1, dist2);
      if (dist2 == min) leastIndex = 2;
      if (dist1 == min) leastIndex = 1;
      if (dist0 == min) leastIndex = 0;
      vel = validMoves[leastIndex].copy();
      nextPos.x += vel.x * BWidth;
      nextPos.y += vel.y * BHeight;
      move();
    }
  }
  
  void scatterMove() {
    PVector[] validMoves = new PVector[3];
    if(!inNext()) {
      move(); 
    }
    else {
      PVector oldVel = vel.copy();
      PVector testVel = new PVector(0,1);
      int checked = 0;
      if (PVector.mult(oldVel, -1).y!=testVel.y && checkNextMove(testVel)) {
        validMoves[checked] = testVel.copy();
        checked++;
      }
      testVel = new PVector(-1, 0);
      if (PVector.mult(oldVel, -1).x!=testVel.x && checkNextMove(testVel)) {
        validMoves[checked] = testVel.copy();
        checked++;
      }
      testVel = new PVector(0, -1);
      if (PVector.mult(oldVel, -1).y!=testVel.y && checkNextMove(testVel)) {
        validMoves[checked] = testVel.copy();
        checked++;
      }
      testVel = new PVector(1, 0);
      if (PVector.mult(oldVel, -1).x!=testVel.x && checkNextMove(testVel)) {
        validMoves[checked] = testVel.copy();
        checked++;
      }
      float dist0 = bigNum, dist1 = bigNum, dist2 = bigNum;
      if (validMoves[0] != null) {
        dist0 = PVector.dist(PVector.add(pos, validMoves[0]), scatterTarget);
        if (validMoves[1] != null) {
          dist1 = PVector.dist(PVector.add(pos, validMoves[1]), scatterTarget);
          if (validMoves[2] != null) {
            dist2 = PVector.dist(PVector.add(pos, validMoves[2]), scatterTarget);
          }
        }
      }
      int leastIndex = 0; //index with smallest distance
      float min = min(dist0, dist1, dist2);
      if (dist2 == min) leastIndex = 2;
      if (dist1 == min) leastIndex = 1;
      if (dist0 == min) leastIndex = 0;
      vel = validMoves[leastIndex].copy();
      nextPos.x += vel.x * BWidth;
      nextPos.y += vel.y * BHeight;
      move();
      
    }
  }
  
  void setChaseTarget(){
  }
  
  void chaseMove() {
    PVector[] validMoves = new PVector[3];
    setChaseTarget();
    //println(chaseTarget, pac.pos);
    if(!inNext()) {
      move(); 
    }
    else {
      PVector oldVel = vel.copy();
      PVector testVel = new PVector(0,1);
      int checked = 0;
      //println(PVector.mult(oldVel,-1).y, testVel.y);
      if (PVector.mult(oldVel, -1).y!=testVel.y && checkNextMove(testVel)) {
        validMoves[checked] = testVel.copy();
        //println(validMoves[checked]);
        checked++;
      }
      testVel = new PVector(-1, 0);
      if (PVector.mult(oldVel, -1).x!=testVel.x && checkNextMove(testVel)) {
        validMoves[checked] = testVel.copy();
        //println(validMoves[checked]);
        checked++;
      }
      testVel = new PVector(0, -1);
      if (PVector.mult(oldVel, -1).y!=testVel.y && checkNextMove(testVel)) {
        validMoves[checked] = testVel.copy();
        //println(validMoves[checked]);
        checked++;
      }
      testVel = new PVector(1, 0);
      if (PVector.mult(oldVel, -1).x!=testVel.x && checkNextMove(testVel)) {
        validMoves[checked] = testVel.copy();
        //println(validMoves[checked]);
        checked++;
      }
      float dist0 = bigNum, dist1 = bigNum, dist2 = bigNum;
      if (validMoves[0] != null) {
        dist0 = PVector.dist(PVector.add(pos, validMoves[0]), chaseTarget);
        if (validMoves[1] != null) {
          dist1 = PVector.dist(PVector.add(pos, validMoves[1]), chaseTarget);
          if (validMoves[2] != null) {
            dist2 = PVector.dist(PVector.add(pos, validMoves[2]), chaseTarget);
          }
        }
      }
      //for (int i = 0; i < 3; i++) {
      //  println(validMoves[i]);
      //}
      int leastIndex = 0; //index with smallest distance
      float min = min(dist0, dist1, dist2);
      if (dist2 == min) leastIndex = 2;
      if (dist1 == min) leastIndex = 1;
      if (dist0 == min) leastIndex = 0;
      vel = validMoves[leastIndex].copy();
      nextPos.x += vel.x * BWidth;
      nextPos.y += vel.y * BHeight;
      move();
    }
  }
  
  boolean killPac() {
    if (!blue && !eaten && dist(pac.pos.x,pac.pos.y, pos.x, pos.y) < BWidth) {
      return true;
    }
    return false;
  }
}
