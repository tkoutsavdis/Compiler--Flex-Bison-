%{
	#include <stdlib.h>
  	#include <stdio.h>
  	#include <string.h>
  	#include <math.h>		
  	#include "cgen.h"
	#include "kappalib.h"
  	extern int yylex(void);
  	extern int line_num;
%}


%union {
	char* str;
}

%token KW_INTEGER
%token KW_SCALAR 
%token KW_STR
%token KW_BOOLEAN
%token KW_TRUE
%token KW_FALSE
%token KW_CONST
%token KW_IF
%token KW_ELSE
%token KW_ENDIF
%token KW_FOR
%token KW_IN
%token KW_ENDFOR
%token KW_WHILE
%token KW_ENDWHILE
%token KW_BREAK
%token KW_CONTINUE
%token KW_DEF
%token KW_ENDDEF
%token KW_MAIN
%token KW_RETURN
%token KW_COMP
%token KW_ENDCOMP
%token KW_OF

%token TK_READSTR
%token TK_READINTEGER
%token TK_READSCALAR
%token TK_WRITESTR
%token TK_WRITEINTEGER
%token TK_WRITESCALAR
%token TK_WRITE

%token <str> TK_POSINT
%token <str> TK_STRING
%token <str> TK_ID
%token <str> TK_REAL

%right '=' TK_PLUS_EQUAL TK_MINUS_EQUAL TK_MUL_EQUAL TK_DIV_EQUAL TK_MOD_EQUAL TK_ASSIGN_ARRAY
%left KW_OR
%left KW_AND
%right KW_NOT
%left TK_EQUAL TK_NOT_EQUAL 
%left TK_LESS_EQUAL TK_GREATER_EQUAL '<' '>'
%left OPER_PLUS OPER_MINUS
%left '+' '-'
%left '*' '/' '%'
%right SIGN_PLUS SIGN_MINUS
%right TK_POWER
%left '.' '(' ')' '[' ']'

/************************************************************************************************************************/
%type <str> program
%type <str> main_function
%type <str> body_function

%type <str> functions
%type <str> func_decl
%type <str> functions_param
%type <str> choose_functions_param
%type <str> function_return_type

%type <str> const_decl
%type <str> const_declaration


%type <str> variable_declarations
%type <str> var_decl_1

%type <str> commands
%type <str> if_command
%type <str> else_command
%type <str> for_command
%type <str> for_expr
%type <str> for_step
%type <str> while_command
%type <str> array_command
%type <str> array_with_array_command
%type <str> expr_array
%type <str> assign_comand
%type <str> break_command
%type <str> continue_command
%type <str> return_command
%type <str> function_call_command
%type <str> function_call_param
%type <str> commitedFunctions

%type <str> comp
%type <str> comp_declaration
%type <str> body_comp
%type <str> comp_variables
%type <str> comp_variables1


%type <str> expr

%type <str> data_types

%start input

%%

/*============================================= Main Program ===================================================*/
/* Initialization and library inclusion of the Programm*/
input:
%empty
| program 
{
  if (yyerror_count == 0)
  {	printf("#include <stdio.h>\n#include <stdlib.h>\n#include <string.h>\n#include <math.h>\n#include \"kappalib.h\"\n\n");
    	printf("\n%s\n\n", $1);
  }
};

//ALL POSIBLE COMBINATIONS OF KAPPA PROGRAM
program:
const_decl variable_declarations comp functions main_function			{$$ = template("%s\n%s\n%s\n%s\n%s",$1, $2,$3,$4,$5);}
|const_decl variable_declarations comp main_function				{$$ = template("%s\n%s\n%s\n%s",$1, $2,$3,$4);}
|const_decl variable_declarations functions main_function			{$$ = template("%s\n%s\n%s\n%s",$1, $2,$3,$4);}
|const_decl comp functions main_function					{$$ = template("%s\n%s\n%s\n%s",$1, $2,$3,$4);}
|variable_declarations comp functions main_function				{$$ = template("%s\n%s\n%s\n%s",$1, $2,$3,$4);}
|const_decl variable_declarations main_function					{$$ = template("%s\n%s\n%s",$1, $2,$3);}
|const_decl comp main_function 							{$$ = template("%s\n%s\n%s",$1, $2,$3);}
|const_decl functions main_function						{$$ = template("%s\n%s\n%s",$1, $2,$3);}
|variable_declarations comp main_function					{$$ = template("%s\n%s\n%s",$1, $2,$3);}
|variable_declarations functions main_function					{$$ = template("%s\n%s\n%s",$1, $2,$3);}
|comp functions main_function							{$$ = template("%s\n%s\n%s",$1, $2,$3);}
|const_decl main_function							{$$ = template("%s\n%s",$1, $2);}
|variable_declarations main_function						{$$ = template("%s\n%s",$1, $2);}
|comp main_function								{$$ = template("%s\n%s",$1, $2);}
|functions main_function							{$$ = template("%s\n%s",$1, $2);}
|main_function									{$$ = $1;}
;

