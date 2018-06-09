class Location {
  // true if in pool, false otherwise
  boolean pool;
  // the position if out of pool
  PVector pos;
  // the layer in the pool
  int layer;
  // the slot in the pool layer
  int slot;
  // the fractional slot in the layer
  float fracSlot;
  
  Location copy() {
    Location clone = new Location();
    clone.pool = pool;
    clone.pos = pos;
    clone.layer = layer;
    clone.slot = slot;
    clone.fracSlot = fracSlot;
    return clone;
  }
  
  public String toString() {
    return pool ? "L" + layer + " S" + slot + " F" + fracSlot : "" + pos;
  }
}

class Dot {
  Location start = new Location();
  Location end = new Location();
  
  public String toString() {
    return start + " -> " + end;
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
