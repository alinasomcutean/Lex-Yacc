%{
#include <stdio.h>
#include <stdlib.h>

extern FILE *yyin;
extern FILE *yyout;
%}

%union {
	char* boolean;
}

%token NUMBER PLUS MINUS MUL DIV POWER AND OR NOT LPAR RPAR
%token <boolean> BOOLEAN
%left PLUS MINUS
%left MUL DIV
%left POWER
%left AND OR
%left NOT

%%
program: goal;

goal: /* NULL */
    | expr { fprintf(yyout, "Yacc - goal\n"); }
    | expr ',' goal;

expr: arith_expr {
	fprintf(yyout, "Yacc: arithmetic expression\n");
	}
    | bool_expr {
	fprintf(yyout, "Yacc: boolean expression\n");
	};

bool_expr: bool_expr AND bool_expr {
		fprintf(yyout, "Yacc - && operator \n");
		}
	 | bool_expr OR bool_expr{
		fprintf(yyout, "Yacc - || operator \n");
		}
	 | bool_term {
		fprintf(yyout, "Yacc - Boolean term\n");
		};

bool_term: NOT bool_final {
		fprintf(yyout, "Yacc - not operator \n");
		}
	 | bool_final ;

bool_final: BOOLEAN {
		fprintf(yyout, "Yacc - boolean value\n");
		};

arith_expr: arith_expr PLUS term { 
	fprintf(yyout, "Yacc - Addition\n");
	}
    | arith_expr MINUS term {
	fprintf(yyout, "Yacc - Substraction\n");
	}
    | term ;

term: term MUL factor {
	fprintf(yyout, "Yacc - Multiplication\n");
	}
    | term DIV factor {
	fprintf(yyout, "Yacc - Division\n");
	}
    | factor ;

factor: factor POWER exponent {
		fprintf(yyout, "Yacc - Power\n");
		}
      | exponent ;

exponent: MINUS exponent {
		fprintf(yyout, "Yacc - Minus exponent\n");
		}
	| final ;

final: NUMBER {
	fprintf(yyout, "Yacc - Number\n");
	}
     | LPAR expr RPAR {
	fprintf(yyout, "Yacc - ( ) \n");
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
