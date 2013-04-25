%%%-------------------------------------------------------------------
%%% File:      erlyjs_scan.xrl
%%% @author    Roberto Saccon <rsaccon@gmail.com> [http://rsaccon.com]
%%% @copyright 2007 Roberto Saccon
%%% @doc  
%%% ErlyJS Scanner
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

Definitions.

Digit = [0-9]
UpperC = [A-Z]
LowerC = [a-z]
Whitespace = [\000-\s]

String = "(\\\^.|\\.|[^"])*"
Quote = '(\\\^.|\\.|[^'])*'
Comment = (/\*(.|[\r\n])*?\*/|//.*)


Rules.   

{Digit}+\.{Digit}+ : build_float(TokenChars, TokenLine).

{Digit}+ : build_integer(TokenChars, TokenLine).

{String} : build_string(TokenChars, TokenLine, TokenLen).

{Quote} : build_string(TokenChars, TokenLine, TokenLen).

{Comment} : skip_token.     
   
({UpperC}|{LowerC}|_|\$)({UpperC}|{Digit}|{LowerC}|_|\$)* : build_identifier(TokenChars, TokenLine). 

{Whitespace}+ : skip_token.


%% special characters and single character operators
\* :                  {token,{'*',TokenLine}}.
/ :                   {token,{'/',TokenLine}}.
\+ :                  {token,{'+',TokenLine}}.
- :                   {token,{'-',TokenLine}}.
\^ :                  {token,{'^',TokenLine}}.
& :                   {token,{'&',TokenLine}}.
\| :                  {token,{'|',TokenLine}}.
\< :                  {token,{'<',TokenLine}}.
\> :                  {token,{'>',TokenLine}}.
= :                   {token,{'=',TokenLine}}.
\. :                  {token,{'.',TokenLine}}.
, :                   {token,{',',TokenLine}}.
: :                   {token,{':',TokenLine}}.
! :                   {token,{'!',TokenLine}}.
\? :                  {token,{'?',TokenLine}}.
; :                   {token,{';',TokenLine}}.
\( :                  {token,{'(',TokenLine}}.
\) :                  {token,{')',TokenLine}}.
\{ :                  {token,{'{',TokenLine}}.
} :                   {token,{'}',TokenLine}}.
\[ :                  {token,{'[',TokenLine}}.
\] :                  {token,{']',TokenLine}}.
\% :                  {token,{'%',TokenLine}}.
\~ :                  {token,{'~',TokenLine}}.


%% multi character operators
\+\+ :                {token,{'++',TokenLine}}.
-- :                  {token,{'--',TokenLine}}.
<< :                  {token,{'<<',TokenLine}}.
>> :                  {token,{'>>',TokenLine}}.
>>> :                 {token,{'>>>',TokenLine}}.
== :                  {token,{'==',TokenLine}}.
!= :                  {token,{'!=',TokenLine}}.
=== :                 {token,{'===',TokenLine}}.
!== :                 {token,{'!==',TokenLine}}.
&& :                  {token,{'&&',TokenLine}}.
\|\| :                {token,{'||',TokenLine}}.
\*= :                 {token,{'*=',TokenLine}}.
/= :                  {token,{'/=',TokenLine}}.
\%= :                 {token,{'%=',TokenLine}}.
\+= :                 {token,{'+=',TokenLine}}.
-= :                  {token,{'-=',TokenLine}}.
<<= :                 {token,{'<<=',TokenLine}}.
>>= :                 {token,{'>>=',TokenLine}}.
>>>= :                {token,{'>>>=',TokenLine}}.
&= :                  {token,{'&=',TokenLine}}.
\^= :                 {token,{'^=',TokenLine}}.
\|= :                 {token,{'|=',TokenLine}}.
<= :                  {token,{'<=',TokenLine}}.
>= :                  {token,{'>=',TokenLine}}.

Erlang code.  

%%%-------------------------------------------------------------------
%%% File:      erlyjs_scan.xrl
%%% @author    Roberto Saccon <rsaccon@gmail.com> [http://rsaccon.com]
%%% @copyright 2007 Roberto Saccon
%%% @doc  
%%% ErlyJS Scanner (auto-generated with leex)
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

-export([
    build_integer/2, 
    build_float/2,
    build_string/3, 
    build_identifier/2,
    reserved_word/1]).
    
build_integer(Chars, Line) ->
    {token, {integer, Line, list_to_integer(Chars)}}.

build_float(Chars, Line) ->
    {token, {float, Line, list_to_float(Chars)}}.

build_string(Chars, Line, Len) ->
    S = lists:sublist(Chars, 2, Len - 2), 
    {token, {string, Line, S}}.
  
build_identifier(Chars, Line) ->  
    Atom = list_to_atom(Chars),
    case reserved_word(Atom) of
        true -> {token, {Atom, Line}};
        false -> {token, {identifier, Line, Atom}}
    end.

%% reserved words
reserved_word('break') -> true;
reserved_word('else') -> true;
reserved_word('new') -> true;
reserved_word('var') -> true;
reserved_word('case') -> true;
reserved_word('finally') -> true;
reserved_word('return') -> true;
reserved_word('void') -> true;
reserved_word('catch') -> true;
reserved_word('for') -> true;
reserved_word('switch') -> true;
reserved_word('while') -> true;
reserved_word('continue') -> true;
reserved_word('function') -> true;
reserved_word('this') -> true;
reserved_word('with') -> true;
reserved_word('default') -> true;
reserved_word('if') -> true;
reserved_word('throw') -> true;
reserved_word('delete') -> true;
reserved_word('in') -> true;
reserved_word('try') -> true;
reserved_word('do') -> true;
reserved_word('instanceof') -> true;
reserved_word('typeof') -> true;

%% future reserved words
reserved_word('abstract') -> true;
reserved_word('enum') -> true;
reserved_word('int') -> true;
reserved_word('short') -> true;
reserved_word('boolean') -> true;
reserved_word('export') -> true;
reserved_word('interface') -> true;
reserved_word('static') -> true;
reserved_word('byte') -> true;
reserved_word('extends') -> true;
reserved_word('long') -> true;
reserved_word('super') -> true;
reserved_word('char') -> true;
reserved_word('final') -> true;
reserved_word('native') -> true;
reserved_word('synchronized') -> true;
reserved_word('class') -> true;
reserved_word('float') -> true;
reserved_word('package') -> true;
reserved_word('throws') -> true;
reserved_word('const') -> true;
reserved_word('goto') -> true;
reserved_word('private') -> true;
reserved_word('transient') -> true;
reserved_word('debugger') -> true;
reserved_word('implements') -> true;
reserved_word('protected') -> true;
reserved_word('volatile') -> true;
reserved_word('double') -> true;
reserved_word('import') -> true;
reserved_word('public') -> true;
reserved_word(_) -> false.