/**************************************** MAIN FUNCTION**************************************** */
main_function:
KW_DEF KW_MAIN '(' ')' ':' body_function KW_ENDDEF ';'	{$$ = template("int main()\n{\n%s\n}\n", $6);}
;

/****************************************FUNCTIONS**************************************** */
functions:
func_decl            	{$$ = template("%s\n", $1);}
|functions func_decl  	{$$ = template("%s\n%s\n", $1, $2);}
;

func_decl:
KW_DEF TK_ID '('functions_param')' function_return_type ':' body_function KW_ENDDEF';' 	{$$ = template("%s %s(%s)\n{\n%s\n}\n",$6, $2,$4, $8);}
;

function_return_type:
%empty				{$$ = template("void");}
|'-''>' data_types		{$$ = template("%s",$3);}
;

functions_param:
%empty				{$$ = "";}
|choose_functions_param		{$$ = $1;}
;

choose_functions_param:
TK_ID ':' data_types						{$$ = template("%s %s", $3,$1);}
|TK_ID'['']' ':' data_types 					{$$ = template("%s *%s", $5, $1);}
|choose_functions_param ',' TK_ID ':' data_types		{$$ = template("%s, %s %s",$1, $5,$3);}
|choose_functions_param ',' TK_ID'['']' ':' data_types		{$$ = template("%s, %s *%s",$1, $7,$3);}
;

/****************************************BODY OF FUNCTIONS**************************************** */

body_function:
const_declaration				{$$ = template("\t%s", $1);}
|variable_declarations				{$$ = template("\t%s", $1);}
|commands					{$$ = template("\t%s", $1);}
|body_function	const_declaration		{$$ = template("%s\n\t%s", $1, $2);}
|body_function	variable_declarations		{$$ = template("%s\n\t%s", $1, $2);}
|body_function	commands			{$$ = template("%s\n\t%s", $1, $2);}
;

/**************************************** COMP DECLARATIONS **************************************** */

comp:
comp_declaration			{$$ = $1;}
|comp comp_declaration			{$$ = template("%s\n%s\n", $1, $2);}
;

comp_declaration:
KW_COMP TK_ID ':' body_comp KW_ENDCOMP ';'		{$$ = template("typedef struct %s{\n%s\n} %s;\n",$2,$4,$2);}
;

body_comp:
comp_variables				{$$ =$1;}
|body_comp comp_variables		{$$ = template("\t%s\n\t%s", $1, $2);}
;

comp_variables:
comp_variables1 ':' data_types ';' 			{$$ = template("%s %s;", $3, $1);}
;

comp_variables1:
'#' TK_ID						{$$ = template("%s", $2);}
|'#' TK_ID '['']'					{$$ = template("*%s", $2);}
|'#' TK_ID '['TK_POSINT']' 				{$$ = template("%s[%s]", $2, $4);}
|comp_variables1 ',' '#' TK_ID				{$$ = template("%s, %s",$1, $4);}
|comp_variables1 ',' '#' TK_ID '['']'			{$$ = template("%s, *%s",$1, $4);}
;

/**************************************** CONST DECLARATIONS **************************************** */
/*out of main*/
const_decl:
const_declaration			{$$ = $1;}
|const_decl const_declaration		{$$ = template("%s\n%s\n", $1, $2);}

const_declaration:
KW_CONST assign_comand ':' data_types ';' {$$ = template("const %s %s;\n",$4,$2);}
;

