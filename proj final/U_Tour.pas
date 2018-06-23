Unit U_Tour;
INTERFACE
uses sysutils,crt,math,U_Verification,U_Type,U_Affichage,U_Actualisation_Grille;

(*-------------------------------------------------------------------------------------------------------------*)
procedure continuer_recursive(var player:joueur; var plat:plateau; var arr:tabpiecepos; x1,y1,x2,y2,iteration:integer);
//function actualiser_tab_piece_pos( arr:tabpiecePos):tabpiecePos;
function actualiser_tab_piece_pos( arr:tabpiecePos):tabpiecePos;
procedure actualiser_positions(var arr:tabpiecepos; var plat:plateau);

IMPLEMENTATION
(*-------------------------------------------------------------------------------------------------------------*)
procedure placement(player:joueur; plat:plateau; piec_donne:piece_donne ; x,y:integer);
	begin
		plat[x,y].forme:=piec_donne.piec.forme;
		plat[x,y].couleur:=piec_donne.piec.couleur;
		player.main[piec_donne.placement].forme:='neant';
		player.main[piec_donne.placement].couleur:='noir';
	end; 
(*-------------------------------------------------------------------------------------------------------------*)	
function verification_alignement(x1,x2,y1,y2:integer;plat:plateau):boolean;
	var
	i:integer;
	flag:boolean;
	begin
		flag:=true;
		if (x1=x2) and (y1=y2) then
		begin
			flag:=false;
		end
		else
		begin
			if (x1=x2) then
			begin
				i:= min(y1,y2)+1;
				while( i <> max(y1,y2)) do
					begin
					writeln('i : ',i);
					if (plat[x1,i].forme = 'neant' ) then
						begin
							flag:=false;
							break;
						end; 
						i:=i+1;
					end;
			end	
			else if (y1= y2) then
				begin
					i:= min(x1,x2)+1;// pas prendre la case qu'on veut placer parce quelle est pas encore placée
					while (i<> max(x1,x2)) do
					begin
						
						if (plat[i,y1].forme= 'neant' ) then
						begin
							writeln(plat[i,y1].forme);
							flag:=false;
							break;
						end;
						i:=i+1;
					end;
				end
			else
				begin
				flag:= false;
				end;
		end;
		verification_alignement:=flag;
	end;
(*-------------------------------------------------------------------------------------------------------------*)
function verification_alignement2(x1,x2,x3,y1,y2,y3:integer;plat:plateau):boolean;
	var
	flag:boolean;
	begin
		flag:=false;
		writeln;
		writeln(verification_alignement(x1,x3,y1,y3,plat));
		writeln(verification_alignement(x2,x3,y2,y3,plat));
		if  verification_alignement(x1,x3,y1,y3,plat) and verification_alignement(x2,x3,y2,y3,plat) then
			 flag:=true;
		verification_alignement2:=flag;
	end;
	
(*-------------------------------------------------------------------------------------------------------------*)	
function choix_piece (main:donne):piece_donne;    
var x:integer;
flag:boolean;
	elu:piece_donne;
begin
	textcolor(lightgray);
	flag:=false;
	writeln('voici votre donne:');
	afficherdonne(main);
	textcolor(lightgray);
	writeln('veuillez choisir un element de 1 a ', length(main)); //
	while(flag <> true) do
	begin
		readln(x);
		x:=x-1;
		if (('neant' <> main[x].forme) and ((x >= 0) and (x<length(main)))) then
			begin
			flag := true;
			elu.piec.forme:= main[x].forme; 
			elu.piec.couleur:= main[x].couleur;     //a verifier
			elu.placement:=x;
			//piece.place_dans_la_donne:=x;
			end
		else
			writeln('l''element selectionner n''est pas disponible, recommencez');
	end;
	choix_piece:=elu;
