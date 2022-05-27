class Block {
  float xpos, ypos;
  float bwidth, bheight;
  int type;    
  color c;
  
  Block(float x, float y, float in_bwidth, float in_bheight, int in_type, color in_c) {
    xpos = x;
    ypos = y;
    bwidth = in_bwidth;
    bheight = in_bheight;
    type = in_type;
    c = in_c;
  }
  
  void display() {
    noStroke();
    fill(c);
    rect(xpos,ypos,bwidth,bheight);
  }
}
