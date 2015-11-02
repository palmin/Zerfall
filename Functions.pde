void display() {
  background(0);
  fill(200, 190, 180);
  camera(player.xpos + 87, player.ypos + 81, 720 / tan(PI*30.0 / 180.0), player.xpos + 87, player.ypos + 81, 0, 0, 1, 0);
  translate(0, 0, -1);
  shape(background);
  translate(0, 0, 1);
  image(player.sheet[player.sprite], player.xpos, player.ypos);
  //for (zombieClass zombie : zombies) {
  //  image(zombie.sheet.get(zombie.sprite * 100, 0, 100, 162), zombie.xpos, zombie.ypos);
  //}
  image(foreground, 0, 0, width * 2, height * 2);
  printText(str(player.gunClip) + "/" + str(player.clipSize[player.weapon]), int(map(2500, 0, 2560, 0, width)), int(map(1400, 0, 1440, 0, height)), 10, orbitron, 72, #FFFFFF, RIGHT);
  printText(player.gunID[player.weapon], int(map(2500, 0, 2560, 0, width)), int(map(1325, 0, 1440, 0, height)), 10, orbitron, 48, #EEEEEE, RIGHT);
}

void printText(String text, int x, int y, int z, PFont font, int size, color fill, int align) {
  textFont(font);
  textSize(int(map(size, 0, 2560, 0, width)));
  fill(fill);
  textAlign(align);
  pushMatrix();
  camera();
  hint(DISABLE_DEPTH_TEST);
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

void parseBitmap(PImage source, color index) {
  IntList doorx = new IntList();
  IntList doory = new IntList();
  IntList doorx2 = new IntList();
  IntList doory2 = new IntList();
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
    println(doors[0][i], doors[1][i], doors[2][i], doors[3][i]);
  }
  IntList doorx = new IntList();
  IntList doory = new IntList();
  IntList doorx2 = new IntList();
  IntList doory2 = new IntList();
}
