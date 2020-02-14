with Generateur_G;

pragma Elaborate_All (Generateur_G);

package body A_E_P.Valeur_Param_P
   with Spark_Mode => Off
is

   package Generateur_P is new Generateur_G (Valeur_T => V_Param_T);

   ---------------------------------------------------------------------------
   procedure Generer
      (Parametre : in out Valeur_Param_T)
   is
   begin
      Parametre.Valeur := Generateur_P.Generer_Flottant
         (
            Borne_Inferieur => Parametre.Debut_Intervalle,
            Borne_Superieur => Parametre.Fin_Intervalle
         );
   end Generer;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   function Accoupler
      (
         Parametre : in Valeur_Param_T;
         Autre     : in Valeur_Param_T
      )
      return Valeur_Param_T
   is
      Bebe : Valeur_Param_T;
   begin
      Bebe.Valeur := (Parametre.Valeur + Autre.Valeur) / 2.0;
      return Bebe;
   end Accoupler;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   procedure Modifier_Valeur
      (
         Parametre       : in out Valeur_Param_T;
         Nouvelle_Valeur : in     V_Param_T
      )
   is
   begin
      Parametre.Valeur := Nouvelle_Valeur;
   end Modifier_Valeur;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   function Lire_Valeur
      (Parametre : in Valeur_Param_T)
      return V_Param_T
   is
   begin
      return Parametre.Valeur;
   end Lire_Valeur;
   ---------------------------------------------------------------------------

end A_E_P.Valeur_Param_P;
