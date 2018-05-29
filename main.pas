program main;

 uses
         Uinit;

 var
 plat : plateau;
 pioche : pioche;
 begin
 plat := init_plat();
 pioche := init_pioche(6,6,3);
 disp_plat(plat,6);
 end.
