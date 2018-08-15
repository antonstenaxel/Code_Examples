import java.util.Map;

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

  void connectTo(Neuron neuron, float connectionWeight) {
    connectedNeurons.put(neuron, connectionWeight);
    numberOfConnections+=1;
  }


  void update() {
    float sum= 0;
    for (Map.Entry<Neuron, Float> map : connectedNeurons.entrySet()) {
      Neuron neuron = map.getKey();
      float weight = map.getValue();
      sum+= neuron.state * weight;
    }

    localField = sum - treshold;
    state = squashingFunction(localField);
  }

  float squashingFunction(float input) {
    float output = (float) Math.tanh(noiseParameter*input);
    return output;
  }


  void showLines() {
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
  void show() {


 

    fill(51);
    stroke(255);
    ellipse(position.x, position.y, 60, 60);
    fill(255);
    textAlign(CENTER, CENTER);
    text(state, position.x, position.y);
  }
}