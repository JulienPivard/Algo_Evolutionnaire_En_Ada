with A_E_P.Formule_P;
with A_E_P.Individu_P;

generic

   type Indice_Population_T is range <>;
   --  L'intervalle de valeurs de la population.

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
      (
         Population : in out Population_T;
         Formule    : in     A_E_P.Formule_P.Formule_T
      );
   --  Initialise les paramètres de toute une population.
   --  @param Population
   --  La population.
   --  @param Formule
   --  La formule à appliquer à toute la population.

   procedure Remplacer_Morts
      (Population : in out Population_T);
   --  Remplace les paramètres des individus trop loin du minimum
   --  par de nouveaux.
   --  @param Population
   --  La population total.

   procedure Calcul_Formule_Sur_Enfant
      (
         Population : in out Population_T;
         Formule    : in     A_E_P.Formule_P.Formule_T
      );
   --  Applique la formule à la population nouvellement née.
   --  Il est inutile de recalculer toutes les valeurs,
   --  seul les 25% dernières sont nouvelles.
   --  @param Population
   --  La population.
   --  @param Formule
   --  La formule à appliquer à la nouvelle population.

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

   procedure Put_Line
      (Item : in Population_T);
   --  Affiche le contenu d'un tableau de valeurs.
   --  @param Item
   --  La population à afficher.

   procedure Afficher_Details;
   --  Affiche la répartition détaillé des populations,
   --  des morts, des naissances et des mutants.

private

   Taille_Population : constant Indice_Population_T :=
      (Indice_Population_T'Last - Indice_Population_T'First) + 1;
   --  La population total d'individu.
   --  Chaque individu est une case du tableau.
   Enfant_Moyenne    : constant Indice_Population_T := 1;
   --  L'enfant issu de la moyenne de tous les survivants.
   Nb_Survivants     : constant Indice_Population_T :=
      Taille_Population - ((Taille_Population * 25) / 100) - Enfant_Moyenne;
   --  Le nombre de survivants (environ 75%)
   Nb_Morts          : constant Indice_Population_T :=
      Taille_Population - Nb_Survivants;
   --  Le reste de la population que n'as pas survécu.
   Future_Nb_Enfants : constant Indice_Population_T :=
      Nb_Morts - Enfant_Moyenne;
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
      Intervalle_Naissance_T'First + Enfant_Moyenne
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
      of A_E_P.Individu_P.Individu_T;
   --  Contient la population.

   procedure Appliquer_Formule
      (
         Population : in out Table_Population_T;
         Formule    : in     A_E_P.Formule_P.Formule_T
      );
   --  Applique une formule à toute une population.
   --  Le résultat sera conservé dans chaque individu.
   --  @param Population
   --  La population.
   --  @param Formule
   --  La formule à appliquer à toute la population.

   subtype Sous_Population_T is Table_Population_T (Indice_Population_T);
   --  Contient toute la population existante.

   type Population_T is
      record
         Table : Sous_Population_T;
         --  La totalité de la population.
      end record;

end A_E_P.Population_G;
