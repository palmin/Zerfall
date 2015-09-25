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
  fill(127, 127, 127);
  if (gunFlare == true) {
    pointLight(255, 127, 0, player.xpos, player.ypos + 84, 100);
    gunFlare = false;
  }
  ambientLight(127,127,127, width/2, height/2, 10);
}