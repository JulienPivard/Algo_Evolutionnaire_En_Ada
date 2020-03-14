with Ada.Real_Time;

with A_E_P.Parametres_P;

private with A_E_P.Population_G;
private with A_E_P.Population_G.Text_IO;
private with A_E_P.Individu_G;
private with A_E_P.Individu_G.Text_IO;

generic

   type Indice_Population_T is range <>;
   --  La taille de la population à faire évoluer.

   type Parametres_G_T is new A_E_P.Parametres_P.Parametres_T with private;
   --  Les paramètres de la fonction à résoudre,
   --  c'est une représentation du génome d'un individu.

   with procedure Put
      (Item : in Parametres_G_T);
   --  Procédure d'affichage du contenu des paramètres.
   --  @param Item
   --  Les paramètres.

   with procedure Afficher_Formule;
   --  Affiche la formule qui va être résolue.

   Intervalle_De_Convergence : V_Calcule_T := 1.0;
   --  Permet de régler la précision de la détection de convergence
   --  des individus vers un génome similaire. C'est grâce à ce
   --  critère que l'on mesure la diversité génétique de la
   --  population. Pour détecter si le minimum est atteint, on
   --  prend l'individu le mieux adapté comme référence, et si le
   --  résultat de chacun des autres individu survivant est dans
   --  l'intervalle valeur_de_référence +/- Intervalle_De_Convergence,
   --  alors on considère que la diversité génétique a disparu pour
   --  cette génération. Il faut que la diversité génétique ait
   --  disparue pendant 25 générations d’affilée pour que l'on
   --  déclare que le minimum a été trouvé.

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

   procedure Faire_Evoluer
      (
         Population     : in out Population_T;
         Debut, Fin     :    out Ada.Real_Time.Time;
         Nb_Generations :    out Natural
      );
   --  Fait évoluer la population jusqu'à atteindre la
   --  convergence de ses individus.
   --  @param Population
   --  La population à faire évoluer.

   procedure Initialiser
      (Population : in out Population_T);
   --  Initialise les paramètres de toute une population.
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
         Indice_Population_T       => Indice_Population_T,
         Intervalle_De_Convergence => Intervalle_De_Convergence,
         Individu_P                => Individu_P
      );
   package Population_IO is new Population_P.Text_IO
      (Individu_IO => Individu_IO);

   type Population_T is
      record
         Initialisee : Boolean := False;
         --  La population a été initialisée.
         Pop         : Population_P.Population_T;
         --  La population à utiliser.
      end record;

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

end A_E_P.Algo_Evolutionnaire_G;
