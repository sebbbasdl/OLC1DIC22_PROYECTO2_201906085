import { Response, Request } from "express";
import Errores from '../../utils/Interpreter/Arbol/Exceptions/Error';
import Three from "../../utils/Interpreter/Arbol/Symbol/Three";
import SymbolTable from "../../utils/Interpreter/Arbol/Symbol/SymbolTable";
import { Instruccion } from "../../utils/Interpreter/Arbol/Abstract/Instruccion";
import { type } from "os";
import * as graphviz from 'graphviz';
import { toFile } from 'ts-graphviz/adapter';




export let listaErrores: Array<Errores> = [];

export const parse = (req: Request & unknown, res: Response): void => {
    listaErrores = new Array<Errores>();
    let parser = require('../../utils/Interpreter/Arbol/analizador');
    const { peticion } = req.body;

    try { 
      const returnThree = parser.parse(peticion)
      let ast = new Three(returnThree);
      var tabla = new SymbolTable();
      ast.settablaGlobal(tabla);
      
      for (let i of ast.getinstrucciones()) {
        if (i instanceof Errores) {
          listaErrores.push(i);
          ast.actualizaConsola((<Errores>i).returnError());
        }
        //console.log(i)
        var resultador = i instanceof Instruccion ? i.interpretar(ast, tabla) : new Errores("ERROR SEMANTICO", "no se puede ejecutar la instruccion", 0, 0);
        if (resultador instanceof Errores) {
          listaErrores.push(resultador);
          
          ast.actualizaConsola((<Errores>resultador).returnError());
        }        
      }   
          
      const arbolGrafo = ast.getTree("ast");
      //console.log(arbolGrafo)
      

      toFile(arbolGrafo, './result.png', { format: 'png' });
      
      
      res.json({ consola: ast.getconsola(), grafo: arbolGrafo, errores: listaErrores, simbolos: ast.gettablaGlobal()  , errores_sematicos: ast.getSemanticError() });
    } catch (err) {
        console.log(err)
        res.json({ consola: '', error: err, errores: listaErrores, simbolos: [] });
    }
}
