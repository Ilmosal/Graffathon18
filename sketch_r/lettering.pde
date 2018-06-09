
float[] x_top_down_left = lerpc(0,0,8);
float[] x_top_down_middle = lerpc(0.5,0.5,8);
float[] x_top_down_right = lerpc(1,1,8);
float[] y_top_down = lerpc(0,1,8);

float[] x_td_half_right = lerpc(1,1,6);
float[] x_td_half_left = lerpc(0,0,6);
float[] y_td_half = lerpc(0,0.66,6);

float[] x_e_line = lerpc(0,0.66,3);
float[] y_e_line = lerpc(0.66,0.66,3);

float[] x_dash_line = lerpc(0,1,4);
float[] y_dash_line = lerpc(0.66,0.66,4);
float[] y_top = lerpc(0,0,4);
float[] y_bottom = lerpc(1,1,4);

float[] xa_full_diagonal = lerpc(0,1,9); //for both
float[] ya_full_diagonal = lerpc(1,0,9); //for both

float[] lerpc(float start, float end, int points){
  float[] arr = new float[points];
  for(int i = 0;i<points;i++){
    float coeff = i/(points-1.0);
    arr[i] = lerp(start, end, coeff);//(1-coeff)*start + coeff*end;
  }
  return arr;
}


// A
float[] x_aa = concat(concat(xa_full_diagonal,x_top_down_right),x_dash_line); // /|-
float[] y_aa = concat(concat(ya_full_diagonal,y_top_down),y_dash_line); // /|-
//B
float[] x_bl = {0, 0.115152, 0.248485, 0.424242, 0.6, 0.745455, 0.860606, 0.945455, 0.957576, 0.860606, 0.733333, 0.587879, 0.430303, 0.272727, 0.127273, 0.0121212};
float[] y_bl = {0.997436, 1, 0.994872, 0.984615, 0.964103, 0.935897, 0.897436, 0.851282, 0.792308, 0.735897, 0.697436, 0.674359, 0.65641, 0.64359, 0.64359, 0.646154};
float[] x_bu = {0.0242424, 0.133333, 0.236364, 0.363636, 0.490909, 0.606061, 0.684848, 0.745455, 0.727273, 0.612121, 0.430303};
float[] y_bu = {0.0128205, 0.0512821, 0.0948718, 0.151282, 0.212821, 0.279487, 0.34359, 0.430769, 0.507692, 0.576923, 0.612821};
// actual B
float[] x_bls = {0, 0.248485, 0.6, 0.860606, 0.957576, 0.733333, 0.430303, 0.127273};
float[] y_bls = {1, 0.994872, 0.964103, 0.897436, 0.792308, 0.697436, 0.65641, 0.646154};
float[] x_bus = {0.0242424, 0.236364, 0.490909, 0.684848, 0.727273, 0.430303};
float[] y_bus = {0.0128205, 0.0948718, 0.212821, 0.34359, 0.507692, 0.612821};
float[] x_bb = concat(concat(x_bus, x_bls), x_top_down_left);
float[] y_bb = concat(concat(y_bus, y_bls), y_top_down);
// C
float[] x_cc = {1, 0.830303, 0.636364, 0.454545, 0.266667, 0.10303, 0.030303, 0.0181818, 0.0666667, 0.139394, 0.248485, 0.369697, 0.484848, 0.630303, 0.830303, 1};
float[] y_cc = {1, 0.989744, 0.979487, 0.958974, 0.910256, 0.851282, 0.771795, 0.687179, 0.589744, 0.505128, 0.423077, 0.333333, 0.258974, 0.179487, 0.0794872, 0.00512821};
// D
float[] x_dc = {1-1, 1-0.830303, 1-0.636364, 1-0.454545, 1-0.266667, 1-0.10303, 1-0.030303, 1-0.0181818, 1-0.0666667, 1-0.139394, 1-0.248485, 1-0.369697, 1-0.484848, 1-0.630303, 1-0.830303, 1-1};
float[] x_dd = concat(x_dc, x_top_down_left);
float[] y_dd = concat(y_cc, y_top_down);
// F
float[] x_ff = concat(concat(x_dash_line, x_top_down_left), x_e_line);
float[] y_ff = concat(concat(y_top, y_top_down), y_e_line);
// E
float[] x_ee = concat(x_ff, x_dash_line);
float[] y_ee = concat(y_ff, y_bottom);
// G
float[] x_gg = {0.654545, 0.818182, 0.981818, 0.981818, 0.939394, 0.884848, 0.781818, 0.587879, 0.381818, 0.187879, 0.0727273, 0.0242424, 0.0363636, 0.0848485, 0.151515, 0.260606, 0.363636, 0.515152, 0.660606, 0.8, 0.987879};
float[] y_gg = {0.635897, 0.633333, 0.633333, 0.715385, 0.817949, 0.894872, 0.953846, 0.984615, 0.984615, 0.935897, 0.864103, 0.769231, 0.674359, 0.576923, 0.482051, 0.382051, 0.294872, 0.210256, 0.133333, 0.0692308, 0.00769231};
// H
float[] x_hh = concat(concat(x_top_down_left, x_dash_line), x_top_down_right);
float[] y_hh = concat(concat(y_top_down, y_dash_line), y_top_down);
// I
float[] x_ii = x_top_down_middle;
float[] y_ii = y_top_down;
// J
float[] x_ul = {0, 0, 0.0545454, 0.133333, 0.290909, 0.478788, 0.703031, 0.860607, 0.945455, 0.981819, 0.99394};
float[] y_ul = {0.635897, 0.710256, 0.810256, 0.889744, 0.961538, 0.987179, 0.961538, 0.887179, 0.802564, 0.710256, 0.633333};
float[] x_jj = concat(x_td_half_right, x_ul);
float[] y_jj = concat(y_td_half, y_ul);
// K
//float[] x_kk = 
//float[] y_kk = 
// L
//float[] x_ll = 
//float[] y_ll = 
// M
//float[] x_mm = 
//float[] y_mm = 
// N
//float[] x_nn = 
//float[] y_nn = 
// O
//float[] x_oo = 
//float[] y_oo = 


float[] xs = x_bb;
float[] ys = y_bb;
