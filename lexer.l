%{
#include "parser.tab.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
%}

digit   [0-9]
letter  [a-zA-Z]
id      {letter}({letter}|{digit})*
number  {digit}+(\.{digit}+)?

%%

[ \t\r\n]+      ;

"intg"      { return INTG; }
"longr"     { return LONGR; }
"flt"       { return FLT; }
"dble"      { return DBLE; }

"if"        { return IF; }
"else"      { return ELSE; }
"for"       { return FOR; }
"while"     { return WHILE; }
"do"        { return DO; }
"print"     { return PRINT; }
"return"    { return RETURN; }

"=="        { return EQ; }
"!="        { return NE; }
"<="        { return LE; }
">="        { return GE; }

"&&"        { return AND; }
"||"        { return OR; }
"!"         { return NOT; }

"+="        { return ADDASSIGN; }
"-="        { return SUBASSIGN; }
"*="        { return MULASSIGN; }
"/="        { return DIVASSIGN; }

"++"        { return INC; }
"--"        { return DEC; }

"+"         { return '+'; }
"-"         { return '-'; }
"*"         { return '*'; }
"/"         { return '/'; }
"%"         { return '%'; }

">"         { return '>'; }
"<"         { return '<'; }

"="         { return '='; }

"("         { return '('; }
")"         { return ')'; }
"{"         { return '{'; }
"}"         { return '}'; }
";"         { return ';'; }

{number}    { yylval.fval = atof(yytext); return NUMBER; }
{id}        { strcpy(yylval.sval, yytext); return ID; }

.           { printf("Unknown char: %s\\n", yytext); }

%%

int yywrap(){ return 1; }
