/**
 ** User Interface Class
 ** version 1.0
 ** by Abdullah Al-Sabbagh
 **
 ** USAGE: To display information to the user and for input and output IO
 **   by linking with other UI object such as buttons, panels, sliders, etc...
 ** VERSIONS:
 **   1: 28-12-2016: First released
 */

class UI {
  ArrayList<Panel> panels;
  ArrayList<CircleButton> cButtons;
  boolean mouseIsPressed;

  UI() {
    panels = new ArrayList<Panel>(0);
    cButtons = new ArrayList<CircleButton>(0);
    mouseIsPressed = false;
  }

  // PANELS: controlling and interaction
  void addPanel(Panel panel) {
    panels.add(panel);
  }

  int panelIndex() {
    return panels.size();
  }

  boolean isPanelNameExist(Panel testedPanel, String panelName) {
    if (!panels.isEmpty()) {
      Panel currentPanel;
      for (int i = 0; i < panels.size(); i++) {
        currentPanel = panels.get(i);
        if (testedPanel != currentPanel && panelName == currentPanel.getPanelName()) {
          return true;
        }
      }
    }
    return false;
  }

  // BUTTONS: controlling and interaction
  void addCircleButton(CircleButton cButton) {
    cButtons.add(cButton);
  }

  void UI_MousePressed(boolean status) {
    if (status != mouseIsPressed) {
      mouseIsPressed = status;

      if (mouseIsPressed) {
        resetButtonsClickedModeTo(true);
      } else {
        resetButtonsClickedModeTo(false);
      }
    }
  }

  boolean isCircleButtonNameExist(CircleButton testedButton, String buttonName) {
    if (!cButtons.isEmpty()) {
      CircleButton currentButton;
      for (int i = 0; i < cButtons.size(); i++) {
        currentButton = cButtons.get(i);
        if (testedButton != currentButton &&  buttonName == currentButton.getButtonName()) {
          return true;
        }
      }
    }
    return false;
  }

  void resetButtonsClickedModeTo(boolean status) {
    if (!cButtons.isEmpty()) {
      if (status) {
        CircleButton currentButton;

        for (int i = 0; i < cButtons.size(); i++) {
          currentButton = cButtons.get(i);

          if (currentButton.mouseHover()) {
            currentButton.clickedMode(true);
            break;
          }
        }
      } else {
        for (int i = 0; i < cButtons.size(); i++) {
          cButtons.get(i).clickedMode(false);
        }
      }
    }
  }

  int buttonIndex() {
    return cButtons.size();
  }


  // running UI
  void run() {

    // display each panel and run its behaviour
    if (!panels.isEmpty()) {
      for (int i = 0; i < panels.size(); i++) {
        panels.get(i).run();
      }
    }

    // display each button and run its behaviour
    if (!cButtons.isEmpty()) {
      for (int i = 0; i < cButtons.size(); i++) {
        cButtons.get(i).run();
      }
    }
  }
}