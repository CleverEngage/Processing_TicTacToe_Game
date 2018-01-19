/**
 ** Tic Tac Toe Game Class
 ** version 1.0
 ** by Abdullah Al-Sabbagh
 **
 ** USAGE: To handle all Tic Tac Toe Game logic
 **   Tic-tac-toe (also known as noughts and crosses or Xs and Os) is
 **   a paper-and-pencil game for two players, X and O, who take turns 
 **   marking the spaces in a 3×3 grid. The player who succeeds in placing
 **   three of their marks in a horizontal, vertical, or diagonal row wins 
 **   the game. https://en.wikipedia.org/wiki/Tic-tac-toe
 **
 **     Game Grid will be indexed as: 
 **       0  |  1  |  2
 **      ----------------
 **       3  |  4  |  5
 **      ----------------
 **       6  |  7  |  8
 **
 ** VERSIONS:
 **   1: 28-12-2016: First released
 */

class TicTacToe {
  // currentTurn will be incremented by 1 each turn
  // when it start the value will be either 1 or 2
  int currentTurn;
  // 1: player 1 => will be for real player (Human)
  // 2: player 2 => will be considered as CPU 
  //  if CPU_RandomMove(), CPU_SemiSmartMove() or CPU_SmartMove() get called
  int currentPlayerTurn;
  IntList player1MovePoints;
  IntList player2MovePoints;
  int gameDifficulty;  // 0: easy - 1: hard
  int mistake; // used in game difficulty "Hard" to make chance to let player 1 wins
  int gameResult;      // 0: draw - 1: player 1 wins - 2: player 2 wins
  int[] winningIndexes;  // for saving winner player moves as indexes


  TicTacToe() {
    currentTurn = 0;  
    currentPlayerTurn = (int) random(1, 3); // initiate with random player turn
    player1MovePoints = new IntList();
    player2MovePoints = new IntList();
    gameDifficulty = 0; // default is easy
    mistake = 0;

    gameResult = -1;
    winningIndexes = new int[3];
    for (int i = 0; i < winningIndexes.length; i++) {
      winningIndexes[i] = -1;
    }
  }

  void setGameDifficultyTo(int difficulty) {
    gameDifficulty = difficulty;
  }

  void startNewGame() {
    // selecting player; if previouse round is player 1 
    //    choose player 2 and vice versa
    currentPlayerTurn = currentTurn % 2 == 1 ? (currentPlayerTurn % 2) + 1: currentPlayerTurn;
    // reset current turn to 1
    currentTurn = 1;
    // clearing previous moves if available
    player1MovePoints.clear();
    player2MovePoints.clear();
    gameResult = -1;
    mistake = 0;
    for (int i = 0; i < winningIndexes.length; i++) {
      winningIndexes[i] = -1;
    }
  }

  int getPlayerTurn() {
    return currentPlayerTurn;
  }

  void updatePlayerTurn() {
    currentPlayerTurn = (currentPlayerTurn % 2) + 1;
    ++currentTurn;
  }

  //int attention (int ) {

  //}

  boolean isMoveMarked(int move) {
    return (player1MovePoints.hasValue(move) || player2MovePoints.hasValue(move));
  }

  boolean isCenter(int move) {
    return (move == 4);
  }

  boolean isCorner(int move) {
    switch(move) {
    case 0:
    case 2:
    case 6:
    case 8:
      return true;
    default:
      return false;
    }
  }

  // NOTE: To be deleted if it is not required
  boolean isEdge(int move) {
    switch(move) {
    case 1:
    case 3:
    case 5:
    case 7:
      return true;
    default:
      return false;
    }
  }

  /*
  ** EXAMPLE: get unique value of corner and edge that can be used 
   ** to find required move to specific point
   ----------------------------
   -------> ( 0 , 1 ) =>  101
   -------> ( 0 , 3 ) =>  103
   -------> ( 0 , 5 ) =>  105
   -------> ( 8 , 7 ) =>  187
   ** HINT: You can think as if the rule is:  1 follow by value1 then value2
   if value1 = 8 and value2 = 7 the result will be 187
   */
  int hash(int value1, int value2) {
    return ((value1 + 10) * 10 + value2);
  }

