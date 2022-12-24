"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.parse = exports.listaErrores = void 0;
const Error_1 = __importDefault(require("../../utils/Interpreter/Arbol/Exceptions/Error"));
const Three_1 = __importDefault(require("../../utils/Interpreter/Arbol/Symbol/Three"));
const SymbolTable_1 = __importDefault(require("../../utils/Interpreter/Arbol/Symbol/SymbolTable"));
exports.listaErrores = [];
const parse = (req, res) => {
    exports.listaErrores = new Array();
    let parser = require('../../utils/Interpreter/Arbol/analizador');
    const { peticion } = req.body;
    try {
        const returnThree = parser.parse(peticion);
        let ast = new Three_1.default(returnThree);
        var tabla = new SymbolTable_1.default();
        ast.settablaGlobal(tabla);
        for (let i of ast.getinstrucciones()) {
            if (i instanceof Error_1.default) {
                exports.listaErrores.push(i);
                ast.actualizaConsola(i.returnError());
            }
            var resultador = i.interpretar(ast, tabla) /*i instanceof Instruccion ? i.interpretar(ast, tabla) : new Errores("ERROR SEMANTICO", "no se puede ejecutar la instruccion", 0, 0)*/;
            if (resultador instanceof Error_1.default) {
                exports.listaErrores.push(resultador);
                ast.actualizaConsola(resultador.returnError());
            }
        }
        res.json({ consola: ast.getconsola(), errores: exports.listaErrores, simbolos: [] });
    }
    catch (err) {
        console.log(err);
        res.json({ consola: '', error: err, errores: exports.listaErrores, simbolos: [] });
    }
};
exports.parse = parse;