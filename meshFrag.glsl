#define PROCESSING_SHADER

uniform sampler2D depthMap;
uniform sampler2D textureMap;
varying vec2 vertTexCoord;

void main() {
  // Sample color from texture map
  vec4 texColor = texture2D(textureMap, vertTexCoord);
  gl_FragColor = texColor;
}