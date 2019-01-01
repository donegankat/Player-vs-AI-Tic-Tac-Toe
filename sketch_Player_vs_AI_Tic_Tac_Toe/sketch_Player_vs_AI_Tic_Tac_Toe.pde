/// *********
/// Variables
/// *********

private Board _board;

// We'll treat the window width & height as a bit smaller than we actually make it so that we have a border around the game board 
int windowWidth = 840;
int windowHeight = 840;
int windowPadding = 40;

int squarePadding = 20; // The space between the square edges and the shapes we're going to draw in them

int currentPlayer = 1; // 1 is X, 2 is O

int shapeWidth = windowWidth/3 - windowPadding - squarePadding;
int shapeHeight = windowHeight/3 - windowPadding - squarePadding;


/// *********
/// Setup
/// *********

void setup() // Pretty sure all Processing projects need this void setup()
{
  size(880,920); // This is the actual window size: (x:880, y:920), so it's quite a bit bigger than what we've accounted for with in windowWidth and int windowHeight.
  noStroke();
  background(0);
  
  PFont f = createFont("Arial", 24);
  textFont(f);
  
  _board = new Board();
  _board.Setup();
}

void draw() // This doesn't need to do anything but it can be called if we need to refresh the screen
{
  
}


/// *********
/// Events
/// *********

void mouseClicked()
{
  boolean validClick = true;
  
  int row = 0;
  int column = 0;
  
  // Make sure the click was in a valid area. If the user clicked outside of the game board, don't do anything.
  // If the click was valid, calculate which square was clicked.
  
  // Evaluate which column was clicked
  if (mouseX >= windowPadding && mouseX <= windowWidth/3) // Click was in the left column
  {
    column = 0;
  }
  else if (mouseX > windowWidth/3 && mouseX <= windowWidth - windowWidth/3) // Click was in the middle column
  {
    column = 1;
  }
  else if (mouseX > windowWidth - windowWidth/3 && mouseX < windowWidth - windowPadding) // Click was in the right column
  {
    column = 2;
  }
  else // The click was off the board somewhere
  {
    validClick = false;
  }
  
  // Evaluate which row was clicked
  if (mouseY >= windowPadding && mouseY <= windowHeight/3) // Click was in the top row
  {
    row = 0;
  }
  else if (mouseY > windowHeight/3 && mouseY <= windowHeight - windowHeight/3) // Click was in the middle row
  {
    row = 1;
  }
  else if (mouseY > windowHeight - windowHeight/3 && mouseY < windowHeight - windowPadding) // Click was in the bottom row
  {
    row = 2;
  }
  else // The click was off the board somewhere
  {
    validClick = false;
  }
    
  if (validClick) // The click was in a valid area
  {
    int currentSquareIndex = _board.getSquareIndex(row, column); // Figure out which square was clicked on
    
    TakeTurn(currentSquareIndex);
  }
  else // The click wasn't in a square so let the player know they had a bad click & need to try again
  {
    _printMessage("INVALID CLICK", false); // Print on the screen for the player to see
  }
}

// Takes a turn and draws the current player's shape on the screen.
void TakeTurn(int currentSquareIndex)
{
  int currentSquareStatus = _board.getSquareStatus(currentSquareIndex); // Check to see if the square that was clicked was already occupied
  
  if (currentSquareStatus == 0) // If the square is empty then we can fill it in.
  {
    _board.setSquareStatus(currentSquareIndex, currentPlayer); // Mark that this square is now filled by the current player
        
    boolean playerWon = _board.checkPlayerWon(); // Check to see if the player won the game
    if (playerWon) // Winner
    {
      _printMessage("PLAYER " + currentPlayer + " WON", true); // Print on the screen for the player to see
      println("PLAYER", currentPlayer, "WON"); // Print to the console window
    }
    else
    {
      _eraseMessage(); // Clear any previous text from below the board
    }
    
    if (currentPlayer == 1) // Player 1 is playing, so draw an X
    {
      _board.DrawX(currentSquareIndex);
      currentPlayer = 2; // Switch from X to O next time
      TakeComputerTurn();
    }
    else // Player 2 is playing, so draw an O
    {
      _board.DrawO(currentSquareIndex);
      currentPlayer = 1; // switch from O to X next time
    }
  }
}

// Evaluates and takes the computer's turn.
void TakeComputerTurn()
{
  int[] originalBoardSquares = new int[9]; //<>//
  arrayCopy(_board.boardSquares, originalBoardSquares); // Make a copy of the original board state for safe keeping.
  
  int bestMove = EvaluateComputerMoves();
  
  currentPlayer = 2; // Make sure that after evaluating moves we set the player back to the computer. //<>//
  arrayCopy(originalBoardSquares, _board.boardSquares); // Reset to the original board state.
  
  TakeTurn(bestMove);  
}

// Tests out possible moves and returns the move that's the best possible option.
// TODO: Make this recursive so the computer looks several moves ahead.
// TODO: Weight moves that would block the player from winning, or for doing some other tricksy strategy.
int EvaluateComputerMoves()
{
  int bestMove = 0;
  
  for(int currentIndex = 0; currentIndex < _board.boardSquares.length; currentIndex++) // Look through all possible moves
  {
    int currentMoveScore = 0;
    int currentSquareStatus = _board.getSquareStatus(currentIndex);
    
    if (currentSquareStatus == 0) // This space is available to move into
    {
      _board.setSquareStatus(currentIndex, currentPlayer); // Mark that this square is now filled by the current player
      
      if (_board.checkPlayerWon())
      {
        if (currentPlayer == 1)
        {
          currentMoveScore = -1000; // This was a bad outcome for the computer. The player won
        }
  
        currentMoveScore = 1000; // This was a good outcome for the computer
      }
      
      if (currentMoveScore > bestMove)
        bestMove = currentIndex;
    }
  }
  
  return bestMove;
}



/// *********
/// Helpers
/// *********
 //<>//
// Prints a message on the screen below the board.
// TODO: If I ever feel like making this a better game, the redFill parameter should be changed to a fancier way of defining the text color.
// TODO: I should also add an x and y parameter to let the text position be customizable.
private void _printMessage(String message, boolean redFill) // The redFill boolean is just a lazy, shitty way for me to indicate if the text should be red. Otherwise have the text be white.
{
  if (redFill) // Red is used when a player has won the game
  {
    fill(255, 0, 0);
  }
  else // All other notifications are white.
  {
    fill(255, 255, 255); 
  }
  
  text(message, windowPadding, 900); // Print on the screen for the player to see
}

// This is just a super hacky, shitty way to erase any text we've previously printed below the board. I'm being lazy so I'm just going to cover it up rather than redraw the canvas or anything.
// TODO: If I ever actually do anything with this game, make this better.
// TODO: I should also add an x and y parameter to let the text position be customizable.
private void _eraseMessage()
{
  fill(0);
  noStroke();
  rect(0, 900 - 24, windowWidth, windowPadding);
}
