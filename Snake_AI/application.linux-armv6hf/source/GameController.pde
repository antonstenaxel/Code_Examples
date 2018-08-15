class GameController {

  boolean running = true;
  int margin = 10;
  int gameWidth = 800; 
  int gameHeight = 800;
  PVector[] margins;
  Snake snake;

  // #########################  Constructor #########################   

  GameController() {
    
    snake = new Snake(this);
    snake.game = this;
  }

 GameController(Snake snake) {
   
    this.snake = snake;
  }
  // #########################  Update #########################   

  void update() {
    snake.update();
   
    running = snake.alive;
  }

  // #########################  Show #########################   

  void show() {
    drawMargin();
    snake.show();
    if (running) {
      
    }
  }

  // #########################  Methods #########################   

  void drawMargin() {
    stroke(180, 100);
    noFill();
    rect(margin, margin, gameWidth-2*margin, gameHeight-2*margin);
  }

  void keyPress(int keyNumber) {

    switch(keyNumber) {
    case 37 : 
      snake.turn(-1); 
      break;
    case 39 : 
      snake.turn(1); 
      break;
    case 38 : 
      snake.grow(); 
      break;
      case 40 : 
      snake.stay(); 
      break;
    case 32 : 
      snake.reset(); 
      break;
    }
  }
}