  boolean isAdjacentCornerEdge(int corner, int edge) {
    int hash = hash(corner, edge);

    switch(hash) {
    case 101:
    case 103:
    case 121:
    case 125:
    case 163:
    case 167:
    case 185:
    case 187:
      return true;
    default:
      return false;
    }
  }

  boolean isOppositeCornerEdge(int corner, int edge) {
    int hash = hash(corner, edge);

    switch(hash) {
    case 105:
    case 107:
    case 123:
    case 127:
    case 161:
    case 165:
    case 181:
    case 183:
      return true;
    default:
      return false;
    }
  }

  boolean isOneCornerLeft() {
    int count = 0;
    // corners indexes = {0, 2, 6, 8}
    for (int i = 0; i < 7; i += 6) {
      for (int j = 0; j < 3; j += 2) {
        if (!isMoveMarked(j+i)) {
          ++count;
        }
      }
    }

    return (count == 1);
  }

  boolean isCornerEdgesNotMarkedOf(int corner) {
    switch(corner) {
    case 0:
      return !(isMoveMarked(1) || isMoveMarked(3));
    case 2:
      return !(isMoveMarked(1) || isMoveMarked(5));
    case 6:
      return !(isMoveMarked(3) || isMoveMarked(7));
    case 8:
      return !(isMoveMarked(5) || isMoveMarked(7));
    default:
      return false;
    }
  }

  boolean isOppositeEdges(int edge1, int edge2) {
    int hash = hash(edge1, edge2);

    switch(hash) {
    case 117:
    case 171:
    case 135:
    case 153:
      return true;
    default: 
      return false;
    }
  }

  boolean isAdjacentEdges(int edge1, int edge2) {
    int hash = hash(edge1, edge2);

    switch(hash) {
    case 113:
    case 131:
    case 115:
    case 151:
    case 137:
    case 173:
    case 157:
    case 175:
      return true;
    default: 
      return false;
    }
  }

  boolean isOppositeCorners(int corner1, int corner2) {
    int hash = hash(corner1, corner2);

    switch(hash) {
    case 126:
    case 162:
    case 108:
    case 180:
      return true;
    default:
      return false;
    }
  }

  int findCenterMove() {
    return 4;
  }

  int findRandomMove() {
    IntList moves = new IntList();

    for (int i = 0; i < 9; i++) {
      if (!isMoveMarked(i)) {
        moves.append(i);
      }
    }

    if (moves.size() > 0) {
      int choice = (int) random(0, moves.size());
      return moves.get(choice);
    }

    return -1;
  }

  int findRandomCorner() {
    IntList availableCorners = new IntList();

    int currentCorner;
    // corners indexes = {0, 2, 6, 8}
    for (int i = 0; i < 7; i += 6) {
      for (int j = 0; j < 3; j += 2) {
        currentCorner = j+i;
        if (!isMoveMarked(currentCorner)) {
          availableCorners.append(currentCorner);
        }
      }
    }

    if (availableCorners.size() > 0) {
      int choice = (int) random(0, availableCorners.size());
      return availableCorners.get(choice);
    }

    return -1;
  }

  int findRandomEdge() {
    IntList availableEdges = new IntList();

    int currentEdge;
    // edges indexes = {1, 3, 5, 7}
    for (int i = 1; i < 8; i += 2) {
      currentEdge = i;
      if (!isMoveMarked(currentEdge)) {
        availableEdges.append(currentEdge);
      }
    }

    if (availableEdges.size() > 0) {
      int choice = (int) random(0, availableEdges.size());
      return availableEdges.get(choice);
    }

    return -1;
  }

  int findLastNotMarkedCorner() {
    int lastCorner = -1;
    int count = 0;
    // corners indexes = {0, 2, 6, 8}
    for (int i = 0; i < 7; i += 6) {
      for (int j = 0; j < 3; j += 2) {
        if (!isMoveMarked(j+i)) {
          ++count;
          lastCorner = j+i;
        }
      }
    }

    if (count == 1) {
      return lastCorner;
    }

    return -1;
  }

