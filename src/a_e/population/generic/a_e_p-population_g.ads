with A_E_P.Individu_G;

generic

   type ID_Population_G_T is new Taille_Population_T;
   --  La taille de la population à faire évoluer.

   with package Individu_G_P is new A_E_P.Individu_G (<>);
   --  Un individu contenant La liste des paramètres
   --  à donner en entré de la fonction à optimiser.

   type Table_Population_G_T is
      array (ID_Population_G_T range <>)
      of Individu_G_P.Individu_T;
   --  Contient la population.

   with procedure Trier_G
      (Tableau : in out Table_Population_G_T);
   --  Trie les individu d'une population en fonction
   --  de la valeur calculée de chaque individu.
   --  @param Population
   --  La population à trier.

   with function Comparer_G
      (Gauche, Droite : in     Individu_G_P.Individu_T)
      return Boolean;
   --  Compare deux individus.
   --  @param Gauche
   --  L'individu à gauche de la comparaison.
   --  @param Droite
   --  L'individu à gauche de la comparaison.
   --  @return Le résultat de la comparaison.

--  @summary
--  Opérations réalisable sur une population d'individu.
--  @description
--  La population est composé d'individus contenant chacun
--  les valeurs des paramètres d'une fonction, et le résultat
--  associé.
--  @group Population
package A_E_P.Population_G
   with Spark_Mode => Off
