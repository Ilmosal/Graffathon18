
Dot[][] slotsUsed = new Dot[layers][];
int[] maxCounts = new int[layers];

void createDots() {
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
