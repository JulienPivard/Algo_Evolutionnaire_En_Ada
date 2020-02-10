with Ada.Text_IO;
with Ada.Real_Time;
with Ada.Numerics.Discrete_Random;

with A_E_P.Aleatoire_P;
with Chrono_P;
with A_E_P;
with A_E_P.Individu_P;
with A_E_P.Formule_P;

separate (Executeur_G)
procedure Executer
   --  (Arguments)
is
   use type A_E_P.Math_T;
   use type A_E_P.V_Param_T;
   use type A_E_P.V_Calcule_T;

   type Indice_Population_T is range 1 .. 25;
   type Population_T        is array (Indice_Population_T) of A_E_P.Individu_P.Individu_T;

   package V_Initial_IO is new Ada.Text_IO.Float_IO (Num => A_E_P.V_Param_T);
   package V_Calcule_IO is new Ada.Text_IO.Float_IO (Num => A_E_P.V_Calcule_T);

   Formule : constant A_E_P.Formule_P.Formule_T :=
      A_E_P.Formule_P.Formule_Surface'Access;

   Population : Population_T;
   Debut, Fin : Ada.Real_Time.Time;

   Nb_Generations : Natural := Natural'First;

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

   subtype Intervalle_Naissance_T      is Indice_Population_T        range
      Nb_Survivants + 1 .. Indice_Population_T'Last;

   subtype Intervalle_Future_Enfant_T  is Intervalle_Naissance_T     range
      Intervalle_Naissance_T'First + Enfant_Moyenne
      ..
      Intervalle_Naissance_T'Last;

   subtype Intervalle_Mort_T           is Intervalle_Naissance_T;

   subtype Intervalle_Accouplements_T  is Intervalle_Future_Enfant_T range
      Intervalle_Future_Enfant_T'First
      ..
      Intervalle_Future_Enfant_T'First + Nb_Accouplements - 1;

   subtype Intervalle_Mutants_T        is Intervalle_Future_Enfant_T range
      Intervalle_Future_Enfant_T'Last - Nb_Mutants + 1
      ..
      Intervalle_Future_Enfant_T'Last;

   subtype Intervalle_Enfant_Moyenne_T is Intervalle_Naissance_T     range
      Intervalle_Naissance_T'First .. Intervalle_Naissance_T'First;

   package Indice_IO is new Ada.Text_IO.Integer_IO (Indice_Population_T);
   package Alea_P    is new Ada.Numerics.Discrete_Random
      (Intervalle_Survivants_T);

   Alea_Survivant : Alea_P.Generator;

   ---------------------------------------------------------------------------
   procedure Put_Line
      (Item : in Population_T);
   --  Affiche le contenu d'un tableau de valeurs.
   --  @param Item
   --  Le tableau.

   procedure Put_Line
      (Item : in Population_T)
   is
      I : Indice_Population_T := 1;
   begin
      if Taille_Population <= 100 then
         for E of Item loop
            Indice_IO.Put    (Item => I, Width => 3);
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
            Ada.Text_IO.Put  (Item => " | X : ");
            V_Initial_IO.Put
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
         V_Initial_IO.Put
            (
               Item => A_E_P.Individu_P.Lire_Parametre (Individu => Item (Item'First)),
               Fore => 3,
               Aft  => 3,
               Exp  => 0
            );
         Ada.Text_IO.Put (Item => " | Résultat : ");
         V_Calcule_IO.Put
            (
               Item => A_E_P.Individu_P.Lire_Resultat (Individu => Item (Item'First)),
               Fore => 3,
               Aft  => 3,
               Exp  => 0
            );
         Ada.Text_IO.New_Line (Spacing => 1);

      end if;
   end Put_Line;
   ---------------------------------------------------------------------------
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

   --  Initialisation du tableau avec des valeurs initial
   Boucle_Initialisation :
   for E of Population loop
      A_E_P.Individu_P.Modifier_Parametre
         (
            Individu => E,
            Valeur   => A_E_P.Aleatoire_P.Generer
         );
   end loop Boucle_Initialisation;

   --  Premier calcul de toutes la valeurs.
   Boucle_Calcul :
   for E of Population loop
      A_E_P.Individu_P.Modifier_Resultat
         (
            Individu => E,
            Valeur   => Formule (P => A_E_P.Individu_P.Lire_Parametre (Individu => E))
         );
   end loop Boucle_Calcul;

   Ada.Text_IO.Put_Line (Item    => "========== Valeurs de départ ==========");
   Ada.Text_IO.New_Line (Spacing => 1);
   Put_Line             (Item    => Population);
   Ada.Text_IO.New_Line (Spacing => 1);

   Debut := Ada.Real_Time.Clock;
   Boucle_Generation_Successive :
   loop
      --  Utilisation d'un tri à bulle pour le premier prototype.
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
               if A_E_P.Individu_P.Lire_Resultat (Individu => Population (I))
                  >
                  A_E_P.Individu_P.Lire_Resultat (Individu => Population (I + 1))
               then
                  Bloc_Echange_Valeur :
                  declare
                     Tmp : A_E_P.Individu_P.Individu_T;
                  begin
                     Tmp                := Population (I);
                     Population (I)     := Population (I + 1);
                     Population (I + 1) := Tmp;
                  end Bloc_Echange_Valeur;

                  --  On note qu'un échange à été fait et que donc le tableau
                  --  n'est potentiellement pas totalement trié.
                  Echange := True;
               end if;
            end loop Boucle_Tri_Bulle;

            exit Boucle_De_Tri when not Echange;
         end Bloc_Tri_Bulle;
      end loop Boucle_De_Tri;

      --  Toutes les valeurs survivantes doivent se trouver autour
      --  de la valeur minimum du tableau +/-1
      --  Intervalle de convergence
      Bloc_Verification_Convergence :
      declare
         V_Ref : constant A_E_P.V_Calcule_T :=
            A_E_P.Individu_P.Lire_Resultat (Individu => Population (Population'First));
      begin
         exit Boucle_Generation_Successive when
            (
               for all I in Intervalle_Survivants_T =>
                  A_E_P.Individu_P.Lire_Resultat (Individu => Population (I)) <= V_Ref + 1.0
                  and then
                  A_E_P.Individu_P.Lire_Resultat (Individu => Population (I)) >= V_Ref - 1.0
            );
      end Bloc_Verification_Convergence;

      --  Génère des valeurs aléatoires et les places dans la moitié
      --  des 25% dernières cases du tableau.
      Boucle_Genere_Nouvelles_Valeurs_Alea :
      for I in Intervalle_Mutants_T loop
         A_E_P.Individu_P.Modifier_Parametre
            (
               Individu => Population (I),
               Valeur   => A_E_P.Aleatoire_P.Generer
            );
      end loop Boucle_Genere_Nouvelles_Valeurs_Alea;

      --  Génère une nouvelle valeur à partir de plusieurs autres.
      Bloc_Calcul_Moyenne :
      declare
         Moyenne : A_E_P.V_Param_T := 0.0;
      begin
         Boucle_Calcul_Moyenne :
         for I in Intervalle_Survivants_T loop
            Moyenne := Moyenne + A_E_P.Individu_P.Lire_Parametre (Individu => Population (I));
         end loop Boucle_Calcul_Moyenne;
         Moyenne := Moyenne / A_E_P.V_Param_T (Nb_Survivants);
         --  Les 3 dernières valeurs ne font pas partit des survivantes

         A_E_P.Individu_P.Modifier_Parametre
            (
               Individu => Population (Intervalle_Enfant_Moyenne_T'First),
               Valeur   => Moyenne
            );
      end Bloc_Calcul_Moyenne;

      --  Pour chaque valeurs dans l'intervalle d'accouplement,
      --  on sélectionne deux parents et on fait la moyenne
      --  des deux.
      Bloc_Accouplement_Valeurs :
      declare
         Moyenne : A_E_P.V_Param_T;
      begin
         Alea_P.Reset (Gen => Alea_Survivant);

         Boucle_Accouplement_Valeurs :
         for I in Intervalle_Accouplements_T loop
            Bloc_Moyenne_Parents :
            declare
               Valeur_1 : constant A_E_P.V_Param_T :=
                  A_E_P.Individu_P.Lire_Parametre
                     (
                        Individu => Population
                           (Alea_P.Random (Gen => Alea_Survivant))
                     );
               Valeur_2 : constant A_E_P.V_Param_T :=
                  A_E_P.Individu_P.Lire_Parametre
                     (
                        Individu => Population
                           (Alea_P.Random (Gen => Alea_Survivant))
                     );
            begin
               Moyenne := (Valeur_1 + Valeur_2) / 2.0;
            end Bloc_Moyenne_Parents;

            A_E_P.Individu_P.Modifier_Parametre
               (
                  Individu => Population (I),
                  Valeur   => Moyenne
               );
         end loop Boucle_Accouplement_Valeurs;
      end Bloc_Accouplement_Valeurs;

      Nb_Generations := Nb_Generations + 1;

      --  Il est inutile de recalculer toutes les valeurs.
      --  Seul les 25% dernières sont nouvelles.
      Boucle_Calcul_Partiel :
      for I in Intervalle_Naissance_T loop
         A_E_P.Individu_P.Modifier_Resultat
            (
               Individu => Population (I),
               Valeur   => Formule
                  (P => A_E_P.Individu_P.Lire_Parametre (Individu =>  Population (I)))
            );
      end loop Boucle_Calcul_Partiel;

   end loop Boucle_Generation_Successive;
   Fin := Ada.Real_Time.Clock;

   Ada.Text_IO.Put_Line (Item    => "======= Valeurs après évolution =======");
   Ada.Text_IO.New_Line (Spacing => 1);
   Put_Line             (Item    => Population);
   Ada.Text_IO.New_Line (Spacing => 1);

   Ada.Text_IO.Put_Line
      (Item => "Nombre de générations : " & Natural'Image (Nb_Generations));

   --------------------------------------
   Ada.Text_IO.New_Line (Spacing => 1);
   --  Affiche le temps de filtrage du fichier.
   Ada.Text_IO.Put      (Item    => "Temps total : ");
   Ada.Text_IO.New_Line (Spacing => 1);

   --  Conversion du temps pour faciliter l'affichage.
   Chrono_P.Affichage_Temps (Debut => Debut, Fin => Fin);

   Ada.Text_IO.New_Line (Spacing => 1);
   --------------------------------------
end Executer;
