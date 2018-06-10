
#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

varying vec4 vertColor;
varying vec3 ecNormal;
varying vec3 lightDir;


const vec4 lumcoeff = vec4(0.299, 0.587, 0.114, 0);

void main() {
  vec3 direction = normalize(lightDir);
  vec3 normal = normalize(ecNormal);
  float intensity = max(0.0, dot(direction, normal));
  vec4 col = vec4(intensity, intensity, intensity, 1) * vertColor;
  float lum = dot(col, lumcoeff);
  if (0.25 < lum) {
    gl_FragColor = vertColor;
  } else {
    gl_FragColor = vec4(0.45, 0.05, 0.18, 1);
  }
}
