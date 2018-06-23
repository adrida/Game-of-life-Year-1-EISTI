program main;
uses U_Finition,U_Type,U_TirageEchange,U_Creation,U_Tour,unix,process,sysutils,crt,U_Affichage;

var
pioche : pioche;
j1,j2 : joueur;
plat : plateau;
arr : tabpiecePos;
(*-------------------------------------------------------------------------------------------------------------*)
begin 
	randomize; 
	clrscr;
	writeln('Qwirkle Le jeu');
	delay(2000);	
	initgame(pioche,plat,j1,j2);
	Tous_Les_Tours(pioche,plat,j1,j2,arr,1);
end.
(*-------------------------------------------------------------------------------------------------------------*)