/**
 ** Grid class
 ** version 2.0
 ** by Abdullah Al-Sabbagh
 **
 ** USAGE: This calss is used to make grid object that makes most of calculation 
 **   required such as grid size, cell size, locations, etc...
 ** VERSIONS:
 **   2: 01-03-2017: Update methods such as 'cellIndexToX(int index, float offset);' the 
 **       offset now take any value
 **   1: 12-18-2016: First released
 */


class Grid {
  int columns, rows;
  float cellWidth, cellHeight;
  float gridWidth, gridHeight;
  float gridX, gridY;
  float cellBorderWeight;

  Grid(int columns_, int rows_) {
    columns = columns_;
    rows = rows_;
    gridX = 0;
    gridY = 0;
    gridWidth = width;
    gridHeight = height;
    // it is the line weight (line - stroke, strokeWeight(1)); use it to draw cell border in outer mode
    // in order to draw border you have to set cellBorderWeight to reguired value of strokeWeight
    // use method => Grid setBorderWeight(int weight);
    cellBorderWeight = 0;

    calculateCellSize();
  }

  Grid(int columns_, int rows_, float x, float y, float gridWidth_, float gridHeight_) {
    columns = columns_;
    rows = rows_;
    gridX = x;
    gridY = y;
    gridWidth = gridWidth_;
    gridHeight = gridHeight_;
    cellBorderWeight = 0;

    calculateCellSize();
  }

  // the border of the cell will be considered as outer border and 
  // its size will be removed from cell final size
  void calculateCellSize() { 
    cellWidth  = (gridWidth  - cellBorderWeight * (columns + 1)) / columns;
    cellHeight = (gridHeight - cellBorderWeight * (rows    + 1)) / rows;
  }

  float getBorderWeight() {
    return cellBorderWeight;
  }

  // the border of the cell will be considered as outer border and 
  // its size will be removed from cell final size
  Grid setBorderWeight(float weight) {
    cellBorderWeight = weight;

    calculateCellSize();
    return this;
  }

  PVector getLocation() {
    PVector location = new PVector(gridX, gridY);
    return location;
  }

  float getLocationX() {
    return gridX;
  }

  float getLocationY() {
    return gridY;
  }

  Grid setLocation(PVector location) {
    gridX = location.x;
    gridY = location.y;

    return this;
  }

  Grid setLocation(float x, float y) {
    gridX = x;
    gridY = y;

    return this;
  }

  // to center the grid in main window
  Grid setLocation(String location) {
    if (location.toLowerCase() == "center") {
      gridX = width  / 2 - gridWidth  / 2;
      gridY = height / 2 - gridHeight / 2;
    }

    return this;
  }

  // to center the grid in parent cell
  Grid setLocation(String location, Grid parent) {
    if (location.toLowerCase() == "center") {
      gridX = gridX + parent.getCellWidth()  / 2 - gridWidth  / 2;
      gridY = gridY + parent.getCellHeight() / 2 - gridHeight / 2;
    }

    return this;
  }

  float getGridWidth() {
    return gridWidth;
  }

  float getGridHeight() {
    return gridHeight;
  }

  Grid setSize(float newWidth, float newHeight) {
    gridWidth = newWidth;
    gridHeight = newHeight;

    calculateCellSize();

    return this;
  }

  boolean pointOnGrid(float x, float y) {
    float cellBorderStartX = borderColToX(0) - cellBorderWeight * 0.5;        // adding and removing border offset to
    float gridBorderEndX   = borderColToX(columns) + cellBorderWeight * 0.5;  // check the begining and end of grid
    float gridBorderStartY = borderRowToY(0) - cellBorderWeight * 0.5;
    float gridBorderEndY   = borderRowToY(rows) + cellBorderWeight * 0.5;
    return (x >= cellBorderStartX && x <= gridBorderEndX && y >= gridBorderStartY && y <= gridBorderEndY);
  }

  boolean pointOnGrid(PVector point) {
    return pointOnGrid(point.x, point.y);
  }

