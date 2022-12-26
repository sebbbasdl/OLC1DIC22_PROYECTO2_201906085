import { Instruccion } from '../Abstract/Instruccion';
import Arbol from '../Symbol/Three';
import tablaSimbolo from '../Symbol/SymbolTable';
import Tipo, {DataType} from '../Symbol/Type';
import SymbolTable from '../Symbol/SymbolTable';

export default class If extends Instruccion {
    private operacionIf: Instruccion;
    private listaInstrucciones: Instruccion [];    
    private listaElseIf: Instruccion [] | undefined;
    private listaInsElse: Instruccion [] | undefined;


    constructor(
        operacion: Instruccion, 
        listaInstrucciones: Instruccion[], 
        listaElseIf: Instruccion[] | undefined, 
        listaInsElse: Instruccion[] | undefined,
        linea: number, 
        columna: number
    ){
        super(new Tipo(DataType.INDEFINIDO), linea, columna);
        this.operacionIf = operacion
        this.listaInstrucciones = listaInstrucciones
        this.listaElseIf = listaElseIf
        this.listaInsElse = listaInsElse
    }

    public interpretar(arbol: Arbol, tabla: tablaSimbolo) {
        const condition = this.operacionIf.interpretar(arbol, tabla)
        if((condition)){
            const tablaLocal = new SymbolTable(tabla)
            for(let i of this.listaInstrucciones){
                i.interpretar(arbol, tablaLocal)
            }
            return true
        }
    }
}