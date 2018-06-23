Unit UTypes;


interface

{$IFDEF FPC}{$MODE OBJFPC}{H$H+}{$ENDIF}
{$APPTYPE CONSOLE}
uses crt,sysutils, math, classes;
Const
     PLAYER_XCOORD = 40;
Type
	tuile = record
		forme : char;
		couleur : byte;
	end;
	joueur = record
		nom : string;
		age : integer;
		score : integer;
		typedejoueur : char; // humain ou ordinateur , mais dans cette version on ne gere ques les humains
		etat : char; // etat devient 'P' en cas d'impossibilité pour jouer ( sac vide et il ne peut pas placer dans le plateuau
		main :  array of tuile;
	end;
	coord = record
		x , y : integer;
	end;
	board = array of array of tuile;
	one_row = array of Tuile;  // permet de sauvegarder toutes les tuiles dans une ligne ou colonne  
	player_coord = array of coord;
var
	qwirkle_score : integer = 6;
	display_utilisation : boolean = false;
	currentPlayer : integer = -1;
	DEFAULT_FORMES : array[1..10] of char = (char(42),char(43),char(79),char(61),char(35),char(36),char(37),char(38),char(64),char(63));
	//DEFAULT_FORMES : array[1..10] of char = ('*','+','ⵔ','¤','ø','ⵠ','a','b','c','d');
	DEFAULT_COULEURS : array[1..10] of byte = (LightCyan,Yellow,Red,Green,Magenta,White,Brown,LightBlue,Cyan,Blue);

	sac :  array of tuile;
	plateau : array of array of tuile;
	joueurs : array of joueur;

implementation

End.
