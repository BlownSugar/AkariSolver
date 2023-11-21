% Definitions
wall('#').
numbered_wall(N) :- member(N, ['0', '1', '2', '3', '4']).

% Lamp predicate - to use numbers as atoms, single quotes are necessary
lamp('1').

lamp_placement_blank(Cell) :- empty(Cell).

empty('.').
% A cell is empty if it is not a wall, a lamp, or a numbered wall
empty(Cell) :- \+ wall(Cell), \+ lamp(Cell), \+ numbered_wall(Cell).


% An empty cell that is not a lamp but can be illuminated or a numbered wall is considered blank
blank(Cell) :- empty(Cell); numbered_wall(Cell).

% Valid board position
valid_position(X, Y) :- between(0, 9, X), between(0, 9, Y).

% Get the cell at a specific position
get_cell(Board, X, Y, Cell) :- nth0(Y, Board, Row), nth0(X, Row, Cell).

% Set the cell at a specific position
set_cell(Board, X, Y, Value, UpdatedBoard) :-
  nth0(Y, Board, OldRow),
  replace_in_list(OldRow, X, Value, NewRow),
  replace_in_list(Board, Y, NewRow, UpdatedBoard).

% Replaces an item in a list
replace_in_list([_|T], 0, X, [X|T]).
replace_in_list([H|T], I, X, [H|R]) :-
  I > 0,
  NI is I-1,
  replace_in_list(T, NI, X, R).

% Check if cell is illuminated by a lamp
is_illuminated(Board, X, Y) :-
  (check_direction(Board, X, Y, -1, 0); % left
  check_direction(Board, X, Y, 1, 0); % right
  check_direction(Board, X, Y, 0, -1); % up
  check_direction(Board, X, Y, 0, 1)). % down

% Check a specific direction for a lamp
check_direction(Board, X, Y, DX, DY) :-
  X1 is X + DX, Y1 is Y + DY,
  valid_position(X1, Y1),
  get_cell(Board, X1, Y1, Cell),
  (lamp(Cell); (blank(Cell), check_direction(Board, X1, Y1, DX, DY))).

% Solver
akari_solver(Board, Solution) :- solve(Board, Solution).

solve(Board, Board) :- check_board(Board). % Stop condition - valid solution found
solve(Board, Solution) :-
  (blank_cell(Board, X, Y) -> 
    (get_cell(Board, X, Y, Cell), lamp_placement_blank(Cell),
    set_cell(Board, X, Y, '1', UpdatedBoard1), solve(UpdatedBoard1, Solution)  
    ; set_cell(Board, X, Y, '.', UpdatedBoard2), solve(UpdatedBoard2, Solution)  
    )
  ; Board = Solution  
  ).

% Get a blank cell
blank_cell(Board, X, Y) :-
  get_cell(Board, X, Y, Cell),
  blank(Cell),
  \+ is_illuminated(Board, X, Y).

% Check if the board is a valid solution
check_board(Board) :-
  forall(blank_cell(Board, X, Y), is_illuminated(Board, X, Y)),
  forall((valid_position(X, Y), get_cell(Board, X, Y, Cell), numbered_wall(Cell)), correct_number_of_adjacent_lamps(Board, X, Y)).

% Checks if a numbered wall has the correct number of adjacent lamps
correct_number_of_adjacent_lamps(Board, X, Y) :-
  get_cell(Board, X, Y, Cell),
  atom_number(Cell, N), % gets the number on the wall
  findall((X1, Y1), (adjacent(X, Y, X1, Y1), get_cell(Board, X1, Y1, Cell1), lamp(Cell1)), AdjacentLamps),
  length(AdjacentLamps, N). % checks if the number of adjacent lamps equals to the number on the wall

% Gets all adjacent cells
adjacent(X, Y, X1, Y1) :-
  adjacent_dx_dy(DX, DY),
  X1 is X + DX, Y1 is Y + DY,
  valid_position(X1, Y1).

adjacent_dx_dy(-1, 0). % left
adjacent_dx_dy(1, 0).  % right
adjacent_dx_dy(0, -1). % up
adjacent_dx_dy(0, 1).  % down
