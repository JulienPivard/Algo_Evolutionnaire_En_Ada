with Ada.Numerics.Discrete_Random;

with Generateur_P;

pragma Elaborate_All (Generateur_P);

package body A_E_P.Population_G
   with Spark_Mode => Off
is

   subtype Intervalle_Initial_T is V_Param_T range 0.0 .. 1100.0;

   function Generer is new Generateur_P.Generer_Flottant
      (Valeur_T => V_Param_T);

   ---------------------------------------------------------------------------
   procedure Initialiser
      (
         Population : in out Population_T;
         Formule    : in     A_E_P.Formule_P.Formule_T
      )
   is
   begin
      --  Initialisation du tableau avec des valeurs initial
      Boucle_Initialisation :
      for E of Population.Table loop
         A_E_P.Individu_P.Modifier_Parametre
            (
               Individu => E,
               Valeur   => Generer
                  (
                     Borne_Inferieur => Intervalle_Initial_T'First,
                     Borne_Superieur => Intervalle_Initial_T'Last
                  )
            );
      end loop Boucle_Initialisation;

      Appliquer_Formule (Population => Population.Table, Formule => Formule);
   end Initialiser;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   procedure Remplacer_Morts
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
   begin
      --  Génère des valeurs aléatoires et les places dans la moitié
      --  des 25% dernières cases du tableau.
      Boucle_Genere_Nouvelles_Valeurs_Alea :
      for I in Intervalle_Mutants_T loop
         A_E_P.Individu_P.Modifier_Parametre
            (
               Individu => Population.Table (I),
               Valeur   => Generer
                  (
                     Borne_Inferieur => Intervalle_Initial_T'First,
                     Borne_Superieur => Intervalle_Initial_T'Last
                  )
            );
      end loop Boucle_Genere_Nouvelles_Valeurs_Alea;

      --  Génère une nouvelle valeur à partir de plusieurs autres.
      Bloc_Calcul_Enfant_Moyenne :
      declare
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
      end Bloc_Calcul_Enfant_Moyenne;

      --  Pour chaque valeurs dans l'intervalle d'accouplement,
      --  on sélectionne deux parents et on fait la moyenne
      --  des deux.
      Bloc_Accouplement_Valeurs :
      declare
         package Alea_P    is new Ada.Numerics.Discrete_Random
            (Intervalle_Survivants_T);

         Moyenne        : A_E_P.V_Param_T;
         Alea_Survivant : Alea_P.Generator;
      begin
         Alea_P.Reset (Gen => Alea_Survivant);

         Boucle_Accouplement_Valeurs :
         for I in Intervalle_Accouplements_T loop
            Bloc_Moyenne_Parents :
            declare
               Valeur_1 : constant A_E_P.V_Param_T :=
                  A_E_P.Individu_P.Lire_Parametre
                     (
                        Individu => Population.Table
                           (Alea_P.Random (Gen => Alea_Survivant))
                     );
               Valeur_2 : constant A_E_P.V_Param_T :=
                  A_E_P.Individu_P.Lire_Parametre
                     (
                        Individu => Population.Table
                           (Alea_P.Random (Gen => Alea_Survivant))
                     );
            begin
               Moyenne := (Valeur_1 + Valeur_2) / 2.0;
            end Bloc_Moyenne_Parents;

            A_E_P.Individu_P.Modifier_Parametre
               (
                  Individu => Population.Table (I),
                  Valeur   => Moyenne
               );
         end loop Boucle_Accouplement_Valeurs;
      end Bloc_Accouplement_Valeurs;
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
         Tri_A_Bulle (Tableau => Population.Table);
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
         Bloc_Calcul :
         declare
            Param : constant V_Param_T :=
               A_E_P.Individu_P.Lire_Parametre (Individu => E);
         begin
            A_E_P.Individu_P.Modifier_Resultat
               (
                  Individu => E,
                  Valeur   => Formule (P => Param)
               );
         end Bloc_Calcul;
      end loop Boucle_Calcul;
   end Appliquer_Formule;
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
