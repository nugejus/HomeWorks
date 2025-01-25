:- use_module(library(pce)).

visualize(Tree) :-
    new(Window, picture('Syntax Parsing Tree')), 
    send(Window, size, size(1920, 1080)),
    send(Window, open),
    X is 1920 // 3 + 100, draw_tree(Window, Tree, X, 50, 400),
    send(Window, flush).

draw_tree(_, atomic(Value), X, Y, _) :- 
    draw_node(_, Value, X, Y).
draw_tree(Window, Node, X, Y, Offset) :-
    Node =.. [Label | Children],
    draw_node(Window, Label, X, Y),
    NewY is Y + 80, 
    draw_children(Window, Children, X, NewY, Offset).

draw_children(_, [], _, _, _) :- !. 

draw_children(Window, [Child], X, Y, Offset) :- 
    draw_edge(Window, X, Y - 80, X, Y),
    draw_tree(Window, Child, X, Y, Offset // 2).

draw_children(Window, [Left, Right], X, Y, Offset) :- 
    NewXLeft is X - Offset,
    draw_edge(Window, X, Y - 80, NewXLeft, Y),
    draw_tree(Window, Left, NewXLeft, Y, Offset // 2),
    NewXRight is X + Offset,
    draw_edge(Window, X, Y - 80, NewXRight, Y),
    draw_tree(Window, Right, NewXRight, Y, Offset // 2).

draw_children(Window, [Left, Middle, Right], X, Y, Offset) :- 
    NewXLeft is X - Offset,
    draw_edge(Window, X, Y - 80, NewXLeft, Y),
    draw_tree(Window, Left, NewXLeft, Y, Offset // 2),
    NewXMiddle is X,
    draw_edge(Window, X, Y - 80, NewXMiddle, Y),
    draw_tree(Window, Middle, NewXMiddle, Y, Offset // 2),
    NewXRight is X + Offset,
    draw_edge(Window, X, Y - 80, NewXRight, Y),
    draw_tree(Window, Right, NewXRight, Y, Offset // 2).


draw_node(Window, Value, X, Y) :-
    send(Window, display, text(Value), point(X-7, Y-8)).

draw_edge(Window, X1, Y1, X2, Y2) :-
    send(Window, display, line(X1, Y1+10, X2, Y2-10)).
