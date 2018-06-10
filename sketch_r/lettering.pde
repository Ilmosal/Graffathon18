
float[] x_top_down_left = lerpc(0,0,7);
float[] x_top_down_middle = lerpc(0.5,0.5,7);
float[] x_top_down_right = lerpc(1,1,7);
float[] y_top_down = lerpc(0,1,7);

float[] x_td_half_right = lerpc(1,1,5);
float[] x_td_half_left = lerpc(0,0,5);
float[] y_td_half = lerpc(0,0.66,5);

float[] x_dash_line = lerpc(0,1,4);
float[] y_dash_line = lerpc(0.66,0.66,4);
float[] y_bottom = lerpc(1,1,4);
float[] y_top = lerpc(0,0,4);

float[] x_dash_short = lerpc(0.3,0.7,2);
float[] y_dash_short = lerpc(0.66,0.66,2);
float[] y_bottom_2 = lerpc(1,1,2);
float[] y_top_2 = lerpc(0,0,2);

float[] x_dash_right = lerpc(0.25,1,3);
float[] x_dash_left = lerpc(0,0.75,3);
float[] y_bottom_3 = lerpc(1,1,3);
float[] y_top_3 = lerpc(0,0,3);

float[] xy_mid = lerpc(0.5,0.5,2);
float[] yy_down = lerpc(0.8,1,2);

float[] xa_full_diagonal = lerpc(0,1,8); //for both
float[] ya_full_diagonal = lerpc(1,0,8); //for both
float[] x_double_diagonal = lerpc(0,1,16); //for both

