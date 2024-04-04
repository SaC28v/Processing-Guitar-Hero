//Clase Hija
//Clase Boton hereda de ElementoBase

class Boton extends ElementoBase{
  public float w, h;
  public char tecla;
  public boolean activado;
  
  public Boton(float x, float y, float w, float h, char tecla){
    super(x,y);
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.tecla = tecla;
    this.activado = false;
  }

  //F 
  public void mostrar(){
    stroke(#FFEB08);
    
    if(activado){
      fill(#31312F);
    } 
    else{
      fill(0);
    }
    rect(x, y, w, h);
    textSize(24);
    textAlign(CENTER, CENTER);
    fill(#FFEB08);
    text(tecla, x, y);
  }

   public boolean colisiona(Nota nota){
      return activado && x - w / 2 < nota.x && nota.x < x + w / 2 && y - h / 2 < nota.y && nota.y < y + h / 2;
    }

   public boolean Tecla(char t){
      switch (t) {
        case 'd':
        case 'D':
          return this == botones[0];
        case 'f':
        case 'F':
          return this == botones[1];
        case 'j':
        case 'J':
          return this == botones[2];
        case 'k':
        case 'K':
          return this == botones[3];
        default:
          return false;
      }
    }

   public void activar(boolean presionado){
      activado = presionado;
    }
}
