with Ada.Numerics.Generic_Elementary_Functions;

package body A_E_P.Parametres_P.Formule_A_2_P
   with Spark_Mode => Off
is

   ---------------------------------------------------------------------------
   overriding
   procedure Generer
      (Parametres : in out Anonyme_T)
   is
   begin
      Valeur_Param_X_P.Generer (Parametre => Parametres.Param_X);
      Valeur_Param_Y_P.Generer (Parametre => Parametres.Param_Y);
   end Generer;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   overriding
   function Accoupler
      (
         Parametres : in Anonyme_T;
         Autre      : in Anonyme_T
      )
      return Anonyme_T
   is
      Bebe : Anonyme_T;
   begin
      Bebe.Param_X := Valeur_Param_X_P.Accoupler
         (
            Parametre => Parametres.Param_X,
            Autre     => Autre.Param_X
         );
      Bebe.Param_Y := Valeur_Param_Y_P.Accoupler
         (
            Parametre => Parametres.Param_Y,
            Autre     => Autre.Param_Y
         );
      return Bebe;
   end Accoupler;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   overriding
   function Calculer
      (Parametres : in Anonyme_T)
      return V_Calcule_T
   is
   begin
      return Formule_Anonyme (P => Parametres);
   end Calculer;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   --                               Partie privée                           --
   ---------------------------------------------------------------------------

   package Math_P is new Ada.Numerics.Generic_Elementary_Functions
      (Float_Type => Math_T);

   ---------------------------------------------------------------------------
   function Formule_Anonyme
      (P : in Anonyme_T)
      return V_Calcule_T
   is
      Xi : constant Math_T := Math_T
         (Valeur_Param_X_P.Lire_Valeur (Parametre => P.Param_X));
      Yi : constant Math_T := Math_T
         (Valeur_Param_Y_P.Lire_Valeur (Parametre => P.Param_Y));
   begin
      return V_Calcule_T
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
   end Formule_Anonyme;
   ---------------------------------------------------------------------------

end A_E_P.Parametres_P.Formule_A_2_P;
