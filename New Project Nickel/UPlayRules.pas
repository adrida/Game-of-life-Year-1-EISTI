Unit UPlayRules;


interface

{$IFDEF FPC}{$MODE OBJFPC}{H$H+}{$ENDIF}
{$APPTYPE CONSOLE}
uses crt,sysutils, math, classes, UTypes,UInit,UAffichage;

function isMainVide(numero : integer): boolean;
function GetPositions(msg:string; var pos : array of integer; len,cy,nbTuiles : integer) : boolean;
function CheckPositions( pos : array of integer; len,cy : integer) : boolean;
Function EchangerTuiles():boolean;
function IsFormePresent(forme : char; var arrForme : array of char; var count : integer): boolean;
function IsColorPresent(clr : byte; var arrClrs : array of byte; var count : integer): boolean;
Function  DetermineMaximumEqualTiles(n : integer): integer;
Function FindFirstPlayer(): integer;
Function PlacerTuiles(nbTuiles : integer): boolean;
Function DemanderJouerEchanger():char;
procedure DecalerPlateau(i,j : integer);
Procedure CheckDecalagePlateau(var maxX,maxY, x,y: integer;var play : player_coord);
procedure copyPlateau(var TmpPlateau: board; sens : integer);
Function isAllTuilesValid(arrRow : one_row; len : integer): boolean;
Function IsColorsAndFormsOk(x,y : integer): boolean;
Function IsXYPresentInArray(x,y : integer; arr : player_coord):boolean;
Procedure CalculateScore(play : player_coord; cy : integer);
Function IsPlayValid(x,y,cy,firstPlayer : integer; posTuiles : array of integer; direction : char; var play : player_coord): boolean;
Procedure Repiocher(posTuiles : array of integer);
Function  hasToPlaceManyTiles(posTuiles : array of integer): boolean;
Procedure Afficherjeu(maxTuiles:integer; displayMain : boolean);


implementation

//permet de vérifier si la main d'un joueur est vide
function isMainVide(numero : integer): boolean;
Var b : boolean;
i , len  : integer;
Begin
	b := true; // on suppose que la main est vide au départ
	len := length(joueurs[numero].main);

	for i := 0 to len-1 do
	begin
		if ( (joueurs[numero].main[i].couleur <> Black) ) then // nous n'avons pas besoin de tester les deux attributs, il suffit de tester soit la forme ou la couleur
		begin
			b := false;
			break;
        end;
	end;
	isMainVide := b;
End;


//*******************************************************************************************
// Retourne les positions des tuiles à echanger
// argument : array of integer => pos_to_echange

function GetPositions(msg:string; var pos : array of integer; len,cy,nbTuiles : integer) : boolean;
Var
b : boolean;
i ,x: integer;
List: TStringList;
Txt, fmt: string;

Begin
	try
        b := false;
        List := TStringList.Create;
        while b = false do
		begin
			x := AfficherMessage(Yellow,PLAYER_XCOORD,cy,msg, false,false);
			Readln(Txt);
			Split(' ', Txt, List);
			 if List.Count > len then
			begin
				Txt := format('%s',['Vous pouvez saisir maximum ']) + format('%d',[len]) + format('%s',[' positions.']) ;
				raise exception.create(Txt);
            end
			else
			begin
				for  i:=0 to List.Count-1 do
				begin
					pos[i] := StrToInt(List[i]);
					if ( (pos[i] > len) or (pos[i] < 1) ) then raise exception.create('LE NUMERO DE POSITION EST NON VALIDE !')
					else if joueurs[currentPlayer].main[pos[i]-1].couleur = Black  then raise exception.create('LE POSITION VIDE EST NON AUTORISE !')
                end;
				if ( (nbTuiles <> 0) and (List.count <> nbTuiles) ) then 
				Begin
					Txt := 'Vous devez saisir ' + IntToStr(nbTuiles) + ' positions !';
					raise exception.create(Txt);
				end;
                b := true;
			end;
        end;
        List.Free;
	Except
        on E :Exception do begin
			List.Free;
			AfficherMessage(Yellow,PLAYER_XCOORD,cy+1,E.message,true,false);
			AfficherMessage(Yellow,PLAYER_XCOORD,cy+1,' ',false,false); // pour effacer le message précédent
        end
    end;

	GetPositions := b;
End;

