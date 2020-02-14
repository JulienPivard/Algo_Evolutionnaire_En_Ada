package body A_E_P.Individu_P
   with Spark_Mode => Off
is

   ---------------------------------------------------------------------------
   procedure Modifier_Resultat
      (
         Individu : in out Individu_T;
         Valeur   : in     V_Calcule_T
      )
   is
   begin
      Individu.V_Calcule := Valeur;
   end Modifier_Resultat;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   function Lire_Resultat
      (Individu : in Individu_T)
      return V_Calcule_T
   is
   begin
      return Individu.V_Calcule;
   end Lire_Resultat;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   procedure Generer_Parametres
      (Individu : in out Individu_T)
   is
   begin
      A_E_P.Parametres_P.Generer (Parametres => Individu.V_Param);
   end Generer_Parametres;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   function Accoupler
      (
         Individu : in Individu_T;
         Autre    : in Individu_T
      )
      return Individu_T
   is
      Bebe : Individu_T;
   begin
      Bebe.V_Param := A_E_P.Parametres_P.Accoupler
         (
            Parametres => Individu.V_Param,
            Autre      => Autre.V_Param
         );
      return Bebe;
   end Accoupler;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   procedure Appliquer_Formule
      (
         Individu : in out Individu_T;
         Formule  : in     A_E_P.Formule_P.Formule_T
      )
   is
   begin
      Individu.V_Calcule :=
         A_E_P.Parametres_P.Calculer
            (
               Parametres => Individu.V_Param,
               Formule    => Formule
            );
   end Appliquer_Formule;
   ---------------------------------------------------------------------------

end A_E_P.Individu_P;
