%{
extern int rows;
extern int columns;
%}


%token INTEGER VARIABLE
%left '+' '-'
%left '*' '/'

%{
static int variables[26];
%}

%%

program : program statement ';'
        | program error ';'		{ yyerrok; }
        | /* NULL */
	;

statement : expression 			{ printf("%d\n", $1); }
          | VARIABLE '=' expression	{ variables[$1] = $3; }
          ;

expression : INTEGER
           | VARIABLE			{ $$ = variables[$1]; }
           | expression '+' expression	{ $$ = $1 + $3; }
           | expression '-' expression	{ $$ = $1 - $3; }
           | expression '*' expression	{ $$ = $1 * $3; }
           | expression '/' expression	{ $$ = $1 / $3; }
           | '(' expression ')'		{ $$ = $2; }
           ;

%%

int yyerror(char *msg) {
	printf("KO-%s on row %d and column %d\n",msg, rows, columns+1);
        exit(1); 
}
