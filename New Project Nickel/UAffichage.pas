Unit UAffichage;

interface

{$IFDEF FPC}{$MODE OBJFPC}{H$H+}{$ENDIF}
{$APPTYPE CONSOLE}
uses crt,sysutils, math, classes, UTypes, UInit;

procedure Split(const Delimiter: Char; Input: string; const Strings: TStrings);
Function EffacerLignes(x : integer; hasToClear : boolean): integer;
Function AfficherMessage(clr : byte;cx, cy: integer; message : string; dowait, hasToClear : boolean): integer;
procedure afficherUtilisation();
Procedure AfficherMain(msg:string; hasToClear:boolean);
procedure AfficherPlateau();






implementation

// Utilitaire : Pour decouper un string par son separateur
procedure Split(const Delimiter: Char; Input: string; const Strings: TStrings);
begin
   Assert(Assigned(Strings)) ;
   Strings.Clear;
   Strings.Delimiter := Delimiter;
   Strings.DelimitedText := Input;
end;

//*******************************************************************************************
// Effacer les lignes à l'écran en  dessous du plateau
Function EffacerLignes(x : integer; hasToClear : boolean): integer;
var i, y : integer;
Begin
	if hasToClear = true then
	begin
		Clrscr;
		y := 1;
	end
	else y := ((length(Plateau)+1)*2) + 1;  // ligne = ((hauteur du plateau+1(position)) * 2(ligne vide entre chaque ligne))  + 1

	for i := y to y+5 do   // effacer les lignes par des espaces
	begin
		gotoxy(x,i);
		write('                                                                                 ');
	end;
	EffacerLignes := y;
End;
//*******************************************************************************************
// Afficher un message d'erreur ou information
// dowait = true => attente d'appuyer sur une touche
// cx, cy => coord d'affichage
Function AfficherMessage(clr : byte;cx, cy: integer; message : string; dowait, hasToClear : boolean): integer;
var y : integer;
Begin
	if cy = 0 then cy := EffacerLignes(cx,hasToClear);

	textcolor(clr);
	gotoxy(cx,cy);
	write('                                                 ');
	gotoxy(cx,cy);
	write(message);
	if dowait = true then Readkey;
	AfficherMessage :=  cx + length(message); // retourne la dernière position de x
End;


//**********************************************************************************
// affichage de l'utilisation de la ligne de commande
procedure afficherUtilisation();
Begin
	//clrscr;
	textcolor(yellow);
	writeln('***** Utilisation du programme - Ligne de commande *******');
	writeln;
	writeln('Qwirkle -j hh -c 5 -f 5 -t 3');
	writeln;
	writeln('*******************************************************');
	writeln('Permet de jouer une partie entre deux joueurs humains ("-j hh") avec un kit de 3 tuiles identiques ("-t 3")');
	writeln('ayant 5 couleurs ("-c 5") et 5 formes ("-f 5")');
	writeln(' -j hh => -j type de joueur h = humain o=Ordinateur');
	writeln(' -c 6 => -c nombre de couleurs');
	writeln(' -f 6 => -c nombre de formes');
	writeln(' -t 3 => -t nombre de tuiles identiques');
	writeln('Les couleurs et les formes sont limitées à 10 !');
	textcolor(LightCyan);
	writeln;
	writeln('***** Conseil d''utilisation du programme *******');
	writeln;
	writeln('Veuillez utiliser en mode plein ecran votre console !');
	writeln('Les positions des tuiles dans la main du joueur et les coordonnées sont saisies en séparant par des espaces sur la même lignes');
	writeln('Couleurs :  B => Blanc; V => Vert; R => Rouge; L => LightBlue; E => Blue, M => Magenta; N => Marron; J => Jaune,Y => LightCyan; C => Cyan');
	
	ReadKey;
End;


//**********************************************************************************
// Afficher le plateau du jeu Qwirkle
procedure AfficherPlateau();
var row, col,rowmax,colmax, x,y : integer;
txt : string;
Begin
	clrscr;
	rowmax := length(plateau);
	colmax := length(plateau[0]);
	txt := 'P  '; // position
	clrscr;
	 y := 3;
	for row := 0 to rowmax-1 do
	begin
		x := 4;
		for col := 0 to colmax-1 do
		begin
			if ((row = 0) and (col < 9) )  then
			begin
                txt := txt + IntToStr(col+1) + '  ';
            end
            else if ((row = 0) and (col >= 9) ) then
			begin
                txt := txt + IntToStr(col+1) + ' ';
            end;
			if  col = 0 then
			begin
				textcolor(white); gotoxy(1,y); write(row+1);
			end;
			textcolor(plateau[row,col].couleur);  gotoxy(x,y); write(plateau[row,col].forme);
			x := x + 3;
		end;
		y := y + 2;
		if row = 0 then
		begin
			textcolor(white); gotoxy(1,1); write(txt);
		end;
	end;

End;
//**********************************************************************************
// affichage les tuiles d'un joueur
Procedure AfficherMain(msg:string; hasToClear:boolean);
Var i, main_len,x,y : integer;
clr : char;
Begin
	y := EffacerLignes(1,hasToClear);

	textcolor(Yellow);
	gotoxy(1,y); write('Joueur ', currentPlayer+1, ' ', joueurs[currentPlayer].nom,': ' + msg);
	y := y+1;
	gotoxy(1,y); write('POSITION : ');
	y := y+1;
	gotoxy(1,y); write('TUILES   : ');
	gotoxy(1,y+1); write('COULEUR  : ');
	x := 12;
	main_len := length(joueurs[currentPlayer].main);
	for i := 0 to main_len-1 do
	begin
		textcolor(Green);
		gotoxy(x,y-1); write(i+1, ' ');
		textcolor(joueurs[currentPlayer].main[i].couleur);
		gotoxy(x,y); write(joueurs[currentPlayer].main[i].forme,' ');
		textcolor(white);
		gotoxy(x,y+1);
		case joueurs[currentPlayer].main[i].couleur of
			LightCyan : clr := 'Y';
			Yellow : clr := 'J';
			Red : clr := 'R';
			Green : clr := 'V';
			Blue : clr := 'E';
			Magenta : clr := 'M';
			White : clr := 'B';
			Brown : clr := 'N';
			LightBlue : clr := 'L';
			Cyan : clr := 'C'
			else clr := 'I';
		end;	
		write(clr,' ');
		x := x + 2;
	end;

End;

End.

