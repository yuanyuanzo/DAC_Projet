% Donne par l"enonce"
compteur(1).
troisieme_etape(Abi,Abr) :- nl,nl,
                                write('Abox ins = '),write(Abi),nl,nl,
                                write('Abox relation = '),write(Abr),nl,nl,
                             tri_Abox(Abi,Lie,Lpt,Li,Lu,Ls),
                             create_ABR(Abr,Abi,Abe),
                             write('Abe = '),write(Abe),nl,
                             resolution(Lie,Lpt,Li,Lu,Ls,Abe),
                             nl,write('Youpiiiiii, on a demontre la proposition initiale !!!').

% Classement des formules dans Abox,les renvoyer dans 5 listes
tri_Abox([],[],[],[],[],[]).
tri_Abox([(I,some(R,C))|Abi],[(I,some(R,C))|Lie],Lpt,Li,Lu,Ls):-tri_Abox(Abi,Lie,Lpt,Li,Lu,Ls),!.
tri_Abox([(I,all(R,C))|Abi],Lie,[(I,all(R,C))|Lpt],Li,Lu,Ls):-tri_Abox(Abi,Lie,Lpt,Li,Lu,Ls),!.
tri_Abox([(I,and(C1,C2))|Abi],Lie,Lpt,[(I,and(C1,C2))|Li],Lu,Ls):-tri_Abox(Abi,Lie,Lpt,Li,Lu,Ls),!.
tri_Abox([(I,or(C1,C2))|Abi],Lie,Lpt,Li,[(I,or(C1,C2))|Lu],Ls):-tri_Abox(Abi,Lie,Lpt,Li,Lu,Ls),!.
tri_Abox([(I,not(C))|Abi],Lie,Lpt,Li,Lu,[(I,not(C))|Ls]):-tri_Abox(Abi,Lie,Lpt,Li,Lu,Ls),!.
tri_Abox([(I,C)|Abi],Lie,Lpt,Li,Lu,[(I,C)|Ls]):-tri_Abox(Abi,Lie,Lpt,Li,Lu,Ls),!.


create_ABR(Abr,Abi,Abe):-concat(Abr,Abi,Abe).
seperate_ABR([],[],[]).
seperate_ABR([(I1,I2,R)|Abe],Abi,[(I1,I2,R)|Abr]):-seperate_ABR(Abe,Abi,Abr),!.
seperate_ABR([(I,C)|Abe],[(I,C)|Abi],Abr):-seperate_ABR(Abe,Abi,Abr),!.

complete_some([],_,_,_,_,Abe,Abe).
complete_some(Lie,Lpt,Li,Lu,Ls,Abe,Abe21):- enleve((I,some(R,C)),Lie,Lie1),
                                        enleve((I,some(R,C)),Abe,Abe1),
                                        complete_some(Lie1,Lpt,Li,Lu,Ls,Abe1,Abe2),
                                        genere(Nom),
                                        concat([(Nom,C),(I,Nom,R)],Abe2,Abe21),!.

tansformation_and(_,_,[],_,_,Abe,Abe).
tansformation_and(Lie,Lpt,Li,Lu,Ls,Abe,Abe21):- enleve((I,and(C1,C2)),Li,Li1),
                                        enleve((I,and(C1,C2)),Abe,Abe1),
                                        complete_some(Lie,Lpt,Li1,Lu,Ls,Abe1,Abe2),
                                        concat([(I,C1),(I,C2)],Abe2,Abe21),!.

deduction_all(_,[],_,_,_,Abe,Abe).
deduction_all(Lie,Lpt,Li,Lu,Ls,Abe,Abe21):- enleve((I,all(R,C)),Lpt,Lpt1),
                                        enleve((I,all(R,C)),Abe,Abe1),
                                        deduction_all(Lie,Lpt1,Li,Lu,Ls,Abe1,Abe2),
                                        member((I,II,R),Abe1),
                                        concat([(II,C)],Abe2,Abe21),!.

tranformation_or(_,_,_,[],_,Abe,Abe).
tranformation_or(Lie,Lpt,Li,Lu,Ls,Abe,[Abe21,Abe22]):- enleve((I,or(C1,C2)),Lu,Lu1),
                                        enleve((I,or(C1,C2)),Abe,Abe1),
                                        tranformation_or(Lie,Lpt,Li,Lu1,Ls,Abe1,Abe2),
                                        concat([(I,C1)],Abe2,Abe21),
                                        concat([(I,C2)],Abe2,Abe22),!.

test_collision(Abe):- member((I,C),Abe),nnf(not(C),NF),member((I, NF),Abe).


return_ABE(A1,A2,A1):-test_collision(A1),!.
return_ABE(A1,A2,A2):-test_collision(A2),!.
return_ABE(A1,A2,[A1,A2]):-not(test_collision(A1)),!,not(test_collision(A2)),!.

%%%%%%%%%%NON

resolution(Lie,Lpt,Li,Lu,Ls,Abe,Abe):- test_collision(Abe),
                                    write('Collision'),nl,
                                    write(Abe),nl,!.



%%%%%%%%%% some
resolution(Lie,Lpt,Li,Lu,Ls,Abe):- not(test_collision(Abe)),
                                    seperate_ABR(Abe,Abi,_),
                                    tri_Abox(Abi,Lie1,Lpt1,Li1,Lu1,Ls1),
                                    Lie1\=[],!,
                                    
                                    write('Lie1!=[]'),nl,
                                    write('Abi'),nl,
                                    write(Abi),nl,
                                    write('Abe'),nl,
                                    write(Abe),nl,
                                    complete_some(Lie1,Lpt1,Li1,Lu1,Ls1,Abe,Abe2),
                                    nl,write('Some'),nl,nl,
                                    write('Abe2'),nl,
                                    write(Abe2),nl,
                                    not(test_collision(Abe2)),!,
                                    resolution(Lie1,Lpt1,Li1,Lu1,Ls1,Abe2).

