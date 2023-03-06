float centerX, centerY, centerX2, centerY2;
float radius = 100;
float angle = 0, angle2 = PI;
float speed = 0.05;
float waitTime = 5000; // in milliseconds
float startTime;

void setup() {
  size(640, 480);
  centerX = width/2;
  centerY = height/2;
  smooth();
  startTime = millis();
}

void draw() {
  // Wait for 5 seconds
  if (millis() - startTime < waitTime) {
    background(255);
    noStroke();
    fill(255, 0, 0);
    ellipse(centerX + cos(0) * radius, centerY + sin(0) * radius, 40, 40);
    ellipse(centerX + cos(600) * radius, centerY + sin(600) * radius, 40, 40);
    return;
  }
  
  // Calculate circle position
  float x = centerX + cos(angle) * radius;
  float y = centerY + sin(angle) * radius;
  angle += speed;
  
  float x2 = centerX + cos(angle2) * radius;
  float y2 = centerY + sin(angle2) * radius;
  angle2 += speed;
  
  // Draw circle
  background(255);
  noStroke();
  fill(255, 0, 0);
  ellipse(x, y, 40, 40);
  ellipse(x2, y2, 40, 40);
  
  // Check if the circle has completed a full rotation
  if (angle >= TWO_PI) {
    angle = 0;
    angle2 = PI;
    startTime = millis();
  }
}
