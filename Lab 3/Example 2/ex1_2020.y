%{
#include <stdio.h>
#include <stdlib.h>
%}
%token INT ID EOL
%%
goal : sums EOL             { printf("Yacc - goal\n");}
    ;
sums : sums '+' prods       { printf("Yacc-sums+prods\n");}
    | prods                 { printf("Yacc-sums prods\n");}
    ;
prods : prods '*' value     { printf("Yacc-prods * value\n");}
    | value                 { printf("Yacc-prods value\n");}
    ;
value : INT                 { printf("Yacc - value INT: %d\n", $1);}
    | ID                    { printf("Yacc-value ID: %c\n", $1);} 
    ;
%%
int yyerror(char *msg) {printf("KO-%s\n",msg);
                        exit(1); }
int main(void) {if(!yyparse()) printf("OK\n");
                else printf("KO\n"); return 0; }