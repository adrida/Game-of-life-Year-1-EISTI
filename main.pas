program main;

 uses
         Uinit,Utest;

 var
 plat : plateau;
 p : pioche;
 begin
 plat := init_plat();
 p := init_pioche(6,6,3);
 disp_plat(plat,6);
 end.
