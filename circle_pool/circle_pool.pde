import peasy.*;

import moonlander.library.*;

import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

final int layers = 5;
final int sphereRadius = 20;
final int padding = 5;
final float rotateSpeed = 0.03;

final float minOffset = 2 * sphereRadius + 1;

final Shape[] shapes = new Shape[] {
  new Shape(new float[]{50, 50, 50, 50, -50, -50, -50, -50},
            new float[]{-300, -300, -200, -200, -300, -300, -200, -200},
            new float[]{50, -50, 50, -50, 50, -50, 50, -50}),
  new Shape(new float[]{70, 70, 70, 70, -70, -70, -70, -70},
            new float[]{-280, -280, -220, -220, -280, -280, -220, -220},
            new float[]{70, -70, 70, -70, 70, -70, 70, -70})
};

Dot[] dots;
int[] maxCounts = new int[layers];

PeasyCam cam;

void setup() {
  size(800, 600, P3D);
  //fullScreen(P3D);
  
  colorMode(HSB, 360, 100, 100);
  cam = new PeasyCam(this, 100);
  cam.setSuppressRollRotationMode();
  // calculate max number of dots
  int totalCount = 0;
  for (int layer = 0; layer < layers; layer++) {
    int count = 1;
    // basic trigonometry to figure out the biggest n-gon we can fit
    while (0.5 / sin(PI / count) <= layer) {
      count++;
    }
    count--;
    maxCounts[layer] = count;
    totalCount += count;
  }
  // init the dots in the pool
  dots = new Dot[totalCount];
  for (int layer = 0, i = 0; layer < layers; layer++) {
    for (int j = 0; j < maxCounts[layer]; j++) {
      Dot dot = dots[i++] = new Dot();
      dot.start.pool = true;
      dot.start.layer = layer;
      dot.start.x = dot.start.slot = j;
      dot.end = dot.start;
    }
  }
}

float optimalFrac(boolean min, int[] counts) {
  float bestFrac = counts[0] / maxCounts[0];
  for (int i = 1; i < layers; i++) {
    float frac = (float) counts[i] / maxCounts[i];
    if (min ? frac < bestFrac : frac > bestFrac) {
      bestFrac = frac;
    }
  }
  return bestFrac;
}