  int findCornerOppositeOf(int corner) {
    switch(corner) {
    case 0:
      return 8;
    case 2:
      return 6;
    case 6:
      return 2;
    case 8:
      return 0;
    default:
      return -1;
    }
  }

  int findCornerNotOppositeOf(int corner) {
    if (isCorner(corner)) {
      int choice = (int) random(1, 3);
      int hash = corner + choice;
      switch(hash) {
      case 1:
        return 2;
      case 2:
        return 6;
      case 3:
        return 0;
      case 4:
        return 8;
      case 7:
        return 0;
      case 8:
        return 8;
      case 9:
        return 2;
      case 10:
        return 6;
      default:
        return -1;
      }
    }
    return -1;
  }

  int findAdjacentCornerOf(int corner, int edge) {
    if (isAdjacentCornerEdge(corner, edge)) {
      int hash = hash(corner, edge);

      switch(hash) {
      case 101:
        return 6;
      case 103:
        return 2;
      case 121:
        return 8;
      case 125:
        return 0;
      case 163:
        return 8;
      case 167:
        return 0;
      case 185:
        return 6;
      case 187:
        return 2;
      }
    }
    return -1;
  }

  int findCenterOrCornerWithoutEdges() {
    int choice = (int) random(1, 3);

    switch(choice) {
    case 1:
      return 4; // 4 is center index in Tic Tac Toe grid
    case 2:
      int corner;
      // corners indexes = {0, 2, 6, 8}
      for (int i = 0; i < 7; i += 6) {
        for (int j = 0; j < 3; j += 2) {
          corner = j+i;
          if (!isMoveMarked(corner) && isCornerEdgesNotMarkedOf(corner)) {
            return corner;
          }
        }
      }
    }

    return -1;
  }

  int findCornerOfCornerAndEdge(int corner, int edge) {
    if (isCorner(corner) && isEdge(edge)) {
      int hash = hash(corner, edge);

      switch(hash) {
      case 105:
        return 2;
      case 107:
        return 6;
      case 123:
        return 0;
      case 127:
        return 8;
      case 161:
        return 0;
      case 165:
        return 8;
      case 181:
        return 2;
      case 183:
        return 6;
      default:
        return -1;
      }
    } else {
      return -1;
    }
  }

  int findCornerOfAdjacentEdges(int edge1, int edge2) {
    int hash = hash(edge1, edge2);

    switch(hash) {
    case 113:
    case 131:
      return 0;
    case 115:
    case 151:
      return 2;
    case 137:
    case 173:
      return 6;
    case 157:
    case 175: 
      return 8;
    default:
      return -1;
    }
  }


  // The strategy is based on wikipedia, YouTube and some of my knowledge
  // https://en.wikipedia.org/wiki/Tic-tac-toe#Strategy


