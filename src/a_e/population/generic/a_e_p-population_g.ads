with A_E_P.Individu_G;

private with Sorte_De_Tri_P;
private with Tri_Rapide_G;
private with Tri_A_Bulle_G;

pragma Elaborate_All (Tri_Rapide_G);
pragma Elaborate_All (Tri_A_Bulle_G);

generic
   Taille : Taille_Population_T;
   --  La taille de la population à faire évoluer.

   with package Individu_P is new A_E_P.Individu_G (<>);
   --  Un individu contenant La liste des paramètres
   --  à donner en entré de la fonction à optimiser.

   Objectif : Objectif_T := Minimiser;
   --  Trouver les valeurs de paramètres qui vont
   --  minimiser ou maximiser le résultat de la fonction

--  @summary
--  Opérations réalisable sur une population d'individu.
--  @description
--  La population est composé d'individus contenant chacun
--  les valeurs des paramètres d'une fonction, et le résultat
--  associé.
--  @group Population
package A_E_P.Population_G
   with
      Pure           => False,
      Preelaborate   => False,
      Elaborate_Body => False,
      Spark_Mode     => Off
is

   type Population_T is private;
   --  La population total d'individu. Celle-ci est invariable
   --  dans le temps.

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

   procedure Organiser_Tournois
      (Population : in out Population_T);
   --  Organise des tournois dont le nombre correspond à environ 8%
   --  du nombre d'individus, avec environ 8% d'individus.
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
      (Population : in     Population_T)
      return Boolean;
   --  Indique si la population converge vers un minimum ou non.
   --  Synonyme de disparition de la diversité générique.
   --  @param Population
   --  La population.
   --  @return La population converge vers un même génome.

   type Migrants_T is private;
   --  La population de migrants d'une ile à une autre.

   procedure Accueillir_Migrants
      (
         Population : in out Population_T;
         Migrants   : in     Migrants_T
      );
   --  Accueil une population migrante dans notre population.
   --  @param Population
   --  La population.
   --  @param Migrants
   --  Les migrant à intégrer à la population.

   function Faire_Migrer
      (Population : in     Population_T)
      return Migrants_T;
   --  Sélectionne des individus pour les faire
   --  migrer hors de la population.
   --  @param Population
   --  La population.
   --  @return Les migrants qui partent de la population.

