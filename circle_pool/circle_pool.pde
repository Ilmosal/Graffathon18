import peasy.*;

import moonlander.library.*;

import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

final int layers = 7;
final int sphereRadius = 5;
final int padding = 10;
final float rotateSpeed = 5;

final float minOffset = 2 * sphereRadius + padding;

final Node[][] nodes = new Node[3][];
final Node[][] frame = new Node[3][];

float beat = 0.0;
int BPM = 105;

Dot[] dots;
Dot[][] slotsUsed = new Dot[layers][];
int[] maxCounts = new int[layers];

PeasyCam cam;

Moonlander moonlander;

final float startY = -40;

void setup() {
  size(800, 600, P3D);
  moonlander = Moonlander.initWithSoundtrack(this, "graffathonsong.mp3", BPM, 32);
  //fullScreen(P3D);
  
  // init fancy cubes for the shapes
  /*
  for (int i = 0; i < shapes.length; i++) {
    PVector coords[] = new PVector[8 + 12 * i];
    float off = 3 * sphereRadius;
    float rad = (i + 1) * off / 2;
    int p = 0;
    coords[p++] = new PVector(-rad, startY - 2 * rad, -rad);
    coords[p++] = new PVector(-rad, startY - 2 * rad, rad);
    coords[p++] = new PVector(-rad, startY, -rad);
    coords[p++] = new PVector(-rad, startY, rad);
    coords[p++] = new PVector(rad, startY - 2 * rad, -rad);
    coords[p++] = new PVector(rad, startY - 2 * rad, rad);
    coords[p++] = new PVector(rad, startY, -rad);
    coords[p++] = new PVector(rad, startY, rad);
    for (int j = 1; j <= i; j++) {
      coords[p++] = new PVector(-rad + j * off, startY - 2 * rad, -rad);
      coords[p++] = new PVector(-rad + j * off, startY - 2 * rad, rad);
      coords[p++] = new PVector(-rad + j * off, startY, -rad);
      coords[p++] = new PVector(-rad + j * off, startY, rad);
      coords[p++] = new PVector(-rad, startY - 2 * rad + j * off, -rad);
      coords[p++] = new PVector(-rad, startY - 2 * rad + j * off, rad);
      coords[p++] = new PVector(rad, startY - 2 * rad + j * off, -rad);
      coords[p++] = new PVector(rad, startY - 2 * rad + j * off, rad);
      coords[p++] = new PVector(-rad, startY - 2 * rad, -rad + j * off);
      coords[p++] = new PVector(-rad, startY, -rad + j * off);
      coords[p++] = new PVector(rad, startY - 2 * rad, -rad + j * off);
      coords[p++] = new PVector(rad, startY, -rad + j * off);
    }
    shapes[i] = coords;
  }
  */
  createNodes();
  
  colorMode(HSB, 360, 100, 100);
  cam = new PeasyCam(this, 0, startY, 0, 400);
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
  println("total dots: " + totalCount);
  // init the dots in the pool
  dots = new Dot[totalCount];
  
  for (int layer = 0, i = 0; layer < layers; layer++) {
    slotsUsed[layer] = new Dot[maxCounts[layer]];
    for (int j = 0; j < maxCounts[layer]; j++) {
      Dot dot = dots[i++] = new Dot();
      dot.start.pool = true;
      dot.start.layer = layer;
      dot.start.fracSlot = dot.start.slot = j;
      dot.end = dot.start;
      slotsUsed[layer][j] = dot;
    }
  }
  
  moonlander.start("localhost", 1339, "synkkifilu");
  setShape(nodes[1]);
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

void setShape(Node[] shape) {
  int[] counts = new int[layers];
  int usedCount = 0;
  // move the end locations to be starts and count dots starting on each layer
  for (int i = 0; i < dots.length; i++){
    Dot dot = dots[i];
    dot.start = dot.end.copy();
    dot.end.pool = true;
    if (dot.start.pool) {
      counts[dot.end.layer]++;
    } else {
      usedCount++;
    }
  }
  // spread the dots starting in the pool evenly in slots
  Dot[][] newSlots = new Dot[layers][];
  for (int i = 0; i < layers; i++) {
    newSlots[i] = new Dot[maxCounts[i]];
    int seen = 0;
    for (int j = 0; j < maxCounts[i]; j++) {
      Dot dot = slotsUsed[i][j];
      if (dot != null && dot.start.pool) {
        dot.end.slot = seen * maxCounts[dot.end.layer] / counts[dot.end.layer];
        seen++;
        newSlots[dot.end.layer][dot.end.slot] = dot;
      }
    }
  }
  slotsUsed = newSlots;
  // choose dots to the shape
  int shaped = 0;
  while (shaped < shape.length) {
    Dot dot;
    if (usedCount > 0) {
      // find a dot already in the previous shape
      do {
        dot = dots[(int) random(dots.length)];
      } while (!dot.end.pool || dot.start.pool);
      usedCount--;
    } else {
      // find a maximally full layer to take from
      float maxFrac = optimalFrac(false, counts);
      int layer;
      do {
        layer = (int) random(layers);
      } while ((float) counts[layer] / maxCounts[layer] < maxFrac);
      // find a dot on that layer
      do {
        dot = slotsUsed[layer][(int) random(maxCounts[layer])];
      } while (dot == null || !dot.end.pool);
    }
    // use the dot
    dot.end.pool = false;
    dot.end.node = shape[shaped];
    // update counts
    if (dot.start.pool) {
      counts[dot.end.layer]--;
      slotsUsed[dot.end.layer][dot.end.slot] = null;
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
      do {
        slot = (int) random(maxCounts[layer]);
      } while (slotsUsed[layer][slot] != null);
      // use the slot
      dot.end.layer = layer;
      dot.end.slot = slot;
      counts[layer]++;
      slotsUsed[layer][slot] = dot;
    }
  }
  // spread the dots in each layer evenly
  for (int i = 0; i < layers; i++) {
    float seen = 0;
    for (int j = 0; j < maxCounts[i]; j++) {
      Dot dot = slotsUsed[i][j];
      if (dot != null && dot.end.pool) {
        dot.end.fracSlot = seen * maxCounts[dot.end.layer] / counts[dot.end.layer];
        seen++;
      }
    }
  }
}

PVector resolvePoolLoc(int layer, float x) {
  float radius = layer * minOffset;
  float speed = layer == 0 ? 0 : pow(-1, layer) * rotateSpeed / radius;
  float angle = TAU * x / maxCounts[layer] + speed * (float) moonlander.getCurrentTime();
  return new PVector(sin(angle) * radius, 0, cos(angle) * radius);
}

PVector resolveLoc(Location loc) {
  if (!loc.pool) {
    loc.node.update(beat);
  }

  return loc.pool ? resolvePoolLoc(loc.layer, loc.fracSlot) : loc.node.pos;
}

int shapeNo = 0;

boolean debugger = false;

final int period = 3;

int scene = 1;
int bar = 0;
float old_beat = 0.0;

void draw() {
  moonlander.update();
  background(0);
  noLights();
  //ambientLight(0, 0, 50);
  directionalLight(0, 0, 100, 1, 10, 2);
  fill(128);
  noStroke();
  float cur_time = (float) moonlander.getCurrentTime();
  
  beat = (((cur_time*BPM)/60.0) % 4)/4;
  
  if (old_beat > beat) {
    bar++;
  } 
  old_beat = beat;
  
  /*
  if (millis() / period > shapeNo) {
    shapeNo++;
    setShape(nodes);
  }
  */
  
  if (bar == 9 && scene == 1) {
    scene++;
    setShape(nodes[scene]);    
  }
  
  /*
  if (moonlander.getCurrentTime() > 10.0 && scene == 0) {
    scene++;
    setShape(nodes[1]);
  }*/
  
  float phase = scene == 0 ? 1 : (1 - cos(min(1, (cur_time - 10)) * PI)) / 2;
  
  if (debugger) {
    for (int i = 0; i < dots.length; i++) println(dots[i]);
    debugger = false; //<>//
  }
  
  for (int i = 0; i < dots.length; i++) {
    Dot dot = dots[i];  
    PVector loc;
    if (dot.start.pool && dot.end.pool) {
      // in-pool moves should be radial
      loc = resolvePoolLoc(dot.end.layer, map(phase, 0, 1, dot.start.fracSlot, dot.end.fracSlot));
    } else {
      // out-of-pool moves should be linear
      PVector startLoc = resolveLoc(dot.start);
      PVector endLoc = resolveLoc(dot.end);

      loc = new PVector(map(phase, 0, 1, startLoc.x, endLoc.x),
          map(phase, 0, 1, startLoc.y, endLoc.y),
          map(phase, 0, 1, startLoc.z, endLoc.z));
    }
    dot.cache_loc = loc;
    pushMatrix();
    translate(loc.x, loc.y, loc.z);
    fill(255);
    sphere(sphereRadius);
    popMatrix(); 
  }
  
  for (int i = 0; i < dots.length; i++) {
    if (dots[i].end.node == null) {
      continue;
    }
    
    for (Node n : dots[i].end.node.connections) {  
      fill(255);
      line(n.pos.x, n.pos.y, n.pos.z, dots[i].end.node.pos.x, dots[i].end.node.pos.y, dots[i].end.node.pos.z); 
    }
  }  
}


void keyPressed() {
  if (key == 'd') {
    debugger = true;
  }
}
