class Map {
  Block[][] blocks;
  int cols, rows;
  int BWidth, BHeight;
  
  void ReadMap(String filename) {
    String[] lines = loadStrings(filename);
    cols = lines[0].length();
    rows = lines.length;
    BWidth = width / cols;
    BHeight = height / rows;
    
    blocks = new Block[rows][cols];
    for(int irow = 0; irow < rows; irow+=1) {
      for(int icol = 0; icol < cols; icol += 1) {
        float xInput, yInput;
        int typeInput;
        color colorInput;
        xInput = BWidth*(icol%cols);
        yInput = BHeight*(irow%rows);
        
        if (lines[irow].charAt(icol) == '#') {//hashtag is wall
          typeInput = WALL;
          
        }
        //. is pellet
        //o is power pellet
        //C is pac man
        //= is door
      }
    }
  }
}
