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

[a-zA-Z]+ {
	  yylval.string = yytext;		
	  return STRING;
	}

[()+'\n] return *yytext;

[ \t] ;

.	fprintf(yyout, "Illegal expression\n");

%%

int yywrap() {
	return 1;
}
