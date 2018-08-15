function Neighbourhood(boid) {
    this.boid = boid;
    this.debug = this.boid.debug;
    this.swarm = this.boid.swarm;
    this.pos = createVector(0, 0); // Center of neighbourhood
    this.vel = createVector(0, 0); // Velocity of neighbourhood;
    this.members = [];
    this.exists = false;

    this.update = function () {

        this.findMembers();

        if (this.members.length > 0) {
            this.exists = true;
            this.updateCenter();
            this.updateHeading();
            
            if (this.debug) {
                this.displayDebug();
            }
            
        } else {
            this.exists = false;
        }

    }


    this.findMembers = function () {
        
        this.temp = [];
        
        for (j = 0; j < this.swarm.N; j++) {
            this.d = p5.Vector.dist(this.boid.pos, this.swarm.boids[j].pos);
            push();
            translate(this.boid.pos.x, this.boid.pos.y);
            this.tempvec = p5.Vector.sub(this.swarm.boids[j].pos, this.boid.pos);
            this.ang = p5.Vector.angleBetween(this.boid.vel, this.tempvec);
            this.withinDistance = this.d < this.boid.vis;
            this.withinAngle = abs(this.ang) < this.boid.visAngle / 2;
            pop();




            if (this.withinDistance && this.withinAngle && this.swarm.boids[j] != this.boid) {
                this.temp.push(this.swarm.boids[j]);

            }

        }
        this.members = this.temp;
    }

    this.updateHeading = function () {
        
        this.vel.set(this.boid.vel.x, this.boid.vel.y);
        this.number = this.members.length;
        
        for (k = 0; k < this.number; k++) {
            this.vel.add(this.members[k].vel);
        }
        
        this.vel.div(this.number + 1);

    }

    this.updateCenter = function () {

        this.pos.set(this.boid.pos.x, this.boid.pos.y);
        this.number = this.members.length;

        for (k = 0; k < this.number; k++) {
            this.pos.add(this.members[k].pos);
        }
        
        this.pos.div(this.number + 1);
        
    }

    this.displayDebug = function () {

        fill(255, 100);
        ellipse(this.pos.x, this.pos.y, 20, 20);
        stroke(255, 10)
        strokeWeight(1);

        push();
        translate(this.pos.x, this.pos.y);
        strokeWeight(5);
        fill(0, 255);

        this.head = this.vel.copy();
        this.head.setMag(13);
        ellipse(this.head.x, this.head.y, 5, 5);
        pop();

        for (l = 0; l < this.members.length; l++) {
            stroke(255);
            line(this.boid.pos.x, this.boid.pos.y, this.members[l].pos.x, this.members[l].pos.y)
        }
        
    }
}
