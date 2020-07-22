%{
#include "y.tab.h"
extern YYSTYPE yylval;
%}

%%

[A-Z] 	{
	  yylval.variable = *yytext - 'A';
	  //printf("X");
	  return VARIABLE;
        } 

det	return DET;

[0-9]+  {
	  yylval.number = atoi(yytext);
	  return NUMBER;
        }

[=:;+\-*#\n] {
		//printf("Y");
		return *yytext;
	     }

[ \t]+ ;

. fprintf(yyout, "Illegal character");

%%

int yywrap(void)
{
    return 1;
}
