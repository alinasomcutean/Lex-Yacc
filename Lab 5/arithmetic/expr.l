%{
#include "y.tab.h"
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

[ \t] ;

\n return '\0';

. fprintf(yyout, "Illegal expression\n");

%%

int yywrap() {
	return 1;
}
