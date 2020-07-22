%{
#include <stdio.h>
#include <stdlib.h>
#include "y.tab.h"
%}
%%
"-"		return MINUS;
"/"		return DIV;
"("		return LPAR;
")"		return RPAR;
[0-9]+		return INUM;
[ \t]		;
\n		return '\0';
.	   printf("Lex: illegal char.\n");
%%
int yywrap() { return 1; }

