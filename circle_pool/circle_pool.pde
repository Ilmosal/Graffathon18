import peasy.*;

import moonlander.library.*;

import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

final int layers = 9;
final int sphereRadius = 5;
final int padding = 10;
final float rotateSpeed = 16;

final float minOffset = 2 * sphereRadius + padding;

final Node[][] nodes = new Node[3][];
final Node[][] frame = new Node[3][];

float beat = 0.0, totalBeat = 0.0;
int BPM = 128;

Dot[] dots;

PeasyCam cam;

Moonlander moonlander;

final float startY = -40;

void setup() {
  size(1024, 576, P3D);
  //fullScreen(P3D);
  moonlander = Moonlander.initWithSoundtrack(this, "../../Exit the Premises.mp3", BPM, 8);
  
  colorMode(HSB, 360, 100, 100);
  
  createNodes();
  createScenes();
  
  //cam = new PeasyCam(this, 0, startY, 0, 400);
  //cam.setSuppressRollRotationMode();
  
  createDots();
  
  moonlander.start("localhost", 1339, "syncdata.rocket");
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

int sceneIndex = -1;
float sceneStart;
Scene scene;

void draw() {
  moonlander.update();
  noLights();
  ambientLight(0, 0, (float) moonlander.getValue("ambient"));
  directionalLight(0, 0, (float) moonlander.getValue("directional"), 1, 10, 2);
  background(0);
  
  totalBeat = (float) moonlander.getCurrentTime() * BPM / 60.0;
  beat = totalBeat % 1;
  
  updateCamera(totalBeat);
  
  // find current scene
  int targetScene = sceneIndex;
  while (targetScene < scenes.length - 1 && scenes[targetScene + 1].start <= totalBeat) {
    targetScene++;
  }
  while (targetScene > 0 && scenes[targetScene].start > totalBeat) {
    targetScene--;
  }
  if (targetScene != sceneIndex) {
    sceneIndex = targetScene;
    scene = scenes[sceneIndex];
    sceneStart = scene.start;
    scene.initScene();
  }
  
  println(sceneIndex, scene, totalBeat);
  
  float transitionLen = 1;
  float offset = min(1, (totalBeat - sceneStart) / transitionLen);
  float phase = (1 - cos(offset * PI)) / 2;
  
  scene.initFrame(totalBeat - sceneStart, phase);
  
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
    fill(dot.clr);
    pushMatrix();
    translate(loc.x, loc.y, loc.z);
    sphere(sphereRadius);
    popMatrix(); 
  }
  
  for (int i = 0; i < dots.length; i++) {
    if (dots[i].end.node == null) {
      continue;
    }
    
    for (Node n : dots[i].end.node.connections) {
      line(n.pos.x, n.pos.y, n.pos.z, dots[i].end.node.pos.x, dots[i].end.node.pos.y, dots[i].end.node.pos.z); 
    }
  }
  /*//debug cube
  stroke(255);
  noFill();
  pushMatrix();
  translate(0, -100, 0);
  box(20);
  popMatrix();*/
}
