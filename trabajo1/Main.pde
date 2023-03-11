// Estrellas

int NUM_STARS = 50;
ArrayList<Star> stars = new ArrayList<Star>();

// Si hay algún par de círculos rotando actualmente

boolean cur_rotating = false;

int circleId1;
int circleId2;

// Par de círculos que rotó anteriormente

int prevCircleId1;
int prevCircleId2;

// Numero de circulos a dibujar

int num_circles = 12;

// Radio inicial

float radio = 200;

// Se inicializan los colores

int saturation = 60;
int brightness = 80;

float [] colors = new float[num_circles];

int colorsIterator = 0;

// Se crea la lista donde se guardaran los circulos

ArrayList <CircleItem> items = new ArrayList <CircleItem> ();

// Se crea la lista donde se guardaran las orbitas

ArrayList <OrbitItem> orbitItems = new ArrayList <OrbitItem> ();

int [][] posicionesIniciales = new int[num_circles][];

// Numero de pasos para dar la vuelta para cada par de circulos

int steps = 180;

// Velocidad de movimiento

int speed = 0;

// Parametros para la circunferencia que se dibuja al fondo

float centroX = 0;
float centroY = 0;
float diametro = 0;

int checkDescuadre = 0;
int checkDescuadre1 = 0;

void setup() {
  
  // Cambio modo de color
  
  colorMode(HSB, 360, 100, 100);
  
  size(800, 800, P2D);
  
  // Creacion estrellas
  
  for (int i = 0; i < NUM_STARS; i++) {
        
        stars.add(new Star(noise(width), noise(height)));
  }
  
  // Creacion de los colores
  
  for (int i=0; i < num_circles; i++) {
    colors[i] = int(random(0, 359));
  }
  
  // Creacion circulos
  
  int counterPos = 0;
  
  for(int i=0; i < 360 ; i += int(360/num_circles)){
            
    int xPos = int(radio*cos(i*(PI/180)));
    int yPos = int(radio*sin(i*(PI/180)));
    
    int[] temp = new int[] {xPos, yPos};
            
    posicionesIniciales[counterPos] = (temp);
    
    counterPos++;
        
    CircleItem ci = new CircleItem(xPos, yPos, colors[(colorsIterator)%colors.length]+1-1);
    
    colorsIterator++;
    
  }
  
  frameRate(100);
}

