with Ada.Text_IO;

package body A_E_P.Individu_G.Text_IO
   with Spark_Mode => Off
is

   package V_Calcule_IO is new Ada.Text_IO.Float_IO
      (Num => A_E_P.V_Calcule_T);

   ---------------------------------------------------------------------------
   procedure Put_Line
      (Item : in Individu_T)
   is
   begin
      Put (Item => Item.V_Param);

      Ada.Text_IO.Put  (Item => " |<>| ");
      Ada.Text_IO.Put  (Item => " |=> Résultat : ");
      V_Calcule_IO.Put
         (
            Item => Item.V_Calcule,
            Fore => 3,
            Aft  => 3,
            Exp  => 0
         );

      Ada.Text_IO.New_Line (Spacing => 1);
   end Put_Line;
   ---------------------------------------------------------------------------

end A_E_P.Individu_G.Text_IO;
