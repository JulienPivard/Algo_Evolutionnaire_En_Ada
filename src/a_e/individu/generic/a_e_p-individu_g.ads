generic
   type Parametres_G_T is private;
   --  Les paramètres qui représentent le génome de l'individu.

   with procedure Generer
      (Parametres : in out Parametres_G_T);
   --  Génère des valeurs aléatoires pour les paramètres stocké.
   --  @param Parametres
   --  Les paramètres.

   with function Accoupler
      (
         Parametres : in Parametres_G_T;
         Autre      : in Parametres_G_T
      )
      return Parametres_G_T;
   --  Accouple deux paramètres pour obtenir un nouveau
   --  jeu de paramètres.
   --  @param Parametres
   --  Les paramètres, premier parent.
   --  @param Autre
   --  Les paramètres, second parent.
   --  @return Le jeu de paramètres issus de la combinaison des parents.

   type Resultat_Calcul_G_T is private;
   --  Le résultat du calcul de la formule avec les valeurs des paramètres.

   with function Calculer
      (Parametres : in Parametres_G_T)
      return Resultat_Calcul_G_T;
   --  Calcul la formule en utilisant les valeurs de ses
   --  paramètres comme entrées de la fonction de la formule.
   --  @param Parametres
   --  Les paramètres de la fonction.

   with function Convergence
      (
         Reference : in Resultat_Calcul_G_T;
         Actuelle  : in Resultat_Calcul_G_T
      )
      return Boolean;
   --  Tests si la valeur calculée est proche de celle de référence.
   --  L'intervalle de convergence représente l'écart accepté
   --  entre tous les individu survivant à chaque génération
   --  par rapport à l'individu de référence. Si tous les
   --  individus sont dans cet intervalle, alors la population
   --  à convergé vers son optimal et n'évoluera plus.
   --  @param Reference
   --  La valeur de référence.
   --  @param Actuelle
   --  La valeur à comparer.
   --  @return La valeur est proche de celle de référence.

   with function "<"
      (Gauche, Droite : in Resultat_Calcul_G_T)
      return Boolean
   is <>;
   --  Utilisé pour pouvoir trier les individus en
   --  fonction de leur adaptation.
   --  @param Gauche
   --  Le résultat à gauche de la comparaison.
   --  @param Droite
   --  Le résultat à droite de la comparaison.
   --  @return Gauche < Droite

   with function ">"
      (Gauche, Droite : in Resultat_Calcul_G_T)
      return Boolean
   is <>;
   --  Utilisé pour pouvoir trier les individus en
   --  fonction de leur adaptation.
   --  @param Gauche
   --  Le résultat à gauche de la comparaison.
   --  @param Droite
   --  Le résultat à droite de la comparaison.
   --  @return Gauche > Droite

--  @summary
--  Un individu de la population.
--  @description
--  Un individu porte toutes ses spécificités en lui,
--  tel que les paramètres de la fonction et son
--  résultat en fonction de ceux-ci.
--  @group Population
package A_E_P.Individu_G
   with
      Pure           => False,
      Preelaborate   => False,
      Elaborate_Body => False,
      Spark_Mode     => Off
is

   type Individu_T is private;
   --  Un individu d'une population.

   procedure Modifier_Resultat
      (
         Individu : in out Individu_T;
         Valeur   : in     Resultat_Calcul_G_T
      )
      with Inline => True;
   --  Modifie le résultat stocké dans l'individu.
   --  @param Individu
   --  L'individu d'une population.
   --  @param Valeur
   --  Le résultat à stocker.

   function Lire_Resultat
      (Individu : in Individu_T)
      return Resultat_Calcul_G_T
      with Inline => True;
   --  Lit le résultat stocké dans l'individu.
   --  @param Individu
   --  L'individu d'une population.
   --  @return La valeur du résultat.

   procedure Generer_Parametres
      (Individu : in out Individu_T)
      with Inline => True;
   --  Permet de générer de nouvelles valeurs pour chaque
   --  paramètres aléatoirement.
   --  @param Individu
   --  L'individu dont il faut régénérer les valeurs.

   function Accoupler
      (
         Individu : in Individu_T;
         Autre    : in Individu_T
      )
      return Individu_T
      with Inline => True;
   --  Accouple deux individus pour en obtenir un 3ieme.
   --  @param Individu
   --  Le premier membre du couple.
   --  @param Autre
   --  Le second membre du couple.
   --  @return Le résultat de l'union des deux Individu.

   procedure Appliquer_Formule
      (Individu : in out Individu_T)
      with Inline => True;
   --  Applique la formule sur l'individu.
   --  @param Individu
   --  L'individu.

   function Dans_Convergence
      (
         Reference : in Individu_T;
         Actuel    : in Individu_T
      )
      return Boolean
      with Inline => True;
   --  Test si un individu est proche d'un individu de référence.
   --  Le résultat est utilisé pour connaitre le niveau de
   --  convergence génétique d'une population.
   --  L'intervalle de convergence représente l'écart accepté
   --  entre tous les individu survivant à chaque génération
   --  par rapport à l'individu de référence. Si tous les
   --  individus sont dans cet intervalle, alors la population
   --  à convergé vers son optimal et n'évoluera plus.
   --  @param Reference
   --  L'individu de référence.
   --  @param Actuel
   --  L'individu à comparer à la référence.
   --  @return L'individu est proche de la référence.

   function "<"
      (Gauche, Droite : in Individu_T)
      return Boolean
      with Inline => True;
   --  Compare deux individus.
   --  @param Gauche
   --  L'individu de gauche à comparer.
   --  @param Gauche
   --  L'individu de droite à comparer.
   --  @return Gauche < Droite.

   function ">"
      (Gauche, Droite : in Individu_T)
      return Boolean
      with Inline => True;
   --  Compare deux individus.
   --  @param Gauche
   --  L'individu de gauche à comparer.
   --  @param Gauche
   --  L'individu de droite à comparer.
   --  @return Gauche > Droite.

private

   type Individu_T is
      record
         V_Param   : Parametres_G_T;
         --  La/Les inconnue(s) utilisé par la fonction, qui
         --  correspond à notre environnement.
         --  Peut être vu comme le génome de l'individu.
         V_Calcule : Resultat_Calcul_G_T;
         --  Le résultat de la fonction appliqué aux paramètres.
         --  Peut être vu comme l'expression des gènes de
         --  l'individu contraint par l'environnement.
      end record;

end A_E_P.Individu_G;
