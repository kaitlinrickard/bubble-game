class Bubble {
  int col; // color
  float x; // x point
  float y; // y point
  Bubble (int c) {
    col = c; // set color
  }
  void setX(float bubbleX) { // set x point
    x= bubbleX;
  }
  void setY(float bubbleY) { // set y point
    y= bubbleY;
  }
  float getX() { // get x point
    return x;
  }
    float getY() { // get y point
    return y;
  }
  int getColor() { // get color
    return col;
  }
  void place(float bubbleX, float bubbleY, float bubbleW) { // draw the bubbles on the screen
    if (col==1) {
      image(purple, bubbleX, bubbleY, bubbleW, bubbleW); // purple bubble
    }
    if (col==2) {
      image(yellow, bubbleX, bubbleY, bubbleW, bubbleW); // yellow bubble
    }
    if (col==3) {
      image(green, bubbleX, bubbleY, bubbleW, bubbleW); // green bubble
    }
    if (col==4) {
      image(red, bubbleX, bubbleY, bubbleW, bubbleW); // red bubble
    }
    if (col==5) {
      image(hole, bubbleX, bubbleY, bubbleW, bubbleW); // black hole
    }
  }
}
