%{
#include <stdio.h>
#include "grammar_fsm.h"

/*
extern int lex_debug;
void dlog(const char *token) {
	if(lex_debug) {
		printf("%s", token);
	}
}
*/
#define dlog(x)

%}

%%
\*                    	dlog("EOB\n"); grammar_fsm_eob();
%						dlog("STATEMENT_MARKER\n"); grammar_fsm_statement();
,                    	dlog("COMMA "); grammar_fsm_comma();

[-+]?[0-9]+(\.[0-9]+)?  dlog("NUMBER "); grammar_fsm_number(atoi(yytext));
([a-zA-Z ;:\.])*   		dlog("LITERAL "); grammar_fsm_text(yytext);

\n                      
[ \t]+

.						{ printf("Incorrect input: %s\n", yytext); }
%%