  int findWinMove() {
    int index;
    int player2MarkedPoints = 0;
    int possibleWinMove = -1; // set it to -1 to check if possible win move is found
    IntList possibleWinMoves = new IntList();

    // search in rows
    for (int row = 0; row < 3; row++) {
      for (int col = 0; col < 3; col++) {
        index = grid.colRowToIndex(col, row);

        if (isMoveMarked(index)) {
          if (player2MovePoints.hasValue(index)) {
            ++player2MarkedPoints;
          }
        } else {
          possibleWinMove = index;
        }
      }
      if (player2MarkedPoints == 2 && possibleWinMove != -1) {
        possibleWinMoves.append(possibleWinMove);
      }

      // reset player2MarkedPoints and possibleWinMove for next loop
      player2MarkedPoints = 0;
      possibleWinMove = -1;
    }

    // search in columns
    for (int col = 0; col < 3; col++) {
      for (int row = 0; row < 3; row++) {
        index = grid.colRowToIndex(col, row);

        if (isMoveMarked(index)) {
          if (player2MovePoints.hasValue(index)) {
            ++player2MarkedPoints;
          }
        } else {
          possibleWinMove = index;
        }
      }
      if (player2MarkedPoints == 2 && possibleWinMove != -1) {
        possibleWinMoves.append(possibleWinMove);
      }

      // reset player2MarkedPoints and possibleWinMove for next loop
      player2MarkedPoints = 0;
      possibleWinMove = -1;
    }

    // search in diagonal 0 - 4 - 8
    for (int i = 0; i < 9; i += 4) {
      if (isMoveMarked(i)) {
        if (player2MovePoints.hasValue(i)) {
          ++player2MarkedPoints;
        }
      } else {
        possibleWinMove = i;
      }
    }
    if (player2MarkedPoints == 2 && possibleWinMove != -1) {
      possibleWinMoves.append(possibleWinMove);
    }

    // reset player2MarkedPoints and possibleWinMove for next check
    player2MarkedPoints = 0;
    possibleWinMove = -1;

    // search in diagonal 2 - 4 - 6
    for (int i = 2; i < 7; i += 2) {
      if (isMoveMarked(i)) {
        if (player2MovePoints.hasValue(i)) {
          ++player2MarkedPoints;
        }
      } else {
        possibleWinMove = i;
      }
    }
    if (player2MarkedPoints == 2 && possibleWinMove != -1) {
      possibleWinMoves.append(possibleWinMove);
    }


    if (possibleWinMoves.size() > 0) {
      int choice = (int) random(0, possibleWinMoves.size());
      return possibleWinMoves.get(choice);
    } else {
      return -1;
    }
  }

  int findBlockMove() {
    int index;
    int player1MarkedPoints = 0;
    int possibleWinMove = -1; // set it to -1 to check if possible win move is found
    IntList possibleWinMoves = new IntList();

    // search in rows
    for (int row = 0; row < 3; row++) {
      for (int col = 0; col < 3; col++) {
        index = grid.colRowToIndex(col, row);

        if (isMoveMarked(index)) {
          if (player1MovePoints.hasValue(index)) {
            ++player1MarkedPoints;
          }
        } else {
          possibleWinMove = index;
        }
      }
      if (player1MarkedPoints == 2 && possibleWinMove != -1) {
        possibleWinMoves.append(possibleWinMove);
      }

      // reset player1MarkedPoints and possibleWinMove for next loop
      player1MarkedPoints = 0;
      possibleWinMove = -1;
    }

    // search in columns
    for (int col = 0; col < 3; col++) {
      for (int row = 0; row < 3; row++) {
        index = grid.colRowToIndex(col, row);

        if (isMoveMarked(index)) {
          if (player1MovePoints.hasValue(index)) {
            ++player1MarkedPoints;
          }
        } else {
          possibleWinMove = index;
        }
      }
      if (player1MarkedPoints == 2 && possibleWinMove != -1) {
        possibleWinMoves.append(possibleWinMove);
      }

      // reset player1MarkedPoints and possibleWinMove for next loop
      player1MarkedPoints = 0;
      possibleWinMove = -1;
    }

    // search in diagonal 0 - 4 - 8
    for (int i = 0; i < 9; i += 4) {
      if (isMoveMarked(i)) {
        if (player1MovePoints.hasValue(i)) {
          ++player1MarkedPoints;
        }
      } else {
        possibleWinMove = i;
      }
    }
    if (player1MarkedPoints == 2 && possibleWinMove != -1) {
      possibleWinMoves.append(possibleWinMove);
    }

    // reset player1MarkedPoints and possibleWinMove for next check
    player1MarkedPoints = 0;
    possibleWinMove = -1;

    // search in diagonal 2 - 4 - 6
    for (int i = 2; i < 7; i += 2) {
      if (isMoveMarked(i)) {
        if (player1MovePoints.hasValue(i)) {
          ++player1MarkedPoints;
        }
      } else {
        possibleWinMove = i;
      }
    }
    if (player1MarkedPoints == 2 && possibleWinMove != -1) {
      possibleWinMoves.append(possibleWinMove);
    }


    if (possibleWinMoves.size() > 0) {
      int choice = (int) random(0, possibleWinMoves.size());
      return possibleWinMoves.get(choice);
    } else {
      return -1;
    }
  }

  boolean isValidMove(int move) {
    return (move > -1);
  }

