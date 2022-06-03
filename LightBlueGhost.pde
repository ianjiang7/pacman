class LightBlueGhost extends Ghost {
  //scatter: target is bottom right
  //chase: target is two units in front of Pac-Man and then the vector from this tile to red's is rotated 180 degrees and resulting pos is blue's target
  LightBlueGhost(int row, int col, int asize) {
    super(row, col, asize,color(130,200,255));
    scatterTarget = new PVector(600, 600);
  }
}
