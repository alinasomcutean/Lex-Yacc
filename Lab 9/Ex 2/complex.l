%{
#include "y.tab.h"
extern YYSTYPE yylval;
%}

%%

[0-9]+  {
	  yylval.number = atoi(yytext);
	  return NUMBER;
        }

j	return *yytext;

[a-z]	{
	  yylval.variable = *yytext - 'a';
	  return VARIABLE;
        } 

[<>\-+*/(),=\n]	return *yytext;

[ \t]+ ;

. fprintf(yyout, "Illegal character");

%%

int yywrap(void)
{
    return 1;
}
