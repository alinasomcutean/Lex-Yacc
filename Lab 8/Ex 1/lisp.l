%{
#include "y.tab.h"
extern YYSTYPE yylval;
%}

%%

[0-9]+ {
	  yylval.number = atoi(yytext);
	  return NUMBER;
	}

CONS return CONS;
CAR return CAR;
CDR return CDR;
APPEND return APPEND;

[()+'\n] return *yytext;

[ \t] ;

%%

int yywrap() {
	return 1;
}
