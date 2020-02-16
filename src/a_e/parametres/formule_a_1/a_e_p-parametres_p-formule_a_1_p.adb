with Ada.Numerics.Generic_Elementary_Functions;

package body A_E_P.Parametres_P.Formule_A_1_P
   with Spark_Mode => Off
is

   ---------------------------------------------------------------------------
   overriding
   procedure Generer
      (Parametres : in out Anonyme_T)
   is
   begin
      Valeur_Param_P.Generer (Parametre => Parametres.Param);
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
      Bebe.Param := Valeur_Param_P.Accoupler
         (
            Parametre => Parametres.Param,
            Autre     => Autre.Param
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

   package Math_P is new Ada.Numerics.Generic_Elementary_Functions (Math_T);

   ---------------------------------------------------------------------------
   function Lire_Parametre
      (Parametres : in Anonyme_T)
      return V_Param_T
   is
   begin
      return Valeur_Param_P.Lire_Valeur
         (Parametre => Parametres.Param);
   end Lire_Parametre;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   function Formule_Anonyme
      (P : in Anonyme_T)
      return V_Calcule_T
   is
      Pi : constant        := Ada.Numerics.Pi;
      Xi : constant Math_T := Math_T (Lire_Parametre (Parametres => P));
   begin
      return V_Calcule_T
         (10.0 + (Xi**2) - 10.0 * Math_P.Cos (X => 2.0 * Pi * Xi));
   end Formule_Anonyme;
   ---------------------------------------------------------------------------

end A_E_P.Parametres_P.Formule_A_1_P;