end;	
(*-------------------------------------------------------------------------------------------------------------*)
function continuation(player:joueur):boolean;
	var
	g:string;
	c:boolean;
	begin
		writeln('Voici votre donne');
		afficherdonne(player.main);
		writeln('Voulez vous continuer à placer des pieces ? (o/n)');
		readln(g);
		if (g<>'n') and (g<>'o') then
			begin
			writeln('Votre choix n''est pas valide veuillez repondre correctement a la question suivante');
			continuation(player);
			end
		else if (g='o') then
			begin
				c:=TRUE;			
			end
		else 
			begin
			writeln('Vous avez fini votre tour,c''est au joueur suivant de jouer');
			c:=FALSE;
			end;
		continuation:=c;
			
	end;
(*-------------------------------------------------------------------------------------------------------------*)
function verif_neant(x,y:integer;plat:plateau):boolean;   //verifie que la case est libre
	var
	flag:boolean;
	begin
		flag:=true;
		if (plat[x,y].forme <> 'neant') then
			flag:=false;
		verif_neant:=flag;
	end;
(*-------------------------------------------------------------------------------------------------------------*)	
procedure viderTabpieces(arr:tabpiecePos);
	var
		i:integer;
	begin
		for i:=low(Arr) to high(Arr) do
			begin
				arr[i].piec.couleur := 'noir';
				arr[i].piec.forme := 'neant';  
			end;
	end;	
(*-------------------------------------------------------------------------------------------------------------*)	
procedure actualiser_positions(var arr:tabpiecepos; var plat:plateau);
	var
	i:integer;
	decalx,decaly:boolean;
	begin
		decalx:=false;
		decaly:=false;
		for i:=low(plat) to high(plat) do
			if (plat[i,0].forme <> 'neant') then
				begin
					decaly:=true;
					break;
				end;
				
		for i:=low(plat[0]) to high(plat[0]) do
			if (plat[0,i].forme <> 'neant') then
				begin
					decalx:=true;
					break;
				end;
				
		if decaly then
			begin
				for i:=low(arr) to high(arr) do
					begin
						arr[i].y:=arr[i].y+1;
					end;
			end;
		if decalx then
			begin
				for i:=low(arr) to high(arr) do
					begin
						arr[i].x:=arr[i].x+1;
					end;
			end;	
	end;

