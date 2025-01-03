--  with GNAT.Source_Info;

with Ada.Text_IO;
with Ada.Real_Time;

with A_E_P;
with A_E_P.Algo_Evolutionnaire_G;

with Demo_P;
with Demo_P.Surface_P;
with Demo_P.Surface_P.Text_IO;

with Demo_P.Formule_A_1_P;
with Demo_P.Formule_A_1_P.Text_IO;

with Demo_P.Formule_A_2_P;
with Demo_P.Formule_A_2_P.Text_IO;

with Demo_P.Trouver_Param_Valeur_G;
with Demo_P.Trouver_Param_Valeur_G.Text_IO;

with Demo_P.Chemin_P.Evo_P;
with Demo_P.Chemin_P.Evo_P.Text_IO;

with Chrono_IO;

separate (Executeur_G)
procedure Executer
   --  (Arguments)
is
   ---------------------------------------------------------------------------
   generic
      with package Population_G_P is new A_E_P.Algo_Evolutionnaire_G (<>);
      --  La population à minimiser.

   procedure Determiner_Min
      (
         Min               : in     String;
         Nom               : in     String;
         Reduire_Affichage : in     Boolean := False
      );
   --  Détermine le minimum de la formule.
   --  @param Min
   --  Le minimum attendu.
   --  @param Nom
   --  Le nom des variables.
   --  @param Reduire_Affichage
   --  Réduit la quantité d'affichage.

   ------------------------
   procedure Determiner_Min
      (
         Min               : in     String;
         Nom               : in     String;
         Reduire_Affichage : in     Boolean := False
      )
   is
      use type A_E_P.Taille_Population_T;

      Population : Population_G_P.Population_T;
      Debut, Fin : Ada.Real_Time.Time;

      NB_Generations : Natural := Natural'First;
   begin
      Bloc_Determiner_Reduction_Affichage :
      declare
         Taille : constant A_E_P.Taille_Population_T :=
            Population_G_P.Lire_Taille (Population => Population);
      begin
         if not Reduire_Affichage then
            Population_G_P.Afficher_Details;
         else
            Ada.Text_IO.Put_Line
               (
                  Item => "Population   :" &
                     A_E_P.Taille_Population_T'Image (Taille)
               );
         end if;

         Population_G_P.Initialiser (Population => Population);

         if Taille < 50 and then not Reduire_Affichage then
            Ada.Text_IO.Put_Line
               (Item => "========== Valeurs de départ ==========");

            Ada.Text_IO.New_Line    (Spacing => 1);
            Population_G_P.Put_Line (Item    => Population);
            Ada.Text_IO.Put_Line    (Item    => "=======");
            Ada.Text_IO.New_Line    (Spacing => 1);
         end if;
      end Bloc_Determiner_Reduction_Affichage;

      Population_G_P.Faire_Evoluer
         (
            Population      => Population,
            Debut           => Debut,
            Fin             => Fin,
            NB_Generations  => NB_Generations
         );

      Ada.Text_IO.Put_Line
         (Item => "======= Valeurs attendu après évolution =======");
      Ada.Text_IO.Put_Line
         (Item => "La valeur attendue de " & Nom & " pour le min : " & Min);

      Ada.Text_IO.Put_Line
         (Item => "=======                                 =======");
      Ada.Text_IO.Put_Line
         (Item => "=======            Résultats            =======");
      Population_G_P.Put_Line (Item    => Population);
      Ada.Text_IO.Put_Line    (Item    => "=======");

      Ada.Text_IO.Put_Line
         (
            Item => "Nombre de générations : " &
               Natural'Image (NB_Generations)
         );

      --------------------------------------
      --  Affiche le temps de filtrage du fichier.
      Ada.Text_IO.Put      (Item    => "Temps total : ");
      Ada.Text_IO.New_Line (Spacing => 1);

      --  Conversion du temps pour faciliter l'affichage.
      Chrono_IO.Affichage_Temps (Debut => Debut, Fin => Fin);

      Ada.Text_IO.New_Line (Spacing => (if Reduire_Affichage then 2 else 4));
      --------------------------------------
   end Determiner_Min;
   ---------------------------------------------------------------------------

   --  Expérimentation avec une formule de calcul de surface d'un volume.
   package Surface_R    renames Demo_P.Surface_P;
   package Surface_IO_R renames Demo_P.Surface_P.Text_IO;

   use type Surface_R.Resultat_T;

   package Population_Surface_P is new A_E_P.Algo_Evolutionnaire_G
      (
         ID_Population_G_T        => Demo_P.ID_Population_T,
         Parametres_G_T           => Surface_R.Probleme_Surface_T,
         Generer_G                => Surface_R.Generer,
         Accoupler_G              => Surface_R.Accoupler,
         Resultat_Calcul_G_T      => Surface_R.Resultat_T,
         Calculer_G               => Surface_R.Calculer,
         Convergence_Adaptation_G => Surface_R.Resultats_Convergent,
         Put_Parametres_G         => Surface_IO_R.Put_Parametres,
         Put_Resultat_G           => Surface_IO_R.Put_Resultat,
         Afficher_Formule_G       => Surface_IO_R.Afficher_Formule
      );

   procedure Min_Surface is new Determiner_Min
      (Population_G_P => Population_Surface_P);

   --  Expérimentation avec une formule à un paramètre
   package Formule_1_R    renames Demo_P.Formule_A_1_P;
   package Formule_1_IO_R renames Demo_P.Formule_A_1_P.Text_IO;

   use type Formule_1_R.Resultat_T;

   package Population_Anonyme_1_P is new A_E_P.Algo_Evolutionnaire_G
      (
         ID_Population_G_T        => Demo_P.ID_Population_T,
         Parametres_G_T           => Formule_1_R.Anonyme_T,
         Generer_G                => Formule_1_R.Generer,
         Accoupler_G              => Formule_1_R.Accoupler,
         Resultat_Calcul_G_T      => Formule_1_R.Resultat_T,
         Calculer_G               => Formule_1_R.Calculer,
         Convergence_Adaptation_G => Formule_1_R.Resultats_Convergent,
         Put_Parametres_G         => Formule_1_IO_R.Put_Parametres,
         Put_Resultat_G           => Formule_1_IO_R.Put_Resultat,
         Afficher_Formule_G       => Formule_1_IO_R.Afficher_Formule
      );

   procedure Min_Anonyme_1 is new Determiner_Min
      (Population_G_P => Population_Anonyme_1_P);

   --  Expérimentation avec une formule à deux paramètres
   package Formule_2_R    renames Demo_P.Formule_A_2_P;
   package Formule_2_IO_R renames Demo_P.Formule_A_2_P.Text_IO;

   use type Formule_2_R.Resultat_T;

   package Population_Anonyme_2_P is new A_E_P.Algo_Evolutionnaire_G
      (
         ID_Population_G_T        => Demo_P.ID_Population_T,
         Parametres_G_T           => Formule_2_R.Anonyme_T,
         Generer_G                => Formule_2_R.Generer,
         Accoupler_G              => Formule_2_R.Accoupler,
         Resultat_Calcul_G_T      => Formule_2_R.Resultat_T,
         Calculer_G               => Formule_2_R.Calculer,
         Convergence_Adaptation_G => Formule_2_R.Resultats_Convergent,
         Put_Parametres_G         => Formule_2_IO_R.Put_Parametres,
         Put_Resultat_G           => Formule_2_IO_R.Put_Resultat,
         Afficher_Formule_G       => Formule_2_IO_R.Afficher_Formule
      );

   procedure Min_Anonyme_2 is new Determiner_Min
      (Population_G_P => Population_Anonyme_2_P);

   package Trouver_Val_Param_P is new Demo_P.Trouver_Param_Valeur_G
      (Objectif_G => 50.0);
   package Trouver_Val_Param_IO is new Trouver_Val_Param_P.Text_IO;

   --  Expérimentation pour trouver les paramètres qui permettent d'atteindre
   --  une valeur.
   package Trouver_R    renames Trouver_Val_Param_P;
   package Trouver_IO_R renames Trouver_Val_Param_IO;

   use type Trouver_R.Resultat_T;

   package Population_Trouver_Parametres_P is new A_E_P.Algo_Evolutionnaire_G
      (
         ID_Population_G_T        => Demo_P.ID_Population_T,
         Parametres_G_T           => Trouver_R.Anonyme_T,
         Generer_G                => Trouver_R.Generer,
         Accoupler_G              => Trouver_R.Accoupler,
         Resultat_Calcul_G_T      => Trouver_R.Resultat_T,
         Calculer_G               => Trouver_R.Calculer,
         Convergence_Adaptation_G => Trouver_R.Resultats_Convergent,
         Put_Parametres_G         => Trouver_IO_R.Put_Parametres,
         Put_Resultat_G           => Trouver_IO_R.Put_Resultat,
         Afficher_Formule_G       => Trouver_IO_R.Afficher_Formule
      );

   procedure Trouver_Parametres is new Determiner_Min
      (Population_G_P => Population_Trouver_Parametres_P);

   --  Expérimentation pour trouver le chemin le plus court dans un graph.
   package Chemin_R    renames Demo_P.Chemin_P.Evo_P;
   package Chemin_IO_R renames Demo_P.Chemin_P.Evo_P.Text_IO;

   use type Chemin_R.Resultat_T;

   type ID_Pop_Chemin_T is new A_E_P.Taille_Population_T range 1 .. 1_000;

   package Population_Chemin_P is new A_E_P.Algo_Evolutionnaire_G
      (
         ID_Population_G_T        => ID_Pop_Chemin_T,
         Parametres_G_T           => Chemin_R.Probleme_Chemin_T,
         Generer_G                => Chemin_R.Generer,
         Accoupler_G              => Chemin_R.Accoupler,
         Resultat_Calcul_G_T      => Chemin_R.Resultat_T,
         Calculer_G               => Chemin_R.Calculer,
         Convergence_Adaptation_G => Chemin_R.Resultats_Convergent,
         Put_Parametres_G         => Chemin_IO_R.Put_Parametres,
         Put_Resultat_G           => Chemin_IO_R.Put_Resultat,
         Afficher_Formule_G       => Chemin_IO_R.Afficher_Formule
      );

   procedure Trouver_Chemin_Min is new Determiner_Min
      (Population_G_P => Population_Chemin_P);