float[] xq_diagonal = lerpc(0.43,0.95,3);
float[] yq_diagonal = lerpc(0.55,1,3);
float[] xr_diagonal = lerpc(0.25,1,4);
float[] yr_diagonal = lerpc(0.75,1,4);
float[] xm_diagonal = lerpc(0.15,0.85,7);
float[] ym_diagonal = concat(lerpc(0.18,0.66,4),lerpc(0.5,0.18,3));
float[] xn_diagonal = lerpc(0.22,0.78,4);
float[] yn_diagonal = lerpc(0.2,0.66,4);
float[] yw_diagonal = concat(lerpc(0.95,0.66,4), lerpc(0.75, 0.9, 3));
float[] x_dots = {0,1};

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
float[] x_cc = {1, 0.636364, 0.266667, 0.030303, 0.0666667, 0.248485, 0.484848, 0.830303, 1};
float[] y_cc = {1, 0.979487, 0.910256, 0.771795, 0.589744, 0.423077, 0.258974, 0.0794872, 0.00512821};
// D
float[] x_dc = {1-1, 1-0.830303, 1-0.636364, 1-0.454545, 1-0.266667, 1-0.10303, 1-0.030303, 1-0.0181818, 1-0.0666667, 1-0.139394, 1-0.248485, 1-0.369697, 1-0.484848, 1-0.630303, 1-0.830303, 1-1};
float[] x_dd = concat(x_dc, x_top_down_left);
float[] y_dd = concat(y_cc, y_top_down);
// F
float[] x_ff = concat(concat(x_dash_right, x_top_down_left), x_dash_short);
float[] y_ff = concat(concat(y_top_3, y_top_down), y_dash_short);
// E
float[] x_ee = concat(x_ff, x_dash_right);
float[] y_ee = concat(y_ff, y_bottom_3);
// G
float[] x_gg = {0.654545, 0.818182, 0.981818, 0.981818, 0.939394, 0.884848, 0.781818, 0.587879, 0.381818, 0.187879, 0.0727273, 0.0242424, 0.0363636, 0.0848485, 0.151515, 0.260606, 0.363636, 0.515152, 0.660606, 0.8, 0.987879};
float[] y_gg = {0.635897, 0.633333, 0.633333, 0.715385, 0.817949, 0.894872, 0.953846, 0.984615, 0.984615, 0.935897, 0.864103, 0.769231, 0.674359, 0.576923, 0.482051, 0.382051, 0.294872, 0.210256, 0.133333, 0.0692308, 0.00769231};
// H
float[] x_hh = concat(concat(x_top_down_left, x_dash_short), x_top_down_right);
float[] y_hh = concat(concat(y_top_down, y_dash_short), y_top_down);
// I
float[] x_ii = concat(concat(x_dash_short,x_top_down_middle),x_dash_short);
float[] y_ii = concat(concat(y_top_2,y_top_down),y_bottom_2);
// J
float[] x_ul = {0, 0, 0.0545454, 0.133333, 0.290909, 0.478788, 0.703031, 0.860607, 0.945455, 0.981819, 0.99394};
float[] y_ul = {0.635897, 0.710256, 0.810256, 0.889744, 0.961538, 0.987179, 0.961538, 0.887179, 0.802564, 0.710256, 0.633333};
float[] x_uls = {0.0545454, 0.290909, 0.703031, 0.945455};
float[] y_uls = {0.810256, 0.961538, 0.961538, 0.802564};
float[] x_jj = concat(append(x_td_half_right, 0), x_uls);
float[] y_jj = concat(append(y_td_half, 0.635897), y_uls);
// K
float[] x_kk = concat(concat(x_top_down_left, xa_full_diagonal), xr_diagonal);
float[] y_kk = concat(concat(y_top_down, ya_full_diagonal), yr_diagonal);
// L
float[] x_ll = concat(x_top_down_left, x_dash_right);
float[] y_ll = concat(y_top_down, y_bottom_3);
// M
float[] x_mm = concat(concat(x_top_down_left, x_top_down_right), xm_diagonal);
float[] y_mm = concat(concat(y_top_down, y_top_down), ym_diagonal);
// N
float[] x_nn = concat(concat(x_top_down_left, x_top_down_right), xn_diagonal);
float[] y_nn = concat(concat(y_top_down, y_top_down), yn_diagonal);
// O //TODO MAKE THE O TOP
float[] x_ous = {0.998077, 0.978846, 0.913462, 0.805769, 0.623077, 0.371154, 0.219231, 0.113462, 0.0403846};
float[] y_ous = {0.615385, 0.418803, 0.237607, 0.0974359, 0.017094, 0.100855, 0.247863, 0.406838, 0.560684};
float[] x_oo = concat(x_uls, x_ous);
float[] y_oo = concat(y_uls, y_ous);
//P
float[] x_pp = concat(x_top_down_left, x_bus);
float[] y_pp = concat(y_top_down, y_bus);
//Q
float[] x_qq = concat(x_oo,xq_diagonal);
float[] y_qq = concat(y_oo,yq_diagonal);
//
//R
float[] x_rr = concat(x_pp,xr_diagonal);
float[] y_rr = concat(y_pp,yr_diagonal);
//S
float[] x_ssl = {0, 0.2, 0.442424, 0.666667, 0.872727, 0.993939, 0.957576, 0.824242, 0.606061, 0.327273, 0.121212, 0.0121212, 0.0545455, 0.175758, 0.333333, 0.527273, 0.733333, 0.987879};
float[] y_ssl = {0.989744, 0.989744, 0.976923, 0.953846, 0.907692, 0.828205, 0.741026, 0.676923, 0.646154, 0.628205, 0.587179, 0.510256, 0.415385, 0.325641, 0.233333, 0.153846, 0.0794872, 0.0102564};
float[] x_ss = {0, 0.442424, 0.872727, 0.957576, 0.606061, 0.121212, 0.0545455, 0.333333, 0.733333};
float[] y_ss = {0.989744, 0.976923, 0.907692, 0.741026, 0.646154, 0.587179, 0.415385, 0.233333, 0.0794872};

