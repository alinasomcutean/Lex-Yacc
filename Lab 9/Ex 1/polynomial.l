%{
#include "y.tab.h"
extern YYSTYPE yylval;
%}

%%

[xX] return VARIABLE;

[0-9]+ {
	 yylval.number = atoi(yytext);
	 return NUMBER;
       }

[+\-*^()\n] return *yytext;

[ \t]+ ;

. fprintf(yyout, "Illegal character");

%%

int yywrap(void)
{
    return 1;
}
