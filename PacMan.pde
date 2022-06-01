class PacMan {
  //starting pos: row 21, col 14
  //fill(200, 200, 0);
  //circle(14*BWidth +BWidth/2, 21*BHeight + BHeight/2, 10);
  
  int x, y, size;
  int row, col;
  int xVel, yVel;
  int nxV, nyV;
  //size just needs to be switched to width and height when we replace the circle with PImage
  
  PacMan(int row, int col, int asize) {
    x = col*BWidth + BWidth/2;
    y = row*BHeight + BHeight/2;
    size = asize;
    this.row = row;
    this.col = col;
    xVel = 0;
    yVel = 0;
    nxV = 0;
    nyV = 0;
  }
  
  void display() {
    fill(255, 255, 0);
    circle(x, y, size);
  }
  
  void keyPressed() {
    if (keyCode == LEFT) {
      //if(!inWall(x-(BWidth/2)-1,y)) {
      //  xVel = -1;
      //  yVel = 0;
      //}
      nxV = -1;
    }
    if (keyCode == RIGHT) {
      //if(!inWall(x+(BWidth/2)+1,y)) {
      //  xVel = 1;
      //  yVel = 0;
      //  //move();
      //}
      nxV = 1;
    }  
    if(keyCode == UP) {
      //if(!inWall(x,y-(BHeight/2)-1)) {
      //  yVel = -1;
      //  xVel = 0;
      //  //move();
      //}
      nyV = -1;
    }
    if(keyCode == DOWN) {
      //if(!inWall(x,y+(BHeight/2)+1)) {
      //  yVel = 1;
      //  xVel = 0;
      //  //move();
      //}
      nyV = 1;
    }
    
    //setPos(findRow(this.y), findCol(this.x));
    //display();
  }
  
  void move() {
    if(nxV == 1){
      if(!inWall(x+nxV,y, m.blocks[row][col+1]) && x == col*BWidth + (BWidth/2) && y == row*BHeight + (BHeight/2) && m.blocks[row][col+1].type != WALL) {
        xVel = 1;
        yVel = 0;
        nxV = 0;
      }
    }
    
    if(nxV == -1){
      if(!inWall(x+nxV,y, m.blocks[row][col-1]) && x == col*BWidth + (BWidth/2) && y == row*BHeight + (BHeight/2) && m.blocks[row][col-1].type != WALL) {
        xVel = -1;
        yVel = 0;
        nxV = 0;
      }
    }
    
    if(nyV == 1){
      if(!inWall(x,y+nyV, m.blocks[row+1][col]) && x == col*BWidth + (BWidth/2) && y == row*BHeight + (BHeight/2) && m.blocks[row+1][col].type != WALL) {
        yVel = 1;
        xVel = 0;
        nyV = 0;
      }
    }
    if(nyV == -1){
      if(!inWall(x,y+nyV, m.blocks[row-1][col]) && x == col*BWidth + (BWidth/2) && y == row*BHeight + (BHeight/2) && m.blocks[row-1][col].type != WALL) {
        yVel = -1;
        xVel = 0;
        nyV = 0;
      }
    }
    if(inWall(x+xVel,y+yVel)) {
      println("true");
      xVel = 0;
      yVel = 0;
    }
    x += xVel;
    y += yVel;
    setPos(findRow(y),findCol(x));
    println(inWall(x,y,m.blocks[row][col]));
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
} 
