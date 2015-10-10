void printText(String text, int x, int y, int z, PFont font, int size, color fill, int align) {
  textFont(font, size);
  fill(fill);
  textAlign(align);
  text(text, x, y, z);
}
void timer(float d, int identifier) { //Initializes the timer
  if (d == -PI) {
    timerInfo[1][identifier]= 60 * minute() + second() + (millis() * .0001);
    if (timerInfo[1][identifier]- timerInfo[0][identifier] >= timerInfo[2][identifier]) {
      timer[identifier] = false;
    }
  } else {
    timerInfo[1][identifier] = 60 * minute() + second() + (millis() * .0001);
    timerInfo[0][identifier] = 60 * minute() + second() + (millis() * .0001);
    timerInfo[2][identifier] = d;
    timer[identifier] = true;
  }
}

void timer(int identifier) { //Runs the timer
  timer(-PI, identifier);
}

void HUD() {
  pushMatrix();
  lights();
  hint(DISABLE_DEPTH_TEST);
  camera();
  textMode(MODEL);
  translate(0, 0, 5);
  printText(str(player.gunClip) + "/" + str(player.clipSize[player.currentWeapon]), 2500, 1400, 10, orbitron, 72, #888888, RIGHT);
  popMatrix();
}

void display() {
  background(0);
  fill(200, 190, 180);
  camera(player.xpos, player.ypos, 623.5, player.xpos, player.ypos, 0, 0, 1, 0);
  ambientLight(127, 127, 127);
  shader(shader, TRIANGLE);
  if (player.sprite > 3) {
    float xpos = (player.sprite == (2 | 3 | 6 | 7)) ? player.xpos : player.xpos + 175;
    float ypos = player.ypos + 75;
    fill(255, 255, 127);
    pointLight(255, 127, 0, xpos, ypos, 20);
  } else {
  }
  translate(0, 0, -1);
  shape(background);
  translate(0, 0, 1);
  image(player.sheet.get(player.sprite * 175, 0, 175, 161), player.xpos, player.ypos);
  image(foreground, 0, 0);
  fill(255);
  noStroke();
  resetShader();
}