/**
 ** Text Motion Class
 ** version 1.0
 ** by Abdullah Al-Sabbagh
 **
 ** USAGE: To move a given text from point to point with a given speed,
 **  color and size
 ** VERSIONS:
 **   1: 30-12-2016: First released
 */

class TextMotion {
  float x, y;
  float targetX, targetY;
  String text;
  float textSize;
  color textColor;
  float speed; // This should be as lerp 'amt   float: float between 0.0 and 1.0'
  boolean isMoveFromCenter;

  TextMotion(String text_, float textSize_, color textColor_, float x_, float y_, float speed_) {
    text = text_;
    textSize = textSize_;
    textColor = textColor_;
    x = x_;
    y = y_;

    if (speed_ >= 0 && speed_ <= 1) {
      speed = speed_;
    } else {
      speed = 1;
    }

    targetX = x;
    targetY = y;

    isMoveFromCenter = true;
  }

  boolean hasDestination() {
    return (x != targetX || y != targetY);
  }

  void moveText() {
    x = lerp(x, targetX, speed);
    y = lerp(y, targetY, speed);
  }

  void moveTo(float newTargetX, float newTargetY) {
    targetX = newTargetX;
    targetY = newTargetY;
  }

  void setTextCenterMoveTo(boolean status) {
    if (isMoveFromCenter != status) {
      isMoveFromCenter = status;
    }
  }

  void show() {
    textSize(textSize);
    fill(textColor);

    float stringWidth = textWidth(text);
    float stringAscent = textAscent() * 0.5;

    float widthOffset = isMoveFromCenter ? stringWidth * -0.5 : 0;

    text(text, x + widthOffset, y + stringAscent);
  }

  void run() {
    if (hasDestination()) {
      moveText();
    }

    show();
  }
}