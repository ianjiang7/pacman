class OrangeGhost extends Ghost {
  //scatter: target is bottom left
  //chase: when 8 or more units from Pac-Man, target is Pac-Man
  //chase: if less than 8, target is scatter target
  
  OrangeGhost(int row, int col, int asize) {
    super(row, col, asize,color(255,140,0));
    scatterTarget = new PVector(0, 600);
    nextPos = new PVector(col*BWidth + BWidth/2 - BWidth, row*BHeight + BHeight/2);
    vel = new PVector (-1, 0);
  }
}
