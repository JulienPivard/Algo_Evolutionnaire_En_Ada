with Ada.Text_IO;

package body A_E_P.Individu_G.Text_IO
   with Spark_Mode => Off
is

   ---------------------------------------------------------------------------
   procedure Put_Line
      (Item : in     Individu_T)
   is
   begin
      Put_Parametres (Item => Item.V_Param);

      Ada.Text_IO.Put  (Item => " |<>| ");

      Put_Resultat (Item => Item.V_Calcule);

      Ada.Text_IO.New_Line (Spacing => 1);
   end Put_Line;
   ---------------------------------------------------------------------------

end A_E_P.Individu_G.Text_IO;