private

   type Indice_Population_T is new Taille_Population_T range
      Taille_Population_T'First .. Taille;
   --  Les indices de la table de population.

   type Table_Population_T is
      array (Indice_Population_T range <>)
      of Individu_P.Individu_T;
   --  Contient la population.

   Taille_Population : constant Indice_Population_T :=
      Indice_Population_T (Taille);
   --  La population total d'individu.
   --  Chaque individu est une case du tableau.

   pragma Compile_Time_Error
      (
         Taille_Population < 25,
         "La taille de la population est trop faible. " &
         "25 individus au minimum."
      );

   Taille_Migrants   : constant Indice_Population_T := 8;

   Taille_Tournois   : constant Indice_Population_T := 8;

   Pop_A_Renouveler  : constant Indice_Population_T := 25;

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
         Pos_Perdants : Indice_Population_T;
         Pos_Gagnants : Indice_Population_T;
         Pos_Seconds  : Indice_Population_T;
      end record;

   type Resultat_Tournois_T is array (Nb_Tournois_T) of Res_Tournoi_T;
   --  Tableau de position des individus dans la population
   --  ayant participé aux tournois.

   procedure Generer_Individus_Mutants
      (Population : in out Population_T)
      with Inline => True;
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
      (Population : in out Table_Population_T);
   --  Applique une formule à toute une population.
   --  Le résultat sera conservé dans chaque individu.
   --  @param Population
   --  La population.

   procedure Generer_Individus_Aleatoirement
      (Population : in out Table_Population_T);
   --  Génère des individu avec des caractéristique
   --  choisie au hasard pour chaque case de la population.
   --  @param Population
   --  La population.

   function Comparer_Minimiser
      (
         Population     : in     Table_Population_T;
         Gauche, Droite : in     Indice_Population_T
      )
      return Boolean
      with Inline => True;
   --  Compare deux individus.
   --  @param Population
   --  La population.
   --  @param Gauche
   --  L'individu à gauche de la comparaison.
   --  @param Droite
   --  L'individu à droite de la comparaison.
   --  @return Vrais si l'individu de gauche est < à celui de droite.

   function Comparer_Maximiser
      (
         Population     : in     Table_Population_T;
         Gauche, Droite : in     Indice_Population_T
      )
      return Boolean
      with Inline => True;
   --  Compare deux individus.
   --  @param Population
   --  La population.
   --  @param Gauche
   --  L'individu à gauche de la comparaison.
   --  @param Droite
   --  L'individu à droite de la comparaison.
   --  @return Vrais si l'individu de gauche est > à celui de droite.

   procedure Echanger
      (
         Population     : in out Table_Population_T;
         Gauche, Droite : in     Indice_Population_T
      )
      with Inline => True;
   --  Échange deux individus.
   --  @param Population
   --  La population.
   --  @param Gauche
   --  L'individu à échanger.
   --  @param Droite
   --  L'individu à échanger.

   subtype Sous_Population_T is Table_Population_T (Indice_Population_T);
   --  Contient toute la population existante.

   subtype Pop_Migrants_T    is Table_Population_T (Indice_Migrants_T);
   --  Contient la population de migrants.

   type Population_T is
      record
         Table : Sous_Population_T;
         --  La totalité de la population.
      end record;

   type Migrants_T is
      record
         Table : Pop_Migrants_T;
         --  La population de migrants.
      end record;

   package Tri_A_Bulle_Max_P is new Tri_A_Bulle_G
      (
         Indice_G_T   => Indice_Population_T,
         Element_G_T  => Individu_P.Individu_T,
         Table_G_T    => Table_Population_T,
         Comparer     => Comparer_Maximiser,
         Echanger     => Echanger
      );

   package Tri_Rapide_Max_P is new Tri_Rapide_G
      (
         Sorte_De_Tri => Sorte_De_Tri_P.Aleatoire,
         Indice_G_T   => Indice_Population_T,
         Element_G_T  => Individu_P.Individu_T,
         Table_G_T    => Table_Population_T,
         Comparer     => Comparer_Maximiser,
         Echanger     => Echanger
      );

   package Tri_A_Bulle_Min_P is new Tri_A_Bulle_G
      (
         Indice_G_T   => Indice_Population_T,
         Element_G_T  => Individu_P.Individu_T,
         Table_G_T    => Table_Population_T,
         Comparer     => Comparer_Minimiser,
         Echanger     => Echanger
      );

   package Tri_Rapide_Min_P is new Tri_Rapide_G
      (
         Sorte_De_Tri => Sorte_De_Tri_P.Aleatoire,
         Indice_G_T   => Indice_Population_T,
         Element_G_T  => Individu_P.Individu_T,
         Table_G_T    => Table_Population_T,
         Comparer     => Comparer_Minimiser,
         Echanger     => Echanger
      );

   type Trier_A is not null access
      procedure
         (Tableau : in out Table_Population_T);
   --  Pointeur sur la procédure de tri à utiliser.

   Trier_Individus : constant Trier_A :=
      (
         if Objectif = Minimiser then
            (
               if Taille_Population <= 1000 then
                  Tri_A_Bulle_Min_P.Tri_A_Bulle'Access
               else
                  Tri_Rapide_Min_P.Tri_Rapide'Access
            )
         else
            (
               if Taille_Population <= 1000 then
                  Tri_A_Bulle_Max_P.Tri_A_Bulle'Access
               else
                  Tri_Rapide_Max_P.Tri_Rapide'Access
            )
      );
   --  La fonction de tri à utiliser. Dépend du contexte
   --  et de l'objectif visé.

end A_E_P.Population_G;
