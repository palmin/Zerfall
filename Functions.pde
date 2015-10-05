void printText(String text, int x, int y, int z, PFont font, int size, color fill, int align) {
  textFont(font, size);
  fill(fill);
  textAlign(align);
  text(text, x, y, z);
}

public void timerInit(float d, int identifier) { //Initializes the timer
  time = 60 * minute() + second() + (millis() * .0001);
  start = 60 * minute() + second() + (millis() * .0001);
  duration = d;
  timer[identifier] = true;
}

void timer(int identifier) { //Runs the timer
  time = 60 * minute() + second() + (millis() * .0001);
  if (time - start >= duration) {
    timer[identifier] = false;
  }
}

public void HUD() {
  printText(str(player.gunClip) + "/" + str(player.clipSize[player.currentWeapon]), 2500, 1400, 10, orbitron, 72, #888888, RIGHT);
}

void display() {
  background(0);
  fill(200, 190, 180);
  camera(player.xpos, player.ypos, 623.5, player.xpos, player.ypos, 0, 0, 1, 0);
  ambientLight(127, 127, 127);
  //shader(shader, TRIANGLE);
  if (gunFlare == true) {
    float xpos = (player.sprite == (2 | 3 | 6 | 7)) ? player.xpos : player.xpos + 175;
    float ypos = player.ypos + 75;
    pointLight(255, 127, 0, xpos, ypos, 20);
    gunFlare = false;
  } else {
  }
  translate(0, 0, -1);
  shape(background);
  translate(0, 0, 1);
  image(player.sheet.get(player.sprite * 175, 0, 175, 161), player.xpos, player.ypos);
  image(foreground, 0, 0);
  fill(255);
  noStroke();
  text(time, 500, 161);
  text(start, 500, 261);
  text(duration, 500, 361);
  resetShader();
}