%{
    const impresion = require('./Instructions/Imprimir');
    const nativo = require('./Expresions/Native');
    const Tipo = require('./Symbol/Type');
    const controller = require('../../../controller/parser/parser');
    const errores = require('./Exceptions/Error');
    const declaracion = require('./Instructions/Declaracion');
    const aritmetico = require('./Expresions/Aritmetica');
    const relacional = require('./Expresions/Relacional');
    const logica = require('./Expresions/Logica');
    const ifIns = require('./Instructions/IfIns'); 
    const mientras = require('./Instructions/Mientras'); 
    const asignacion = require('./Instructions/Asignacion');
    const { Nodo } = require('./Symbol/Three');
    const procedureDec = require('./Instructions/ProcedureDec');
    const procedureExec = require('./Instructions/ProcedureExec');
%}
%lex 


%options case-insensitive 
//inicio analisis lexico
%%
"WriteLine"			return 'RESPRINT';
"while"				return 'T_WHILE'
"for"				return 'T_FOR';
"int"           	return 'T_INT';
"double"           	return 'T_DOUBLE';
"char"           	return 'T_CHAR';
"boolean"           	return 'T_BOOL';
"string"           	return 'T_STRING';
"if"				return 'T_IF';
"do"				return 'T_DO';
"void"				return 'T_VOID'
"break"				return 'T_BREAK'
"return"			return 'T_RETURN'
"continue"			return 'T_CONTINUE'
"main"				return 'T_MAIN'
"else"				return 'T_ELSE'


"+"                 return 'T_MAS';
"-"                 return 'T_MENOS';
"*"                 return 'T_POR';
"/"                 return 'T_DIVIDIDO';
"="                 return 'T_IGUAL';
"<"					return 'T_MENORQ';
">"					return 'T_MAYORQ';
"!"					return 'T_DIFERENTE';

"."					return 'T_PUNTO';
","					return 'T_COMA';
";"             return 'PTCOMA';
"("             return 'PARABRE';
")"             return 'PARCIERRA';
"{"             return 'LLAVIZQ';
"}"             return 'LLAVDER';
"["             return 'CORABRE';
"]"             return 'CORCIERRA';
">"             return 'T_MAYORQ';
":"             return 'T_DOSPT';

"&&"				return 'T_AND';
"||"				return 'T_OR';

"true"				return 'T_TRUE'
"false"				return 'T_FALSE'


[ \r\t]+ { }
\n {}
\"[^\"]*\"                  { yytext=yytext.substr(1,yyleng-2); return 'CADENA'; }

//[0-9]+\b                	return 'ENTERO';
[0-9]+("."[0-9]+)?\b    	return 'ENTERO';

