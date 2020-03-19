with A_E_P.Individu_G;

private with Sorte_De_Tri_P;
private with Tri_Rapide_G;
private with Tri_A_Bulle_G;

pragma Elaborate_All (Tri_Rapide_G);
pragma Elaborate_All (Tri_A_Bulle_G);

generic

   type Indice_Population_T is range <>;
   --  L'intervalle de valeurs de la population.

   with package Individu_P is new A_E_P.Individu_G (<>);
   --  Un individu contenant La liste des paramètres
   --  à donner en entré de la fonction à optimiser.

   Intervalle_De_Convergence : V_Calcule_T := 1.0;
   --  À chaque génération, l'individu avec le résultat le
   --  plus faible/élevé est pris pour référence.
   --  L'intervalle de convergence représente l'écart accepté
   --  entre tous les individu survivant à chaque génération
   --  par rapport à l'individu de référence. Si tous les
   --  individus sont dans cet intervalle, alors la population
   --  à convergé vers son optimal et n'évoluera plus.

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

   procedure Trier
      (Population : in out Population_T);
   --  Trie les individu d'une population en fonction
   --  de la valeur calculée de chaque individu.
   --  @param Population
   --  La population à trier.

   function Verifier_Convergence
      (Population : in Population_T)
      return Boolean;
   --  Indique si la population converge vers un minimum ou non.
   --  @param Population
   --  La population.

private

   Taille_Population : constant Indice_Population_T :=
      (Indice_Population_T'Last - Indice_Population_T'First) + 1;
   --  La population total d'individu.
   --  Chaque individu est une case du tableau.

   pragma Compile_Time_Error
      (
         Taille_Population < 25,
         "La taille de la population est trop faible. " &
         "25 individus au minimum."
      );

   Nb_Survivants     : constant Indice_Population_T :=
      Taille_Population - ((Taille_Population * 25) / 100);
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

   subtype Intervalle_Survivants_T     is Indice_Population_T        range
      Indice_Population_T'First .. Nb_Survivants;
   --  Défini l'intervalle de valeur des individu survivant.

   subtype Intervalle_Naissance_T      is Indice_Population_T        range
      Nb_Survivants + 1 .. Indice_Population_T'Last;
   --  Défini l'intervalle de valeurs des individu qui naitront
   --  lors de la prochaine génération.

   subtype Intervalle_Future_Enfant_T  is Intervalle_Naissance_T     range
      Intervalle_Naissance_T'First
      ..
      Intervalle_Naissance_T'Last;
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

   type Table_Population_T is
      array (Indice_Population_T range <>)
      of Individu_P.Individu_T;
   --  Contient la population.

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
         Population     : in Table_Population_T;
         Gauche, Droite : in Indice_Population_T
      )
      return Boolean;
   --  Compare deux individus.
   --  @param Population
   --  La population.
   --  @param Gauche
   --  L'individu à gauche de la comparaison.
   --  @param Gauche
   --  L'individu à droite de la comparaison.
   --  @return Vrais si l'individu de gauche est < à celui de droite.

   procedure Echanger
      (
         Population     : in out Table_Population_T;
         Gauche, Droite : in     Indice_Population_T
      );
   --  Échange deux individus.
   --  @param Population
   --  La population.
   --  @param Gauche
   --  L'individu à échanger.
   --  @param Gauche
   --  L'individu à échanger.

   subtype Sous_Population_T is Table_Population_T (Indice_Population_T);
   --  Contient toute la population existante.

   type Population_T is
      record
         Table : Sous_Population_T;
         --  La totalité de la population.
      end record;

   package Tri_A_Bulle_P is new Tri_A_Bulle_G
      (
         Indice_G_T   => Indice_Population_T,
         Element_G_T  => Individu_P.Individu_T,
         Table_G_T    => Table_Population_T,
         Comparer     => Comparer_Minimiser,
         Echanger     => Echanger
      );

   package Tri_Rapide_P is new Tri_Rapide_G
      (
         Sorte_De_Tri => Sorte_De_Tri_P.Aleatoire,
         Indice_G_T   => Indice_Population_T,
         Element_G_T  => Individu_P.Individu_T,
         Table_G_T    => Table_Population_T,
         Comparer     => Comparer_Minimiser,
         Echanger     => Echanger
      );

end A_E_P.Population_G;
