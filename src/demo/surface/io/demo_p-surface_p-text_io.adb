with Ada.Text_IO;

with A_E_P.Valeur_Param_G.Text_IO;

pragma Elaborate_All (A_E_P.Valeur_Param_G.Text_IO);

package body Demo_P.Surface_P.Text_IO
   with Spark_Mode => Off
is

   package Valeur_Diametre_IO is new Valeur_Diametre_P.Text_IO;

   ---------------------------------------------------------------------------
   procedure Put
      (Item : in Surface_T)
   is
   begin
      Ada.Text_IO.Put        (Item => " | D : ");
      Valeur_Diametre_IO.Put (Item => Item.Diametre);
   end Put;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   procedure Afficher_Formule is
   begin
      Ada.Text_IO.Put_Line (Item => "pi * (D^2 / 2) + 4 * (160 / D)");
   end Afficher_Formule;
   ---------------------------------------------------------------------------

end Demo_P.Surface_P.Text_IO;
