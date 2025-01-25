:- use_module(library(pce)).

% 구문 트리 시각화 시작점
visualize(Tree) :-
    new(Window, picture('Syntax Parsing Tree')), % 캔버스 생성
    send(Window, size, size(1920, 1080)),         % 캔버스 크기 설정
    send(Window, open),                         % 창 열기
    X is 1920 // 3 + 100, draw_tree(Window, Tree, X, 50, 400),      % 트리 그리기 (중앙에서 시작)
    send(Window, flush).                        % 화면 갱신

% 트리 그리기
draw_tree(_, atomic(Value), X, Y, _) :- % 리프 노드 처리
    draw_node(_, Value, X, Y).
draw_tree(Window, Node, X, Y, Offset) :-
    Node =.. [Label | Children],       % 노드를 functor와 자식 리스트로 분해
    draw_node(Window, Label, X, Y),   % 현재 노드(Label) 그리기
    NewY is Y + 80,                   % 자식 노드의 Y 좌표 계산
    draw_children(Window, Children, X, NewY, Offset). % 자식 노드 그리기

% 자식 노드 그리기
draw_children(_, [], _, _, _) :- !. % 자식 노드가 없으면 종료

draw_children(Window, [Child], X, Y, Offset) :- % 자식이 하나만 있을 경우
    draw_edge(Window, X, Y - 80, X, Y),         % 부모-자식 간선
    draw_tree(Window, Child, X, Y, Offset // 2).

draw_children(Window, [Left, Right], X, Y, Offset) :- % 자식이 두 개일 경우
    % 왼쪽 자식 그리기
    NewXLeft is X - Offset,
    draw_edge(Window, X, Y - 80, NewXLeft, Y),
    draw_tree(Window, Left, NewXLeft, Y, Offset // 2),
    % 오른쪽 자식 그리기
    NewXRight is X + Offset,
    draw_edge(Window, X, Y - 80, NewXRight, Y),
    draw_tree(Window, Right, NewXRight, Y, Offset // 2).

draw_children(Window, [Left, Middle, Right], X, Y, Offset) :- % 자식이 세 개일 경우
    % 왼쪽 자식 그리기
    NewXLeft is X - Offset,
    draw_edge(Window, X, Y - 80, NewXLeft, Y),
    draw_tree(Window, Left, NewXLeft, Y, Offset // 2),
    % 중간 자식 그리기
    NewXMiddle is X,
    draw_edge(Window, X, Y - 80, NewXMiddle, Y),
    draw_tree(Window, Middle, NewXMiddle, Y, Offset // 2),
    % 오른쪽 자식 그리기
    NewXRight is X + Offset,
    draw_edge(Window, X, Y - 80, NewXRight, Y),
    draw_tree(Window, Right, NewXRight, Y, Offset // 2).


% 노드 그리기
draw_node(Window, Value, X, Y) :-
    send(Window, display, text(Value), point(X-7, Y-8)).  % 노드 값 표시

% 간선(Edge) 그리기
draw_edge(Window, X1, Y1, X2, Y2) :-
    send(Window, display, line(X1, Y1+10, X2, Y2-10)).
