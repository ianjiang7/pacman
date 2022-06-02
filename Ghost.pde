class Ghost {
  PVector pos;
  PVector prevPos;
  PVector vel;
  PVector nextVel;
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
    prevPos = new PVector(0, 0);
    vel = new PVector(-1,0); //up and to the left?
    nextVel = vel;
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
            inWall(x,y,m.blocks[row+1][col])  
            );
  }
  
  void move() {
    //if(!inWall(int(pos.x+nextVel.x),int(pos.y+nextVel.y), m.blocks[int(row+nextVel.y)][int(col+nextVel.x)]) && nextVel.x!=-vel.x && nextVel.y!=-vel.y) {
      //vel = nextVel;
   // }
    if (checkNextMove(nextVel)) {
      prevPos = pos;
      pos.add(nextVel);
      vel = nextVel;
    }
    setPos(findRow(int(pos.y)), findCol(int(pos.x)));
  }
  
  void display() {
    fill(c);
    circle(pos.x, pos.y, size);
  }
  
  void blueMove() {
    Block nextBlock = m.blocks[(findRow(int(pos.y + vel.y)))][findCol(int(pos.x+vel.x))];
    circle(pos.x+vel.x, pos.y + vel.y, 20);
    //if ((findRow(int(pos.y + vel.y)) == row && findCol(int(pos.x+vel.x)) == col) || (pos.y != nextBlock.ypos + BHeight/2 && pos.x != nextBlock.xpos + BWidth/2)) {
    //  move();
    //}
    //ghost moves randomly but can't move back or into walls
    //vel.mult(-1); //turns 180 degrees
    //ghost has four options of movement: up, down, left, right - but the option that's == vel.mult(-1) isn't allowed
    if (nextBlock.type == WALL) {
      nextVel.x = int(random(3)) - 1;
      nextVel.y = int(random(3)) - 1;
      while((nextVel.x == 0 && nextVel.y == 0) || (nextVel.x != 0 && nextVel.y != 0)) {
        nextVel.x = int(random(3)) - 1;
        if (nextVel.x != 0) {
          nextVel.y = 0;
        }
        if (nextVel.x == 0) {
          nextVel.y = int(random(3))-1;
        }
      }
      move();
    }
    else {
      move();
    }
    
    
    
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
}
