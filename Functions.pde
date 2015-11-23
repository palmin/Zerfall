void display() {
  background(0);
  clip(0, 0, width, height);
  pushMatrix();
  translate(-(player.xpos + player.sheet[0].width / 2) + width / 2, -(player.ypos + player.sheet[0].height / 2) + height / 2);
  image(map, 0, 0);
  image(player.sheet[player.sprite], player.xpos, player.ypos);
  for (zombieClass zombie : zombies)
    image(zombie.sheet.get(zombie.sprite * 100, 0, 100, 162), zombie.xpos, zombie.ypos);
  image(foreground, 0, 0);
  translate(player.xpos + player.sheet[0].width / 2, player.ypos + player.sheet[0].height / 2);
  popMatrix();
  printText(str(player.gunClip) + "/" + str(player.clipSize[player.weapon]), 1270, 700, 36, #FFFFFF, RIGHT);
  printText(player.gunID[player.weapon], 1270, 660, 24, #EEEEEE, RIGHT);
  printText(round(frameRate), 10, 30, 24, #FFFFFF, LEFT);
}

void printText(String text, int x, int y, int size, color fill, int align) {
  textSize(size * round(height / 720));
  fill(fill);
  textAlign(align);
  text(text, map(x, 0, 1280, 0, width), map(y, 0, 720, 0, height));
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
  timer(float d) {
    duration = d;
  }
  void check() {
    if (millis() * .001 - activation > duration)
      active = false;
  }
  void activate() {
    activation = millis() * .001;
    active = true;
  }
  void set(float d) {
    duration = d;
  }
}