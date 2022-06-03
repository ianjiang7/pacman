float bigNum = 200000; //used to initialize dist0, dist1, and dist2 in scatterMove

class Ghost {
  PVector pos;
  PVector prevVel;
  PVector prevPos;
  PVector nextPos;//coordinates of the center of the next box
  PVector vel;
  PVector scatterTarget;
  //PVector nextVel;
  //vel.x/nextVel.x and vel.y/nextVel.y can be -1, 0, or 1
  int row, col;
  color c;
  int size;
  
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
    nextPos = new PVector(col*BWidth + BWidth/2, row*BHeight + BHeight/2 - BHeight);
    vel = new PVector(0,-1); //up and to the left?
    //nextVel = vel;
    scatterTarget = new PVector(0,0);
    c = ac;
    size = asize;
  }

  boolean inWall(int x, int y, Block b) {
     if(b.type == WALL) {
       if(x-(BWidth/2) < b.xpos+BWidth && x+(BWidth/2) > b.xpos && y-(BHeight/2) < b.ypos+BHeight && y+(BHeight/2) > b.ypos)
         return true;
      }
      return false;
  }
  
  boolean inWall(int x, int y) {
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
  
  void move() {
    //if(!inWall(int(pos.x+nextVel.x),int(pos.y+nextVel.y), m.blocks[int(row+nextVel.y)][int(col+nextVel.x)]) && nextVel.x!=-vel.x && nextVel.y!=-vel.y) {
      //vel = nextVel;
   // }
    if (checkNextMove(vel)) {
      prevVel = vel;
      prevPos = pos;
      pos.add(vel);
      //vel = nextVel;
    }
    setPos(findRow(int(pos.y)), findCol(int(pos.x)));
  }
  
  void display() {
    fill(c);
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
  }
  
  boolean inNext() {
    return pos.x == nextPos.x && pos.y == nextPos.y;
  }
  
  PVector getRandomVel() {
    boolean b = false;
    while(!b) {
      int n = int(random(4));
      if(n == 0){
        if(m.blocks[row-1][col].type != WALL && vel.y != 1) {
          return new PVector(0,-1);
        }
      }
      if(n == 1){
        if(m.blocks[row+1][col].type != WALL && vel.y != -1) {
          return new PVector(0,1);
        }
      }
      if(n == 2){
        if(m.blocks[row][col-1].type != WALL && vel.x != 1) {
          return new PVector(-1,0);
        }
      }
      if(n == 3){
        if(m.blocks[row][col+1].type != WALL && vel.x != -1) {
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
  
  void eatenMove() {
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
      //if (dist1 < dist0) {
      //  leastIndex = 1;
      //  if (dist2<dist1) {
      //    leastIndex = 2;
      //  }
      //}
      //if (dist2 < dist0) {
      //  leastIndex = 2;
      //}
      vel = validMoves[leastIndex].copy();
      println(validMoves[0], validMoves[1], validMoves[2]);
      println(dist0, dist1, dist2);
      println("o" + oldVel, "n" + vel);
      println("______");
      nextPos.x += vel.x * BWidth;
      nextPos.y += vel.y * BHeight;
      move();
    }
  }
}
