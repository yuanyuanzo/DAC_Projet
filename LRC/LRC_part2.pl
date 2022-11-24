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
suite(R,Abi,Abi1,Tbox) :-    nl,write('Cette reponse est incorrecte.'),nl,
                             saisie_et_traitement_prop_a_demontrer(Abi,Abi1,Tbox).

acquisition_prop_type1(Abi,Abi1,Tbox) :-



