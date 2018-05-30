 Unit Uinit;

 interface

 (*----------Type def d'une piece---------------*)
 Type
         piece = record
         symb : integer;
         color : integer;
         end;

 (*---------Type def d'une main---------------*)
         hand = array of piece;

 (*----------Type def d'un joueur---------------*)
         joueur = record
         nom : string;
         main : hand;
         score : integer;
         end;
         
 (*----------Type def des coordonées-------------*)        
 	   coord = record
 	   x : integer;
 	   y : integer;
 	   end;


 (*----------Type def d'un plateau---------------*)
         plateau = array of array of piece;

 (*----------Type def de la pioche---------------*)
         pioche = array of piece;

 (*----------Type def de la liste de joueurs---------------*)
         players = array of joueur;

 function init_plat():plateau;
 function init_pioche(typ,col,id:integer):pioche;

 implementation
 uses Utest;
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
  setlength(p ,taille);
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
                         p[i].color := j;
                         i := i + 1;
                         c := c + 1;
                 end;
  b := b + 1;
         end;
         a := a + 1;
 end;
 end;
 begin
 end.