/**************************************** VARIABLE DECLARATIONS **************************************** */
variable_declarations:
var_decl_1 ':' data_types ';'	{$$ = template("%s %s;", $3, $1);}	
;

var_decl_1:
TK_ID						{$$ = $1;}					
|TK_ID '['']'					{$$ = template("*%s", $1);}
|TK_ID '['TK_POSINT']' 				{$$ = template("%s[%s]", $1, $3);}
|TK_ID '[' TK_ID ']'				{$$ = template("%s[%s]", $1, $3);}
|var_decl_1 ',' TK_ID				{$$ = template("%s, %s",$1, $3);}
|var_decl_1 ',' TK_ID '['']'			{$$ = template("%s, *%s",$1, $3);}
;

/************************************************************ COMANDS *************************************************************** */
commands:
assign_comand ';'			{$$ = template("%s;",$1);}
|if_command ';'				{$$ = template("%s",$1);}
|for_command ';'			{$$ = template("%s",$1);}
|array_command ';'			{$$ = template("%s",$1);}
|array_with_array_command ';'		{$$ = template("%s",$1);}
|while_command ';' 			{$$ = template("%s",$1);}
|break_command ';'			{$$ = template("%s;",$1);}
|continue_command ';'			{$$ = template("%s;",$1);}
|return_command ';'			{$$ = template("%s;",$1);}
|function_call_command ';'		{$$ = template("%s;",$1);}
|commitedFunctions			{$$ = template("%s;",$1);}
;

//assign command
assign_comand:		
TK_ID '=' expr						{$$ = template("%s = %s",$1,$3);}
|TK_ID TK_PLUS_EQUAL expr				{$$ = template("%s += %s",$1,$3);}
|TK_ID TK_MINUS_EQUAL expr				{$$ = template("%s -= %s",$1,$3);}
|TK_ID TK_MUL_EQUAL expr				{$$ = template("%s *= %s",$1,$3);}
|TK_ID TK_DIV_EQUAL expr				{$$ = template("%s /= %s",$1,$3);}
|TK_ID TK_MOD_EQUAL expr				{$$ = template("%s %= %s",$1,$3);}
|TK_ID'['TK_POSINT']' '=' expr				{$$ = template("%s[%s] = %s",$1,$3,$6);}
|TK_ID'['TK_POSINT']' TK_PLUS_EQUAL expr		{$$ = template("%s[%s] += %s",$1,$3,$6);}
|TK_ID'['TK_POSINT']' TK_MINUS_EQUAL expr		{$$ = template("%s[%s] -= %s",$1,$3,$6);}
|TK_ID'['TK_POSINT']' TK_MUL_EQUAL expr			{$$ = template("%s[%s] *= %s",$1,$3,$6);}
|TK_ID'['TK_POSINT']' TK_DIV_EQUAL expr			{$$ = template("%s[%s] /= %s",$1,$3,$6);}
|TK_ID'['TK_POSINT']' TK_MOD_EQUAL expr			{$$ = template("%s[%s] %= %s",$1,$3,$6);}
|TK_ID'['TK_ID']' '=' expr				{$$ = template("%s[%s] = %s",$1,$3,$6);}
|TK_ID'['TK_ID']' TK_PLUS_EQUAL expr			{$$ = template("%s[%s] += %s",$1,$3,$6);}
|TK_ID'['TK_ID']' TK_MINUS_EQUAL expr			{$$ = template("%s[%s] -= %s",$1,$3,$6);}
|TK_ID'['TK_ID']' TK_MUL_EQUAL expr			{$$ = template("%s[%s] *= %s",$1,$3,$6);}
|TK_ID'['TK_ID']' TK_DIV_EQUAL expr			{$$ = template("%s[%s] /= %s",$1,$3,$6);}
|TK_ID'['TK_ID']' TK_MOD_EQUAL expr			{$$ = template("%s[%s] %= %s",$1,$3,$6);}
|TK_ID '.' TK_ID '=' expr				{$$ = template("%s.%s = %s",$1,$3,$5);}
|TK_ID'['TK_ID ']' '.' TK_ID '=' expr			{$$ = template("%s[%s].%s = %s",$1,$3,$6,$8);}
|TK_ID'['TK_POSINT ']' '.' TK_ID '=' expr		{$$ = template("%s[%s].%s = %s",$1,$3,$6,$8);}
|TK_ID '.' TK_ID '['TK_ID ']' '=' expr			{$$ = template("%s.%s[%s] = %s",$1,$3,$5,$8);}
|TK_ID '.' TK_ID '['TK_POSINT ']' '=' expr		{$$ = template("%s.%s[%s] = %s",$1,$3,$5,$8);}
;	