[A-Za-z]+["_"0-9A-Za-z]*    return 'IDENTIFICADOR';
(\'[^\']\')|(\'\'\'\')|("#"{ENTERO}) return 'CHAR';

<<EOF>>                     return 'EOF';
.                           return 'INVALID'

/lex

/*%left 'T_MAS' 'T_MENOS'

%left 'T_OR'*/

%right T_IGUAL
%left T_MAS, T_MENOS
%left T_POR, T_DIVIDIDO
%left PARABRE,PARCIERRA,LLAVIZQ,LLAVDER
%left 'T_MAYORQ'


%start INIT
//Inicio
//Definicion de gramatica
%%

INIT: instrucciones EOF     {
        return {
            returnInstruction: $1.returnInstruction, 
            nodeInstruction: (new Nodo("INIT")).generateProduction([$1.nodeInstruction, 'EOF'])            
        };
    }
;

instrucciones : 
    instrucciones instruccion   {$$={
            returnInstruction: [...$1.returnInstruction, $2.returnInstruction], 
            nodeInstruction: (new Nodo("Instrucciones")).generateProduction([$1.nodeInstruction,  $2.nodeInstruction]) 
            };}
    | instruccion               {$$={
            returnInstruction: [$1.returnInstruction],
            nodeInstruction: (new Nodo("Instrucciones")).generateProduction([$1.nodeInstruction])
            };}
;

instruccion : imprimir  {$$={
            returnInstruction: $1.returnInstruction, 
            nodeInstruction: (new Nodo("INSTRUCCION")).generateProduction([$1.nodeInstruction]) 
            };}
            | declaracion {$$={
            returnInstruction: $1.returnInstruction, 
            nodeInstruction: (new Nodo("INSTRUCCION")).generateProduction([$1.nodeInstruction]) 
            };}
            | ifins {$$={
                returnInstruction: $1.returnInstruction, 
                nodeInstruction: (new Nodo("INSTRUCCION")).generateProduction([$1.nodeInstruction]) 
            };}
            | whileins {$$={
                returnInstruction: $1.returnInstruction, 
                nodeInstruction: (new Nodo("INSTRUCCION")).generateProduction([$1.nodeInstruction]) 
            };}
            | asignacion {$$={
                returnInstruction: $1.returnInstruction, 
                nodeInstruction: (new Nodo("INSTRUCCION")).generateProduction([$1.nodeInstruction]) 
            };}
            |execprocedure PTCOMA {
            $$={
                returnInstruction: $1.returnInstruction, 
                nodeInstruction: (new Nodo("INSTRUCCION")).generateProduction([$1.nodeInstruction]) 
            };
            } 

            | INVALID               {controller.listaErrores.push(new errores.default('ERROR LEXICO',$1,@1.first_line,@1.first_column));}
            | error  PTCOMA         {controller.listaErrores.push(new errores.default(`ERROR SINTACTICO`,"Se esperaba token",@1.first_line,@1.first_column));}
;

imprimible:
    expresion {$$ = {
            returnInstruction: $1.returnInstruction,
            nodeInstruction: (new Nodo('IMPRIMIBLE')).generateProduction([$1.nodeInstruction])
        }}  
    | expresion_logica {$$ = {
            returnInstruction: $1.returnInstruction,
            nodeInstruction: (new Nodo('IMPRIMIBLE')).generateProduction([$1.nodeInstruction])
        }}  
;

imprimir : 
    RESPRINT PARABRE imprimible PARCIERRA PTCOMA {$$= {
            returnInstruction: new impresion.default($3.returnInstruction,@1.first_line,@1.first_column),
            nodeInstruction: (new Nodo('IMPRIMIR')).generateProduction([$1, $2, $3.nodeInstruction, $4])
        }}
;

expresion : ENTERO {$$={
            returnInstruction: new nativo.default(new Tipo.default(Tipo.DataType.ENTERO),$1, @1.first_line, @1.first_column),
            nodeInstruction: (new Nodo('EXPRESION')).generateProduction([$1])
            }}
            | CADENA {$$={
            returnInstruction: new nativo.default(new Tipo.default(Tipo.DataType.CADENA),$1, @1.first_line, @1.first_column),
            nodeInstruction: (new Nodo('EXPRESION')).generateProduction([$1])
            }}
            | IDENTIFICADOR {$$={
            returnInstruction: new nativo.default(new Tipo.default(Tipo.DataType.IDENTIFICADOR), $1, @1.first_line, @1.first_column),
            nodeInstruction: (new Nodo('EXPRESION')).generateProduction([$1])
            }}
            | expresion T_MAS expresion { $$={
            returnInstruction: new aritmetico.default(aritmetico.tipoOp.SUMA, $1.returnInstruction, $3.returnInstruction, @1.first_line, @1.first_column),
            nodeInstruction: (new Nodo('EXPRESION')).generateProduction([$1.nodeInstruction, '+', $3.nodeInstruction])
            }}
            | expresion T_MENOS expresion {$$={
            returnInstruction: new aritmetico.default(aritmetico.tipoOp.RESTA, $1.returnInstruction, $3.returnInstruction, @1.first_line, @1.first_column),
            nodeInstruction: (new Nodo('EXPRESION')).generateProduction([$1.nodeInstruction, '-', $3.nodeInstruction])
            }} 
            | expresion T_POR expresion {$$={
            returnInstruction: new aritmetico.default(aritmetico.tipoOp.MULTIPLICACION, $1.returnInstruction, $3.returnInstruction, @1.first_line, @1.first_column),
            nodeInstruction: (new Nodo('EXPRESION')).generateProduction([$1.nodeInstruction, '*', $3.nodeInstruction])
            }} 
            | expresion T_DIVIDIDO expresion {$$={
            returnInstruction: new aritmetico.default(aritmetico.tipoOp.DIVISION, $1.returnInstruction, $3.returnInstruction, @1.first_line, @1.first_column),
            nodeInstruction: (new Nodo('EXPRESION')).generateProduction([$1.nodeInstruction, '/', $3.nodeInstruction])
            }}
            
            | PARABRE expresion PARCIERRA {$$={
            returnInstruction: $2.returnInstruction,
            nodeInstruction: (new Nodo('EXPRESION')).generateProduction([$1.nodeInstruction, $2.nodeInstruction, $3.nodeInstruction])
            }}
            
            | T_TRUE {$$={
            returnInstruction: new nativo.default(new Tipo.default(Tipo.DataType.BOOLEAN),$1, @1.first_line, @1.first_column),
            nodeInstruction: (new Nodo('EXPRESION')).generateProduction([$1])
            }}
            | T_FALSE {$$={
            returnInstruction: new nativo.default(new Tipo.default(Tipo.DataType.BOOLEAN),$1, @1.first_line, @1.first_column),
            nodeInstruction: (new Nodo('EXPRESION')).generateProduction([$1])
            }}
            | CHAR {$$={
            returnInstruction: new nativo.default(new Tipo.default(Tipo.DataType.CHAR),$1, @1.first_line, @1.first_column),
            nodeInstruction: (new Nodo('EXPRESION')).generateProduction([$1])
            }}
          


;


asignacion :
    IDENTIFICADOR T_IGUAL expresion PTCOMA 
                            {
                                $$ = {
                                    returnInstruction: new asignacion.default($1, $3.returnInstruction,@1.first_line,@1.first_column),
                                    nodeInstruction: (new Nodo("ASIGNACION")).generateProduction([$1, $2, $3.nodeInstruction])
                                }
                            }
;

datatypes:
    T_INT {
        $$={
            returnInstruction: new Tipo.default(Tipo.DataType.ENTERO),
            nodeInstruction: (new Nodo('DATATYPES')).generateProduction([$1])
        }
    }
    |T_STRING{
        $$={
            returnInstruction: new Tipo.default(Tipo.DataType.CADENA),
            nodeInstruction: (new Nodo('DATATYPES')).generateProduction([$1])
        }
    }
    |T_BOOL{
        $$={
            returnInstruction: new Tipo.default(Tipo.DataType.BOOLEAN),
            nodeInstruction: (new Nodo('DATATYPES')).generateProduction([$1])
        }
    }
    |T_CHAR{
        $$={
            returnInstruction: new Tipo.default(Tipo.DataType.CHAR),
            nodeInstruction: (new Nodo('DATATYPES')).generateProduction([$1])
        }
    }
    |T_DOUBLE{
        $$={
            returnInstruction: new Tipo.default(Tipo.DataType.DECIMAL),
            nodeInstruction: (new Nodo('DATATYPES')).generateProduction([$1])
        }
    }  

;

proceduredatatypes:
    datatypes {
        $$={
            returnInstruction: $1.returnInstruction,
            nodeInstruction: (new Nodo('PROCEDURESDATATYPES')).generateProduction([$1.nodeInstruction])
        }
    }    
    | T_VOID {
        $$ = {
            returnInstruction: new Tipo.default(Tipo.DataType.VOID),
            nodeInstruction: (new Nodo('PROCEDURESDATATYPES')).generateProduction([$1])
        }
    }
;

execprocedure:
    IDENTIFICADOR CORABRE execparams CORCIERRA {
        $$={
            returnInstruction: new procedureExec.default($1, $3.returnInstruction, @1.first_line, @1.first_column), 
            nodeInstruction: (new Nodo('EXECPROCEDURE')).generateProduction([$1, $2, $3.nodeInstruction, $4])
        }
    }
;

execparams:
    execparams T_COMA imprimible {
        $1.returnInstruction.push($3.returnInstruction); 
        $$={
            returnInstruction: $1.returnInstruction,
            nodeInstruction: (new Nodo('EXECPARAMS')).generateProduction([$1.nodeInstruction, $2, $3.nodeInstruction])
        }
    }
    | imprimible {
        $$={
            returnInstruction: [$1.returnInstruction],
            nodeInstruction: (new Nodo('EXECPARAMS')).generateProduction([$1.nodeInstruction])
        }
    }
    | {
        $$={
            returnInstruction: [],
            nodeInstruction: (new Nodo('EXECPARAMS')).generateProduction(["VACIO"])
        }
    }
;

declaracion:
    datatypes IDENTIFICADOR T_IGUAL expresion PTCOMA { 
    if($1.returnInstruction.tipo==0){
        $$={
            returnInstruction: new declaracion.default($2, new Tipo.default(Tipo.DataType.ENTERO), $4.returnInstruction, @1.first_line, @1.first_column), 
            nodeInstruction: (new Nodo('Declaracion')).generateProduction(['entero', $2, '=', $4.nodeInstruction, ';'])
        }
    }else if($1.returnInstruction.tipo==1){
        $$={
            returnInstruction: new declaracion.default($2, new Tipo.default(Tipo.DataType.CADENA), $4.returnInstruction, @1.first_line, @1.first_column), 
            nodeInstruction: (new Nodo('Declaracion')).generateProduction(['string', $2, '=', $4.nodeInstruction, ';'])
        }
    }else if($1.returnInstruction.tipo==2){
        $$={
            returnInstruction: new declaracion.default($2, new Tipo.default(Tipo.DataType.BOOLEAN), $4.returnInstruction, @1.first_line, @1.first_column), 
            nodeInstruction: (new Nodo('Declaracion')).generateProduction(['boolean', $2, '=', $4.nodeInstruction, ';'])
        }
    }else if($1.returnInstruction.tipo==3){
        $$={
            returnInstruction: new declaracion.default($2, new Tipo.default(Tipo.DataType.CHAR), $4.returnInstruction, @1.first_line, @1.first_column), 
            nodeInstruction: (new Nodo('Declaracion')).generateProduction(['char', $2, '=', $4.nodeInstruction, ';'])
        }
    }else if($1.returnInstruction.tipo==4){
        $$={
            returnInstruction: new declaracion.default($2, new Tipo.default(Tipo.DataType.ENTERO), $4.returnInstruction, @1.first_line, @1.first_column), 
            nodeInstruction: (new Nodo('Declaracion')).generateProduction(['double', $2, '=', $4.nodeInstruction, ';'])
        }
    }

        
    }

    | IDENTIFICADOR PARABRE declarationsparams PARCIERRA T_DOSPT proceduredatatypes LLAVIZQ instrucciones LLAVDER {
        $$={
            returnInstruction: new procedureDec.default($1, $6.returnInstruction, $8.returnInstruction, $3.returnInstruction, @1.first_line, @1.first_column), 
            nodeInstruction: (new Nodo('Declaracion')).generateProduction([$1, $2, $3.nodeInstruction, $4, $5, $6.nodeInstruction, $7, $8.nodeInstruction, $9])
        }
    }
;

declarationsparams:
    declarationsparams T_COMA declarationsparam {
        $1.returnInstruction.push($3.returnInstruction); 
        $$={
            returnInstruction: $1.returnInstruction,
            nodeInstruction: (new Nodo('DECLARATIONPARAMS')).generateProduction([$1.nodeInstruction, $2, $3.nodeInstruction])
        }
    }
    | declarationsparam {
        $$={
            returnInstruction: [$1.returnInstruction],
            nodeInstruction: (new Nodo('DECLARATIONPARAMS')).generateProduction([$1.nodeInstruction])
        }
    }
    | {
        $$={
            returnInstruction: [],
            nodeInstruction: (new Nodo('DECLARATIONPARAMS')).generateProduction(["VACIO"])
        }
    }
;

declarationsparam:
    datatypes IDENTIFICADOR {
        $$={
            returnInstruction: { id: $2, type: $1.returnInstruction },
            nodeInstruction: (new Nodo('DECLARATIONPARAMS')).generateProduction([$1.nodeInstruction, $2])
        }
    }
;

ifins:
     simpleif                {$$ = {
            returnInstruction: $1.returnInstruction,
            nodeInstruction: (new Nodo('IFINS')).generateProduction([$1.nodeInstruction])
            }}                            
    | T_IF PARABRE expresion_logica PARCIERRA LLAVIZQ instrucciones LLAVDER elseifins T_ELSE LLAVIZQ instrucciones LLAVDER 
                            {$$={
            returnInstruction: new ifIns.default($3.returnInstruction,$6.returnInstruction,$8.returnInstruction,$11.returnInstruction,@1.first_line,@1.first_column),
            nodeInstruction: (new Nodo('IFINS')).generateProduction([$1, $2, $3.nodeInstruction, $4, $5, $6.nodeInstruction, $7, $8.nodeInstruction, $9, $10, $11.nodeInstruction,$12])
            };} 
    | T_IF PARABRE expresion_logica PARCIERRA LLAVIZQ instrucciones LLAVDER T_ELSE LLAVIZQ instrucciones LLAVDER {$$={
            returnInstruction: new ifIns.default($3.returnInstruction,$6.returnInstruction,undefined,$10.returnInstruction,@1.first_line,@1.first_column),
            nodeInstruction: (new Nodo('IFINS')).generateProduction([$1, $2, $3.nodeInstruction, $4, $5, $6.nodeInstruction, $7,$8, $9, $10.nodeInstruction, $11])
            };} 
    | T_IF PARABRE expresion_logica PARCIERRA LLAVIZQ instrucciones LLAVDER elseifins {$$={
            returnInstruction: new ifIns.default($3.returnInstruction,$6.returnInstruction,$8.returnInstruction,undefined,@1.first_line,@1.first_column),
            nodeInstruction: (new Nodo('IFINS')).generateProduction([$1, $2, $3.nodeInstruction, $4, $5, $6.nodeInstruction, $7, $8.nodeInstruction])
            };} 

;

simpleif :
     T_IF PARABRE expresion_logica PARCIERRA LLAVIZQ instrucciones LLAVDER{$$={
            returnInstruction: new ifIns.default($3.returnInstruction,$6.returnInstruction, undefined, undefined, @1.first_line, @1.first_column),
            nodeInstruction: (new Nodo('SIMPLEIF')).generateProduction([$1, $2, $3.nodeInstruction, $4, $5, $6.nodeInstruction, $7])
        }} 
;

elseifins :
    elseifins T_ELSE simpleif 
                                                {
                                                    $1.returnInstruction.push($3.returnInstruction); 
                                                    $$={
                                                        returnInstruction: $1.returnInstruction,
                                                        nodeInstruction: (new Nodo('ELSEIFSINS')).generateProduction([$1.nodeInstruction, $2, $3.nodeInstruction])
                                                    }
                                                }
  | T_ELSE simpleif  
                                                {
                                                    $$={
                                                        returnInstruction: [$2.returnInstruction],
                                                        nodeInstruction: (new Nodo('ELSEIFSINS')).generateProduction([$1, $2.nodeInstruction])
                                                    }
                                                }
;


whileins:
    T_WHILE PARABRE expresion_logica PARCIERRA LLAVIZQ instrucciones LLAVDER
                            {$$ = {
            returnInstruction: new mientras.default($3.returnInstruction,$6.returnInstruction,@1.first_line,@1.first_column),
            nodeInstruction: (new Nodo("WHILEINS")).generateProduction([$1, $2, $3.nodeInstruction, $4, $5, $6.nodeInstruction, $7])
            }}
;

expresion_relacional:
        expresion T_MAYORQ expresion {$$ = {
            returnInstruction: new relacional.default(relacional.tipoOp.MAYOR, $1.returnInstruction, $3.returnInstruction, @1.first_line, @1.first_column),
            nodeInstruction: (new Nodo('EXPRESION_RELACIONAL')).generateProduction([$1.nodeInstruction, $2, $3.nodeInstruction])
            }}
        |expresion T_MAYORQ T_IGUAL expresion {$$ = {
            returnInstruction: new relacional.default(relacional.tipoOp.MAYOR_IGUAL, $1.returnInstruction, $4.returnInstruction, @1.first_line, @1.first_column),
            nodeInstruction: (new Nodo('EXPRESION_RELACIONAL')).generateProduction([$1.nodeInstruction, $2+$3, $4.nodeInstruction])
            }}
        |expresion T_MENORQ T_IGUAL expresion {$$ = {
            returnInstruction: new relacional.default(relacional.tipoOp.MENOR_IGUAL, $1.returnInstruction, $4.returnInstruction, @1.first_line, @1.first_column),
            nodeInstruction: (new Nodo('EXPRESION_RELACIONAL')).generateProduction([$1.nodeInstruction, $2+$3, $4.nodeInstruction])
            }}
        |expresion T_MENORQ expresion {$$ = {
            returnInstruction: new relacional.default(relacional.tipoOp.MENOR, $1.returnInstruction, $3.returnInstruction, @1.first_line, @1.first_column),
            nodeInstruction: (new Nodo('EXPRESION_RELACIONAL')).generateProduction([$1.nodeInstruction, $2, $3.nodeInstruction])
            }}
        |expresion T_IGUAL T_IGUAL expresion {$$ = {
            returnInstruction: new relacional.default(relacional.tipoOp.IGUAL_IGUAL, $1.returnInstruction, $4.returnInstruction, @1.first_line, @1.first_column),
            nodeInstruction: (new Nodo('EXPRESION_RELACIONAL')).generateProduction([$1.nodeInstruction, $2+$3, $4.nodeInstruction])
            }}
        |expresion T_DIFERENTE T_IGUAL expresion {$$ = {
            returnInstruction: new relacional.default(relacional.tipoOp.DIFERENTE_IGUAL, $1.returnInstruction, $4.returnInstruction, @1.first_line, @1.first_column),
            nodeInstruction: (new Nodo('EXPRESION_RELACIONAL')).generateProduction([$1.nodeInstruction, $2+$3, $4.nodeInstruction])
            }}
;

expresion_logica:
    expresion_logica T_OR expresion_relacional {$$ = {
            returnInstruction: new logica.default(logica.tipoOp.OR, $1.returnInstruction, $3.returnInstruction, @1.first_line, @1.first_column),
            nodeInstruction: (new Nodo('EXPRESION_LOGICA')).generateProduction([$1.nodeInstruction, $2, $3.nodeInstruction])
        }}
    |expresion_logica T_AND expresion_relacional {$$ = {
            returnInstruction: new logica.default(logica.tipoOp.AND, $1.returnInstruction, $3.returnInstruction, @1.first_line, @1.first_column),
            nodeInstruction: (new Nodo('EXPRESION_LOGICA')).generateProduction([$1.nodeInstruction, $2, $3.nodeInstruction])
        }}
    | expresion_relacional                   { $$ = {
            returnInstruction: $1.returnInstruction,
            nodeInstruction: (new Nodo('EXPRESION_RELACIONAL')).generateProduction([$1.nodeInstruction])
        }}
;



