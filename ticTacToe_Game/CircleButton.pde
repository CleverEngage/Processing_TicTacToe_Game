/**
 ** User Interface Class: Circle Button
 ** version 1.0
 ** by Abdullah Al-Sabbagh
 **
 ** USAGE: Clickable Circle Button that may be used in UI class
 ** VERSIONS:
 **   1: 28-12-2016: First released
 */

class CircleButton {
  float x, y;
  float diameter;
  String name;
  String text;
  color cbColor, cbHoverColor, cbClickedColor;
  color strokeColor, clickedStrokeColor;
  color textColor;
  float defaultTextSize;
  float textSize;
  boolean buttonIsActive;
  boolean clickedModeIsActive;
  boolean hoverModeIsActive;

  CircleButton(float x_, float y_, float diameter_) {
    x = x_;
    y = y_;
    diameter = diameter_;
    name = "newButton_" + str(ui.buttonIndex());
    text = "newButton";
    defaultTextSize = 25;
    textSize = 25;
    cbColor            = color(157, 0, 0);
    cbHoverColor       = color(200, 0, 0);
    cbClickedColor     = color(70, 11, 1);
    strokeColor        = color(124, 32, 32);
    clickedStrokeColor = color(124, 0, 0);
    textColor          = color(247, 227, 227);
    buttonIsActive = true;
    clickedModeIsActive = false;
    hoverModeIsActive = false;
  }

  PVector getPosition() {
    PVector postion = new PVector(x, y);
    return postion;
  }

  void setPosition(float newX, float newY) {
    x = newX;
    y = newY;
  }

  float getSize() {
    return diameter;
  }

  void setSize(float newdiameter) {
    diameter = newdiameter;
  }

  String getButtonName() {
    return name;
  }

  void setButtonName(String newName) {
    if (ui.isCircleButtonNameExist(this, newName)) {
      println("ERROR: Button Name '", newName, "' exist!");
      return;
    }
    name = newName;
  }

  void setBodyColor(color newColor) {
    cbColor = newColor;
  }

  void setClickedColor(color newColor) {
    cbClickedColor  = newColor;
  }

  void setHoverColor(color newColor) {
    cbHoverColor  = newColor;
  }

  void setStrokeColor(color newColor) {
    strokeColor  = newColor;
  }

  void setClickedStrokeColor(color newColor) {
    clickedStrokeColor  = newColor;
  }

  // text that apper on the button
  String getText() {
    return text;
  }

  void setText(String newText) {
    text = newText;

    textSize = defaultTextSize;

    textSize(textSize);
    float txtWidth = textWidth(text);

    while (txtWidth >= diameter - 8 && textSize > 8) { 
      textSize(--textSize);
      txtWidth = textWidth(text);
    }
  }
  void setTextColor(color newColor) {
    textColor = newColor;
  }

  void setTextSize(int newSize) {
    defaultTextSize = newSize;
    textSize = newSize;
  }

  // button enabled/disabled
  void enable(boolean status) {
    if (status != buttonIsActive) {
      buttonIsActive = status;
    }
  }

  // active/disactive clicked mode
  void clickedMode(boolean status) {
    if (status != clickedModeIsActive) {
      clickedModeIsActive = status;
    }
  }

  void hoverMode(boolean status) {
    if (status != hoverModeIsActive) {
      hoverModeIsActive = status;
    }
  }

  boolean mouseHover() {
    float distance = dist(mouseX, mouseY, x, y);
    if (distance <= diameter * 0.5) {
      return true;
    }
    return false;
  }

  boolean clicked() {
    if (buttonIsActive && mouseHover()) {
      clickedMode(true);
      return true;
    }
    return false;
  }

  // to activate hover mode
  void renderObjectHover() {
    if (mouseHover()) {
      hoverMode(true);
    } else {
      hoverMode(false);
    }
  }

  void show() {
    pushMatrix();
    translate(x, y);

    strokeWeight(2);

    // set stroke color based on button mode
    if (clickedModeIsActive || !buttonIsActive) {
      stroke(clickedStrokeColor);
    } else {
      stroke(strokeColor);
    }

    // set body color based on button mode
    if (clickedModeIsActive || !buttonIsActive) {
      fill(cbClickedColor);
    } else if (hoverModeIsActive) {
      fill(cbHoverColor);
    } else {
      fill(cbColor);
    }


    ellipse(0, 0, diameter, diameter);

    textSize(textSize);
    fill(textColor);

    float stringWidth = textWidth(text);
    float stringAscent = textAscent() * 0.5;

    text(text, 0 - stringWidth * 0.5, 0 + stringAscent);

    popMatrix();
  }

  void run() {
    renderObjectHover();
    show();
  }
}