%{
#include <stdlib.h>
#include "types.h"
#include "y.tab.h"
int rows = 0;
int columns = 0;
%}

%%
 
  /* variables */
[a-z]           {
                   yylval.sIndex = *yytext - 'a';
		   columns++;
                   return VARIABLE;
                }

  /* integers */                 
[0-9]+          {
                   yylval.iValue = atoi(yytext);
		   columns++;
                   return INTEGER;
                }

  /* operators */
[-()<>=+/*;{}.]	{
		   columns++;
		   return *yytext;
		}

">="            {

		   columns+=2;
		   return GE;
		}
"<="            {

		   columns+=2;
		   return LE;
		}
"=="            {

		   columns+=2;
		   return EQ;
		}
"!="            {

		   columns+=2;
		   return NE;
		}
"while"         {
		   columns+=5;
		   return WHILE;
		}
"if"            {

		   columns+=2;
		   return IF;
		}
"else"          {

		   columns+=4;
		   return ELSE;
		}
"print"         {

		   columns+=5;
		   return PRINT;
		}

[ \t]+          columns++;      // Skip whitespaces.

\n		{
		   rows++;
		   columns = 0;
		}

.               {
		   columns++;
		   yyerror("Unknown character.\n");
		}

%%

int yywrap(void)
{
    return 1;
}