//if command
if_command:
KW_IF '(' expr ')' ':' body_function else_command KW_ENDIF 	{$$ = template("if(%s){\n\t%s\t\n\t}\n%s",$3,$6,$7);} 
;

else_command:
%empty					{$$ = "";}
|KW_ELSE ':' body_function		{$$ = template("\telse{\n\t%s\n\t}",$3);}
;

//for command
for_command:
KW_FOR TK_ID KW_IN '[' for_expr ':' for_expr for_step ']' ':' body_function KW_ENDFOR 
{$$ = template("for (int %s = %s; %s <= %s; %s+=%s) {\n%s\n\t}",$2,$5,$2,$7,$2,$8,$11);}
;

for_expr:
TK_POSINT					{$$ = $1;}
|TK_ID						{$$ = $1;}
|'-' for_expr  %prec SIGN_MINUS			{$$ = template("-%s",$2);}
|'+' for_expr  %prec SIGN_PLUS			{$$ = template("+%s",$2);}
|for_expr '+' for_expr %prec OPER_PLUS		{$$ = template("%s + %s",$1,$3);}
|for_expr '-' for_expr %prec OPER_MINUS		{$$ = template("%s - %s",$1,$3);}
|for_expr '*' for_expr				{$$ = template("%s * %s",$1,$3);}
|for_expr '/' for_expr				{$$ = template("%s / %s",$1,$3);}
|for_expr '%' for_expr				{$$ = template("%s % %s",$1,$3);}
|for_expr TK_POWER for_expr			{$$ = template("pow(%s, %s)", $1, $3);}
|'(' expr ')'					{$$ = template("(%s)", $2);}
;

for_step:
%empty		{$$ = "1";}
|':' for_expr	{$$ = template("%s",$2);}
;

//array_command
array_command:
TK_ID TK_ASSIGN_ARRAY '[' TK_ID expr_array KW_FOR TK_ID ':' expr_array ']' ':' data_types 
{$$=template("%s* %s = (%s*)malloc(%s*sizeof(%s));\n\tfor(int %s = 0;%s<%s;++%s){\n\t\t%s[%s] = %s%s;\n\t}"
,$12,$1,$12,$9,$12,$7,$7,$9,$7,$1,$7,$4,$5);}
;

//array_with_array_command
array_with_array_command:
TK_ID TK_ASSIGN_ARRAY '[' TK_ID expr_array KW_FOR TK_ID ':' data_types KW_IN TK_ID KW_OF TK_POSINT ']' ':' data_types
{$$=template("%s* %s = (%s*)malloc(%s*sizeof(%s));\n\tfor(%s %s_i=0;%s_i<%s;++%s_i){\n\t\t%s[%s_i] = %s[%s_i]%s;\n\t}",$16,$1,$16,$13,$16,$9,$11,$11,$13,$11,$1,$11,$11,$11,$5);}
;

//expr_array
expr_array:
%empty					{$$ = "";}
|TK_POSINT				{$$ = $1;}
|TK_REAL				{$$ = $1;}
|TK_STRING				{$$ = $1;}
|TK_ID					{$$ = $1;}
|'+' expr_array				{$$ = template("+%s",$2);}
|'-' expr_array 			{$$ = template("- %s",$2);}
|'*' expr_array				{$$ = template("* %s",$2);}
|'/' expr_array				{$$ = template("/ %s",$2);}
|'%' expr_array				{$$ = template("% %s",$2);}
|TK_POWER expr_array			{$$ = template("**%s", $2);}
;

//while command
while_command:
KW_WHILE '(' expr ')' ':' body_function KW_ENDWHILE	{$$ = template("while(%s){\n\t%s\n\t}\n",$3,$6);}

//break command
break_command:
KW_BREAK		{$$ = template("break");}
;

