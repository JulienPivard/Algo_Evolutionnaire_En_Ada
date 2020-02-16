with Ada.Text_IO;

with A_E_P.Valeur_Param_G.Text_IO;

pragma Elaborate_All (A_E_P.Valeur_Param_G.Text_IO);

package body A_E_P.Parametres_P.Formule_A_1_P.Text_IO
   with Spark_Mode => Off
is

   package Valeur_Param_1_IO is new Valeur_Param_1_P.Text_IO;

   ---------------------------------------------------------------------------
   procedure Put
      (Item : in Anonyme_T)
   is
   begin
      Ada.Text_IO.Put       (Item => " | X : ");
      Valeur_Param_1_IO.Put (Item => Item.Param_1);
   end Put;
   ---------------------------------------------------------------------------

end A_E_P.Parametres_P.Formule_A_1_P.Text_IO;