  // TODO: check if 'getLastCPUMove ()' should be deleted
  int getLastCPUMove () {
    int lastMoveIndex = player2MovePoints.size() - 1;

    if (lastMoveIndex >= 0) {
      return player2MovePoints.get(lastMoveIndex);
    }

    return -1;
  }

  int getFirstOpponentMove () {
    if (player1MovePoints.size() > 0) {
      return player1MovePoints.get(0);
    }

    return -1;
  }

  int getLastOpponentMove () {
    int lastMoveIndex = player1MovePoints.size() - 1;

    if (lastMoveIndex >= 0) {
      return player1MovePoints.get(lastMoveIndex);
    }

    return -1;
  }

  int findCasualMove() {
    int CPU_Move = -1;

    CPU_Move = findWinMove();

    if (!isValidMove(CPU_Move)) {
      CPU_Move = findBlockMove();
    } 

    if (!isValidMove(CPU_Move)) {
      CPU_Move = findRandomMove();
    }

    return CPU_Move;
  }

  int findSmartMove() {
    int CPU_Move = -1;
    int lastCPUMove = getLastCPUMove();
    int lastOpponentMove = getLastOpponentMove();

    switch(currentTurn) {
      // if CPU is 1st turn
    case 1:
      CPU_Move = findRandomCorner();
      break;
    case 3:
      if (isCenter(lastOpponentMove)) {
        CPU_Move = findCornerOppositeOf(lastCPUMove);
      } else if (isCorner(lastOpponentMove)) {
        CPU_Move = findRandomCorner();
      } else if (isAdjacentCornerEdge(lastCPUMove, lastOpponentMove)) {
        CPU_Move = findAdjacentCornerOf(lastCPUMove, lastOpponentMove);
      } else {
        CPU_Move = findCornerNotOppositeOf(lastCPUMove);
      }
      break;
    case 5:
      CPU_Move = findWinMove();

      if (!isValidMove(CPU_Move)) {
        CPU_Move = findBlockMove();
      } 

      if (!isValidMove(CPU_Move)) {
        if (isOneCornerLeft()) {
          CPU_Move = findLastNotMarkedCorner();
        } else {
          CPU_Move = findCenterOrCornerWithoutEdges();
        }
      }
      break;
    case 7:
    case 9:
      CPU_Move = findWinMove();

      if (!isValidMove(CPU_Move)) {
        CPU_Move = findBlockMove();
      }

      if (!isValidMove(CPU_Move)) {
        CPU_Move = findRandomMove();
      }
      break;

      // if CPU is 2nd turn
    case 2:
      if (isCenter(lastOpponentMove)) {
        CPU_Move = findRandomCorner();
      } else {
        CPU_Move = findCenterMove();
      }
      break;
    case 4:
      CPU_Move = findBlockMove();

      if (!isValidMove(CPU_Move)) {
        int firstOpponentMove = getFirstOpponentMove();

        if (isCorner(lastOpponentMove)) {
          if (isCenter(firstOpponentMove)) {
            CPU_Move = findRandomCorner();
          } else if (isOppositeCornerEdge(lastOpponentMove, firstOpponentMove)) {
            CPU_Move = findCornerOfCornerAndEdge(lastOpponentMove, firstOpponentMove);
          } else if (isOppositeCorners(lastOpponentMove, firstOpponentMove)) {
            CPU_Move = findRandomEdge();
          }
        } else if (isEdge(lastOpponentMove)) {
          if (isOppositeCornerEdge(firstOpponentMove, lastOpponentMove)) {
            CPU_Move = findCornerOfCornerAndEdge(firstOpponentMove, lastOpponentMove);
          } else if (isAdjacentEdges(lastOpponentMove, firstOpponentMove)) {
            CPU_Move = findCornerOfAdjacentEdges(lastOpponentMove, firstOpponentMove);
          } else if (isOppositeEdges(lastOpponentMove, firstOpponentMove)) {
            CPU_Move = findRandomCorner();
          }
        }
      }
      break;
    case 6:
    case 8:
      CPU_Move = findWinMove();

      if (!isValidMove(CPU_Move)) {
        CPU_Move = findBlockMove();
      }

      if (!isValidMove(CPU_Move)) {
        CPU_Move = findRandomMove();
      }
      break;
    }

    return CPU_Move;
  }

