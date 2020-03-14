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

   with function Calculer
      (Parametres : in Parametres_G_T)
      return V_Calcule_T;
   --  Calcul la formule en utilisant les valeurs de ses
   --  paramètres comme entrées de la fonction de la formule.
   --  @param Parametres
   --  Les paramètres de la fonction.

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
         Valeur   : in     V_Calcule_T
      )
      with Inline => True;
   --  Modifie le résultat stocké dans l'individu.
   --  @param Individu
   --  L'individu d'une population.
   --  @param Valeur
   --  Le résultat à stocker.

   function Lire_Resultat
      (Individu : in Individu_T)
      return V_Calcule_T
      with Inline => True;
   --  Lit le résultat stocké dans l'individu.
   --  @param Individu
   --  L'individu d'une population.
   --  @return La valeur du résultat.

   procedure Generer_Parametres
      (Individu : in out Individu_T);
   --  Permet de générer de nouvelles valeurs pour chaque
   --  paramètres aléatoirement.
   --  @param Individu
   --  L'individu dont il faut régénérer les valeurs.

   function Accoupler
      (
         Individu : in Individu_T;
         Autre    : in Individu_T
      )
      return Individu_T;
   --  Accouple deux individus pour en obtenir un 3ieme.
   --  @param Individu
   --  Le premier membre du couple.
   --  @param Autre
   --  Le second membre du couple.
   --  @return Le résultat de l'union des deux Individu.

   procedure Appliquer_Formule
      (Individu : in out Individu_T);
   --  Applique la formule sur l'individu.
   --  @param Individu
   --  L'individu.

   function "<"
      (Gauche, Droite : in Individu_T)
      return Boolean;
   --  Compare deux individus.
   --  @param Gauche
   --  L'individu de gauche à comparer.
   --  @param Gauche
   --  L'individu de droite à comparer.
   --  @return Gauche < Droite.

private

   type Individu_T is
      record
         V_Param   : Parametres_G_T;
         --  La/Les inconnue(s) utilisé par la fonction, qui
         --  correspond à notre environnement.
         --  Peut être vu comme le génome de l'individu.
         V_Calcule : V_Calcule_T := 0.0;
         --  Le résultat de la fonction appliqué aux paramètres.
         --  Peut être vu comme l'expression des gènes de
         --  l'individu contraint par l'environnement.
      end record;

end A_E_P.Individu_G;
