"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.myGlobal = void 0;
exports.myGlobal = [];
class SymbolTable {
    constructor(anterior) {
        this.tablaAnterior = anterior;
        this.tablaActual = new Map();
    }
    getValor(id) {
        let valor = this.tablaActual.get(id);
        if (!valor) {
            let actual = this.getAnterior();
            while (actual && !valor) {
                valor = actual.getTabla().get(id);
                actual = actual.getAnterior();
            }
        }
        return valor;
    }
    setValor(id, valor, declaration = true) {
        var _a, _b;
        if (declaration)
            this.tablaActual.set(id, valor);
        else {
            let actual = this;
            let oldValue = null;
            while (actual) {
                if (actual.getTabla().get(id)) {
                    oldValue = actual.getTabla().get(id);
                    actual.getTabla().delete(id);
                    actual.getTabla().set(id, valor);
                    break;
                }
                actual = actual.getAnterior();
            }
            if (!oldValue)
                console.log('Error la variable no existe');
        }
        this.tablaActual.set(id, valor);
        exports.myGlobal.push(id + "=" + ((_a = this.tablaActual.get(id)) === null || _a === void 0 ? void 0 : _a.getvalor()));
        console.log(id + "=" + ((_b = this.tablaActual.get(id)) === null || _b === void 0 ? void 0 : _b.getvalor()));
        return null;
    }
    getAnterior() {
        return this.tablaAnterior;
    }
    setAnterior(anterior) {
        this.tablaAnterior = anterior;
    }
    getTabla() {
        return this.tablaActual;
    }
    setTabla(Tabla) {
        this.tablaActual = Tabla;
    }
}
exports.default = SymbolTable;
