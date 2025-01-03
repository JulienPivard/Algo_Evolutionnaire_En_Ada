private with A_E_P.Population_G;
private with A_E_P.Population_G.Text_IO;
private with A_E_P.Individu_G;
private with A_E_P.Individu_G.Text_IO;

private with Tri_Rapide_G;
private with Tri_A_Bulle_G;

pragma Elaborate_All (Tri_Rapide_G);
pragma Elaborate_All (Tri_A_Bulle_G);

private

generic

   type ID_Population_G_T is new Taille_Population_T;
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

   Objectif_G : Objectif_T := Minimiser_E;
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
   --  @param NB_Tours_Sans_Divergences
   --  Nombre de tours sans divergences de la population.
   --  @param NB_Tours_Sans_Amelioration
   --  Le nombre de tours sans amélioration de la population.

   procedure Passer_A_La_Generation_Suivante
      (Population : in out Population_T);
   --  Fait passer la population à la génération suivante.
   --  @param Population
   --  La population à faire évoluer.

   function Lire_Taille
      (Population : in out Population_T)
      return Taille_Population_T;
   --  Lit la taille de la population.
   --  @param Population
   --  La population.
   --  @return La taille de la population.

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

   type Table_Population_T is
      array (ID_Population_G_T range <>)
      of Individu_P.Individu_T;
   --  Contient la population.

   procedure Trier
      (Population : in out Table_Population_T);
   --  Procédure pour trier une population d'individus.
   --  @param Population
   --  La population à trier.

   function Comparer
      (
         Gauche : in     Individu_P.Individu_T;
         Droite : in     Individu_P.Individu_T
      )
      return Boolean;
   --  Compare deux individus.
   --  @param Gauche
   --  L'individu à gauche de la comparaison.
   --  @param Droite
   --  L'individu à gauche de la comparaison.
   --  @return Le résultat de la comparaison.

   package Population_P  is new A_E_P.Population_G
      (
         ID_Population_G_T    => ID_Population_G_T,
         Individu_G_P         => Individu_P,
         Table_Population_G_T => Table_Population_T,
         Trier_G              => Trier,
         Comparer_G           => Comparer
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

   procedure Echanger
      (
         Population     : in out Table_Population_T;
         Gauche, Droite : in     ID_Population_G_T
      );
   --  Échange deux individus.
   --  @param Population
   --  La population.
   --  @param Gauche
   --  L'individu à échanger.
   --  @param Droite
   --  L'individu à échanger.

   function Choisir_Pivot_Deterministe
      (Premier, Dernier : in     ID_Population_G_T)
      return ID_Population_G_T;
   --  Choisi la position du pivot dans l'intervalle donné.
   --  Le choix est fait de façon déterministe.
   --  @param Premier
   --  L'indice de la première case de l'intervalle.
   --  @param Dernier
   --  L'indice de la dernière case de l'intervalle.
   --  @return La position du pivot.

   function Choisir_Pivot_Aleatoire
      (Premier, Dernier : in     ID_Population_G_T)
      return ID_Population_G_T;
   --  Choisi la position du pivot dans l'intervalle donné.
   --  Une valeur est choisie aléatoirement dans l'intervalle.
   --  @param Premier
   --  L'indice de la première case de l'intervalle.
   --  @param Dernier
   --  L'indice de la dernière case de l'intervalle.
   --  @return La position du pivot.

   package Tri_A_Bulle_P is new Tri_A_Bulle_G
      (
         Indice_G_T  => ID_Population_G_T,
         Element_G_T => Individu_P.Individu_T,
         Table_G_T   => Table_Population_T,
         Comparer_G  => Comparer,
         Echanger_G  => Echanger
      );

   package Tri_Rapide_P is new Tri_Rapide_G
      (
         Indice_G_T      => ID_Population_G_T,
         Element_G_T     => Individu_P.Individu_T,
         Table_G_T       => Table_Population_T,
         Comparer_G      => Comparer,
         Echanger_G      => Echanger,
         Choisir_Pivot_G => Choisir_Pivot_Aleatoire
      );

   type Trier_A is not null access procedure
      (Tableau : in out Table_Population_T);
   --  Pointeur sur la procédure de tri à utiliser.
   --  @param Tableau
   --  Le tableau d'individus.

   Taille_Population : constant ID_Population_G_T :=
      (ID_Population_G_T'Last - ID_Population_G_T'First) + 1;
   --  La population total d'individu.
   --  Chaque individu est une case du tableau.

   Seuil_Limite : constant := 1_000;

   Trier_Individus : constant Trier_A :=
      (
         if Taille_Population <= Seuil_Limite then
            Tri_A_Bulle_P.Tri_A_Bulle'Access
         else
            Tri_Rapide_P.Tri_Rapide'Access
      );
   --  La fonction de tri à utiliser. Dépend du contexte
   --  et de l'objectif visé.

   function Comparer_Minimiser
      (Gauche, Droite : in     Individu_P.Individu_T)
      return Boolean;
   --  Compare deux individus.
   --  @param Gauche
   --  L'individu à gauche de la comparaison.
   --  @param Droite
   --  L'individu à droite de la comparaison.
   --  @return Vrais si l'individu de gauche est < à celui de droite.

   function Comparer_Maximiser
      (Gauche, Droite : in     Individu_P.Individu_T)
      return Boolean;
   --  Compare deux individus.
   --  @param Gauche
   --  L'individu à gauche de la comparaison.
   --  @param Droite
   --  L'individu à droite de la comparaison.
   --  @return Vrais si l'individu de gauche est > à celui de droite.

   type Comparateur_A is not null access function
      (Gauche, Droite : in     Individu_P.Individu_T)
      return Boolean;
   --  Pointeur sur la fonction de comparaison d'individus.
   --  @param Tableau
   --  Le tableau d'individus.

   Comparateur : constant Comparateur_A :=
      (
         if Objectif_G = Minimiser_E then
            Comparer_Minimiser'Access
         else
            Comparer_Maximiser'Access
      );
   --  Fonction de comparaison de deux individus.

   ---------------------------------------------------------------------------
   procedure Calcul_Formule_Sur_Enfant
      (Population : in out Population_P.Population_T)
      renames
      Population_P.Calcul_Formule_Sur_Enfant;
   --  Applique la formule à la population nouvellement née.
   --  Il est inutile de recalculer toutes les valeurs,
   --  seul les 25% dernières sont nouvelles.
   --  @param Population
   --  La population.

   ---------------------------------------------------------------------------
   procedure Faire_Evoluer_Par_Tournoi
      (Population : in out Population_P.Population_T)
      renames
      Population_P.Organiser_Saison_Des_Amours;
   --  Organise des tournois dont le nombre correspond à environ 8%
   --  du nombre d'individus, avec environ 8% d'individus.
   --  @param Population
   --  La population.

   ---------------------------------------------------------------------------
   procedure Remplacer_Morts
      (Population : in out Population_P.Population_T)
      renames
      Population_P.Remplacer_Morts;
   --  Remplace les paramètres des individus trop loin du minimum
   --  par de nouveaux.
   --  @param Population
   --  La population total.

   ---------------------------------------------------------------------------
   procedure Trier
      (Population : in out Population_P.Population_T)
      renames
      Population_P.Trier;
   --  Trie les individu d'une population en fonction
   --  de la valeur calculée de chaque individu.
   --  @param Population
   --  La population à trier.

   ---------------------------------------------------------------------------
   function Verifier_Convergence
      (Population : in     Population_P.Population_T)
      return Boolean
      renames
      Population_P.Verifier_Convergence;
   --  Indique si la population converge vers un minimum ou non.
   --  Synonyme de disparition de la diversité générique.
   --  @param Population
   --  La population.
   --  @return La population converge vers un même génome.

end A_E_P.Outils_G;
