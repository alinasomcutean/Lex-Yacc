%{
#include "y.tab.h"
extern YYSTYPE yylval;
%}

X [a-zA-Z]{1,5}
D [0-9]
E [DEde][-+]?{D}+

%%

{X} {
	yylval.node = yytext;
	return NODE;
    }

{D}+ {
	yylval.value = yytext;
	return NUMERIC;
	}
{D}+"."{D}*({E})? {
	yylval.value = yytext;
	return NUMERIC;
	}
{D}*"."{D}+({E})? {
	yylval.value = yytext;
	return NUMERIC;
	}
{D}+{E}	{
	yylval.value = yytext;
	return NUMERIC;
	}

[a-zA-Z]+ {
	yylval.string = yytext;		
	return STRING;
	}

"," return ',';

"(" return '(';

")" return ')';

[ \t] ;

\n return '\0';

. fprintf(yyout, "Illegal expression\n");

%%

int yywrap() {
	return 1;
}
