with Ada.Numerics;

package body Demo_P.Surface_P
   with Spark_Mode => Off
is

   ---------------------------------------------------------------------------
   procedure Generer
      (Parametres : in out Probleme_Surface_T)
   is
   begin
      Valeur_Diametre_P.Generer (Parametre => Parametres.Diametre);
   end Generer;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   function Accoupler
      (
         Parametres : in Probleme_Surface_T;
         Autre      : in Probleme_Surface_T
      )
      return Probleme_Surface_T
   is
      Bebe : Probleme_Surface_T;
   begin
      Bebe.Diametre := Valeur_Diametre_P.Accoupler
         (
            Parametre => Parametres.Diametre,
            Autre     => Autre.Diametre
         );
      return Bebe;
   end Accoupler;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   function Calculer
      (Parametres : in Probleme_Surface_T)
      return Resultat_T
   is
      Vol : constant System.Dim.Mks.Mks_Type := 160.0 * (System.Dim.Mks.m**3);
      Pi  : constant            := Ada.Numerics.Pi;
      Di  : constant Diametre_T := Lire_Parametre (P => Parametres);
   begin
      return R : Resultat_T do
         R.Surface := Pi * ((Di**2) / 2.0) + 4.0 * (Vol / Di);
      end return;
   end Calculer;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   --                               Partie privée                           --
   ---------------------------------------------------------------------------

end Demo_P.Surface_P;
