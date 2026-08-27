% Ver los personajes segun la dificultad del lugar en el que estan, si hay uno en dos lugares de la misma, aparece dos veces. Se excluyen enemigos.

personajes_en_zona_de_dificultad(Dificultad, R):-
    dificultad(L, Dificultad),
    ubicado(R, L),
    \+infectado(R, _).

% Revisar si algo X comparte ubicacion con algo Y
misma_ubicacion(X, Y) :-
    ubicado(X, L),
    ubicado(Y, L),
    \==(X, Y).

% Revisa si X es de mayor edad que Y.
tiene_mayor_edad(X, Y) :-
    edad(X, E1),
    edad(Y, E2),
    <(E1, E2).