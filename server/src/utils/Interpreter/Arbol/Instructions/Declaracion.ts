import { Instruccion } from '../Abstract/Instruccion';
import Arbol from '../Symbol/Three';
import Simbolo from '../Symbol/Symbol';
import tablaSimbolo from '../Symbol/SymbolTable';
import Tipo, {DataType} from '../Symbol/Type';

export default class Declaracion extends Instruccion {
    private id: String;
    private tipo: Tipo;
    private valor: Instruccion;
    
    constructor(id: String, tipo: Tipo, valor: Instruccion, linea: number, columna: number) {
        super(new Tipo(DataType.INDEFINIDO), linea, columna);
        this.id = id;
        this.tipo = tipo;
        this.valor = valor;
        
    }

    public interpretar(arbol: Arbol, tabla: tablaSimbolo) {
        console.log(this.tipo.getTipo())
        console.log(this.valor.tipoDato.getTipo())
        if(this.tipo.getTipo()==this.valor.tipoDato.getTipo() ||this.valor.tipoDato.getTipo()==7){
            tabla.setValor(this.id, new Simbolo(this.tipo, this.id, this.valor.interpretar(arbol, tabla)));
        }else{
            arbol.setSemanticError("No es posible realizar la declaracion ya que son de tipos de datos diferentes en la linea: "+this.linea+" columna: "+this.columna)
        }

        
        return null;
    }
}