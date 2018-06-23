unit U_bdd;
INTERFACE
uses U_Type,U_Verification;
(*-------------------------------------------------------------------------------------------------------------*)
IMPLEMENTATION
procedure k();
var
variable:integer;
(*-------------------------------------------------------------------------------------------------------------*)
begin
	 case variable of
		 1
		 piec.forme := '<>';
		 piec.couleur :='bleu';

		 2
		 piec.forme := '<>';
		 piec.couleur :='rouge';
		 3
		 piec.forme := '<>';
		 piec.couleur :='vert';
		 4
		 piec.forme := '<>';
		 piec.couleur :='orange';
		 5
		 piec.forme := '<>';
		 piec.couleur :='violet';
		 6
		 piec.forme := '<>';
		 piec.couleur :='jaune';
		 7
		 piec.forme = '><';
		 piec.couleur :='bleu';
		 8
		 piec.forme = '><';
		 piec.couleur :='rouge';
		 9
		 piec.forme = '><';
		 piec.couleur :='vert';
		 10
		 piec.forme = '><';
		 piec.couleur :='orange';
		 11
		 piec.forme = '><';
		 piec.couleur :='violet';
		 12
		 piec.forme = '><';
		 piec.couleur :='jaune';
		 13
		 piec.forme = '()';
		 piec.couleur :='bleu';
		 14
		 piec.forme = '()';
		 piec.couleur :='rouge';
		 15
		 piec.forme = '()';
		 piec.couleur :='vert';
		 16
		 piec.forme = '()';
		 piec.couleur :='orange';
		 17
		 piec.forme = '()';
		 piec.couleur :='violet';
		 18
		 piec.forme = '()';
		 piec.couleur :='jaune';
		 19
		 piec.forme = '++';
		 piec.couleur :='bleu';
		 20
		 piec.forme = '++';
		 piec.couleur :='rouge';
		 21
		 piec.forme = '++';
		 piec.couleur :='vert';
		 22
		 piec.forme = '++';
		 piec.couleur :='orange';
		 23
		 piec.forme = '++';
		 piec.couleur :='violet';
		 24
		 piec.forme = '++';
		 piec.couleur :='jaune';
		 25
		 piec.forme = '**';
		 piec.couleur :='bleu'; 
		 26
		 piec.forme = '**';
		 piec.couleur :='rouge';
		 27
		 piec.forme = '**';
		 piec.couleur :='vert';
		 28
		 piec.forme = '**';
		 piec.couleur :='orange';
		 29
		 piec.forme = '**';
		 piec.couleur :='violet';
		 30
		 piec.forme = '**';
		 piec.couleur :='jaune';
		 31
		 piec.forme = '[]';
		 piec.couleur :='bleu';
		 32
		 piec.forme = '[]';
		 piec.couleur :='rouge';
		 33
		 piec.forme = '[]';
		 piec.couleur :='vert';
		 34
		 piec.forme = '[]';
		 piec.couleur :='orange';
		 35
		 piec.forme = '[]';
		 piec.couleur :='violet';
		 36
		 piec.forme = '[]';
		 piec.couleur :='jaune';
		end;
	end;
	(*-------------------------------------------------------------------------------------------------------------*)
	function Tirage_IA(player:joueur):joueur;
		var
		i:integer;
		Begin
			for i:=low(player.main) to high(player.main) do
				begin
					
				end;
				
		end;
	(*-------------------------------------------------------------------------------------------------------------*)
	function cherche_Seq(plat:plateau):position;
		begin
		
		end;
	(*-------------------------------------------------------------------------------------------------------------*)
END.
