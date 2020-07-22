%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern FILE *yyin;
extern FILE *yyout;

typedef struct _lisp {
	int head;
	struct _lisp *tail;
} lisp_t;

typedef struct _string_lisp {
	char* head;
	struct _string_lisp *tail;
} string_lisp_s;

lisp_t *cons(int, lisp_t *);
lisp_t *concat(lisp_t *, lisp_t *);
lisp_t *cdr(lisp_t *);
int car(lisp_t *);
void print_list(lisp_t *);
void print_l(lisp_t *);

string_lisp_s *cons_str(char*, string_lisp_s *);
string_lisp_s *concat_str(string_lisp_s *, string_lisp_s *);
string_lisp_s *cdr_str(string_lisp_s *);
char* car_str(string_lisp_s *);
void print_list_str(string_lisp_s *);
void print_l_str(string_lisp_s *);
%}

%union{
	int number;
	char* string;
	struct _lisp *list;
	struct _string_lisp *list_str;
}

%token <number> NUMBER
%token <string> STRING
%token CONS CAR CDR APPEND

%type <list> list_form list_command enum
%type <list_str> list_form_str list_command_str enum_str
%type <number> num_form num_command
%type <string> str_form str_command

%%

file : file form '\n'
     | file '\n'
     | /* empty */
     ;

form : num_form { fprintf(yyout, "%d\n", $1);}
     | list_form { print_list($1);}
     | str_form { fprintf(yyout, "%s \n", $1);}
     | list_form_str { print_list_str($1);}
     ;

num_form: '(' num_command ')' { $$ = $2; }
        | NUMBER 
        ;

num_command: CAR list_form { $$=car($2); }
	   | '+' num_form num_form { $$=$2+$3; }
	   ;

list_form: '(' list_command ')' { $$ = $2; }
	 | '\'' '(' enum ')' { $$ = $3; }
	 ;

list_command: CDR list_form { $$=cdr($2); }
	 | CONS num_form list_form { $$=cons($2,$3); }
	 | APPEND list_form list_form { $$=concat($2,$3); }
	 ;

str_form: '(' str_command ')' { $$ = $2; }
	| STRING
	;

str_command: CAR list_form_str { $$=car_str($2); }
	   

list_form_str: '(' list_command_str ')' { $$ = $2; }
	     | '\'' '(' enum_str ')' { $$ = $3; }
	     ;

list_command_str: CDR list_form_str { $$=cdr_str($2); }
		| CONS str_form list_form_str { $$=cons_str($2,$3); }
	 	| APPEND list_form_str list_form_str { $$=concat_str($2,$3); }
	 	;

enum: NUMBER enum { $$=cons($1,$2); }
    | NUMBER { $$=cons($1,NULL); }
    ;

enum_str: STRING enum_str { $$=cons_str($1,$2); }
	| STRING { $$=cons_str($1,NULL); }
	;

%%

lisp_t *cons(int nr, lisp_t *l)
{
	lisp_t *list = (lisp_t *)malloc(sizeof(lisp_t));
	list->head = nr;
	list->tail = l;
	return list;
}

string_lisp_s *cons_str(char* str, string_lisp_s *l)
{
	string_lisp_s *list = (string_lisp_s *)malloc(sizeof(string_lisp_s));
	list->head = str;
	list->tail = l;
	return list;
}

lisp_t *concat(lisp_t *l1, lisp_t *l2)
{
	lisp_t *list;
	for (list=l1; list->tail!=NULL; list=list->tail);
	list->tail = l2;
	return l1;
}

string_lisp_s *concat_str(string_lisp_s *l1, string_lisp_s *l2)
{
	string_lisp_s *list;
	for (list=l1; list->tail!=NULL; list=list->tail);
	list->tail = l2;
	return l1;
}

lisp_t *cdr(lisp_t *l)
{
	return l->tail;
}

string_lisp_s *cdr_str(string_lisp_s *l)
{
	return l->tail;
}

int car(lisp_t *l)
{
	return l->head;
}

char* car_str(string_lisp_s *l) 
{
	return l->head;
}

void print_list(lisp_t *l)
{
	fprintf(yyout, "(");
	print_l(l);
	fprintf(yyout, ")\n");
}

void print_l(lisp_t *l)
{
	if (l!=NULL) {
		if (l->tail != NULL)
			fprintf(yyout, "%d ", l->head);
		else
			fprintf(yyout, "%d", l->head);
		print_l(l->tail);
	}
}

void print_list_str(string_lisp_s *l)
{
	fprintf(yyout, "(");
	print_l_str(l);
	fprintf(yyout, ")\n");
}

void print_l_str(string_lisp_s *l)
{
	if (l!=NULL) {
		if (l->tail != NULL)
			fprintf(yyout, "%s ", l->head);
		else
			fprintf(yyout, "%s", l->head);
		print_l_str(l->tail);
	}
}

int yyerror(char *msg) {
	fprintf(yyout, "KO-%s\n",msg);
        exit(1); 
}

int main(int argc, char *argv[]) {
	FILE *input = fopen(argv[1], "r");
	FILE *output = fopen(argv[2], "w");

	if(!input) return -1;
	else yyin = input;

	if(!output) return -1;
	else yyout = output;

	if(!yyparse()) fprintf(yyout, "OK\n");
        else fprintf(yyout, "KO\n"); 

	return 0; 
}
