class playerClass {
  PImage sheet;
  int spriteDim, sprite, xpos, ypos, yspeed, door[], i, l;
  boolean[] collision;
  color c = color(0);
  playerClass() {
    sheet = loadImage("Sprites/player.png");
    xpos = 1136;
    ypos = 470;
    sprite = 0;
    yspeed = 1;
    collision = new boolean[5];
    door = new int[2];
  }
  void collision() {
    for (int i = 0; i < 5; i++) {
      collision[i] = false;
    }
    door[0] = door[1] = -1;
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
          if (c == color(255, 0, 0) && keys[4] == true) {
            door[0] = x;
            door[1] = y;
          }
        }
      }
    }
    if (keys[1] == true || keys[4] == true) {
      for (int x = xpos + 150; x <= xpos + 155; x++) { 
        for (int y = ypos; y<= ypos + 161; y++) {   
          c = bitmap.get(x, y); 
          collision[4] = (c == color(0, 0, 0) || c == color(255, 0, 0)) ? true : collision[4]; //This checks the right bound
          if (c == color(255, 0, 0) && keys[4] == true) {
            door[0] = x;
            door[1] = y;
          }
        }
      }
    }
  }
  void doors() {
    l = -1;
    for (i = 0; i <= 20; i += 4) {
      if (door[0] >= doors[i] && door[0] <= doors[i + 2] && door[1] >= doors[i + 1] && door[1] <= doors[i + 3]) {
        l = i;
        break;
      }
    }
    for (int x = doors[l]; x <= doors[l + 2]; x++) { 
      for (int y = doors[l + 1]; y < doors[l + 3]; y++) {
        bitmap.set(x, y, color(255));
      }
    }
  }
  void movement() {
    if (keys[0] == true && collision[3] == false) {
      xpos -= 5;
      sprite = (collision[1] == true) ? 0 : sprite;
    }
    if (keys[1] == true && collision[4] == false) {
      xpos += 5;
      sprite = (collision[1] == true) ? 2 : sprite;
    }
    if (keys[2] == true && collision[1] == true && collision[2] == false) {
      yspeed = -10;
      collision[1] = false;
      sprite += (sprite % 2 == 0) ? 1 : 0;
    }
    if (collision[0] == true && keys[2] == true && collision[2] == false) {
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