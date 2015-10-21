void printText(String text, int x, int y, int z, PFont font, int size, color fill, int align) {
  textFont(font);
  textSize(int(map(size, 0, 5120, 0, width)));
  fill(fill);
  textAlign(align);
  text(text, x, y, z);
}
class timer {
  float duration, elapsed, start;
  timer(float duration) {
    start = 60 * minute() + second() + (millis() * .0001);
    elapsed = 60 * minute() + second() + (millis() * .0001);
  }
  void check() {
    elapsed = 60 * minute() + second() + (millis() * .0001);
  }
}

void display() {
  background(0);
  fill(200, 190, 180);
  camera(player.xpos, player.ypos, 623.5, player.xpos + 87, player.ypos + 81, 0, 0, 1, 0);
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
  translate(0, 0, 5);
  int x = int(map(2500, 0, 2560, 0, width));
  int y = int(map(1400, 0, 1440, 0, height));
  printText(str(player.gunClip) + "/" + str(player.clipSize[player.currentWeapon]), x, y, 10, orbitron, 144, #888888, RIGHT);
  popMatrix();
}
