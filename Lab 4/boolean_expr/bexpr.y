%{
#include <stdio.h>
#include <stdlib.h>

extern FILE *yyin;
extern FILE *yyout;
%}

%union {
	char variableName;
	char eq;
	char* boolean;
}

%token <variableName> VARIABLE
%token <eq> EQUAL
%token <boolean> BOOLEAN
%token OR AND NOT

%%

goal: expr  {
	fprintf(yyout, "Yacc-goal\n");
	};

expr: name equal boolExpr{
	fprintf(yyout, "Yacc - declaration done\n");
	};

name: VARIABLE {
	fprintf(yyout, "Yacc - variable name: %c\n", yylval.variableName);
	};

equal: EQUAL {
	fprintf(yyout, "Yacc - equals: %c\n", yylval.eq);
	};

boolExpr: BOOLEAN operator BOOLEAN {
		fprintf(yyout, "Yacc - correct expression \n");
		}
	| operator BOOLEAN {
		fprintf(yyout, "Yacc - correct expression \n");
		};

operator: OR {
		fprintf(yyout, "Yacc - || operator: \n");
		}
	| AND {
		fprintf(yyout, "Yacc - && operator: \n");
		}
	| NOT {
		fprintf(yyout, "Yacc - not operator: \n");
		}

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
