deuxieme_etape(Abi,Abi1,Tbox) :-
saisie_et_traitement_prop_a_demontrer(Abi,Abi1,Tbox).

saisie_et_traitement_prop_a_demontrer(Abi,Abi1,Tbox) :- 
    nl,
    write('Entrez   le   numero   du   type   de   proposition   que   vous   voulez demontrer :'),
    nl,
    write('1 Une instance donnee appartient a un concept donne.'),
    nl,
    write('2 Deux concepts n"ont pas d"elements en commun(ils ont une intersection vide).'),
    nl,
    read(R),
    suite(R,Abi,Abi1,Tbox).
    
suite(1,Abi,Abi1,Tbox) :-    acquisition_prop_type1(Abi,Abi1,Tbox),!.
suite(2,Abi,Abi1,Tbox) :-    acquisition_prop_type2(Abi,Abi1,Tbox),!.
% suite(R,Abi,Abi1,Tbox) :-    nl,write('Cette reponse est incorrecte.'),nl,
%                             saisie_et_traitement_prop_a_demontrer(Abi,Abi1,Tbox).

acquisition_prop_type1(Abi,Abi1,Tbox) :-write('Entrer le concept et l"instance en [I,C].'),nl,read([I,C]),
                                        ajouter1(I,C,Abi,Abi1,Tbox).

ajouter1(I,C,Abi,[Abi,(I,NF)],Tbox):- member((_,C),Abi),!,not(member((C,_),Tbox)),nnf(not(C),NF).

ajouter1(I,C,Abi,[Abi,(I,NF)],Tbox):-not(member((_,C),Abi)),member((C,CC),Tbox),!,nnf(not(CC),NF).

acquisition_prop_type2(Abi,Abi1,Tbox) :-write('Entrer duex concepts en [C1,C2].'),nl,read([C1,C2]),
                                        ajouter2(C1,C2,Abi,Abi1,Tbox).

ajouter2(C1,C2,Abi,[Abi,(inst,NF)],Tbox):- not(member((_,C1),Abi)),not(member((_,C2),Abi)),member((C1,CC1),Tbox),!,member((C2,CC2),Tbox),!,nnf((and(CC1,CC2)),NF).
ajouter2(C1,C2,Abi,[Abi,(inst,NF)],Tbox):- (member((_,C1),Abi)),(member((_,C2),Abi)),not(member((C1,_),Tbox)),nnf((and(C1,C2)),NF).
ajouter2(C1,C2,Abi,[Abi,(inst,NF)],Tbox):- not(member((_,C1),Abi)),member((_,C2),Abi),member((C1,CC1),Tbox),!,nnf((and(CC1,C2)),NF).
ajouter2(C1,C2,Abi,[Abi,(inst,NF)],Tbox):- member((_,C1),Abi),not(member((_,C2),Abi)),member((C2,CC2),Tbox),!,nnf((and(C1,CC2)),NF).




