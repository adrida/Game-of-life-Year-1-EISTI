Unit U_Finition;
INTERFACE
uses U_Type,U_Param,U_TirageEchange,crt,U_Creation,U_Tour,U_Comptage,U_Placement,U_Actualisation_Grille,U_Affichage;
(*-------------------------------------------------------------------------------------------------------------*)
function namej(j1:joueur):joueur;
function echange_placement(j1:joueur):boolean;
function initialiser_main(var j1:joueur;var pioc:pioche):joueur;
function nommachine(j1:joueur):joueur;
procedure init_joueur(var j1,j2:joueur; var pioc:pioche);
procedure initgame(var pioc:pioche;var plat:plateau; var j1,j2:joueur);
Procedure Init_Tour(Var pioc:pioche;var plat:plateau; player:joueur; var arr:tabpiecepos);
Procedure Tous_Les_Tours(Var pioc:pioche;var plat:plateau;var j1,j2:joueur; var arr:tabpiecepos;qui:integer);
IMPLEMENTATION
(*-------------------------------------------------------------------------------------------------------------*)
function namej(j:joueur):joueur;
	var
	name:string;
	begin
		Clrscr;
		writeln('Nom joueur :');
		readln(name);
		j.nom:=name;
		clrscr;
		writeln;
	namej:=j1
	end;
(*-------------------------------------------------------------------------------------------------------------*)

function nommachine(j1:joueur):joueur;
	var
	nom:string;
	int:char;
	i:integer;
	begin
		writeln('Ce testeur est une machine voici ses caracteristiques : ' );
		nom:='Modele ';
		for i:=0 to 4 do
			begin
				int:=chr(random(25)+65);
				nom:=concat(nom,int);
			end;
		J1.nom:=nom;
		Writeln('Nom :');
		writeln(j1.nom);
	nommachine:=j1;
	end;
(*-------------------------------------------------------------------------------------------------------------*)	
function echange_placement(j1:joueur):boolean;
	var
	ver:boolean;
	p:integer;
	begin
	clrscr;
	writeln('Tour actuel : ',j1.nom,);
	writeln('Votre choix : ');
	writeln('1. Repiocher');
	writeln('2. Poser');
	readln(p);
	if (p <> 1) and (p <> 2) then
		begin
			echange_placement(j1);
		end;
	if p=1 then
	ver:=true
	else 
	ver:=false;
	echange_placement:=ver;
	
	end;
(*-------------------------------------------------------------------------------------------------------------*)

function initialiser_main(var j1:joueur;var pioc:pioche):joueur;
	var
	i:integer;
	begin
	setlength(j1.main,6);
	for i:=low(j1.main) to high(j1.main) do
	begin
		j1.main[i].forme:='vid';
		j1.main[i].couleur:='noir';
	end;
	tirage_total(pioc,j1);
	initialiser_main:=j1;
	end;


(*-------------------------------------------------------------------------------------------------------------*)

procedure init_joueur(var j1,j2:joueur;var pioc:pioche);
	begin
	eval_parameters(j1,j2);
	
	if (j1.caractere = 'humain' ) then
		begin
			j1:=initialiser_main(j1,pioc);
			j1:=nomjoueur(j1);
			j1.score:=0;
		end;
		
	if (j1.caractere = 'machine') then
		j1:=nommachine(j1);
		
	if (j2.caractere = 'humain' ) then
		begin
			j2:=initialiser_main(j2,pioc);
			j2:=nomjoueur(j2);
			while (j1.nom = j2.nom) do
				begin
					writeln('Vous ne pouvez pas choisir ce nom');
					delay(2000);
					j2:=nomjoueur(j2);
				end;
			j2.score:=0;
		end;
		
	if (j2.caractere = 'machine') then
		j2:=nommachine(j2);
	end;

(*-------------------------------------------------------------------------------------------------------------*)
procedure initgame(var pioc:pioche;var plat:plateau;var j1,j2:joueur);
	begin
		setlength(pioc,108);
		plat:=creertableau;
		remplirepioche(pioc);
		init_joueur(j1,j2,pioc);
	end;
(*-------------------------------------------------------------------------------------------------------------*)
Procedure Init_Tour(Var pioc:pioche;var plat:plateau; player:joueur; var arr:tabpiecepos);
	begin
		if echange_placement(player) then// on echange
			begin
			showarr2D(plat);
			player:=echanger(player,pioc)
			end
		else
			placer_total(player,plat,arr);
		tirage_total(pioc,player );
	end;
(*-------------------------------------------------------------------------------------------------------------*)
function estvide(pioc:pioche):boolean;
	var
	i:integer;
	bool:boolean;
	begin
	i:=0;
		bool:=true;
		while (i<=high(pioc)) do
			begin
				if pioc[i].forme <> 'vid' then
					begin
						bool:=false;
						break;
					end;
				i:=i+1;
			end;
		estvide:=bool;
	end;

(*-------------------------------------------------------------------------------------------------------------*)
Procedure Tous_Les_Tours(Var pioc:pioche;var plat:plateau;var j1,j2:joueur; var arr:tabpiecepos;qui:integer);
	var
	i:integer;
	begin
		if not estvide(pioc) then
			begin
				if qui = 1 then
					begin
						Init_Tour(pioc,plat,j1,arr);
						arr:=actualiser_tab_piece_pos(arr);
						actualiser_positions(arr,plat);
						plat:=actualiser(plat);
						writeln('---pour verifier---');
						showarr2D(plat);
						writeln;
						j1.score:=j1.score+compteur_point(arr,plat);
						writeln('Score testeur numero 1 : ',j1.score);
						delay(2000);
						Tous_Les_Tours(pioc,plat,j1,j2,arr,2);
					end
				else
					begin
						Init_Tour(pioc,plat,j2,arr);
						arr:=actualiser_tab_piece_pos(arr);
						actualiser_positions(arr,plat);
						plat:=actualiser(plat);
						
						j2.score:=j2.score+compteur_point(arr,plat);
						writeln('Score testeur 2 : ',j2.score);
						delay(2000);
						Tous_Les_Tours(pioc,plat,j1,j2,arr,1)
					end;
			end;
		Writeln('Partie Finie');
		writeln('Voici les scores');
		writeln(j1.nom,' : ',j1.score);	
		writeln(j2.nom,' : ',j2.score);			
	end;
	(*-------------------------------------------------------------------------------------------------------------*)
END.
