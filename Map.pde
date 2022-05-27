class Map {
  Block[][] blocks;
  int Cols, Rows;
  int BWidth, BHeight;
  
  void ReadMap(String filename) {
    String[] lines = loadStrings(filename);
    Cols = lines[0].length();
    Rows = lines.length;
    BWidth = width / Cols;
    BHeight = height / Rows;
  }
}