resolution(Lie,Lpt,Li,Lu,Ls,Abe):- not(test_collision(Abe)),
                                    seperate_ABR(Abe,Abi,_),
                                    tri_Abox(Abi,Lie1,Lpt1,Li1,Lu1,Ls1),
                                    Lie1\=[],!,
                                    write('Lie1!=[]'),nl,
                                    write('Abi'),nl,
                                    write(Abi),nl,
                                    write('Abe'),nl,
                                    write(Abe),
                                    complete_some(Lie1,Lpt1,Li1,Lu1,Ls1,Abe,Abe2),
                                    nl,nl,write('Some'),nl,nl,
                                    write('Abe2'),nl,
                                    write(Abe2),nl,nl,nl,
                                    test_collision(Abe2),!.



%ALL
resolution(Lie,Lpt,Li,Lu,Ls,Abe):- not(test_collision(Abe)),
                                    seperate_ABR(Abe,Abi,_),
                                    tri_Abox(Abi,Lie1,Lpt1,Li1,Lu1,Ls1),
                                    Lpt1\=[],!,
                                    write('Lpt1!=[]'),nl,
                                    write('Abi'),nl,
                                    write(Abi),nl,
                                    write('Abe'),nl,
                                    write(Abe),nl,
                                    deduction_all(Lie1,Lpt1,Li1,Lu1,Ls1,Abe,Abe2),
                                    nl,nl,write('All'),nl,nl,
                                    write('Abe2'),nl,
                                    write(Abe2),nl,nl,nl,
                                    not(test_collision(Abe2)),!,
                                    resolution(Lie1,Lpt1,Li1,Lu1,Ls1,Abe2).

resolution(Lie,Lpt,Li,Lu,Ls,Abe):- not(test_collision(Abe)),
                                    seperate_ABR(Abe,Abi,_),
                                    tri_Abox(Abi,Lie1,Lpt1,Li1,Lu1,Ls1),
                                    Lpt1\=[],!,
                                    write('Lpt1!=[]'),nl,
                                    write('Abi'),nl,
                                    write(Abi),nl,
                                    write('Abe'),nl,
                                    write(Abe),nl,
                                    deduction_all(Lie1,Lpt1,Li1,Lu1,Ls1,Abe,Abe2),
                                    write('All'),nl,
                                    write('Abe2'),nl,
                                    write(Abe2),nl,nl,nl,
                                    test_collision(Abe2),!.

                                    

%AND
resolution(Lie,Lpt,Li,Lu,Ls,Abe):- not(test_collision(Abe)),
                                    seperate_ABR(Abe,Abi,_),
                                    tri_Abox(Abi,Lie1,Lpt1,Li1,Lu1,Ls1),

                                    Li1\=[],!,
                                    write('Li1!=[]'),nl,
                                    write('Abi'),nl,
                                    write(Abi),nl,
                                    write('Abe'),nl,
                                    write(Abe),nl,
                                    tansformation_and(Lie1,Lpt1,Li1,Lu1,Ls1,Abe,Abe2),
                                    nl,nl,write('AND'),nl,nl,
                                    write('Abe2'),nl,
                                    write(Abe2),nl,nl,nl,
                                    not(test_collision(Abe2)),!,
                                    resolution(Lie1,Lpt1,Li1,Lu1,Ls1,Abe2).

resolution(Lie,Lpt,Li,Lu,Ls,Abe):- not(test_collision(Abe)),
                                    seperate_ABR(Abe,Abi,_),
                                    tri_Abox(Abi,Lie1,Lpt1,Li1,Lu1,Ls1),
                                    Li1\=[],!,
                                    write('Li1!=[]'),nl,
                                    write('Abi'),nl,
                                    write(Abi),nl,
                                    write('Abe'),nl,
                                    write(Abe2),nl,nl,nl,
                                    tansformation_and(Lie1,Lpt1,Li1,Lu1,Ls1,Abe,Abe2),
                                    write('AND'),nl,
                                    write('test_collision Abe'),nl,
                                    write(Abe2),nl,
                                    write('Abe2'),nl,
                                    test_collision(Abe2),!.


%OR
/*
resolution(Lie,Lpt,Li,Lu,Ls,Abe,Abe3):- not(test_collision(Abe)),
                                    seperate_ABR(Abe,Abi,_),!,
                                    tri_Abox(Abi,Lie1,Lpt1,Li1,Lu1,Ls1),
                                    Lu1\=[],!,
                                    write('Trans_or'),nl,
                                    tranformation_or(Lie1,Lpt1,Li1,Lu1,Ls1,Abe,[Abe21,Abe22]),
                                    return_ABE(Abe21,Abe22,A1),
                                    resolution(Lie,Lpt,Li,Lu,Ls,A1,Abe3),
                                    write('Abe1='),nl,
                                    write(Abe21),nl,
                                    write('Abe2='),nl,
                                    write(Abe22),nl.
                                   
%%%%%%%%%%FAIL
resolution(Lie,Lpt,Li,Lu,Ls,Abe,Abe):- not(test_collision(Abe)),
                                    seperate_ABR(Abe,Abi,_),
                                    tri_Abox(Abi,Lie1,Lpt1,Li1,Lu1,Ls1),
                                    Lie1=[],!,Lpt1=[],!,Li1=[],!,Lu1=[],!,
                                    write('Fail to match any rule'),nl,
                                    write(Abe),!.nl.
                                    
*/

