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
      (
         Parametres : in Parametres_T;
         Formule    : in A_E_P.Formule_P.Formule_T
      )
      return V_Calcule_T
   is
   begin
      return Formule (P => Lire_Parametre (Parametres => Parametres));
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

end A_E_P.Parametres_P;
