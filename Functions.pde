void printText(String text, int x, int y, 
  PFont font, int size, color fill, int align) {
  textFont(font, size);
  fill(fill);
  textAlign(align);
  text(text, x, y);
}

void timerInit(int d, int identifier) { //Initializes the timer
  time = second();
  start = second();
  duration = d;
  r[identifier] = true;
}

void timer(int identifier) { //Runs the timer
  time = second();
  if (time - start >= duration) {
    r[identifier] = false;
  }
}

public void lighting() {
  fill(255, 255, 255);
  ambientLight(127,127,127);
  if (gunFlare == true) {
    float xpos = (player.sprite == (0 | 1 | 4 | 5)) ? player.xpos + 150 : player.xpos + 25;
    float ypos = player.ypos + 75;
    spotLight(255, 255, 0, xpos, ypos, 400, 0, 0, -1, PI/16, 3);
    gunFlare = false;
  }
}

public void HUD() {
  printText(str(player.gunClip) + "/" + str(player.clipSize[player.currentWeapon]), 2500, 1400, orbitron, 72, #777777, RIGHT);
}