void display() {
  background(0);
  camera(player.xpos + 87, player.ypos + 81, 720 / tan(PI*30.0 / 180.0), player.xpos + 87, player.ypos + 81, 0, 0, 1, 0);
  image(map, 0, 0);
  image(player.sheet[player.sprite], player.xpos, player.ypos);
  for (zombieClass zombie : zombies) {
    image(zombie.sheet.get(zombie.sprite * 100, 0, 100, 162), zombie.xpos, zombie.ypos);
  }
  image(foreground, 0, 0);
  printText(str(player.gunClip) + "/" + str(player.clipSize[player.weapon]), 2500, 1400, 72, #FFFFFF, RIGHT);
  printText(player.gunID[player.weapon], 2500, 1325, 48, #EEEEEE, RIGHT);
  printText(str(int(frameRate)), 10, 30, orbitron, 24, #FFFFFF, LEFT);
}

void printText(String text, int x, int y, PFont font, int size, color fill, int align) {
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
    tempDoor[] = new IntList[4];
  int
    temp[] = new int[4];
  for (temp[0] = 0; temp[0] < source.width; temp[0]++) {
    for (temp[1] = 0; temp[1] < source.height; temp[1]++) {
      if (source.get(temp[0], temp[1]) == index && source.get(temp[0]-1, temp[1]) != index && source.get(temp[0], temp[1]-1) != index) {
        temp[2] = temp[0];
        temp[3] = temp[1];
        while (source.get(temp[2] + 1, temp[3]) == index) {
          temp[2]++;
        }
        while (source.get(temp[2], temp[3] + 1) == index) {
          temp[3]++;
        }
        for (int i = 0; i < 3; i++)
          tempDoor[0].append(temp[0]);
      }
    }
  }
  doors = new int[4][tempDoor[0].size()];
  for (int i = 0; i < tempDoor[0].size(); i++) {
    for (int j = 0; j < 3; j++) {
      doors[j][i] = tempDoor[j].get(i);
    }
  }
  temp = new IntList();
  doorTemp = new IntList();
}