//*******************************************************************************************
// verifie les positions des tuiles saisies par l'iutilsateur dans sa main
// pos => positions saisie
// len => longeur du tabelau
// numero => numero du jouer
function CheckPositions( pos : array of integer; len,cy : integer) : boolean;
Var
b : boolean;
i , j: integer;
Begin
	b := true;
	for i := 0 to len-1 do
	begin
		for j := 0 to len-1 do
		begin
			if (( j <> i) and (pos[i] <> 0) and (pos[i] = pos[j]) ) then
			begin
				b := false;
				AfficherMessage(Yellow,PLAYER_XCOORD,cy,'Les positions identiques ne sont pas acceeptés !',true,false);
				break;
            end;
        end;
        if b = false then break;
    end;
    CheckPositions := b;
End;
//*******************************************************************************************
// permet d'echanger les tuiles d'un joueur

Function EchangerTuiles():boolean;
Var pos_to_echange : array of integer;
isok : boolean;
 i,main_len, sac_len, count, cy : integer;
Begin
	isok := false;
	main_len := length(joueurs[currentPlayer].main);
	setlength(pos_to_echange,main_len);
	while isok = false do
	begin
		cy := EffacerLignes(PLAYER_XCOORD,false);
		gotoxy(PLAYER_XCOORD,cy);

		isok := GetPositions('Position des tuiles à echanger : ', pos_to_echange,main_len,cy,0);
		if isok = true then isok := CheckPositions(pos_to_echange,main_len,cy);
		if isok = false then
		for i:= 0 to main_len-1 do pos_to_echange[i] := 0;
    end;
	sac_len := length(sac);
	count := 0;
	for i := 0 to main_len-1 do
	begin
		if pos_to_echange[i] <> 0 then
		begin
			sac_len := sac_len + 1;
			setlength(sac,sac_len);
			sac[sac_len-1].forme := joueurs[currentPlayer].main[pos_to_echange[i]-1].forme;
			sac[sac_len-1].couleur := joueurs[currentPlayer].main[pos_to_echange[i]-1].couleur;
			joueurs[currentPlayer].main[pos_to_echange[i]-1].forme := ' ';
			joueurs[currentPlayer].main[pos_to_echange[i]-1].couleur := black;
			count := count + 1;
		end;
	end;
	Piocher(currentPlayer,count);
	EchangerTuiles := isok;
End;

//*****************************************************************************************
//  on cherche la forme dans le tableau de formes, si non trouvé : on ajoute dans le tableau et on increment leur nombre
function IsFormePresent(forme : char; var arrForme : array of char; var count : integer): boolean;
Var
bFind : boolean;
k : integer;
Begin
	bFind := false;
	for k := 0 to count-1 do
	begin
		if arrForme[k] =  forme then
		begin
			bFind := true;
			break;
		end;
	end; // end for k
	if bFind = false then
	begin
		arrForme[count] := forme;
		count := count + 1;
	end;

	IsFormePresent := bFind;
End;
//*****************************************************************************************
//  on cherche la couleur dans le tableau de couleurs, si non trouvé : on ajoute dans le tableau et on increment leur nombre
function IsColorPresent(clr : byte; var arrClrs : array of byte; var count : integer): boolean;
Var
bFind : boolean;
k : integer;
Begin
	bFind := false;
	for k := 0 to count-1 do
	begin
		if arrClrs[k] =  clr then
		begin
			bFind := true;
			break;
		end;
	end; // end for k
	if bFind = false then
	begin
		arrClrs[count] := clr;
		count := count + 1;
	end;
	IsColorPresent := bFind;
End;
//**********************************************************************************
// Determiner maximum tuiles de même type pour un joueur n => numero du joueur

