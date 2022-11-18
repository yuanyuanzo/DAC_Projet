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
flatten(and(C,D),[and, L1,L2]):-flatten(C,L1),flatten(D,L2),!.
flatten(or(C,D),[or,L1,L2]):-flatten(C,L1),flatten(D,L2),!.
flatten(some(R,C),[some,R,L]):-verif_Role(R),flatten(C,L),!.
flatten(all(R,C),[all,R,L]):-verif_Role(R),flatten(C,L),!.
flatten(not(C),[not,L]):-flatten(C,L),!.

autoref(C):-flatten(C,L),my_flatten(L,L1),member(C,L1),!.


% Création d'un Tbox
prolonge(A,A):-cnamea(A),!.
prolonge(A,L):-cnamena(A),equiv(A,B),verif_Concept(B),prolonge(B,L). % si c'est non-atomique, on le transforme en atomique
prolonge(and(C,D),and(L1,L2)):-prolonge(C,L1),prolonge(D,L2),!.
prolonge(or(C,D),or(L1,L2)):-prolonge(C,L1),prolonge(D,L2),!.
prolonge(some(R,C),some(R,L)):-verif_Role(R),prolonge(C,L),!.
prolonge(all(R,C),all(R,L)):-verif_Role(R),prolonge(C,L),!.
prolonge(not(C),not(L)):-prolonge(C,L),!.


creation_Tbox(L):- setof((CA,CG), equiv(CA,CG), L).
traitement_Tbox([],[]).
traitement_Tbox([(CA,CG)|L],[(CA,NF)|L1]):-prolonge(CG,CG1),nnf(CG1,NF),traitement_Tbox(L,L1).

% Création de Abox
creation_Abox(L1,L2):- setof((CA,NF), inst(CA,NF),L1), setof((CA,CB,CD), instR(CA,CB,CD),L2).
traitement_Abox1([],[]).
traitement_Abox1([(CA,CG)|L],[(CA,NF)|L1]):-prolonge(CG,CG1),nnf(CG1,NF),traitement_Abox1(L,L1).
traitement_Abox2([],[]).
traitement_Abox2([(CA,CB,CD)|L],[(CA,CB,NF)|L1]):-prolonge(CD,CD1),nnf(CG1,NF),traitement_Abox2(L,L1).
traitement_Abox(L1,L2,LL1,LL2):-traitement_Abox1(L1,LL1),traitement_Abox2(L2,LL2).
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











