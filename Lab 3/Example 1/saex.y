%{
#include <stdio.h>
#include <stdlib.h>
%}
%token INUM LPAR RPAR MINUS DIV
%%
prog : exp	   {printf("Yacc: OK\n"); } 
  ;
exp : INUM	   {printf("Yacc: INUM\n"); }
  | exp MINUS exp {printf("Yacc: exp MINUS exp\n"); }
  | exp DIV exp   {printf("Yacc: exp DIV exp\n"); }
  | LPAR exp RPAR {printf("Yacc: LPAR exp RPAR\n"); }
  ;
%%
void yyerror(char *msg) {printf("Yacc: %s\n", msg); }
int main() { yyparse(); return 0; }

