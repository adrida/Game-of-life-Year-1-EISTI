
Program rules;
{$IFDEF FPC}{$MODE OBJFPC}{H$H+}{$ENDIF}
{$APPTYPE CONSOLE}
uses crt,sysutils, math, classes, UTypes, UAffichage, UInit, UPlayRules  ;
// DEBUT DU JEU
Procedure StartGame(maxTuiles : integer);
var choix : char;
isok : boolean;
i,count : integer;
txt : string;
Begin
	isok := false;
	choix := 'J';
	while isok = false do
	begin
		AfficherJeu(maxTuiles,true);
		if  maxTuiles = 0 then choix :=  DemanderJouerEchanger; // si ce n'est pas le premier joueur on donne l'option de jouer ou échanger
		case choix of
			'J' : isok := PlacerTuiles(maxTuiles);
			'E': isok := EchangerTuiles;
			'P' : isok := true;
		end;	
		if  isok = true then
		begin
            maxTuiles := 0;
			currentPlayer := currentPlayer + 1;
            if currentPlayer = length(joueurs) then  currentPlayer := 0;
			 isok := false;
			 count := 0;
			for i := 0 to length(joueurs)-1 do 
			begin
				if isMainVide(i) = true then isok := true    // un des joueurs a terminé, sa main est vide
				else if joueurs[i].etat = 'P' then count := count + 1; // on compte le nombre de joueurs qui ont arrêté le jeu
			end;
			if count = length(joueurs) then isok := true;
        end;
	end;
	AfficherJeu(maxTuiles,false);  // fin de jeu affichage du gagnant
End;
//**********************************************************************************
// programme principale
var
maxTuiles: integer;
Begin
	try
		InitDefaultValues;
		maxTuiles := FindFirstPlayer;
		if currentPlayer >= 0 then StartGame(maxTuiles);

	Except
        on E :Exception do begin
            writeln(E.message);
            readkey;
			if (display_utilisation = true ) then afficherUtilisation;
        end
    end;

end.  { fin du programme }