  boolean pointOnCell(float x, float y) {
    if (pointOnGrid(x, y)) {
      float cellX = cellColToX(xToCellCol(x));
      float cellY = cellRowToY(yToCellRow(y));

      return (x >= cellX && x <= cellX + cellWidth && y >= cellY && y <= cellY + cellHeight);
    }
    return false;
  }

  boolean pointOnCell(PVector point) {
    return pointOnCell(point.x, point.y);
  }

  boolean colInRange(int col) {
    return (col >= 0 && col < columns);
  }

  boolean rowInRange(int row) {
    return (row >= 0 && row < rows);
  }

  boolean colRowInRange(int col, int row) {
    return (colInRange(col) && rowInRange(row));
  }

  boolean indexInRange(int index) {
    return (index >= 0 && index < getCells());
  }

  // get x of cell by column
  float cellColToX(int col) {
    return gridX + cellBorderWeight * (col +  1) + col * cellWidth;
  }

  // get x of cell by column then add offset
  float cellColToX(int col, float offset) {
    return cellColToX(col) + cellWidth * offset;
  }

  // get y of the cell by row
  float cellRowToY(int row) {
    return gridY + cellBorderWeight * (row + 1) + row * cellHeight;
  }

  // get y of the cell by row then add offset
  float cellRowToY(int row, float offset) {
    return cellRowToY(row) + cellHeight * offset;
  }

  // get x border of the cell by column
  float borderColToX(int col) {
    return gridX + cellBorderWeight * 0.5 + col * (cellWidth + cellBorderWeight);
  }

  // get y border of the cell by row
  float borderRowToY(int row) {
    return gridY + cellBorderWeight * 0.5 + row * (cellHeight + cellBorderWeight);
  }

  // get x of the cell by index
  float cellIndexToX(int index) {
    return cellColToX(indexToCol(index));
  }

  // get x of the cell by index then add offset
  float cellIndexToX(int index, float offset) {
    return cellIndexToX(index) + cellWidth * offset;
  }

  // get y of the cell by index
  float cellIndexToY(int index) {
    return cellRowToY(indexToRow(index));
  }

  // get y of the cell by index then add offset
  float cellIndexToY(int index, float offset) {
    return cellIndexToY(index) + cellHeight * offset;
  }

  // get column of x in grid
  int xToCellCol(float x) {
    int column = floor((x - gridX)/(cellWidth + cellBorderWeight * 2));

    if (column == columns) {
      --column;
    }
    return column;
  }

  // get row of y in grid
  int yToCellRow(float y) {
    int row = floor((y - gridY)/(cellHeight + cellBorderWeight * 2));

    if (row == rows) {
      --row;
    }

    return row;
  }

  // convert piont in x and y to col and row
  PVector pointToColRow(float x, float y) {
    PVector colRow = new PVector(xToCellCol(x), yToCellRow(y));
    return colRow;
  }

  // convert piont in x and y to col and row
  PVector pointToColRow(PVector point) {
    return pointToColRow(point.x, point.y);
  }

  // point as x,y to index
  int pointToIndex(float x, float y) {
    return colRowToIndex(xToCellCol(x), yToCellRow(y));
  }

  // point as PVector to index
  int pointToIndex(PVector point) {
    return pointToIndex(point.x, point.y);
  }

  // one dimensional array grid
  // convert column & row to index of one dimensional array grid
  int colRowToIndex(int column, int row) {
    return column + row * columns;
  }

  // convert index of one dimensional array grid to column in two dimensional array
  int indexToCol(int index) {
    return index % columns;
  }

  // convert index of one dimensional array grid to row in two dimensional array
  int indexToRow(int index) {
    return floor(index/columns);
  }

  int getColumns() {
    return columns;
  }

  int getRows() {
    return rows;
  }

  float getCellWidth() {
    return cellWidth;
  }

  float getCellHeight() {
    return cellHeight;
  }

  int getCells() {
    return columns * rows;
  }
}