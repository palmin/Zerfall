void printText(String text, int x, int y, 
  PFont font, int size, color fill, int align) {
  textFont(font, size);
  fill(fill);
  textAlign(align);
  text(text, x, y);
}

public void timerInit(int d, int identifier) { //Initializes the timer
  time = second();
  start = second();
  duration = d;
  timer[identifier] = true;
}

void timer(int identifier) { //Runs the timer
  time = second();
  if (time - start >= duration) {
    timer[identifier] = false;
  }
}

public void HUD() {
  printText(str(player.gunClip) + "/" + str(player.clipSize[player.currentWeapon]), 2500, 1400, orbitron, 72, #888888, RIGHT);
}

void display() {
  fill(255, 255, 255);
  ambientLight(205, 175, 155);
  if (gunFlare == true) {
    float xpos = (player.sprite == (0 | 1 | 4 | 5)) ? player.xpos + 25 : player.xpos + 150;
    float ypos = player.ypos + 75;
    spotLight(255, 127, 0, xpos, ypos, 800, 0, 0, -1, PI/16, 1);
    //pointLight(255, 127, 0, xpos, ypos, 40);
    gunFlare = false;
  }
  image(map, 0, 0);
  image(map.get(player.xpos - 20, player.ypos - 20, 215, 201), player.xpos - 20, player.ypos - 20);
  image(player.sheet.get(player.sprite * 175, 0, 175, 161), player.xpos, player.ypos);
  image(foreground, 0, 0);
}