private with A_E_P.Population_G;
private with A_E_P.Population_G.Text_IO;
private with A_E_P.Individu_G;
private with A_E_P.Individu_G.Text_IO;

private

generic

   Taille_Population : Taille_Population_T;
   --  La taille de la population à faire évoluer.

   type Parametres_G_T is private;
   --  Les paramètres de la fonction à résoudre,
   --  c'est une représentation du génome d'un individu.

   with procedure Generer_G
      (Parametres : in out Parametres_G_T);
   --  Génère des valeurs aléatoires pour les paramètres stocké.
   --  @param Parametres
   --  Les paramètres.

   with function Accoupler_G
      (
         Parametres : in     Parametres_G_T;
         Autre      : in     Parametres_G_T
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

   with function Calculer_G
      (Parametres : in     Parametres_G_T)
      return Resultat_Calcul_G_T;
   --  Calcul la formule en utilisant les valeurs de ses
   --  paramètres comme entrées de la fonction de la formule.
   --  @param Parametres
   --  Les paramètres de la fonction.

   with function Convergence_Adaptation_G
      (
         Reference : in     Resultat_Calcul_G_T;
         Actuelle  : in     Resultat_Calcul_G_T
      )
      return Boolean;
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
   --  @param Reference
   --  La valeur à laquelle se référer.
   --  @param Actuelle
   --  La valeur à comparer à la référence.

   with procedure Put_Parametres_G
      (Item : in     Parametres_G_T);
   --  Procédure d'affichage du contenu des paramètres.
   --  @param Item
   --  Les paramètres.

   with procedure Put_Resultat_G
      (Item : in     Resultat_Calcul_G_T);
   --  Procédure d'affichage du contenu des résultats du calcul de la formule.
   --  @param Item
   --  Les résultats.

   with procedure Afficher_Formule_G;
   --  Affiche la formule qui va être résolue.

   with function "<"
      (Gauche, Droite : in     Resultat_Calcul_G_T)
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
      (Gauche, Droite : in     Resultat_Calcul_G_T)
      return Boolean
   is <>;
   --  Utilisé pour pouvoir trier les individus en
   --  fonction de leur adaptation.
   --  @param Gauche
   --  Le résultat à gauche de la comparaison.
   --  @param Droite
   --  Le résultat à droite de la comparaison.
   --  @return Gauche > Droite

   Objectif : Objectif_T := Minimiser;
   --  Trouver les valeurs de paramètres qui vont
   --  minimiser ou maximiser le résultat de la fonction

--  @summary
--  Interface de regroupement pour utiliser l'algo évolutionnaire.
--  @description
--  Permet de n'avoir qu'un seul package à instancier
--  pour pouvoir utiliser cet algorithme.
--  @group Évolution
package A_E_P.Outils_G
   with Spark_Mode => Off
is

   pragma Elaborate_Body;

   type Population_T is private;
   --  La population à faire évoluer.

   procedure Initialiser
      (Population : in out Population_T);
   --  Initialise les paramètres de toute une population.
   --  @param Population
   --  La population.

   procedure Put_Line
      (Item : in     Population_T);
   --  Affiche le contenu d'un tableau de valeurs.
   --  @param Item
   --  La population à afficher.

   procedure Afficher_Details;
   --  Affiche la répartition détaillé des populations,
   --  des morts, des naissances et des mutants.

   type NB_Tours_Sans_Divergences_T  is range 0 .. 25;
   --  Nombre de tours sans divergences lors de l'évolution de la population.
   type NB_Tours_Sans_Amelioration_T is range 0 .. 100;
   --  Nombre de tours sans amélioration du meilleur individu
   --  lors de l'évolution de la population.

   procedure Trier_Et_Verifier
      (
         Population                 : in out Population_T;
         NB_Tours_Sans_Divergences  : in out NB_Tours_Sans_Divergences_T;
         NB_Tours_Sans_Amelioration : in out NB_Tours_Sans_Amelioration_T
      );
   --  Trie et vérifie la convergence de la population.
   --  @param Population
   --  Population à vérifier.
   --  @param Tours_Sans_Divergences
   --  Nombre de tours sans divergences de la population.

   procedure Passer_A_La_Generation_Suivante
      (Population : in out Population_T);
   --  Fait passer la population à la génération suivante.
   --  @param Population
   --  La population à faire évoluer.

   type Migrants_T is private;
   --  La population de migrants d'une ile à une autre.

   type Resultat_Tournois_T is private;
   --  Résultat du tournois entre les individus de la population.

   procedure Accueillir_Migrants
      (
         Population : in out Population_T;
         Migrants   : in     Migrants_T;
         Resultats  : in     Resultat_Tournois_T
      );
   --  Accueil une population migrante dans notre population.
   --  @param Population
   --  La population.
   --  @param Migrants
   --  Les migrant à intégrer à la population.
   --  @param Resultats
   --  Les résultats du tournois pour savoir où placer les migrants.

   procedure Selectionner_Migrants
      (
         Population : in     Population_T;
         Migrants   :    out Migrants_T;
         Resultats  :    out Resultat_Tournois_T
      );
   --  Sélectionne des individus pour les faire
   --  migrer hors de la population.
   --  @param Population
   --  La population.
   --  @param Migrants
   --  Les migrants qui partent de la population.
   --  @param Resultats
   --  Les résultats du tournois.

private

   package Individu_P    is new A_E_P.Individu_G
      (
         Parametres_G_T      => Parametres_G_T,
         Generer_G           => Generer_G,
         Accoupler_G         => Accoupler_G,
         Resultat_Calcul_G_T => Resultat_Calcul_G_T,
         Calculer_G          => Calculer_G,
         Convergence_G       => Convergence_Adaptation_G
      );
   package Individu_IO   is new Individu_P.Text_IO
      (
         Put_Parametres_G => Put_Parametres_G,
         Put_Resultat_G   => Put_Resultat_G
      );

   package Population_P  is new A_E_P.Population_G
      (
         Taille       => Taille_Population,
         Individu_G_P => Individu_P,
         Objectif     => Objectif
      );
   package Population_IO is new Population_P.Text_IO
      (Individu_G_IO => Individu_IO);

   type Population_T is
      record
         Initialisee : Boolean := False;
         --  La population a été initialisée.
         Pop         : Population_P.Population_T;
         --  La population à utiliser.
      end record;

   type Migrants_T is
      record
         Pop : Population_P.Migrants_T;
         --  La population migrante.
      end record;

   type Resultat_Tournois_T is
      record
         Pop : Population_P.Resultat_Tournois_T;
         --  Les résultats du tournois.
      end record;

   ---------------------------------------------------------------------------
   procedure Calcul_Formule_Sur_Enfant
      (Population : in out Population_P.Population_T)
      renames
      Population_P.Calcul_Formule_Sur_Enfant;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   procedure Faire_Evoluer_Par_Tournoi
      (Population : in out Population_P.Population_T)
      renames
      Population_P.Organiser_Saison_Des_Amours;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   procedure Remplacer_Morts
      (Population : in out Population_P.Population_T)
      renames
      Population_P.Remplacer_Morts;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   procedure Trier
      (Population : in out Population_P.Population_T)
      renames
      Population_P.Trier;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   function Verifier_Convergence
      (Population : in     Population_P.Population_T)
      return Boolean
      renames
      Population_P.Verifier_Convergence;
   ---------------------------------------------------------------------------

end A_E_P.Outils_G;
