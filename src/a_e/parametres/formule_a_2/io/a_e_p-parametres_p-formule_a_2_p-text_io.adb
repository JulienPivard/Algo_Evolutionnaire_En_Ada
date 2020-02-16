with Ada.Text_IO;

with A_E_P.Valeur_Param_G.Text_IO;

pragma Elaborate_All (A_E_P.Valeur_Param_G.Text_IO);

package body A_E_P.Parametres_P.Formule_A_2_P.Text_IO
   with Spark_Mode => Off
is

   package Valeur_Param_X_IO is new Valeur_Param_X_P.Text_IO;
   package Valeur_Param_Y_IO is new Valeur_Param_Y_P.Text_IO;

   ---------------------------------------------------------------------------
   procedure Put
      (Item : in Anonyme_T)
   is
   begin
      Ada.Text_IO.Put       (Item => " | X : ");
      Valeur_Param_X_IO.Put (Item => Item.Param_X);
      Ada.Text_IO.Put       (Item => " | Y : ");
      Valeur_Param_Y_IO.Put (Item => Item.Param_Y);
   end Put;
   ---------------------------------------------------------------------------

end A_E_P.Parametres_P.Formule_A_2_P.Text_IO;
