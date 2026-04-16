%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern int yylex();
int yyerror(const char *s);

/* =========================
   SYMBOL TABLE
========================= */
typedef struct {
    char name[50];
    double value;
} Symbol;

Symbol table[200];
int count = 0;

/* =========================
   OUTPUT BUFFER
========================= */
char outputBuffer[1000][100];
int outCount = 0;

double getValue(char *name){
    for(int i=0;i<count;i++)
        if(strcmp(table[i].name,name)==0)
            return table[i].value;
    return 0;
}

void setValue(char *name,double val){
    for(int i=0;i<count;i++){
        if(strcmp(table[i].name,name)==0){
            table[i].value=val;
            return;
        }
    }
    strcpy(table[count].name,name);
    table[count].value=val;
    count++;
}
%}

%union{
    double fval;
    char sval[50];
}

%token INTG LONGR FLT DBLE
%token IF ELSE FOR WHILE DO PRINT RETURN
%token EQ NE LE GE AND OR NOT
%token ADDASSIGN SUBASSIGN MULASSIGN DIVASSIGN INC DEC
%token <fval> NUMBER
%token <sval> ID

%type <fval> E

%left OR
%left AND
%left EQ NE
%left '<' '>' LE GE
%left '+' '-'
%left '*' '/' '%'

%%

program:
    stmt_list RETURN NUMBER ';'
    {
        int i;
        printf("\\n========= FINAL OUTPUT =========\\n");

        for(i=0;i<outCount;i++){
            printf("%s\\n", outputBuffer[i]);
        }

        printf("================================\\n");
        printf("RETURN VALUE = %.0f\\n", $3);
    }
;

stmt_list:
      stmt_list stmt
    | stmt
;

block:
    '{' stmt_list '}'
;

stmt:
      decl ';'
    | assignment ';'
    | PRINT ID ';'
      {
          sprintf(outputBuffer[outCount++], "%s = %.2f", $2, getValue($2));
      }
    | E ';'
      {
          sprintf(outputBuffer[outCount++], "Result = %.2f", $1);
      }
    | if_stmt
    | loop_stmt
;

decl:
      INTG ID '=' E { setValue($2,$4); }
    | INTG ID       { setValue($2,0); }
;

assignment:
      ID '=' E { setValue($1,$3); }
    | ID INC   { setValue($1,getValue($1)+1); }
    | ID DEC   { setValue($1,getValue($1)-1); }
;

if_stmt:
    IF '(' E ')' block
  | IF '(' E ')' block ELSE block
;

loop_stmt:
    WHILE '(' E ')' block
  | DO block WHILE '(' E ')' ';'
  | FOR '(' assignment ';' E ';' assignment ')' block
;

E:
      E '+' E  { $$=$1+$3; }
    | E '-' E  { $$=$1-$3; }
    | E '*' E  { $$=$1*$3; }
    | E '/' E  { $$=($3==0)?0:$1/$3; }
    | E '%' E  { $$=((int)$3==0)?0:((int)$1%(int)$3); }

    | E '>' E  { $$=$1>$3; }
    | E '<' E  { $$=$1<$3; }
    | E GE E   { $$=$1>=$3; }
    | E LE E   { $$=$1<=$3; }
    | E EQ E   { $$=$1==$3; }
    | E NE E   { $$=$1!=$3; }

    | E AND E  { $$=($1!=0)&&($3!=0); }
    | E OR E   { $$=($1!=0)||($3!=0); }
    | NOT E    { $$=($2==0); }

    | '(' E ')' { $$=$2; }
    | NUMBER    { $$=$1; }
    | ID        { $$=getValue($1); }
;

%%

int main(){
    printf("Enter program (must end with return 0;):\\n");
    yyparse();
    return 0;
}

int yyerror(const char *s){
    printf("Syntax Error: %s\\n", s);
    return 0;
}
