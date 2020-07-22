%{
#include "y.tab.h"
extern YYSTYPE yylval;
%}

%%
"ding"	|
"DING"	{ strcpy(yylval.cBuf, yytext); return DING; }
"dong"	|
"DONG"	{ strcpy(yylval.cBuf, yytext); return DONG; }
"dell"	|
"DELL"	{ strcpy(yylval.cBuf, yytext); return DELL; }
[ \t]	;
[\n]	return '\0';
.		printf("Lex-Illegal character: %c\n", yytext[0]);
%%

int yywrap() { 
	return 1; 
}

