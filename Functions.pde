void printText(String text, int x, int y, 
  PFont font, int size, color fill, int align) {
  textFont(font, size);
  fill(fill);
  textAlign(align);
  text(text, x, y);
}

void timerInit(int d, int identifier) { //Initializes the timer
  time = second();
  start = second();
  duration = d;
  r[identifier] = true;
}

void timer(int identifier) { //Runs the timer
  time = second();
  if (time - start >= duration) {
    r[identifier] = false;
  }
}

void lighting() {
  fill(200, 200, 200);
  if (gunFlare == true) {
    float xpos = (player.sprite == (0 | 1 | 4 | 5)) ? player.xpos + 25 : player.xpos + 150;
    float ypos = 75;
    spotLight(255, 200, 0, xpos, ypos, 50, xpos, ypos, 0, 15, 2);
    gunFlare = false;
  }
  ambientLight(127,127,127, width/2, height/2, 10);
}
