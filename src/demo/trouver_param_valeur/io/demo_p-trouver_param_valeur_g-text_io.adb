with Ada.Text_IO;

with A_E_P.Valeur_Param_Flottant_G.Text_IO;

pragma Elaborate_All (A_E_P.Valeur_Param_Flottant_G.Text_IO);

package body Demo_P.Trouver_Param_Valeur_G.Text_IO
   with Spark_Mode => Off
is

   package Valeur_X_IO is new Valeur_X_P.Text_IO
      (
         Put_G                 => Put,
         Afficher_Intervalle_G => False
      );
   package Valeur_Y_IO is new Valeur_Y_P.Text_IO
      (
         Put_G                 => Put,
         Afficher_Intervalle_G => False
      );

   ---------------------------------------------------------------------------
   procedure Put_Parametres
      (Item : in     Anonyme_T)
   is
   begin
      Ada.Text_IO.Put (Item => " |  X : ");
      Valeur_X_IO.Put (Item => Item.X);
      Ada.Text_IO.Put (Item => " |  Y : ");
      Valeur_Y_IO.Put (Item => Item.Y);
   end Put_Parametres;
   ---------------------------------------------------------------------------

   package V_Calcule_IO is new Ada.Text_IO.Float_IO (Num => V_Calcule_T);

   ---------------------------------------------------------------------------
   procedure Put_Resultat
      (Item : in     Resultat_T)
   is
   begin
      Ada.Text_IO.Put (Item => " |=> Résultat : ");
      V_Calcule_IO.Put
         (
            Item => Item.Valeur,
            Fore => 1,
            Aft  => 3,
            Exp  => 0
         );
      Ada.Text_IO.Put (Item => " |=> Distance objectif/résultat : ");
      V_Calcule_IO.Put
         (
            Item => Item.Distance,
            Fore => 1,
            Aft  => 3,
            Exp  => 0
         );
   end Put_Resultat;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   procedure Afficher_Formule is
   begin
      Ada.Text_IO.Put
         (Item => "sin (X + Y) + (X - Y)^2 - 1.5X + 2.5Y + 1.0");
      Ada.Text_IO.Put (Item => " |=> Objectif : ");
      V_Calcule_IO.Put
         (
            Item => Objectif_G,
            Fore => 1,
            Aft  => 3,
            Exp  => 0
         );
      Ada.Text_IO.New_Line (Spacing => 1);
   end Afficher_Formule;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   --                             Partie privée                             --
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   procedure Put
      (Item : in     V_Param_T)
   is
      package V_Param_IO is new Ada.Text_IO.Float_IO (Num => V_Param_T);
   begin
      V_Param_IO.Put
         (
            Item => Item,
            Fore => 1,
            Aft  => 3,
            Exp  => 0
         );
   end Put;
   ---------------------------------------------------------------------------

end Demo_P.Trouver_Param_Valeur_G.Text_IO;
