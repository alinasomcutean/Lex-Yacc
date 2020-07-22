%{
#include <stdio.h>
#include <stdlib.h>

extern FILE *yyin;
extern FILE *yyout;
%}

%left PLUS MINUS
%left MUL DIV
%right POWER

%token PLUS MINUS MUL DIV POWER LPAR RPAR NUMBER

%%
goal: expr {
	fprintf(yyout, "Yacc - Final Result: %d\n", $1); 
	};

expr: expr PLUS term { 
	$$ = $1 + $3;
	fprintf(yyout, "Yacc - Add %d and %d\n", $1, $3);
	}
    | expr MINUS term {
	$$ = $1 - $3;
	fprintf(yyout, "Yacc - Substract %d from %d\n", $3, $1);
	}
    | term {
	$$ = $1;
	fprintf(yyout, "Yacc - Term: %d\n", $1);
	};

term: term MUL factor {
	$$ = $1 * $3;
	fprintf(yyout, "Yacc - Multiply %d with %d\n", $1, $3);
	}
    | term DIV factor {
	$$ = $1 / $3;
	fprintf(yyout, "Yacc - Divide %d by %d\n", $1, $3);
	}
    | factor {
	$$ = $1;
	fprintf(yyout, "Yacc - Factor: %d\n", $1);
	};

factor: exponent POWER factor {
		$$ = pow($1, $3);
		fprintf(yyout, "Yacc - %d at power %d\n", $1, $3);
		}
      | exponent {
		$$ = $1;
		fprintf(yyout, "Yacc - Exponent: %d\n", $1);
		};

exponent: MINUS exponent {
		$$ = -$2;
		fprintf(yyout, "Yacc - Minus exponent: %d\n", $2);
		}
	| final {
		$$ = $1;
		fprintf(yyout, "Yacc - Final: %d\n", $1);
		};

final: NUMBER {
	$$ = $1;
	fprintf(yyout, "Yacc - Number: %d\n", $1);
	}
     | LPAR expr RPAR {
	$$ = $2;
	fprintf(yyout, "Yacc - ( %d ) \n", $2);
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
