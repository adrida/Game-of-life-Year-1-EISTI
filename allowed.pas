



function allowed(c:coord):boolean;
var	k: plateau;
	i:integer;



allowed := true
(*Couleur ou forme différente*)
For i:= 1 to 101 do begin
	for j:= 1 to 101 do begin 
		If (k[x,y].color != k[x+i,y].color) or (k[x,y].color != k[x-i,y].color) 
			or (k[x,y].color != k[x,y+j].color) (k[x,y].color != k[x,y-j].color)

	then allowed := false





