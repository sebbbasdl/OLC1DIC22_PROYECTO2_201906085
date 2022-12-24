import Simbolo from '../../utils/Interpreter/Arbol/Symbol/Symbol';
import { Response, Request } from "express";
import Errores from '../../utils/Interpreter/Arbol/Exceptions/Error';
import Three from "../../utils/Interpreter/Arbol/Symbol/Three";
import SymbolTable from "../../utils/Interpreter/Arbol/Symbol/SymbolTable";
import { Instruccion } from "../../utils/Interpreter/Arbol/Abstract/Instruccion";

export let listaErrores: Array<Errores> = [];
export let listaSimbolos: Array<SymbolTable> = [];



export const parse =( req: Request & unknown, res : Response ):void =>{
    listaErrores = new Array<Errores>();
    listaSimbolos = new Array<SymbolTable>();
    var arrayOfMaps: Map<String, Simbolo>[] = [];
    
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
          
          var resultador =i instanceof Instruccion ?  i.interpretar(ast,tabla): new Errores("Error Semantico","no se puede ejecutar la instruccion",0,0)
          console.log("Instrucciones")
          console.log(i);
          if (resultador instanceof Errores) {
            listaErrores.push(resultador);
            ast.actualizaConsola((<Errores>resultador).returnError());
          }        
        }
        
        console.log("tabla")
        listaSimbolos.push(tabla)
        console.log(listaSimbolos)
        for (const map of arrayOfMaps) {
            for (const key of map.keys()) {
              console.log(key + ': ' + map.get(key));
            }
          }
        
        res.send({ consola: ast.getconsola(), errores: listaErrores, simbolos: listaSimbolos });
      } catch (err) {
          console.log(err)
          res.json({ consola: '', error: err, errores: listaErrores, simbolos: [] });
      }
}