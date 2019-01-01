class Board
{
  int[] boardSquares;
  
  Board()
  {    
  }
  
  /// *********
  /// Setup
  /// *********
  void Setup()
  {
    boardSquares = new int[9];
    
    for (int i = 0; i < 9; i++)
    {
      boardSquares[i] = 0; // Start with a fresh, empty board. 0 indicates that a space is free.
    }
    
    stroke(255, 255, 255);
    strokeWeight(5);  // Thicker
    
    // I don't know why but both the horizontal and vertical lines need to have windowPadding/2 added whenever we do anything with windowWidth/3 or windowHeight/3
    // If we don't add the windowPadding/2, then the squares come out unevenly sized.
    
    // Horizontal lines
    line(windowPadding, windowHeight/3 + windowPadding/2, windowWidth, windowHeight/3 + windowPadding/2);
    line(windowPadding, windowHeight - windowHeight/3 + windowPadding/2, windowWidth, windowHeight - windowHeight/3 + windowPadding/2);
    
    // Vertical Lines
    line(windowWidth/3 + windowPadding/2, windowPadding, windowWidth/3 + windowPadding/2, windowHeight);
    line(windowWidth - windowWidth/3 + windowPadding/2, windowPadding, windowWidth - windowWidth/3 + windowPadding/2, windowHeight);
  }

  /// *********
  /// Helpers
  /// *********

  // Returns the index that a particular square is stored in boardSquares[]
  int getSquareIndex(int row, int column)
  {
    return (row * 3) + column;
  }
  
  // Returns the current status of the given board index. Not actually strictly necessary because this functionality is easy enough to just do
  int getSquareStatus(int index)
  {
    return boardSquares[index];
  }
  
  // Sets the status of a board index
  void setSquareStatus(int index, int status)
  {
    boardSquares[index] = status;
  }

  // Checks to see if a player has won the game yet
  boolean checkPlayerWon()
  {
    boolean playerWon = false; 
    int horizontalCombo = 0;
    
    // Possible winning game states
    // Horizontal:
    // 0, 1, 2
    // 3, 4, 5
    // 6, 7, 8
  
    // Vertical:
    // 0, 3, 6
    // 1, 4, 7
    // 2, 5, 8
  
    // Diagonal:
    // 0, 4, 8
    // 2, 4, 6
    
    for (int i = 0; i < 9; i++)
    {
      // Vertical check
      if (i < 3) // Only need to check if i is 0, 1, or 2 because we'll look at the other squares in the if statement
      {
        if (boardSquares[i] == currentPlayer && boardSquares[i + 3] == currentPlayer && boardSquares[i + 6] == currentPlayer)
        {
          playerWon = true;
          break;
        }
      }
      
      // Horizontal check
      if (i % 3 == 0) // We're on a new row so reset the horizontal combo to 0
      {
        horizontalCombo = 0;
      }
      
      if (boardSquares[i] == currentPlayer)
      {
        horizontalCombo ++;
      }
      
      if (horizontalCombo >= 3)
      {
        playerWon = true;
        break;
      }
    }
    
    // Diagonal check
    if ((boardSquares[0] == currentPlayer && boardSquares[4] == currentPlayer && boardSquares[8] == currentPlayer)
    || (boardSquares[2] == currentPlayer && boardSquares[4] == currentPlayer && boardSquares[6] == currentPlayer))
    {
      playerWon = true;
    }
    
    return playerWon;
  }

  // Draw an X in the given square
  void DrawX(int squareIndex)
  {
    int row = (int)squareIndex / 3;
    int column = squareIndex % 3;
    
    DrawX(row, column);
  }
  
  // Draw an X in the given square
  void DrawX(int row, int column)
  {
    int startDrawX = _getStartDrawX(column);
    int startDrawY = _getStartDrawY(row);
    
    stroke(0, 100, 255); // Set the stroke to blue for X's
    
    line(startDrawX, startDrawY, startDrawX + shapeWidth, startDrawY + shapeHeight);
    line(startDrawX, startDrawY + shapeHeight, startDrawX + shapeWidth, startDrawY);
  }
  
  // Draw an O in the given square
  void DrawO(int squareIndex)
  {
    int row = (int)squareIndex / 3;
    int column = squareIndex % 3;
    
    DrawO(row, column);
  }
  
  // Draw an O in the given square
  void DrawO(int row, int column)
  {
    int startDrawX = _getStartDrawX(column);
    int startDrawY = _getStartDrawY(row);
    
    stroke(0, 255, 50); // Set the stroke to green for O's
    
    ellipseMode(CORNER);
    fill(0);
    ellipse(startDrawX, startDrawY, shapeWidth, shapeHeight);
  }
  
  // Gets the X coordinate at which to start drawing the shape.
  private int _getStartDrawX(int currentColumn)
  {
    int drawX = 0;
    
    switch (currentColumn)
    {
      case 0:
        drawX = windowPadding;
        break;
      case 1: 
        drawX = windowWidth/3 + windowPadding/2 + 5;
        break;
      case 2: 
        drawX = windowWidth - windowWidth/3 + windowPadding/2 + 10;
        break;
    }
    
    return drawX + squarePadding; // Pad each square a little bit
  }
  
  // Gets the Y coordinate at which to start drawing the shape.
  private int _getStartDrawY(int currentRow)
  {
    int drawY = 0;
    
    switch (currentRow)
    {
      case 0:
        drawY = windowPadding;
        break;
      case 1: 
        drawY = windowHeight/3 + windowPadding/2 + 5;
        break;
      case 2: 
        drawY = windowHeight - windowHeight/3 + windowPadding/2 + 10;
        break;
    }
    
    return drawY + squarePadding; // Pad each square a little bit
  }
}