Function  DetermineMaximumEqualTiles(n : integer): integer;
Var
i,j,k, len, clrCount, formeCount, maxTuiles : integer;
recCountColors : array of integer;
recCountFormes : array of integer;
arrColors : array of byte;
arrFormes : array of char;
bFind : boolean;
Begin
	len := length(Joueurs[0].main);
	setlength(recCountColors,len);
	setlength(recCountFormes,len);
	setlength(arrColors,len);
	setlength(arrFormes,len);
	for i := 0 to len-1 do
	begin
		recCountColors[i] := 0;
		recCountFormes[i] := 0;
	end;

	// pour chaque forme existe dans la main du joueur , on calcul le nombre
	for i := 0 to len-1 do arrFormes[i] := ' ';
	formeCount := 0;
	for i := 0 to len-1 do
	begin
		bFind := IsFormePresent(joueurs[n].main[i].forme,arrFormes,formeCount);
		if  bFind = false then
		begin
			for j := 0 to len-1 do arrColors[j] := black;
			arrColors[0] := joueurs[n].main[i].couleur;
			clrCount := 1;
			for j := 0 to len-1 do
			begin
				if (( i <> j) and (joueurs[n].main[i].forme = joueurs[n].main[j].forme) ) then // debut if forme equal
				begin
					IsColorPresent(joueurs[n].main[j].couleur,arrColors,clrCount);
				end; // end for if form equal
			end; // end for j
			recCountFormes[formeCount-1] := clrCount;
			arrFormes[formeCount-1] := joueurs[n].main[i].forme;
		end; // end of bfind
	end;
	maxTuiles := 0;
	for i :=0 to 	formeCount-1 do
	begin
		if recCountFormes[i] > maxTuiles then maxTuiles := recCountFormes[i];
	end;
	// pour chaque couleur existe dans la main du joueur , on calcul le nombre
	for i := 0 to len-1 do arrColors[i] := black;

	clrCount := 0;
	for i := 0 to len-1 do
	begin
		bFind := IsColorPresent(joueurs[n].main[i].couleur,arrColors,clrCount);
		if  bFind = false then
		begin
			for j := 0 to len-1 do arrFormes[j] := ' ';
			arrFormes[0] := joueurs[n].main[i].forme;
			formeCount := 1;
			for j := 0 to len-1 do
			begin
				if (( i <> j) and (joueurs[n].main[i].couleur = joueurs[n].main[j].couleur) ) then // debut if forme equal
				begin
					IsFormePresent(joueurs[n].main[j].forme,arrFormes,formeCount);
				end; // end for if form equal
			end; // end for j
			recCountColors[clrCount-1] := formeCount;
			arrColors[clrCount-1] := joueurs[n].main[i].couleur;
		end; // end of bfind
	end;
	for i :=0 to 	clrCount-1 do
	begin
		if recCountColors[i] > maxTuiles then maxTuiles := recCountColors[i];
	end;
	DetermineMaximumEqualTiles := maxTuiles;
End;

Function FindFirstPlayer(): integer;
var
i,len, maxTiles  : integer;
arrTiles : array of integer;
equalTiles : boolean;
Begin
	len := length(joueurs);
	setlength(arrTiles,len);
	textcolor(yellow);
	equalTiles := false;
	for i := 0 to len-1 do arrTiles[i] := DetermineMaximumEqualTiles(i);
	clrscr;
	textcolor(yellow);

	currentPlayer := 0; //  on suppose le premier joueur a plus de tuiles identiques
	maxTiles := arrTiles[0];
	writeln('joueur 1 ',  joueurs[0].nom,' => TUILES A JOUER : ', arrTiles[0], ' => Age :', joueurs[0].age );
	for i := 1 to len-1 do // parcours du tableau à partir du 2ème joueur
	begin
		writeln('joueur ', i+1, ' ', joueurs[i].nom,' => TUILES A JOUER : ', arrTiles[i], ' => Age :', joueurs[i].age);
		if (arrTiles[i] =  maxTiles)  then
		begin
			if  joueurs[currentPlayer].age = joueurs[i].age then equalTiles := true
			else if  joueurs[i].age > joueurs[currentPlayer].age  then
			begin
				equalTiles := false;
				currentPlayer := i;
			end;
		end
		else if arrTiles[i] > maxTiles then
		begin
			maxTiles := arrTiles[i];
			currentPlayer := i;
			equalTiles := false;
		end;
	end;
	writeln('Le premier joueur est :' ,	 joueurs[currentPlayer].nom);
	
	if equalTiles = true then
	begin
		textcolor(green);
		writeln('Plusieurs joueurs ont le même nombre de tuiles à placer. Le jeu doit être relancer !');
		currentPlayer := -1;
	end;
	Readkey;
	FindFirstPlayer := 	maxTiles;
End;
//*****************************************************************************************************

