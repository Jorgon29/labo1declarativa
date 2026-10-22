d(Var, Func, 1):-
    Var == Func.

d(Var, Func, 0):-
    atomic(Var),
    number(Func).

d(Var, N*Var, N):-
    atomic(Var),
    number(N).

d(Var, Var^N, N*Var^Nm1):-
    atomic(Var),
    number(N),
    Nm1 is N - 1.

d(Var, K*Var^N, C*Var^Nm1):-
    atomic(Var),
    number(K),
    number(N),
    C is K*N,
    Nm1 is N - 1.

d(Var, log(Var), 1/Var):-
    atomic(Var).

s(Var, K, K*Var):-
    atomic(Var),
    number(K).

s(Var, Var, 1/2*Var^2):-
    atomic(Var).

s(Var, K*Var^N, K/M*Var^M):-
    atomic(Var),
    number(K),
    number(N),
    M is N + 1.

simplificar(Var, Expr, R) :-
    terminos(Expr, 1, Var, Pares),
    combinar(Pares, Combinado),
    armar(Var, Combinado, R).

terminos(A+B, S, V, P) :- !,
    terminos(A, S, V, PA),
    terminos(B, S, V, PB),
    append(PA, PB, P).
terminos(A-B, S, V, P) :- !,
    S2 is -S,
    terminos(A, S,  V, PA),
    terminos(B, S2, V, PB),
    append(PA, PB, P).
terminos(-A, S, V, P) :- !,
    S2 is -S,
    terminos(A, S2, V, P).
terminos(T, S, V, [C-N]) :-
    parsear(T, V, C0, N),
    C is S*C0.

parsear(K, _, K, 0)    :- number(K), !.
parsear(V, V, 1, 1)    :- !.
parsear(V^N, V, 1, N)  :- number(N), !.
parsear(K*V, V, K, 1)  :- number(K), !.
parsear(K*V^N, V, K, N) :- number(K), number(N), !.

combinar([], []).
combinar([C-N|T], [Sum-N|Cola]) :-
    sumar_semejantes(T, N, C, Sum, Otros),
    combinar(Otros, Cola).

sumar_semejantes([], _, S, S, []).
sumar_semejantes([C-N|T], N, Acc, S, Otros) :- !,
    Acc1 is Acc + C,
    sumar_semejantes(T, N, Acc1, S, Otros).
sumar_semejantes([P|T], N, Acc, S, [P|Otros]) :-
    sumar_semejantes(T, N, Acc, S, Otros).

armar(V, Pares, R) :-
    quitar_ceros(Pares, Qs),
    (   Qs = []
    ->  R = 0
    ;   Qs = [P|T],
        mono(V, P, M),
        sumar_terminos(V, T, M, R)
    ).

quitar_ceros([], []).
quitar_ceros([C-N|T], R) :-
    (   C =:= 0
    ->  R = Cola
    ;   R = [C-N|Cola]
    ),
    quitar_ceros(T, Cola).

sumar_terminos(_, [], Acc, Acc).
sumar_terminos(V, [C-N|T], Acc, R) :-
    (   C < 0
    ->  Cp is -C, mono(V, Cp-N, M), Acc1 = Acc-M
    ;   mono(V, C-N, M), Acc1 = Acc+M
    ),
    sumar_terminos(V, T, Acc1, R).

mono(_, C-0, C) :- !.
mono(V, 1-1, V) :- !.
mono(V, C-1, C*V) :- !.
mono(V, 1-N, V^N) :- !.
mono(V, C-N, C*V^N).