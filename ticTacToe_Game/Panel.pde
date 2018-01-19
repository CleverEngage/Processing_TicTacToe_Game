/**
 ** User Interface Class: Panel
 ** version 1.0
 ** by Abdullah Al-Sabbagh
 **
 ** USAGE: Panel that may be used in UI class to display 
 **  information to the user
 ** VERSIONS:
 **   1: 29-12-2016: First released
 */

class Panel {
  class Field {
    float x, y;
    String name;
    String label;
    String data;
    float labelTextSize;
    float dataTextSize;
    color labelColor;
    color dataColor;
  }

  float x, y;
  float pWidth, pHeight;
  String name;
  color pColor, strokeColor;
  float maxFieldLabelWidth;
  ArrayList<Field> fields;

  Panel(float x_, float y_, float pWidth_, float pHeight_) {
    x = x_;
    y = y_;
    pWidth = pWidth_;
    pHeight = pHeight_;
    name = "newPanel" + str(ui.panelIndex());
    pColor = color(206, 60, 60, 10);
    strokeColor = color(255, 0, 0, 25);
    maxFieldLabelWidth = 0;
    fields = new ArrayList<Field>(0);
  }

  String getPanelName() {
    return name;
  }

  void setPanelName(String newName) {
    if (ui.isPanelNameExist(this, newName)) {
      println("ERROR: Panel Name '", newName, "' exist!");
      return;
    }
    name = newName;
  }

  void setMaxLabelWidth(String label, float labelTextSize) {
    textSize(labelTextSize);
    float labelWidth = textWidth(label);

    if (labelWidth > maxFieldLabelWidth) {
      maxFieldLabelWidth = labelWidth;
    }
  }

  void addField(String name_, String label_, float x_, float y_) {
    if (!isFieldNameExist(name_)) {
      Field field = new Field();
      field.x = x_;
      field.y = y_;
      field.name = name_;
      field.label = label_;
      field.data = "";
      field.labelTextSize = 30;
      field.dataTextSize = 30;
      field.labelColor = color(250, 250);
      field.dataColor = color(245, 250);
      fields.add(field);

      setMaxLabelWidth(field.label, field.labelTextSize);
    } else {
      println("ERROR: Field Name '" + name_ + "' Exist!");
    }
  }

  void addField(String name_, String label_, float x_, float y_, float labelTextSize_, float dataTextSize_, color labelColor_, color dataColor_) {
    if (!isFieldNameExist(name_)) {
      Field field = new Field();
      field.x = x_;
      field.y = y_;
      field.name = name_;
      field.label = label_;
      field.data = "";
      field.labelTextSize = labelTextSize_;
      field.dataTextSize = dataTextSize_;
      field.labelColor = labelColor_;
      field.dataColor = dataColor_;
      fields.add(field);

      setMaxLabelWidth(field.label, field.labelTextSize);
    } else {
      println("ERROR: Field Name '" + name_ + "' Exist!");
    }
  }

  boolean isFieldNameExist(String fieldName) {
    if (!fields.isEmpty()) {
      Field currentField;
      for (int i = 0; i < fields.size(); i++) {
        currentField = fields.get(i);

        if (currentField.name == fieldName) {
          return true;
        }
      }
    }
    return false;
  }

  void setPanelColor (color newPanelColor, color newStrokeColor) {
    pColor = newPanelColor;
    strokeColor = newStrokeColor;
  }

  Field findField(String fieldName) {
    if (!fields.isEmpty()) {
      Field currentField;
      for (int i = 0; i < fields.size(); i++) {
        currentField = fields.get(i);

        if (currentField.name == fieldName) {
          return currentField;
        }
      }
    }
    return null;
  }

  void setFieldData(String fieldName, String fieldData) {
    Field field = findField(fieldName);
    if (field == null) {
      println("ERROR: Field name '" + fieldName + "' does not exist!");
      return;
    }
    field.data = fieldData;
  }

  void show() {
    pushMatrix();
    translate(x, y);

    // showing each field 
    noStroke();
    if (!fields.isEmpty()) {
      for (int i = 0; i < fields.size(); i++) {
        Field field = fields.get(i);

        if (field.label != "") {
          fill(field.labelColor);
          textSize(field.labelTextSize);
          text(field.label, field.x, field.y);
        }

        if (field.data != "") {
          fill(field.dataColor);
          textSize(field.dataTextSize);
          text(field.data, field.x + maxFieldLabelWidth + 10, field.y);
        }
      }
    }

    if (pColor == color(0)) {
      noFill();
    } else {
      fill(pColor);
    }

    if (strokeColor == color(0)) {
      noStroke();
    } else {
      stroke(strokeColor);
    }

    rect(0, 0, pWidth, pHeight);

    popMatrix();
  }

  void run() {
    show();
  }
}