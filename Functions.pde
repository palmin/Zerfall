void display() {
  background(0);
  translate(-(player.xpos + player.sheet[0].width / 2), -(player.ypos + player.sheet[0].height / 2));
  image(map, 0, 0);
  image(player.sheet[player.sprite], player.xpos, player.ypos);
  for (zombieClass zombie : zombies) {
    image(zombie.sheet.get(zombie.sprite * 100, 0, 100, 162), zombie.xpos, zombie.ypos);
  }
  image(foreground, 0, 0);
  printText(str(player.gunClip) + "/" + str(player.clipSize[player.weapon]), 2500, 1400, 72, #FFFFFF, RIGHT);
  printText(player.gunID[player.weapon], 2500, 1325, 48, #EEEEEE, RIGHT);
  printText(str(int(frameRate)), 10, 30, 24, #FFFFFF, LEFT);
  printText(str(player.collision[0]) + ", " + str(player.collision[1]) + ", " + str(player.collision[2]) + ", " + str(player.collision[3]) + ", " + str(player.collision[4]), 1000, 30, 24, #EEEEEE, LEFT);
}

void printText(String text, int x, int y, int size, color fill, int align) {
  textSize(int(map(size, 0, 2560, 0, width)));
  fill(fill);
  textAlign(align);
  pushMatrix();
  text(text, map(x, 0, 2560, 0, width), map(y, 0, 1440, 0, height), 5);
  popMatrix();
}

class timer {
  float activate, duration;
  boolean active;
  void check() {
    if (millis() - activate > duration)
      active = false;
  }
  void activate(float d) {
    duration = d;
    activate = millis();
    active = true;
  }
}