begin
   --  Ada.Text_IO.Put      (Item => "Procédure : [");
   --  Ada.Text_IO.Put      (Item => GNAT.Source_Info.Enclosing_Entity);
   --  Ada.Text_IO.Put      (Item => "], une instance de : ");
   --  Ada.Text_IO.Put_Line (Item => GNAT.Source_Info.Source_Location);

   Min_Surface
      (Nom => "X",      Min => "5.88",         Reduire_Affichage => False);

   Min_Anonyme_1
      (Nom => "X",      Min => "0.0",          Reduire_Affichage => True);

   Min_Anonyme_2
      (Nom => "X et Y", Min => "-0.55, -1,55", Reduire_Affichage => True);

   Trouver_Parametres
      (Nom => "X et Y", Min =>   "45.0, 50.0", Reduire_Affichage => True);

   Bloc_Afficher_Score_Min :
   declare
      type Table_Sommets_T is array (Demo_P.Sommet_T) of Boolean;

      Str_Min : constant String := Integer'Image (Table_Sommets_T'Length - 1);
   begin
      Trouver_Chemin_Min
         (
            Nom               => "chemin",
            Min               =>
               "tous les sommets une fois (score :" & Str_Min & ")",
            Reduire_Affichage => True
         );
   end Bloc_Afficher_Score_Min;
end Executer;
