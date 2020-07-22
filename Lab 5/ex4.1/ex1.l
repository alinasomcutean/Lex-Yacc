%{
#include "y.tab.h"
extern YYSTYPE yylval;
%}

X [a-z]{1,8}
Y [a-z]{0,3}

%%

"#include" return INCLUDE;

\"{X}\.{Y}\" {
	yylval.expr = yytext;
	return LIB;
	}

[ \t] ;

\n return '\0';

. fprintf(yyout, "Illegal expression\n");

%%

int yywrap(){
	return 1;
}
