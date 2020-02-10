with Ada.Text_IO;
with Ada.Numerics.Discrete_Random;

with Generateur_P;

pragma Elaborate_All (Generateur_P);

package body A_E_P.Population_G
   with Spark_Mode => Off
is

   package V_Param_IO is new Ada.Text_IO.Float_IO
      (Num => A_E_P.V_Param_T);
   package V_Calcule_IO is new Ada.Text_IO.Float_IO
      (Num => A_E_P.V_Calcule_T);
   package Indice_IO    is new Ada.Text_IO.Integer_IO
      (Num => Indice_Population_T);

   subtype Intervalle_Initial_T is A_E_P.V_Param_T range 0.0 .. 1100.0;

   function Generer is new Generateur_P.Generer_Flottant
      (Intervalle_Initial_T);

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
                     Bloc_Echange_Valeur :
                     declare
                        Tmp : A_E_P.Individu_P.Individu_T;
                     begin
                        Tmp                      := Population.Table (I);
                        Population.Table (I)     := Population.Table (I + 1);
                        Population.Table (I + 1) := Tmp;
                     end Bloc_Echange_Valeur;

                     --  On note qu'un échange à été fait et que donc le
                     --  tableau n'est potentiellement pas totalement trié.
                     Echange := True;
                  end if;
               end loop Boucle_Tri_Bulle;

               exit Boucle_De_Tri when not Echange;
            end Bloc_Tri_Bulle;
         end loop Boucle_De_Tri;
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
   procedure Put_Line
      (Item : in Population_T)
   is
      I : Indice_Population_T := Indice_Population_T'First;
   begin
      if Taille_Population <= 100 then
         for E of Item.Table loop
            Indice_IO.Put      (Item => I, Width => 3);

            if I in Intervalle_Survivants_T then
               Ada.Text_IO.Put (Item => " S   ");
            elsif I in Intervalle_Mort_T then
               Ada.Text_IO.Put (Item => " Mort");
            end if;
            if I in Intervalle_Enfant_Moyenne_T then
               Ada.Text_IO.Put (Item => " Moy");
            elsif I in Intervalle_Accouplements_T then
               Ada.Text_IO.Put (Item => " A  ");
            elsif I in Intervalle_Mutants_T then
               Ada.Text_IO.Put (Item => " Mut");
            else
               Ada.Text_IO.Put (Item => "    ");
            end if;

            Ada.Text_IO.Put    (Item => " | X : ");
            V_Param_IO.Put
               (
                  Item => A_E_P.Individu_P.Lire_Parametre (Individu => E),
                  Fore => 3,
                  Aft  => 3,
                  Exp  => 0
               );
            Ada.Text_IO.Put  (Item => " | Résultat : ");
            V_Calcule_IO.Put
               (
                  Item => A_E_P.Individu_P.Lire_Resultat (Individu => E),
                  Fore => 3,
                  Aft  => 3,
                  Exp  => 0
               );

            Ada.Text_IO.New_Line (Spacing => 1);
            if I < Indice_Population_T'Last then
               I := I + 1;
            end if;
         end loop;
      else
         Ada.Text_IO.Put (Item => "Minimum : ");
         Ada.Text_IO.Put (Item => " | X : ");
         V_Param_IO.Put
            (
               Item => A_E_P.Individu_P.Lire_Parametre
                  (Individu => Item.Table (Item.Table'First)),
               Fore => 3,
               Aft  => 3,
               Exp  => 0
            );
         Ada.Text_IO.Put (Item => " | Résultat : ");
         V_Calcule_IO.Put
            (
               Item => A_E_P.Individu_P.Lire_Resultat
                  (Individu => Item.Table (Item.Table'First)),
               Fore => 3,
               Aft  => 3,
               Exp  => 0
            );
         Ada.Text_IO.New_Line (Spacing => 1);

      end if;
   end Put_Line;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   procedure Afficher_Details is
   begin
      Ada.Text_IO.Put_Line (Item => "Population   : " & Taille_Population'Img);
      Ada.Text_IO.Put_Line (Item => "Survivants   : " & Nb_Survivants'Img);
      Ada.Text_IO.Put_Line (Item => "Morts        : " & Nb_Morts'Img);
      Ada.Text_IO.Put_Line (Item => "Future       : " & Future_Nb_Enfants'Img);
      Ada.Text_IO.Put_Line (Item => "Accouplement : " & Nb_Accouplements'Img);
      Ada.Text_IO.Put_Line (Item => "Mutants      : " & Nb_Mutants'Img);

      if Taille_Population <= 60 then
         Ada.Text_IO.New_Line  (Spacing => 1);

         Ada.Text_IO.Put       (Item => "Survivants    : ");
         for I in Indice_Population_T loop
            if I in Intervalle_Survivants_T then
               Ada.Text_IO.Put (Item => "|");
               Indice_IO.Put   (Item => I, Width => 2);
            else
               Ada.Text_IO.Put (Item => "|  ");
            end if;
         end loop;
         Ada.Text_IO.Put_Line  (Item => "|");

         Ada.Text_IO.Put       (Item => "Morts         : ");
         for I in Indice_Population_T loop
            if I in Intervalle_Mort_T then
               Ada.Text_IO.Put (Item => "|");
               Indice_IO.Put   (Item => I, Width => 2);
            else
               Ada.Text_IO.Put (Item => "|  ");
            end if;
         end loop;
         Ada.Text_IO.Put_Line  (Item => "|");

         Ada.Text_IO.Put       (Item => "Naissance     : ");
         for I in Indice_Population_T loop
            if I in Intervalle_Naissance_T then
               Ada.Text_IO.Put (Item => "|");
               Indice_IO.Put   (Item => I, Width => 2);
            else
               Ada.Text_IO.Put (Item => "|  ");
            end if;
         end loop;
         Ada.Text_IO.Put_Line  (Item => "|");

         Ada.Text_IO.Put       (Item => "Enfant moyen  : ");
         for I in Indice_Population_T loop
            if I in Intervalle_Enfant_Moyenne_T then
               Ada.Text_IO.Put (Item => "|");
               Indice_IO.Put   (Item => I, Width => 2);
            else
               Ada.Text_IO.Put (Item => "|  ");
            end if;
         end loop;
         Ada.Text_IO.Put_Line  (Item => "|");

         Ada.Text_IO.Put       (Item => "Accouplements : ");
         for I in Indice_Population_T loop
            if I in Intervalle_Accouplements_T then
               Ada.Text_IO.Put (Item => "|");
               Indice_IO.Put   (Item => I, Width => 2);
            else
               Ada.Text_IO.Put (Item => "|  ");
            end if;
         end loop;
         Ada.Text_IO.Put_Line  (Item => "|");

         Ada.Text_IO.Put       (Item => "Mutants       : ");
         for I in Indice_Population_T loop
            if I in Intervalle_Mutants_T then
               Ada.Text_IO.Put (Item => "|");
               Indice_IO.Put   (Item => I, Width => 2);
            else
               Ada.Text_IO.Put (Item => "|  ");
            end if;
         end loop;
         Ada.Text_IO.Put_Line  (Item => "|");
      end if;

      Ada.Text_IO.New_Line (Spacing => 1);
   end Afficher_Details;
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

end A_E_P.Population_G;
