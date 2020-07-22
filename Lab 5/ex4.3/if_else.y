%{
#include <stdio.h>
#include <stdlib.h>

extern FILE *yyin;
extern FILE *yyout;
%}

%union {
	char* boolean;
	char* name;
	char* value;
}

%token IF THEN ELSE LPAR RPAR EQ NOT AND OR DUMMY
%token <boolean> BOOLEAN
%token <name> NAME
%token <value> VALUE
%left AND OR
%left NOT
%nonassoc DUMMY

%%

goal: ifelse {
	fprintf(yyout, "Yacc - goal\n");
	};

ifelse: IF LPAR bool_expr RPAR THEN body %prec DUMMY {
	  fprintf(yyout, "Yacc - simple if\n");
	  }
      | IF LPAR bool_expr RPAR THEN body ELSE body {
	  fprintf(yyout, "Yacc - if else\n");
	  };

bool_expr: bool_expr AND bool_expr 
	 | bool_expr OR bool_expr
	 | bool_term ;

bool_term: NOT bool_final 
	 | bool_final ;

bool_final: BOOLEAN ;

body: NAME EQ VALUE;

%%

int yyerror(char *msg) {
	fprintf(yyout, "KO-%s\n",msg);
        exit(1); 
}

int main(int argc, char *argv[]) {
	FILE *input = fopen(argv[1], "r");
	FILE *output = fopen(argv[2], "w");

	if(!input) return -1;
	else yyin = input;

	if(!output) return -1;
	else yyout = output;

	if(!yyparse()) fprintf(yyout, "OK\n");
        else fprintf(yyout, "KO\n"); 

	return 0; 
}
