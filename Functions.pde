void display() {
  background(0);
  camera(player.xpos + 87, player.ypos + 81, 720 / tan(PI*30.0 / 180.0), player.xpos + 87, player.ypos + 81, 0, 0, 1, 0);
  image(map, 0, 0);
  image(player.sheet[player.sprite], player.xpos, player.ypos);
  for (zombieClass zombie : zombies) {
    image(zombie.sheet.get(zombie.sprite * 100, 0, 100, 162), zombie.xpos, zombie.ypos);
  }
  image(foreground, 0, 0);
  printText(str(player.gunClip) + "/" + str(player.clipSize[player.weapon]), 2500, 1400, orbitron, 72, #FFFFFF, RIGHT);
  printText(player.gunID[player.weapon], 2500, 1325, orbitron, 48, #EEEEEE, RIGHT);
  printText(str(player.collision[0]) + ", " + str(player.collision[1]) + ", " + str(player.collision[2]) + ", " + str(player.collision[3]) + ", " + str(player.collision[4]), 1000, 30, orbitron, 24, #EEEEEE, LEFT);
  printText(str(int(frameRate)), 10, 30, orbitron, 24, #FFFFFF, LEFT);
}

void printText(String text, int x, int y, PFont font, int size, color fill, int align) {
  textFont(font);
  textSize(int(map(size, 0, 2560, 0, width)));
  fill(fill);
  textAlign(align);
  pushMatrix();
  camera();
  hint(DISABLE_DEPTH_TEST);
  text(text, map(x, 0, 2560, 0, width), map(y, 0, 1440, 0, height), 5);
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

void parseBitmap(PImage source, color index) {
  IntList
  doorx = new IntList(),
  doory = new IntList(),
  doorx2 = new IntList(),
  doory2 = new IntList();
  for (int x = 0; x < source.width; x++) {
    for (int y = 0; y < source.height; y++) {
      if (source.get(x, y) == index && source.get(x-1, y) != index && source.get(x, y-1) != index) {
        int x2 = x;
        int y2 = y;
        while (source.get(x2 + 1, y2) == index) {
          x2++;
        }
        while (source.get(x2, y2 + 1) == index) {
          y2++;
        }
        doorx.append(x);
        doory.append(y);
        doorx2.append(x2);
        doory2.append(y2);
      }
    }
  }
  doors = new int[4][doorx.size()];
  for (int i = 0; i < doorx.size(); i++) {
    doors[0][i] = doorx.get(i);
    doors[1][i] = doory.get(i);
    doors[2][i] = doorx2.get(i);
    doors[3][i] = doory2.get(i);
  }
  doorx = new IntList();
  doory = new IntList();
  doorx2 = new IntList();
  doory2 = new IntList();
}