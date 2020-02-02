% Aufgabe a
istVaterVon(abraham,herb).
istVaterVon(abraham,homer).
istVaterVon(clancy,marge).
istVaterVon(clancy,patty).
istVaterVon(clancy,selma).
istVaterVon(homer,bart).
istVaterVon(homer,lisa).
istVaterVon(homer,maggie).
istMutterVon(mona,herb).
istMutterVon(mona,homer).
istMutterVon(jackie,marge).
istMutterVon(jackie,patty).
istMutterVon(jacky, selma).
istMutterVon(marge,bart).
istMutterVon(marge,lisa).
istMutterVon(marge,maggie).
istMutterVon(selma,ling).

female(mona).
female(jackie).
female(marge).
female(patty).
female(selma).
female(lisa).
female(maggie).
female(ling).
male(abraham).
male(clancy).
male(herb).
male(homer).
male(bart).

istVorfahre(P1,P2):-istMutterVon(P1,P2);istVaterVon(P1,P2).

sindGeschwister(P1,P2):-istVorfahre(Eltern,P1),istVorfahre(Eltern,P2),
                                     \+(P1=P2).

istSchwesterVon(P1,P2):-sindGeschwister(P1,P2),female(P1),\+(P1=P2).

istBruderVon(P1,P2):-sindGeschwister(P1,P2),male(P1),\+(P1=P2).

%Aufgabe b
%rekursiv
count([],0).
count([_|Tail],Size):-count(Tail,Res),Size is Res +1.
sum([],0).
sum([Head|Tail],Sum):-sum(Tail,Res),Sum is Res + Head.
average([],0).
average(List,Avg):-sum(List,X),count(List,Y),Avg is X / Y.

%endrekursiv
ecount(List,Size):-ecount(List,0,Size).
ecount([],SoFar,SoFar).
ecount([_|Tail],SoFar,Size):-TempOneMore is SoFar +1,
                                 ecount(Tail,TempOneMore,Size).

esum(List,Sum):-esum(List,0,Sum).
esum([],Res,Res).
esum([Head|Tail],Res,Sum):-TempSum is Res + Head,
                           esum(Tail,TempSum,Sum).

eAverage([],0).
eAverage(List,Avg):-esum(List,X),ecount(List,Y),Avg is X / Y.

defList(l1,[1,2,3,4,5]).

memberOfList(X,[X|_]):-true.
memberOfList(X, [_|T]):- memberOfList(X, T).

myappend([], L, L).
myappend([HeadA|TailA],ListeB, [HeadA,C_Teil]):-myappend(TailA,ListeB,C_Teil).

contains(X,[X|_]).
contains(X,[_|Tail]):-contains(X,Tail).

allMembers([],[]).
allMembers([],_).
allMembers([L1Head|L1Tail],L2):-contains(L1Head,L2),allMembers(L1Tail,L2).


numberOfMatches1( X,X,1).
numberOfMatches1(_,_,0).

numberOfMatches2(_,[],0).
numberOfMatches2( X,[Head|Tail],R) :-numberOfMatches1(X,Head,E),
                                     numberOfMatches2(X,Tail,A),R is E+A.
numberOfMatches([],_,0).
numberOfMatches([HeadA|TailA],ListeB,R):-numberOfMatches2(HeadA,ListeB,E),numberOfMatches(TailA,ListeB,A),R is A+E.

vorsatz(vorsätzeFridolin,[instrument_lernen,vegan_ausprobieren,mehr_lernen]).%!!!!!!
vorsatzeLars([mehr_sport,vegan_ausprobieren,fremdsprache_lernen]).
vorsatzeHanna([alle_vorlesungen_besuchen,instrument_lernen,mehr_lernen,vegan_ausprobieren,alte_freundin_anrufen]).
vorsatzeSusi([alle_vorlesungen_besuchen,instrument_lernen,mehr_lernen,vegan_ausprobieren,alte_freundin_anrufen]).

mindgleich(X):-vorsätzeFridolin(L1),vorsätzeLars(L2),numberOfMatches(L1,L2,A),A>=X.

mind1():-mindgleich(1).
mind3():-mindgleich(3).


alleGleich1():-vorsätzeLars(L1),vorsätzeSusi(L2),numberOfMatches(L1,L2,A),count(L1,B),count(L2,C),B==C,A==B.




%Augabe c

defnode(k1, n(4,n(5,n(4,-,-),n(8,-,-)),n(15,-,-))).
defnode(k2, n(5,n(4,n(3,-,-),n(2,-,-)),n(1,-,-))).
%tree(-). %leerer Baum
%tree(n(X,L,R)):- tree(L), tree(R). %Baumknoten mit Inhalt X

equals(X,X).

memberOfTree(X,n(X,_,_)).
memberOfTree(X,n(_,Left,Right)):-memberOfTree(X,Left);memberOfTree(X,Right).

count(X,n(X,-,-),1).
count(_,n(_,-,-),0).
count(_,-,0).
count(X,n(X, Left, Right), Res):-count(X,Left,Res1),
    count(X,Right,Res2),Res is Res1 + Res2 +1 .

count(X,n(_, Left, Right), Num):-count(X,Left,Num1),
    count(X,Right,Num2),Num is Num1 + Num2 .


%replace(X,Y,n(X,-,-),n(Y,-,-)).

%replace(_,_,n(Z,-,-),n(Z,-,-)).

replace(_,_,-,-).

replace(X,Y,n(X, Left, Right), Out) :-replace(X,Y,Left,Out2),
    replace(X,Y,Right,Out3),Out=n(Y,Out2,Out3).

replace(X,Y,n(Z, Left, Right), Out) :-replace(X,Y,Left,Out2),
    replace(X,Y,Right,Out3),Out=n(Z,Out2,Out3).


treeSum(n(X,-,-),X).
treeSum(n(X,Left,Right),Sum):-treeSum(Left,Sum1),treeSum(Right,Sum2),Sum is Sum1+Sum2+X.