procedure continuer_recursive(var player:joueur; var plat:plateau; var arr:tabpiecepos; x1,y1,x2,y2,iteration:integer);//toujours à 0 pour l'appel
	var
	x,y,x3,y3,k:integer;
	piec,piec_v1,piec_v2,piec_v3:piece_donne;
	compteur:integer;
	b:boolean;
	begin
		clrscr;
		writeln('bonjour');
		if (iteration = 0 ) then
			begin
			setlength(arr,length(player.main));
			viderTabpieces(arr);
			end;
		actualiser_positions(arr,plat);
		plat:=actualiser(plat);
		writeln('Voici la grille actuelle');
		showarr2D(plat);
		piec := choix_piece(player.main);  //choix de piec dans la donne
		textcolor(lightgray);
		writeln('iteration :',iteration);
		writeln('Saisir la position de la piece sur la grille ');
			
		
		if (iteration > 0 ) then
		begin
		writeln('(-1,-1) si vous ne voulez pas placer de case');
		end;
		write('x : ');
		readln(x);
		write('y : ');
		readln(y);
		
		if iteration = 0 then
			k:=0
		else
			k:=-1;
		
		while ((x<k) or (x>high(plat))) or ((y<k) or (y>high(plat[0]))) do
			begin
				writeln('Vous avez saisi des positions invalides veuillez recommencer');
				write('x : ');
				readln(x);
				write('y : ');
				readln(y);
			end;
			
		if (iteration>0) and (x=-1) and (y=-1) then
			begin
			iteration:=-1;
			writeln('Vous avez fini votre tour,c''est au joueur suivant de jouer');
			end
		else
		begin	
			if (iteration=0) then//initialisation 
				begin
					piec_v1:=piec;
					x1:=x;
					y1:=y;
					arr[0].piec:=piec_v1.piec;
					arr[0].x:=x1;
					arr[0].y:=y1;
					if Verification_Totale(x1,y1, plat, piec_v1.piec) and verif_neant(x1,y1,plat) then
						begin
							clrscr;
							placement(player,plat,piec_v1,x1,y1);
							writeln('=======Vous avez placé une piece=====');
							showarr2D(plat);
							if (x1=0) then
								x1:=1;
							if (y1=0) then
								y1:=1;
							if continuation(player) then
								begin
									iteration:=iteration+1;
									continuer_recursive(player,plat,arr,x1,y1,0,0,iteration);
								end;
						end
					else
						begin
							writeln('Vous avez saisi une position invalide, appuyez sur entrer pour continuer :');
							readln;
							continuer_recursive(player,plat,arr,0,0,0,0,0);
						end;
				end
				else
						begin
							if (iteration=1) then// deuxieme case
							begin
							piec_v2:=piec;
							x2:=x;
							y2:=y;
							writeln('X1 : ',x1,' Y1 : ',y1);
							writeln('X2 : ',x2,' Y2 : ',y2);
							writeln(Verification_Totale(x2,y2, plat, piec_v2.piec));
							writeln(verification_alignement(x1,x2,y1,y2,plat));
							writeln(verif_neant(x2,y2,plat));
							b:=Verification_Totale(x2,y2, plat, piec_v2.piec) and verification_alignement(x1,x2,y1,y2,plat) and verif_neant(x2,y2,plat);
							arr[1].piec:=piec_v2.piec;
							arr[1].x:=x2;
							arr[1].y:=y2;
							writeln('hh');
							if b then
								begin
									clrscr;
									writeln('hahahahah');
									placement(player,plat,piec_v2,x2,y2);
									writeln('=======Vous avez placé une piece=====');
									showarr2D(plat);
									
									if continuation(player) then
										begin
											
											iteration:=iteration+1;//continuer oui/non
											continuer_recursive(player,plat,arr,x1,y1,x2,y2,iteration);
										end;
								end
							else
								begin
									writeln('Vous avez saisi une position invalide, appuyez sur entrer pour continuer');
									readln;
									continuer_recursive(player,plat,arr,x1,y1,0,0,1);
								end;
						end
				else
					begin
						if (iteration=2) then// troisieme case et +
							begin
								piec_v3:=piec;
								x3:=x;
								y3:=y;
								if Verification_Totale(x3,y3, plat, piec_v3.piec) and verification_alignement2(x1,x2,x3,y1,y2,y3,plat) and verif_neant(x3,y3,plat)  then
									begin
										clrscr;
										writeln('=======Vous avez placé une piece=====');
										placement(player,plat,piec_v3,x3,y3);
										compteur:=0;
										while (arr[compteur].piec.forme <> 'neant') do
											compteur:=compteur+1;
											
										arr[compteur].piec := piec_v3.piec;
										arr[compteur].x := x3;
										arr[compteur].y := y3;
										
										showarr2D(plat);
										if continuation(player) then
										continuer_recursive(player,plat,arr,x1,y1,x2,y2,2);    //ca devrais pas etre iteration dans les paramétre?..........................
									end
								else
									begin
										writeln('Vous avez saisi une position invalide, appuyer sur entrer pour continuer');
										readln;
										continuer_recursive(player,plat,arr,x1,y1,x2,y2,2);
									end;
							end;
					end;
				end;
		end;
		
	end;
(*-------------------------------------------------------------------------------------------------------------*)

function actualiser_tab_piece_pos( arr:tabpiecePos):tabpiecePos;
	var
	arr1:tabpiecePos;
	i,n,j:integer;
	begin
	for i:=low(arr) to high(arr) do
		write(arr[i].piec.forme, '||');
	n:=0;
	j:=0;
	for i:=low(arr) to high(arr) do
		begin
			if (arr[i].piec.forme <>'neant') then
				n:=n+1
		end;
		writeln(n);
		setlength(arr1,n);
	for i:=low(arr) to high(arr) do
		begin
			if (arr[i].piec.forme <>'neant') then
				begin
					arr1[j].piec:=arr[i].piec;
					arr1[j].x:=arr[i].x;
					arr1[j].y:=arr[i].y;
					j:=j+1;
				end;
		end;
		
	 actualiser_tab_piece_pos:=arr1;
	end;
(*-------------------------------------------------------------------------------------------------------------*)
end.
	
	
	
	
	
	
	
	