void draw() {
  
  background(0);
  
  // Parte del centro
  
  float acc = map(mouseX, 0, width, 0.005f, 0.2f);
    
  for (Star star : stars) {
      
      star.corre();
      star.update(acc);
  }
  
  stars.removeIf(star -> !star.is_active());
  
  while (stars.size() < NUM_STARS) {
      
      stars.add(new Star(random(width), random(height)));
  }
  
  translate(width/2, height/2);
  
  // Si no hay nada rotando actualmente
  
  if (cur_rotating == false){
    
    float temp = random(0, 1);
    
    println(temp);
    
    if (temp <= 0.2) {
      
      speed = steps/4;
      
    }
    else if (temp <= 0.4) {
      
      speed = steps/3;
      
    }
    
    else if (temp <= 0.6) {
      
      speed = steps/2;
      
    }
    
    else if (temp <= 0.8) {
      
      speed = steps;
      
    }
    
    else {
      
      speed = steps*2;
      
    }
    
    checkDescuadre ++;
    checkDescuadre1 ++;
    
    // Escoge que par de circulos van a rotar
        
    circleId1 = int(random(0, num_circles));
    circleId2 = int(random(0, num_circles));
        
    while (
        // Si son el mismo
        circleId2 == circleId1
        // O si son los opuestos
        //|| (num_circles%2 == 0 && num_circles != 2 && abs(circleId1-circleId2) == int(num_circles/2))
        // O si son el par anterior
        || ((circleId1 == prevCircleId1 && circleId2 == prevCircleId2) || (circleId1 == prevCircleId2 && circleId2 == prevCircleId1))
      ){

      circleId1 = int(random(0, num_circles));
      circleId2 = int(random(0, num_circles));
      
    }
        
    CircleItem circle1 = items.get(circleId1);
    CircleItem circle2 = items.get(circleId2);
    
    while (num_circles%2 == 0 && num_circles != 2
      && (abs(circle1.posicion-circle2.posicion) == int(num_circles/2)-1
          || abs(circle1.posicion-circle2.posicion) == int(num_circles/2)
          || abs(circle1.posicion-circle2.posicion) == int(num_circles/2)+1)){
            
      println("Entra con", circle1.posicion, "y con", circle2.posicion);
      
      circleId1 = int(random(0, num_circles));
      circleId2 = int(random(0, num_circles));
      
      circle1 = items.get(circleId1);
      circle2 = items.get(circleId2);
    
    }
    
    // Asigna el centro y diametro de la orbita en la que van a rotar
            
    centroX = (circle1.xPos + circle2.xPos)/2;
    centroY = (circle1.yPos + circle2.yPos)/2;
    diametro = dist(circle1.xPos, circle1.yPos, circle2.xPos, circle2.yPos);
    
    // Asigna el tono promedio entre los dos circulos
    
    float hue = (circle1.c + circle2.c) / 2;
    
    // Crea la orbita
    
    OrbitItem orbit = new OrbitItem(centroX, centroY, diametro, hue);
    
    circle1.setFinal(centroX, centroY, circle2.c);
    circle2.setFinal(centroX, centroY, circle1.c);
    
    // Activa la rotacion
        
    cur_rotating = true;
    
  }
  
  // Cuando haya rotacion
  
  if (cur_rotating == true){
    
    CircleItem circle1 = items.get(circleId1);
    CircleItem circle2 = items.get(circleId2);
    
    // Actualiza los circulos
    
    circle1.actualiza();
    circle2.actualiza();
    
    // Cambia el alpha de las orbitas
    OrbitItem orbit = orbitItems.get(orbitItems.size()-1);
    orbit.changeOpacity();
    
    // Si ya termino la rotacion, escoge otro par de circulos
    
    if (circle1.check == false && circle2.check == false){
      
      prevCircleId1 = circleId1;
      prevCircleId2 = circleId2;
            
      cur_rotating = false;
      delay(steps);
      
      // Elimina la orbita
      
      orbitItems.remove(orbitItems.size()-1);
      
    }
    
  }
  
  for (CircleItem item : items){
    
    item.display();
    
  }
  
  for (OrbitItem item : orbitItems){
    
    item.display();
    
  }
}

class CircleItem{
    
  // Contador pasos
  
  public int counter = 0;
  
  // Posicion actual
  public int xPos = 0;
  public int yPos = 0;
    
  public float angulo = 0;
  
  // Centro orbita
  
  public float centroX = 0;
  public float centroY = 0;
  
  public float radio = 0;
  
  // Saltos
  
  public float saltoH = 0;
  
  // Colores
  
  private float c;
  private float cEnd;
  private float cInit;
  
  // Posicion actual del circulo
  
  private int posicion = 0;
  
  // Comprobante si ya hizo la transicion
  
  public boolean check = true;
  
  // Para dibujar cada circulo
  
  public CircleItem(int xPos, int yPos, float c){
        
    this.xPos = xPos;
    this.yPos = yPos;
    this.c = c+1-1;
    this.cInit = c+1-1;
    
    items.add(this);
    
    this.posicion = items.indexOf(this);
    
  }
  
  public void display(){
    
    noStroke();
        
    fill(this.c, saturation, brightness);
    circle(this.xPos, this.yPos, 40);
    
  }
  
  public void setFinal(float centroX, float centroY, float new_c){    

    this.cEnd = new_c+1-1;
   
    this.centroX = centroX;
    this.centroY = centroY;
     
    this.angulo = atan2(this.yPos - this.centroY, this.xPos - this.centroX);
    
    this.radio = dist(this.xPos, this.yPos, this.centroX, this.centroY);
     
    this.check = true;
     
    this.saltoH = (this.cEnd - this.c) / float(speed);
    
  }
  
