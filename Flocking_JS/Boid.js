function Boid(swarm, col, debug) {
    this.debug = debug;
    this.swarm = swarm;
    this.col = col;

    this.size = 18;
    this.maxSpeed = maxSpeed;
    this.maxAcc = maxAcc;

    this.vel = createVector(random(0.5) - 0.25, random(0.5) - 0.25);
    this.pos = createVector(random(width), random(height));
    this.acc = createVector(0, 0);

    this.neighbourhood = new Neighbourhood(this);

    this.vis = vis;
    this.visAngle = PI / 2;

    this.T = 4;
    this.hardEdge = false;


    this.update = function () {

        this.visAngle = visAngle;
        this.vis = vis;
        this.maxSpeed = maxSpeed;
        this.maxAcc = maxAcc;

        this.applyForce();
        this.vel.add(this.acc);
        this.vel.limit(this.maxSpeed);
        this.pos.add(this.vel);

        this.checkBounds();
        this.neighbourhood.update();

        if (this.debug) {
            this.displayDebug();
        }

    }


    this.applyForce = function () {

        this.force = createVector(0, 0);

        if (this.neighbourhood.exists) {

            this.force.add(this.cohesion().mult(Cc));
            this.force.add(this.alignment().mult(Cl));
            this.force.add(this.separation().mult(Cs));

        }

        this.acc.set(this.force);
        this.acc.limit(this.maxAcc);

    }

    this.cohesion = function () {
        this.rho = this.neighbourhood.pos.copy();
        return p5.Vector.sub(this.rho, this.pos).mult(1 / (this.T * this.T));

    }

    this.alignment = function () {
        return this.neighbourhood.vel.mult(1 / (this.T * this.neighbourhood.members.length));
    }

    this.separation = function () {

        this.m = this.neighbourhood.members;
        this.temp = createVector(0, 0);
        for (k = 0; k < this.m.length; k++) {
            this.temp.add(p5.Vector.sub(this.pos, this.m[k].pos));
        }
        return this.temp.mult(1 / pow(this.T, 2));

    }
    
   

    this.checkBounds = function () {


        if (this.hardEdge) {
            if (this.pos.x < 0 || this.pos.x > width) {
                this.vel.x = -this.vel.x;
            } else if (this.pos.y < 0 || this.pos.y > height - 50) {
                this.vel.y = -this.vel.y;
            }
        } else {
            if (this.pos.x < 0) {
                this.pos.x = width;
            } else if (this.pos.x > width) {
                this.pos.x = 0;
            } else if (this.pos.y < 0) {
                this.pos.y = height - 50;
            } else if (this.pos.y > height - 50) {
                this.pos.y = 0;
            }
        }

    }

    this.display = function () {
        
        fill(col);
        stroke(200,100);
       
        push();
        translate(this.pos.x, this.pos.y);
        rotate(this.vel.heading());
        
        this.tail=map(this.vel.mag(),0,maxSpeed,0.6,0.2);
        
        arc(0, 0, this.size, this.size, (1-this.tail/2) * PI, (1+this.tail/2) * PI,PIE);
        pop();
        
    }

    this.displayDebug = function () {
        //visibility circle
        noFill();
        stroke(255);
        push();
        translate(this.pos.x, this.pos.y);
        rotate(this.vel.heading());
        arc(0, 0, this.vis * 2, this.vis * 2, -this.visAngle / 2, this.visAngle / 2, PIE)
        pop();
    }
}
