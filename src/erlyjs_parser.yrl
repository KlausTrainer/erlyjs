%%%-------------------------------------------------------------------
%%% File:      erlyjs_parser.xrl
%%% @author    Roberto Saccon <rsaccon@gmail.com> [http://rsaccon.com]
%%% @copyright 2007 Roberto Saccon
%%% @doc
%%% ErlyJS Parser
%%% @end
%%%
%%% The MIT License
%%%
%%% Copyright (c) 2007 Roberto Saccon
%%%
%%% Permission is hereby granted, free of charge, to any person obtaining a copy
%%% of this software and associated documentation files (the "Software"), to deal
%%% in the Software without restriction, including without limitation the rights
%%% to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
%%% copies of the Software, and to permit persons to whom the Software is
%%% furnished to do so, subject to the following conditions:
%%%
%%% The above copyright notice and this permission notice shall be included in
%%% all copies or substantial portions of the Software.
%%%
%%% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
%%% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
%%% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
%%% AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
%%% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
%%% OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
%%% THE SOFTWARE.
%%%
%%% Acknowledgements
%%% ================
%%% special thanks to Denis Loutrein for initial code contribution
%%%
%%% @since 2007-12-23 by Roberto Saccon
%%%-------------------------------------------------------------------


Nonterminals
    Program
    MultiplicativeExpression
    UnaryExpression
    AdditiveExpression
    PostfixExpression
    LeftSideExpression
    CallExpression
    PrimaryExpression
    MemberExpression
    Arguments
    NewExpression
    Expression
    ArgumentList
    AssignmentExpression
    ObjectLiteral
    RegularExpression
    ParenthesizedExpression
    FunctionExpression
    ArrayLiteral
    Elision
    ElisionOpt
    AnonymousFunction
    NamedFunction
    FieldList
    LiteralField
    ElementList
    OptionalExpression
    Number
    ConditionalExpression
    CompoundAssignment
    FormalParametersAndBody
    FormalParameters
    FunctionDefinition
    Statement
    OptionalSemicolon
    EmptyStatement
    TopStatement
    TopStatements
    ExpressionStatement
    VariableDefinition
    VariableDeclarationList
    VariableDeclaration
    VariableInitializer
    ShiftExpression
    RelationalExpression
    EqualityExpression
    BitwiseAndExpression
    BitwiseXorExpression
    LogicalOrExpression
    BitwiseOrExpression
    LogicalAndExpression
    Block
    LabeledStatement
    IfStatement
    SwitchStatement
    DoStatement
    WhileStatement
    ForStatement
    WithStatement
    ContinueStatement
    BreakStatement
    ReturnStatement
    ThrowStatement
    TryStatement
    BlockStatements
    CaseGroups
    CaseGroup
    CaseGuards
    CaseGuard
    ForInitializer
    ForInBinding
    LastCaseGroup
    OptionalLabel
    CatchClauses
    FinallyClause
    CatchClause
    .


Terminals
    float integer string new this null true false delete void typeof try throw with break return
    identifier regexp function var instanceof in if else switch do while for case default
    continue finally catch
    '+' '-' '*' '/' '%' ':' '~' '!' '*=' '/=' '%=' '+=' '-=' '<<=' '>>=' '>>>='
    '&=' '^=' '|=' '=' ';' '?' '<<' '>>' '>>>' '<' '>'
    '(' ')' '[' ']' '.' ',' '++' '--' '&&' '===' '==' '<=' '>=' '!=' '!=='
    '{' '}' '&' '^' '||' '|'
    .


Left 100 FunctionExpression.
Left 100 LiteralField.


Rootsymbol Program.


%% Number
Number -> float : '$1'.
Number -> integer : '$1'.

%% Primary Expressions
PrimaryExpression -> this : '$1'.
PrimaryExpression -> null : '$1'.
PrimaryExpression -> true : '$1'.
PrimaryExpression -> false : '$1'.
PrimaryExpression -> Number : '$1'.
PrimaryExpression -> string : '$1'.
PrimaryExpression -> identifier : '$1'.
PrimaryExpression -> regexp : '$1'.
PrimaryExpression -> ParenthesizedExpression : '$1'.
PrimaryExpression -> ArrayLiteral : '$1'.
PrimaryExpression -> ObjectLiteral : '$1'.

ParenthesizedExpression -> '(' Expression ')' : '$2'.

%% Function Expressions
FunctionExpression -> AnonymousFunction : '$1'.
FunctionExpression -> NamedFunction : '$1'.

%% Object Literals TODO
ObjectLiteral -> '{' '}' : '$1'.
ObjectLiteral -> '{' FieldList '}'  : '$2'.
FieldList -> LiteralField : ['$1'].
FieldList -> FieldList ',' LiteralField : '$1' ++ ['$3'].
LiteralField -> identifier ':' AssignmentExpression : '$1'.

%% Array Literals
ArrayLiteral -> '[' ElisionOpt ']' : {'[', '$2'}.
ArrayLiteral -> '[' ElementList ']' :  {'[', '$2'}.
ArrayLiteral -> '[' ElementList ',' ElisionOpt ']' : {'[', lists:flatten('$2' ++ '$4')}.
ElementList -> ElisionOpt AssignmentExpression : '$1' ++ ['$2'].
ElementList -> ElementList ',' ElisionOpt AssignmentExpression : '$1' ++ '$3' ++ ['$4'].
ElisionOpt -> '$empty' : [].
ElisionOpt -> ',' : [{'[', ','}].
ElisionOpt -> Elision ',' : ['$1', {'[', ','}].
Elision -> ',' : [{'[', ','}].
Elision -> Elision ',' : ['$1', {'[', ','}].

%% Left-Side Expressions
LeftSideExpression -> NewExpression : '$1'.
LeftSideExpression -> CallExpression : '$1'.
CallExpression -> MemberExpression Arguments : funcall('$1', '$2').
CallExpression -> CallExpression Arguments : funcall('$1', '$2').
CallExpression -> CallExpression '[' Expression ']' : {'$1', {'[', ['$3']}}.

NewExpression -> MemberExpression : '$1'.
NewExpression -> new NewExpression : {new, '$2'}.

MemberExpression -> PrimaryExpression : '$1'.
MemberExpression -> FunctionExpression : '$1'.
MemberExpression -> MemberExpression '[' Expression ']' : {'$1', {'[]', '$3'}}.
MemberExpression -> MemberExpression '.' identifier : {'$1', [element(3, '$3')]}.
MemberExpression -> new MemberExpression Arguments : {new, '$2', '$3'}.

Arguments -> '(' ')' : {'(', []}.
Arguments -> '(' ArgumentList ')' : {'(', '$2'}.
ArgumentList -> AssignmentExpression : ['$1'].
ArgumentList -> ArgumentList ',' AssignmentExpression : '$1' ++ ['$3'].


%% Postfix Operators
PostfixExpression -> LeftSideExpression : '$1'.
PostfixExpression -> LeftSideExpression '++' : {op, postfix('$2'), '$1'}.
PostfixExpression -> LeftSideExpression '--' : {op, postfix('$2'), '$1'}.

%% Unary Operators
UnaryExpression -> PostfixExpression : '$1'.
UnaryExpression -> delete LeftSideExpression : {op, '$1', '$2'}. % TODO
UnaryExpression -> void UnaryExpression : {op, '$1', '$2'}. % TODO
UnaryExpression -> typeof UnaryExpression : {op, '$1', '$2'}. % TODO
UnaryExpression -> '++' UnaryExpression : {op, '$1', '$2'}.
UnaryExpression -> '--' UnaryExpression : {op, '$1', '$2'}.
UnaryExpression -> '+' UnaryExpression : plus('$1', '$2').
UnaryExpression -> '-' UnaryExpression : minus('$1', '$2').
UnaryExpression -> '~' UnaryExpression : {op, '$1', '$2'}.
UnaryExpression -> '!' UnaryExpression : {op, '$1', '$2'}.


%% Multiplicative Operators
MultiplicativeExpression -> UnaryExpression : '$1'.
MultiplicativeExpression -> MultiplicativeExpression '*' UnaryExpression : {op, '$2', '$1', '$3'}.
MultiplicativeExpression -> MultiplicativeExpression '/' UnaryExpression : {op, '$2', '$1', '$3'}.
MultiplicativeExpression -> MultiplicativeExpression '%' UnaryExpression : {op, '$2', '$1', '$3'}.

%% Additive Operators
AdditiveExpression -> MultiplicativeExpression : '$1'.
AdditiveExpression -> AdditiveExpression '+' MultiplicativeExpression : {op, '$2', '$1', '$3'}.
AdditiveExpression -> AdditiveExpression '-' MultiplicativeExpression : {op, '$2', '$1', '$3'}.

%% Bitwise Shift Operators
ShiftExpression -> AdditiveExpression : '$1'.
ShiftExpression -> ShiftExpression '<<' AdditiveExpression : {op, '$2', '$1', '$3'}.
ShiftExpression -> ShiftExpression '>>' AdditiveExpression : {op, '$2', '$1', '$3'}.
ShiftExpression -> ShiftExpression '>>>' AdditiveExpression : '$1'. % TODO

%% Relational Operators
RelationalExpression -> ShiftExpression : '$1'.
RelationalExpression -> RelationalExpression '<' ShiftExpression : {op, '$2', '$1', '$3'}.
RelationalExpression -> RelationalExpression '>' ShiftExpression : {op, '$2', '$1', '$3'}.
RelationalExpression -> RelationalExpression '<=' ShiftExpression : {op, '$2', '$1', '$3'}.
RelationalExpression -> RelationalExpression '>=' ShiftExpression  : {op, '$2', '$1', '$3'}.
RelationalExpression -> RelationalExpression instanceof ShiftExpression : '$1'. % TODO
RelationalExpression -> RelationalExpression in ShiftExpression  : '$1'.  % TODO

%% Equality Operators
EqualityExpression -> RelationalExpression : '$1'.
EqualityExpression -> EqualityExpression '==' RelationalExpression : {op, '$2', '$1', '$3'}.
EqualityExpression -> EqualityExpression '!=' RelationalExpression : {op, '$2', '$1', '$3'}.
EqualityExpression -> EqualityExpression '===' RelationalExpression  : {op, '$2', '$1', '$3'}.
EqualityExpression -> EqualityExpression '!==' RelationalExpression : {op, '$2', '$1', '$3'}.

%% Binary Bitwise Operators
BitwiseAndExpression -> EqualityExpression : '$1'.
BitwiseAndExpression -> BitwiseAndExpression '&' EqualityExpression : {op, '$2', '$1', '$3'}.
BitwiseXorExpression -> BitwiseAndExpression : '$1'.
BitwiseXorExpression -> BitwiseXorExpression '^' BitwiseAndExpression : {op, '$2', '$1', '$3'}.
BitwiseOrExpression -> BitwiseXorExpression : '$1'.
BitwiseOrExpression -> BitwiseOrExpression '|' BitwiseXorExpression : {op, '$2', '$1', '$3'}.

%% Binary Logical Operators
LogicalAndExpression -> BitwiseOrExpression : '$1'.
LogicalAndExpression -> LogicalAndExpression '&&' BitwiseOrExpression : {op, '$2', '$1', '$3'}.
LogicalOrExpression -> LogicalAndExpression : '$1'.
LogicalOrExpression -> LogicalOrExpression '||' LogicalAndExpression : {op, '$2', '$1', '$3'}.

%% Conditional Operator
ConditionalExpression -> LogicalOrExpression : '$1'.
ConditionalExpression -> LogicalOrExpression '?' AssignmentExpression ':' AssignmentExpression : {op, 'cond', '$1', '$3', '$5'}.

%% Assignment Operators
AssignmentExpression -> ConditionalExpression : '$1'.
AssignmentExpression -> LeftSideExpression '=' AssignmentExpression : {assign, '$2', '$1', '$3'}.
AssignmentExpression -> LeftSideExpression CompoundAssignment AssignmentExpression  : {assign, '$2', '$1', '$3'}.
CompoundAssignment -> '*=' : '$1'.
CompoundAssignment -> '/=' : '$1'.
CompoundAssignment -> '%=' : '$1'.
CompoundAssignment -> '+=' : '$1'.
CompoundAssignment -> '-=' : '$1'.
CompoundAssignment -> '<<=' : '$1'.
CompoundAssignment -> '>>=' : '$1'.
CompoundAssignment -> '>>>=' : '$1'. % TODO
CompoundAssignment -> '&=' : '$1'.
CompoundAssignment -> '^=' : '$1'.
CompoundAssignment -> '|=' : '$1'.

%% Expressions
Expression -> AssignmentExpression : '$1'.
Expression -> Expression ',' AssignmentExpression : ['$1', '$3'].

OptionalExpression -> Expression : '$1'.
OptionalExpression -> '$empty' : [].

%% Statements
Statement -> EmptyStatement :  '$1'.
Statement -> ExpressionStatement OptionalSemicolon : '$1'.
Statement -> VariableDefinition OptionalSemicolon : '$1'.
Statement -> Block : '$1'.
Statement -> LabeledStatement : '$1'.
Statement -> IfStatement : '$1'.
Statement -> SwitchStatement : '$1'.
Statement -> DoStatement OptionalSemicolon : '$1'.
Statement -> WhileStatement : '$1'.
Statement -> ForStatement : '$1'.
Statement -> WithStatement : '$1'.
Statement -> ContinueStatement OptionalSemicolon : '$1'.
Statement -> BreakStatement OptionalSemicolon  : '$1'.
Statement -> ReturnStatement OptionalSemicolon  : '$1'.
Statement -> ThrowStatement OptionalSemicolon : '$1'.
Statement -> TryStatement : '$1'.
OptionalSemicolon -> ';' : '$1'.
OptionalSemicolon -> '$empty' : [].

%% Empty Statement
EmptyStatement -> ';'.

%% Expression Statement
ExpressionStatement -> Expression : '$1'.

%% Variable Definition
VariableDefinition -> var VariableDeclarationList : {var, '$2'}.
VariableDeclarationList -> VariableDeclaration : ['$1'].
VariableDeclarationList -> VariableDeclarationList ',' VariableDeclaration : '$1' ++ ['$3'].
VariableDeclaration -> identifier VariableInitializer : {'$1', '$2'}.
VariableInitializer -> '$empty' : [].
VariableInitializer -> '=' AssignmentExpression : '$2'.

%% Block
Block -> '{' BlockStatements '}' : '$2'.
BlockStatements -> Statement : ['$1'].
BlockStatements ->  BlockStatements Statement : '$1' ++ ['$2'].

%% Labeled Statements
LabeledStatement -> identifier ':' Statement : {label, '$2'}.

%% If Statement
IfStatement -> 'if' ParenthesizedExpression Statement  : {'if', '$2', '$3'}.
IfStatement -> 'if' ParenthesizedExpression Statement else Statement : {ifelse, '$2', '$3', '$5'}.


%% Switch Statement
SwitchStatement -> switch ParenthesizedExpression '{' '}' : [].
SwitchStatement -> switch ParenthesizedExpression '{' CaseGroups LastCaseGroup '}' : {switch, '$2', '$4', '$5'}.
CaseGroups -> '$empty' : [].
CaseGroups -> CaseGroups CaseGroup : '$1' ++ ['$2'].
CaseGroup -> CaseGuards BlockStatements : {'$1', '$2'}.
LastCaseGroup  -> CaseGuards BlockStatements : {'$1', '$2'}.
CaseGuards -> CaseGuard : ['$1'].
CaseGuards -> CaseGuards CaseGuard : '$1' ++ ['$2'].
CaseGuard -> 'case' Expression ':' : '$2'.
CaseGuard -> default ':' : default.


%% Do-While Statement
DoStatement -> do Statement while ParenthesizedExpression : {do_while, '$2', '$4'}.

%% While Statement
WhileStatement -> while ParenthesizedExpression Statement : {while, '$2', '$3'}.

%% For Statements  TODO
ForStatement -> for '(' ForInitializer ';' OptionalExpression ';' OptionalExpression ')' Statement : {for, '$3', '$5', '$7', '$9'}.
ForStatement -> for '(' ForInBinding in Expression ')' Statement : '$1'. %% TODO
ForInitializer -> '$empty' : [].
ForInitializer -> Expression : '$1'.
ForInitializer -> var VariableDeclarationList : {var, '$2'}.
%ForInBinding -> LeftSideExpression : '$1'.
ForInBinding -> var VariableDeclaration : '$1'.  %% TODO

%% With Statement TODO
WithStatement -> with ParenthesizedExpression Statement : '$1'.

%% Continue and Break Statements
ContinueStatement -> continue OptionalLabel : '$1'.
BreakStatement  -> break OptionalLabel : '$1'.
OptionalLabel -> '$empty' : [].
OptionalLabel -> identifier : '$1'.

%% Return Statement TODO
ReturnStatement -> return : {return, undefined}.
ReturnStatement -> return Expression : {return, '$2'}.

%% Throw Statement TODO
ThrowStatement -> throw Expression : '$1'.

%% Try Statement
TryStatement -> try Block CatchClauses : '$1'.
TryStatement -> try Block FinallyClause : '$1'.
TryStatement -> try Block CatchClauses FinallyClause : '$1'.
CatchClauses -> CatchClause : '$1'.
CatchClauses -> CatchClauses CatchClause : '$1'.
CatchClause -> catch '(' identifier ')' Block : '$1'.
FinallyClause -> finally Block : '$1'.

%% Function Definition
FunctionDefinition -> NamedFunction : '$1'.
AnonymousFunction -> function FormalParametersAndBody : {function, '$2'}.
NamedFunction -> function identifier FormalParametersAndBody : {function, '$2', '$3'}.
FormalParametersAndBody -> '(' FormalParameters ')' Block : {params, '$2', body, '$4'}.
FormalParametersAndBody -> '(' FormalParameters ')' '{' '}' : {params, '$2', body, [{return, undefined}]}.
FormalParameters -> '$empty' : [].
FormalParameters -> identifier : ['$1'].
FormalParameters -> FormalParameters ',' identifier : '$1' ++ ['$3'].

%% Programs
Program -> TopStatements : '$1'.
TopStatements -> '$empty' : [].
TopStatements -> TopStatements TopStatement : '$1' ++ ['$2'].
TopStatement -> Statement : '$1'.
TopStatement -> FunctionDefinition  : '$1'.


Erlang code.

minus(_, {integer, Line, Value}) -> {integer, Line, -Value};
minus(_, {float, Line, Value}) -> {float, Line, -Value};
minus(Op, Exp) -> {op, Op, Exp}.

plus(_, Int = {integer, _, _}) -> Int;
plus(_, Float = {float, _, _}) -> Float;
plus(Op, Exp) -> {op, Op, Exp}.

postfix({Op, Line}) -> {Op, postfix, Line}.

funcall(Call, Args) when size(Call) =:= 3 -> {apply, Call, Args};
funcall(Call, Args) -> {Call, Args}.
