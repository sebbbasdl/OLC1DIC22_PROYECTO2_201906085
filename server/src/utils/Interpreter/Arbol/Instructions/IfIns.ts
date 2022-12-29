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
            console.log("estoy aqui1")
            return true
        }else{
            if(this.listaElseIf){ 
                for(let i of this.listaElseIf){
                    const operation = i.interpretar(arbol, tabla);
                    if(operation){
                        return false;
                    }
                }
                console.log("estoy aqui2")
            }
            if(this.listaInsElse){
                const tablaLocal = new SymbolTable(tabla)
                for(let i of this.listaInsElse){
                    i.interpretar(arbol, tablaLocal)
                }
                console.log("estoy aqui3")
                return false
            }
        }
    }
}