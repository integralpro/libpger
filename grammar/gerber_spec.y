%{
#include <stdio.h>
#include <string.h>

void yyerror(const char *str)
{
    fprintf(stderr, "Error: %s\n", str);
}

int yywrap()
{
    return 1;
}

int main() {
	yyparse();
}

%}

%token NUMBER EOB STATEMENT_MARKER IDENTIFIER COMMA
%token D01 D02 D03 G01 G02 G03 G04 M02 G36 G37 G74 G75 DXX LITERAL
%token X Y I J
%token FS MO IP IN AD

%%
statements:
		statement
		|
		statements statement
		;

statement:
		command EOB
		|
		STATEMENT_MARKER params STATEMENT_MARKER
        ;

params:
		param EOB
		|
		params param EOB
		;

param:
		|
		FS X NUMBER Y NUMBER
		|
		MO
		|
		IP
		|
		IN comment
		|
		AD DXX aperture_type modifiers_set
		;

aperture_type:
		LITERAL COMMA NUMBER
		|
		LITERAL COMMA NUMBER X NUMBER
		;

modifiers_set:
		|
		X NUMBER
		|
		X NUMBER X NUMBER
		;

command:
		|
		G04 comment
		|
		LITERAL NUMBER
		;

comment:
		|
		comment LITERAL
		|
		comment NUMBER
		;

%%
