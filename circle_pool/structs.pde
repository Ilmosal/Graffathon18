class Location {
  // the position, x is also fractional slot
  float x, y, z;
  // the layer in the pool
  int layer;
  // the slot in the pool layer
  int slot;
  // true if in pool, false otherwise
  boolean pool;
  
  Location copy() {
    Location clone = new Location();
    clone.x = x;
    clone.y = y;
    clone.z = z;
    clone.layer = layer;
    clone.slot = slot;
    clone.pool = pool;
    return clone;
  }
  
  public String toString() {
    return pool ? "L" + layer + " S" + slot + " F" + x : x + " " + y + " " + z;
  }
}

class Dot {
  Location start = new Location();
  Location end = new Location();
  
  public String toString() {
    return start + " -> " + end;
  }
}

class Shape {
  float[] x;
  float[] y;
  float[] z;
  int length;
  
  public Shape(float[] x, float[] y, float[] z) {
    this.x = x;
    this.y = y;
    this.z = z;
    this.length = x.length;
  }
}

class DotComparator implements java.util.Comparator<Dot> {
  public int compare(Dot a, Dot b) {
    if (a.end.pool != b.end.pool) {
      return Boolean.compare(a.end.pool, b.end.pool);
    } else if (a.end.layer != b.end.layer) {
      return Integer.compare(a.end.layer, b.end.layer);
    } else {
      return Integer.compare(a.end.slot, b.end.slot);
    }
  }
}

final Shape emptyShape = new Shape(new float[0], new float[0], new float[0]);
