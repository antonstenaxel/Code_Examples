class Snake {

  boolean alive = true;
  float turnAngle=PI/32;
  float maxSpeed = 2;
  float speed = maxSpeed;
  float health = 100;
  float decayRate=0.1;
  int vision = 150;
  float fitness;


  PVector desiredDirection;

  SnakeBrain brain;
  SnakeHead head;
  Food[] food = new Food[5];
  ArrayList<GameObject> body = new ArrayList();
  GameController game;



  // #########################  Constructor #########################  

  Snake(GameController game, SnakeBrain brain) {
    for(int i = 0; i<5 ; i++){
    food[i] = new Food(game.margin, game);
    }
    this.game = game;
    this.brain = brain;
    head = new SnakeHead(this, new PVector(game.gameWidth/2, game.gameHeight/2));
    body.add(head);
  }
  Snake(GameController game) {
    this(game, new SnakeBrain());
  }

  // #########################  Update #########################   

  void update() {
    fitness+=0.1;
    for (GameObject bodypart : body) {
      bodypart.update();
    }

    if (alive && frameCount %2 ==0 ) {
      checkFood();
      for(Food food: food){
      food.update();
      }
      health -= decayRate;
      think();
      if (isOutsideMargins() || crashingWithBody() || health <= 0) {
        die();
      }
    }

    displayScore();
  }

  // #########################  Show #########################   

  void show() {
    for (GameObject bodypart : body) {
      bodypart.show();
    }
    if (alive) {
       for(Food food: food){
      food.show();
      }
    }
  }

  // #########################  Methods #########################   

  float[][] getVisualInformation() {
    float[][] visualInformation = head.getWhiskerInformation();
    return visualInformation;
  }

  void think() {
    float[][] visualInformation = getVisualInformation();
    float[][] action = brain.process(visualInformation);
    float action1 = map(action[0][0], 0, 1, -turnAngle, turnAngle);
   
    turn(action1);

  }

  void grow() {   
    GameObject tail =  body.get(body.size()-1);
    color bodyColor = color(180, 180, map(cos(body.size()/2), -1, 1, 180, 255), 200);
    body.add(new SnakeBody(tail, bodyColor, this));
  }

  void turn(float angle) {
    desiredDirection.rotate(angle);
  }

  void turn(int direction) {
    turn(direction*turnAngle);
  }

  boolean isOutsideMargins() {
    if ( head.position.x + head.size/2 > game.gameWidth-game.margin ||  
      head.position.x - head.size/2 < game.margin || 
      head.position.y + head.size/2 > game.gameHeight-game.margin ||  
      head.position.y - head.size/2 < game.margin) {
      return true;
    }
    return false;
  }

  void displayScore() {
    fill(200, 200);
    text(body.size(), game.gameWidth/2, game.gameHeight-30);
  }

  boolean crashingWithBody() {
    for (int i =2; i < body.size(); i++ ) {
      if (PVector.dist(head.position, body.get(i).position)<(head.size/2+body.get(i).size/2)) {
        return true;
      }
    }
    return false;
  }

  void checkFood() {
 for(Food food: food){
   
    if (PVector.dist(head.position, food.position)<head.size/2+food.size/2) {
      food.eat();
      health+=food.nutrition;
      if (health > 100) {
        health = 100;
      }
      grow();
      fitness+=100;
    }
 }
  }

  void stay() {

    if (speed == maxSpeed) {
      speed = 0;
    } else {

      speed = maxSpeed;
    }
  }
  void die() {
    alive = false;
    speed = 0;
    health = 0;
  }

  void reset() {
    fitness = 0;
    speed = maxSpeed;
    body.clear();
    head = new SnakeHead(this, new PVector(game.gameWidth/2, game.gameHeight/2));
    body.add(head);
    alive = true;
    health = 100;
  }

  Snake mate(Snake partner) {

    float[][] iwh = brain.inputWeights;
    float[][] hwh = brain.hiddenWeights;
    float[][] owh = brain.outputWeights;
    float[][] iww = partner.brain.inputWeights;
    float[][] hww = partner.brain.hiddenWeights;
    float[][] oww = partner.brain.outputWeights;

    float[][] iwc = new float[iwh.length][iwh[0].length];
    float[][] hwc = new float[hwh.length][hwh[0].length];
    float[][] owc = new float[owh.length][owh[0].length];

    int crossoverPointInput = (int) random(iwh.length);
    int crossoverPointHidden = (int) random(hwh.length);
    int crossoverPointOutput = (int) random(owh.length);

    for (int i = 0; i< iwh.length; i++) {
      if (i<crossoverPointInput) {
        iwc[i] = iwh[i];
      } else {
        iwc[i] = iww[i];
      }
    }

    for (int i = 0; i< hwh.length; i++) {
      if (i<crossoverPointHidden) {
        hwc[i] = hwh[i];
      } else {
        hwc[i] = hww[i];
      }
    }
    for (int i = 0; i< owh.length; i++) {
      if (i<crossoverPointOutput) {
        owc[i] = owh[i];
      } else {
        owc[i] = oww[i];
      }
    }

    SnakeBrain childBrain = new SnakeBrain(iwc, hwc, owc);
    Snake child = new Snake(game, childBrain);
    return child;
  }

  void mutate(float pMut) {

    float[][] iwh = brain.inputWeights;
    float[][] hwh = brain.hiddenWeights;
    float[][] owh = brain.outputWeights;


    for (int i = 0; i< iwh.length; i++) {
      for (int j = 0; j< iwh[0].length; j++) {
        if (random(1)<pMut) {
          brain.inputWeights[i][j] = random(-1, 1);
        }
      }
    }
    for (int i = 0; i< hwh.length; i++) {
      for (int j = 0; j< hwh[0].length; j++) {
        if (random(1)<pMut) {
          brain.hiddenWeights[i][j] = random(-1, 1);
        }
      }
    }
    for (int i = 0; i< owh.length; i++) {
      for (int j = 0; j< owh[0].length; j++) {
        if (random(1)<pMut) {
          brain.outputWeights[i][j] = random(-1, 1);
        }
      }
    }
  }
}