%{
#include "y.tab.h"
extern YYSTYPE yylval;
%}


%%

[0-9]+ return NUMBER;
"+" return PLUS;
"-" return MINUS;
"*" return MUL;
"/" return DIV;
"^" return POWER;
"(" return LPAR;
")" return RPAR;

true|false {
	yylval.boolean = yytext;
	return BOOLEAN;
	}

"&&" return AND;
"||" return OR;
not return NOT;

[ \t] ;

\n return '\0';

. fprintf(yyout, "Illegal expression\n");

%%

int yywrap(){
	return 1;
}
