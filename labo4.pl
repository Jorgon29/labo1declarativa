almacenar(N, [N]):-
    <(N, 10).

almacenar(N, R):-
    >=(N, 10),
    is(D, mod(N, 10)),
    is(E, //(N, 10)),
    almacenar(E, R2),
    append([D],R2,R).