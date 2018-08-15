function Swarm(N) {
    this.N = N;
    this.boids = [];
    this.center = createVector(0, 0);
    this.col = color(245, 200);
    
    for (i = 0; i < this.N; i++) {
        this.boids.push(new Boid(this, this.col, false));

    }
    
    if(debug){
    this.boids.push(new Boid(this, color(200, 0, 255, 200), true));
    }
    

    this.update = function () {

        for (i = 0; i < this.boids.length; i++) {
            this.boids[i].update();
            this.boids[i].display();
        }

    }


}
