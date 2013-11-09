accReverse([],L,L).
accReverse([H|T],Acc,Rev):-accReverse(T,[H|Acc],Rev).
reverse(L1,L2):-accReverse(L1,[],L2).

same_a(X,X,X).
accfind_common([],[],L,L).
accfind_common([A|T],[B|Y],Acc,R):-same_a(A,B,a),accfind_common(T,Y,[a|Acc],R),!.
accfind_common([_|T],[_|Y],Acc,R):-accfind_common(T,Y,[n|Acc],R).

find_common(X,Y,Z):-accfind_common(X,Y,[],R),reverse(R,Z),!.
find_common(A,[],A).

timetable(X,Y,R):-constraints(X,T),find_common(T,Y,R).

common_constraints([A|T],Acc,R):-timetable(A,Acc,Ac),common_constraints(T,Ac,R).
common_constraints([],L,L).
final_constraints(A,R):-common_constraints(A,[],R),!.

add_extra_n(R,L,R):-length(R,L1),L1=:=L,!.
add_extra_n(S,L,R):-length(S,L1),L1<L,add_extra_n([n|S],L,R).
same_b(X,X).
select_tutor_number(_,Acc,Aim,L,F,R2):-Acc=:=Aim,add_extra_n(F,L,R1),reverse(R1,R2),!.
select_tutor_number([A|T],Acc,Aim,L,R,F):-same_b(A,a),NewAcc is Acc + 1,select_tutor_number(T,NewAcc,Aim,L,[a|R],F).
select_tutor_number([_|T],Acc,Aim,L,R,F):-select_tutor_number(T,Acc,Aim,L,[n|R],F).

find_student_common([],[]):-fail,!.
find_student_common([A|T],[B|Y]):-same_a(A,B,a),true,!;find_student_common(T,Y).

final_select(S,Num,R):-final_constraints(S,R1),length(R1,Len),select_tutor_number(R1,0,Num,Len,[],R).

test_student([],_):-true,!.
test_student([A|T],S):-student_timetable(A,A1),find_student_common(A1,S),test_student(T,S).

find_time_slots_sub(T,S,Num,FNum,R):-final_select(T,Num,R),test_student(S,R),FNum=Num,true,!;NewNum is Num + 1,find_time_slots_sub(T,S,NewNum,FNum,R).

find_time_slots(T,S,Num,R):-find_time_slots_sub(T,S,1,Num,R).
