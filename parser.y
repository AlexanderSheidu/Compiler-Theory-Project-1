/* CMSC 430 Compiler Theory and Design
   Project 2 Skeleton
   UMGC CITE
   Summer 2023 

   Project 2 Parser */

%{

#include <string>

using namespace std;

#include "listing.h"

int yylex();
void yyerror(const char* message);

%}

%define parse.error verbose

%token IDENTIFIER INT_LITERAL REAL_LITERAL CHAR_LITERAL HEX_LITERAL

%token ADDOP MULOP ANDOP RELOP ARROW

%token BEGIN_ CASE CHARACTER ELSE END ENDSWITCH FUNCTION INTEGER REAL IS LIST OF OTHERS
	RETURNS SWITCH WHEN

%token IF THEN ELSIF ENDIF FOLD ENDFOLD LEFT RIGHT MODOP EXPOP NEGOP OROP NOTOP

%%

function:	
	function_header variables body ;

function_header:	
	FUNCTION IDENTIFIER parameters RETURNS type ';'  ;

type:
	INTEGER |
	REAL | 
	CHARACTER ;
	
variables: 
	variables variable |
	%empty ;
	    
variable:	
	IDENTIFIER ':' type IS statement ';' |
	IDENTIFIER ':' LIST OF type IS list ';' ;

parameters:
	parameters var |
	parameters ',' var |
	%empty ;
    
var:	
	IDENTIFIER ':' type ;	

direction:
 	LEFT | RIGHT
	
operator:
 	ADDOP | MULOP | MODOP | EXPOP | NEGOP | ANDOP | OROP | NOTOP

list_choice:
 	list |
 	IDENTIFIER	

list:
	'(' expressions ')' ;

expressions:
	expressions ',' expression| 
	expression ;

body:
	BEGIN_ statement_ END ';' ;

statement_:
	statement ';' |
	error ';' ;
    
statement:
	expression |
	WHEN condition ',' expression ':' expression |
	SWITCH expression IS cases OTHERS ARROW statement ';' ENDSWITCH |
	IF condition THEN statement ';' elsifs ELSE statement ';' ENDIF | 
	FOLD direction operator list_choice ENDFOLD ;

cases:
	cases case |
	%empty ;
	
case:
	CASE INT_LITERAL ARROW statement ';' ; |
	CASE REAL_LITERAL ARROW statement ';' ; 

elsifs:
	elsifs elsif |
	%empty ;
	
elsif:
	ELSIF condition THEN INT_LITERAL  ';' ; |
	ELSIF condition THEN CHAR_LITERAL  ';' ; |
	ELSIF condition THEN REAL_LITERAL ';' ; |
	ELSIF condition THEN expression ';' ; 	

condition:
	condition ANDOP NOTOP relation |
	condition ANDOP relation |
	condition OROP relation |
	relation ;

relation:
	'(' condition ')' |
	expression RELOP expression ;

expression:
	expression ADDOP term |
	term ;
      
term:
	NEGOP primary |
	term MODOP primary |
	term MULOP primary |
	term EXPOP primary |
	primary ;

primary:
	'(' expression ')' |
	INT_LITERAL |
	REAL_LITERAL |
	HEX_LITERAL |
	CHAR_LITERAL |
	IDENTIFIER '(' expression ')' |
	IDENTIFIER ;

%%

void yyerror(const char* message) {
	appendError(SYNTAX, message);
}

int main(int argc, char *argv[]) {
	firstLine();
	yyparse();
	lastLine();
	return 0;
} 
