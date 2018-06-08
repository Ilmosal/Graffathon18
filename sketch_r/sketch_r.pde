float angle;

Dot[] pool; //all are here constantly
Dot[] shape; //added when necessary
int dots = 40;
int dots_in_pool = dots;
int hax = 0;
float[] shape_xs = {0,0,1,1};
float[] shape_ys = {2,1,1,2};

class Dot {
  float curr_x;
  float curr_y;
  float want_x;
  float want_y;
  boolean in_pool;
  
  Dot() {
    curr_x = 0;
    curr_y = 0;
    want_x = random(100);
    want_y = random(100);
    in_pool = true;
  }
}

void setShape(int n) {
  for (int i=0;i<dots;i++){
    pool[i].in_pool = true;
  }
  int shaped = 0;
  while(shaped<n){
    Dot derp = pool[(int)random(dots)];
    if(derp.in_pool) {
      derp.in_pool = false;
      shaped += 1;
    }
  }
  dots_in_pool = dots - n;
}


void setup() {
  size(400, 400, P3D);
  noStroke();
  randomSeed(1337);
  pool = new Dot[dots];
  for (int i=0;i<dots;i++){
    pool[i] = new Dot();
  }
}

void draw() {
  hax ++;
  if(hax%100==0){
    setShape(4);
  }
  background(0);
  camera(width/2, height/2, 300, width/2, height/2, 0, 0, 1, 0);
  
  pointLight(200, 200, 200, width/2, height/2+20, -200);
  pointLight(200, 200, 200, width/2, height/2+10, -100);
  
  translate(width/2, height/2 + 100);
  rotateY(angle + 1);
  
  //angle += 0.01;
  int shape_i = 0;
  int pool_i = 0;
  float shape_coeff = abs((hax%100-50)/50.0);
  for (int i=0;i<dots;i++){
    pushMatrix();
    Dot doti = pool[i];
    //float coeff = 0.9;
    //doti.curr_x = doti.curr_x * coeff + doti.want_x * (1-coeff);
    //doti.curr_y = doti.curr_y * coeff + doti.want_y * (1-coeff);
    float x = (1-shape_coeff) * i/dots;
    float y = 0 * (1-shape_coeff) * i/dots;
    if(doti.in_pool){
      x += shape_coeff * pool_i/dots_in_pool;
      y += 0 * shape_coeff * pool_i/dots_in_pool;
      pool_i ++;
    }
    else {
      x += shape_coeff * shape_xs[shape_i];
      y += shape_coeff * shape_ys[shape_i];
      shape_i ++;
    }
    translate(1000 * x, 100 * y);
    sphere(20);
    popMatrix();
  }
}
