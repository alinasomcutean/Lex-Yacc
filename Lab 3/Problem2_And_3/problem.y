%{
#include <stdio.h>
#include <stdlib.h>

extern FILE *yyin;
extern FILE *yyout;
%}

%token GREETING QUESTION ANSWER FAREWELL ENDFILE

%%

goal: dialog 
    | ENDFILE {
	fprintf(yyout, "Yacc-goal\n");
	};

dialog: GREETING QUESTION ANSWER FAREWELL {
	fprintf(yyout, "Yacc-dialog done\n\n");
	}
      | dialog '\n' dialog;


%%

int yyerror(char *msg) {
	fprintf(yyout, "KO-%s\n",msg);
        exit(1); 
}

int main(void) {
	FILE *input = fopen("input.txt", "r");
	FILE *output = fopen("output.txt", "w");

	if(!input) return -1;
	else yyin = input;

	if(!output) return -1;
	else yyout = output;

	if(!yyparse()) fprintf(yyout, "OK\n");
        else fprintf(yyout, "KO\n"); 

	return 0; 
}
