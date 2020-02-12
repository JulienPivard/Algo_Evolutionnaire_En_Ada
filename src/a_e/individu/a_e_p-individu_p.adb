with A_E_P.Intervalle_P;
with Generateur_P;

pragma Elaborate_All (Generateur_P);

package body A_E_P.Individu_P
   with Spark_Mode => Off
is

   function Generer is new Generateur_P.Generer_Flottant
      (Valeur_T => V_Param_T);

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
      Individu.V_Param := Generer
         (
            Borne_Inferieur => Intervalle_P.Intervalle_Initial_T'First,
            Borne_Superieur => Intervalle_P.Intervalle_Initial_T'Last
         );
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
      Bebe.V_Param := (Individu.V_Param + Autre.V_Param) / 2.0;
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
      Individu.V_Calcule := Formule (P => Individu.V_Param);
   end Appliquer_Formule;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   procedure Modifier_Parametre
      (
         Individu : in out Individu_T;
         Valeur   : in     V_Param_T
      )
   is
   begin
      Individu.V_Param := Valeur;
   end Modifier_Parametre;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   function Lire_Parametre
      (Individu : in Individu_T)
      return V_Param_T
   is
   begin
      return Individu.V_Param;
   end Lire_Parametre;
   ---------------------------------------------------------------------------

end A_E_P.Individu_P;
