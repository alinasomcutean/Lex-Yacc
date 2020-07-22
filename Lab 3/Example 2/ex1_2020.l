%{
#include "y.tab.h"
extern int yylval;
%}
%%
[0-9]+      { yylval=atoi(yytext);
              printf("Lex–INT: %d\n", yylval);
              return INT; }
[a-zA-Z]    { yylval=yytext[0];
              printf("Lex–ID: %c\n", yylval);
              return ID; }
"+"         { printf("Lex–ADD\n"); 
              return *yytext;}
"*"         { printf("Lex–MUL\n"); 
              return *yytext;}
[\n]        return EOL;
[ \t]+      ;
.           printf("Lex - illegal char.\n");
%%
int yywrap() { return 1; }