// placer les tuiles dans le plateau
Function PlacerTuiles(nbTuiles : integer): boolean;
Var i,main_len,x,y,cy,pos,maxX,maxY : integer;
txt : string;
isok : boolean;
direction : char;
posTuiles : array of integer;
formes : array of char;
play : Player_coord;
Begin
	isok := false;
	maxX := length(Plateau);
	maxY := length(Plateau[0]);
	main_len := length(joueurs[currentPlayer].main);
	setlength(posTuiles,main_len);
	for i:= 0 to main_len-1 do posTuiles[i] := 0;  // initialiser les positions

	cy := EffacerLignes(PLAYER_XCOORD,false);
	textcolor(white);

	try
		if nbTuiles > 0 then // premier tour , le  premier joueur doit placer le nombre exact dans GetPositions
		begin
			txt := 'Nombre de tuiles à placer : ' + IntToStr(nbTuiles);
			AfficherMessage(Yellow, PLAYER_XCOORD,cy,txt ,false,false); 
        end;

		repeat
			isok := GetPositions('Saisir le(s) position(s) : ', posTuiles,main_len,cy+1,nbTuiles);
			if isok = true then isok := CheckPositions(posTuiles,main_len,cy+1);
			if isok = false then
			for i:= 0 to main_len-1 do posTuiles[i] := 0;
		until ( isok = true);
		if  nbTuiles = 0  then  // on demande les coord si ce n'est pas le premier joueur, si non on place automatiquement au milieu du plateau
		begin
			repeat
				AfficherMessage( Yellow,PLAYER_XCOORD,cy+2,'Donnez les coords : ' ,false,false);
				Readln(x,y);
			until ((x > 0) and (x < maxX) and (y > 0) and (y < maxY));
		end
		else
		begin
			x := Ceil(length(plateau)/2);  // arrondir à la valeur supérieur càd 9.5 devient 10
			y := Ceil(length(plateau[0])/2);
		end;
		if hasToPlaceManyTiles(posTuiles) = true then 
		Begin
			repeat
				AfficherMessage( Yellow,PLAYER_XCOORD,cy+3,'Donnez la direction (G/D/H/B) : ' ,false,false);
				Readln(direction);
				direction := upcase(direction);
			until ((direction = 'G') or (direction = 'D') or (direction = 'H') or (direction = 'B') );
		end
		else	direction := 'G';
		isok := IsPlayValid(x,y,cy+4,nbTuiles,posTuiles,direction,play);
		
		Except
			on E :Exception do begin
				AfficherMessage(Yellow,PLAYER_XCOORD,cy+4,'VALEUR NON AUTORISEE !',true,false);
				isok := false;
			end;
	end; { fin du try}
	
	if isok = true then  Repiocher(posTuiles); // a faire remettre la main à 0 pour les position des tuiles placer sur le plateau et piocher à nouveau
	PlacerTuiles := isok;
End;



// demande le joueur courant de jouer,echanger ou arrêter le jeu  si il n'y a pas de tuiles
// dans le sac et il ne peut pas placer les Tuiles dans sa main 
Function DemanderJouerEchanger():char;
var c, EchangeouPasser : char;
y : integer;
txt : string;
Begin
	txt := 'Votre Choix :';
	if length(sac) <= 0 then EchangeouPasser := 'P' else EchangeouPasser := 'E';
	try
		repeat
			y := EffacerLignes(PLAYER_XCOORD,false);
			textcolor(white);
			gotoxy(PLAYER_XCOORD,y); write('Jouer    => J');
			gotoxy(PLAYER_XCOORD,y+1); 
			if length(sac) > 0 then write('Echanger => E') else write('Passer => P');
			gotoxy(PLAYER_XCOORD,y+2); write(txt);
			gotoxy(PLAYER_XCOORD+length(txt),y+2);
			readln(c);
			c := upcase(c);
			until ( (c = 'J' ) or (c = EchangeouPasser) );
			if c = 'P' then joueurs[currentPlayer].etat := 'P' else  joueurs[currentPlayer].etat := ' ';
		Except
		on E :Exception do begin
			AfficherMessage(Yellow,PLAYER_XCOORD,y+3,'VALEUR NON AUTORISEE,  RECOMMENCER SVP !',true,false);
		end;
	end; { fin du try}
	writeln();
	DemanderJouerEchanger := c;
End;

//**********************************************************************************

