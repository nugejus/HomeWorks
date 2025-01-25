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
np(Num, Pronoun) --> p(Num, Pronoun).
np(Num, NPP) --> npp(Num, NPP).

npp(Num, Noun) --> n(Num, Noun).
npp(Num, np(AP, Noun)) --> ap(Num, AP), n(Num, Noun).
npp(Num, np(Determiner, NPP)) --> det(Num, Determiner), npp(Num, NPP).

npp(Num, np(Noun, NPT)) --> n(Num, Noun), npt(NPT).
npp(Num, np(AP, Noun, NPT)) --> ap(Num, AP), n(Num, Noun), npt(NPT).
npp(Num, np(Determiner, NPP, NPT)) --> det(Num, Determiner), npp(Num, NPP), npt(NPT).

npt(np(PP, NPT)) --> pp(PP), npt(NPT).
npt(PP) --> pp(PP).

% Verb phrase
vp(Num, Verb) --> v(Num, Verb).
vp(Num, vp(Verb, NP)) --> v(Num, Verb), np(_, NP).
vp(Num, vp(Verb, VPP)) --> v(Num, Verb), vpp(Num, VPP).

vp(Num, vp(Adv, Verb)) --> adv(verb, Adv), v(Num, Verb).
vp(Num, vp(Adv, Verb, NP)) --> adv(verb, Adv), v(Num, Verb), np(Num, NP).
vp(Num, vp(Adv, Verb, VPP)) --> adv(verb, Adv), v(Num, Verb), vpp(Num, VPP).

vpp(_, vp(PP)) --> pp(PP).
vpp(Num, vp(PP, VP)) --> pp(PP), vpp(Num, VP).

% Preposition, Adjectives 처리
pp(pp(Preposition, NP)) --> prep(Preposition), npp(_, NP).

ap(_, ap(Adverb, APA)) --> adv(adjective, Adverb), apa(APA).
ap(Num, ap(Determiner, APA)) --> det(Num, Determiner), apa(APA).
ap(Num, ap(Determiner, Adverb, APA)) --> det(Num, Determiner), adv(adjective, Adverb), apa(APA).

apa(Adjectives) --> adj(Adjectives).
apa(ap(Adjectives, APA)) --> adj(Adjectives), apa(APA).