with Ada.Numerics.Generic_Elementary_Functions;

package body Demo_P.Formule_A_1_P
   with Spark_Mode => Off
is

   subtype Math_T is A_E_P.Math_T;

   use type Math_T;

   ---------------------------------------------------------------------------
   procedure Generer
      (Parametres : in out Anonyme_T)
   is
   begin
      Valeur_X_P.Generer (Parametre => Parametres.X);
   end Generer;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   function Accoupler
      (
         Parametres : in Anonyme_T;
         Autre      : in Anonyme_T
      )
      return Anonyme_T
   is
      Bebe : Anonyme_T;
   begin
      Bebe.X := Valeur_X_P.Accoupler
         (
            Parametre => Parametres.X,
            Autre     => Autre.X
         );
      return Bebe;
   end Accoupler;
   ---------------------------------------------------------------------------

   package Math_P is new Ada.Numerics.Generic_Elementary_Functions (Math_T);

   ---------------------------------------------------------------------------
   function Calculer
      (Parametres : in Anonyme_T)
      return Resultat_T
   is
      Pi : constant        := Ada.Numerics.Pi;
      Xi : constant Math_T := Math_T (Lire_Parametre (P => Parametres));
   begin
      return R : Resultat_T do
         R.Valeur := A_E_P.V_Calcule_T
            (10.0 + (Xi**2) - 10.0 * Math_P.Cos (X => 2.0 * Pi * Xi));
      end return;
   end Calculer;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   --                               Partie privée                           --
   ---------------------------------------------------------------------------

end Demo_P.Formule_A_1_P;
