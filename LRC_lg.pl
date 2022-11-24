% nnf()
nnf(not(and(C1, C2)), or(NC1, NC2)) :- nnf(not(C1), NC1), nnf(not(C2), NC2), !.
nnf(not(or(C1, C2)), and(NC1, NC2)) :- nnf(not(C1), NC1), nnf(not(C2), NC2), !.
nnf(not(all(R, C)), some(R, NC)) :- nnf(not(C), NC), !.
nnf(not(some(R, C)), all(R, NC)) :- nnf(not(C), NC), !.
nnf(not(not(X)), X) :-!.
nnf(not(X), not(X)) :-!.
nnf(and(C1, C2), and(NC1, NC2)) :- nnf(C1, NC1), nnf(C2, NC2), !.
nnf(or(C1, C2), or(NC1, NC2)) :- nnf(C1, NC1),  nnf(C2, NC2), !.
nnf(some(R, C), some(R, NC)) :- nnf(C, NC), !.
nnf(all(R, C), all(R, NC)) :- nnf(C, NC), !.
nnf(X, X).

% equiv(ConceptNonAtom, ConceptCGen)
equiv(sculpteur, and(personne, some(aCree, sculpture))).
equiv(auteur, and(personne, some(aEcrit, livre))).
equiv(editeur, and(personne, and(not(some(aEcrit, livre)), some(aEdite, livre)))).
equiv(parent, and(personne, some(aEnfant, anything))).
% cnamea(ConceptAtom)
cnamea(personne).
cnamea(livre).
cnamea(objet).
cnamea(sculpture).
cnamea(anything).
cnamea(nothing).
% cnamena(ConceptNonAtom)
cnamena(auteur).
cnamena(editeur).
cnamena(sculpteur).
cnamena(parent).
% iname(Instance)
iname(michelAnge).
iname(david).
iname(sonnets).
iname(vinci).
iname(joconde).
% rname(Role)
rname(aCree).
rname(aEcrit).
rname(aEdite).
rname(aEnfant).
% inst(Instance, ConceptGen)
inst(michelAnge, personne).
inst(david, sculpture).
inst(sonnets, livre).
inst(vinci, personne).
inst(joconde, objet).
% instR(Instance1, Instance2, Role)
instR(michelAnge, david, aCree).
instR(michelAnge, sonnets, aEcrit).
instR(vinci, joconde, aCree).

% autoref: ConceptNonAtom -> boolean
autoref(CNA) :- equiv(CNA, CG), !, not(pas_autoref(CNA, CG)).
pas_autoref(CNA, not(CG)) :- !, pas_autoref(CNA, CG).
pas_autoref(CNA, or(CG1, CG2)) :- !, pas_autoref(CNA, CG1), pas_autoref(CNA, CG2).
pas_autoref(CNA, and(CG1, CG2)) :- !, pas_autoref(CNA, CG1), pas_autoref(CNA, CG2).
pas_autoref(CNA, some(_, CG)) :- !, pas_autoref(CNA, CG).
pas_autoref(CNA, all(_, CG)) :- !, pas_autoref(CNA, CG).
pas_autoref(CNA, CG) :- !, CNA \= CG.

% test + remarque 1
test_autoref :-
    not(autoref(sculpteur)),
    not(autoref(auteur)),
    not(autoref(editeur)),
    not(autoref(parent)),
    not(pas_autoref(sculpture, and(objet, all(creePar, and(personne, some(aCree, sculpture)))))).

% concept: ConceptGen -> boolean
concept(CG) :- cnamea(CG), !.
concept(CG) :- cnamena(CG), !.
concept(not(CG)) :- !, concept(CG).
concept(or(CG1, CG2)) :- !, concept(CG1), concept(CG2).
concept(and(CG1, CG2)) :- !, concept(CG1), concept(CG2).
concept(some(R, CG)) :- !, rname(R), concept(CG).
concept(all(R, CG)) :- !, rname(R), concept(CG).

% test + remarque 2
test_concept :-
    concept(sculpteur),
    concept(auteur),
    concept(editeur),
    concept(parent),
    not(concept(and(objet, all(creePar, and(personne, some(aCree, sculpture)))))).

% traitement_Tbox: Tbox -> Tbox -> boolean
traitement_Tbox([], []) :- !.
traitement_Tbox([(CNA, CG) | Tbox], [(CNA, NNF) | TboxR]) :-
    concept(CNA),
    concept(CG),
    pas_autoref(CNA, CG),
    develop(CG, CGD),
    nnf(NNF, CGD),
    traitement_Tbox(Tbox, TboxR).

develop(not(CG), not(CGD)) :- !, develop(CG, CGD).
develop(or(CG1, CG2), or(CGD1, CGD2)) :- !, develop(CG1, CGD1), develop(CG2, CGD2).
develop(and(CG1, CG2), and(CGD1, CGD2)) :- !, develop(CG1, CGD1), develop(CG2, CGD2).
develop(some(R, CG), some(R, CGD)) :- !, develop(CG, CGD).
develop(all(R, CG), all(R, CGD)) :- !, develop(CG, CGD).
develop(CG, CGD) :- equiv(CG, CGD), !.
develop(CG, CG).

% test + remarque 3
test_traitement_Tbox :-
    traitement_Tbox([(sculpteur, and(personne, some(aCree, sculpture)))],
                    [(sculpteur, not(or(not(personne), all(aCree, not(sculpture)))))]).

% traitement_Abox: AboxI -> AboxR -> AboxI -> AboxR -> boolean
traitement_Abox([], [], [], []) :- !.
traitement_Abox([], [(I1, I2, R) | Abox2], [], [(I1, I2, R) | AboxR2]) :- !,
    iname(I1),
    iname(I2),
    rname(R),
    instR(I1, I2, R),
    traitement_Abox([], Abox2, [], AboxR2).
traitement_Abox([(I, CG) | Abox1], Abox2, [(I, CGD) | AboxR1], AboxR2) :- !,
    iname(I),
    concept(CG),
    inst(I, CG),
    develop(CG, CGD),
    traitement_Abox(Abox1, Abox2, AboxR1, AboxR2).

% test + remarque 4
test_traitement_Abox :-
    traitement_Abox([], [], [], []),
    traitement_Abox([(michelAnge, personne)], [(michelAnge, david, aCree)], [(michelAnge, personne)], [(michelAnge, david, aCree)]).

% test
test :-
    test_autoref,
    test_concept,
    test_traitement_Tbox,
    test_traitement_Abox.

premiere_etape(Tbox, AboxI, AboxR,) :-
    traitement_Tbox(Tbox, TboxR),
    traitement_Abox(AboxI, AboxR, AboxIR, AboxRR),
    write(TboxR), nl,
    write(AboxIR), nl,
    write(AboxRR), nl.