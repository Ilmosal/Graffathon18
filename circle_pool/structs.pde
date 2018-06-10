class Node {
  PVector pos;
  Node from_node;
  Node to_node;
  Node next_node;
  boolean beat_frame_mem;

  ArrayList<Node> connections;

  Node(PVector vector) {
    pos = vector;
    to_node = null;
    from_node = null;
    next_node = null;
    beat_frame_mem = false;
    connections = new ArrayList();
  }
  
  void update(Float beatFrame) {
    if (this.to_node != null) {  
      if (beatFrame < 0.4 && beat_frame_mem) {
          this.pos = this.to_node.pos;
          this.from_node = this.to_node;
          this.to_node = this.to_node.next_node;
          beat_frame_mem = false;  
        } else if (beatFrame > 0.5) {
        beat_frame_mem = true;
      }
      
      PVector vec = this.to_node.pos.copy().sub(this.from_node.pos);  

      this.pos = this.from_node.pos.copy().add(vec.mult(sinusoidalEaseIn(beatFrame)));  
    } 
  }
  
  private float sinusoidalEaseIn(float val) {
    return sin(PI / 2 * val);
  }
  
  private float sinusoidalEaseIO(float val) {
    return cos(PI * val) / 2 + 0.5;
  }
}

abstract class Scene {
  int start;
  
  Scene(int start) {
    this.start = start;
  }
  
  abstract void initScene();
  
  abstract void initFrame(float beatsAfterStart, float phase);
}

class Location {
  // true if in pool, false otherwise
  boolean pool;
  // the position if out of pool
  Node node;
  // the layer in the pool
  int layer;
  // the slot in the pool layer
  int slot;
  // the fractional slot in the layer
  float fracSlot;
 
  Location (Node node) {
    this.node = node;
  }
  
  Location copy() {
    Location clone = new Location(null);
    clone.node = this.node;
    clone.pool = pool;
    clone.layer = layer;
    clone.slot = slot;
    clone.fracSlot = fracSlot;
    return clone;
  }
  
  public String toString() {
    return pool ? "L" + layer + " S" + slot + " F" + fracSlot : "" + node.pos;
  }
}

class Dot {
  Location start = new Location(null);
  Location end = new Location(null);
  color clr = color(255);
  PVector cache_loc;
  
  public String toString() {
    return start + " -> " + end;
  }
  
    
}