//T
float[] x_tt = concat(x_dash_line, x_top_down_middle);
float[] y_tt = concat(y_top, y_top_down);
//U
float[] x_uu = concat(concat(x_td_half_right, x_uls), x_td_half_left);
float[] y_uu = concat(concat(y_td_half, y_uls), y_td_half);
//V
float[] x_vv = x_double_diagonal;
float[] y_vv = concat(xa_full_diagonal, ya_full_diagonal);
//W
//maybe we don't need w?
float[] x_ww = concat(concat(x_top_down_left, xm_diagonal), x_top_down_right);
float[] y_ww = concat(concat(y_top_down, yw_diagonal), y_top_down);
//X
float[] x_xx = concat(xa_full_diagonal, xa_full_diagonal);
float[] y_xx = concat(ya_full_diagonal, xa_full_diagonal);
//Y
float[] x_yy = concat(concat(xm_diagonal, xy_mid), x_dots);
float[] y_yy = concat(concat(ym_diagonal, yy_down), y_top_2);
//Z
float[] x_zz = concat(x_dash_left, concat(xa_full_diagonal, x_dash_right));
float[] y_zz = concat(y_top_3, concat(ya_full_diagonal,y_bottom_3));

float[][] letter_a = {x_aa, y_aa};
float[][] letter_b = {x_bb, y_bb};
float[][] letter_c = {x_cc, y_cc};
float[][] letter_d = {x_dd, y_dd};
float[][] letter_e = {x_ee, y_ee};
float[][] letter_f = {x_ff, y_ff};
float[][] letter_g = {x_gg, y_gg};
float[][] letter_h = {x_hh, y_hh};
float[][] letter_i = {x_ii, y_ii};
float[][] letter_j = {x_jj, y_jj};
float[][] letter_k = {x_kk, y_kk};
float[][] letter_l = {x_ll, y_ll};
float[][] letter_m = {x_mm, y_mm};
float[][] letter_n = {x_nn, y_nn};
float[][] letter_o = {x_oo, y_oo};
float[][] letter_p = {x_pp, y_pp};
float[][] letter_q = {x_qq, y_qq};
float[][] letter_r = {x_rr, y_rr};
float[][] letter_s = {x_ss, y_ss};
float[][] letter_t = {x_tt, y_tt};
float[][] letter_u = {x_uu, y_uu};
float[][] letter_v = {x_vv, y_vv};
float[][] letter_w = {x_ww, y_ww};
float[][] letter_x = {x_xx, y_xx};
float[][] letter_y = {x_yy, y_yy};
float[][] letter_z = {x_zz, y_zz};
float[][] letter_space = {{},{}};

float[][][] letters = {letter_a,letter_b,letter_c,letter_d,letter_e,letter_f,letter_g,letter_h,letter_i,letter_j,letter_k,letter_l,letter_m,letter_n,letter_o,letter_p,letter_q,letter_r,letter_s,letter_t,letter_u,letter_v,letter_w,letter_x,letter_y,letter_z};

