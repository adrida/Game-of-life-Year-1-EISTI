Unit Uinit;

interface

Type 
	pNoeud = ^Noeud;
	Noeud = record
	valeur : integer;
	suivant : pnoeud;
	end.
(*----------Type def d'une piece---------------*)
Type
	piece = record 
	symb = integer;
	color = integer;
end.

(*----------Type def d'un plateau---------------*)
Type 
	plateau = array of array of piece;
end.

(*----------Type def de la pioche---------------*)
Type 
	pioche = array of piece;
end.

(*---------Type def d'une main---------------*)
Type 
	hand = array of piece;
end.

(*----------Type def d'un joueur---------------*)
Type
	joueur = record
	nom = string;
	main = hand;
	score = integer;
end.

(*----------Type def de la liste de joueurs---------------*)
Type
	players = array of joueur;
end.

function init_plat():plateau;
function init_pioche(typ,col,id:integer):pioche;

implementation

(*----------------INITIALISATEUR DU PLATEAU DE JEU-------------*)
function init_plat():plateau;
var
	plat : plateau;
	empt_piece : piece;
	i,j : integer;
begin
	i := 0;
	j := 0;
	empt_piece.symb := 0;
	empt_piece.color := 0;
	while (i <= 6)do
	begin
		while (j <= 6) do
		begin
			plat[i][j] := empt_piece;
			j := j + 1;	
		end;
		i := i + 1; 
	end;
	init_plat := plat;
end;

(*-----------------------CREATION DES PIECES-------------------------*)
(*----PREND EN PARAM LE NB DE TYP COULEURS ET PIECES IDENTIQUES------*)
function init_pioche(typ,col,id:integer):pioche;
var
taille : integer;
p : pioche;
a,b,i,j,c : integer;

begin
taille := typ*col*id;
setlength(taille ,p);
if((typ <= 1) or (col <= 1) or (id <= 1)) then
begin	
	writeln('Nombres d''entrees invalides');
	init_pioche := p;
end;	
a := 1;	
b := 1;
c := 1;
i := 1;
j := 20;
while (a <= typ) do
begin;
	j := j + 1;
	b := 1;
	while (b <= col)do
	begin
		c := 1;
		while (c <= id) do
		begin                           
			p[i].symb := a; 
			p[i].col := j;
			i := i + 1;
			c := c + 1;
		end;
		b := b + 1;
	end;
	a := a + 1;
end;
end;
