with Ada.Numerics.Discrete_Random;

package body A_E_P.Population_G
   with Spark_Mode => Off
is

   ---------------------------------------------------------------------------
   procedure Initialiser
      (
         Population : in out Population_T;
         Formule    : in     A_E_P.Formule_P.Formule_T
      )
   is
   begin
      --  Initialisation du tableau avec des valeurs initial
      Generer_Individus_Aleatoirement (Population => Population.Table);

      Appliquer_Formule
         (
            Population => Population.Table,
            Formule    => Formule
         );
   end Initialiser;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   procedure Remplacer_Morts
      (Population : in out Population_T)
   is
   begin
      Generer_Individus_Mutants     (Population => Population);

      --  Génère une nouvelle valeur à partir de plusieurs autres.
      Generer_Enfant_Moyenne        (Population => Population);

      --  Pour chaque valeurs dans l'intervalle d'accouplement,
      --  on sélectionne deux parents et on fait la moyenne
      --  des deux.
      Generer_Enfants_Accouplement  (Population => Population);
   end Remplacer_Morts;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   procedure Calcul_Formule_Sur_Enfant
      (
         Population : in out Population_T;
         Formule    : in     A_E_P.Formule_P.Formule_T
      )
   is
   begin
      --  Il est inutile de recalculer toutes les valeurs.
      --  Seul les 25% dernières sont nouvelles.
      Appliquer_Formule
         (
            Population => Population.Table (Intervalle_Naissance_T),
            Formule    => Formule
         );
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
   procedure Tri_A_Bulle
      (Tableau : in out Table_Population_T)
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
         Individu : constant A_E_P.Individu_P.Individu_T := Tableau (Position);
      begin
         return A_E_P.Individu_P.Lire_Resultat (Individu => Individu);
      end Lire_Resultat;
      ------------------------------------
   begin
      Boucle_De_Tri :
      loop
         Bloc_Tri_Bulle :
         declare
            subtype Intervalle_Tmp_T is Indice_Population_T range
               Indice_Population_T'First .. Indice_Population_T'Last - 1;

            Echange : Boolean := False;
         begin
            Boucle_Tri_Bulle :
            for I in Intervalle_Tmp_T loop
               --  On cherche ici à minimiser le résultat.
               if Lire_Resultat (Position => I)
                  >
                  Lire_Resultat (Position => I + 1)
               then
                  Echanger
                     (
                        Population => Tableau,
                        Gauche     => I,
                        Droite     => I + 1
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
         Individu : constant A_E_P.Individu_P.Individu_T :=
            Population.Table (Position);
      begin
         return A_E_P.Individu_P.Lire_Resultat (Individu => Individu);
      end Lire_Resultat;
      ------------------------------------

      V_Ref : constant V_Calcule_T :=
         Lire_Resultat (Position => Population.Table'First);
   begin
      return (for all I in Intervalle_Survivants_T =>
         Lire_Resultat (Position => I) <= V_Ref + 1.0
         and then
         Lire_Resultat (Position => I) >= V_Ref - 1.0);
   end Verifier_Convergence;
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
   procedure Generer_Enfant_Moyenne
      (Population : in out Population_T)
   is
      ------------------------------------
      function Lire_Parametre
         (Position : in Indice_Population_T)
         return V_Param_T
         with Inline => True;

      ----------------------
      function Lire_Parametre
         (Position : in Indice_Population_T)
         return V_Param_T
      is
         Individu : constant A_E_P.Individu_P.Individu_T :=
            Population.Table (Position);
      begin
         return A_E_P.Individu_P.Lire_Parametre (Individu => Individu);
      end Lire_Parametre;
      ------------------------------------

      Moyenne : A_E_P.V_Param_T := 0.0;
   begin
      Boucle_Calcul_Moyenne :
      for I in Intervalle_Survivants_T loop
         Moyenne := Moyenne + Lire_Parametre (Position => I);
      end loop Boucle_Calcul_Moyenne;
      Moyenne := Moyenne / A_E_P.V_Param_T (Nb_Survivants);
      --  Les 3 dernières valeurs ne font pas partit des survivantes

      A_E_P.Individu_P.Modifier_Parametre
         (
            Individu => Population.Table
               (Intervalle_Enfant_Moyenne_T'First),
            Valeur   => Moyenne
         );
   end Generer_Enfant_Moyenne;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   procedure Generer_Enfants_Accouplement
      (Population : in out Population_T)
   is
      package Alea_P is new Ada.Numerics.Discrete_Random
         (Intervalle_Survivants_T);

      Alea_Survivant : Alea_P.Generator;
   begin
      Alea_P.Reset (Gen => Alea_Survivant);

      Boucle_Accouplement_Valeurs :
      for I in Intervalle_Accouplements_T loop
         Bloc_Moyenne_Parents :
         declare
            Individu_1 : constant A_E_P.Individu_P.Individu_T :=
               Population.Table (Alea_P.Random (Gen => Alea_Survivant));
            Individu_2 : constant A_E_P.Individu_P.Individu_T :=
               Population.Table (Alea_P.Random (Gen => Alea_Survivant));
         begin
            Population.Table (I) :=
               Individu_P.Accoupler
                  (
                     Individu => Individu_1,
                     Autre    => Individu_2
                  );
         end Bloc_Moyenne_Parents;
      end loop Boucle_Accouplement_Valeurs;
   end Generer_Enfants_Accouplement;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   procedure Appliquer_Formule
      (
         Population : in out Table_Population_T;
         Formule    : in     A_E_P.Formule_P.Formule_T
      )
   is
   begin
      --  Premier calcul de toutes la valeurs.
      Boucle_Calcul :
      for E of Population loop
         A_E_P.Individu_P.Appliquer_Formule
            (
               Individu => E,
               Formule  => Formule
            );
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
         A_E_P.Individu_P.Generer_Parametres (Individu => E);
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
         Individu : constant A_E_P.Individu_P.Individu_T := Population (Pos);
      begin
         return A_E_P.Individu_P.Lire_Resultat (Individu => Individu);
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
      Tmp : constant A_E_P.Individu_P.Individu_T := Population (Gauche);
   begin
      Population (Gauche) := Population (Droite);
      Population (Droite) := Tmp;
   end Echanger;
   ---------------------------------------------------------------------------

end A_E_P.Population_G;
