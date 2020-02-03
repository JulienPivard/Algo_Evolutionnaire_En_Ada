with Ada.Text_IO;
with Ada.Numerics.Generic_Elementary_Functions;

separate (Executeur_G)
procedure Executer
   --  (Arguments)
is
   type Calcul_T is digits 5;

   package Math_IO is new Ada.Text_IO.Float_IO (Calcul_T);
   package Math_P  is new Ada.Numerics.Generic_Elementary_Functions
      (Calcul_T);

   X : constant Calcul_T := 5.0;
   D : constant Calcul_T := 2.0;
   R : Calcul_T;
begin
   R := 10.0 + (X**2) - 10.0 * Math_P.Cos (X => 2.0 * Ada.Numerics.Pi * X);

   Math_IO.Put          (Item    => R, Fore => 3, Aft => 3, Exp => 0);
   Ada.Text_IO.New_Line (Spacing => 1);

   R := Ada.Numerics.Pi * ((D**2) / 2.0) + 4.0 * (160.0 / D);

   Math_IO.Put          (Item    => R, Fore => 3, Aft => 3, Exp => 0);
   Ada.Text_IO.New_Line (Spacing => 1);
end Executer;
