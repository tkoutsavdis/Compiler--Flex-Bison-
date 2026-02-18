%{
#include <stdio.h>
#include <string.h>
#include <math.h>
#include "cgen.h"
#include "myanalyzer.tab.h"

int line_num = 1;

%}

ID	 		[a-zA-Z_][0-9a-zA-Z_]*
DIGIT  			[0-9]
NUM  			{DIGIT}{DIGIT}*
DECIMAL 		("."({NUM})+)|({NUM}("."({NUM})*)?)
ARITHMETIC_CONSTANT 	{NUM}|{DECIMAL}([eE][+-]?{NUM})?
STRING  		(["][^\n]*["])|(['][^\n]*['])

%%

integer		{return	KW_INTEGER;}
scalar		{return	KW_SCALAR;}
str		{return KW_STR;}
boolean		{return KW_BOOLEAN;}
true		{return KW_TRUE;}
false		{return KW_FALSE;}
const		{return KW_CONST;}
if		{return KW_IF;}
else		{return KW_ELSE;}
endif		{return KW_ENDIF;}
for		{return KW_FOR;}
in		{return KW_IN;}
endfor		{return KW_ENDFOR;}
while		{return KW_WHILE;}
endwhile	{return KW_ENDWHILE;}
break		{return KW_BREAK;}
continue	{return KW_CONTINUE;}
not		{return KW_NOT;}
and		{return KW_AND;}
or		{return KW_OR;}
def		{return KW_DEF;}
enddef		{return KW_ENDDEF;}
main		{return KW_MAIN;}
return		{return KW_RETURN;}
comp		{return KW_COMP;}
endcomp		{return KW_ENDCOMP;}
of		{return KW_OF;}

readStr		{return TK_READSTR;}
readInteger	{return TK_READINTEGER;}
readScalar	{return TK_READSCALAR;}
writeStr	{return TK_WRITESTR;}
writeInteger	{return TK_WRITEINTEGER;}
writeScalar	{return TK_WRITESCALAR;}
write		{return TK_WRITE;}

"+"		{return'+';}					
"-"		{return'-';}		
"*"		{return'*';}
"/"		{return'/';}
"%"		{return '%';}
"**"		{return TK_POWER;}

"=="		{return TK_EQUAL;}
"!="		{return TK_NOT_EQUAL;}
"<"		{return '<';}
"<="		{return TK_LESS_EQUAL;}
">"		{return '>';}
">="		{return TK_GREATER_EQUAL;}

"="		{return '=';}
"+="		{return TK_PLUS_EQUAL;}  
"-="		{return TK_MINUS_EQUAL;}  
"*="		{return TK_MUL_EQUAL;}  
"/="		{return TK_DIV_EQUAL;}  
"%="		{return TK_MOD_EQUAL;}
":="		{return TK_ASSIGN_ARRAY;}

";"		{return ';';}		
"("		{return '(';}		
")"		{return ')';}		
","            	{return ',';}
"["		{return '[';}		
"]"		{return ']';}		
"{"		{return '{';}		
"}"		{return '}';}		
":"		{return ':';}       
"#"		{return '#';}
"."		{return '.';}

{NUM}			{yylval.str = strdup(yytext);
				return TK_POSINT;}

{STRING} 		{yylval.str = strdup(yytext);
				return TK_STRING;}

{ID} 			{yylval.str = strdup(yytext);
				return TK_ID;}

{ARITHMETIC_CONSTANT}	{yylval.str = strdup(yytext);
				return TK_REAL;}


"--"[^\n]*  	/* eat line comments */
[ \r\t]+		/* skip whitespace */
\n 		++line_num;
<<EOF>> 	return EOF;

.             	{yyerror("lexical error: unrecognized literal '%s'\n", yytext); }

%%
