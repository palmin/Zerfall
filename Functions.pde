void printText(String text, int x, int y, int z, PFont font, int size, color fill, int align) {
  textFont(font);
  textSize(int(map(size, 0, 2560, 0, width)));
  fill(fill);
  textAlign(align);
  pushMatrix();
  lights();
  hint(DISABLE_DEPTH_TEST);
  camera();
  text(text, x, y, z);
  popMatrix();
}

class timer {
  float elapsed, start, duration;
  boolean active;
  timer(float d) {
    duration = d;
    start = millis() * .001;
    elapsed = 0;
    active = true;
  }
  void check() {
    elapsed = millis() * .001 - start;
    if (elapsed > duration)
      active = false;
  }
}

void display() {
  background(0);
  fill(200, 190, 180);
  camera(player.xpos + 87, player.ypos + 81, 360 / tan(PI*30.0 / 180.0), player.xpos + 87, player.ypos + 81, 0, 0, 1, 0);
  ambientLight(127, 127, 127);
  if (player.sprite > 3) {
    float xpos = (player.sprite == (6 | 7)) ? player.xpos : player.xpos + 175;
    float ypos = player.ypos + 75;
    fill(255, 255, 127);
    pointLight(255, 127, 0, xpos, ypos, 40);
  }
  translate(0, 0, -1);
  shape(background);
  translate(0, 0, 1);
  image(player.sheet[player.sprite], player.xpos, player.ypos);
  for (zombieClass zombie : zombies) {
    image(zombie.sheet.get(zombie.sprite * 100, 0, 100, 162), zombie.xpos, zombie.ypos);
  }
  image(foreground, 0, 0, width * 2, height * 2);
  printText(str(player.gunClip) + "/" + str(player.clipSize[player.currentWeapon]), int(map(2500, 0, 2560, 0, width)), int(map(1400, 0, 1440, 0, height)), 10, orbitron, 144, #888888, RIGHT);
}