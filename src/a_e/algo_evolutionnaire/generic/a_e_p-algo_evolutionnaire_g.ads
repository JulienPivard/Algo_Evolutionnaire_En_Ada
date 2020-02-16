with A_E_P.Parametres_P;

private with A_E_P.Population_G;
private with A_E_P.Population_G.Text_IO;
private with A_E_P.Individu_G;
private with A_E_P.Individu_G.Text_IO;

generic

   type Indice_Population_T is range <>;
   --  L'intervalle de valeurs de la population.

   type Parametres_G_T is new A_E_P.Parametres_P.Parametres_T with private;
   --  Les paramètres qui représentent le génome de l'individu.

   with procedure Put
      (Item : in Parametres_G_T);
   --  Procédure d'affichage du contenu des paramètres.
   --  @param Item
   --  Les paramètres.

--  @summary
--  Interface de regroupement pour utiliser l'algo évolutionnaire.
--  @description
--  Permet de n'avoir qu'un seul package à instancier
--  pour pouvoir utiliser cet algorithme.
--  @group Évolution
package A_E_P.Algo_Evolutionnaire_G
   with
      Pure           => False,
      Preelaborate   => False,
      Elaborate_Body => False,
      Spark_Mode     => Off
is

   type Population_T is private;

   procedure Initialiser
      (Population : in out Population_T)
      with Inline => True;
   --  Initialise les paramètres de toute une population.
   --  @param Population
   --  La population.

   procedure Remplacer_Morts
      (Population : in out Population_T)
      with Inline => True;
   --  Remplace les paramètres des individus trop loin du minimum
   --  par de nouveaux.
   --  @param Population
   --  La population total.

   procedure Calcul_Formule_Sur_Enfant
      (Population : in out Population_T)
      with Inline => True;
   --  Applique la formule à la population nouvellement née.
   --  Il est inutile de recalculer toutes les valeurs,
   --  seul les 25% dernières sont nouvelles.
   --  @param Population
   --  La population.

   procedure Trier
      (Population : in out Population_T)
      with Inline => True;
   --  Trie les individu d'une population en fonction
   --  de la valeur calculée de chaque individu.
   --  @param Population
   --  La population à trier.

   function Verifier_Convergence
      (Population : in Population_T)
      return Boolean
      with Inline => True;
   --  Indique si la population converge vers un minimum ou non.
   --  @param Population
   --  La population.

   procedure Put_Line
      (Item : in Population_T)
      with Inline => True;
   --  Affiche le contenu d'un tableau de valeurs.
   --  @param Item
   --  La population à afficher.

   procedure Afficher_Details
      with Inline => True;
   --  Affiche la répartition détaillé des populations,
   --  des morts, des naissances et des mutants.

private

   package Individu_P    is new A_E_P.Individu_G
      (Parametres_G_T => Parametres_G_T);
   package Individu_IO   is new Individu_P.Text_IO
      (Put => Put);

   package Population_P  is new A_E_P.Population_G
      (
         Indice_Population_T => Indice_Population_T,
         Individu_P          => Individu_P
      );
   package Population_IO is new Population_P.Text_IO
      (Individu_IO => Individu_IO);

   type Population_T is
      record
         Pop : Population_P.Population_T;
         --  La population à utiliser.
      end record;

end A_E_P.Algo_Evolutionnaire_G;
