import peasy.*;

import moonlander.library.*;

import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

PeasyCam cam;

final boolean DEBUG = true;

void setup() {
  fullScreen(P3D);
  colorMode(HSB, 360, 100, 100);
  if (DEBUG) {
    cam = new PeasyCam(this, 100);
    cam.setSuppressRollRotationMode();
  }
}

float rotateOffset = 0;

int layers = 5;
int sphereRadius = 20;
int padding = 5;
float rotateSpeed = 0.05;

long lastFrame = 0;

void draw() {
  background(255);

  float minOffset = 2 * sphereRadius + padding;

  noLights();
  ambientLight(0, 0, 50);
  directionalLight(0, 0, 50, 1, 10, 2);
  
  noStroke();

  for (int layer = 0; layer < layers; layer++) {
    fill(layer * 30, 100, 100);

    float layerRadius = minOffset * layer;

    pushMatrix();
    if (layer != 0) {
      rotateY(pow(-1, layer) * rotateSpeed / layerRadius * millis());
    }

    int sphereCount = 1;
    while (minOffset / 2 / sin(TAU / 2 / sphereCount) <= layerRadius) {
      sphereCount++;
    }
    sphereCount--;

    for (int i = 0; i < sphereCount; i++) {
      pushMatrix();
      rotateY(TAU / sphereCount * i);
      translate(layerRadius, 0, 0);
      sphere(sphereRadius);
      popMatrix();
    }
    popMatrix();
  }
  
  noLights();
  fill(0, 0, 0);
  cam.beginHUD();
  text("layers: " + layers, 0, 20, 0);
  text("sphere size: " + sphereRadius, 0, 40, 0);
  text("padding: " + padding, 0, 60, 0);
  text("speed: " + rotateSpeed, 0, 80, 0);
  text("press R/F/T/G/Y/H/U/J to adjust", 0, 100, 0);
  long nowFrame = millis();
  float fps = 1000.0 / (nowFrame - lastFrame);
  lastFrame = nowFrame;
  text((int)fps + "fps", 0, 150, 0);
  cam.endHUD();
}

void keyPressed() {
  if (key == 'r') layers++;
  if (key == 'f') layers--;
  if (key == 't') sphereRadius++;
  if (key == 'g') sphereRadius--;
  if (key == 'y') padding++;
  if (key == 'h') padding--;
  if (key == 'u') rotateSpeed += 0.005;
  if (key == 'j') rotateSpeed -= 0.005;
}
