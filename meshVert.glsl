#define PROCESSING_SHADER

uniform mat4 transform;
uniform mat4 modelview;
uniform mat4 projection;

uniform sampler2D depthMap;
uniform float depthScale;

attribute vec4 vertex;
attribute vec2 texCoord;

varying vec2 vertTexCoord;

void main() {
  // Sample depth from texture
  float depth = texture2D(depthMap, texCoord).r;
  
  // Modify vertex position based on depth
  vec4 pos = vertex;
  pos.z = depth * depthScale; // Use depth scale uniform
  
  // Transform vertex
  gl_Position = transform * pos;
  
  // Pass texture coordinates to fragment shader
  vertTexCoord = texCoord;
}