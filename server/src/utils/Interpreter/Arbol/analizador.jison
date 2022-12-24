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
%}
%lex 


%options case-insensitive 
//inicio analisis lexico
%%
"imprimir"      return 'RESPRINT';
"int"           return 'T_INT';
"="             return 'T_IGUAL';
";"             return 'PTCOMA';
"("             return 'PARABRE';
")"             return 'PARCIERRA';


[ \r\t]+ { }
\n {}
\"[^\"]*\"                  { yytext=yytext.substr(1,yyleng-2); return 'CADENA'; }
[0-9]+                      return 'ENTERO';
[A-Za-z]+["_"0-9A-Za-z]*    return 'IDENTIFICADOR';

<<EOF>>                     return 'EOF';
.                           return 'INVALID'

/lex

%left 'MAS' 'MENOS'
%left 'MAYOR_QUE'
%left 'OR'

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

imprimir : RESPRINT PARABRE expresion PARCIERRA PTCOMA{$$=new impresion.default($3,@1.first_line,@1.first_column);}
;

expresion : ENTERO {$$=new nativo.default(new Tipo.default(Tipo.DataType.ENTERO),$1, @1.first_line, @1.first_column)}
          | CADENA {$$=new nativo.default(new Tipo.default(Tipo.DataType.CADENA),$1, @1.first_line, @1.first_column)}
          | IDENTIFICADOR {$$=new nativo.default(new Tipo.default(Tipo.DataType.IDENTIFICADOR), $1, @1.first_line, @1.first_column)}
;

declaracion:
    T_INT IDENTIFICADOR T_IGUAL expresion PTCOMA {
        $$=new declaracion.default($2, new Tipo.default(Tipo.DataType.ENTERO), $4/*.returnInstruction*/, @1.first_line, @1.first_column)
    }
;

