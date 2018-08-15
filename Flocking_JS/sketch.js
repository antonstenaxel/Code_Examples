var N = 100;
var s;
var Cc;
var Cl;
var Cs;
var vis;
var visAngle;
var maxSpeed;
var maxAcc;
var debug=true;


function setup() {
    frameRate(60);
    createCanvas(innerWidth , innerHeight);
    swarm = new Swarm(N);
    cSlider = createSlider(0, 1, 0.3, 0.01);
    cSlider.position(0, height - 20);
    lSlider = createSlider(0, 1, 1, 0.01);
    lSlider.position(150, height - 20);
    sSlider = createSlider(0, 1, 0.05, 0.01);
    sSlider.position(300, height - 20);
    visSlider = createSlider(0, 200, 50, 1);
    visSlider.position(450, height - 20);
    angSlider = createSlider(0.01, TWO_PI, PI, PI/180);
    angSlider.position(600, height - 20);
    
    velSlider = createSlider(0, 10, 4, 0.1);
    velSlider.position(750, height - 20);
    accSlider = createSlider(0, 5, 0.5, 0.01);
    accSlider.position(900, height - 20);

}

function draw() {

    background(180, 150, 255);
    stroke(240);
    strokeWeight(1);
    line(0,height-50,width,height-50);
    swarm.update();
    Cc = cSlider.value();
    Cl = lSlider.value();
    Cs = sSlider.value();
    vis = visSlider.value();
    visAngle = angSlider.value();
    maxSpeed=velSlider.value();
    maxAcc=accSlider.value();
    
    
    fill(120,180);
    textAlign(CENTER)
    textSize(13);
    text("Cohesion: " + floor(100*Cc) + "%",75,height-30)
    text("Alignment: " + floor(100*Cl) + "%",225,height-30)
    text("Separation: " + floor(100*Cs) + "%",375,height-30)
    text("Vis dist: " + floor(vis) + " px",525,height-30)
    text("Vis angle: " + floor(180/PI*visAngle+1) + " deg",675,height-30)
    text("Max speed: " + floor(maxSpeed*24) +" px/s",825,height-30)
    text("Max acc: " + floor(maxAcc*24) + " px/s2" ,975,height-30)
    




}
