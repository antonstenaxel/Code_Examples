class Food extends GameObject {

  float angle;
  float margin;
  float speed=0;
  int finalSize= 15;
  float nutrition = 20;
  
  // #########################  Constructor  #########################   

  Food(float margin, GameController game) {
    this.game = game;
    this.margin = 2.5*margin;
    size=0;
    position = new PVector(random(margin, game.gameWidth-margin), random(margin,game.gameHeight-margin));
    direction = PVector.random2D();
  }

  // #########################  Update  #########################   
  
  void update() {
    size = lerp(size, finalSize, 0.01);
    if(speed > 0){
    angle = 0.8*noise(frameCount)-0.4;
    direction.rotate(angle);
    position.add(PVector.mult(direction, speed));
    isOutside();
    }
  }
  
  // #########################  Show  ######################### 

  void show() {

    noStroke();
    fill(180, 255, 180, 120);
    ellipse(position.x, position.y, size, size);
  }


  // #########################  Methods  #########################   


  void eat() {
    size=0;
    position.set(random(margin, game.gameWidth-margin), random(margin, game.gameHeight-margin));
  }

  void isOutside() {
    if (position.x > game.gameWidth-margin || position.x<margin) {
      direction.x=-direction.x;
    } else if (position.y <margin || position.y > game.gameHeight-margin) {
      direction.y=-direction.y;
    }
  }
}