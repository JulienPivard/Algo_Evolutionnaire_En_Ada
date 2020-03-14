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
   procedure Trier
      (Population : in out Population_T)
   is
   begin
      if Taille_Population <= 1000 then
         Tri_A_Bulle             (Tableau => Population.Table);
      else
         Tri_Rapide_P.Tri_Rapide (Tableau => Population.Table);
      end if;
   end Trier;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   function Verifier_Convergence
      (Population : in Population_T)
      return Boolean
   is
      ------------------------------------
      function Lire_Resultat
         (Position : in Indice_Population_T)
         return V_Calcule_T
         with Inline => True;

      ----------------------
      function Lire_Resultat
         (Position : in Indice_Population_T)
         return V_Calcule_T
      is
         Individu : constant Individu_P.Individu_T :=
            Population.Table (Position);
      begin
         return Individu_P.Lire_Resultat (Individu => Individu);
      end Lire_Resultat;
      ------------------------------------

      V_Ref : constant V_Calcule_T :=
         Lire_Resultat (Position => Population.Table'First);
   begin
      return (for all I in Intervalle_Survivants_T =>
         Lire_Resultat (Position => I) <= V_Ref + Intervalle_De_Convergence
         and then
         Lire_Resultat (Position => I) >= V_Ref - Intervalle_De_Convergence);
   end Verifier_Convergence;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   --                               Partie privée                           --
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   procedure Tri_A_Bulle
      (Tableau : in out Table_Population_T)
   is
   begin
      Boucle_De_Tri :
      loop
         Bloc_Tri_Bulle :
         declare
            subtype Intervalle_Tmp_T is Indice_Population_T range
               Indice_Population_T'First + 1 .. Indice_Population_T'Last;

            Echange : Boolean := False;
         begin
            Boucle_Tri_Bulle :
            for I in reverse Intervalle_Tmp_T loop
               --  On cherche ici à minimiser le résultat.
               if Comparer_Minimiser
                  (
                     Population => Tableau,
                     Gauche     => I,
                     Droite     => I - 1
                  )
               then
                  Echanger
                     (
                        Population => Tableau,
                        Gauche     => I,
                        Droite     => I - 1
                     );

                  --  On note qu'un échange à été fait et que donc le
                  --  tableau n'est potentiellement pas totalement trié.
                  Echange := True;
               end if;
            end loop Boucle_Tri_Bulle;

            exit Boucle_De_Tri when not Echange;
         end Bloc_Tri_Bulle;
      end loop Boucle_De_Tri;
   end Tri_A_Bulle;
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
      ------------------------------------
      function Lire_Resultat
         (Pos : in Indice_Population_T)
         return V_Calcule_T
         with Inline => True;

      ----------------------
      function Lire_Resultat
         (Pos : in Indice_Population_T)
         return V_Calcule_T
      is
         Individu : constant Individu_P.Individu_T := Population (Pos);
      begin
         return Individu_P.Lire_Resultat (Individu => Individu);
      end Lire_Resultat;
      ------------------------------------
   begin
      return Lire_Resultat (Pos => Gauche) < Lire_Resultat (Pos => Droite);
   end Comparer_Minimiser;
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