float[][] kernings = {{1.500, 1.500, 1.482, 1.500, 1.500, 1.500, 1.476, 1.500, 1.200, 1.500, 1.500, 1.500, 1.500, 1.500, 1.460, 1.500, 1.460, 1.500, 1.500, 1.500, 1.500, 1.500, 1.500, 1.500, 1.500, 1.500}, {1.443, 1.458, 1.429, 1.458, 1.458, 1.458, 1.433, 1.458, 1.113, 1.433, 1.458, 1.458, 1.458, 1.458, 1.407, 1.458, 1.407, 1.458, 1.418, 1.053, 1.443, 1.143, 1.458, 1.413, 1.053, 1.413}, {1.500, 1.500, 1.417, 1.500, 1.500, 1.500, 1.421, 1.500, 1.200, 1.410, 1.500, 1.500, 1.500, 1.500, 1.410, 1.500, 1.410, 1.500, 1.500, 1.500, 1.500, 1.500, 1.500, 1.500, 1.500, 1.500}, {1.482, 1.482, 1.464, 1.482, 1.482, 1.482, 1.453, 1.482, 1.117, 1.482, 1.482, 1.482, 1.482, 1.482, 1.426, 1.482, 1.426, 1.482, 1.422, 1.022, 1.482, 1.212, 1.482, 1.417, 1.102, 1.417}, {1.500, 1.500, 1.417, 1.500, 1.500, 1.500, 1.421, 1.500, 1.200, 1.410, 1.500, 1.500, 1.500, 1.500, 1.410, 1.500, 1.410, 1.500, 1.500, 1.500, 1.500, 1.500, 1.500, 1.500, 1.500, 1.500}, {1.200, 1.500, 1.182, 1.500, 1.500, 1.500, 1.166, 1.500, 1.200, 1.200, 1.500, 1.500, 1.500, 1.500, 1.220, 1.500, 1.220, 1.500, 1.225, 1.500, 1.500, 1.500, 1.500, 1.500, 1.500, 1.500}, {1.483, 1.488, 1.465, 1.488, 1.488, 1.488, 1.459, 1.488, 1.188, 1.483, 1.488, 1.488, 1.488, 1.488, 1.437, 1.488, 1.437, 1.488, 1.413, 1.488, 1.488, 1.488, 1.488, 1.488, 1.488, 1.488}, {1.500, 1.500, 1.482, 1.500, 1.500, 1.500, 1.476, 1.500, 1.200, 1.500, 1.500, 1.500, 1.500, 1.500, 1.460, 1.500, 1.460, 1.500, 1.500, 1.500, 1.500, 1.500, 1.500, 1.500, 1.500, 1.500}, {1.200, 1.200, 1.117, 1.200, 1.200, 1.200, 1.121, 1.200, 0.900, 1.110, 1.200, 1.200, 1.200, 1.200, 1.110, 1.200, 1.110, 1.200, 1.200, 1.200, 1.200, 1.200, 1.200, 1.200, 1.200, 1.200}, {1.500, 1.500, 1.482, 1.500, 1.500, 1.500, 1.466, 1.500, 1.200, 1.500, 1.500, 1.500, 1.500, 1.500, 1.460, 1.500, 1.460, 1.500, 1.440, 1.500, 1.500, 1.500, 1.500, 1.500, 1.500, 1.500}, {1.500, 1.500, 1.417, 1.500, 1.500, 1.500, 1.421, 1.500, 1.200, 1.410, 1.500, 1.500, 1.500, 1.500, 1.410, 1.500, 1.410, 1.500, 1.500, 1.500, 1.500, 1.500, 1.500, 1.500, 1.500, 1.500}, {1.500, 1.500, 1.417, 1.500, 1.500, 1.500, 1.421, 1.500, 1.200, 1.410, 1.500, 1.500, 1.500, 1.500, 1.410, 1.500, 1.410, 1.500, 1.500, 1.000, 1.410, 1.080, 1.500, 1.500, 1.000, 1.500}, {1.500, 1.500, 1.482, 1.500, 1.500, 1.500, 1.476, 1.500, 1.200, 1.500, 1.500, 1.500, 1.500, 1.500, 1.460, 1.500, 1.460, 1.500, 1.500, 1.500, 1.500, 1.500, 1.500, 1.500, 1.500, 1.500}, {1.500, 1.500, 1.482, 1.500, 1.500, 1.500, 1.476, 1.500, 1.200, 1.500, 1.500, 1.500, 1.500, 1.500, 1.460, 1.500, 1.460, 1.500, 1.500, 1.500, 1.500, 1.500, 1.500, 1.500, 1.500, 1.500}, {1.498, 1.498, 1.475, 1.498, 1.498, 1.498, 1.459, 1.498, 1.108, 1.498, 1.498, 1.498, 1.498, 1.498, 1.458, 1.498, 1.458, 1.498, 1.428, 1.358, 1.498, 1.358, 1.498, 1.408, 1.358, 1.408}, {1.207, 1.227, 1.179, 1.227, 1.227, 1.227, 1.163, 1.227, 0.752, 1.212, 1.227, 1.227, 1.227, 1.227, 1.187, 1.227, 1.187, 1.227, 1.167, 1.052, 1.227, 1.077, 1.227, 1.052, 1.052, 1.052}, {1.498, 1.498, 1.475, 1.498, 1.498, 1.498, 1.459, 1.498, 1.153, 1.498, 1.498, 1.498, 1.498, 1.498, 1.458, 1.498, 1.458, 1.498, 1.453, 1.358, 1.498, 1.358, 1.498, 1.453, 1.358, 1.453}, {1.500, 1.500, 1.417, 1.500, 1.500, 1.500, 1.421, 1.500, 1.200, 1.410, 1.500, 1.500, 1.500, 1.500, 1.410, 1.500, 1.410, 1.500, 1.500, 1.050, 1.410, 1.080, 1.500, 1.500, 1.050, 1.500}, {1.453, 1.453, 1.439, 1.453, 1.453, 1.453, 1.433, 1.453, 1.088, 1.448, 1.453, 1.453, 1.453, 1.453, 1.402, 1.453, 1.402, 1.453, 1.393, 1.228, 1.453, 1.228, 1.453, 1.388, 1.228, 1.388}, {1.000, 1.500, 1.022, 1.500, 1.500, 1.500, 1.066, 1.500, 1.200, 1.000, 1.500, 1.500, 1.500, 1.500, 1.220, 1.500, 1.220, 1.500, 1.225, 1.500, 1.500, 1.500, 1.500, 1.500, 1.500, 1.500}, {1.500, 1.500, 1.482, 1.500, 1.500, 1.500, 1.466, 1.500, 1.200, 1.500, 1.500, 1.500, 1.500, 1.500, 1.460, 1.500, 1.460, 1.500, 1.440, 1.500, 1.500, 1.500, 1.500, 1.500, 1.500, 1.500}, {1.245, 1.500, 1.212, 1.500, 1.500, 1.500, 1.201, 1.500, 1.200, 1.255, 1.500, 1.500, 1.500, 1.500, 1.245, 1.500, 1.245, 1.500, 1.300, 1.500, 1.500, 1.500, 1.500, 1.500, 1.500, 1.500}, {1.500, 1.500, 1.482, 1.500, 1.500, 1.500, 1.476, 1.500, 1.200, 1.500, 1.500, 1.500, 1.500, 1.500, 1.460, 1.500, 1.460, 1.500, 1.500, 1.500, 1.500, 1.500, 1.500, 1.500, 1.500, 1.500}, {1.500, 1.500, 1.417, 1.500, 1.500, 1.500, 1.421, 1.500, 1.200, 1.410, 1.500, 1.500, 1.500, 1.500, 1.410, 1.500, 1.410, 1.500, 1.500, 1.500, 1.500, 1.500, 1.500, 1.500, 1.500, 1.500}, {1.120, 1.500, 1.102, 1.500, 1.500, 1.500, 1.101, 1.500, 1.200, 1.140, 1.500, 1.500, 1.500, 1.500, 1.220, 1.500, 1.220, 1.500, 1.240, 1.500, 1.500, 1.500, 1.500, 1.500, 1.500, 1.500}, {1.500, 1.500, 1.417, 1.500, 1.500, 1.500, 1.421, 1.500, 1.200, 1.410, 1.500, 1.500, 1.500, 1.500, 1.410, 1.500, 1.410, 1.500, 1.500, 1.500, 1.500, 1.500, 1.500, 1.500, 1.500, 1.500}};

