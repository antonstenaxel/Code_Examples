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

  void show() {
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

  void initializeNetwork() {
    for (int i = 0; i< nInputs; i++) {
      float yPos = map( i, -0.1, nInputs-1+0.1, 300, 500);
      inputNeurons[i] = new Neuron(new PVector(200, yPos));
    }
    for (int i = 0; i< nHidden; i++) {
      float yPos = map( i, -0.1, nHidden-1+0.1, 200, 600);
      hiddenNeurons[i] = new Neuron(new PVector(400, yPos));
      for(Neuron inputNeuron : inputNeurons){
        hiddenNeurons[i].connectTo(inputNeuron,random(-0.2,0.2));
      }
    }
    for (int i = 0; i< nOutputs; i++) {
      float yPos = map( i, -0.1, nOutputs-1+0.1, 300, 500);
      outputNeurons[i] = new Neuron(new PVector(600, yPos));
      for(Neuron hiddenNeuron : hiddenNeurons){
        outputNeurons[i].connectTo(hiddenNeuron,random(-0.2,0.2));
      }
    }
  }

  float[] feed(Float[] input) {
    setInputStates(input);
    updateNetwork();

    float[] output = new float[nOutputs];

    for (int i = 0; i < nOutputs; i++) {
      output[i] = outputNeurons[i].state;
    }

    return output;
  }


  void updateNetwork() {
  
    for (Neuron neuron : hiddenNeurons) {
      neuron.update();
    }
    for (Neuron neuron : outputNeurons) {
      neuron.update();
    }
  }

  void setInputStates(Float[] input) {
    for (int i = 0; i < nInputs; i++) {
      inputNeurons[i].state=input[i];
    }
  }
}