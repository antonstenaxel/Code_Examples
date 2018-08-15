import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.Map; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Snake_AI extends PApplet {



Evolution evolution;
public void setup() {
  frameRate(120);
  
  evolution = new Evolution();  
}

public void draw() {
  surface.setTitle("FPS: " + round(frameRate));
  background(51);
  evolution.update();
}

public void keyPressed() {
  evolution.keyPress(keyCode);
}
class Evolution {

  int N=5;
  int generation = 1;
  int stage = 1;
  float lastBestFitness = 0 ; 

  float bestFitness = 0;

  GameController[] population = new GameController[N];
  float[] fitnessValues = new float[N];


  Evolution() {
    initializePopulation();
  }

  public void initializePopulation() {

    for (int i=0; i<N; i++) {
      GameController game = new GameController();
      population[i]= game;
    }
  }

  public void update() { 
    text("Generation: " + generation, 800, 100);
    text("Best Fitness: " + bestFitness, 800, 125);
    text("Last best fitness: " + lastBestFitness, 800, 150);

    try {
      for (GameController game : population) {
        game.show();
      }
    }
    catch( NullPointerException e) {
    }
    switch(stage) {
    case 1:
      for (GameController game : population) {
        game.update();
      }
      if (allGamesStopped()) {
        stage+=1;
      }
      break;
    case 2:
      evaluateIndividuals();
    case 3: 
      crossOver();
    case 4: 
      mutation();
    case 5: 
      reset();
      generation+=1;
      stage=1;
    }
  }


  public void crossOver() {
    println("Crossing over");

    GameController[] tempPopulation = new GameController[N];


    for (int i = 0 ; i < N; i++) {
      Snake snakeOne = selection();
      Snake snakeTwo = selection();

      Snake child = snakeOne.mate(snakeTwo);
      tempPopulation[i] = new GameController(child);
    }
    
   
    //int bestSnakeIndex= bestSnakeIndex();
   // GameController elite = new GameController(population[bestSnakeIndex].snake); // Elitism
    //elite.snake.reset();
     population = tempPopulation;
     //population[0] = elite;
  }

  public int bestSnakeIndex() {
    int bestSnakeIndex = 0;
    float bestFitness = 0 ; 
    for(int i = 0 ; i< N; i++){
      if(fitnessValues[i]>bestFitness){
        lastBestFitness = fitnessValues[i];
        bestSnakeIndex = i;
        bestFitness=fitnessValues[i];
      }
      
    }
 

    return bestSnakeIndex;
  }

  public Snake selection() {
    int snakeIndex=0;
    float r = random(1);
    float totalFitness = 0 ; 
    float partialFitness = 0;
    for (float f : fitnessValues) {
      totalFitness+=  f;
    }

    for (int i = 0; i < N; i++) {
      partialFitness +=  fitnessValues[i];
      if (partialFitness/totalFitness>=r) {
        snakeIndex=i;
        break;
      }
    }

    return population[snakeIndex].snake;
  }







  public void mutation() {
   for(GameController game : population){
     game.snake.mutate(0.01f);
   }
  }

  public void reset() {
    println("Resetting");
  };

  public void evaluateIndividuals() {
    println("Evaluating individuals");
    for (int i = 0; i < N; i++) {
      Snake snake = population[i].snake;
      fitnessValues[i] = snake.fitness;
      if (fitnessValues[i] > bestFitness) {
        bestFitness = fitnessValues[i];
      }
    }
  }

  public boolean allGamesStopped() {

    for (GameController game : population) {
      if (game.running) {
        return false;
      }
    }
    return true;
  }

  public void keyPress(int code) {
    for (GameController game : population) {
      game.keyPress(code);
    }
  }
}
class Food extends GameObject {

  float angle;
  float margin;
  float speed=0;
  int finalSize= 15;
  float nutrition = 20;
  
  // #########################  Constructor  #########################   

  Food(float margin, GameController game) {
    this.game = game;
    this.margin = 2.5f*margin;
    size=0;
    position = new PVector(random(margin, game.gameWidth-margin), random(margin,game.gameHeight-margin));
    direction = PVector.random2D();
  }

  // #########################  Update  #########################   
  
  public void update() {
    size = lerp(size, finalSize, 0.01f);
    if(speed > 0){
    angle = 0.8f*noise(frameCount)-0.4f;
    direction.rotate(angle);
    position.add(PVector.mult(direction, speed));
    isOutside();
    }
  }
  
  // #########################  Show  ######################### 

  public void show() {

    noStroke();
    fill(180, 255, 180, 120);
    ellipse(position.x, position.y, size, size);
  }


  // #########################  Methods  #########################   


  public void eat() {
    size=0;
    position.set(random(margin, game.gameWidth-margin), random(margin, game.gameHeight-margin));
  }

  public void isOutside() {
    if (position.x > game.gameWidth-margin || position.x<margin) {
      direction.x=-direction.x;
    } else if (position.y <margin || position.y > game.gameHeight-margin) {
      direction.y=-direction.y;
    }
  }
}
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

  public void update() {
    snake.update();
   
    running = snake.alive;
  }

  // #########################  Show #########################   

  public void show() {
    drawMargin();
    snake.show();
    if (running) {
      
    }
  }

  // #########################  Methods #########################   

  public void drawMargin() {
    stroke(180, 100);
    noFill();
    rect(margin, margin, gameWidth-2*margin, gameHeight-2*margin);
  }

  public void keyPress(int keyNumber) {

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
abstract class GameObject {
 
  PVector position;
  float size;
  PVector direction;
  GameController game;

  public void update() {
  }

  public void show() {
  }
}
class NeuralNetwork {

  int nInputs ;
  int nHidden; 
  int nOutputs;
  Neuron[] inputNeurons;
  Neuron[] hiddenNeurons;
  Neuron[] outputNeurons;



  NeuralNetwork(int nInputs, int nHidden, int nOutputs) {

    this.nInputs = nInputs;
    this.nHidden = nHidden;
    this.nOutputs = nOutputs;
    inputNeurons = new Neuron[nInputs];
    hiddenNeurons = new Neuron[nHidden];
    outputNeurons = new Neuron[nOutputs];

    initializeNetwork();
  }

  public void show() {
    for (Neuron neuron : inputNeurons) {
      neuron.showLines();
    }
    for (Neuron neuron : hiddenNeurons) {
      neuron.showLines();
    }
    for (Neuron neuron : outputNeurons) {
      neuron.showLines();
    }
    
    for (Neuron neuron : inputNeurons) {
      neuron.show();
    }
    for (Neuron neuron : hiddenNeurons) {
      neuron.show();
    }
    for (Neuron neuron : outputNeurons) {
      neuron.show();
    }
  }

  public void initializeNetwork() {
    for (int i = 0; i< nInputs; i++) {
      float yPos = map( i, -0.1f, nInputs-1+0.1f, 300, 500);
      inputNeurons[i] = new Neuron(new PVector(200, yPos));
    }
    for (int i = 0; i< nHidden; i++) {
      float yPos = map( i, -0.1f, nHidden-1+0.1f, 200, 600);
      hiddenNeurons[i] = new Neuron(new PVector(400, yPos));
      for(Neuron inputNeuron : inputNeurons){
        hiddenNeurons[i].connectTo(inputNeuron,random(-0.2f,0.2f));
      }
    }
    for (int i = 0; i< nOutputs; i++) {
      float yPos = map( i, -0.1f, nOutputs-1+0.1f, 300, 500);
      outputNeurons[i] = new Neuron(new PVector(600, yPos));
      for(Neuron hiddenNeuron : hiddenNeurons){
        outputNeurons[i].connectTo(hiddenNeuron,random(-0.2f,0.2f));
      }
    }
  }

  public float[] feed(Float[] input) {
    setInputStates(input);
    updateNetwork();

    float[] output = new float[nOutputs];

    for (int i = 0; i < nOutputs; i++) {
      output[i] = outputNeurons[i].state;
    }

    return output;
  }


  public void updateNetwork() {
  
    for (Neuron neuron : hiddenNeurons) {
      neuron.update();
    }
    for (Neuron neuron : outputNeurons) {
      neuron.update();
    }
  }

  public void setInputStates(Float[] input) {
    for (int i = 0; i < nInputs; i++) {
      inputNeurons[i].state=input[i];
    }
  }
}


class Neuron {


  HashMap<Neuron, Float> connectedNeurons = new  HashMap<Neuron, Float>();

  float state;
  float localField;
  int numberOfConnections = 0;
  float noiseParameter = 1;
  PVector position;
  float treshold;

  Neuron(PVector position) {
    this.position = position;
    state = random(-1, 1);
    treshold = random ( -1,1);
  }

  public void connectTo(Neuron neuron, float connectionWeight) {
    connectedNeurons.put(neuron, connectionWeight);
    numberOfConnections+=1;
  }


  public void update() {
    float sum= 0;
    for (Map.Entry<Neuron, Float> map : connectedNeurons.entrySet()) {
      Neuron neuron = map.getKey();
      float weight = map.getValue();
      sum+= neuron.state * weight;
    }

    localField = sum - treshold;
    state = squashingFunction(localField);
  }

  public float squashingFunction(float input) {
    float output = (float) Math.tanh(noiseParameter*input);
    return output;
  }


  public void showLines() {
       for (Map.Entry<Neuron, Float> map : connectedNeurons.entrySet()) {
      Neuron neuron = map.getKey();
      float weight = map.getValue();
      PVector neuronPos = neuron.position;
      float temp = map(abs(weight), 0, 1, 0, 3);
      strokeWeight(temp);
      if (weight >= 0) {
        stroke(180, 255, 180, 180);
      } else {
        stroke(255, 180, 180, 180);
      }
      line(position.x, position.y, neuronPos.x, neuronPos.y);
    }
  }
  public void show() {


 

    fill(51);
    stroke(255);
    ellipse(position.x, position.y, 60, 60);
    fill(255);
    textAlign(CENTER, CENTER);
    text(state, position.x, position.y);
  }
}
class Snake {

  boolean alive = true;
  float turnAngle=PI/32;
  float maxSpeed = 2;
  float speed = maxSpeed;
  float health = 100;
  float decayRate=0.1f;
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

  public void update() {
    fitness+=0.1f;
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

  public void show() {
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

  public float[][] getVisualInformation() {
    float[][] visualInformation = head.getWhiskerInformation();
    return visualInformation;
  }

  public void think() {
    float[][] visualInformation = getVisualInformation();
    float[][] action = brain.process(visualInformation);
    float action1 = map(action[0][0], 0, 1, -turnAngle, turnAngle);
   
    turn(action1);

  }

  public void grow() {   
    GameObject tail =  body.get(body.size()-1);
    int bodyColor = color(180, 180, map(cos(body.size()/2), -1, 1, 180, 255), 200);
    body.add(new SnakeBody(tail, bodyColor, this));
  }

  public void turn(float angle) {
    desiredDirection.rotate(angle);
  }

  public void turn(int direction) {
    turn(direction*turnAngle);
  }

  public boolean isOutsideMargins() {
    if ( head.position.x + head.size/2 > game.gameWidth-game.margin ||  
      head.position.x - head.size/2 < game.margin || 
      head.position.y + head.size/2 > game.gameHeight-game.margin ||  
      head.position.y - head.size/2 < game.margin) {
      return true;
    }
    return false;
  }

  public void displayScore() {
    fill(200, 200);
    text(body.size(), game.gameWidth/2, game.gameHeight-30);
  }

  public boolean crashingWithBody() {
    for (int i =2; i < body.size(); i++ ) {
      if (PVector.dist(head.position, body.get(i).position)<(head.size/2+body.get(i).size/2)) {
        return true;
      }
    }
    return false;
  }

  public void checkFood() {
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

  public void stay() {

    if (speed == maxSpeed) {
      speed = 0;
    } else {

      speed = maxSpeed;
    }
  }
  public void die() {
    alive = false;
    speed = 0;
    health = 0;
  }

  public void reset() {
    fitness = 0;
    speed = maxSpeed;
    body.clear();
    head = new SnakeHead(this, new PVector(game.gameWidth/2, game.gameHeight/2));
    body.add(head);
    alive = true;
    health = 100;
  }

  public Snake mate(Snake partner) {

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

  public void mutate(float pMut) {

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
class SnakeBody extends GameObject {

  int col;
  int desSize =15;

  GameObject target;
  Snake snake;

  // #########################  Constructor #########################   

  SnakeBody(GameObject target, int col, Snake snake) {
    size=0;
    this.position= PVector.add(target.position, PVector.mult(target.direction, -1)); 
    this.target = target;   
    this.snake=snake;
    this.col = col;
    this.game = snake.game;
  }

  // #########################  Update #########################   

  public void update() {
    if (snake.alive) {
      followTarget();
      updateSize();
    }
  }

  // #########################  Show #########################   

  public void show() {
    noStroke();
    if (snake.alive) {
      float intensity = map(snake.health, 0, 100, 0.3f, 1);
      fill(intensity*red(col), intensity*green(col), intensity*blue(col), 100);
    } else {
      fill(30, 100);
    }
    ellipse(position.x, position.y, size, size);
  }
  
    // #########################  Methods #########################   

  public void updateSize() {
    size = lerp(size, desSize, 0.4f);
  }

  public void followTarget() {
    direction = PVector.sub(target.position, position);
    float distance = direction.mag();
    direction.setMag(distance-(target.size/2+size/2));
    position.add(direction);
  }
}
class SnakeBrain {
  float[][] inputWeights;
  float[][] hiddenWeights;
  float[][] outputWeights;


  SnakeBrain() {
    this.inputWeights = randomMatrix(39,20,-0.1f,0.1f);
    this.hiddenWeights = randomMatrix(20,20,-0.1f,0.1f);
    this.outputWeights = randomMatrix(20,1,-0.1f,0.1f);
  }


SnakeBrain(float[][] inputWeights, float[][] hiddenWeights, float[][] outputWeights){
  this.inputWeights=inputWeights;
  this.hiddenWeights = hiddenWeights;
  this.outputWeights = outputWeights;

}
  public float[][] process(float[][] input) {
    float[][] interim = feedForward(input, inputWeights);
    interim = feedForward(interim,hiddenWeights);
    return feedForward(interim, outputWeights);
  }

  public float[][] feedForward(float[][] input, float[][] weights) {
    return sigmoid(multiply(input, weights));
  }


  public float[][] randomMatrix(int n, int m, float min, float max) {

    float[][] matrix = new float[n][m];

    for (int i = 0; i< n; i++) {
      for (int j = 0; j< m; j++) {
        matrix[i][j] = min + (max-min)*random(1);
      }
    }
    
    return matrix;
  }

  public float[][] multiply(float[][] a, float[][] b) {

    float[][] result = new float[a.length][b[0].length];
    for (int col=0; col <b[0].length; col++) {
      for (int row=0; row< a.length; row++) {
        for (int k = 0; k< a[0].length; k++ ) {
          result[row][col] = result[row][col] + a[row][k]*b[k][col];
        }
      }
    }
    return result;
  }

  public void printMatrix(float[][] matrix) {

    int n=matrix.length;
    int m= matrix[0].length;

    for (int row=0; row< n; row++) {
      for (int col=0; col <m; col++) {
        print(matrix[row][col]+",");
      }
      println();
    }
  }

  public float[][] sigmoid(float[][] input) {
    float[][] output = new float[input.length][input[0].length];
    float c=1;
    for (int i=0; i<input.length; i++) {
      for (int j=0; j<input[0].length; j++) {
        output[i][j] = 1/(1+exp(-c*input[i][j]));
      }
    }
    return output;
  }
}
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

  public void update() {
    if (snake.alive) {
      updateDirection();
      updatePosition();
      updateWhiskers();
    }
  }
  
  // #########################  Show #########################   

  public void show() {
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

  public void updatePosition() {
    position=position.add(PVector.mult(direction, snake.speed));
  }

  public void updateDirection() {
    direction.x= lerp(direction.x, snake.desiredDirection.x, 0.6f);
    direction.y= lerp(direction.y, snake.desiredDirection.y, 0.6f);
    direction.setMag(1);
  }

  public void turn(float angle) {
    snake.desiredDirection.rotate(angle);
  }
  
  public void attachWhiskers() {
    int count = 0;
    for (int i = -floor(numberOfWhiskers/2); i<= floor(numberOfWhiskers/2); i++) {
      float angle =  i* PI/(floor(numberOfWhiskers-1));
      whiskers[count] = new Whisker(this, angle);
      count +=1;
    }
  }

  public void updateWhiskers() {
    for (Whisker whisker : whiskers) {
      whisker.update();
    }
  }
  
  public float[][] getWhiskerInformation() {
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
class Whisker {

  SnakeHead head;
  boolean drawWhisker = true;
  float angle;
  PVector endPoint = new PVector(0, 0);
  PVector startPoint = new PVector(0, 0);
  int whiskerColor = color(255, 150);
  int whiskerFill = color(255, 10);
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

  public void update() {   
    if (head.snake.alive) {
      updateEndPoints();
      collectInformation();
    }
  }

  // #########################  Draw #########################   

  public void show() {
    if (drawWhisker && head.snake.alive) {
      drawWhisker();
    }
  }


  public void drawWhisker() {
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

  public void collectInformation() {
    inContactWithMargins = inContactWithMargins();
    inContactWithFood = inContactWithFood();
    inContactWithBody = inContactWithBody();
  }


  public void updateEndPoints() {
    startPoint.set(head.position.x+head.size/2*cos(head.direction.heading()+angle), head.position.y+head.size/2*sin(head.direction.heading()+angle));
    endPoint.set(head.position.x+vision*cos(head.direction.heading()+angle), head.position.y+vision*sin(head.direction.heading()+angle));
    whiskerVector = PVector.sub(endPoint, head.position);
  }

  public float inContactWithBody() {

    float minDist=2*vision;
    float dist = minDist;
    float returnVal = 0;
    for (int i = 1; i< head.snake.body.size(); i++) {


      GameObject bodyPart = head.snake.body.get(i);
      PVector headToBody = PVector.sub(bodyPart.position, head.position);
      dist = headToBody.mag();
      if (abs(PVector.angleBetween(headToBody, whiskerVector))<=visionAngle+0.1f && dist <= vision + bodyPart.size/2) {
        if (dist <minDist) {
          minDist = dist;
          returnVal = bind(map(minDist, head.size/2, vision-bodyPart.size/2, 1, 0));
        }
      }
    }
    return returnVal;
  }

  public float inContactWithFood() {
    for (Food food : head.snake.food) {

      PVector headToFood = PVector.sub(food.position, head.position);

      if (abs(PVector.angleBetween(headToFood, whiskerVector))<=visionAngle && headToFood.mag() <= vision+food.size/2) {
        return bind(map(headToFood.mag(), head.size/2, vision-food.size/2, 1, 0));
      }
    }
    return 0;
  }

  public float inContactWithMargins() {
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


  public PVector intersection(PVector p1, PVector p2, float x3, float y3, float x4, float y4) {

    float x1 = p1.x;
    float y1 = p1.y;
    float x2 = p2.x;
    float y2 = p2.y;


    float denominator = (x1-x2)*(y3-y4)-(y1-y2)*(x3-x4);
    float term1 = (x1*y2-y1*x2);
    float term2 = (x3*y4-y3*x4);

    return new PVector((term1*(x3-x4)-(x1-x2)*term2)/denominator, (term1*(y3-y4)-(y1-y2)*term2)/denominator);
  }
  public float bind(float number) {
    if (number < 0) {
      number = 0 ;
    } else if ( number > 1) {
      number = 1;
    }

    return number;
  }
}
  public void settings() {  size(1000, 800); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Snake_AI" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