procedure DecalerPlateau(i,j : integer);
Var nbofLines,nbofColumns,linesToAdd,columnsToAdd: integer;
decalageLine,decalageColumn : boolean;
Begin
    linesToAdd :=0;
    columnsToAdd:=0;
    decalageColumn:= false;
    decalageLine := false;

    nbofLines := length(plateau);
    nbofColumns := length(plateau[0]);


            if ((i= 0) or ( i = nbofLines-1)) then
                linesToAdd:=1;
            if i=0 then
                decalageLine := true;
            if ((j= 0) or (j = nbofColumns-1)) then
                columnsToAdd:=1;
            if (j=0) then
                decalageColumn := true;

            setlength(plateau,nbofLines+linesToAdd,nbofColumns+columnsToAdd);

            if decalageLine = true then
            begin
                for i:=nbofLines-1 downto 0 do
                begin
                    for j:=0 to nbofColumns-1 do
					begin
						plateau[i+1,j].forme := plateau[i,j].forme;
						plateau[i+1,j].couleur := plateau[i,j].couleur;
					end;
                end;

                for j:=0 to nbofColumns+columnsToAdd-1 do
				begin
                    plateau[0,j].couleur:= Black;
					plateau[0,j].forme := ' ';
				end;
			end;
            if decalageColumn = true then
            begin
                
				for i:=0 to nbofLines+linesToAdd-1 do   //
                    begin
                        for j:=nbofColumns-1 downto 0 do
						begin
                            plateau[i,j+1].forme:= plateau[i,j].forme;
							plateau[i,j+1].couleur := plateau[i,j].couleur;
						end;
                    end;
				for i:=0 to nbofLines+linesToAdd-1 do
					begin
						plateau[i,0].couleur:= Black;
						plateau[i,0].forme := ' ';
					end;
			end;
End;

//*****************************************************************************
// Vérifions si on doit decaler le plateau à gauche, à droite, en haut ou en bas
Procedure CheckDecalagePlateau(var maxX,maxY, x,y: integer;var play : player_coord);
var i,count : integer;
Begin
	count := length(play);
	// On décale le plateau en fonction de la position donnée par l'utilisateur
        if ((x = 0) or (x = maxX-1) or (y = 0) or (y = maxY-1) ) then
	begin
	     DecalerPlateau(x,y);
             if x = 0 then
             begin
                  for i:=0 to count-1 do play[i].x := play[i].x + 1;     // les positions des coord saisie par le joueur change, car on ajoute une ligne en haut
                  x := 1;
             end;
             if y = 0 then
             begin
                  for i:=0 to count-1 do play[i].y := play[i].y + 1;    // les positions des coord saisie par le joueur change, car on ajoute une colonne à gauche
                  y := 1;
             end;

        end;

	maxX := length(Plateau);
	maxY := length(plateau[0]);
End;
//**********************************************************************************
// Copier le contenu du plateau dans le varaible temporarire ou vice versa
// sens = 1 => copie Plateau vers TmpPlateau
// sens = 2 => copie TmpPlateau vers Plateau
procedure copyPlateau(var TmpPlateau: board; sens : integer);
var
row, col,rowmax,colmax: integer;
//TmpPlateau : array of array of tuile;
Begin
	if  sens = 1 then
	begin
		rowmax := length(plateau); // nombre de lignes
		colmax :=length(plateau[0]);  // nombre de colonnes
		setlength(TmpPlateau,rowmax,colmax);
		for row:=0 to rowmax-1 do
		begin
			for col:= 0 to colmax-1 do
			begin
				TmpPlateau[row,col].forme := plateau[row,col].forme ;
				TmpPlateau[row,col].couleur := plateau[row,col].couleur;
			end;
		end;
	end
	else if  sens = 2 then
	begin
		rowmax := length(TmpPlateau); // nombre de lignes
		colmax :=length(TmpPlateau[0]);  // nombre de colonnes
		setlength(plateau,rowmax,colmax);
		for row:=0 to rowmax-1 do
		begin
			for col:= 0 to colmax-1 do
			begin
				plateau[row,col].forme := TmpPlateau[row,col].forme ;
				plateau[row,col].couleur := Tmpplateau[row,col].couleur;
			end;
		end;
	end;
End;

//**********************************************************************************
// validation des tuiles pour la même couleur ou même forme
Function isAllTuilesValid(arrRow : one_row; len : integer): boolean;
Var
isok, colorsok, formesok : boolean;
i,j,count : integer;
formes : array of char;
couleurs : array of byte;
label ENDVALID;

