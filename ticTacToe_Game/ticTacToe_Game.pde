/**
 ** Complete Tic Tac Toe Game controller program
 ** version 1.0
 ** by Abdullah Al-Sabbagh
 **
 ** USAGE: This file will be for GUI and handle user event and communicate with
 **     all classes, show user movements or actions and display results.
 ** VERSIONS:
 **   1: 12-27-2016: First released
 */

PFont myFont;

Grid grid;
TicTacToe ticTacToe;
float lineWeight = 3;

UI ui;
CircleButton startGameButton;
CircleButton xoButton;
CircleButton endGameButton;
CircleButton gameDifficultyButton;

Panel leftPanel;
Panel rightPanel;
Panel labelsPanel;

ArrayList<TextMotion> playerXO;
TextMotion currentXO;
//TextMotion testXO;
boolean isXOShouldMovedToMouse;

int playerTurn;
String player1XOChoice;

Timer playTurnTimer;

boolean isGameEnds = false;
boolean isResultAvailable = false;
String resultText = "";
float resultTextSize = 10;

int player1Win = 0;
int player1Lose = 0;
int tie = 0;

void setup() {
  size(1000, 800);

  myFont = loadFont("Frutiger65-Bold-200.vlw");  // load the font from this sketch's data directory
  textFont(myFont);  // set the current font to myFont

  grid = new Grid(3, 3);
  grid.setBorderWeight(lineWeight).setSize(500, 500).setLocation("center");

  ticTacToe = new TicTacToe();

  ui = new UI();

  startGameButton = new CircleButton(120, height - 160, 160);
  startGameButton.setButtonName("startGame");
  startGameButton.setText("Start Game");
  ui.addCircleButton(startGameButton);

  xoButton = new CircleButton(width - 120, height -160, 160);
  xoButton.setButtonName("xoButton");
  xoButton.setText("X");
  xoButton.setTextSize(80);
  ui.addCircleButton(xoButton);

  endGameButton = new CircleButton(220, height - 60, 80);
  endGameButton.setButtonName("endGame");
  endGameButton.setText("End Game");
  endGameButton.setTextSize(14);
  endGameButton.enable(false);
  ui.addCircleButton(endGameButton);


  gameDifficultyButton = new CircleButton(width - 220, height - 60, 80);
  gameDifficultyButton.setButtonName("gameDifficulty");
  gameDifficultyButton.setText("Easy");
  gameDifficultyButton.setTextSize(20);
  ui.addCircleButton(gameDifficultyButton);


  leftPanel = new Panel(0.5, 0.5, 300, 100);
  leftPanel.setPanelName("leftPanel");
  leftPanel.setPanelColor(color(255, 0, 0, 5), color(0));
  leftPanel.addField("Win", "Win:", 180, 35, 20, 20, color(150), color(150));
  leftPanel.addField("Lose", "Lose:", 180, 60, 20, 20, color(150), color(150));
  leftPanel.addField("Tie", "Tie:", 180, 85, 20, 20, color(150), color(150));
  ui.addPanel(leftPanel);

  leftPanel.setFieldData("Win", "0");
  leftPanel.setFieldData("Lose", "0");
  leftPanel.setFieldData("Tie", "0");

  rightPanel = new Panel(width - 301, 0.5, 300, 100);
  rightPanel.setPanelName("rightPanel");
  rightPanel.setPanelColor(color(255, 0, 0, 5), color(0));
  rightPanel.addField("Win", "Win:", 180, 35, 20, 20, color(150), color(150));
  rightPanel.addField("Lose", "Lose:", 180, 60, 20, 20, color(150), color(150));
  rightPanel.addField("Tie", "Tie:", 180, 85, 20, 20, color(150), color(150));
  ui.addPanel(rightPanel);

  rightPanel.setFieldData("Win", "0");
  rightPanel.setFieldData("Lose", "0");
  rightPanel.setFieldData("Tie", "0");

  labelsPanel = new Panel(0.5, 0.5, width - 1, 100);
  labelsPanel.setPanelName("labelsPanel");
  labelsPanel.setPanelColor(color(255, 0, 0, 5), color(255, 0, 0, 10));
  labelsPanel.addField("Player1", "Player 1", 15, 60, 30, 0, color(150), color(150));
  labelsPanel.addField("Player2", "Computer", 710, 60, 30, 0, color(150), color(150));
  labelsPanel.addField("GameLabel", "Tic Tac Toe", 350, 70, 60, 0, color(255, 141, 0), color(0));
  ui.addPanel(labelsPanel);

  playerXO = new ArrayList<TextMotion>(7);

  isXOShouldMovedToMouse = false;

  playTurnTimer = new Timer();

  smooth(8);
}

