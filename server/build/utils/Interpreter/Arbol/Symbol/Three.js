"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const SymbolTable_1 = __importDefault(require("./SymbolTable"));
/*import { CDigraph, CNode, CEdge} from '../../../Graphviz'
import { toDot } from 'ts-graphviz';*/
class Three {
    //private raiz: Nodo;
    //private graphIndex: number;
    constructor(instrucciones) {
        // this.instrucciones = production.returnInstruction;
        this.instrucciones = instrucciones;
        this.consola = '';
        this.tablaGlobal = new SymbolTable_1.default();
        this.errores = new Array();
        // this.raiz = production.nodeInstruction;
        //this.graphIndex = 0;
    }
    getconsola() {
        return this.consola;
    }
    setconsola(value) {
        this.consola = value;
    }
    actualizaConsola(uptodate) {
        this.consola = `${this.consola}${uptodate}\n`;
    }
    getinstrucciones() {
        return this.instrucciones;
    }
    setinstrucciones(value) {
        this.instrucciones = value;
    }
    getErrores() {
        return this.errores;
    }
    seterrores(value) {
        this.errores = value;
    }
    gettablaGlobal() {
        return this.tablaGlobal;
    }
    settablaGlobal(value) {
        this.tablaGlobal = value;
    }
}
exports.default = Three;
/*
export class Nodo {
    private hijos: Nodo [];
    private padre: Nodo | undefined;
    private valor: any;

    constructor(valor: any) {
        this.valor = valor;
        this.hijos = [];
    }

    public getValor(): any {
        return this.valor;
    }

    public setValor(valor: any) {
        this.valor = valor;
    }

    public setHijos(hijos: Nodo[]) {
        this.hijos = hijos;
    }

    public setPadre(padre: Nodo) {
        this.padre = padre;
    }

    public getPadre(): Nodo | undefined {
        return this.padre;
    }

    public getHijos(): Nodo[] {
        return this.hijos;
    }

    public generateProduction(labels: any[]): Nodo {
        labels.forEach(element => {
            (typeof element === "string" && this.hijos.push(new Nodo(element)))
            ||
            (element instanceof Nodo && this.hijos.push(element))
        });
        return this;
    }
}*/ 
