private with A_E_P.Valeur_Param_G;

pragma Elaborate_All (A_E_P.Valeur_Param_G);

--  @summary
--  Définit une sous classe de paramètres.
--  @description
--  Définie une formule pour avoir un autre tests sur
--  une fonction à un paramètre.
--  @group Formule
package A_E_P.Parametres_P.Formule_A_2_P
   with
      Pure           => False,
      Preelaborate   => False,
      Elaborate_Body => True,
      Spark_Mode     => Off
is

   type Anonyme_T is new Parametres_T with private;

   overriding
   procedure Generer
      (Parametres : in out Anonyme_T);
   --  Génère des valeurs aléatoires pour les paramètres stocké.
   --  @param Parametres
   --  Les paramètres.

   overriding
   function Accoupler
      (
         Parametres : in Anonyme_T;
         Autre      : in Anonyme_T
      )
      return Anonyme_T;
   --  Accouple deux paramètres pour obtenir un nouveau
   --  jeu de paramètres.
   --  @param Parametres
   --  Les paramètres, premier parent.
   --  @param Autre
   --  Les paramètres, second parent.
   --  @return Le jeu de paramètres issus de la combinaison des parents.

   overriding
   function Calculer
      (Parametres : in Anonyme_T)
      return V_Calcule_T;
   --  Calcul la formule en utilisant les valeurs de ses
   --  paramètres comme entrées de la fonction de la formule.
   --  @param Parametres
   --  Les paramètres de la fonction.

private

   package Valeur_Param_X_P is new A_E_P.Valeur_Param_G
      (
         Debut_Intervalle => -1.0,
         Fin_Intervalle   => +100.0
      );

   package Valeur_Param_Y_P is new A_E_P.Valeur_Param_G
      (
         Debut_Intervalle => -2.0,
         Fin_Intervalle   => +100.0
      );

   type Anonyme_T is new Parametres_T with
      record
         Param_X : Valeur_Param_X_P.Valeur_Param_T;
         --  L'unique paramètre (Pour le moment)
         Param_Y : Valeur_Param_Y_P.Valeur_Param_T;
         --  L'unique paramètre (Pour le moment)
      end record;

   function Formule_Anonyme
      (P : in Anonyme_T)
      return V_Calcule_T;
   --  Un autre calcul.
   --  Convergera vers X = 0.0.
   --  @param X
   --  La valeur de l'inconnue X.
   --  @return Le résultats de la formule en fonction de X.

end A_E_P.Parametres_P.Formule_A_2_P;
