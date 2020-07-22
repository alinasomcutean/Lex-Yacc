%{
#include <stdio.h>
#include <stdlib.h>

extern FILE *yyin;
extern FILE *yyout;
%}

%left '+'
%left '*'
%right '!'

%token BOOLEAN

%%

program : program expression '\n' { if($2 >= 1) fprintf(yyout, "true\n"); 
				    else fprintf(yyout, "false\n"); }
	| /* NULL */
	;

expression : BOOLEAN 
           | expression '+' expression	{ $$ = $1 + $3; }
           | expression '*' expression	{ $$ = $1 * $3; }
           | '!' expression	{ if($2 >= 1) $$ = 0; else $$ = 1; }
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
