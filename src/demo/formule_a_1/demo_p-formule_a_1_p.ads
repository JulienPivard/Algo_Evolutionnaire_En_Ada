private with A_E_P.Valeur_Param_Flottant_G;

pragma Elaborate_All (A_E_P.Valeur_Param_Flottant_G);

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
         Parametres : in     Anonyme_T;
         Autre      : in     Anonyme_T
      )
      return Anonyme_T;
   --  Accouple deux paramètres pour obtenir un nouveau
   --  jeu de paramètres.
   --  @param Parametres
   --  Les paramètres, premier parent.
   --  @param Autre
   --  Les paramètres, second parent.
   --  @return Le jeu de paramètres issus de la combinaison des parents.

   type Resultat_T is private;
   --  Stock le résultat des calculs.

   function Calculer
      (Parametres : in     Anonyme_T)
      return Resultat_T;
   --  Calcul la formule en utilisant les valeurs de ses
   --  paramètres comme entrées de la fonction de la formule.
   --  @param Parametres
   --  Les paramètres de la fonction.
   --  @return Le résultat du calcul de la formule.

   function "<"
      (Gauche, Droite : in     Resultat_T)
      return Boolean;
   --  Compare deux résultats.
   --  @param Gauche
   --  Le résultat à gauche de la comparaison.
   --  @param Droite
   --  Le résultat à droite de la comparaison.
   --  @return Gauche < Droite.

   function ">"
      (Gauche, Droite : in     Resultat_T)
      return Boolean;
   --  Compare deux résultats.
   --  @param Gauche
   --  Le résultat à gauche de la comparaison.
   --  @param Droite
   --  Le résultat à droite de la comparaison.
   --  @return Gauche > Droite.

   function Resultats_Convergent
      (
         Reference : in     Resultat_T;
         Actuel    : in     Resultat_T
      )
      return Boolean;
   --  Le résultat actuel converge avec le résultat de référence.
   --  @param Reference
   --  Le résultat de référence.
   --  @param Actuel
   --  Le résultat dont on veut savoir si il converge.
   --  @return Le résultat converge vers la référence.

private

   package Valeur_X_P is new A_E_P.Valeur_Param_Flottant_G
      (
         Valeur_Param_G_T   => V_Param_T,
         Debut_Intervalle_G => -100_000.0,
         Fin_Intervalle_G   => +100_000.0
      );

   type Anonyme_T is
      record
         X : Valeur_X_P.Valeur_Param_T;
         --  La valeur de l'unique paramètre de la fonction.
      end record;

   function Lire_Parametre
      (P : in     Anonyme_T)
      return V_Param_T
   is (Valeur_X_P.Lire_Valeur (Parametre => P.X));
   --  Lit la valeur d'un paramètre.
   --  @param Parametres
   --  Les paramètres.
   --  @return La valeur du paramètre demandé.

   type Resultat_T is
      record
         Valeur : V_Calcule_T := 0.0;
         --  Le résultat du calcul de la formule.
      end record;

   function "<"
      (Gauche, Droite : in     Resultat_T)
      return Boolean
   is (Gauche.Valeur < Droite.Valeur);

   function ">"
      (Gauche, Droite : in     Resultat_T)
      return Boolean
   is (Gauche.Valeur > Droite.Valeur);

   Seuil_De_Convergence : constant := 0.5;

   function Resultats_Convergent
      (
         Reference : in     Resultat_T;
         Actuel    : in     Resultat_T
      )
      return Boolean
   is
      (
         Reference.Valeur - Seuil_De_Convergence <= Actuel.Valeur
         and then
         Actuel.Valeur <= Reference.Valeur + Seuil_De_Convergence
      );

end Demo_P.Formule_A_1_P;