Begin
	isok := true;

	{
		si les couleurs de toutes les lignes sont égales , on vérifie le forme est présente une seule fois
        si toutes les formes sont égales , on vérifie la couleur est présente une seule fois.
        si non le tableau est invalide.
	 }
	if len = 1 then goto ENDVALID;

	colorsok := true; formesok := true;
    for i := 1 to len-1 do 
	begin
		if arrRow[0].couleur <> arrRow[i].couleur then colorsok := false
		else if  arrRow[0].forme <> arrRow[i].forme then formesok := false;
	end;	
	if (colorsok = false) and (formesok = false) then 
	begin
		isok := false;
		goto ENDVALID;
	end;
	count := 1;
	setlength(formes,count);
	formes[count-1] := arrRow[0].forme;
	if colorsok = true then
	begin
		for  i:= 1 to len-1 do
		begin
			for j := 0 to length(formes)-1 do
			begin
				if arrRow[i].forme =  formes[j] then
				begin
					isok := false;
					 goto ENDVALID;
				end;
			 end;
				count := count + 1;
				setlength(formes,count);
				formes[count-1] := arrRow[i].forme;
		end;
	end;
	
	count := 1;
	setlength(couleurs,count);
	couleurs[count-1] := arrRow[0].couleur;
	if formesok = true then
	begin
		for i := 1 to len-1 do
		begin
				for j := 0 to length(couleurs)-1 do
				begin
					if arrRow[i].couleur =  couleurs[j] then
					begin
						isok := false;
						goto ENDVALID;
					end;
				 end;
				count := count + 1;
				setlength(couleurs,count);
				couleurs[count-1] := arrRow[i].couleur;
		end;
	end;	
	

ENDVALID:
			isAllTuilesValid := isok;
End;

//**********************************************************************************
// on recupère dans un tableau les tuiles de chaque lignes adjacentes et chaque colonne adjacents
// et on appelle la fonction isAllTuilesValid pour vérfier si c'est la même forme ou même couleur
Function IsColorsAndFormsOk(x,y : integer): boolean;
Var
isok : boolean;
arrRow : one_row;
t_x,t_y, lenY, lenX, count, inc : integer;
Begin
	lenX := length(plateau);
	lenY := length(plateau[0]);

	setlength(arrRow,lenY);
	isok := true;
	t_x := x;
	inc := -1;
	//  Verifie toutes les tuiles adjacent dans la direction Y
	while (isok = true) and (t_x >= 0 ) and (t_x < lenX) and (plateau[t_x,y].couleur <> Black) do
	Begin
		arrRow[0] := plateau[t_x,y];
		t_y := y + 1; count := 1;

		 while ((t_y < lenY) and (plateau[t_x,t_y].couleur <> Black)) do
		 Begin
				arrRow[count] :=plateau[t_x,t_y];
				t_y := t_y + 1;
				count := count + 1;
		end;

		 t_y := y - 1;
		 while ((t_y >= 0) and (plateau[t_x,t_y].couleur <> Black)) do
		 Begin
				arrRow[count] := plateau[t_x,t_y];
				t_y := t_y - 1;
				count := count + 1;
		end;
		isok := isAllTuilesValid(arrrow,count);
		t_x := t_x + inc ;  // on vérifie les lignes en haut   // erreur constaté
		if ((t_x < 0) or (plateau[t_x,y].couleur = Black)) and (inc = -1)  then 
		begin
			t_x := x + 1; // on vérifie les lignes en bas
			inc := 1;
		end;	
	end;
	//  Verifie toutes les tuiles adjacent dans la direction X
     if isok = true then

	 begin
		setlength(arrRow,lenX);
		t_y := y;
                inc := -1;
		while (isok = true) and (t_y >= 0 ) and (t_y < lenY) and (plateau[x,t_y].couleur <> Black) do
		Begin
			arrRow[0] := plateau[x,t_y];
			t_x := x + 1; count := 1;

			 while ((t_x < lenX) and (plateau[t_x,t_y].couleur <> Black)) do
			 Begin
					arrRow[count] :=plateau[t_x,t_y];
					t_x := t_x + 1;
					count := count + 1;
			end;

			 t_x := x - 1;
			 while ((t_x >= 0) and (plateau[t_x,t_y].couleur <> Black)) do
			 Begin
					arrRow[count] := plateau[t_x,t_y];
					t_x := t_x - 1;
					count := count + 1;
			end;
			isok := isAllTuilesValid(arrrow,count);
			t_y := t_y + inc ;  // on vérifie les colonnes à gauche    // erreur constaté
			if ((t_y < 0) or (plateau[x,t_y].couleur = Black)) and (inc = -1)  then 
			begin
				t_y := y + 1; // on vérifie les les colonnes à droite
				inc := 1;
			end;	 
		end;
	end;
	IsColorsAndFormsOk := isok;
