with Ada.Numerics.Discrete_Random;

package body A_E_P.Population_G
   with Spark_Mode => Off
is

   package Alea_Survivants_P is new Ada.Numerics.Discrete_Random
      (Result_Subtype => Intervalle_Survivants_T);

   Generateur_Survivant : Alea_Survivants_P.Generator;

   ---------------------------------------------------------------------------
   procedure Initialiser
      (Population : in out Population_T)
   is
   begin
      --  Initialisation du tableau avec des valeurs initial
      Generer_Individus_Aleatoirement (Population => Population.Table);

      Appliquer_Formule (Population => Population.Table);
   end Initialiser;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   procedure Remplacer_Morts
      (Population : in out Population_T)
   is
   begin
      Generer_Individus_Mutants     (Population => Population);

      --  Pour chaque valeurs dans l'intervalle d'accouplement,
      --  on sélectionne deux parents et on fait la moyenne
      --  des deux.
      Generer_Enfants_Accouplement  (Population => Population);
   end Remplacer_Morts;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   procedure Calcul_Formule_Sur_Enfant
      (Population : in out Population_T)
   is
   begin
      --  Il est inutile de recalculer toutes les valeurs.
      --  Seul les 25% dernières sont nouvelles.
      Appliquer_Formule
         (Population => Population.Table (Intervalle_Naissance_T));
   end Calcul_Formule_Sur_Enfant;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   procedure Organiser_Tournois
      (Population : in out Population_T)
   is
      subtype Nb_Participants_Tournois_T is Indice_Population_T range
         Indice_Population_T'First .. Nb_Participants;
      --  Le nombre de participants à chaque tournois.
      type Nb_Tournois_T is new Nb_Participants_Tournois_T;
      --  Le nombre de tournois organisé.

      type Enfants_T      is array (Nb_Tournois_T) of Individu_P.Individu_T;
      --  Tableau des enfants conçus par les tournois successifs.
      type Pos_Individu_T is array (Nb_Tournois_T) of Indice_Population_T;
      --  Tableau de position des perdants dans la population.

      Pos_Perdants : Pos_Individu_T;
      Pos_Gagnants : Pos_Individu_T;
      Pos_Seconds  : Pos_Individu_T;

      Enfants : Enfants_T;
   begin
      Boucle_Tournois :
      for I in Nb_Tournois_T loop
         Bloc_Accouplement :
         declare
            Pos_Concurent : Indice_Population_T;
         begin
            Pos_Gagnants (I) := Alea_Survivants_P.Random
               (Gen => Generateur_Survivant);
            Pos_Seconds  (I) := Alea_Survivants_P.Random
               (Gen => Generateur_Survivant);
            Pos_Perdants (I) := Alea_Survivants_P.Random
               (Gen => Generateur_Survivant);

            if Pos_Perdants (I) < Pos_Gagnants (I) then
               Pos_Concurent    := Pos_Perdants (I);
               Pos_Perdants (I) := Pos_Gagnants (I);
               Pos_Gagnants (I) := Pos_Concurent;
            end if;

            if Pos_Perdants (I) < Pos_Seconds (I) then
               Pos_Concurent    := Pos_Perdants (I);
               Pos_Perdants (I) := Pos_Seconds  (I);
               Pos_Seconds  (I) := Pos_Concurent;
            end if;

            Boucle_Selection_Participants :
            for J in Nb_Participants_Tournois_T loop
               Pos_Concurent := Alea_Survivants_P.Random
                  (Gen => Generateur_Survivant);

               if    Pos_Concurent < Pos_Gagnants (I) then
                  Pos_Gagnants (I) := Pos_Concurent;
               elsif Pos_Concurent < Pos_Seconds  (I) then
                  Pos_Seconds  (I) := Pos_Concurent;
               elsif Pos_Concurent > Pos_Perdants (I) then
                  Pos_Perdants (I) := Pos_Concurent;
               end if;
            end loop Boucle_Selection_Participants;

            Enfants (I) := Individu_P.Accoupler
               (
                  Individu => Population.Table (Pos_Gagnants (I)),
                  Autre    => Population.Table (Pos_Seconds  (I))
               );
         end Bloc_Accouplement;
      end loop Boucle_Tournois;

      for I in Nb_Tournois_T loop
         Individu_P.Appliquer_Formule (Individu => Enfants (I));
         Population.Table (Pos_Perdants (I)) := Enfants (I);
      end loop;
   end Organiser_Tournois;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   procedure Trier
      (Population : in out Population_T)
   is
   begin
      Trier_Individus (Tableau => Population.Table);
   end Trier;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   function Verifier_Convergence
      (Population : in Population_T)
      return Boolean
   is
      I_Ref : constant Individu_P.Individu_T :=
         Population.Table (Population.Table'First);

      function Converge
         (
            Reference : in Individu_P.Individu_T := I_Ref;
            Actuel    : in Individu_P.Individu_T
         )
         return Boolean
         renames Individu_P.Dans_Convergence;
   begin
      return (for all I in Intervalle_Survivants_T =>
         Converge (Actuel => Population.Table (I)));
   end Verifier_Convergence;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   --                               Partie privée                           --
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   procedure Generer_Individus_Mutants
      (Population : in out Population_T)
   is
   begin
      --  Génère des valeurs aléatoires et les places dans la moitié
      --  des 25% dernières cases du tableau.
      Generer_Individus_Aleatoirement
         (Population => Population.Table (Intervalle_Mutants_T));
   end Generer_Individus_Mutants;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   procedure Generer_Enfants_Accouplement
      (Population : in out Population_T)
   is
   begin
      Boucle_Accouplement_Valeurs :
      for I in Intervalle_Accouplements_T loop
         Bloc_Moyenne_Parents :
         declare
            Position_Parent_1 : constant Intervalle_Survivants_T :=
               Alea_Survivants_P.Random (Gen => Generateur_Survivant);
            Position_Parent_2 : constant Intervalle_Survivants_T :=
               Alea_Survivants_P.Random (Gen => Generateur_Survivant);
         begin
            Population.Table (I) :=
               Individu_P.Accoupler
                  (
                     Individu => Population.Table (Position_Parent_1),
                     Autre    => Population.Table (Position_Parent_2)
                  );
         end Bloc_Moyenne_Parents;
      end loop Boucle_Accouplement_Valeurs;
   end Generer_Enfants_Accouplement;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   procedure Appliquer_Formule
      (Population : in out Table_Population_T)
   is
   begin
      --  Premier calcul de toutes la valeurs.
      Boucle_Calcul :
      for E of Population loop
         Individu_P.Appliquer_Formule (Individu => E);
      end loop Boucle_Calcul;
   end Appliquer_Formule;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   procedure Generer_Individus_Aleatoirement
      (Population : in out Table_Population_T)
   is
   begin
      Boucle_Generation_Individus :
      for E of Population loop
         Individu_P.Generer_Parametres (Individu => E);
      end loop Boucle_Generation_Individus;
   end Generer_Individus_Aleatoirement;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   function Comparer_Minimiser
      (
         Population     : in Table_Population_T;
         Gauche, Droite : in Indice_Population_T
      )
      return Boolean
   is
      use type Individu_P.Individu_T;
   begin
      return Population (Gauche) < Population (Droite);
   end Comparer_Minimiser;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   function Comparer_Maximiser
      (
         Population     : in Table_Population_T;
         Gauche, Droite : in Indice_Population_T
      )
      return Boolean
   is
      use type Individu_P.Individu_T;
   begin
      return Population (Gauche) > Population (Droite);
   end Comparer_Maximiser;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   procedure Echanger
      (
         Population     : in out Table_Population_T;
         Gauche, Droite : in     Indice_Population_T
      )
   is
      Tmp : constant Individu_P.Individu_T := Population (Gauche);
   begin
      Population (Gauche) := Population (Droite);
      Population (Droite) := Tmp;
   end Echanger;
   ---------------------------------------------------------------------------

begin

   Alea_Survivants_P.Reset (Gen => Generateur_Survivant);

end A_E_P.Population_G;
