epsilon('ε').

first(Symbol, Grammar, Result) :-
    atom_chars(Symbol, [H|_]), 
    (   get_assoc(H, Grammar, Rules)
    ->  findall(R, (member(Rule, Rules),
                    (   Rule = []
                    ->  R = [epsilon]
                    ;   Rule = [Head|_], 
                        (   Head = epsilon 
                        ->  R = [epsilon]
                        ;   atom_chars(Head, [C|_]), 
                            (   get_assoc(C, Grammar, _)
                            ->  first(C, Grammar, R)
                            ;   R = [C]
                            )
                        )
                    )
                ), Result)
    ;   Result = [H]  
    ).


firstSets(Grammar, Result) :-
    findall(Key-Value, (gen_assoc(Key, Grammar, _), first(Key, Grammar, Value)), Pairs),
    list_to_assoc(Pairs, Result).

removeEpsilon(Str, Result) :-
    (   Str = epsilon
    ->  Result = epsilon
    ;   atom_chars(Str, Chars),
        delete(Chars, 'ε', NewChars),
        atom_chars(Result, NewChars)
    ).

parseRule(Rule, Result) :-
    atomic_list_concat(Parts, ' ', Rule),
    maplist(removeEpsilon, Parts, Result).

parseGrammarLine(Line, NonTerminal-Rules) :-
    atomic_list_concat(Parts, '->', Line),
    [NonTerminal, RuleStr] = Parts,
    atomic_list_concat(RuleParts, '|', RuleStr),
    maplist(parseRule, RuleParts, Rules).

readGrammarFromString(String, Grammar) :-
    atomic_list_concat(Lines, '\n', String),
    maplist(parseGrammarLine, Lines, Pairs),
    list_to_assoc(Pairs, Grammar).

printFirstSets(Firsts) :-
    gen_assoc(Key, Firsts, Value),
    format('First(~w): ~w~n', [Key, Value]),
    fail.
printFirstSets(_).

main :-
    GrammarString = "S->AB|c
A->d
B->c",
    readGrammarFromString(GrammarString, Grammar),
    firstSets(Grammar, Firsts),
    printFirstSets(Firsts).