void printText(String text, int x, int y, int z, PFont font, int size, color fill, int align) {
  textFont(font);
  textSize(int(map(size, 0, 2560, 0, width)));
  fill(fill);
  textAlign(align);
  text(text, x, y, z);
}

class timer {
  float elapsed, start, duration;
  boolean active;
  timer(float d) {
    duration = d;
    start = 3600 * hour() + 60 * minute() + second() + millis() * .0001;
    elapsed = 0;
    active = true;
  }
  void check() {
    elapsed = 60 * minute() + second() + millis() * .0001 - start;
    if (elapsed > duration) {
      active = false;
    }
  }
}
