class zombieClass {
  PImage sheet;
  int sprite, xpos, ypos, health, yspeed, xspeed, zombieCache;
  SoundFile groan, attack;
  boolean[] collision;
  color c = color(0);
  zombieClass(int speed) {
    sheet = loadImage("Sprites/zombie-temp.png");
    xpos = player.xpos;
    ypos = player.ypos;
    sprite = 0;
    yspeed = 1;
    xspeed = speed;
    collision = new boolean[5];
  }
  void collision() {
    for (int i = 0; i < 5; i++) {
      collision[i] = false;
    }
    for (int x = xpos + 25; x <= xpos + 150; x++) {
      for (int y = ypos + 162; y <= ypos + 162 + abs(yspeed); y++) {
        c = bitmap.get(x, y);
        collision[1] = (c == color(255, 0, 0) || c == color(0, 0, 0)) ? true : collision[1]; //This checks the lower bound
        collision[0] = (c == color(0, 0, 255)) ? true : collision[0];
      }
    }
    for (int x = xpos; x <= xpos + 84; x++) {
      for (int y = ypos; y <= ypos - 1 - abs(yspeed); y--) {
        c = bitmap.get(x, y);
        collision[2] = (c == color(0, 0, 0)) ? true : collision[2]; //This checks the upper bound
      }
    }
    for (int x = xpos; x <= xpos - xspeed; x--) {
      for (int y = ypos; y<= ypos + 162; y++) {   
        c = bitmap.get(x, y); 
        collision[3] = (c == color(255, 0, 0) || c == color(0, 0, 0)) ? true : collision[3]; //This checks the left bound
      }
    }
    for (int x = xpos + 84; x <= xpos + 84 + xspeed; x++) { 
      for (int y = ypos; y<= ypos + 162; y++) {   
        c = bitmap.get(x, y); 
        collision[4] = (c == color(0, 0, 0) || c == color(255, 0, 0)) ? true : collision[4]; //This checks the right bound
      }
    }
  }
  void movement() {
    yspeed = (collision[1] == true || collision[2] == true) ? 1 : yspeed + 1;
    if (collision[1] == false) {
      ypos += yspeed;
    }
    if (player.xpos + 50 > xpos) {
      xpos = xpos + xspeed;
    }
    if (player.xpos + 50 < xpos) {
      xpos = xpos - xspeed;
    }
    image(sheet.get(sprite * 84, 0, 84, 162), xpos, ypos);
  }
  void spawn() {
    if (zombieList.length < 8 && zombieCache > 0) {
      zombieCache--;
      append(zombieList, new zombieClass(int(random(1,4))));
    }
  }
}