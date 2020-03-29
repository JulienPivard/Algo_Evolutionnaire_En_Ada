with Ada.Text_IO;

with A_E_P.Valeur_Param_G.Text_IO;

pragma Elaborate_All (A_E_P.Valeur_Param_G.Text_IO);

package body Demo_P.Formule_A_1_P.Text_IO
   with Spark_Mode => Off
is

   package Valeur_X_IO is new Valeur_X_P.Text_IO;

   ---------------------------------------------------------------------------
   procedure Put_Parametres
      (Item : in Anonyme_T)
   is
   begin
      Ada.Text_IO.Put (Item => " | X : ");
      Valeur_X_IO.Put (Item => Item.X);
   end Put_Parametres;
   ---------------------------------------------------------------------------

   package V_Calcule_IO is new Ada.Text_IO.Float_IO (Num => V_Calcule_T);

   ---------------------------------------------------------------------------
   procedure Put_Resultat
      (Item : in Resultat_T)
   is
   begin
      Ada.Text_IO.Put (Item => " |=> Résultat : ");
      V_Calcule_IO.Put
         (
            Item => Item.Valeur,
            Fore => 3,
            Aft  => 3,
            Exp  => 0
         );
   end Put_Resultat;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   procedure Afficher_Formule is
   begin
      Ada.Text_IO.Put_Line (Item => "10 + X^2 - 10 * cos (2 * pi * X)");
   end Afficher_Formule;
   ---------------------------------------------------------------------------

end Demo_P.Formule_A_1_P.Text_IO;
