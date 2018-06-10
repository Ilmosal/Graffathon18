Scene[] scenes;

void createScenes() {
  scenes = new Scene[] {
    new IntroScene(-100),
    new NodeScene(16, nodes[1]),
    new TextScene(32, "purkka", -70, -100, 0, 0, 0, 40),
    new TextScene(48, "demonimi", 0, -100, -70, PI / 6, PI / 2, 40)
  };
}

class IntroScene extends Scene {
  IntroScene(int start) {
    super(start);
  }
  
  void initScene() {
    setShape(new Node[] {});
    for (int i = 0; i < dots.length; i++) {
      dots[i].clr = color(255); 
    }
  }
  
  void initFrame(float beatsAfterStart, float phase) {
    noStroke();
  }
}

class NodeScene extends Scene {
  Node[] nodes;
  
  NodeScene(int start, Node[] nodes) {
    super(start);
    this.nodes = nodes;
  }
  
  void initScene() {
    setShape(nodes);  
  }
  
  void initFrame(float beatsAfterStart, float phase) {
    noStroke();
    float blink = (float) moonlander.getValue("blink");
    for (int i = 0; i < dots.length; i++) {
      Dot dot = dots[i];
      float startBright = dot.start.pool ? blink : 255;
      float endBright = dot.end.pool ? blink : 255;
      dot.clr = color(startBright * (1 - phase) + endBright * phase);
    }
  }
}

Node[] buildText(String text, float x, float y, float z, float pitch, float yaw, float scale) {
  float[][] basePos = getDotString(text);
  float minX = basePos[0][0], maxX = basePos[0][0], minY = basePos[1][0], maxY = basePos[1][0];
  for (int i = 0; i < basePos[0].length; i++) {
    minX = min(minX, basePos[0][i]);
    maxX = max(maxX, basePos[0][i]);
    minY = min(minY, basePos[1][i]);
    maxY = max(maxY, basePos[1][i]);
  }
  float midX = (minX + maxX) / 2;
  float midY = (minY + maxY) / 2;
  Node[] out = new Node[basePos[0].length];
  for (int i = 0; i < basePos[0].length; i++) {
    // scale text
    float dx = (basePos[0][i] - midX) * scale;
    float dy = (basePos[1][i] - midY) * scale;
    // rotate pitch
    float px = dx;
    float py = cos(pitch) * dy;
    float pz = sin(pitch) * dy;
    // rotate yaw
    float yx = cos(yaw) * px + sin(yaw) * pz;
    float yy = py;
    float yz = cos(yaw) * pz - sin(yaw) * px;
    out[i] = new Node(new PVector(x + yx, y + yy, z + yz));
  }
  return out;
}

class TextScene extends NodeScene {
  
  String text;
  float x, y, z, pitch, yaw, scale;
  
  TextScene(int start, String text, float x, float y, float z, float pitch, float yaw, float scale) {
    super(start, buildText(text, x, y, z, pitch, yaw, scale));
  }
}