void draw() {
  background(8);

  drawLines();
  drawButtonsBackground();

  ui.run();

  if (playerXO.size() > 0) {
    for (int i = 0; i < playerXO.size(); i++) {
      playerXO.get(i).run();
    }
  }

  // play() will run only if game starts and timer is set
  if (playTurnTimer.onDelay()) {
    play();
  }

  // Showing game result => winner or draw
  if (isGameEnds && isResultAvailable) {
    showGameResult();
  }
}

void mouseMoved() {
  if (isXOShouldMovedToMouse) {
    currentXO.moveTo(mouseX, mouseY);
  }
}

void mousePressed() {
  ui.UI_MousePressed(true);
}

void mouseReleased() {
  if (startGameButton.clicked()) {
    startGame();
  } else if (xoButton.clicked()) {
    toggleXOButtonText();
  } else if (gameDifficultyButton.clicked()) {
    changeGameDifficultyButtonText();
  } else if (endGameButton.clicked()) {
    endGame();
  } else if (grid.pointOnGrid(mouseX, mouseY) && isXOShouldMovedToMouse) {
    moveXOToBoard(mouseX, mouseY);
  }

  ui.UI_MousePressed(false);
}

void startGame() {
  // STEP 1: disable buttons
  startGameButton.enable(false);
  xoButton.enable(false);
  gameDifficultyButton.enable(false);
  endGameButton.enable(true);

  // STEP 2: clear the board
  playerXO.clear();

  // STEP 3: reset moving XO to mouse, isGameEnd and showing 
  //   game result flags to false, also reset resultTextSize
  setMoveXOToMouseModeTo(false);
  isGameEnds = false;
  setShowingGameResultTo(false);
  resultTextSize = 10;

  // STEP 4: set players XO choices
  player1XOChoice = xoButton.getText();

  playerTurn = 1;
  currentXO = newXOTextInit();
  playerXO.add(currentXO);
  playerTurn = 2;
  currentXO = newXOTextInit();
  playerXO.add(currentXO);

  // STEP 5: in TicTacToe set game difficulty and start new Game
  ticTacToe.setGameDifficultyTo(mapGameDifficulty(gameDifficultyButton.getText()));
  ticTacToe.startNewGame();

  // STEP 6: choose random player from TicTacToe
  playerTurn = ticTacToe.getPlayerTurn();

  // STEP 7: play
  waitBeforeNextTurn(); // will set timer to active play after some delay
}

void play() {
  if (!ticTacToe.isGameEnd()) {
    currentXO = newXOText();
    playerXO.add(currentXO);

    switch(playerTurn) {
    case 1:
      currentXO.moveTo(mouseX, mouseY);
      setMoveXOToMouseModeTo(true);
      break;
    case 2:
      int index = ticTacToe.getCPU_Move();
      moveXOToBoard(index);
      break;
    }
  } else {
    // END THE GAME!
    endGame();
  }
}

void endGame() {
  // STEP 1: enable buttons
  startGameButton.enable(true);
  xoButton.enable(true);
  gameDifficultyButton.enable(true);
  endGameButton.enable(false);

  // STEP 2: if game ends in player 1 turn remove XO text
  if (isXOShouldMovedToMouse) {
    playerXO.remove(currentXO);
  }

  // STEP 3: reset timers
  playTurnTimer.reset();

  // STEP 4: set result and activate end game flag
  if (ticTacToe.hasGameResult()) {
    setGameResult(ticTacToe.getGameResult());
    setShowingGameResultTo(true);
  }
  isGameEnds = true;
}

