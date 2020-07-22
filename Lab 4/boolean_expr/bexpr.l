%{
#include "y.tab.h"
extern YYSTYPE yylval;
%}

%%

[a-zA-Z] {
	yylval.variableName = yytext[0];
	return VARIABLE;
	}

[=] {
	yylval.eq = yytext[0];
	return EQUAL;
	}

true|false {
	yylval.boolean = yytext;
	return BOOLEAN;
	}

"||" return OR;

"&&" return AND;

not return NOT;

[ \t] ;

\n return '\n';

%%

int yywrap(){
	return 1;
}
