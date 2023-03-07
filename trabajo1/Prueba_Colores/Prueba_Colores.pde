// Si hay algún par de círculos rotando actualmente

boolean cur_rotating = false;

int circleId1;
int circleId2;

// Numero de circulos a dibujar

int num_circles = 2;

// Se inicializan los colores

int saturation = 99;
int value = 80;

float [][] colors = new float[num_circles][];

int colorsIterator = 0;

// Se crea la lista donde se guardaran los circulos

ArrayList <CircleItem> items = new ArrayList <CircleItem> ();

// Numero de pasos para dar la vuelta para cada par de circulos

int steps = 10;

void setup() {
  
  // Cambio modo de color
  
  colorMode(HSB, 360, 99, 99);
  
  size(800, 800, P2D);
  
  for (int i=0; i<num_circles; i++) {
    colors[i] = new float[] {int(random(0, 359)), saturation, value};
  }
    
  for(int i=0; i < 360 ; i+= int(360 / num_circles)){
        
    int xPos = int(200*cos(i*(PI/180)));
    int yPos = int(200*sin(i*(PI/180)));
    CircleItem ci = new CircleItem(xPos, yPos, colors[(colorsIterator)%colors.length]);
    colorsIterator++;
    
  }
  
  frameRate(10);

}

void draw() {
  
  background(0);
  
  translate(width/2, height/2);
  
  if (cur_rotating == false){
        
    circleId1 = int(random(0, num_circles));    
    circleId2 = int(random(0, num_circles));
    
    //circleId1 = 0;
    //circleId2 = 1;
    
    while (circleId2 == circleId1){
      
      circleId2 = int(random(0, num_circles));
      
    }
    
    CircleItem circle1 = items.get(circleId1);
    CircleItem circle2 = items.get(circleId2);
    
    circle1.setFinal(circle2.xPos, circle2.yPos, circle2.c);
    circle2.setFinal(circle1.xPos, circle1.yPos, circle1.c);
        
    cur_rotating = true;
    
  }
  
  if (cur_rotating == true){
    
    CircleItem circle1 = items.get(circleId1);
    CircleItem circle2 = items.get(circleId2);
    
    circle1.actualizaColor(circleId1);
    circle2.actualizaColor(circleId2);
    
    if (circle1.cCheck == false && circle2.cCheck == false){
            
      cur_rotating = false;
      
    }
    
  }
  
  for (CircleItem item : items){
    
    item.display();
    
  }
}

class CircleItem{
  
    // Posicion actual
  public int xPos = 0;
  public int yPos = 0;
  
  // Posicion inicial
  public int xPosInit = 0;
  public int yPosInit = 0;
  
  // Posicion final
  
  public int xPosEnd = 0;
  public int yPosEnd = 0;
  
  // Saltos
  
  public int saltoX = 0;
  public int saltoY = 0;
  public float saltoC = 0;
  
  // Colores
  
  private float[] c;
  private float[] cEnd;
  
  // Comprobante si ya hizo la transicion a color
  
  public boolean cCheck = true;
  
  
  // Para dibujar cada circulo
  
  public CircleItem(int xPos, int yPos, float[] c){
    
    this.xPos = xPos;
    this.yPos = yPos;
    this.c = c;
    
    items.add(this);
    
  }
  
  public void display(){
        
    fill(this.c[0], this.c[1], this.c[2]);
    circle(this.xPos, this.yPos, 40);
    
  }
  
  public void setFinal(int xPos, int yPos, float[] new_c){
    
   //this.xPosEnd = xPos;
   //this.yPosEnd = yPos;
   this.cEnd = new_c.clone();
   
   this.cCheck = true;
   
   this.saltoC = (this.cEnd[0] - this.c[0]) / steps;
   
  }
  
  public void actualizaColor(int id){
        
    if (this.c[0] != this.cEnd[0]){
      
      if (this.c[0] + this.saltoC > this.cEnd[0]) {
        this.c[0] = this.cEnd[0];
      }
      
      else {
        
        this.c[0] += this.saltoC;
        
      }
      
    }
        
    if (this.c[0] == this.cEnd[0]){
      
      this.cCheck = false;
      
      this.saltoC = 0;
      
      //this.cEnd = this.c;
      
    }
    
  }
  
  // Calcula la pos de X y Y actuales
}
