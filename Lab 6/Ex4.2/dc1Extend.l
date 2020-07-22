%{
#include "y.tab.h"
extern int yylval;
%}

%%

[0-9]+	{
		yylval = atoi(yytext);
		return INTEGER;
	}

[-+/*^()%\n]	return *yytext;

[ \t]+          ;

. fprintf(yyout, "Illegal expression\n");

%%

int yywrap() {
	return 1;
}
