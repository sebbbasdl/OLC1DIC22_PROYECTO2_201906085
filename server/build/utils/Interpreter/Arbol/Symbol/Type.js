"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.DataType = void 0;
class Type {
    constructor(tipo) {
        this.tipo = tipo;
    }
    getTipo() {
        return this.tipo;
    }
    setTipo(tipo) {
        this.tipo = tipo;
    }
}
exports.default = Type;
var DataType;
(function (DataType) {
    DataType[DataType["ENTERO"] = 0] = "ENTERO";
    DataType[DataType["CADENA"] = 1] = "CADENA";
    DataType[DataType["BOOLEAN"] = 2] = "BOOLEAN";
    DataType[DataType["CHAR"] = 3] = "CHAR";
    DataType[DataType["DECIMAL"] = 4] = "DECIMAL";
    DataType[DataType["IDENTIFICADOR"] = 5] = "IDENTIFICADOR";
    DataType[DataType["VOID"] = 6] = "VOID";
    DataType[DataType["INDEFINIDO"] = 7] = "INDEFINIDO";
})(DataType = exports.DataType || (exports.DataType = {}));
