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
Object.defineProperty(exports, "__esModule", { value: true });
exports.tipoOp = void 0;
const Instruccion_1 = require("../Abstract/Instruccion");
const Type_1 = __importStar(require("../Symbol/Type"));
class Logica extends Instruccion_1.Instruccion {
    constructor(tipo, opIzq, opDer, fila, columna) {
        super(new Type_1.default(Type_1.DataType.INDEFINIDO), fila, columna);
        this.tipo = tipo;
        this.operacionIzq = opIzq;
        this.operacionDer = opDer;
    }
    interpretar(arbol, tabla) {
        const validTypesOperations = [Type_1.DataType.BOOLEAN];
        let valueIzq = this.operacionIzq.interpretar(arbol, tabla);
        let valueDer = this.operacionDer.interpretar(arbol, tabla);
        if (validTypesOperations.includes(this.operacionIzq.tipoDato.getTipo())
            && validTypesOperations.includes(this.operacionDer.tipoDato.getTipo())) {
            if (this.tipo === tipoOp.OR) {
                this.tipoDato = new Type_1.default(Type_1.DataType.BOOLEAN);
                return valueIzq || valueDer;
            }
        }
        else {
            return null;
        }
    }
}
exports.default = Logica;
var tipoOp;
(function (tipoOp) {
    tipoOp[tipoOp["AND"] = 0] = "AND";
    tipoOp[tipoOp["OR"] = 1] = "OR";
})(tipoOp = exports.tipoOp || (exports.tipoOp = {}));
