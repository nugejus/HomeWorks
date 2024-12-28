:-include("drawer.pl").
:-include("dict.pl").

parse_sentence(Sentence) :-
    findall(Tree, s(_, Tree, Sentence, []), Trees),
    (   Trees = [] 
    ->  writeln("This sentence is not correct")
    ;   
        writeln("Possible parsing versions:"),
        print_and_visualize_trees(Trees)
    ).

print_and_visualize_trees([]).
print_and_visualize_trees([Tree | Rest]) :-
    format('~w~n', [Tree]),
    visualize(Tree),
    print_and_visualize_trees(Rest). 

% 문장 시작 S -> NP VP
s(Num, s(NP,VP)) --> np(Num, NP), vp(Num, VP).

% Noun phrase
np(Num, Noun) --> n(Num, Noun).
np(Num, Pronoun) --> p(Num, Pronoun).
np(Num, np(Determiner, Noun)) --> det(Num, Determiner), n(Num, Noun).
np(Num, ap(Determiner, AP)) --> det(Num, Determiner), ap(Num, AP).
np(Num, ap(Adverb, AP)) --> adv(adjective, Adverb), ap(Num, AP).

np(Num, np(NP1, NP2)) --> base_np(Num, NP1), np_tail(NP2).

base_np(Num, Noun) --> n(Num, Noun).
base_np(Num, Pronoun) --> p(Num, Pronoun).
base_np(Num, np(Determiner, Noun)) --> det(Num, Determiner), n(Num, Noun).
base_np(Num, ap(Determiner, AP)) --> det(Num, Determiner), ap(Num, AP).
base_np(Num, ap(Adverb, AP)) --> adv(adjective, Adverb), ap(Num, AP).

np_tail(np(PP, NP)) --> pp(_, PP), np_tail(NP).
np_tail(PP) --> pp(_, PP).


% Verb phrase
vp(Num, Verb) --> v(Num, Verb).
vp(Num, vp(Adverb, Verb, NP)) --> adv(verb, Adverb), v(Num, Verb), np(Num, NP).

vp(Num, vp(VP1, VP2)) --> base_vp(Num, VP1), vp_tail(VP2).

base_vp(Num, Verb) --> v(Num, Verb).
base_vp(Num, vp(Verb, NP)) --> v(Num, Verb), np(_, NP).
base_vp(Num, vp(Adverb, Verb, NP)) --> adv(verb, Adverb), v(Num, Verb), np(Num, NP).

vp_tail(vp(VP, PP)) --> pp(_, PP), vp_tail(VP).
vp_tail(PP) --> pp(_, PP).

% Preposition, Adjectives 처리
pp(Num, pp(Preposition, NP)) --> prep(Preposition), np(Num, NP).

ap(Num, ap(Adjectives, AP)) --> adj(Adjectives), ap(Num, AP).
ap(Num, ap(Adjectives, NP)) --> adj(Adjectives), np(Num, NP).
