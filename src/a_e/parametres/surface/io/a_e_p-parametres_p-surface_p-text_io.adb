with Ada.Text_IO;

with A_E_P.Valeur_Param_G.Text_IO;

pragma Elaborate_All (A_E_P.Valeur_Param_G.Text_IO);

package body A_E_P.Parametres_P.Surface_P.Text_IO
   with Spark_Mode => Off
is

   package Valeur_Param_IO is new Valeur_Param_P.Text_IO;

   ---------------------------------------------------------------------------
   procedure Put
      (Item : in Surface_T)
   is
   begin
      Ada.Text_IO.Put     (Item => " | X : ");
      Valeur_Param_IO.Put (Item => Item.Param);
   end Put;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   procedure Afficher_Formule is
   begin
      Ada.Text_IO.Put_Line (Item => "pi * (D^2 / 2) + 4 * (160 / D)");
   end Afficher_Formule;
   ---------------------------------------------------------------------------

end A_E_P.Parametres_P.Surface_P.Text_IO;
