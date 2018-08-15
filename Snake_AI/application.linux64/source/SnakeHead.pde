class SnakeHead extends GameObject {

  int numberOfWhiskers = 13;
  
  Whisker[] whiskers = new Whisker[numberOfWhiskers];
  Snake snake;

  // #########################  Constructor #########################   

  SnakeHead(Snake snake, PVector position) {
    this.game = snake.game;
    this.snake = snake;
    this.position = position;
    size=20;
    direction=PVector.random2D();
    snake.desiredDirection=direction.copy();
    attachWhiskers();
  }

  // #########################  Update #########################   

  void update() {
    if (snake.alive) {
      updateDirection();
      updatePosition();
      updateWhiskers();
    }
  }
  
  // #########################  Show #########################   

  void show() {
    noStroke();
    if (snake.alive) {
      fill(180, 180, 255, 180);
    } else {
      fill(40, 100);
    }
    ellipse(position.x, position.y, size, size);

    for (Whisker whisker : whiskers) {
      whisker.show();
    }
  }

  // #########################  Methods #########################   

  void updatePosition() {
    position=position.add(PVector.mult(direction, snake.speed));
  }

  void updateDirection() {
    direction.x= lerp(direction.x, snake.desiredDirection.x, 0.6);
    direction.y= lerp(direction.y, snake.desiredDirection.y, 0.6);
    direction.setMag(1);
  }

  void turn(float angle) {
    snake.desiredDirection.rotate(angle);
  }
  
  void attachWhiskers() {
    int count = 0;
    for (int i = -floor(numberOfWhiskers/2); i<= floor(numberOfWhiskers/2); i++) {
      float angle =  i* PI/(floor(numberOfWhiskers-1));
      whiskers[count] = new Whisker(this, angle);
      count +=1;
    }
  }

  void updateWhiskers() {
    for (Whisker whisker : whiskers) {
      whisker.update();
    }
  }
  
  float[][] getWhiskerInformation() {
    float[][] whiskerInformation =  new float[1][numberOfWhiskers*3];

    for (int i = 0; i < whiskers.length; i++) {
      whiskers[i].update();
      whiskerInformation[0][i]=whiskers[i].inContactWithMargins;
      whiskerInformation[0][i+numberOfWhiskers]=whiskers[i].inContactWithFood;
      whiskerInformation[0][i+2*numberOfWhiskers]=whiskers[i].inContactWithBody;
    }

    return whiskerInformation;
  }
}