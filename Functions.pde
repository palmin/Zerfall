class timer {
  timer(float d, int identifier) {
    timerInfo[1][identifier] = 60 * minute() + second() + (millis() * .0001);
    timerInfo[0][identifier] = 60 * minute() + second() + (millis() * .0001);
    timerInfo[2][identifier] = d;
    timer[identifier] = true;
  }
}

void printText(String text, int x, int y, int z, PFont font, int size, color fill, int align) {
  textFont(font);
  textSize(int(map(size, 0, 5120, 0, width)));
  fill(fill);
  textAlign(align);
  text(text, x, y, z);
}
void timer(float d, int identifier) { //Initializes the timer
  if (d < 0) {
    timerInfo[1][identifier]= 60 * minute() + second() + (millis() * .0001);
    if (timerInfo[1][identifier]- timerInfo[0][identifier] >= timerInfo[2][identifier]) {
      timer[identifier] = false;
    }
  }
}

void timer(int identifier) { //Runs the timer
  timer(-1, identifier);
}

void display() {
  background(0);
  fill(200, 190, 180);
  camera(player.xpos, player.ypos, 623.5, player.xpos, player.ypos, 0, 0, 1, 0);
  ambientLight(127, 127, 127);
  if (player.sprite > 3) {
    float xpos = (player.sprite == (2 | 3 | 6 | 7)) ? player.xpos : player.xpos + 175;
    float ypos = player.ypos + 75;
    fill(255, 255, 127);
    pointLight(255, 127, 0, xpos, ypos, 40);
  } else {
  }
  translate(0, 0, -1);
  shape(background);
  translate(0, 0, 1);
  image(player.sheet.get(player.sprite * 175, 0, 175, 161), player.xpos, player.ypos);
  for (zombieClass zombie : zombies) {
    image(zombie.sheet.get(zombie.sprite * 100, 0, 100, 162), zombie.xpos, zombie.ypos);
  }
  image(foreground, 0, 0);
  fill(255);
  noStroke();
  pushMatrix();
  lights();
  hint(DISABLE_DEPTH_TEST);
  camera();
  textMode(MODEL);
  translate(0, 0, 5);
  int x = int(map(2500, 0, 2560, 0, width));
  int y = int(map(1400, 0, 1440, 0, height));
  printText(str(player.gunClip) + "/" + str(player.clipSize[player.currentWeapon]), x, y, 10, orbitron, 144, #888888, RIGHT);
  popMatrix();
}