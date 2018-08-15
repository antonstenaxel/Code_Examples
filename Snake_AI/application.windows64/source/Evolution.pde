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

  void initializePopulation() {

    for (int i=0; i<N; i++) {
      GameController game = new GameController();
      population[i]= game;
    }
  }

  void update() { 
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


  void crossOver() {
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

  int bestSnakeIndex() {
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

  Snake selection() {
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







  void mutation() {
   for(GameController game : population){
     game.snake.mutate(0.01);
   }
  }

  void reset() {
    println("Resetting");
  };

  void evaluateIndividuals() {
    println("Evaluating individuals");
    for (int i = 0; i < N; i++) {
      Snake snake = population[i].snake;
      fitnessValues[i] = snake.fitness;
      if (fitnessValues[i] > bestFitness) {
        bestFitness = fitnessValues[i];
      }
    }
  }

  boolean allGamesStopped() {

    for (GameController game : population) {
      if (game.running) {
        return false;
      }
    }
    return true;
  }

  void keyPress(int code) {
    for (GameController game : population) {
      game.keyPress(code);
    }
  }
}