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
  printText(str(int(frameRate)), 10, 30, 24, #FFFFFF, LEFT);
  printText(str(player.collision[0]) + ", " + str(player.collision[1]) + ", " + str(player.collision[2]) + ", " + str(player.collision[3]) + ", " + str(player.collision[4]), 1000, 30, 24, #EEEEEE, LEFT);
}

void printText(String text, int x, int y, int size, color fill, int align) {
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

void parseBitmap(PImage source, color index) {
  final IntList[]
    tempDoor = new IntList[4];
  for (int i = 0; i < 3; i++)
  tempDoor[i] = new IntList();
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
          tempDoor[i].append(temp[i]);
      }
    }
  }
  doors = new int[4][tempDoor[0].size()];
  for (int i = 0; i < tempDoor[0].size(); i++) {
    for (int j = 0; j < 3; j++) {
      doors[j][i] = tempDoor[j].get(i);
    }
  }
  temp = new int[0];
}
