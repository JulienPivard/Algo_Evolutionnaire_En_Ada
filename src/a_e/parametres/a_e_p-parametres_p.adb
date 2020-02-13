with A_E_P.Intervalle_P;
with Generateur_P;

pragma Elaborate_All (Generateur_P);

package body A_E_P.Parametres_P
   with Spark_Mode => Off
is

   function Generer is new Generateur_P.Generer_Flottant
      (Valeur_T => V_Param_T);

   ---------------------------------------------------------------------------
   procedure Generer
      (Parametres : in out Parametres_T)
   is
   begin
      Parametres.Param_1.Valeur := Generer
         (
            Borne_Inferieur => Intervalle_P.Intervalle_Initial_T'First,
            Borne_Superieur => Intervalle_P.Intervalle_Initial_T'Last
         );
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
      Bebe.Param_1 := Accoupler
         (
            Valeur => Parametres.Param_1,
            Autre  => Autre.Param_1
         );
      return Bebe;
   end Accoupler;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   procedure Modifier_Parametre
      (
         Parametres  : in out Parametres_T;
         Valeur      : in     V_Param_T
      )
   is
   begin
      Parametres.Param_1.Valeur := Valeur;
   end Modifier_Parametre;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   function Lire_Parametre
      (Parametres : in Parametres_T)
      return V_Param_T
   is
   begin
      return Parametres.Param_1.Valeur;
   end Lire_Parametre;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   function Accoupler
      (
         Valeur : in Valeur_T;
         Autre  : in Valeur_T
      )
      return Valeur_T
   is
      Bebe : Valeur_T;
   begin
      Bebe.Valeur := (Valeur.Valeur + Autre.Valeur) / 2.0;
      return Bebe;
   end Accoupler;
   ---------------------------------------------------------------------------

end A_E_P.Parametres_P;
