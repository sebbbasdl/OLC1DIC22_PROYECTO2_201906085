"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const Instruccion_1 = require("../Abstract/Instruccion");
const Type_1 = require("../Symbol/Type");
const get_1 = __importDefault(require("lodash/get"));
class Nativo extends Instruccion_1.Instruccion {
    constructor(tipo, valor, fila, columna) {
        super(tipo, fila, columna);
        this.valor = valor;
    }
    interpretar(arbol, tabla) {
        if (this.tipoDato.getTipo() === Type_1.DataType.ENTERO) {
            return this.valor;
        }
        else if (this.tipoDato.getTipo() === Type_1.DataType.CADENA) {
            return this.valor.toString();
        }
        else if (this.tipoDato.getTipo() === Type_1.DataType.IDENTIFICADOR) {
            let value = tabla.getValor(this.valor);
            //this.tipoDato = get(value, 'tipo', new Type(DataType.INDEFINIDO));
            return (0, get_1.default)(value, 'valor');
        }
    }
}
exports.default = Nativo;
