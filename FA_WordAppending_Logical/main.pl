startState(0).
finalStates([3]).
transitions([(0, a, 1), (1, b, 2), (2, c, 3)]).

depthFirstSearch(CurrentState, PreviousSymbols, Path, Symbols) :-
    finalStates(FinalStates),
    member(CurrentState, FinalStates),
    Path = [CurrentState],
    Symbols = PreviousSymbols.
depthFirstSearch(CurrentState, PreviousSymbols, Path, Symbols) :-
    transitions(Transitions),
    findall((Symbol, NextState), member((CurrentState, Symbol, NextState), Transitions), NextStates),
    member((Symbol, NextState), NextStates),
    \+ member(NextState, PreviousSymbols),
    append(PreviousSymbols, [Symbol], NewSymbols),
    depthFirstSearch(NextState, NewSymbols, RestPath, RestSymbols),
    Path = [CurrentState | RestPath],
    Symbols = RestSymbols.

findPath(Word, Path, Symbols) :-
    startState(StartState),
    string_chars(Word, Chars),
    foldl(stateTransition, Chars, StartState, FinalState),
    depthFirstSearch(FinalState, [], Path, Symbols).

stateTransition(Char, CurrentState, NextState) :-
    transitions(Transitions),
    member((CurrentState, Char, NextState), Transitions).

main :-
    Word = "aa",
    findPath(Word, Path, Symbols),
    write('Path: '), writeln(Path),
    string_chars(Word, WordChars),
    append(WordChars, Symbols, AllSymbols),
    string_chars(AllSymbolsString, AllSymbols),
    write('Possible word: '), writeln(AllSymbolsString).