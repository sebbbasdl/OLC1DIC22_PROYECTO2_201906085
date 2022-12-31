"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || function (mod) {
    if (mod && mod.__esModule) return mod;
    var result = {};
    if (mod != null) for (var k in mod) if (k !== "default" && Object.prototype.hasOwnProperty.call(mod, k)) __createBinding(result, mod, k);
    __setModuleDefault(result, mod);
    return result;
};
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const Instruccion_1 = require("../Abstract/Instruccion");
const Type_1 = __importStar(require("../Symbol/Type"));
const SymbolTable_1 = __importDefault(require("../Symbol/SymbolTable"));
const cloneDeep_1 = __importDefault(require("lodash/cloneDeep"));
class Mientras extends Instruccion_1.Instruccion {
    constructor(decla, operacion, incre, listaInstrucciones, linea, columna) {
        super(new Type_1.default(Type_1.DataType.INDEFINIDO), linea, columna);
        this.decla = decla;
        this.operacion = operacion;
        this.incre = incre;
        this.listaInstrucciones = listaInstrucciones;
    }
    interpretar(arbol, tabla) {
        const tablaLocal = new SymbolTable_1.default(tabla);
        const auxdecla = (0, cloneDeep_1.default)(this.decla).interpretar(arbol, tablaLocal);
        const auxope = (0, cloneDeep_1.default)(this.operacion).interpretar(arbol, tablaLocal);
        const auxincre = (0, cloneDeep_1.default)(this.incre.tipoDato.getTipo());
        console.log(auxdecla, auxope, auxincre);
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
exports.default = Mientras;
