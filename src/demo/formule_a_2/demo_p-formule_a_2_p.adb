with Ada.Numerics.Generic_Elementary_Functions;

package body Demo_P.Formule_A_2_P
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
      Valeur_Y_P.Generer (Parametre => Parametres.Y);
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
      Bebe.Y := Valeur_Y_P.Accoupler
         (
            Parametre => Parametres.Y,
            Autre     => Autre.Y
         );
      return Bebe;
   end Accoupler;
   ---------------------------------------------------------------------------

   package Math_P is new Ada.Numerics.Generic_Elementary_Functions
      (Float_Type => Math_T);

   ---------------------------------------------------------------------------
   function Calculer
      (Parametres : in Anonyme_T)
      return A_E_P.V_Calcule_T
   is
      Xi : constant Math_T := Math_T (Lire_Parametre_X (P => Parametres));
      Yi : constant Math_T := Math_T (Lire_Parametre_Y (P => Parametres));
   begin
      return A_E_P.V_Calcule_T
         (
            Math_P.Sin (X => Xi + Yi)
            +
            (Xi - Yi)**2
            -
            (1.5 * Xi)
            +
            (2.5 * Yi)
            +
            1.0
         );
   end Calculer;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   --                               Partie privée                           --
   ---------------------------------------------------------------------------

end Demo_P.Formule_A_2_P;