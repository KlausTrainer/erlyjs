%%%-------------------------------------------------------------------
%%% File:      erlyjs.erl
%%% @author    Roberto Saccon <rsaccon@gmail.com> [http://rsaccon.com]
%%% @copyright 2007 Roberto Saccon
%%% @doc  
%%% ErlyJS main module
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
%%% @since 2007-11-17 by Roberto Saccon
%%%-------------------------------------------------------------------
-module(erlyjs).
-author('rsaccon@gmail.com').

    
%% API
-export([
    compile/2, 
    compile/3, 
    shell/0,
    create_scanner/0, 
    create_parser/0, 
    scanner_src/0, 
    parser_src/0,
    dump_src/1]).


compile(File, Module) ->
    erlyjs_compiler:compile(File, Module, []).

compile(File, Module, Options) ->
    erlyjs_compiler:compile(File, Module, Options).
  
    
%%--------------------------------------------------------------------
%% @spec () -> any()
%% @doc 
%% Interactive Javascript shell
%% @end 
%%--------------------------------------------------------------------
shell() ->
    exit(not_implemnted_yet).
    
            
%%--------------------------------------------------------------------
%% @spec () -> any()
%% @doc 
%% Creates the leex-based ErlyJS lexer
%% @end 
%%--------------------------------------------------------------------
create_scanner() ->
    create_scanner("src/erlyjs_scan", "ebin").

%%--------------------------------------------------------------------
%% @spec () -> any()
%% @doc 
%% Creates the yecc-based ErlyJS parser
%% @end 
%%--------------------------------------------------------------------    
create_parser() ->
    create_parser("src/erlyjs_parser", "ebin").
     
scanner_src() ->
     filename:join(src_erlyjs_dir(), "erlyjs_scan.xrl").

parser_src() ->
     filename:join(src_erlyjs_dir(), "erlyjs_parser.yrl"). 
     
 
dump_src(Module) ->  
    Beam = filename:join(["ebin", lists:concat([Module, ".beam"])]),
    case beam_lib:chunks(Beam, [abstract_code]) of
        {ok,{_,[{abstract_code,{_,AC}}]}} ->  
            io:put_chars(erl_prettypr:format(erl_syntax:form_list(AC)));
        _ ->
            io:format("~p~n",["No source code found"]) 
   end.
    
    
%%====================================================================
%% Internal functions
%%====================================================================

src_erlyjs_dir() ->
     {file, Ebin} = code:is_loaded(?MODULE),
     filename:join([filename:dirname(filename:dirname(Ebin)), "src"]).


create_scanner(Path, Outdir) ->
    case leex:file(Path) of
        ok ->
            compile2(Path, Outdir, "Scanner");
        _ ->
            {error, "scanner generation failed"}
    end.

    
create_parser(Path, Outdir) ->
    case yecc:file(Path) of
        {ok, _} ->
            compile2(Path, Outdir, "Parser");
        _ ->
            {error, "parser generation failed"}
    end.


compile2(Path, Outdir, Name) ->
    case compile:file(Path, [{outdir, Outdir}]) of
        {ok, Bin} ->
            code:purge(Bin),
            case code:load_file(Bin) of
                {module, _} ->
                    ok;
                _ ->
                    {error, Name ++ "reload failed"}
            end;
        _ ->
            {error, Name ++ "compilation failed"}
    end.

            
    
    