void setGameResult(int player) {
  switch(player) {
  case 1:
    ++player1Win;
    leftPanel.setFieldData("Win", str(player1Win));
    rightPanel.setFieldData("Lose", str(player1Win));

    resultText = player1XOChoice + "  Wins";
    break;
  case 2:
    ++player1Lose;
    leftPanel.setFieldData("Lose", str(player1Lose));
    rightPanel.setFieldData("Win", str(player1Lose));

    resultText = (player1XOChoice == "X" ? "O" : "X") + "  Wins";
    break;
  default:
    ++tie;
    leftPanel.setFieldData("Tie", str(tie));
    rightPanel.setFieldData("Tie", str(tie));

    resultText = "XO  Tie";
  }
}

void drawWinningCrossLine(int[] indexes) {
  float x1, y1, x2, y2;
  int minIndex = min(indexes);
  int maxIndex = max(indexes);
  int difference = maxIndex - minIndex;

  x1 = y1 = x2 = y2 = 0;

  if (difference == 2) {         // Horizontal lines
    x1 = grid.cellIndexToX(minIndex);
    y1 = grid.cellIndexToY(minIndex, 0.5);
    x2 = grid.cellIndexToX(maxIndex, 1);
    y2 = grid.cellIndexToY(maxIndex, 0.5);
  } else if (difference == 6) {  // Vertical lines
    x1 = grid.cellIndexToX(minIndex, 0.5);
    y1 = grid.cellIndexToY(minIndex);
    x2 = grid.cellIndexToX(maxIndex, 0.5);
    y2 = grid.cellIndexToY(maxIndex, 1);
  } else if (difference == 4) {   // diagonal line => top right to bottom left
    x1 = grid.cellIndexToX(minIndex, 1);
    y1 = grid.cellIndexToY(minIndex);
    x2 = grid.cellIndexToX(maxIndex);
    y2 = grid.cellIndexToY(maxIndex, 1);
  } else if (difference == 8) {   // diagonal line => top left to bottom right
    x1 = grid.cellIndexToX(minIndex);
    y1 = grid.cellIndexToY(minIndex);
    x2 = grid.cellIndexToX(maxIndex, 1);
    y2 = grid.cellIndexToY(maxIndex, 1);
  }

  strokeWeight(6);
  stroke(245, 151, 0);
  line(x1, y1, x2, y2);
}

void showGameResult() {
  if (resultTextSize < 68) {
    resultTextSize += 2;
  } else {
    resultTextSize = 70 + sin(frameCount*0.1) * 2;
  }

  noStroke();
  fill(255, 160 + sin(frameCount*0.4) * 20, 0, 240);
  textSize(resultTextSize);

  float stringWidth = textWidth(resultText);
  float stringAscent = textAscent() * 0.5;

  text(resultText, width /2 - stringWidth * 0.5, height - 75 + stringAscent);

  stroke(255, 0, 0);

  if (ticTacToe.getGameResult() > 0) {
    drawWinningCrossLine(ticTacToe.getWinningIndexes());
  }
}

void setShowingGameResultTo(boolean status) {
  if (isResultAvailable != status) {
    isResultAvailable = status;
  }
}

void toggleXOButtonText() {
  if (xoButton.getText() == "X") {
    xoButton.setText("O");
  } else {
    xoButton.setText("X");
  }
}

void setMoveXOToMouseModeTo(boolean status) {
  if (isXOShouldMovedToMouse != status) {
    isXOShouldMovedToMouse = status;
  }
}

