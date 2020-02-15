with Ada.Text_IO;

with A_E_P.Valeur_Param_P.Text_IO;

package body A_E_P.Parametres_P.Surface_P.Text_IO
   with Spark_Mode => Off
is

   ---------------------------------------------------------------------------
   procedure Put
      (Item : in Surface_T)
   is
   begin
      Ada.Text_IO.Put                  (Item => " | X : ");
      A_E_P.Valeur_Param_P.Text_IO.Put (Item => Item.Param_1);
   end Put;
   ---------------------------------------------------------------------------

end A_E_P.Parametres_P.Surface_P.Text_IO;
