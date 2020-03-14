private with A_E_P.Valeur_Param_G;

pragma Elaborate_All (A_E_P.Valeur_Param_G);

--  @summary
--  Calcul la minimisation d'une formule.
--  @description
--  Définie une formule pour avoir un autre tests sur
--  une fonction à un paramètre.
--  @group Formule
package Demo_P.Formule_A_1_P
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
         Debut_Intervalle => -10_000.0,
         Fin_Intervalle   => +10_000.0
      );

   type Anonyme_T is
      record
         X : Valeur_X_P.Valeur_Param_T;
         --  La valeur de l'unique paramètre de la fonction.
      end record;

   function Lire_Parametre
      (P : in Anonyme_T)
      return A_E_P.V_Param_T
   is (Valeur_X_P.Lire_Valeur (Parametre => P.X));
   --  Lit la valeur d'un paramètre.
   --  @param Parametres
   --  Les paramètres.
   --  @return La valeur du paramètre demandé.

end Demo_P.Formule_A_1_P;
