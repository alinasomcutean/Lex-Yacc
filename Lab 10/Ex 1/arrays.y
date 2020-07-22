%{
#include <stdio.h>
#include <stdlib.h>

extern FILE *yyin;
extern FILE *yyout;

typedef struct _line{
	int values[10];
	int existingValues;
} line;

typedef struct _matrix{
	line* lines[10];
	int existingLines;
} matrix;

matrix *mat[26];

line* newRow(int);
line* addToRow(line*, int);

matrix* newMatrix(line*);
matrix* addToMatrix(matrix*, line*);

matrix* add(matrix*, matrix*);
matrix* sub(matrix*, matrix*);
matrix* multiply(matrix*, matrix*);

void getCofactor(matrix*, matrix*, int, int, int);
int computeDet(matrix*, int);

matrix* transpose(matrix*);

void print(matrix*);

%}

%union{
	int variable;
	int number;
	struct _line *l;
	struct _matrix *m;
}

%token <number> NUMBER;
%token <variable> VARIABLE;
%token DET;

%type <m> content matrix expression
%type <l> row

%left '+' '-'
%left '*' '#'
%right DET

%%

file : file content '\n'	{ print($2);}
     | file '\n'
     | /*Empty*/
     ;

content : VARIABLE '=' matrix ';'		{ $$ = $3; mat[$1] = $3;}
	| VARIABLE '=' expression ';'		{ $$ = $3; mat[$1] = $3;}
	| VARIABLE '=' expression ':'		{ $$ = $3; mat[$1] = $3;}
	| expression ':'			{ $$ = $1;}
	;

expression : expression '+' expression		{ $$ = add($1, $3);}	
	   | expression '-' expression		{ $$ = sub($1, $3);}	
	   | expression '*' expression		{ $$ = multiply($1, $3);}
	   | DET expression			{ int d = computeDet(mat[$2], 2); 							  fprintf(yyout, "Determinant is %d\n", d);
						}
	   | VARIABLE 				{ $$ = mat[$1];}
	   | VARIABLE '#'			{ $$ = transpose(mat[$1]);}
	   ;

matrix  : matrix '\n' row			{ $$ = addToMatrix($1, $3);}
	| row					{ $$ = newMatrix($1);}
	;

row : row NUMBER				{ $$ = addToRow($1, $2);}
    | NUMBER					{ $$ = newRow($1);}
    ;

%%

line *newRow(int number) {
	//printf("new row\n");
	line *newLine = (line*)malloc(sizeof(line));
	newLine->values[0] = number;
	newLine->existingValues = 1;
	return newLine;
}

line *addToRow(line *row, int number) {
	//printf("add %d ", number);
	int currentNoOfValues = row->existingValues;
	row->values[currentNoOfValues++] = number;
	row->existingValues = currentNoOfValues++;
	return row;
}

matrix* newMatrix(line* row) {
	//printf("new matrix\n");
	matrix *newMatrix = (matrix*)malloc(sizeof(matrix));
	newMatrix->lines[0] = row;
	newMatrix->existingLines = 1;
	return newMatrix;
}

matrix* addToMatrix(matrix* m, line* row) {
	//printf("add line to matrix\n");
	int currentNoOfLines = m->existingLines;
	m->lines[currentNoOfLines++] = row;
	m->existingLines = currentNoOfLines++;
	return m;
}

matrix* add(matrix *x, matrix *y) {
	//printf("in");
	matrix *newMatrix = (matrix*)malloc(sizeof(matrix));
	newMatrix->existingLines = x->existingLines;
	for(int i = 0; i < x->existingLines; i++) {
	   line *newLine = (line*)malloc(sizeof(line));
	   newLine->existingValues = x->lines[i]->existingValues;
	   for(int j = 0; j < newLine->existingValues; j++) {
		newLine->values[j] = x->lines[i]->values[j] + y->lines[i]->values[j];
		//printf("%d ", newLine->values[j]);
	   }
	   newMatrix->lines[i] = newLine;
	}
	return newMatrix;
}

matrix* sub(matrix *x, matrix *y) {
	matrix *newMatrix = (matrix*)malloc(sizeof(matrix));
	newMatrix->existingLines = x->existingLines;
	for(int i = 0; i < x->existingLines; i++) {
	   line *newLine = (line*)malloc(sizeof(line));
	   newLine->existingValues = x->lines[i]->existingValues;
	   for(int j = 0; j < newLine->existingValues; j++) {
		newLine->values[j] = x->lines[i]->values[j] - y->lines[i]->values[j];
	   }
	   newMatrix->lines[i] = newLine;
	}
	return newMatrix;
}

matrix* multiply(matrix *x, matrix *y) {
	matrix *newMatrix = (matrix*)malloc(sizeof(matrix));
	newMatrix->existingLines = x->existingLines;
	for(int i = 0; i < x->existingLines; i++) {
	   line *newLine = (line*)malloc(sizeof(line));
	   newLine->existingValues = x->lines[i]->existingValues;
	   for(int j = 0; j < newLine->existingValues; j++) {
		newLine->values[j] = 0;
		for(int k = 0; k < y->existingLines; k++) {
		   newLine->values[j] += x->lines[i]->values[k] * y->lines[k]->values[j];
		}
	   }
	   newMatrix->lines[i] = newLine;
	}
	return newMatrix;
}

matrix* transpose(matrix *x) {
	//printf("DA");
	matrix *newMatrix = (matrix*)malloc(sizeof(matrix));
	newMatrix->existingLines = x->existingLines;
	for(int i = 0; i < x->existingLines; i++) {
	   line *newLine = (line*)malloc(sizeof(line));
	   newLine->existingValues = x->lines[i]->existingValues;
	   for(int j = 0; j < newLine->existingValues; j++) {
		newLine->values[j] = x->lines[j]->values[i];
	   }
	   newMatrix->lines[i] = newLine;
	}
	return newMatrix;
}

void getCofactor(matrix *mat, matrix *temp, int p, int q, int n) { 
    int i = 0, j = 0; 
    // Looping for each element of the matrix 
    for (int row = 0; row < n; row++) { 
        for (int col = 0; col < n; col++) { 
            //  Copying into temporary matrix only those element 
            //  which are not in given row and column 
            if (row != p && col != q) { 
		temp->lines[i]->values[j++] = mat->lines[row]->values[col];

                // Row is filled, so increase row index and 
                // reset col index 
                if (j == n - 1) { 
                    j = 0; 
                    i++; 
                } 
            } 
        } 
    } 
}

int computeDet(matrix *x, int n) {
	int D = 0;
	if(x->existingLines == 1) {
	   return x->lines[0]->values[0];
	}

	matrix *temp = (matrix*)malloc(sizeof(matrix));
 	int sign = 1;

	for(int i = 0; i < x->lines[0]->existingValues; i++) {
	   getCofactor(x, temp, 0, i, n); 
           D += sign * x->lines[0]->values[i] * computeDet(temp, n - 1); 
           sign = -sign; 
	}
	return D;
}

void print(matrix *m) {
	for(int i = 0; i < m->existingLines; i++) {
	   for(int j = 0; j < m->lines[i]->existingValues; j++) {
	      fprintf(yyout, "%d ", m->lines[i]->values[j]);
	   }
	   fprintf(yyout, "\n");
	}
	fprintf(yyout, "\n");
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
