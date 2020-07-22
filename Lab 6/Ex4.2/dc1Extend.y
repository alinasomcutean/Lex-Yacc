%{
#include <stdio.h>
#include <stdlib.h>

extern FILE *yyin;
extern FILE *yyout;
%}

%token INTEGER
%left '+' '-'
%left '*' '/' '%'
%right '^'

%%

program : program expression '\n'	 { fprintf(yyout, "%d\n", $2); }
        | /* NULL */
	;

expression : INTEGER
           | expression '+' expression	{ $$ = $1 + $3; }
           | expression '-' expression	{ $$ = $1 - $3; }
           | expression '*' expression	{ $$ = $1 * $3; }
           | expression '/' expression	{ $$ = $1 / $3; }
	   | expression '^' expression  { $$ = pow($1, $3); }
	   | expression '%' expression  { $$ = $1 % $3; }
	   | '(' expression ')' { $$ = $2; }
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