End;

//**********************************************************************************
// Helper function, pour vérifier si les coord x,y est déjà present dans le tableau fourni
// ce procedure est appelé par CalculateScore
Function IsXYPresentInArray(x,y : integer; arr : player_coord):boolean;
var
b : boolean;
len,i : integer;
Begin
	b := false;
	len := length(arr);
	for i := 0 to len-1 do
	begin
		if ( (arr[i].x = x) and (arr[i].y = y) ) then
		begin
			b := true;
			break;
		end;
	end;
	IsXYPresentInArray := b;
End;

//**********************************************************************************
// Calculer le score du joueur courant

Procedure CalculateScore(play : player_coord; cy : integer);
var
score,x,y,t_y,t_x, i,minX,maxX,minY,maxY, qwirklePoint,len : integer;
horz_pos, vert_pos : player_coord;
isPresent : boolean;
txt : string;
Begin
		score := 0;

        for i := 0 to length(play) -1 do
		begin
            x := play[i].x; y := play[i].y;
			// calculer le scrore dans la direction Y
			minY := y;
            while ((minY - 1 >= 0) and (plateau[x,minY - 1].couleur <> Black)) do minY := minY - 1;
			maxY := y;
            while ((maxY + 1 < length(plateau[0])) and (plateau[x,maxY + 1].couleur <> Black))  do maxY := maxY + 1;
			qwirklePoint := 0;
			
            if minY <> maxY then
			begin
                for t_y := minY to maxY do
				begin
                    isPresent := IsXYPresentInArray (x, t_y,horz_pos);
					if isPresent = false then
					begin
                        score := score + 1;
                        qwirklePoint := qwirklePoint + 1;
                        len := length(horz_pos) + 1;
						setlength(horz_pos,len);
						horz_pos[len-1].x :=x;
						horz_pos[len-1].y := t_y;
					end;
                end;
                if qwirklePoint = qwirkle_score then score := score + qwirklePoint;
            end;
			// calculer le scrore dans la direction X
			minX := x;
            while ((minX - 1 >= 0) and (plateau[minX-1,y].couleur <> Black)) do minX := minX - 1;
			maxX := x;
            while ((maxX + 1 < length(plateau[0])) and (plateau[maxX+1,y].couleur <> Black))  do maxX := maxX + 1;
			qwirklePoint := 0;
			
            if minX <> maxX then
			begin
                for t_x := minX to maxX do
				begin
                    isPresent := IsXYPresentInArray (t_x, y,vert_pos);
					if isPresent = false then
					begin
                        score := score + 1;
                        qwirklePoint := qwirklePoint + 1;
                        len := length(vert_pos) + 1;
						setlength(vert_pos,len);
						vert_pos[len-1].x := t_x;
						vert_pos[len-1].y := y;
					end;
                end;
                if qwirklePoint = qwirkle_score then score := score + qwirklePoint;
            end;
		end;
        joueurs[currentPlayer].score := joueurs[currentPlayer].score + score;
End;

//**********************************************************************************
// validation des positions dans le plateau
// on recupere les coord dans la variable Play pour calculer le score d'un joueur
Function IsPlayValid(x,y,cy,firstPlayer : integer; posTuiles : array of integer; direction : char; var play : player_coord): boolean;
Var
i, t_x,t_y,incX, incY,len,maxX,maxY, count  : integer;
isValid : boolean;
TmpPlateau : board;
choice : char;
txt : string;

