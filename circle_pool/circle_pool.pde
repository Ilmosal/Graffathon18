import peasy.*;
import java.util.Collections;
import moonlander.library.*;
import moonlander.library.MinimController;

import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

final int layers = 10;
final int sphereRadius = 5;
final int padding = 10;
final float rotateSpeed = 16;
final float waveHeight = 10;
final float waveLength = 6;

final float minOffset = 2 * sphereRadius + padding;

Node[][] nodes = new Node[8][];
Node[][] frames = new Node[8][];

float beat = 0.0, totalBeat = 0.0;
int BPM = 128;

Dot[] dots;

PeasyCam cam;

Moonlander moonlander;

// audio + colors
Minim minim;
MinimController mc;
AudioPlayer jingle;
FFT fft;
float smoothing = 0;
float[] fftReal;
float[] fftImag;
float[] fftSmooth;
float[] fftPrev;
float[] fftCurr;
int specSize;
int windex = 0;
int scale = 10;
int color_loc = 0;

final float startY = -40;

void setup() {
  size(1024, 576, P3D);
  //fullScreen(P3D); 
  
  colorMode(HSB, 360, 100, 100);
  
  nodes[0] = new Node[1];
  nodes[1] = new Node[2];
  nodes[2] = new Node[4];
  nodes[3] = new Node[8];
  nodes[4] = new Node[4];
  nodes[5] = new Node[8];
  nodes[6] = new Node[16];
  
  frames[0] = new Node[8];
  frames[1] = new Node[8];
  frames[2] = new Node[8];
  frames[3] = new Node[8];
  frames[4] = new Node[4];
  frames[5] = new Node[4];
  frames[6] = new Node[8];
  
  createNodes(nodes, frames);
  createScenes();
  
  //cam = new PeasyCam(this, 0, startY, 0, 400);
  //cam.setSuppressRollRotationMode();
  
  // SOUND SETUP CHUNK
  minim = new Minim(this);
  jingle = minim.loadFile("/home/joel/Downloads/Disco con Tutti.mp3");
  //jingle = minim.loadFile("/home/joel/Nextcloud/workspace/processing/Overworld.mp3");
  //jingle = minim.loadFile("../graffathonsong.mp3");
  mc = new MinimController(jingle, 128, 8);
  //moonlander = Moonlander.initWithSoundtrack(this, "../../Exit the Premises.mp3", BPM, 8);
  moonlander = new Moonlander(this, mc);
  moonlander.start("localhost", 1339, "syncdata.rocket");
  fft = new FFT(jingle.bufferSize(), jingle.sampleRate());
  specSize = fft.specSize();
  fftSmooth = new float[specSize];
  fftPrev   = new float[specSize];
  fftCurr   = new float[specSize]; 
  //jingle.play();
  
  createDots();
}

// DECIBEL LOG CHECK
float dB(float x) {
  if (x == 0) {
    return 0;
  }
  else {
    return 10 * (float)Math.log10(x);
  }
} 

PVector resolvePoolLoc(int layer, float x) {
  float radius = layer * minOffset;
  float speed = layer == 0 ? 0 : pow(-1, layer) * rotateSpeed / radius;
  float angle = TAU * x / maxCounts[layer] + speed * (float) moonlander.getCurrentTime();
  float waviness = (float) moonlander.getValue("waviness"); 
  float y = waviness * waveHeight * sin(totalBeat * PI + TAU / waveLength * layer);
  return new PVector(sin(angle) * radius, y, cos(angle) * radius);
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
  
  // SOUND
  fft.forward(jingle.mix);
  fftReal = fft.getSpectrumReal();
  fftImag = fft.getSpectrumImaginary();
  
  totalBeat = (float) moonlander.getCurrentTime() * BPM / 60.0;
  beat = totalBeat % 1;
  
  if (totalBeat >= 316) exit();
 
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
  
  float transitionLen = 2;
  float offset = min(1, (totalBeat - sceneStart) / transitionLen);
  float phase = (1 - cos(offset * PI)) / 2;
 
  scene.initFrame(totalBeat - sceneStart, phase);
  
  float shake = (float) moonlander.getValue("shake");
  
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
    
    loc.x += shake * noise(i, 0, totalBeat * 10);
    loc.y += shake * noise(i, 10, totalBeat * 10);
    loc.z += shake * noise(i, 20, totalBeat * 10);
    
    dot.cache_loc = loc;
    // COLORFUL STUFF
    int m = (int)map(i, 0, dots.length, 0, specSize);
    fftCurr[i] = scale * (float)Math.log10(fftReal[m]*fftReal[m] + fftImag[m]*fftImag[m]);  
    fftSmooth[i] = smoothing * fftSmooth[m] + ((1 - smoothing) * fftCurr[m]);
    float abs_smooth = abs(fftSmooth[i]);
    //print( abs_smooth + " ");
    //int specmap = (int)map(i, 0, dots.length, 1, 100 );
    int hue = (int)map(abs_smooth, 0, 80, 1, 1000);
    if (hue + color_loc > 1000 )
      hue = (hue + color_loc) - 1000;
    fill((hue + color_loc)%1000, 100, 100);
    //fill(dot.clr);
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
