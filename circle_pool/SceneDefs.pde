Scene[] scenes;

void createScenes() {
  scenes = new Scene[] {
    new IntroScene(-100),
    new TextScene(16, "graffathon18", 0, -100, 0, 0, 0, 30, 9),
    new TextScene(32, "team epatoivo", 0, -100, 0, PI / 12, PI * 0.6, 30, 0),
    new TextScene(48, "outoftime", 0, -100, 0, PI / 6, PI / 2, 40, 1),
    new NodeScene(64, nodes[0]),
    new NodeScene(80, nodes[1]),
    new NodeScene(96, nodes[2]),
    new NodeScene(112, nodes[3]),
    new NodeScene(128, nodes[4]),
    new NodeScene(144, nodes[5]),
    new NodeScene(160, nodes[6]),
    new TextScene(240, "purkka", 0, -100, 0, PI / 6, PI / 8, 40, 3),
    new TextScene(248, "qazhax", 0, -100, 0, PI / 6, 0, 40, 5),
    new TextScene(256, "cubanfrog", 0, -100, 0, PI / 6, -PI / 12, 40, 8),
    new TextScene(264, "joel", 0, -100, 0, PI / 6, PI / 8, 40, 6),
    new TextScene(272, "greetz to", 0, -100, 0, 0, 0, 40, 7),
    new TextScene(280, "we know nobody", -70, -100, 0, PI / 6, PI / 8, 40, 0),
    new TextScene(288, "thx for watching", 0, -100, 0, PI / 6, 0, 40, 2),
    new IntroScene(304)
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
      color startClr = dot.start.pool ? color(blink) : dot.start.node.clr;
      color endClr = dot.end.pool ? color(blink) : dot.end.node.clr;
      dot.clr = color(hue(startClr) * (1 - phase) + hue(endClr) * phase,
          saturation(startClr) * (1 - phase) + saturation(endClr) * phase,
          brightness(startClr) * (1 - phase) + brightness(endClr) * phase);
    }
  }
}

Node[] buildText(String text, float x, float y, float z, float pitch, float yaw, float scale, int clrMode) {
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
    if (clrMode == 1) {
      out[i].clr = color(360.0 * basePos[2][i] / text.length(), 100, 100);
    } else if (clrMode == 2) {
      out[i].clr = color(156, 63, 89);
    } else if (clrMode == 3) {
      out[i].clr = color(156, 63, 89);
    } else if (clrMode == 4) {
      out[i].clr = color(49, 90, 100);
    } else if (clrMode == 5) {
      out[i].clr = color(173, 74, 100);
    } else if (clrMode == 6) {
      out[i].clr = color(325, 67, 100);
    } else if (clrMode == 7) {
      out[i].clr = color(352, 86, 94);
    } else if (clrMode == 8) {
      out[i].clr = color(39, 88, 91);
    } else if (clrMode == 9) {
      out[i].clr = color(120, 74, 90.6);
    }
  }
  return out;
}

class TextScene extends NodeScene {
  
  String text;
  float x, y, z, pitch, yaw, scale;
  
  TextScene(int start, String text, float x, float y, float z, float pitch, float yaw, float scale, int clrMode) {
    super(start, buildText(text, x, y, z, pitch, yaw, scale, clrMode));
  }
}