is

   pragma Elaborate_Body;

   type Population_T is private;
   --  La population total d'individu. Celle-ci est invariable
   --  dans le temps.

   procedure Initialiser
      (Population : in out Population_T);
   --  Initialise les paramètres de toute une population.
   --  @param Population
   --  La population.

   procedure Remplacer_Morts
      (Population : in out Population_T);
   --  Remplace les paramètres des individus trop loin du minimum
   --  par de nouveaux.
   --  @param Population
   --  La population total.

   procedure Calcul_Formule_Sur_Enfant
      (Population : in out Population_T);
   --  Applique la formule à la population nouvellement née.
   --  Il est inutile de recalculer toutes les valeurs,
   --  seul les 25% dernières sont nouvelles.
   --  @param Population
   --  La population.

   procedure Organiser_Saison_Des_Amours
      (Population : in out Population_T);
   --  Organise des tournois dont le nombre correspond à environ 8%
   --  du nombre d'individus, avec environ 8% d'individus.
   --  @param Population
   --  La population.

   procedure Trier
      (Population : in out Population_T);
   --  Trie les individu d'une population en fonction
   --  de la valeur calculée de chaque individu.
   --  @param Population
   --  La population à trier.

   procedure C_Est_Ameliore_Depuis_Gen_Precedente
      (
         Population   : in out Population_T;
         Est_Ameliore :    out Boolean
      );
   --  Le meilleur individu a changé depuis la dernière génération.
   --  @param Population
   --  La population.
   --  @param Est_Ameliore
   --  Le meilleur individu a changé.

   function Verifier_Convergence
      (Population : in     Population_T)
      return Boolean;
   --  Indique si la population converge vers un minimum ou non.
   --  Synonyme de disparition de la diversité générique.
   --  @param Population
   --  La population.
   --  @return La population converge vers un même génome.

   function Lire_Taille
      (Population : in     Population_T)
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

   subtype Indice_Population_T is ID_Population_G_T;
   --  Les indices de la table de population.

   Taille_Population : constant ID_Population_G_T :=
      (ID_Population_G_T'Last - ID_Population_G_T'First) + 1;
   --  La population total d'individu.
   --  Chaque individu est une case du tableau.

   pragma Compile_Time_Error
      (
         Taille_Population < 25,
         "La taille de la population est trop faible. " &
         "25 individus au minimum."
      );

   Taille_Migrants   : constant := 8;
   --  Pourcentage de la population qui sera renouvelé par la migration.
   Taille_Tournois   : constant := 8;
   --  Le nombre de tournois organisé correspond au
   --  pourcentage du nombre d'individu dans la population.
   Pop_A_Renouveler  : constant := 25;
   --  La pourcentage de la population à renouveler à chaque génération.

   Nb_Survivants     : constant Indice_Population_T :=
      Taille_Population - ((Taille_Population * Pop_A_Renouveler) / 100);
   --  Le nombre de survivants (environ 75%)
   Nb_Morts          : constant Indice_Population_T :=
      Taille_Population - Nb_Survivants;
   --  Le reste de la population que n'as pas survécu.
   Future_Nb_Enfants : constant Indice_Population_T := Nb_Morts;
   --  Le total d'enfants "naturel" qui seront conçu pour
   --  la prochaine génération.
   Nb_Accouplements  : constant Indice_Population_T := Future_Nb_Enfants / 2;
   --  Le nombre d'enfants par accouplement de deux valeur
   --  prises au hasard parmi les survivantes.
   Nb_Mutants        : constant Indice_Population_T :=
      Future_Nb_Enfants - Nb_Accouplements;
   --  Nombre de valeurs qui seront généré aléatoirement.
   Nb_Tournois       : constant Indice_Population_T :=
      (Taille_Population * Taille_Tournois) / 100;
   --  Nombre de tournois organisé.
   Nb_Participants   : constant Indice_Population_T :=
      Nb_Tournois;
   --  Nombre de participants a chaque tournois.
   Nb_Migrants       : constant Indice_Population_T :=
      (Taille_Population * Taille_Migrants) / 100;
   --  Le nombre d'individu dans le groupe de migrants.

   subtype Intervalle_Survivants_T     is Indice_Population_T        range
      Indice_Population_T'First .. Nb_Survivants;
   --  Défini l'intervalle de valeur des individu survivant.

   subtype Intervalle_Naissance_T      is Indice_Population_T        range
      Nb_Survivants + 1 .. Indice_Population_T'Last;
   --  Défini l'intervalle de valeurs des individu qui naitront
   --  lors de la prochaine génération.

   subtype Intervalle_Future_Enfant_T  is Intervalle_Naissance_T     range
      Intervalle_Naissance_T'First .. Intervalle_Naissance_T'Last;
   --  Intervalle des futures enfant. L'enfant issue de la moyenne
   --  de tous les survivant n'est pas compté.

   subtype Intervalle_Mort_T           is Intervalle_Naissance_T;
   --  Correspond au même intervalle que celui des naissance car
   --  la population est constante dans le temps, il doit donc
   --  y avoir autant de mort que de naissances.

   subtype Intervalle_Accouplements_T  is Intervalle_Future_Enfant_T range
      Intervalle_Future_Enfant_T'First
      ..
      Intervalle_Future_Enfant_T'First + Nb_Accouplements - 1;
   --  Défini le nombre d'individu à naitre qui seront issus
   --  d'accouplement de deux individus survivant existant.

   subtype Intervalle_Mutants_T        is Intervalle_Future_Enfant_T range
      Intervalle_Future_Enfant_T'Last - Nb_Mutants + 1
      ..
      Intervalle_Future_Enfant_T'Last;
   --  Défini les futur individu à naitre que seront issu de mutations.

   subtype Intervalle_Enfant_Moyenne_T is Intervalle_Naissance_T     range
      Intervalle_Naissance_T'First .. Intervalle_Naissance_T'First;
   --  La position de l'enfant issu du calcul de la moyenne de tous
   --  les survivants.

   subtype Indice_Migrants_T           is Indice_Population_T        range
      Indice_Population_T'First .. Nb_Migrants;
   --  Le nombre d'individus participants à la migration.

   subtype Nb_Participants_Tournois_T is Indice_Population_T         range
      Indice_Population_T'First .. Nb_Participants;
   --  Le nombre de participants à chaque tournois.
   type Nb_Tournois_T is new Nb_Participants_Tournois_T;
   --  Le nombre de tournois organisé.

   type Res_Tournoi_T is
      record
         Pos_Perdants : Indice_Population_T := Indice_Population_T'Last;
         --  La position du perdant du tournoi.
         Pos_Gagnants : Indice_Population_T := Indice_Population_T'Last;
         --  La position du gagnant du tournoi.
         Pos_Seconds  : Indice_Population_T := Indice_Population_T'Last;
         --  La position du second du tournoi.
      end record;
   --  Les résultats du tournoi.

   type Table_Resultat_Tournois_T is array (Nb_Tournois_T) of Res_Tournoi_T;
   --  Tableau de position des individus dans la population
   --  ayant participé aux tournois.

   Resultat_Tournois_Vide : constant Table_Resultat_Tournois_T :=
      Table_Resultat_Tournois_T'
         (
            others => Res_Tournoi_T'
               (
                  Pos_Perdants => Indice_Population_T'Last,
                  Pos_Gagnants => Indice_Population_T'Last,
                  Pos_Seconds  => Indice_Population_T'Last
               )
         );

   function Tirer_Concurrent
      (Participants : in     Res_Tournoi_T)
      return Indice_Population_T;
   --  Tire un concurrent au hasard qui est différent de ceux déjà en lice.
   --  @param Participants
   --  Les participants déjà en lice.
   --  @return Le nouveau concurrent.

   procedure Organiser_Tournois
      (
         Population        : in     Population_T;
         Resultat_Tournois :    out Table_Resultat_Tournois_T
      );
   --  Organise des tournois dont le nombre correspond à environ 8%
   --  du nombre d'individus, avec environ 8% d'individus.
   --  Les individus les plus proches du début du tableau sont les plus
   --  fort, ceux qui sont à la fin sont les plus faibles.
   --  @param Population
   --  La population.
   --  @param Resultat_Tournois
   --  Les résultats des tournois.

   procedure Generer_Individus_Mutants
      (Population : in out Population_T);
   --  Génère des individus en attribuant des valeurs
   --  aléatoire à leurs variables. Ils sont placé dans
   --  la dernière moitié des 25% dernières cases du tableau.
   --  @param Population
   --  La population.

   procedure Generer_Enfants_Accouplement
      (Population : in out Population_T);
   --  Génère des enfants par accouplement de deux individus
   --  pris au hasard parmi les survivants.
   --  @param Population
   --  La population.

   procedure Appliquer_Formule
      (Population : in out Table_Population_G_T);
   --  Applique une formule à toute une population.
   --  Le résultat sera conservé dans chaque individu.
   --  @param Population
   --  La population.

   procedure Generer_Individus_Aleatoirement
      (Population : in out Table_Population_G_T);
   --  Génère des individu avec des caractéristique
   --  choisie au hasard pour chaque case de la population.
   --  @param Population
   --  La population.

   subtype Sous_Population_T is Table_Population_G_T (Indice_Population_T);
   --  Contient toute la population existante.

   subtype Pop_Migrants_T    is Table_Population_G_T (Indice_Migrants_T);
   --  Contient la population de migrants.

   type Population_T is
      record
         Table           : Sous_Population_T;
         --  La totalité de la population.
         Meilleur_Valeur : Individu_G_P.Individu_T;
         --  Le meilleur résultat trouvé dans la population.
      end record;

   type Migrants_T is
      record
         Table : Pop_Migrants_T;
         --  La population de migrants.
      end record;

   type Resultat_Tournois_T is
      record
         Table : Table_Resultat_Tournois_T;
         --  Les résultats du tournois entre les individus.
      end record;

end A_E_P.Population_G;
