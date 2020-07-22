%{
#include "y.tab.h"
extern YYSTYPE yylval;
%}

D [0-9]

%%

int|float|double|char {
	yylval.decType = yytext;
	return DATATYPE;
	}

[a-zA-Z] {
	yylval.varName = yytext[0];
	return VARNAME;
	}

[=] {
	yylval.eq = yytext[0];
	return EQUAL;
	}

{D}+ {
	yylval.intValue = yytext;
	return INTVALUE;
	}

{D}+"."{D}+ {
	yylval.realValue = yytext;
	return REALVALUE;
	}

'[a-zA-Z]' {
	yylval.character = yytext;
	return CHARACTER;
	}

; {
	yylval.end = yytext[0];
	return FINAL;
	}

[ ] ;

\n return '\n';

%%

int yywrap(){
	return 1;
}