  public void actualizaColor(){
    
    if (this.c != this.cEnd){
      
      if (this.c < this.cEnd && this.c + this.saltoH > this.cEnd) {
        this.c = this.cEnd;
      }
      
      else if (this.c > this.cEnd && this.c + this.saltoH < this.cEnd) {
        this.c = this.cEnd;
      }
      
      else {
        
        this.c += this.saltoH;
        
      }
      
    }
    
    //this.c = lerpColor(color(this.cInit, saturation, brightness), color(this.cEnd, saturation, brightness), this.counter*this.saltoH/100);
        
  }
  
  // Calcula la pos de X y Y actuales
  
  public void actualizaPosicion(){
    
    this.angulo += PI/speed;
            
    this.xPos = int(this.centroX + this.radio*cos(this.angulo));
    this.yPos = int(this.centroY + this.radio*sin(this.angulo));
    
  }
  
  public void actualiza(){
    
    this.actualizaColor();
    this.actualizaPosicion();
    
    this.counter ++;
    
    if (this.counter == speed){
            
      this.counter = 0;
      
      this.check = false;
      
      this.ajustaPosicion();
      
    }
    
  }
  
  public void ajustaPosicion(){
    
    int xCercano = this.xPos;
    
    int yCercano = this.yPos;
    
    float distCercana = radio;
    
    int indexCercano = 0;
      
    for (int i=0; i<posicionesIniciales.length; i++){
      
      float distActual = dist(this.xPos, this.yPos, posicionesIniciales[i][0], posicionesIniciales[i][1]);
      
      if (distActual < distCercana || distActual == 0){
        
        distCercana = distActual;
        
        xCercano = posicionesIniciales[i][0];
        yCercano = posicionesIniciales[i][1];
        
        indexCercano = i;
        
      }
    
    }
    
  this.xPos = xCercano;
  this.yPos = yCercano;
  
  this.posicion = indexCercano;
  
  }
  
}

public class OrbitItem{
  
  public float centroX = 0;
  public float centroY = 0;
  public float radio = 0;
  
  public float hue = 0;
  
  public float saltoS = 0;
  
  public float sat = 0;
  
  public float alpha = 0;
  public float alphaChange = 512 / float(speed);
    
  public OrbitItem(float centroX, float centroY, float radio, float hue){
    
    this.centroX = centroX;
    this.centroY = centroY;
    this.radio = radio;
    
    this.hue = hue;
    
    this.saltoS = float(saturation) / float(speed);
    
    orbitItems.add(this);
    
  }
  
  public void changeOpacity() {
    
    this.alpha += this.alphaChange;
    
    if (this.alpha > 255 || this.alpha < 0) {
      this.alphaChange *= -1;
      
    }
    
  }
  
  public void display(){
    
    this.sat += this.saltoS;
        
    strokeWeight(3);
    stroke(this.hue, this.sat, brightness, this.alpha);
    noFill();
        
    circle(centroX, centroY, radio);
    
    noStroke();
  
  }
}

class Star {

    PVector pos;
    PVector prev_pos;
    PVector vel;
    float ang;
    
    Star(float x, float y) {
        
        pos = new PVector(x, y);
        prev_pos = new PVector(x, y);
        vel = new PVector(0, 0);
        ang = atan2(y - (height/2), x - (width/2));
    }
    
    boolean is_active() {
        
        return on_screen(prev_pos.x, prev_pos.y);
    }
    
    void update(float acc) {
        
        vel.x += cos(ang) * acc;
        vel.y += sin(ang) * acc;
        
        prev_pos.x = pos.x;
        prev_pos.y = pos.y;
        
        pos.x += vel.x;
        pos.y += vel.y;
    }
    
    void corre() {
      
        stroke(random(255), random(255), random(255));
        strokeWeight(3);
        line(pos.x, pos.y, prev_pos.x, prev_pos.y);
    }
}

boolean on_screen(float x, float y) {
    
    return x >= 0 && x <= width && y >= 0 && y <= height;
}
