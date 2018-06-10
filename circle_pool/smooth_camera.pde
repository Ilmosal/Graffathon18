class PathStop {
  // whether or not to use cubic interpolation
  boolean cubic;
  // the time in beats
  float time;
  // the position of the camera
  PVector pos;
  // the velocity of the camera
  PVector velocity;
  // the position of the center of the view
  PVector center;
  // the velocity of the center of the view
  PVector centerVelocity;
  // the up vector (not interpolated)
  PVector up;
  
  PathStop(float time, PVector pos, PVector center, PVector centerVelocity, PVector up) {
    this.time = time;
    this.pos = pos;
    this.velocity = new PVector();
    this.cubic = false;
    this.center = center;
    this.centerVelocity = centerVelocity;
    this.up = up == null ? new PVector(0, 1, 0) : up;
  }
  
  PathStop(float time, PVector pos, PVector velocity, PVector center, PVector centerVelocity, PVector up) {
    this.time = time;
    this.pos = pos;
    this.velocity = velocity;
    this.cubic = true;
    this.center = center;
    this.centerVelocity = centerVelocity;
    this.up = up == null ? new PVector(0, 1, 0) : up;
  }
}

PathStop[] path = new PathStop[] {
  new PathStop(0, new PVector(0, 0, 100), new PVector(0, 0, 0), new PVector(), null),
  new PathStop(6, new PVector(0, 0, 100), new PVector(0, 0, 0), new PVector(), null),
  new PathStop(6, new PVector(0, -100, 0), new PVector(0, 0, 0), new PVector(), new PVector(0, 0, -1)),
  new PathStop(10, new PVector(0, -100, 0), new PVector(0, 0, 0), new PVector(), new PVector(0, 0, -1)),
  new PathStop(10, new PVector(0, -350, 0), new PVector(0, 0, 0), new PVector(), new PVector(0, 0, -1)),
  new PathStop(14, new PVector(0, -350, 0), new PVector(0, 0, 0), new PVector(), new PVector(0, 0, -1)),
  new PathStop(14, new PVector(-250, -125, 90), new PVector(200, 0, 200), new PVector(0, -20, -230), new PVector(), null),
  new PathStop(32, new PVector(250, -125, 60), new PVector(200, 50, -200), new PVector(-50, 0, -180), new PVector(), null),
  new PathStop(48, new PVector(-250, -113, -19), new PVector(0, -13.8, 205), new PVector(-50, -120, 100), new PVector(), null),
  new PathStop(64, new PVector(180, -240, 70), new PVector(0, 0, -200), new PVector(0, -100, 0), new PVector(), null),
  new PathStop(80, new PVector(-180, -170, 70), new PVector(0, 20, 200), new PVector(0, -100, 0), new PVector(), null),
  new PathStop(96, new PVector(70, -90, 180), new PVector(200, 0, 0), new PVector(0, -100, 0), new PVector(), null),
  new PathStop(304, new PVector(70, -90, 180), new PVector(0, -100, 0), new PVector(), null),
  new PathStop(312, new PVector(35, -90, 90), new PVector(0, 200, 0), new PVector(), null),
};

int camIndex = 0;

PVector lastVel;

PVector interpolateLinear(PVector pos0, PVector pos1, float t) {
  return pos0.copy().mult(1 - t).add(pos1.copy().mult(t));
}

PVector interpolateCubic(PVector pos0, PVector vel0, PVector pos1, PVector vel1, float t) {
  float T = 1 - t;
  PVector p1 = pos0;
  PVector p2 = vel0.copy().add(pos0);
  PVector p3 = vel1.copy().mult(-1).add(pos1);
  PVector p4 = pos1;
  println(p1,p2,p3,p4);
  PVector pos = p1.copy().mult(T * T * T)
      .add(p2.copy().mult(3 * T * T * t))
      .add(p3.copy().mult(3 * T * t * t))
      .add(p4.copy().mult(t * t * t));
  PVector vel = p2.copy().sub(p1).mult(3 * T * T)
      .add(p3.copy().sub(p2).mult(6 * T * t))
      .add(p4.copy().sub(p3).mult(3 * t * t))
      .div(3.0);
  lastVel = vel;
  return pos;
}

void updateCamera(float time) {
  while (camIndex > 0 && path[camIndex].time > time) {
    camIndex--;
  }
  while (camIndex < path.length - 1 && path[camIndex + 1].time <= time) {
    camIndex++;
  }
  ((PGraphics3D) g).cameraNear = 0.01;
  PathStop from = path[camIndex];
  if (camIndex == path.length - 1) {
    camera(from.pos.x, from.pos.y, from.pos.z, from.center.x, from.center.y, from.center.z, from.up.x, from.up.y, from.up.z);
  } else {
    PathStop to = path[camIndex + 1];
    float length = to.time - from.time;
    float t = (time - from.time) / length;
    PVector pos, center;
    if (to.cubic) {
      pos = interpolateCubic(from.pos, from.velocity, to.pos, to.velocity, t);
      println(t, pos, lastVel, lastVel.mag());
      center = interpolateCubic(from.center, from.centerVelocity, to.center, to.centerVelocity, t);
    } else {
      pos = interpolateLinear(from.pos, to.pos, t);
      center = interpolateLinear(from.center, to.center, t);
    }
    camera(pos.x, pos.y, pos.z, center.x, center.y, center.z, to.up.x, to.up.y, to.up.z);
  }
}
