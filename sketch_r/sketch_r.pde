import moonlander.library.*;

import ddf.minim.*;

Moonlander moonlander;

float angle = PI/2+1;
PShader shady;

Dot[] pool; //all are here constantly
Dot[][] all_pools_start; //replaced with the end version of the array
Dot[][] all_pools_end; //swapped around here
int[] dots_in_pools_start;
int[] dots_in_pools_end;
int dots = 200;
int pools = 10;
//int dots_in_pool = dots;
int hax = -1;
float[] shape_xs = {0,0,1,1, 0,0,1,1};
float[] shape_ys = {2,1,1,2, 4,3,3,4};
float[] shape2_xs = {0,0.2,0.4,0.6, 0.8,1,0.8,0.6};
float[] shape2_ys = {1,1.5,2,2.5, 3,3.5,4,4.5};

int dot_creation_counter = 0;


class Node {
  int[] pos;
  Node target;
  Node old_pos;
  float pos_on_route;
  ArrayList<Node> connections;
  boolean visible;
  
  Node(int x_pos, int y_pos, int z_pos, boolean visible) {
    pos = new int[3];
    pos[0] = x_pos; pos[1] = y_pos; pos[2] = z_pos;
    this.visible = visible;
    target = null;
    old_pos = null;
    pos_on_route = 1.0;
    connections = new ArrayList();
  }
  
  void giveTarget(Node target) {
    this.target = target;
    this.pos_on_route = 0.0;
  }
  
  void update() {
    if (this.target != null) {
      int[] vec = new int[3];
      vec[0] = this.target.pos[0] - this.old_pos.pos[0];
      vec[1] = this.target.pos[1] - this.old_pos.pos[1];
      vec[2] = this.target.pos[2] - this.old_pos.pos[2];
      
      print(vec[0]);
      print(vec[1]);
      print(vec[2]);
      print("\n");

      float len = sqrt(vec[0]*vec[0] + vec[1]*vec[1] + vec[2]*vec[2]);

      this.pos_on_route += 0.01;

      this.pos[0] = (int) (vec[0] * pos_on_route) + this.old_pos.pos[0];
      this.pos[1] = (int) (vec[1] * pos_on_route) + this.old_pos.pos[1];
      this.pos[2] = (int) (vec[2] * pos_on_route) + this.old_pos.pos[2];
   
      if (this.pos_on_route >= 1.0) {
        this.pos[0] = this.target.pos[0];
        this.pos[1] = this.target.pos[1];
        this.pos[2] = this.target.pos[2];
        this.old_pos = this.target;
        this.target = this.target.connections.get(0);
        this.pos_on_route = 0.0;
      } 
    }
  }
  
  void drawNode() {   
    if (this.visible) {
      pushMatrix();
      translate(this.pos[0], this.pos[1], this.pos[2]);
      sphere(5);
      popMatrix();
    
    
      for (Node n : this.connections) {
        line(this.pos[0], this.pos[1], this.pos[2], n.pos[0], n.pos[1], n.pos[2]);
      }
    }
  }
}

class Dot {
  int start_pool;
  int end_pool;
  int start_pool_i; //index_in_start_pool
  int end_pool_i; //index_in_end_pool
  
  Dot() {
    start_pool = 0;
    end_pool = 0;
    start_pool_i = dot_creation_counter;
    end_pool_i = dot_creation_counter;
    dot_creation_counter++;
  }
}

void setup() {
  moonlander = Moonlander.initWithSoundtrack(this, "graffathonsong.mp3", 105, 8);

  size(400, 400, P3D);
  noStroke();
  randomSeed(1337);
  noiseSeed(1337);
  colorMode(RGB, 255);
  dots_in_pools_end = new int[pools];
  dots_in_pools_end[0] = dots;
  pool = new Dot[dots];
  all_pools_end = new Dot[pools][dots]; //n*k array, hardcoding could be better but egh e_E;;
  for (int i=0;i<dots;i++){
    Dot the_new_one = new Dot();
    pool[i] = the_new_one;
    all_pools_end[0][i] = the_new_one;
  }
  resetPools();//sets the start versions of the arrays and everything
  
  shady = loadShader("ToonFrag.glsl", "ToonVert.glsl");
  shady.set("fraction", 1.0);
  moonlander.start();
  for (int i = 0; i < 26; i++) {
    print("[");
    for (int j = 0; j < letters[i][0].length; j++) {
      print("["+letters[i][0][j]+","+letters[i][1][j]+"]");
      if(j!=letters[i][0].length-1)print(",");
    }
    print("]");
  }
}

