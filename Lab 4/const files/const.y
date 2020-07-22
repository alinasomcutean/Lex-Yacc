%{
#include <stdio.h>
%}

%union {
	int ival;
	double rval;
}

%token <ival> INT
%token <rval> REAL

%%
start : const '\n'	{ printf("Yacc: start-const\n"); }
	;
const : INT		{ printf("Yacc: const-int:  %d\n", $<ival>$); }
	| REAL		{ printf("Yacc: const-real: %g\n", $<rval>$); } 
	;
%%

void yyerror(char *s) { 
	printf("%s\n", s); 
}

int main(void) { 
	if (!yyparse()) { 
		printf("OK\n"); 
		return 0; 
	} 
    	else { 
		printf("KO\n"); 
		return 1; 
	} 
}

