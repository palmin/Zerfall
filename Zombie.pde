class zombieClass {
  PImage sheet;
  int sprite, xpos, ypos, health, yspeed;
  boolean[] collision;
  color c = color(0);
  zombieClass(int health, int spawnx, int spawny) {
    sheet = loadImage("Sprites/temp-zombie.png");
    sprite = 0;
    yspeed = 1;
    collision = new boolean[5];
  }
  void collision() {
    for (int i = 0; i < 5; i++) {
      collision[i] = false;
    }
    for (int x = xpos + 25; x <= xpos + 150; x++) {
      for (int y = ypos + 161; y <= ypos + 162 + abs(yspeed); y++) {
        c = bitmap.get(x, y);
        collision[1] = (c == color(255, 0, 0) || c == color(0, 0, 0)) ? true : collision[1]; //This checks the lower bound
        collision[0] = (c == color(0, 0, 255)) ? true : collision[0];
      }
    }
    for (int x = xpos + 25; x <= xpos + 150; x++) {
      for (int y = ypos; y <= ypos - 1 - abs(yspeed); y--) {
        c = bitmap.get(x, y);
        collision[2] = (c == color(0, 0, 0)) ? true : collision[2]; //This checks the upper bound
      }
    }
    if (keys[0] == true || keys[4] == true) {
      for (int x = xpos + 20; x <= xpos + 25; x++) {
        for (int y = ypos; y<= ypos + 161; y++) {   
          c = bitmap.get(x, y); 
          collision[3] = (c == color(255, 0, 0) || c == color(0, 0, 0)) ? true : collision[3]; //This checks the left bound
        }
      }
    }
    for (int x = xpos + 150; x <= xpos + 155; x++) { 
      for (int y = ypos; y<= ypos + 161; y++) {   
        c = bitmap.get(x, y); 
        collision[4] = (c == color(0, 0, 0) || c == color(255, 0, 0)) ? true : collision[4]; //This checks the right bound
      }
    }
  }
  void movement() {
    if (collision[3] == false) {
      xpos -= 5;
    }
    if (collision[4] == false) {
      xpos += 5;
    }
    if (collision[1] == true && collision[2] == false) {
      yspeed = -10;
      collision[1] = false;
    }
    if (collision[0] == true && collision[2] == false) {
      yspeed = -4;
      collision[1] = false;
    }
    if (collision[2] == true) {
      yspeed = 1;
    }
    yspeed = (collision[1] == true || collision[2] == true) ? 1 : yspeed + 1;
    if (collision[1] == false) {
      ypos += yspeed;
    }
    image(sheet.get(sprite * 175, 0, 175, 161), xpos, ypos);
  }
}