float[][] getLetter(char letter){
  if(letter <= 'Z' && letter >= 'A') return letters[letter-'A'];
  if(letter <= 'z' && letter >= 'a') return letters[letter-'a'];
  return letter_space;
}

float[] moveLetter(float[] points, float offset_x){
  float[] copied = new float[points.length];
  arrayCopy(points, copied);
  for(int i=0;i<copied.length;i++){
    copied[i] = copied[i] + offset_x;
  }
  return copied;
}

float getKerning(char prev, char curr){
  if (prev == ' ' || curr == ' ') return 1.5;
  return kernings[prev - 'a'][curr - 'a'];
}

float[][] getDotString(String stringy){
  stringy = stringy.toLowerCase();
  float[] x_points = {};
  float[] y_points = {};
  float offset = -1.5;
  char prev = ' ';
  for (int i=0;i<stringy.length();i++){
    char curr = stringy.charAt(i);
    float[][] letter = getLetter(curr);
    float kerning = getKerning(prev, curr);
    offset += kerning;
    x_points = concat(x_points, moveLetter(letter[0],offset)); 
    y_points = concat(y_points, letter[1]);
    if (curr != ' ') prev = curr;
  }
  float[][] points = {x_points, y_points};
  return points;
}

float[][] xy_string = getDotString("skdjgf asdfja");
float[] xs = xy_string[0];
float[] ys = xy_string[1];
