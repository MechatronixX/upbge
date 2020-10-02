#define SIGMA 50.0 //10.0
#define BSIGMA 0.01 //0.1
#define MSIZE 5 //15

in vec4 uvcoordsvar;
out vec4 fragColor;

uniform sampler2D iChannel0;
uniform float resX;
uniform float resY;

vec2 iResolution = vec2(resX, resY);

float normpdf(in float x, in float sigma)
{
  return 0.39894 * exp(-0.5 * x * x / (sigma * sigma)) / sigma;
}

float normpdf3(in vec3 v, in float sigma)
{
  return 0.39894 * exp(-0.5 * dot(v, v) / (sigma * sigma)) / sigma;
}

void main()
{
  vec3 c = texture(iChannel0, uvcoordsvar.xy - (gl_FragCoord.xy / iResolution.xy)).rgb;

  // declare stuff
  const int kSize = (MSIZE - 1) / 2;
  float kernel[MSIZE];
  vec3 final_colour = vec3(0.0);

  // create the 1-D kernel
  float Z = 0.0;
  for (int j = 0; j <= kSize; ++j) {
    kernel[kSize + j] = kernel[kSize - j] = normpdf(float(j), SIGMA);
  }

  vec3 cc;
  float factor;
  float bZ = 1.0 / normpdf(0.0, BSIGMA);
  // read out the texels
  for (int i = -kSize; i <= kSize; ++i) {
    for (int j = -kSize; j <= kSize; ++j) {
      cc = texture(iChannel0,
                   uvcoordsvar.xy - (gl_FragCoord.xy + vec2(float(i), float(j))) / iResolution.xy)
               .rgb;
      factor = normpdf3(cc - c, BSIGMA) * bZ * kernel[kSize + j] * kernel[kSize + i];
      Z += factor;
      final_colour += factor * cc;
    }
  }
  fragColor = vec4(final_colour / Z, 1.0);
}
