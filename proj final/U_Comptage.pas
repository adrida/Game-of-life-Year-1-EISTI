unit U_Comptage;

INTERFACE

uses U_Type,classes,unix,U_Verification ,U_Affichage;

function compteur_point(S_tuile_poser: tabTuilePos; plat:plateau):integer;

function comptage1(x,y:integer;plat:plateau;player:joueur):joueur;

type
	position=Record
		x:integer;
		y:integer;
		score:integer;
	end;

arr1d = array of position;
 

IMPLEMENTATION

(*-------------------------------------------------------------------------------------------------------------*)

function comptage1(x,y:integer;plat:plateau;player:joueur):joueur;
	var
		
		i,ch,cb,cg,cd:integer;
	begin
	
		ch:=0;
		cb:=0;
		cd:=0;
		cg:=0;
		
		if	not(y=0) then//horizontale gauche
			begin
				i:=1;
				while (plat[x,y-i].forme) <> 'vid'  do
					begin
						cg:=cg+1;
						i:=i+1;
					end;
			end;
			
		if not(high(plat[1]) = y) then//horizontale droite
			begin
				i:=1;
				while (plat[x,y+i].forme) <> 'vid' do
					begin
						cd:=cd+1;
						i:=i+1;
					end;
			end;
	
		if	not(x=0) then//verticale haute 
			begin
				i:=1;
				while (plat[x-i,y].forme) <> 'vid' do
					begin
						ch:=ch+1;
						i:=i+1;
					end;
			end;
			
		if not(high(plat) = x) then//verticale bas
			begin
				i:=1;
				while (plat[x+i,y].forme) <> 'vid' do
					begin
						cb:=cb+1;
						i:=i+1;
				end;
			end;
			
		if (cb=5) then
			cb:=11;
		if (cd=5) then
			cd:=11;	
		if (ch=5) then
			ch:=11;
		if (cg=5) then
			cg:=11;
			
		player.score:=player.score+cb+cd+ch+cg+1;

		comptage1:=player;
	end;
(*-------------------------------------------------------------------------------------------------------------*)
procedure echanger(arr:arr1d;i,j:integer);
	var
	tmp:integer;
	begin
		tmp:=arr[i].score;
		arr[i].score:=arr[j].score;
		arr[j].score:=tmp;
	end;

(*-------------------------------------------------------------------------------------------------------------*)
function partitionner(arr:arr1d;debut,fin:integer):integer;
	Var
		i,j:integer;
		pivot:integer;
	Begin
	pivot:=arr[debut].score;
	i:=debut+1;
	j:=fin;
	while (i<=j) do
		begin	
			while (i<=fin) and (arr[i].score < pivot) do
				i:=i+1;
			while (j>debut) and (arr[j].score >= pivot) do
				j:=j-1;
			if (i<j) then 
				begin	
					echanger(arr,i,j);
				end;
		end;	
	arr[debut].score:=arr[j].score;
	arr[j].score:=pivot;
	partitionner:=j;
	End;
	
(*-------------------------------------------------------------------------------------------------------------*)	
procedure trirapide(arr:arr1d;debut,fin:integer);
	var
		pivot:integer;
	begin
		if (debut<fin) then
			begin
				pivot:=partitionner(arr,debut,fin);
				trirapide(arr,debut,pivot-1);
				trirapide(arr,pivot+1,fin);
			end;
	
	end;
(*-------------------------------------------------------------------------------------------------------------*)
//________________________A TESTER______________________________________

function Taille_S_inverse (x1,y1,x_static,y_static:integer;plat:plateau):integer;
	var
	taille_Moins_tuile:integer;
	begin
		if (x1=x_static) then
			begin
				taille_moins_tuile := length(Sequence_Verticale(x1,y1,plat));
			end
		else if (y1 = y_static) then
			begin
				taille_moins_tuile :=length(Sequence_Horizontale(x1,y1,plat));			
			end;
		if (taille_moins_tuile=5) then
			taille_moins_tuile:=taille_moins_tuile+7   //quickle + tuile
		else if (taille_moins_tuile >=1) then
			taille_moins_tuile:=taille_moins_tuile+1;   //on ajoute la tuile finalement
		taille_S_inverse:=taille_moins_tuile;
	end;
	
(*-------------------------------------------------------------------------------------------------------------*)	
function Taille_Alligner (x1,x2,y1,y2:integer; plat:plateau):integer;
var	
	taille_tuille:integer;
begin
	if(x1=x2) then
			taille_tuille :=length(Sequence_Horizontale(x1,y1,plat))
	else
			taille_tuille := length(Sequence_Verticale(x1,y1,plat));
	Taille_Alligner:=(taille_tuille+1);                                           //ajout du point de la case x1,y1


end;
(*-------------------------------------------------------------------------------------------------------------*)//compte le nombre de point a partir de la séquence de tuile poser
function compteur_point(S_tuile_poser: tabTuilePos; plat:plateau):integer;
var	
	i:integer;
	Point:integer;
	stockpoint1,stockpoint2:integer;
begin
	/// ne pas oublier de compter l'allignement
	point:=0;
	if (length(S_tuile_poser) = 1) then
		begin
			stockpoint1:= (length (Sequence_Horizontale( S_tuile_poser[0].x,S_tuile_poser[0].y,plat)));  //recolte la taille des séquences horizontales
						if (stockpoint1) >= 1 then //regler le probleme du point qui manque '' il comptait la sequence mais pas la tuile poser''
							stockpoint1:=stockpoint1+1;
			stockpoint2:= (length (Sequence_Verticale( S_tuile_poser[0].x,S_tuile_poser[0].y,plat)));
						if (stockpoint2) >= 1 then //regler le probleme du point qui manque '' il comptait la sequence mais pas la tuile poser''
							stockpoint2:=stockpoint2+1;
			
			if(stockpoint1+stockpoint2 =0 )then
				point:=1
			else
			begin
				if stockpoint1 = 5 then
					stockpoint1:=stockpoint1 +6;
				if stockpoint2= 5 then
					stockpoint2:=stockpoint2+6;
				afficherdonne(Sequence_Verticale( S_tuile_poser[0].x,S_tuile_poser[0].y,plat));
				//if(stockpoint
				point := (stockpoint1)+(stockpoint2);
			end;
			
		end
	else if(length(S_tuile_poser)>1) then
		begin
			stockpoint1:= Taille_S_inverse(S_tuile_poser[0].x, S_tuile_poser[0].y,  S_tuile_poser[1].x, S_tuile_poser[1].y, plat);//initialisation comptage
			for i:=1 to length(S_tuile_poser)-1 do  //comptage des sequences inverses sur ma sequence de tuile poser.
			begin
				stockpoint1:= stockpoint1 + Taille_S_inverse(S_tuile_poser[i].x, S_tuile_poser[i].y,  S_tuile_poser[0].x, S_tuile_poser[0].y, plat);
			end;
			stockpoint1:=stockpoint1 +Taille_Alligner(S_tuile_poser[0].x, S_tuile_poser[1].x ,S_tuile_poser[0].y, S_tuile_poser[1].y, plat);
			point:=stockpoint1;
		
		end;

	compteur_point:=point;
end;

(*-------------------------------------------------------------------------------------------------------------*)

END.
