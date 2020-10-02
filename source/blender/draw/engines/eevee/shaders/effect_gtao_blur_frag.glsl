uniform sampler2D iChannel0;
uniform float exponent = 5.0;
uniform float strength = 5.0;
uniform float resX;
uniform float resY;
vec2 resolution = vec2(resX, resY);
in vec4 uvcoordsvar;
out vec4 fragColor;

void main()
{

  vec4 center = texture2D(iChannel0, uvcoordsvar.xy);
  vec4 color = vec4(0.0);
  float total = 0.0;
  for (float x = -4.0; x <= 4.0; x += 1.0) {
    for (float y = -4.0; y <= 4.0; y += 1.0) {
      vec4 sample = texture2D(iChannel0, uvcoordsvar.xy + vec2(x, y) / resolution);
      float weight = 1.0 - abs(dot(sample.rgb - center.rgb, vec3(0.25)));
      weight = pow(weight, exponent);
      color += sample * weight;
      total += weight;
    }
  }
  fragColor = color / total;
}
