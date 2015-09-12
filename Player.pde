class playerClass {
  PImage sheet;
  int sprite, xpos, ypos, yspeed, doorx, doory, l;
  boolean[] collision;
  color c = color(0, 0, 0);
  playerClass() {
    sheet = loadImage("player-sheet.png");
    xpos = 1136;
    ypos = 470;
    sprite = 0;
    doorx = -1;
    doory = -1;
    yspeed = 1;
    collision = new boolean[5];
  }
  void collision() {
    for (int i = 0; i < 5; i++) {
      collision[i] = false;
    }
    doorx = doory = -1;
    for (int x = xpos + 25; x <= xpos + 150; x++) {
      for (int y = ypos + 161; y <= ypos + 162 + abs(yspeed); y++) {
        c = bitmap.get(x, y);
        collision[1] = (c == color(255, 0, 0) || c == color(0, 0, 0)) ? true : collision[1];
        collision[0] = (c == color(0, 0, 255)) ? true : collision[0];
      }
    }
    for (int x = xpos + 25; x <= xpos + 150; x++) {
      for (int y = ypos; y <= ypos - 1 - abs(yspeed); y++) {
        c = bitmap.get(x, y);
        collision[1] = (c == color(255, 0, 0) || c == color(0, 0, 0)) ? true : collision[1];
      }
    }
    if (keys[0] == true) {
      for (int x = xpos + 20; x <= xpos + 25; x++) {
        for (int y = ypos; y<= ypos + 161; y++) {   
          color c = bitmap.get(x, y); 
          collision[3] = (c == color(255, 0, 0) || c == color(0, 0, 0)) ? true : collision[3];
          if (c == color(255, 0, 0) && keys[4] == true) {
            doorx = x;
            doory = y;
          }
        }
      }
    }
    if (keys[1] == true) {
      for (int x = xpos + 150; x <= xpos + 155; x++) {
        for (int y = ypos; y<= ypos + 161; y++) {   
          color c = bitmap.get(x, y); 
          collision[4] = (c == color(0, 0, 0) || c == color(255, 0, 0)) ? true : collision[4];
          if (c == color(255, 0, 0) && keys[4] == true) {
            doorx = x;
            doory = y;
          }
        }
      }
    }
  }
  void doors() {
    for (int i = 0; i <=20; i += 4) {
      if (doorx >= doors[i] && doorx <= doors[i + 2] && doory >= doors[i + 1] && doory <= doors[i + 3]) {
        l = i;
        break;
      }
    }
    for (int x = doors[l]; x <= doors[l + 2]; x ++) {
      for (int y = doors[l + 1]; y <= doors[l + 3]; y++) {
        bitmap.set(x, y, color(255));
      }
    }
  }
  void display() {
    image(bitmap.get(xpos, ypos, 175, 161), xpos, ypos);
    if (keys[0] == true && collision[3] == false) {
      xpos -= 5;
      sprite = (collision[1] == true) ? 0 : sprite;
    }
    if (keys[1] == true && collision[4] == false) {
      xpos += 5;
      sprite = (collision[1] == true) ? 2 : sprite;
    }
    if (keys[2] == true && collision[1] == true) {
      yspeed = -10;
      collision[1] = false;
      sprite += (sprite % 2 == 0) ? 1 : 0;
    }
    if (collision[1] == false) {
      ypos += yspeed;
      yspeed ++;
    }
    if (collision[0] == true && keys[2] == true) {
      yspeed = -4;
      ypos -= 7;
    }
    yspeed = (collision[1] == true) ? 1 : yspeed;
    image(sheet.get(sprite * 175, 0, 175, 161), xpos, ypos);
  }
}