void draw() {
  moonlander.update();
  shader(shady);
  hax ++;
  if(hax%300==0){
    int[] distr = {dots-8,8,0,0, 0,0,0,0, 0,0};
    setRandomShape(distr);
  }
  if(hax%300==50){
    resetPools();
  }
  if(hax%300==100){
    moveToPool(1, 2, 4);
    moveToPool(1, 0, 4);
  }
  if(hax%300==150){
    resetPools();
  }
  if(hax%300==200){
    setShape(2, xs.length);
  }
  if(hax%300==250){
    resetPools();
  }
  background(50);
  camera(width/2, height/2, 300, width/2, height/2, 0, 0, 1, 0);
  
  translate(300,0,-1500);
  
  pointLight(200, 200, 200, width/2-500, height/2+20, 200);
  pointLight(200, 200, 200, width/2, height/2+10, -100);
  
  translate(width/2, height/2 + 100);
  rotateY(angle + 1);
  
  color color1 = color(109, 50, 97);
  color color2 = color(255, 213, 25);
  
  float shape_coeff = sinEase((hax%50)/50.0);//sinEase(abs((hax%100-50)/50.0));
  float noise_coeff = saltShaker(1-shape_coeff);
  color interp = interpolateColourWithGamma(shape_coeff, color1, color2);
  //fill();
  fill(interp);
  for (int i=0;i<dots;i++){
    pushMatrix();
    Dot doti = pool[i];
    //float coeff = 0.9;
    //doti.curr_x = doti.curr_x * coeff + doti.want_x * (1-coeff);
    //doti.curr_y = doti.curr_y * coeff + doti.want_y * (1-coeff);
    float[] c = get_weighted_position(1-shape_coeff, true, doti);
    float[] c2 = get_weighted_position(shape_coeff, false, doti);
    float x = c[0] + c2[0];
    float y = c[1] + c2[1];
    float z = c[2] + c2[2];
    translate(1000 * x + noise_coeff*random(10), -100 * y + noise_coeff*random(10), -400 * z + noise_coeff*random(10));
    sphere(20);
    popMatrix();
  }
}

// returns array of x, y and z
float[] get_weighted_position(float shape_coeff, boolean start, Dot doti){
  int i;
  int dots;
  int pool;
  if(start){
    i = doti.start_pool_i;
    pool = doti.start_pool;
    dots = dots_in_pools_start[pool];
  }
  else {
    i = doti.end_pool_i;
    pool = doti.end_pool;
    dots = dots_in_pools_end[pool];
  }
  
  float x;
  float y;
  float z;
  if(pool == 0){
    x = shape_coeff * i/dots;
    y = 0 * shape_coeff * i/dots;
    z = 0 * shape_coeff * i/dots;
  }
  
  else if (pool == 1) {
    x = shape_coeff * shape_xs[i];
    y = shape_coeff * shape_ys[i];
    z = shape_coeff * 1;
  }
  else {
    x = shape_coeff * (-xs[i]*0.2 + 1);
    y = shape_coeff * -ys[i]*3;
    z = shape_coeff * 0.5;
  }
  float[] retval = {x, y, z};
  return retval;
}


float saltShaker(float in) {
  return (in) * (0.5 + 0.5*noise(hax));
}
float sinEase(float in){
  return sin(in*PI/2);
}

void resetPools(){
  //set previous end position to current start
  for (int i=0;i<dots;i++){
    pool[i].start_pool = pool[i].end_pool;
    pool[i].start_pool_i = pool[i].end_pool_i;
    dots_in_pools_start = dots_in_pools_end;
    all_pools_start = all_pools_end;
  }
}

// takes array of numbers each pool gets
// randomizes every dot into random pool so that in the end they are distributed correctly
// too random D:
void setRandomShape(int[] pool_distribution) {
  resetPools();
  //shuffle indices
  int[] indices = new int[dots];
  for (int i = 0; i<dots; i++){
    indices[i] = i;
  }
  shuffle(indices);
  
  //shuffle dots into pools
  int actual_index = 0;
  all_pools_end = new Dot[pools][dots]; //reset the array
  for (int i = 0; i<pool_distribution.length;i++){
    int n = pool_distribution[i];
    for (int j =0; j<n; j++){
      Dot selected = pool[indices[actual_index]];
      selected.end_pool = i;
      selected.end_pool_i = j;
      all_pools_end[i][j] = selected;
      actual_index ++;
    }
  }
  dots_in_pools_end = pool_distribution;
}