void setShape(Shape shape) {
  int[] counts = new int[layers];
  // move the end locations to be starts and count dots starting on each layer
  for (int i = 0; i < dots.length; i++){
    Dot dot = dots[i];
    dot.start = dot.end.copy();
    dot.end.pool = true;
    if (dot.start.pool) {
      counts[dot.end.layer]++;
    }
  }
  boolean[][] slotsUsed = new boolean[layers][];
  for (int i = 0; i < layers; i++) {
    slotsUsed[i] = new boolean[maxCounts[i]];
  }
  // spread the dots starting in the pool evenly in slots
  int[] layerSeen = new int[layers];
  int minSlot = -1;
  for (int i = 0; i < dots.length; i++) {
    Dot dot = dots[i];
    if (dot.start.pool) {
      if (minSlot == -1) {
        minSlot = dot.end.slot;
      } else {
        dot.end.slot = minSlot + layerSeen[dot.end.layer] * maxCounts[dot.end.layer] / counts[dot.end.layer];
      }
      layerSeen[dot.end.layer]++;
      slotsUsed[dot.end.layer][dot.end.slot] = true;
    }
  }
  // choose dots to the shape
  int shaped = 0;
  while (shaped < shape.x.length) {
    Dot dot = dots[(int) random(dots.length)];
    // skip dots that are already used in the shape
    if (!dot.end.pool) continue;
    // skip dots that are on an emptier layer than the fullest
    // TODO: fix
    //if (dot.start.pool) {
    //  float maxFrac = optimalFrac(false, counts);
    //  float frac = counts[dot.end.layer] / maxCounts[dot.end.layer];
    //  if (frac < maxFrac) {
    //    println("skipped subopt " + dot + " " + frac + " " + maxFrac); continue;} //<>//
    //}
    // use the dot
    dot.end.pool = false;
    dot.end.x = shape.x[shaped];
    dot.end.y = shape.y[shaped];
    dot.end.z = shape.z[shaped];
    // update counts
    if (dot.start.pool) {
      counts[dot.end.layer]--;
      slotsUsed[dot.end.layer][dot.end.slot] = false;
    }
    shaped++;
  }
  // find free slots for the dots returning to the pool
  for (int i = 0; i < dots.length; i++) {
    Dot dot = dots[i];
    if (dot.end.pool && !dot.start.pool) {
      // find a minimally empty layer to insert in
      float minFrac = optimalFrac(true, counts);
      int layer;
      do {
        layer = (int) random(layers);
      } while ((float) counts[layer] / maxCounts[layer] > minFrac);
      // find a free slot
      int slot;
      int tries = 0;
      do {
        slot = (int) random(maxCounts[layer]);
        if (tries++>1000){
          tries=1;
        }
      } while (slotsUsed[layer][slot]);
      // use the slot
      dot.end.layer = layer;
      dot.end.slot = slot;
      counts[layer]++;
      slotsUsed[layer][slot] = true;
    }
  }
  // sort the dots by layer/slot
  java.util.Arrays.sort(dots, new DotComparator());
  // spread the dots in each layer evenly
  layerSeen = new int[layers];
  for (int i = 0; i < dots.length; i++) {
    Dot dot = dots[i];
    if (dot.end.pool) {
      dot.end.x = (float) layerSeen[dot.end.layer] * maxCounts[dot.end.layer] / counts[dot.end.layer];
      layerSeen[dot.end.layer]++;
    }
  }
}

PVector resolvePoolLoc(int layer, float x) {
  float radius = layer * minOffset;
  float speed = layer == 0 ? 0 : pow(-1, layer) * rotateSpeed / radius;
  float angle = TAU * x / maxCounts[layer] + speed * millis();
  return new PVector(sin(angle) * radius, 0, cos(angle) * radius);
}

PVector resolveLoc(Location loc) {
  return loc.pool ? resolvePoolLoc(loc.layer, loc.x) : new PVector(loc.x, loc.y, loc.z);
}

int shapeNo = 0;

boolean debugger = false;

final int period = 3000;

void draw() {
  background(255);
  noLights();
  ambientLight(0, 0, 50);
  directionalLight(0, 0, 50, 1, 10, 2);
  fill(128);
  noStroke();
  
  if (millis() / period > shapeNo) {
    shapeNo++;
    setShape(shapes[(int) random(shapes.length)]);
  }
  float phase = millis() % period > period / 2 ? 1 : (1 - cos(millis() / (float) period * TAU)) / 2;
  
  if (debugger) {
    for (int i = 0; i < dots.length; i++) println(dots[i]);
    debugger = false; //<>//
  }
  
  for (int i = 0; i < dots.length; i++) {
    Dot dot = dots[i];
    PVector loc;
    if (dot.start.pool && dot.end.pool) {
      // in-pool moves should be radial
      loc = resolvePoolLoc(dot.end.layer, map(phase, 0, 1, dot.start.x, dot.end.x));
    } else {
      // out-of-pool moves should be linear
      PVector startLoc = resolveLoc(dot.start);
      PVector endLoc = resolveLoc(dot.end);
      loc = new PVector(map(phase, 0, 1, startLoc.x, endLoc.x),
          map(phase, 0, 1, startLoc.y, endLoc.y),
          map(phase, 0, 1, startLoc.z, endLoc.z));
    }
    pushMatrix();
    translate(loc.x, loc.y, loc.z);
    sphere(sphereRadius);
    popMatrix();
  }
}

void keyPressed() {
  if (key == 'd') {
    debugger = true;
  }
}
