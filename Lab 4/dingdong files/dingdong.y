%{
#include <stdio.h>
%}

%union {
char cBuf[20];
}

%start rhyme
%token <cBuf> DING DONG DELL
%type <cBuf> rhyme sound place

%%
rhyme :	sound place	{printf("Rhyme: %s %s\n", $1, $2);}
	;
sound :	DING DONG 	{printf("Sound: %s %s\n", $1, $2);}
	;
place :	DELL 		{printf("Place: %s\n", $1);}
	;
%%

int main() { 
	if (!yyparse()) printf("OK\n");
        else            printf("KO\n");
        return 0; 
}

void yyerror(char *msg) { 
	printf("%s\n", msg); 
}

