class zombieClass {
  PImage
    sheet = new PImage();
  int
    sprite = 0, 
    xpos = 2270, 
    ypos = 940, 
    health = 100, 
    yspeed = 1, 
    xspeed = speed;
  boolean
    collision[] = new boolean[5];
  zombieClass(int speed) {
    sheet = loadImage("Sprites/zombie.png");
  }
  void movement() {
    for (int i = 0; i < 5; i++)
      collision[i] = false;
    for (int x = xpos; x <= xpos + 100; x++) {
      for (int y = ypos + 161; y <= ypos + 161 + abs(yspeed); y++) {
        color c = bitmap.get(x, y);
        collision[1] = (c == color(255, 0, 0) || c == color(0, 0, 0)) ? true : collision[1]; //This checks the lower bound
        collision[0] = (c == color(0, 0, 255)) ? true : collision[0];
      }
    }
    for (int x = xpos; x <= xpos + 100; x++) {
      for (int y = ypos; y <= ypos - 1 - abs(yspeed); y--) {
        color c = bitmap.get(x, y);
        collision[2] = (c == color(0, 0, 0)) ? true : collision[2]; //This checks the upper bound
      }
    }
    for (int x = xpos; x <= xpos - xspeed; x--) {
      for (int y = ypos; y<= ypos + 162; y++) {   
        color c = bitmap.get(x, y); 
        collision[3] = (c == color(255, 0, 0) || c == color(0, 0, 0)) ? true : collision[3]; //This checks the left bound
      }
    }
    for (int x = xpos + 100; x <= xpos + 100 + xspeed; x++) { 
      for (int y = ypos; y<= ypos + 162; y++) {   
        color c = bitmap.get(x, y); 
        collision[4] = (c == color(0, 0, 0) || c == color(255, 0, 0)) ? true : collision[4]; //This checks the right bound
      }
    }
    if (collision[1] == true || collision[2] == true) {
      yspeed = 1;
    } else {
      yspeed++;
    }
    if (collision[0] == true && player.ypos < ypos && collision[2] == false) {
      yspeed = -xspeed;
      collision[1] = false;
    }
    if (collision[1] == false)
      ypos += yspeed;
    if (player.xpos > xpos && player.ypos > ypos - 40 && player.ypos < ypos + 40) {
      xpos = xpos + xspeed;
      sprite = 1;
    } else if (player.xpos + 50 < xpos && player.ypos > ypos - 5 && player.ypos < ypos + 5) {
      xpos = xpos - xspeed;
      sprite = 0;
    }
  }
}
