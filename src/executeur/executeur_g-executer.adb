with Ada.Text_IO;
with Ada.Numerics.Generic_Elementary_Functions;
with Ada.Numerics.Float_Random;

separate (Executeur_G)
procedure Executer
   --  (Arguments)
is
   type Calcul_T is digits 5;

   type Indice_T       is range 1 .. 10;
   type Table_Calcul_T is array (Indice_T) of Calcul_T;

   package Aleatoire_R renames Ada.Numerics.Float_Random;

   package Math_IO is new Ada.Text_IO.Float_IO (Calcul_T);
   package Math_P  is new Ada.Numerics.Generic_Elementary_Functions
      (Calcul_T);

   X : constant Calcul_T := 5.0;
   D : constant Calcul_T := 2.0;
   R : Calcul_T;

   Resultats : Table_Calcul_T := Table_Calcul_T'(others => 0.0);

   Generateur : Aleatoire_R.Generator;

   ---------------------------------------------------------------------------
   function Generer
      return Calcul_T;

   function Generer
      return Calcul_T
   is
      Resultat : Calcul_T;
   begin
      --  Pour un résultat entre 1.0 et 4.0;
      Resultat := Calcul_T (3.0 * Aleatoire_R.Random (Generateur) + 1.0);
      return Resultat;
   end Generer;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   procedure Put_Line
      (Item : in Table_Calcul_T);

   procedure Put_Line
      (Item : in Table_Calcul_T)
   is
   begin
      for E of Item loop
         Math_IO.Put     (Item => E, Fore => 3, Aft => 3, Exp => 0);
         Ada.Text_IO.Put (Item => " ");
      end loop;
      Ada.Text_IO.New_Line (Spacing => 1);
   end Put_Line;
   ---------------------------------------------------------------------------
begin
   R := 10.0 + (X**2) - 10.0 * Math_P.Cos (X => 2.0 * Ada.Numerics.Pi * X);

   Math_IO.Put          (Item    => R, Fore => 3, Aft => 3, Exp => 0);
   Ada.Text_IO.New_Line (Spacing => 1);

   R := Ada.Numerics.Pi * ((D**2) / 2.0) + 4.0 * (160.0 / D);

   Math_IO.Put          (Item    => R, Fore => 3, Aft => 3, Exp => 0);
   Ada.Text_IO.New_Line (Spacing => 1);

   Aleatoire_R.Reset (Generateur);
   for E of Resultats loop
      E := Generer;
   end loop;

   Put_Line (Item => Resultats);
end Executer;
