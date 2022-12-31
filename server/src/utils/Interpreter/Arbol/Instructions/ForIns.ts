import { Instruccion } from '../Abstract/Instruccion';
import Arbol from '../Symbol/Three';
import tablaSimbolo from '../Symbol/SymbolTable';
import Tipo, {DataType} from '../Symbol/Type';
import arit from '../Expresions/Aritmetica'
import SymbolTable from '../Symbol/SymbolTable';
import cloneDeep from 'lodash/cloneDeep';

export default class Mientras extends Instruccion {
    private decla : Instruccion;
    private operacion: Instruccion;
    private incre : Instruccion;
    private listaInstrucciones: Instruccion [];    

    constructor(
        decla : Instruccion,
        operacion: Instruccion, 
        incre: Instruccion,
        listaInstrucciones: Instruccion[], 
        linea: number, 
        columna: number
    ){
        super(new Tipo(DataType.INDEFINIDO), linea, columna);
        this.decla=decla
        this.operacion = operacion
        this.incre= incre
        this.listaInstrucciones = listaInstrucciones
    }

    public interpretar(arbol: Arbol, tabla: tablaSimbolo) {
        const tablaLocal = new SymbolTable(tabla)
        const auxdecla =cloneDeep(this.decla).interpretar(arbol,tablaLocal)
        const auxope =cloneDeep(this.operacion).interpretar(arbol,tablaLocal)
        const auxincre =cloneDeep(this.incre.tipoDato.getTipo())

        

        

        

        console.log(auxdecla,auxope,auxincre)

        /*for (auxdecla; auxope; auxincre) {
            console.log("jeje")
            const instructionsToExec = cloneDeep(this.listaInstrucciones)    
            for(let i of instructionsToExec){
                i.interpretar(arbol, tablaLocal)
            }
            
        }*/
       /* while(cloneDeep(this.operacion).interpretar(arbol, tablaLocal)){   
            
        }*/
        return null;
    }
}