// moves dots in all pools except pool 0 to the defined pool
// if there are too many dots, the rest go back into the pool 0
// if there are too few dots, pool 0 is used to pick the remaining dots
void setShape(int destination_pool, int n) {
  resetPools();
  //shuffle indices
  int[] indices = new int[n];
  for (int i = 0; i<n; i++){
    indices[i] = i;
  }
  shuffle(indices);
  
  //shuffle dots into pools
  all_pools_end = new Dot[pools][dots]; //reset the array
  all_pools_end[0] = all_pools_start[0];
  
  int current_index = dots_in_pools_end[0];
  for (int i = 0; i<dots;i++){
    Dot selected = pool[i];
    if(selected.end_pool != 0){
      selected.end_pool = 0;
      selected.end_pool_i = current_index;
      all_pools_end[0][current_index] = selected;
      current_index ++;
    }
  }
  int actual_index = 0;
  for (int i = 1; i<pools;i++){
    for (int j =0; j<min(dots_in_pools_start[i], n); j++){
      Dot selected = all_pools_start[i][j];
      selected.end_pool = destination_pool;
      selected.end_pool_i = indices[actual_index];
      all_pools_end[destination_pool][selected.end_pool_i] = selected;
      actual_index ++;
    }
  }
  int root_count = dots_in_pools_start[0];
  if(actual_index < n){
    int[] root_indices = new int[root_count];
    for (int i = 0; i<root_count; i++){
      root_indices[i] = i;
    }
    shuffle(root_indices);
    
    for (int j=0; actual_index<n; actual_index++){
      Dot selected = all_pools_start[0][root_indices[j]];
      selected.end_pool = destination_pool;
      selected.end_pool_i = indices[actual_index];
      all_pools_end[destination_pool][selected.end_pool_i] = selected;
      j ++;
    }
  }
  dots_in_pools_end = new int[pools];
  dots_in_pools_end[0] = dots - n;
  dots_in_pools_end[destination_pool] = n;
  actual_index = 0;
  for (int i=0;i<current_index;i++){
    Dot moving = all_pools_end[0][i];
    if(moving.end_pool == 0){
      moving.end_pool_i = actual_index;
      all_pools_end[0][actual_index] = moving;
      actual_index ++;
    }
  }
}

//assumes that the resetPools has been called before
//assumes there is enough dots in origin and that destination can get the dots without crashing
//moves n dots from origin pool to end of the destination pool and resets origin indices
void moveToPool(int origin_pool, int destination_pool, int n) {
  int index = dots_in_pools_end[destination_pool];
  int moved = 0;
  while (moved<n){
    Dot selected = all_pools_end[origin_pool][(int)random(dots_in_pools_end[origin_pool])]; 
    if(selected.end_pool == origin_pool){
      selected.end_pool = destination_pool;
      selected.end_pool_i = index;
      all_pools_end[destination_pool][index] = selected;
      moved ++;
      index ++;
    }
  }
  
  int actual_i = 0;
  for (int i = 0; i<dots_in_pools_end[origin_pool]; i++){
    Dot selected = all_pools_end[origin_pool][i];
    if(selected.end_pool == origin_pool){
      all_pools_end[origin_pool][actual_i] = selected; // actual_i moves at the same or slower speed so changing the array as we go should not be a problem?
      actual_i ++;
    }
  }
  dots_in_pools_end[origin_pool] -= n;
  dots_in_pools_end[destination_pool] += n;
}


void shuffle(int[] arr){
   int temp;
   for(int i=0;i<arr.length;i++){
       int pick  = (int)random(arr.length); 
       temp = arr[i]; 
       arr[i] = arr[pick]; 
       arr[pick]= temp; 
    }
}

//returns the interpolated colour?
color interpolateColour(float coeff, color from, color to){
  int r1 = (from >> 16) & 0xFF;  // Faster way of getting red(argb)
  int g1 = (from >> 8) & 0xFF;   // Faster way of getting green(argb)
  int b1 = from & 0xFF;          // Faster way of getting blue(argb)
  int r2 = (to >> 16) & 0xFF;  // Faster way of getting red(argb)
  int g2 = (to >> 8) & 0xFF;   // Faster way of getting green(argb)
  int b2 = to & 0xFF;          // Faster way of getting blue(argb)
  int a = 0xFF << 24;
  int r = min(255,(int)round(r1*(1-coeff) + r2*(coeff))) << 16;
  int g = min(255,(int)round(g1*(1-coeff) + g2*(coeff))) << 8;
  int b = min(255,(int)round(b1*(1-coeff) + b2*(coeff)));
  return a+r+b+g;
}


//returns the interpolated colour?
color interpolateColourWithGamma(float coeff, color from, color to){
  int r1 = (from >> 16) & 0xFF;  // Faster way of getting red(argb)
  int g1 = (from >> 8) & 0xFF;   // Faster way of getting green(argb)
  int b1 = from & 0xFF;          // Faster way of getting blue(argb)
  int r2 = (to >> 16) & 0xFF;  // Faster way of getting red(argb)
  int g2 = (to >> 8) & 0xFF;   // Faster way of getting green(argb)
  int b2 = to & 0xFF;          // Faster way of getting blue(argb)
  float gamma = 2;
  int a = 0xFF << 24;
  int r = min(255, interpolateWithGamma(coeff, r1, r2, gamma)) << 16;
  int g = min(255, interpolateWithGamma(coeff, g1, g2, gamma)) << 8;
  int b = min(255, interpolateWithGamma(coeff, b1, b2, gamma));
  return a+r+g+b;
}


//returns interpolated value
int interpolateWithGamma(float coeff, float val1, float val2, float gamma){
  int retval = (int)round(pow(pow(val1, gamma)*(coeff) + pow(val2, gamma)*(1-coeff), 1.0/gamma));
  return retval;
}
