%{
#include "y.tab.h"
extern YYSTYPE yylval;
%}

%%

if return IF;
then return THEN;
else return ELSE;

"(" return LPAR;
")" return RPAR;

true|false {
	yylval.boolean = yytext;
	return BOOLEAN;
	};

"&&" return AND;
"||" return OR;
not return NOT;

[a-z]+ {
	yylval.name = yytext;
	return NAME;
	};

"=" return EQ;

[0-9]+ {
	yylval.value = yytext;
	return VALUE;
	};

[ \t] ;

\n return '\0';

. fprintf(yyout, "Illegal expression\n");

%%

int yywrap(){
	return 1;
}
