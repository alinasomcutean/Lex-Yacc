%{
#include <stdio.h>
#include <stdlib.h>

extern FILE *yyin;
extern FILE *yyout;
%}

%union {
	char* expr;
}

%token INCLUDE 
%token <expr> LIB
%%

goal: include {
	fprintf(yyout, "Yacc-goal\n");
	};

include: begin library {
	fprintf(yyout, "Yacc - declaration done\n");
	};	

begin: INCLUDE {
	fprintf(yyout, "Yacc - first part: #include\n");
	};

library: LIB {
	fprintf(yyout, "Yacc - library: %s\n", yylval.expr);
	};

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
