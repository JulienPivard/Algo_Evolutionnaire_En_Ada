private with A_E_P.Valeur_Param_G;

pragma Elaborate_All (A_E_P.Valeur_Param_G);

--  @summary
--  Calcul la minimisation d'une formule.
--  @description
--  Définie une formule pour avoir un tests sur
--  une fonction à deux paramètres.
--  @group Formule
package Demo_P.Formule_A_2_P
   with
      Pure           => False,
      Preelaborate   => False,
      Elaborate_Body => True,
      Spark_Mode     => Off
is

   type Anonyme_T is private;

   procedure Generer
      (Parametres : in out Anonyme_T);
   --  Génère des valeurs aléatoires pour les paramètres stocké.
   --  @param Parametres
   --  Les paramètres.

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

   function Calculer
      (Parametres : in Anonyme_T)
      return A_E_P.V_Calcule_T;
   --  Calcul la formule en utilisant les valeurs de ses
   --  paramètres comme entrées de la fonction de la formule.
   --  @param Parametres
   --  Les paramètres de la fonction.

private

   package Valeur_X_P is new A_E_P.Valeur_Param_G
      (
         Debut_Intervalle => -1.0,
         Fin_Intervalle   => +100.0
      );

   package Valeur_Y_P is new A_E_P.Valeur_Param_G
      (
         Debut_Intervalle => -2.0,
         Fin_Intervalle   => +100.0
      );

   type Anonyme_T is
      record
         X : Valeur_X_P.Valeur_Param_T;
         --  La valeur du premier paramètre de la formule.
         Y : Valeur_Y_P.Valeur_Param_T;
         --  La valeur du second paramètre de la formule.
      end record;

   function Lire_Parametre_X
      (P : in Anonyme_T)
      return A_E_P.V_Param_T
   is (Valeur_X_P.Lire_Valeur (Parametre => P.X));
   --  Lit la valeur du paramètre X.
   --  @param Parametres
   --  Les paramètres.
   --  @return La valeur du paramètre demandé.

   function Lire_Parametre_Y
      (P : in Anonyme_T)
      return A_E_P.V_Param_T
   is (Valeur_Y_P.Lire_Valeur (Parametre => P.Y));
   --  Lit la valeur du paramètre Y.
   --  @param Parametres
   --  Les paramètres.
   --  @return La valeur du paramètre demandé.

end Demo_P.Formule_A_2_P;