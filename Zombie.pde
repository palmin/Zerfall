class zombieClass {
  PImage sheet;
  int sprite, xpos, ypos, playerx, playery, health, yspeed, xspeed, zombieCache;
  boolean[] collision;
  color c = color(0);
  zombieClass(int speed) {
    sheet = loadImage("Sprites/zombie.png");
    xpos = player.xpos;
    ypos = player.ypos;
    sprite = 0;
    yspeed = 1;
    xspeed = speed;
    collision = new boolean[5];
  }
  void movement() {
    for (int i = 0; i < 5; i++) {
      collision[i] = false;
    }
    playerx = player.xpos + 25;
    playery = player.ypos;
    for (int x = xpos; x <= xpos + 100; x++) {
      for (int y = ypos + 161; y <= ypos + 161 + abs(yspeed); y++) {
        c = bitmap.get(x, y);
        collision[1] = (c == color(255, 0, 0) || c == color(0, 0, 0)) ? true : collision[1]; //This checks the lower bound
        collision[0] = (c == color(0, 0, 255)) ? true : collision[0];
      }
    }
    for (int x = xpos; x <= xpos + 100; x++) {
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
    for (int x = xpos + 100; x <= xpos + 100 + xspeed; x++) { 
      for (int y = ypos; y<= ypos + 162; y++) {   
        c = bitmap.get(x, y); 
        collision[4] = (c == color(0, 0, 0) || c == color(255, 0, 0)) ? true : collision[4]; //This checks the right bound
      }
    }
    yspeed = (collision[1] == true || collision[2] == true) ? 1 : yspeed + 1;
    if (collision[0] == true && playery < ypos && collision[2] == false) {
      yspeed = -xspeed;
      collision[1] = false;
    }
    if (collision[1] == false) {
      ypos += yspeed;
    }
    if (playerx > xpos && playery > ypos - 40 && playery < ypos + 40) {
      xpos = xpos + xspeed;
      sprite = 1;
    } else if (playerx + 50 < xpos && playery > ypos - 5 && playery < ypos + 5) {
      xpos = xpos - xspeed;
      sprite = 0;
    }
  }
  void spawn() {
    if (zombieCache > 0 && zombie.health <= 0) {
      zombie = new zombieClass(int(random(1,3)));
    }
  }
}
