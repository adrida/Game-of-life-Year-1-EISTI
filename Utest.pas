Unit Utest;

interface

uses Uinit;
procedure disp_plat(plat:plateau; dim : integer);
procedure disp_piece(p:piece);
procedure disp_pioche(p:pioche);

implementation

procedure disp_plat(plat:plateau; dim : integer);
var
i,j : integer;
begin
        i :=  1;
        j :=  1;
        while ( i < dim) do
        begin
                write('--');
        end;
                writeln('--');
        i := 1;
        while (j < dim * 2 ) do
                begin
                        i := i + 1;
                        if ( j mod 2 = 1)then
                        begin
                                while ( i < dim) do
                                begin
                                        write('--');
                                        i := i + 1;
                                end;
                                writeln('--');
                        end
                        else
                        begin
                                i := i + 1;
                                while ( i < dim) do
                                begin
                                        write('| ');
                                        i := i + 1;
                                end;
                                writeln(' |');  
end;
                        j := j +1;
                end;
end;

procedure disp_piece(p:piece);
begin
end;

procedure disp_pioche(p:pioche);
begin
end;

begin
end.

