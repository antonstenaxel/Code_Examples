class SnakeBody extends GameObject {

  color col;
  int desSize =15;

  GameObject target;
  Snake snake;

  // #########################  Constructor #########################   

  SnakeBody(GameObject target, color col, Snake snake) {
    size=0;
    this.position= PVector.add(target.position, PVector.mult(target.direction, -1)); 
    this.target = target;   
    this.snake=snake;
    this.col = col;
    this.game = snake.game;
  }

  // #########################  Update #########################   

  void update() {
    if (snake.alive) {
      followTarget();
      updateSize();
    }
  }

  // #########################  Show #########################   

  void show() {
    noStroke();
    if (snake.alive) {
      float intensity = map(snake.health, 0, 100, 0.3, 1);
      fill(intensity*red(col), intensity*green(col), intensity*blue(col), 100);
    } else {
      fill(30, 100);
    }
    ellipse(position.x, position.y, size, size);
  }
  
    // #########################  Methods #########################   

  void updateSize() {
    size = lerp(size, desSize, 0.4);
  }

  void followTarget() {
    direction = PVector.sub(target.position, position);
    float distance = direction.mag();
    direction.setMag(distance-(target.size/2+size/2));
    position.add(direction);
  }
}