with Ada.Numerics;

package body Demo_P.Surface_P
   with Spark_Mode => Off
is

   ---------------------------------------------------------------------------
   procedure Generer
      (Parametres : in out Surface_T)
   is
   begin
      Valeur_Diametre_P.Generer (Parametre => Parametres.Diametre);
   end Generer;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   function Accoupler
      (
         Parametres : in Surface_T;
         Autre      : in Surface_T
      )
      return Surface_T
   is
      Bebe : Surface_T;
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
      (Parametres : in Surface_T)
      return Resultat_T
   is
      Pi : constant        := Ada.Numerics.Pi;
      Di : constant Math_T := Math_T (Lire_Parametre (P => Parametres));
   begin
      return R : Resultat_T do
         R.Surface := V_Calcule_T
            (Pi * ((Di**2) / 2.0) + 4.0 * (160.0 / Di));
      end return;
   end Calculer;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   --                               Partie privée                           --
   ---------------------------------------------------------------------------

end Demo_P.Surface_P;
