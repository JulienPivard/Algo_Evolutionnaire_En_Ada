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
      Generer_Individus_Aleatoirement  (Population => Population.Table);

      Appliquer_Formule                (Population => Population.Table);

      Population.Meilleur_Valeur :=
         Population.Table (Population.Table'First);
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
   procedure Organiser_Saison_Des_Amours
      (Population : in out Population_T)
   is
      type Enfants_T is array (Nb_Tournois_T) of Individu_G_P.Individu_T;
      --  Tableau des enfants conçus par les tournois successifs.

      I : Nb_Tournois_T := Nb_Tournois_T'First;

      Resultat_Tournois : Table_Resultat_Tournois_T;
      Enfants           : Enfants_T;
   begin
      Organiser_Tournois
         (
            Population        => Population,
            Resultat_Tournois => Resultat_Tournois
         );

      Boucle_Tournois :
      for E of Resultat_Tournois loop
         Enfants (I) := Individu_G_P.Accoupler
            (
               Individu => Population.Table (E.Pos_Gagnants),
               Autre    => Population.Table (E.Pos_Seconds)
            );

         if I < Nb_Tournois_T'Last then
            I := Nb_Tournois_T'Succ (I);
         end if;
      end loop Boucle_Tournois;

      for J in Nb_Tournois_T loop
         Individu_G_P.Appliquer_Formule (Individu => Enfants (J));
         Population.Table (Resultat_Tournois (J).Pos_Perdants) := Enfants (J);
      end loop;
   end Organiser_Saison_Des_Amours;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   procedure Trier
      (Population : in out Population_T)
   is
   begin
      Trier_G (Tableau => Population.Table);
   end Trier;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   procedure C_Est_Ameliore_Depuis_Gen_Precedente
      (
         Population   : in out Population_T;
         Est_Ameliore :    out Boolean
      )
   is
      use type Individu_G_P.Individu_T;
   begin
      Est_Ameliore :=
         (
            case Objectif_G is
               when Minimiser_E =>
                  Population.Table (Population.Table'First)
                  <
                  Population.Meilleur_Valeur,

               when Maximiser_E =>
                  Population.Table (Population.Table'First)
                  >
                  Population.Meilleur_Valeur
         );
      if Est_Ameliore then
         Population.Meilleur_Valeur :=
            Population.Table (Population.Table'First);
      end if;
   end C_Est_Ameliore_Depuis_Gen_Precedente;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   function Verifier_Convergence
      (Population : in     Population_T)
      return Boolean
   is
      I_Ref : constant Individu_G_P.Individu_T :=
         Population.Table (Population.Table'First);

      function Converge
         (
            Reference : in     Individu_G_P.Individu_T := I_Ref;
            Actuel    : in     Individu_G_P.Individu_T
         )
         return Boolean
         renames Individu_G_P.Dans_Convergence;
   begin
      return (for all I in Intervalle_Survivants_T =>
         Converge (Actuel => Population.Table (I)));
   end Verifier_Convergence;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   function Lire_Taille
      (Population : in     Population_T)
      return Taille_Population_T
   is
   begin
      return Population.Table'Length;
   end Lire_Taille;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   procedure Accueillir_Migrants
      (
         Population : in out Population_T;
         Migrants   : in     Migrants_T;
         Resultats  : in     Resultat_Tournois_T
      )
   is
      I : Indice_Migrants_T := Indice_Migrants_T'First;
   begin
      Boucle_Integration_Migrants :
      for E of Resultats.Table loop
         Population.Table (E.Pos_Gagnants) := Migrants.Table (I);
         if I < Indice_Migrants_T'Last then
            I := I + 1;
         end if;
      end loop Boucle_Integration_Migrants;
   end Accueillir_Migrants;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   procedure Selectionner_Migrants
      (
         Population : in     Population_T;
         Migrants   :    out Migrants_T;
         Resultats  :    out Resultat_Tournois_T
      )
   is
      I : Indice_Migrants_T := Indice_Migrants_T'First;
   begin
      Organiser_Tournois
         (
            Population        => Population,
            Resultat_Tournois => Resultats.Table
         );

      Boucle_Recuperation_Gagnants :
      for E of Resultats.Table loop
         Migrants.Table (I) := Population.Table (E.Pos_Gagnants);
         if I < Indice_Migrants_T'Last then
            I := I + 1;
         end if;
      end loop Boucle_Recuperation_Gagnants;
   end Selectionner_Migrants;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   --                             Partie privée                             --
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   function Tirer_Concurrent
      (Participants : in     Res_Tournoi_T)
      return Indice_Population_T
   is
      Resultat        : Indice_Population_T;
      Tous_Differents : Boolean := False;
   begin
      Boucle_Tirage :
      loop
         Resultat := Alea_Survivants_P.Random
            (Gen => Generateur_Survivant);
         Tous_Differents :=
            Resultat /= Participants.Pos_Gagnants and then
            Resultat /= Participants.Pos_Seconds  and then
            Resultat /= Participants.Pos_Perdants;

         exit Boucle_Tirage when Tous_Differents;
      end loop Boucle_Tirage;

      return Resultat;
   end Tirer_Concurrent;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   procedure Organiser_Tournois
      (
         Population        : in     Population_T;
         Resultat_Tournois :    out Table_Resultat_Tournois_T
      )
   is
      pragma Unreferenced (Population);

      type A_Deja_Perdu_T is array (Indice_Population_T) of Boolean;

      A_Deja_Perdu : A_Deja_Perdu_T := A_Deja_Perdu_T'(others => False);
   begin
      Resultat_Tournois := Resultat_Tournois_Vide;

      Boucle_Tournois :
      for E of Resultat_Tournois loop
         Bloc_Tournois :
         declare
            Pos_Concurrent : Indice_Population_T;
            Tirage_Valide  : Boolean := False;
         begin
            E.Pos_Gagnants := Tirer_Concurrent (Participants => E);
            E.Pos_Seconds  := Tirer_Concurrent (Participants => E);
            E.Pos_Perdants := Tirer_Concurrent (Participants => E);

            Boucle_Initialiser_Tournois :
            loop
               if E.Pos_Perdants < E.Pos_Gagnants then
                  Pos_Concurrent := E.Pos_Perdants;
                  E.Pos_Perdants := E.Pos_Gagnants;
                  E.Pos_Gagnants := Pos_Concurrent;
               end if;

               if E.Pos_Perdants < E.Pos_Seconds then
                  Pos_Concurrent := E.Pos_Perdants;
                  E.Pos_Perdants := E.Pos_Seconds;
                  E.Pos_Seconds  := Pos_Concurrent;
               end if;

               if E.Pos_Seconds < E.Pos_Gagnants then
                  Pos_Concurrent := E.Pos_Seconds;
                  E.Pos_Seconds  := E.Pos_Gagnants;
                  E.Pos_Gagnants := Pos_Concurrent;
               end if;

               if A_Deja_Perdu (E.Pos_Perdants) then
                  Tirage_Valide := False;
               else
                  Tirage_Valide                 := True;
                  A_Deja_Perdu (E.Pos_Perdants) := True;
               end if;

               exit Boucle_Initialiser_Tournois when Tirage_Valide;

               E.Pos_Perdants := Tirer_Concurrent (Participants => E);
            end loop Boucle_Initialiser_Tournois;

            Boucle_Selection_Participants :
            for J in Nb_Participants_Tournois_T loop
               Pos_Concurrent := Tirer_Concurrent (Participants => E);

               if    Pos_Concurrent < E.Pos_Gagnants then
                  E.Pos_Gagnants := Pos_Concurrent;
               elsif Pos_Concurrent < E.Pos_Seconds  then
                  E.Pos_Seconds  := Pos_Concurrent;
               elsif Pos_Concurrent > E.Pos_Perdants then
                  if not A_Deja_Perdu (Pos_Concurrent) then
                     A_Deja_Perdu (E.Pos_Perdants) := False;
                     A_Deja_Perdu (Pos_Concurrent) := True;
                     E.Pos_Perdants := Pos_Concurrent;
                  end if;
               end if;
            end loop Boucle_Selection_Participants;
         end Bloc_Tournois;
      end loop Boucle_Tournois;
   end Organiser_Tournois;
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
            Population.Table (I) := Individu_G_P.Accoupler
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
      (Population : in out Table_Population_G_T)
   is
   begin
      --  Premier calcul de toutes la valeurs.
      Boucle_Calcul :
      for E of Population loop
         Individu_G_P.Appliquer_Formule (Individu => E);
      end loop Boucle_Calcul;
   end Appliquer_Formule;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   procedure Generer_Individus_Aleatoirement
      (Population : in out Table_Population_G_T)
   is
   begin
      Boucle_Generation_Individus :
      for E of Population loop
         Individu_G_P.Generer_Parametres (Individu => E);
      end loop Boucle_Generation_Individus;
   end Generer_Individus_Aleatoirement;
   ---------------------------------------------------------------------------

begin

   Alea_Survivants_P.Reset (Gen => Generateur_Survivant);

end A_E_P.Population_G;