//continue command
continue_command:
KW_CONTINUE		{$$ = template("continue");}
;

//return command
return_command:
KW_RETURN				{$$ = template("return");}
|KW_RETURN expr				{$$ = template("return %s", $2);}
;

//function call command
function_call_command:
TK_ID '('function_call_param ')'	{$$ = template("%s(%s)", $1, $3);}
;

function_call_param:
%empty					{$$ = "";}
|expr					{$$ = template("%s", $1);}
|function_call_param ',' expr		{$$ = template("%s, %s", $1, $3);}
;

//commited functions commands
commitedFunctions:
TK_WRITEINTEGER '('expr')' ';'          { $$ = template("writeInteger(%s)", $3); }
|TK_WRITESTR '('expr')' ';'		{ $$ = template("writeStr(%s)", $3);}	
|TK_WRITESCALAR '('expr')' ';'		{ $$ = template("writeScalar(%s)", $3); }
|TK_WRITE '('expr')' ';'		{ $$ = template("write(%s)", $3);}
|TK_READSTR'(' expr')' ';'		{ $$ = template("%s = readStr()", $3);}
|TK_READINTEGER'('expr')' ';'		{ $$ = template("%s = readInteger()", $3);}
|TK_READSCALAR'('expr')' ';'		{ $$ = template("%s = readScalar()", $3);}
;

/**************************************** DATATYPES **************************************** */
data_types:
KW_INTEGER		{$$ = template("int");}
|KW_SCALAR      	{$$ = template("double");}
|KW_STR       		{$$ = template("char*");}
|KW_BOOLEAN		{$$ = template("int");}
|TK_ID			{$$ = template("struct %s",$1);}
;
/**************************************** EXPRESSIONS **************************************** */
expr:
TK_POSINT				{$$ = $1;}
|TK_REAL				{$$ = $1;}
|TK_STRING				{$$ = $1;}
|TK_ID					{$$ = $1;}
|'-' expr  %prec SIGN_MINUS		{$$ = template("-%s",$2);}
|'+' expr  %prec SIGN_PLUS		{$$ = template("+%s",$2);}
|expr '+' expr %prec OPER_PLUS		{$$ = template("%s + %s",$1,$3);}
|expr '-' expr %prec OPER_MINUS		{$$ = template("%s - %s",$1,$3);}
|expr '*' expr				{$$ = template("%s * %s",$1,$3);}
|expr '/' expr				{$$ = template("%s / %s",$1,$3);}
|expr '%' expr				{$$ = template("%s % %s",$1,$3);}
|expr TK_POWER expr			{$$ = template("pow(%s, %s)", $1, $3);}
|expr TK_EQUAL expr			{$$ = template("%s == %s",$1,$3);}
|expr TK_NOT_EQUAL expr			{$$ = template("%s != %s",$1,$3);}
|expr '<' expr				{$$ = template("%s < %s",$1,$3);}
|expr TK_LESS_EQUAL expr		{$$ = template("%s <= %s",$1,$3);}
|expr '>' expr				{$$ = template("%s > %s",$1,$3);}
|expr TK_GREATER_EQUAL expr		{$$ = template("%s >= %s",$1,$3);}
|expr KW_AND expr			{$$ = template("%s && %s",$1,$3);}
|expr KW_OR expr			{$$ = template("%s || %s",$1,$3);}
|KW_NOT expr				{$$ = template("!%s",$2);}
|KW_TRUE				{$$ = "1";}
|KW_FALSE				{$$ = "0";}
|'(' expr ')'				{$$ = template("(%s)", $2);}
|'[' expr ']'				{$$ = template("[%s]", $2);}
|TK_ID '['expr']' 			{$$ = template("%s[%s]",$1, $3);}
|TK_ID '.' TK_ID			{$$ = template("%s.%s", $1,$3);}
|TK_ID '.' TK_ID'[' expr ']'		{$$ = template("%s.%s[%s]",$1, $3,$5);}
|TK_ID'[' expr ']' '.' TK_ID		{$$ = template("%s[%s].%s",$1, $3,$6);}
|function_call_command			{$$ = $1;}
;

%%
int main ()
{
   if ( yyparse() != 0 )
	printf("Rejected!\n");
}

