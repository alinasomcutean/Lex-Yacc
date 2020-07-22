%{
#include "y.tab.h"
extern int yylval;
%}

%%

(hello|salut|hi) {
	fprintf(yyout, "Lex-GREETING: %s\n", yytext);
	return GREETING;
	}

("how are you"|"ce faci"|"are you ok") {
	fprintf(yyout, "Lex-QUESTION: %s\n", yytext);
	return QUESTION;
	}

("fine thank you"|"bine mersi"|"fine thanks") {
	fprintf(yyout, "Lex-ANSWER: %s\n", yytext);
	return ANSWER;
	}

(bye|"la revedere"|goodbye) {
	fprintf(yyout, "Lex-FAREWELL: %s\n", yytext);
	return FAREWELL;
	}

EOF return ENDFILE;

\n return '\n';

[ ] ;

. fprintf(yyout, "Lex-illegal char\n");

%%

int yywrap(){
	return 1;
}