Begin
	x := x-1; y := y-1; // car les coord commence à 0,0 , mais le joueur saisie tjrs 1 à maxlengthX et maxlengthY

	t_x := x; t_y := y;
	isValid := false;
	maxX := length(plateau); // nombre de lignes
	maxY :=length(plateau[0]);  // nombre de colonnes
	CopyPlateau(TmpPlateau,1);
	len := length(posTuiles);
	incX := 0; incY := 0;
	if firstPlayer <> 0 then isValid := true;
	case direction of
		'D' : incY := 1;
		'G' : incY := -1;
		'H' : incX := -1;
		'B' : incX := 1;
	end;

	for i := 0 to len-1 do
	begin
		if posTuiles[i] = 0 then break; // absence de tuile à placer, on sort du boucle for
		if plateau[t_x,t_y].couleur <> Black then  break; // vérifie si la position contient déjà une tuile
		// avant de placer on vérifie autour de x,y au moins une case adjacent contient la tuile
		if firstPlayer = 0 then
		begin
			if ( ((t_x-1 >= 0)  and  (plateau[t_x-1,t_y].couleur <> Black)) or ((t_x+1 <  maxX) and (plateau[t_x+1,t_y].couleur <> Black)) or ((t_y-1 >= 0)  and  (plateau[t_x,t_y-1].couleur <> Black)) or ((t_y+1 < maxY) and (plateau[t_x,t_y+1].couleur <> Black)) ) then isValid := true;
		end;
		if isValid = false then break;
		plateau[t_x,t_y].forme:= joueurs[currentPlayer].main[posTuiles[i]-1].forme;
		plateau[t_x,t_y].couleur:= joueurs[currentPlayer].main[posTuiles[i]-1].couleur;
		count := length(play) + 1;
		setlength(play,count);
		play[count-1].x := t_x;
		play[count-1].y := t_y;
        CheckDecalagePlateau(maxX,maxY,t_x,t_y,play);
		t_x := t_x + incX;
		t_y := t_y + incY;
	end;

	if isValid = true then
	begin
		isValid := IsColorsAndFormsOk(play[0].x, play[0].y); 
		if isValid = true then
		begin
			repeat
				AfficherMessage( Yellow,PLAYER_XCOORD,cy,'Votre choix (Valider ou Annuler): ' ,false,false);
				Readln(choice);
				choice := upcase(choice);
			until ((choice = 'V') or (choice = 'A'));
			if  choice = 'A' then isValid := false else CalculateScore(play,cy+2);
		end;
	end;

	if isValid = false then CopyPlateau(TmpPlateau,2); // on recupère l'état précédent du plateau

	IsPlayValid := isValid;
End;

Procedure Repiocher(posTuiles : array of integer);
var
i , count: integer;
Begin
	count := 0;
	for i := 0 to length(posTuiles)-1 do
	begin
		if posTuiles[i] <> 0 then 
		begin
			joueurs[currentPlayer].main[posTuiles[i]-1].forme := ' ';
			joueurs[currentPlayer].main[posTuiles[i]-1].couleur := Black;
			count := count + 1;
		end;
	end;	
	Piocher(currentPlayer,count);
End;

//**********************************************************************************
// Verifie si le joueur voudrait placer plusieurs tuiles pour demander
// dans quelle direction il veut les placer
Function  hasToPlaceManyTiles(posTuiles : array of integer): boolean;
var
i , count: integer;
b : boolean;
Begin
	count := 0;
	b := false;
	for i := 0 to length(posTuiles)-1 do 
	Begin
		if posTuiles[i] <> 0 then count := count + 1;
	end;
	if count > 1 then b := true;
	hasToPlaceManyTiles := b;
End;	
//**********************************************************************************

Procedure Afficherjeu(maxTuiles:integer; displayMain : boolean);
var 
i, cy, maxscore : integer;
txt : string;
Begin
	AfficherPlateau;
	if (maxTuiles > 0) and ( displayMain = true)  then  AfficherMain('Premier joueur', false) else if displayMain = true then AfficherMain(' ', false);
	cy := ((length(Plateau)+1)*2) + 6 ;  // ligne = ((hauteur du plateau+1(position)) * 2(ligne vide entre chaque ligne))  + 6
	
	for i := 0 to length(joueurs)-1 do
	begin
		txt := 'Score de ' +  joueurs[i].nom + ' : ' + IntToStr(joueurs[i].score);
		AfficherMessage(LightCyan, 1,cy,txt ,false,false);
		cy := cy + 1;
	end;
	
	txt := 'Tuiles restantes : ' +  IntToStr(length(sac));
	AfficherMessage(LightCyan, 1,cy,txt ,false,false);
	if displayMain = false then   // message de fin de jeu 
	Begin
		maxscore := 0;
		for i := 0 to  length(joueurs)-1 do
			if  joueurs[i].score > maxscore then
			Begin
				maxscore := joueurs[i].score;
				currentPlayer := i;
			end;
		
		txt := '********* Le jeu est terminé ! *********';
		AfficherMessage(LightBlue, 1,cy+2,txt ,false,false);
		txt := 'Le gagnant est  : ' +  joueurs[currentPlayer].nom + '  / Score => ' + IntToStr(maxscore);
		AfficherMessage(LightBlue, 1,cy+3,txt ,true,false);
	end;
End;


End.