TextMotion newXOText() {
  String XOText = "";
  float XOTextY = 0;
  color textColor = color(0);

  switch(playerTurn) {
  case 1:
    XOText = player1XOChoice;
    XOTextY = 70;
    break;
  case 2:
    XOText = player1XOChoice == "X" ? "O" : "X";
    XOTextY = 788;
    break;
  }


  if (XOText == "X") {
    textColor = color(240, 57, 29);
  } else {
    textColor = color(46, 121, 240);
  }

  TextMotion XOTextMotion = new TextMotion(XOText, 120, textColor, XOTextY, 48, 0.1);
  return XOTextMotion;
}

TextMotion newXOTextInit() {
  String XOText = "";
  float XOTextY = 0;
  color textColor = color(0);

  switch(playerTurn) {
  case 1:
    XOText = player1XOChoice;
    XOTextY = 70;
    break;
  case 2:
    XOText = player1XOChoice == "X" ? "O" : "X";
    XOTextY = 788;
    break;
  }

  if (XOText == "X") {
    textColor = color(240, 57, 29, 50);
  } else {
    textColor = color(46, 121, 240, 50);
  }

  TextMotion XOTextMotion = new TextMotion(XOText, 120, textColor, XOTextY, 48, 0.1);
  return XOTextMotion;
}

void moveXOToBoard(float cellX, float cellY) {
  int index = grid.pointToIndex(cellX, cellY);
  if (!ticTacToe.isMoveMarked(index)) {
    setMoveXOToMouseModeTo(false);
    currentXO.moveTo(grid.cellIndexToX(index, 0.5), grid.cellIndexToY(index, 0.5));
    savePlayerMove(index);
  } else {
    // TODO: tell user about his/her error
    highlightWrongCell(index);
  }
}

void moveXOToBoard(int index) {
  if (!ticTacToe.isMoveMarked(index)) {
    currentXO.moveTo(grid.cellIndexToX(index, 0.5), grid.cellIndexToY(index, 0.5));
    savePlayerMove(index);
  } else {
    highlightWrongCell(index);
  }
}

// will set timer to active play after some delay
void waitBeforeNextTurn() {
  playTurnTimer.setMillisIntervalFor(800);
}

void savePlayerMove(int move) {
  switch(playerTurn) {
  case 1:
    ticTacToe.savePlayer1Move(move);
    break;
  case 2:
    ticTacToe.savePlayer2Move(move);
    break;
  }

  playerTurn = ticTacToe.getPlayerTurn();
  waitBeforeNextTurn();    // will set timer to active play after some delay
}

void changeGameDifficultyButtonText() {
  String currentButtonText = gameDifficultyButton.getText();

  if (currentButtonText == "Easy") {
    gameDifficultyButton.setText("Normal");
  } else if (currentButtonText == "Normal") {
    gameDifficultyButton.setText("Impossible");
  } else if (currentButtonText == "Impossible") {
    gameDifficultyButton.setText("Easy");
  }
}

int mapGameDifficulty(String buttonText) {
  switch(buttonText) {
  case "Normal":
    return 1;
  case "Impossible":
    return 2;
  default:  // Easy difficulty
    return 0;
  }
}

void drawLines() {
  strokeWeight(grid.getBorderWeight());
  stroke(255);

  for (int c = 1; c < grid.getColumns(); c++) {
    float x  = grid.cellColToX(c);
    float y1 = grid.cellRowToY(0);
    float y2 = grid.cellRowToY(grid.getColumns());
    line(x, y1, x, y2);
  }

  for (int r = 1; r < grid.getRows(); r++) {
    float x1 = grid.cellColToX(0);
    float y  = grid.cellRowToY(r);
    float x2 = grid.cellColToX(grid.getRows());
    line(x1, y, x2, y);
  }
}

void drawButtonsBackground() {
  // button cover
  fill(247, 223, 185, 5);
  noStroke();

  // left circle; start new game
  ellipse(0, height, 600, 600);

  // right circle; 
  ellipse(width, height, 600, 600);
}

void highlightWrongCell(int index) {
  noStroke();
  fill(255, 0, 0, 200);
  rect(grid.cellIndexToX(index), grid.cellIndexToY(index), grid.getCellWidth(), grid.getCellHeight());
}