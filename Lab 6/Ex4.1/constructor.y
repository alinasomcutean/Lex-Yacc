%{
#include <stdio.h>
#include <stdlib.h>

extern FILE *yyin;
extern FILE *yyout;
%}

%union{
	char* node;
	char* value;
	char* string;
}

%token <node> NODE
%token <value> NUMERIC
%token <string> STRING

%%

constructor : '(' program ')' {fprintf(yyout, "Yacc - correct constructor\n");}
	    ;

program : /* NULL */ { fprintf(yyout, "Yacc - empty\n"); }
	| item { fprintf(yyout, "Yacc - item\n"); }
	| item ',' program { fprintf(yyout, "Yacc - program - item\n"); }
	;

item : node { fprintf(yyout, "Yacc - node\n"); }
	| atomic_value { fprintf(yyout, "Yacc - atomic value\n"); }
	;

node : NODE { fprintf(yyout, "Yacc - node: %s\n", yylval.node); }
	;

atomic_value : NUMERIC { fprintf(yyout, "Yacc - numeric value: %s\n", yylval.value); }
	| STRING { fprintf(yyout, "Yacc - string of characters: %s\n", yylval.string); }
	;

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
