with Ada.Numerics.Generic_Elementary_Functions;

package body A_E_P.Parametres_P
   with Spark_Mode => Off
is

   ---------------------------------------------------------------------------
   procedure Generer
      (Parametres : in out Parametres_T)
   is
   begin
      A_E_P.Valeur_Param_P.Generer (Parametre => Parametres.Param_1);
   end Generer;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   function Accoupler
      (
         Parametres : in Parametres_T;
         Autre      : in Parametres_T
      )
      return Parametres_T
   is
      Bebe : Parametres_T;
   begin
      Bebe.Param_1 := A_E_P.Valeur_Param_P.Accoupler
         (
            Parametre => Parametres.Param_1,
            Autre     => Autre.Param_1
         );
      return Bebe;
   end Accoupler;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   function Calculer
      (Parametres : in Parametres_T)
      return V_Calcule_T
   is
   begin
      return Formule (P => Parametres);
   end Calculer;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   procedure Modifier_Parametre
      (
         Parametres  : in out Parametres_T;
         Valeur      : in     V_Param_T
      )
   is
   begin
      A_E_P.Valeur_Param_P.Modifier_Valeur
         (
            Parametre       => Parametres.Param_1,
            Nouvelle_Valeur => Valeur
         );
   end Modifier_Parametre;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   function Lire_Parametre
      (Parametres : in Parametres_T)
      return V_Param_T
   is
   begin
      return A_E_P.Valeur_Param_P.Lire_Valeur
         (Parametre => Parametres.Param_1);
   end Lire_Parametre;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   --                               Partie privée                           --
   ---------------------------------------------------------------------------

   package Math_P is new Ada.Numerics.Generic_Elementary_Functions (Math_T);

   ---------------------------------------------------------------------------
   function Formule_Surface
      (P : in Parametres_P.Parametres_T)
      return V_Calcule_T
   is
      Pi : constant        := Ada.Numerics.Pi;
      Di : constant Math_T := Math_T (Parametres_P.Lire_Parametre (P));
   begin
      return V_Calcule_T (Pi * ((Di**2) / 2.0) + 4.0 * (160.0 / Di));
   end Formule_Surface;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   function Formule_Anonyme
      (P : in Parametres_P.Parametres_T)
      return V_Calcule_T
   is
      Pi : constant        := Ada.Numerics.Pi;
      Xi : constant Math_T := Math_T (Parametres_P.Lire_Parametre (P));
   begin
      return V_Calcule_T
         (10.0 + (Xi**2) - 10.0 * Math_P.Cos (X => 2.0 * Pi * Xi));
   end Formule_Anonyme;
   ---------------------------------------------------------------------------

end A_E_P.Parametres_P;
