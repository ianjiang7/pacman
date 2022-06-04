class PinkGhost extends Ghost {
  //scatter: target is upper left
  //chase: target is four tiles in front of Pac-Man
  PinkGhost(int row, int col, int asize) {
    super(row, col, asize,color(230,140,255));
    scatterTarget = new PVector(0, 0);
    nextPos.y = row*BHeight + BHeight/2 - 2 * BHeight;
  }
}  
