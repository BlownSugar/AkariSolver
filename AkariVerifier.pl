% Main verification predicate.
% Main verification predicate.
verify(Board, Solution) :-
    (   validate_board(Board, Solution),
        \+ illuminates_another_bulb(Solution),
        all_cells_lit(Board, Solution)
    ->  write('true')
    ;   write('false')
    ).


% Validate each cell of the board.
validate_board(Board, Solution) :-
    findall((X,Y), (between(1,10,X), between(1,10,Y)), Positions),
    maplist(validate_cell(Board, Solution), Positions).

% Define the behavior of each type of cell.
validate_cell(Board, Solution, (X, Y)) :-
    get_cell(Board, X, Y, Cell),
    get_cell(Solution, X, Y, Light),
    validate_individual_cell(Cell, Light, Solution, X, Y).

validate_individual_cell('#', 0, _, _, _).  % Walls cannot have a light.
validate_individual_cell('.', Light, Solution, X, Y) :-  % An empty cell can have a light or not.
    member(Light, [0, 1]),
    (Light = 1 -> \+illuminates_another_bulb_at(Solution, X, Y); true).
validate_individual_cell(N, 0, Solution, X, Y) :-  % Numbered walls cannot have a light and should have N adjacent lights.
    atom_number(N, N2),
    find_adjacent_cells(Solution, X, Y, AdjacentCells),
    count_lights(AdjacentCells, Count),
    Count =:= N2.

get_cell(Board, X, Y, Cell) :-
    nth1(Y, Board, Row),
    nth1(X, Row, Cell).

find_adjacent_cells(Board, X, Y, AdjacentCells) :-
    findall(Cell, (adjacent(X, Y, X1, Y1), get_cell(Board, X1, Y1, Cell)), AdjacentCells).

adjacent(X, Y, X, Y1) :- member(DY, [-1, 1]), Y1 is Y + DY, between(1,10,Y1).
adjacent(X, Y, X1, Y) :- member(DX, [-1, 1]), X1 is X + DX, between(1,10,X1).

count_lights(Cells, Count) :-
    include(=(1), Cells, Lights),
    length(Lights, Count).

check_direction_bulb(Board, X, Y, DX, DY) :-
    X1 is X + DX,
    Y1 is Y + DY,
    between(1, 10, X1),
    between(1, 10, Y1),
    get_cell(Board, X1, Y1, Cell),
    (Cell = 1 ; Cell = '#'),
    !,
    Cell = 1.

check_direction_light(Board, X, Y, DX, DY) :-
    X1 is X + DX,
    Y1 is Y + DY,
    between(1, 10, X1),
    between(1, 10, Y1),
    get_cell(Board, X1, Y1, Cell),
    (Cell \= '#' ; Cell = 1).

% Predicate to check if a bulb illuminates another bulb.
illuminates_another_bulb(Solution) :-
    findall((X,Y), (get_cell(Solution, X, Y, 1), 
    (   check_direction_bulb(Solution, X, Y, 0, 1)
    ;   check_direction_bulb(Solution, X, Y, 0, -1)
    ;   check_direction_bulb(Solution, X, Y, 1, 0)
    ;   check_direction_bulb(Solution, X, Y, -1, 0)
    )), Bulbs),
    Bulbs \= [].

illuminates_another_bulb_at(Solution, X, Y) :-
    (   check_direction_bulb(Solution, X, Y, 0, 1)
    ;   check_direction_bulb(Solution, X, Y, 0, -1)
    ;   check_direction_bulb(Solution, X, Y, 1, 0)
    ;   check_direction_bulb(Solution, X, Y, -1, 0)
    ).

% Predicate to check if all cells are lit.
all_cells_lit(Board, Solution) :-
    \+ (  get_cell(Board, X, Y, Cell),
          Cell \= '#',
          \+ (   check_direction_light(Solution, X, Y, 1, 0)
              ;   check_direction_light(Solution, X, Y, -1, 0)
              ;   check_direction_light(Solution, X, Y, 0, 1)
              ;   check_direction_light(Solution, X, Y, 0, -1)
              )
       ).


/* verify([['#', '.', '.', '.', '.', '.', '.', '.', '.', '#'],
       ['.', '.', '2', '#', '.', '.', '.', '.', '.', '.'],
       ['.', '.', '#', '.', '.', '#', '.', '3', '#', '.'],
       ['.', '.', '.', '4', '.', '.', '#', '.', '2', '.'],
       ['.', '.', '#', '.', '.', '.', '.', '.', '.', '.'],
       ['.', '.', '.', '.', '.', '.', '.', '#', '.', '.'],
       ['.', '#', '.', '#', '.', '.', '4', '.', '.', '.'],
       ['.', '1', '3', '.', '#', '.', '.', '3', '.', '.'],
       ['.', '.', '.', '.', '.', '.', '#', '1', '.', '.'],
       ['#', '.', '.', '.', '.', '.', '.', '.', '.', '#']],[[0, 0, 1, 0, 0, 0, 0, 0, 0, 0],
       [0, 1, 0, 0, 0, 0, 0, 1, 0, 0],
       [0, 0, 0, 1, 0, 0, 1, 0, 0, 0],
       [0, 0, 1, 0, 1, 0, 0, 1, 0, 1],
       [0, 0, 0, 1, 0, 0, 0, 0, 0, 0],
       [0, 0, 0, 0, 0, 0, 1, 0, 0, 0],
       [0, 0, 1, 0, 0, 1, 0, 1, 0, 0],
       [1, 0, 0, 1, 0, 0, 1, 0, 1, 0],
       [0, 0, 1, 0, 0, 0, 0, 0, 0, 0],
       [0, 0, 0, 0, 0, 0, 0, 1, 0, 0]])
*/