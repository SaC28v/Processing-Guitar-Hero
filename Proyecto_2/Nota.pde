//Clase hija
//Clase Nota hereda de ElementoBase

class Nota extends ElementoBase{
  int columna;
  
  Nota(float x, float y,int columna){
    super(x,y);
    this.columna = columna;
  }

  public void actualizar(){
    y += velocidad;
  }
 
  //Funcion override de ElementoBase
  public void mostrar(){
    switch (columna){
      case 1:
        stroke(#FFEB08);
        fill(14, 208, 0);
        break;
      case 2:
        stroke(#FFEB08);
        fill(217, 6, 2);
        break;
      case 3:
        stroke(#FFEB08);
        fill(1, 30, 233);
        break;
      case 4:
        stroke(#FFEB08);
        fill(243, 121, 17);
        break;
      default:
        fill(255);
        break;
    }

    rect(x, y, 55, 55, 5);
  }

  public void resetear(){
    switch (columna) {
      case 1:
        x = CuerdasX[0];
        break;
      case 2:
        x = CuerdasX[1];
        break;
      case 3:
        x = CuerdasX[2];
        break;
      case 4:
        x = CuerdasX[3];
        break;
      default:
        println("Columna inválida");
        break;
    }
    y -= 740;
  }  

  public float getY(){
    return y;
  }
}

//-------------------------------------------------------------------------------------------------------------//
int obtenerColumna(char tecla) {
  switch (tecla) {
    case 'D':
    case 'd':
      return 1;
    case 'F':
    case 'f':
      return 2;
    case 'J':
    case 'j':
      return 3;
    case 'K':
    case 'k':
      return 4;
    default:
      return -1; // Manejo de casos no asignados
  }
}
