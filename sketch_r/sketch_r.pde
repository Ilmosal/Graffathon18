import moonlander.library.*;

import ddf.minim.*;

Moonlander moonlander;

float angle;

Dot[] pool; //all are here constantly
Dot[][] all_pools_start; //replaced with the end version of the array
Dot[][] all_pools_end; //swapped around here
int[] dots_in_pools_start;
int[] dots_in_pools_end;
int dots = 40;
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
  moonlander.start();
}

void draw() {
  moonlander.update();
  hax ++;
  if(hax%200==0){
    int[] distr = {32,8,0,0, 0,0,0,0, 0,0};
    setRandomShape(distr);
  }
  if(hax%200==50){
    resetPools();
  }
  if(hax%200==100){
    moveToPool(1, 2, 8);
  }
  if(hax%200==150){
    resetPools();
  }
  background(50);
  camera(width/2, height/2, 300, width/2, height/2, 0, 0, 1, 0);
  
  pointLight(200, 200, 200, width/2, height/2+20, -200);
  pointLight(200, 200, 200, width/2, height/2+10, -100);
  
  translate(width/2, height/2 + 100);
  rotateY(angle + 1);
  
  float shape_coeff = sinEase((hax%50)/50.0);//sinEase(abs((hax%100-50)/50.0));
  float noise_coeff = saltShaker(1-shape_coeff);
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
    x = shape_coeff * shape2_xs[i];
    y = shape_coeff * shape2_ys[i];
    z = shape_coeff * 1;
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
