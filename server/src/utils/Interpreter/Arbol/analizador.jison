%{
    //codigo js
    /*const controller = require('../../../controller/parser/parser');
    const errores = require('./Exceptions/Error');
    const nativo = require('./Expresions/Native');
    const aritmetico = require('./Expresions/Aritmetica');
    const relacional = require('./Expresions/Relacional');
    const logica = require('./Expresions/Logica');
    const Tipo = require('./Symbol/Type');
    const impresion = require('./Instructions/Imprimir');   
    const ifIns = require('./Instructions/IfIns');  
    const declaracion = require('./Instructions/Declaracion');
    const mientras = require('./Instructions/Mientras');
    const asignacion = require('./Instructions/Asignacion');
    const { Nodo } = require('./Symbol/Three');*/
    const impresion = require('./Instructions/Imprimir');
    const nativo = require('./Expresions/Native');
    const Tipo = require('./Symbol/Type');
    const controller = require('../../../controller/parser/parser');
    const errores = require('./Exceptions/Error');
    const declaracion = require('./Instructions/Declaracion');
    const aritmetico = require('./Expresions/Aritmetica');
    const relacional = require('./Expresions/Relacional');
    const logica = require('./Expresions/Logica');
%}
%lex 


%options case-insensitive 
//inicio analisis lexico
%%
"imprimir"      return 'RESPRINT';
"int"           return 'T_INT';
"||"            return 'T_OR';

"="             return 'T_IGUAL';
"+"             return 'T_MAS';
";"             return 'PTCOMA';
"("             return 'PARABRE';
")"             return 'PARCIERRA';
">"             return 'T_MAYORQ'


[ \r\t]+ { }
\n {}
\"[^\"]*\"                  { yytext=yytext.substr(1,yyleng-2); return 'CADENA'; }
[0-9]+                      return 'ENTERO';
[A-Za-z]+["_"0-9A-Za-z]*    return 'IDENTIFICADOR';

<<EOF>>                     return 'EOF';
.                           return 'INVALID'

/lex

%left 'T_MAS' 'T_MENOS'
%left 'T_MAYORQ'
%left 'T_OR'

%start INIT
//Inicio
//Definicion de gramatica
%%

INIT: instrucciones EOF     {
        return $1;
    }
;

instrucciones : 
    instrucciones instruccion   {$1.push($2);$$=$1;}
    | instruccion               {$$=[$1];}
;

instruccion : imprimir  {$$=$1;}
            | declaracion {$$=$1;}
            | INVALID               {controller.listaErrores.push(new errores.default('ERROR LEXICO',$1,@1.first_line,@1.first_column));}
            | error  PTCOMA         {controller.listaErrores.push(new errores.default(`ERROR SINTACTICO`,"Se esperaba token",@1.first_line,@1.first_column));}
;

imprimible:
    expresion {$$=$1;}  
    | expresion_logica {$$=$1;}  
;

imprimir : 
    RESPRINT PARABRE imprimible PARCIERRA PTCOMA {$$=new impresion.default($3,@1.first_line,@1.first_column);}
;

expresion : ENTERO {$$=new nativo.default(new Tipo.default(Tipo.DataType.ENTERO),$1, @1.first_line, @1.first_column)}
          | CADENA {$$=new nativo.default(new Tipo.default(Tipo.DataType.CADENA),$1, @1.first_line, @1.first_column)}
          | IDENTIFICADOR {$$=new nativo.default(new Tipo.default(Tipo.DataType.IDENTIFICADOR), $1, @1.first_line, @1.first_column)}
          | expresion T_MAS expresion { $$ = new aritmetico.default(aritmetico.tipoOp.SUMA, $1/*.returnInstruction*/, $3/*.returnInstruction*/, @1.first_line, @1.first_column)}
;

declaracion:
    T_INT IDENTIFICADOR T_IGUAL expresion PTCOMA {
        $$=new declaracion.default($2, new Tipo.default(Tipo.DataType.ENTERO), $4/*.returnInstruction*/, @1.first_line, @1.first_column)
    }
;

expresion_relacional:
        expresion T_MAYORQ expresion {$$ = new relacional.default(relacional.tipoOp.MAYOR, $1, $3, @1.first_line, @1.first_column);}
;

expresion_logica:
    expresion_logica T_OR expresion_relacional {$$ = new logica.default(logica.tipoOp.OR, $1, $3, @1.first_line, @1.first_column);}
    | expresion_relacional                   {$$ = $1;}
;

