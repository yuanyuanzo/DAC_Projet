% Vérification sémantique : 
% Prédicat "Alphabet"

% On vérifie la grammaire de la logique ALC (sujet I.3)
verif_Concept(not(C)) :- verif_Concept(C), !.
verif_Concept(and(C1, C2)) :- verif_Concept(C1), verif_Concept(C2), !.
verif_Concept(or(C1, C2)) :- verif_Concept(C1), verif_Concept(C2), !.
verif_Concept(some(R, C)) :- verif_Role(R), verif_Concept(C), !.
verif_Concept(all(R, C)) :- verif_Role(R), verif_Concept(C), !.

verif_Concept(C) :- cnamea(C), !. % Vérification des concepts atomique
verif_Concept(CG) :- cnamena(CG), !. % Vérification des concepts non atomique
verif_Instance(I) :- iname(I), !. % Vérification des identificateurs d'instance
verif_Role(R) :- rname(R), !. % Vérification des identificateurs de rôle.

% Vérification syntaxique
% Pour autoref

flatten(A,A):-cnamea(A),!.
flatten(A,L):-cnamena(A),equiv(A,B),flatten(B,L). % si c'est non-atomique, on le transforme en atomique
flatten(and(C,D),[L1,L2]):-flatten(C,L1),flatten(D,L2),!.
flatten(or(C,D),[L1,L2]):-flatten(C,L1),flatten(D,L2),!.
flatten(some(R,C),L):-verif_Role(R),flatten(C,L),!.
flatten(all(R,C),L):-verif_Role(R),flatten(C,L),!.
flatten(not(C),L):-flatten(C,L),!.

autoref(C):-flatten(C,L),my_flatten(L,L1),member(C,L1),!.




% Création d'un Tbox
relation(X,Y,and):-and(X,Y),!.
relation(X,Y,or):-or(X,Y),!.
relation(R,C,some):-some(R,C),!.
relation(R,C,all):-all(R,C),!.
relation(X,[],not):-not(X),!.

creation_Tbox(L):- setof((CA,NF),nnf(CG,NF), equiv(CA,CG),L).

% Création d'un A
creation_Abox(L1,L2):- setof((CA,NF), inst(CA,NF),L1), setof((CA,CB,CD), instR(CA,CB,CD),L2).

% Pour la Tbox
% si c'est non-atomique, on le transforme en atomique
transformer_concept(C,CA):- cnamena(C),equiv(C,D),verif_Concept(D),transformer_concept(D,CA).



autoref(C):-flatten(C,L),my_flatten(L,L1),member(C,L1),!.
/*

% Pour la Tbox
verif_Equiv(CA, CG) :- verif_Concept(CA), verif_Concept(CG),!.
verif_Tbox([(CA, CG) | Q]) :- 
    verif_Concept(anything), 
    verif_Concept(nothing), 
    verif_Equiv(CA, CG), 
    verif_Tbox(Q).
verif_Tbox([]).


% Pour la Abox
verif_Inst(I, CG) :- verif_Instance(I), verif_Concept(CG), !.
verif_InstR(I1, I2, R) :- verif_Instance(I1), verif_Instance(I2), verif_Role(R), !.

verif_AboxC([]).
verif_AboxC([(I, CG) | Q]) :- verif_Inst(I, CG), verif_AboxC(Q), !.

verif_AboxR([]).
verif_AboxR([(I1, I2, R) | Q]) :- verif_InstR(I1, I2, R), verif_AboxR(Q), !.
*/











