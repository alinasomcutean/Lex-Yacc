%{
#include "y.tab.h"
extern YYSTYPE yylval;
%}

%%

true {
	yylval = atoi("1");
	return BOOLEAN;
	}
false {
	yylval = atoi("0");
	return BOOLEAN;
	}

"||" return '+';

"&&" return '*';

not return '!';

[ \t]+          ;

\n return '\n';

. fprintf(yyout, "Illegal expression\n");

%%

int yywrap() {
	return 1;
}
