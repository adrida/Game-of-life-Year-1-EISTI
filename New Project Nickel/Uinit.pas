Unit UInit;

interface

{$IFDEF FPC}{$MODE OBJFPC}{H$H+}{$ENDIF}
{$APPTYPE CONSOLE}
uses crt,sysutils, math, classes, UTypes;

procedure initPlateau();
procedure initMain(numero : integer);
procedure InitSac(nb_couleurs, nb_formes, nb_tuiles_idem : integer);
procedure InitPlayers(type_joueurs: string);
procedure InitDefaultValues ;
procedure Piocher(numero, nb : integer);
procedure RetirerPiocheDuSac(pos, len : integer);




implementation

//**********************************************************************************
// Initialise le plateau de jeu avec des cases nulles
procedure initPlateau();
var
row, col,rowmax,colmax: integer;
Begin
	rowmax := (qwirkle_score*2)+1; // nombre de lignes
	colmax := (qwirkle_score*3)+1; // nombre de colonnes
	setlength(plateau,rowmax,colmax);
	for row:=0 to rowmax-1 do
	begin
		for col:= 0 to colmax-1 do
		begin
			plateau[row,col].forme := ' ';
			plateau[row,col].couleur := Black;
		end;
	end;
End;
//**********************************************************************************
// initilaisation de la main vide d'un joueur , le numéro du joueur est dans l'argument de la procédure
procedure initMain(numero : integer);
Var i, len : integer;
Begin

	len := length(joueurs[numero].main);

	for i:= 0 to len-1 do
	begin
		joueurs[numero].main[i].forme := ' ';
		joueurs[numero].main[i].couleur := Black;
	end;
End;


//**********************************************************************************
// Initilaisation du sac de tuiles
procedure InitSac(nb_couleurs, nb_formes, nb_tuiles_idem : integer);
var
i, j, k, n, len : integer;
begin
	len :=  (nb_formes * nb_couleurs *  nb_tuiles_idem); // nombre de tuiles à placer dans le sac
	Setlength(sac,len);
	n := 0;
	for i := 1 to nb_tuiles_idem do
	begin
		for j := 1 to nb_couleurs do
		begin
			for k := 1 to nb_formes do
			begin
				sac[n].forme := DEFAULT_FORMES[k];
				sac[n].couleur := DEFAULT_COULEURS[j];
				n := n + 1;
			end;
		end;
	end;
end;



//**********************************************************************************
// Initilaisation des types de joueurs
procedure InitPlayers(type_joueurs: string);
var
i,  len : integer;
begin
	display_utilisation := true;
	len := length(type_joueurs);
	if  len > 4  then raise exception.create('NOMBRE DE JOUEURS EST LIMITE A 4 : LIGNE DE COMMANDE INCORRECTE !');
	SetLength(joueurs,len);
	textcolor(yellow);
	
	for i := 1 to len do
	begin
		if ( (Upcase(type_joueurs[i]) <> 'H') ) then
		begin
            raise exception.create('TYPE DE JOUEUR INCORRECTE ! VALEUR ATTENDUE => H');
        end
		else
		begin
			write('VEUILLEZ SAISIR LE NOM DU JOUEUR ',  i , ': ');
			Readln(joueurs[i-1].nom);
			write('VEUILLEZ SAISIR L''AGE DU JOUEUR  ',  i , ': ');
			Readln(joueurs[i-1].age);

			joueurs[i-1].score := 0;
			joueurs[i-1].etat := ' ';
			joueurs[i-1].typedejoueur := type_joueurs[i] ;
	
			//if nb_couleurs > nb_formes then setlength(joueurs[i-1].main, nb_couleurs) else setlength(joueurs[i-1].main, nb_formes); // a mettre qwirke!score commen length sans if n else
			
			setlength(joueurs[i-1].main, qwirkle_score);	
			InitMain(i-1); // initilisation de la main du joueur
		end;
    end;
	display_utilisation := false;
end;

//***********************************************************************************************

// permet de piocher dans le sac, on donne comme argument le numéro du joueur et le nb de tuile à piocher
// cette même procédure permet de piocher au début du jeu et aussi pendant le jeu
procedure Piocher(numero, nb : integer);
Var i, j, n, length_sac, length_main : integer;
b: boolean;
Begin
	randomize;
	length_main := length(joueurs[numero].main);
	for i := 0 to nb-1 do
	begin
		length_sac := length(sac);
		if length(sac) <= 0 then break;  // si le sac est vide on sort du boucle for
		n := random(length_sac);
		for j := 0  to length_main-1 do
		begin
			if ( (joueurs[numero].main[j].couleur = Black) ) then // nous n'avons pas besoin de tester les deux attributs, il suffit de tester soit la forme ou la couleur
			begin																				// si la couleur est Black, on sait que la position est vide, on peut placer la pioche
				joueurs[numero].main[j].forme := sac[n].forme;
				joueurs[numero].main[j].couleur := sac[n].couleur;
				RetirerPiocheDuSac(n,length_sac);  // on va retirer la pioche et reduire l'array avec setlength
				break;  // important de sortir de la boucle for de la main pour piocher à nouveau
			end;
		end;
	end;
End;


//**************************************************************************************
// permet de retirer la pioche du sac, la position à retirer est dans l'argument 'pos', et le nombre de pièces est dans 'len'
procedure RetirerPiocheDuSac(pos, len : integer);
Var i, j : integer;
Begin
	for i := pos to len-2 do // nous allons decaler vers la gauche , tous les elements à droite de pos
	begin
		sac[i].forme := sac[i+1].forme;
		sac[i].couleur := sac[i+1].couleur;
	end;
	len := len -1;
	Setlength(sac,len);
End;

//**********************************************************************************
// Initilaisation des valeurs par défaut : nombres de couleurs, formes, tuile identiques et type de joueur
procedure InitDefaultValues ;
var
reste, i, len : integer;
nb_couleurs, nb_formes, nb_tuiles_idem : integer;
typejoueurs : string;
Begin
	display_utilisation := true;
	typejoueurs := 'hh'; // par defaut
	nb_couleurs := 6;
	nb_formes := 6;
	nb_tuiles_idem := 3;
	if  (ParamCount > 0 ) then
	begin
            reste := ParamCount mod 2;
            if ( reste <> 0 ) then
            begin
				raise exception.create('LIGNE DE COMMANDE INCORRECTE !');
			end;
			i := 1;
			while ( i < ParamCount ) do
			begin
				case lowercase(ParamStr(i)) of
					'-j' : typejoueurs := lowercase(ParamStr(i+1));
					'-c' : nb_couleurs := strToInt(ParamStr(i+1));
					'-f' : nb_formes :=  strToInt(ParamStr(i+1));
					'-t' : nb_tuiles_idem :=  strToInt(ParamStr(i+1));
					else
						begin
							raise exception.create('LIGNE DE COMMANDE INCORRECTE !');
						end;
				end;
				i := i + 2;
			end;
	end; // end of if
	//if nb_couleurs > nb_formes then initPlateau(nb_couleurs) else  initPlateau(nb_formes);
	
	qwirkle_score := min(nb_formes,nb_couleurs);  
	initPlateau();
	InitSac(nb_couleurs, nb_formes, nb_tuiles_idem);
	InitPlayers(typejoueurs);
	len := length(joueurs);
	for i := 0 to len-1 do
	begin
		Piocher(i,length(joueurs[i].main));
	end;
End;

End.