  int getCPU_Move() {
    int CPU_Move = -1;

    if (currentPlayerTurn == 2) {
      switch(gameDifficulty) {
      case 0:
        CPU_Move = findRandomMove();
        break;
      case 1:
        CPU_Move = findCasualMove();
        break;
      case 2:
        CPU_Move = findSmartMove();
        break;
      }
    } else {
      println("ERROR: Cannot get CPU move in other player turn");
    }

    return CPU_Move;
  }

  void savePlayer1Move(int move) {
    if (!isMoveMarked(move)) {
      if (currentPlayerTurn == 1) {
        player1MovePoints.append(move);

        if (isPlayerWin(player1MovePoints)) {
          gameResult = currentPlayerTurn;
        } else {
          updatePlayerTurn();
        }
      } else {
        println("ERROR: Cannot set current player move in other player turn");
      }
    } else {
      println("ERROR: Cannot set current player move because it is already used");
    }
  }

  void savePlayer2Move(int move) {
    if (!isMoveMarked(move)) {
      if (currentPlayerTurn == 2) {
        player2MovePoints.append(move);

        if (isPlayerWin(player2MovePoints)) {
          gameResult = currentPlayerTurn;
        } else {
          updatePlayerTurn();
        }
      } else {
        println("ERROR: Cannot set current player move in other player turn");
      }
    } else {
      println("ERROR: Cannot set current player move because it is already used");
    }
  }

  boolean hasGameResult() {
    return gameResult > -1;
  }

  // STOP Game if there is result
  boolean isGameEnd() {
    // if any player wins
    if (hasGameResult()) {
      //println("hasResult()");
      return true;
    }

    // if current turn is equal to 9 (which is the last move)
    //     and no one win it means that the result is tie
    if (currentTurn == 10) {
      gameResult = 0;
      return true;
    }

    return false;
  }

  boolean isPlayerWin(IntList moves) {
    if (moves.hasValue(0) && moves.hasValue(1) && moves.hasValue(2)) {
      for (int i = 0; i < winningIndexes.length; i++) {
        winningIndexes[i] = i;
      }
      return true;
    }

    if (moves.hasValue(3) && moves.hasValue(4) && moves.hasValue(5)) {
      for (int i = 0; i < winningIndexes.length; i++) {
        winningIndexes[i] = i + 3;
      }
      return true;
    }

    if (moves.hasValue(6) && moves.hasValue(7) && moves.hasValue(8)) {
      for (int i = 0; i < winningIndexes.length; i++) {
        winningIndexes[i] = i + 6;
      }
      return true;
    }

    if (moves.hasValue(0) && moves.hasValue(3) && moves.hasValue(6)) {
      for (int i = 0; i < winningIndexes.length; i++) {
        winningIndexes[i] = i * 3;
      }
      return true;
    }

    if (moves.hasValue(1) && moves.hasValue(4) && moves.hasValue(7)) {
      for (int i = 0; i < winningIndexes.length; i++) {
        winningIndexes[i] = (i * 3) + 1;
      }
      return true;
    }

    if (moves.hasValue(2) && moves.hasValue(5) && moves.hasValue(8)) {
      for (int i = 0; i < winningIndexes.length; i++) {
        winningIndexes[i] = (i * 3) + 2 ;
      }
      return true;
    }

    if (moves.hasValue(0) && moves.hasValue(4) && moves.hasValue(8)) {
      for (int i = 0; i < winningIndexes.length; i++) {
        winningIndexes[i] = i * 4;
      }
      return true;
    }

    if (moves.hasValue(2) && moves.hasValue(4) && moves.hasValue(6)) {
      for (int i = 0; i < winningIndexes.length; i++) {
        winningIndexes[i] = (i * 2) + 2 ;
      }
      return true;
    }

    return false;
  }

  int[] getWinningIndexes() {
    return winningIndexes;
  }

  int getGameResult() {
    return gameResult;
  }
}