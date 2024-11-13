PShader meshShader;
PShape gridMesh;
PImage depthMap, textureImage;
int gridSize = 800; // Number of vertices per side
float depthScale = 100.0; // Control depth effect strength

void setup() {
  size(800, 600, P3D);
  
  // Load depth map and texture
  depthMap = loadImage("depth1.png");
  textureImage = loadImage("image.png");
  
  // Create shader
  meshShader = loadShader("meshFrag.glsl", "meshVert.glsl");
  meshShader.set("depthMap", depthMap);
  meshShader.set("textureMap", textureImage);
  meshShader.set("depthScale", depthScale);
  
  // Create base grid mesh
  gridMesh = createShape();
  gridMesh.beginShape(TRIANGLE_STRIP);
  gridMesh.noStroke();
  
  float totalSize = 400;
  float cellSize = totalSize / (gridSize - 1);
  float halfWidth = totalSize / 2;
  float halfHeight = totalSize / 2;
  
  // Generate grid of vertices using triangle strip
  for (int y = 0; y < gridSize-1; y++) {
    // For even numbered rows go left to right,
    // for odd numbered rows go right to left
    if (y % 2 == 0) {
      for (int x = 0; x < gridSize; x++) {
        float xPos = x * cellSize - halfWidth;
        
        // Add vertex from current row
        gridMesh.attrib("texCoord", x / (float)(gridSize-1), y / (float)(gridSize-1));
        gridMesh.vertex(xPos, y * cellSize - halfHeight, 0);
        
        // Add vertex from next row
        gridMesh.attrib("texCoord", x / (float)(gridSize-1), (y+1) / (float)(gridSize-1));
        gridMesh.vertex(xPos, (y+1) * cellSize - halfHeight, 0);
      }
    } else {
      // Go right to left for odd rows to maintain strip connectivity
      for (int x = gridSize-1; x >= 0; x--) {
        float xPos = x * cellSize - halfWidth;
        
        // Add vertex from current row
        gridMesh.attrib("texCoord", x / (float)(gridSize-1), y / (float)(gridSize-1));
        gridMesh.vertex(xPos, y * cellSize - halfHeight, 0);
        
        // Add vertex from next row
        gridMesh.attrib("texCoord", x / (float)(gridSize-1), (y+1) / (float)(gridSize-1));
        gridMesh.vertex(xPos, (y+1) * cellSize - halfHeight, 0);
      }
    }
    
    // If this isn't the last row, add degenerate triangles to connect strips
    if (y < gridSize-2) {
      // Add two vertices at the end of the current strip
      float xEnd = (y % 2 == 0) ? (gridSize-1) : 0;
      gridMesh.attrib("texCoord", xEnd / (float)(gridSize-1), (y+1) / (float)(gridSize-1));
      gridMesh.vertex(xEnd * cellSize - halfWidth, (y+1) * cellSize - halfHeight, 0);
      gridMesh.vertex(xEnd * cellSize - halfWidth, (y+1) * cellSize - halfHeight, 0);
    }
  }
  
  gridMesh.endShape();
  frameRate(1000);
}

void draw() {
  background(0);
  pushMatrix();
  //ortho();
  perspective();
  translate(width/2, height/2);
  rotateX(map(mouseY, 0, height, PI, -PI));
  rotateY(map(mouseX, 0, width, -PI, PI));
  scale(1.3);
  shader(meshShader);
  shape(gridMesh);
  popMatrix();

  resetShader();
  stroke(255);
  fill(255);
  text(frameRate, 10, 10);
}

void keyPressed(){
  int k = key-48;
  if (k >0 && k<5){
   println(k);
   depthMap = loadImage("depth" + k + ".png");
   meshShader.set("depthMap", depthMap);
  }
}
