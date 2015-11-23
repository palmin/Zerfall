void display() {
  background(0);
  //clip((player.xpos + player.sheet[0].width / 2) - width / 2, (player.ypos + player.sheet[0].height / 2) - height / 2, width, height);
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      set(x, y, bitmap.get(x, y));
    }
  }
  translate(-(player.xpos + player.sheet[0].width / 2) + width / 2, -(player.ypos + player.sheet[0].height / 2) + height / 2);
  image(player.sheet[player.sprite], player.xpos, player.ypos);
  for (zombieClass zombie : zombies)
    image(zombie.sheet.get(zombie.sprite * 100, 0, 100, 162), zombie.xpos, zombie.ypos);
  //image(foreground, 0, 0);
  printText(str(player.gunClip) + "/" + str(player.clipSize[player.weapon]), 1270, 700, 36, #FFFFFF, RIGHT);
  printText(player.gunID[player.weapon], 1270, 660, 24, #EEEEEE, RIGHT);
  printText(round(frameRate), 10, 30, 24, #FFFFFF, LEFT);
}

void printText(String text, int x, int y, int size, color fill, int align) {
  translate((player.xpos + player.sheet[0].width / 2) + width / 2, (player.ypos + player.sheet[0].height / 2) + height / 2);
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