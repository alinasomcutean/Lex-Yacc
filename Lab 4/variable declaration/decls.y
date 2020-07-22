%{
#include <stdio.h>
#include <stdlib.h>

extern FILE *yyin;
extern FILE *yyout;
%}

%union {
	char* decType;
	char varName;
	char eq;
	char* intValue;
	char* realValue;
	char* character;
	char end;
}


%token <decType> DATATYPE
%token <varName> VARNAME 
%token <eq> EQUAL
%token <intValue> INTVALUE
%token <realValue> REALVALUE
%token <character> CHARACTER
%token <end> FINAL

%%

goal: declaration  {
	fprintf(yyout, "Yacc-goal\n");
	};

declaration: type name equal value final{
	fprintf(yyout, "Yacc - declaration done\n");
	};

type: DATATYPE {
	fprintf(yyout, "Yacc - datatype: %s\n", yylval.decType);
	};

name: VARNAME {
	fprintf(yyout, "Yacc - variable name: %c\n", yylval.varName);
	};

equal: EQUAL {
	fprintf(yyout, "Yacc - equals: %c\n", yylval.eq);
	};

value: INTVALUE {
		fprintf(yyout, "Yacc-integer: %d\n", atoi(yylval.intValue));
		}
      | REALVALUE {
		fprintf(yyout, "Yacc-real: %f\n", atof(yylval.realValue));
		}
      | CHARACTER {
		fprintf(yyout, "Yacc-char: %s\n", yylval.character);
		};

final: FINAL {
	fprintf(yyout, "Yacc-end declaration: %c\n", yylval.end);
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
