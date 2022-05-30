class PacMan {
  //starting pos: row 21, col 14
  //fill(200, 200, 0);
  //circle(14*BWidth +BWidth/2, 21*BHeight + BHeight/2, 10);
  
  int x, y, size;
  //size just needs to be switched to width and height when we replace the circle with PImage
  
  PacMan(int row, int col, int asize) {
    x = col*BWidth + BWidth/2;
    y = row*BHeight + BHeight/2;
    size = asize;
  }
  
  void display() {
    fill(255, 255, 0);
    circle(x, y, size);
  }
  
  void keyPressed() {
    if (keyCode == LEFT) {
      x -= 1;
    }
    if (keyCode == RIGHT) {
      x+=1;
    }
    if(keyCode == UP) {
      y-=1;
    }
    if(keyCode == DOWN) {
      y+=1;
    }
    display();
  }
}
