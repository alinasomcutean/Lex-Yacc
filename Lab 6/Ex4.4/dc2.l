%{
#include "y.tab.h"
extern int yylval;
int rows = 0;
int columns = 0;
%}

%%

[A-Z]	{
		yylval = *yytext - 'A';
		columns++;
		return VARIABLE;
	}

[a-z]	{
		yylval = *yytext - 'a';
		columns++;
		return VARIABLE;
	}

[0-9]+	{
		yylval = strtol(yytext, (char **)NULL, *yytext=='0' ? 8:10);
		return INTEGER;
	}

0x[0-9a-fA-F]+	{
		yylval = strtol(yytext, (char **)NULL, 16);
		return INTEGER;
	}

[-()=+/*;]	{
			columns++;
			return *yytext;
		}

\n rows++;

[ \t]+	        ;

.		yyerror("Unknown character");
