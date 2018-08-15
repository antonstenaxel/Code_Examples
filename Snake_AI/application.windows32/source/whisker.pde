class Whisker {

  SnakeHead head;
  boolean drawWhisker = true;
  float angle;
  PVector endPoint = new PVector(0, 0);
  PVector startPoint = new PVector(0, 0);
  color whiskerColor = color(255, 150);
  color whiskerFill = color(255, 10);
  int vision;
  float visionAngle;
  PVector whiskerVector;
  float inContactWithMargins = 0;
  float inContactWithFood = 0;
  float inContactWithBody = 0;
  ArrayList<GameObject> bodyWithoutHead;

  // #########################  Constructor #########################   

  Whisker(SnakeHead head, float angle) {
    this.head = head;
    this.angle = angle;
    vision = head.snake.vision;
    visionAngle = PI/(2*(head.numberOfWhiskers));
    update();
  }

  // #########################  Update #########################   

  void update() {   
    if (head.snake.alive) {
      updateEndPoints();
      collectInformation();
    }
  }

  // #########################  Draw #########################   

  void show() {
    if (drawWhisker && head.snake.alive) {
      drawWhisker();
    }
  }


  void drawWhisker() {
    float r = map(inContactWithMargins, 0, 1, 40, 255);
    float g = map(inContactWithFood, 0, 1, 40, 255);
    float b = map(inContactWithBody, 0, 1, 40, 255);
    PVector c = new PVector(r, g, b);

    whiskerColor = color(100+r, 100+ g, 100+b, 0);
    whiskerFill = color(r, g, b, c.mag());

    strokeWeight(1);
    stroke(whiskerColor);  
    fill(whiskerFill);
    arc(startPoint.x, startPoint.y, 2*vision-head.size/2, 2*vision-head.size/2, whiskerVector.heading()-visionAngle, whiskerVector.heading()+visionAngle);
  }


  // #########################  Methods #########################   

  void collectInformation() {
    inContactWithMargins = inContactWithMargins();
    inContactWithFood = inContactWithFood();
    inContactWithBody = inContactWithBody();
  }


  void updateEndPoints() {
    startPoint.set(head.position.x+head.size/2*cos(head.direction.heading()+angle), head.position.y+head.size/2*sin(head.direction.heading()+angle));
    endPoint.set(head.position.x+vision*cos(head.direction.heading()+angle), head.position.y+vision*sin(head.direction.heading()+angle));
    whiskerVector = PVector.sub(endPoint, head.position);
  }

  float inContactWithBody() {

    float minDist=2*vision;
    float dist = minDist;
    float returnVal = 0;
    for (int i = 1; i< head.snake.body.size(); i++) {


      GameObject bodyPart = head.snake.body.get(i);
      PVector headToBody = PVector.sub(bodyPart.position, head.position);
      dist = headToBody.mag();
      if (abs(PVector.angleBetween(headToBody, whiskerVector))<=visionAngle+0.1 && dist <= vision + bodyPart.size/2) {
        if (dist <minDist) {
          minDist = dist;
          returnVal = bind(map(minDist, head.size/2, vision-bodyPart.size/2, 1, 0));
        }
      }
    }
    return returnVal;
  }

  float inContactWithFood() {
    for (Food food : head.snake.food) {

      PVector headToFood = PVector.sub(food.position, head.position);

      if (abs(PVector.angleBetween(headToFood, whiskerVector))<=visionAngle && headToFood.mag() <= vision+food.size/2) {
        return bind(map(headToFood.mag(), head.size/2, vision-food.size/2, 1, 0));
      }
    }
    return 0;
  }

  float inContactWithMargins() {
    int margin = head.game.margin;
    float distToMargin=2*vision;
    float tempVal;

    if (endPoint.y < margin) {
      PVector topIntersect = intersection(startPoint, endPoint, margin, margin, margin+100, margin);
      distToMargin = PVector.dist(topIntersect, startPoint);
    } else if (endPoint.x < margin) {
      PVector leftIntersect = intersection(startPoint, endPoint, margin, margin, margin, margin+10);
      tempVal = PVector.dist(leftIntersect, startPoint);
      if (tempVal < distToMargin) {
        distToMargin = tempVal;
      }
    } else if (endPoint.x > head.game.gameWidth-margin) {
      PVector rightIntersect = intersection(startPoint, endPoint, head.game.gameWidth, margin, head.game.gameWidth, margin+10);
      tempVal = PVector.dist(rightIntersect, startPoint);
      if (tempVal < distToMargin) {
        distToMargin = tempVal;
      }
    } else if (endPoint.y > head.game.gameHeight-margin) {
      PVector bottomIntersect = intersection(startPoint, endPoint, margin, head.game.gameHeight, margin+10, head.game.gameHeight);
      tempVal = PVector.dist(bottomIntersect, startPoint);
      if (tempVal < distToMargin) {
        distToMargin = tempVal;
      }
    }

    float returnVal = map(distToMargin, 0, vision-head.size/2, 1, 0);
    returnVal = bind(returnVal);
    return returnVal;
  }


  PVector intersection(PVector p1, PVector p2, float x3, float y3, float x4, float y4) {

    float x1 = p1.x;
    float y1 = p1.y;
    float x2 = p2.x;
    float y2 = p2.y;


    float denominator = (x1-x2)*(y3-y4)-(y1-y2)*(x3-x4);
    float term1 = (x1*y2-y1*x2);
    float term2 = (x3*y4-y3*x4);

    return new PVector((term1*(x3-x4)-(x1-x2)*term2)/denominator, (term1*(y3-y4)-(y1-y2)*term2)/denominator);
  }
  float bind(float number) {
    if (number < 0) {
      number = 0 ;
    } else if ( number > 1) {
      number = 1;
    }

    return number;
  }
}