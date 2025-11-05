%factos
house(1..5). %esquerda pa direita
color(red;blue;white;orange;green).
man(miguel;joao;pedro;daniel;carlos).
club(academica;benfica;belenenses;fcporto;sporting).
drink(sumol;tea;coffee;milk;water).
woman(maria;carla;paula;filipa;ana).
animal(parrot;fox;turtle;horse;cat).

pref(miguel,paula,5).
pref(miguel,ana,4).
pref(miguel,maria,3).
pref(miguel,carla,2).
pref(miguel,filipa,1).

pref(maria,carlos,5).
pref(maria,miguel,4).
pref(maria,daniel,3).
pref(maria,joao,2).
pref(maria,pedro,1).

pref(joao,maria,5).
pref(joao,paula,4).
pref(joao,carla,3).
pref(joao,filipa,2).
pref(joao,ana,1).

pref(paula,daniel,5).
pref(paula,carlos,4).
pref(paula,joao,3).
pref(paula,miguel,2).
pref(paula,pedro,1).

pref(pedro,paula,5).
pref(pedro,carla,4).
pref(pedro,ana,3).
pref(pedro,filipa,2).
pref(pedro,maria,1).

pref(carla,miguel,5).
pref(carla,daniel,4).
pref(carla,joao,3).
pref(carla,pedro,2).
pref(carla,carlos,1).

pref(daniel,maria,5).
pref(daniel,carla,4).
pref(daniel,paula,3).
pref(daniel,filipa,2).
pref(daniel,ana,1).

pref(filipa,pedro,5).
pref(filipa,joao,4).
pref(filipa,daniel,3).
pref(filipa,miguel,2).
pref(filipa,carlos,1).

pref(carlos,ana,5).
pref(carlos,carla,4).
pref(carlos,paula,3).
pref(carlos,maria,2).
pref(carlos,filipa,1).

pref(ana,daniel,5).
pref(ana,joao,4).
pref(ana,pedro,3).
pref(ana,carlos,2).
pref(ana,miguel,1).

%geradores
1{married(M, F) : man(M)}1 :- woman(F). %cada mulher tem 1 marido
1{married(M, F) : woman(F)}1 :- man(M). %cada homem tem 1 esposa

1{lives(M, F, H) : house(H)}1 :- married(M,F). %cada casal vive em 1 casa
1{lives(M,F, H) : married(M,F)}1 :- house(H). %cada casa tem 1 casal

1{hasColor(H,C): color(C)}1 :- house(H). %cada casa tem 1 cor
1{hasColor(H,C) : house(H)}1 :- color(C). %cada cor é de 1 casa

1{pet(F,A) : animal(A)}1 :- woman(F). %cada mulher é dona de 1 animal
1{pet(F,A) : woman(F)}1 :- animal(A). %cada animal tem 1 dona

1{adept(M,C) : club(C)}1 :- man(M). %cada homem é adepto de 1 clube
1{adept(M,C) : man(M)}1 :- club(C). %cada clube tem apenas 1 adepto

%1{son(S,P) : man(P)}1 :- man(S). %cada filho tem 1 pai
%0{son(S,P) : man(S)}2 :- man(P). %cada pai tem até 2 filhos

1{drinks(M,D) : drink(D)}1 :- man(M). %cada homem bebe 1 bebida
1{drinks(M,D) : man(M)}1 :- drink(D). %cada bebida tem apenas 1 homem

%definir vizinho lado específico
neighbour_R(H,H1) :- house(H), house(H1), H1 = H + 1.
neighbour_L(H,H1) :- house(H), house(H1), H1 = H - 1.

%definir vizinho
neighbour(H,H1) :- house(H1), house(H), H1 = H + 1.
neighbour(H,H1) :- house(H1), house(H), H1 = H - 1.

%definir casa do animal

pethouse(P,H) :- lives(_,F,H), pet(F,P).

%O Miguel é filho do João.
son(miguel,joao).

%O João é filho do Pedro.
son(joao,pedro).

%O Daniel é filho do Pedro.
son(daniel,pedro).

%O Carlos é filho do Daniel.
son(carlos,daniel).

%O pai(Daniel) do Carlos vive na casa vermelha.
:- son(carlos, P), lives(P,_,H), not hasColor(H,red).

%A mulher do Miguel é dona do papagaio.
:- married(miguel,F), not pet(F,parrot).

%O avô(Pedro) do Carlos vive na primeira casa à esquerda.
:- son(carlos, P), son(P,A), not lives(A,_,1).

%Na casa laranja é-se adepto do F.C. Porto.
:- hasColor(H,orange), lives(M,_,H), not adept(M,fcporto).

%O adepto da Académica vive na casa ao lado da dona da raposa.
:- adept(M,academica), lives(M,_,H1),
   pet(F,fox),          lives(_,F,H2),
   not neighbour(H1,H2).

%O Pedro vive ao lado da casa azul.
auxblue :- lives(pedro,_,H1), house(H1), neighbour(H1,H), hasColor(H,blue).
:- not auxblue.

%A mulher do adepto do Sporting tem uma tartaruga. 
:- adept(M,sporting), married(M,F), not pet(F,turtle).

%O adepto do Benfica bebe sumol.
:- adept(M,benfica), not drinks(M,sumol).

%O pai(João) do Miguel bebe chá. 
:- son(miguel,P), not drinks(P,tea).

%O filho(Carlos) do Daniel é adepto do Belenenses.
:- son(S, daniel), not adept(S, belenenses).

%É adepto do F.C. Porto o morador da casa ao lado da casa onde mora a mulher que é dona do cavalo.
auxporto :- lives(_,F,H), pet(F,horse), lives(M1,_,H1), neighbour(H,H1), adept(M1,fcporto).
:- not auxporto.

%Na casa verde bebe-se café.
:- hasColor(H,green), lives(M,_,H), not drinks(M,coffee). 

%A casa verde fica imediatamente à direita da casa branca. 
:- hasColor(H,white), hasColor(H1,green), not neighbour_R(H,H1).

%Na casa do meio bebe-se leite. 
:- lives(M,_,3), not drinks(M,milk).

%O Pedro é casado com a Ana
married(pedro,ana).

%O Carlos não é casado com a Maria. 
:- married(carlos,maria).

%casamentos instáveis
%do lado do homem
unstable(M,F) :- 
  married(M,F), 
  married(M1,F1), 
  pref(M,F,Nm1), 
  pref(M,F1,Nm2), 
  pref(F1,M,Nf1), 
  pref(F1, M1, Nf2), 
  Nf1>Nf2, Nm2>Nm1.

%do lado da mulher
unstable(M,F) :- 
  married(M,F), married(M1,F1), 
  pref(M1,F,Nm1), pref(M1,F1,Nm2), 
  pref(F,M,Nf1), pref(F, M1, Nf2), 
  Nm1>Nm2, Nf2>Nf1.

:- unstable(_, _).

%#show man/1.
%#show son/2.
#show lives/3.
%#show unstable/2.
%#show hasColor/2.
#show pethouse/2.
%#show adept/2.
%#show drinks/2.
%#show married/2.
#show pet/2.
