void display() {
  background(0);
  translate(-(player.xpos + player.sheet[0].width / 2) + width / 2, -(player.ypos + player.sheet[0].height / 2) + height / 2);
  image(map, 0, 0);
  image(player.sheet[player.sprite], player.xpos, player.ypos);
  for (zombieClass zombie : zombies)
    image(zombie.sheet.get(zombie.sprite * 100, 0, 100, 162), zombie.xpos, zombie.ypos);
  image(foreground, 0, 0);
  printText(str(player.gunClip) + "/" + str(player.clipSize[player.weapon]), 1270, 700, 36, #FFFFFF, RIGHT);
  printText(player.gunID[player.weapon], 1270, 660, 24, #EEEEEE, RIGHT);
  printText(int(frameRate), 10, 30, 24, #FFFFFF, LEFT);
  //printText(str(player.collision[0]) + ", " + str(player.collision[1]) + ", " + str(player.collision[2]) + ", " + str(player.collision[3]) + ", " + str(player.collision[4]), 1000, 30, 24, #EEEEEE, LEFT);
}

void printText(String text, int x, int y, int size, color fill, int align) {
  textSize(size);
  fill(fill);
  textAlign(align);
  text(text, x, y);
}

void printText(int text, int x, int y, int size, color fill, int align) {
  printText(str(text), x, y, size, fill, align);
}

class timer {
  float
    activation,
    duration;
  boolean 
    active;
  void check() {
    if (millis() - activation > duration)
      active = false;
  }
  void activate() {
    activation = millis();
    active = true;
  }
  void set(float d) {
    duration = d;
  }
}
