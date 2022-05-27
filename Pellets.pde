class Pellets {
  Pellet[] pellets;
  int cols, rows;
  int BWidth, BHeight;
  String[] lines;
  int total;
  
  Pellets(String filename) {
    lines = loadStrings(filename);
    cols = lines[0].length();
    rows = lines.length;
    total = 0;
    BWidth = width / cols;
    BHeight = height / rows;
    for(int irow = 0; irow < rows; irow+=1) {
      for(int icol = 0; icol < cols; icol += 1) {
        if(lines[irow].charAt(icol) == '.' || lines[irow].charAt(icol) == 'o')
          total++;
        }
    }
    pellets = new Pellet[total];
  }
  
  void ReadFile() {
    int n = 0;
    for(int irow = 0; irow < rows; irow+=1) {
      for(int icol = 0; icol < cols; icol += 1) {
        int xInput, yInput;
        xInput = BWidth*(icol%cols) + BWidth/2;
        yInput = BHeight*(irow%rows) + BHeight/2;
        char ch = lines[irow].charAt(icol);
        
        if(ch == '.') {
          pellets[n] = new Pellet(xInput,yInput,diameter);
          n++;
        }
        if(ch == 'o') {
          pellets[n] = new PowerPellet(xInput,yInput,diameter);
          n++;
        }
      }
    }
  }
  
  void display() {
    for(int i = 0;i < pellets.length;i++) {
      pellets[i].display();
    }
  }
  
}
