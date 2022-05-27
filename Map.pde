class Map {
  Block[][] blocks;
  int cols, rows;
  int BWidth, BHeight;
  String[] lines;
  
  Map(String filename) {
    lines = loadStrings(filename);
    cols = lines[0].length();
    rows = lines.length;
    BWidth = width / cols;
    BHeight = height / rows;
    blocks = new Block[rows][cols];
  }
  
  void ReadMap() {
    for(int irow = 0; irow < rows; irow+=1) {
      for(int icol = 0; icol < cols; icol += 1) {
        float xInput, yInput;
        int typeInput;
        color colorInput;
        xInput = BWidth*(icol%cols);
        yInput = BHeight*(irow%rows);
        char ch = lines[irow].charAt(icol);
        if (ch == '#') {//hashtag is wall
          typeInput = WALL;
          colorInput = blue;
          blocks[irow][icol] = new Block(xInput, yInput, BWidth, BHeight, typeInput, colorInput);
        }
        if (ch == '.' || ch == ' ' || ch == 'o' || ch == 'C') {
          typeInput = EMPTY;
          colorInput = black;
          blocks[irow][icol] = new Block(xInput, yInput, BWidth, BHeight, typeInput, colorInput);
        }//. is pellet
        //o is power pellet
        //C is pac man
        if (ch == '=') {
          typeInput = DOOR;
          colorInput = black;
          blocks[irow][icol] = new Block(xInput, yInput, BWidth, BHeight, typeInput, colorInput);
        }
        //= is door
        if (ch == '*') {
          typeInput = SPAWN; 
          colorInput = red;
          blocks[irow][icol] = new Block(xInput, yInput, BWidth, BHeight, typeInput, colorInput);
        }
      }
    }
  }
}
