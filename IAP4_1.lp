set(1). element(1,a). element(1,b). element(1,c).
set(2). element(2,a). element(2,c). element(2,d).
set(3). element(3,b). element(3,c).

% para cada conjunto S, escolhe exatamente um dos seus elementos.
1 { select(E) : element(S,E) } 1 :- set(S).

% mostrar respostas
#show select/1.
#show select/2.
