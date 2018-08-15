

Evolution evolution;
void setup() {
  frameRate(120);
  size(1000, 800);
  evolution = new Evolution();  
}

void draw() {
  surface.setTitle("FPS: " + round(frameRate));
  background(51);
  evolution.update();
}

void keyPressed() {
  evolution.keyPress(keyCode);
}