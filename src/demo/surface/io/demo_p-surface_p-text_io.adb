with Ada.Text_IO;

with A_E_P.Valeur_Param_Flottant_G.Text_IO;
with System.Dim.Mks_IO;

pragma Elaborate_All (A_E_P.Valeur_Param_Flottant_G.Text_IO);

package body Demo_P.Surface_P.Text_IO
   with Spark_Mode => Off
is

   package Valeur_Diametre_IO is new Valeur_Diametre_P.Text_IO (Put => Put);

   ---------------------------------------------------------------------------
   procedure Put_Parametres
      (Item : in     Probleme_Surface_T)
   is
   begin
      Ada.Text_IO.Put        (Item => " | D : ");
      Valeur_Diametre_IO.Put (Item => Item.Diametre);
   end Put_Parametres;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   procedure Put_Resultat
      (Item : in     Resultat_T)
   is
   begin
      Ada.Text_IO.Put (Item => " |=> Résultat : ");
      System.Dim.Mks_IO.Put
         (
            Item   => Item.Surface * 10_000.0,
            Fore   => 3,
            Aft    => 5,
            Exp    => 0,
            Symbol => " cm**2"
         );
   end Put_Resultat;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   procedure Afficher_Formule is
   begin
      Ada.Text_IO.Put_Line (Item => "pi * (D^2 / 2) + 4 * (160 / D)");
   end Afficher_Formule;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   --                             Partie privée                             --
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   procedure Put
      (Item : in     Diametre_T)
   is
   begin
      System.Dim.Mks_IO.Put
         (
            Item   => Item * 100.0,
            Fore   => 1,
            Aft    => 5,
            Exp    => 0,
            Symbol => " cm"
         );
   end Put;
   ---------------------------------------------------------------------------

end Demo_P.Surface_P.Text_IO;
