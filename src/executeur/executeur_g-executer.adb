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

with Chrono_IO;

separate (Executeur_G)
procedure Executer
   --  (Arguments)
is
   ---------------------------------------------------------------------------
   generic
      with package Population_P is new A_E_P.Algo_Evolutionnaire_G (<>);
      --  La population à minimiser.

   procedure Determiner_Min
      (
         Min               : in String;
         Nom               : in String;
         Reduire_Affichage : in Boolean := False
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
         Min               : in String;
         Nom               : in String;
         Reduire_Affichage : in Boolean := False
      )
   is
      use type A_E_P.Taille_Population_T;

      Taille : constant A_E_P.Taille_Population_T :=
         Population_P.Taille_Population;

      Population : Population_P.Population_T;
      Debut, Fin : Ada.Real_Time.Time;

      Nb_Generations : Natural := Natural'First;
   begin
      if not Reduire_Affichage then
         Population_P.Afficher_Details;
      else
         Ada.Text_IO.Put_Line
            (
               Item => "Population   :" & A_E_P.Taille_Population_T'Image
                  (Population_P.Taille_Population)
            );
      end if;

      Population_P.Initialiser (Population => Population);

      if Taille < 50 and then not Reduire_Affichage then
         Ada.Text_IO.Put_Line
            (Item => "========== Valeurs de départ ==========");

         Ada.Text_IO.New_Line    (Spacing => 1);
         Population_P.Put_Line   (Item    => Population);
         Ada.Text_IO.Put_Line    (Item    => "=======");
         Ada.Text_IO.New_Line    (Spacing => 1);
      end if;

      Population_P.Faire_Evoluer
         (
            Population      => Population,
            Debut           => Debut,
            Fin             => Fin,
            Nb_Generations  => Nb_Generations
         );

      if not Reduire_Affichage then
         Ada.Text_IO.Put_Line
            (Item => "======= Valeurs après évolution =======");
         Ada.Text_IO.Put_Line
            (Item => "La valeur de " & Nom & " pour le min : " & Min);

         Ada.Text_IO.New_Line    (Spacing => 1);
      end if;
      Population_P.Put_Line   (Item    => Population);
      Ada.Text_IO.Put_Line    (Item    => "=======");

      Ada.Text_IO.Put_Line
         (
            Item => "Nombre de générations : " &
               Natural'Image (Nb_Generations)
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
         Taille_Population      => Demo_P.Taille,
         Parametres_G_T         => Surface_R.Surface_T,
         Generer                => Surface_R.Generer,
         Accoupler              => Surface_R.Accoupler,
         Resultat_Calcul_G_T    => Surface_R.Resultat_T,
         Calculer               => Surface_R.Calculer,
         Convergence_Adaptation => Surface_R.Resultats_Convergent,
         Put_Parametres         => Surface_IO_R.Put_Parametres,
         Put_Resultat           => Surface_IO_R.Put_Resultat,
         Afficher_Formule       => Surface_IO_R.Afficher_Formule
      );

   procedure Min_Surface is new Determiner_Min
      (Population_P => Population_Surface_P);

   --  Expérimentation avec une formule à un paramètre
   package Formule_1_R    renames Demo_P.Formule_A_1_P;
   package Formule_1_IO_R renames Demo_P.Formule_A_1_P.Text_IO;

   use type Formule_1_R.Resultat_T;

   package Population_Anonyme_1_P is new A_E_P.Algo_Evolutionnaire_G
      (
         Taille_Population      => Demo_P.Taille,
         Parametres_G_T         => Formule_1_R.Anonyme_T,
         Generer                => Formule_1_R.Generer,
         Accoupler              => Formule_1_R.Accoupler,
         Resultat_Calcul_G_T    => Formule_1_R.Resultat_T,
         Calculer               => Formule_1_R.Calculer,
         Convergence_Adaptation => Formule_1_R.Resultats_Convergent,
         Put_Parametres         => Formule_1_IO_R.Put_Parametres,
         Put_Resultat           => Formule_1_IO_R.Put_Resultat,
         Afficher_Formule       => Formule_1_IO_R.Afficher_Formule
      );

   procedure Min_Anonyme_1 is new Determiner_Min
      (Population_P => Population_Anonyme_1_P);

   --  Expérimentation avec une formule à deux paramètres
   package Formule_2_R    renames Demo_P.Formule_A_2_P;
   package Formule_2_IO_R renames Demo_P.Formule_A_2_P.Text_IO;

   use type Formule_2_R.Resultat_T;

   package Population_Anonyme_2_P is new A_E_P.Algo_Evolutionnaire_G
      (
         Taille_Population      => Demo_P.Taille,
         Parametres_G_T         => Formule_2_R.Anonyme_T,
         Generer                => Formule_2_R.Generer,
         Accoupler              => Formule_2_R.Accoupler,
         Resultat_Calcul_G_T    => Formule_2_R.Resultat_T,
         Calculer               => Formule_2_R.Calculer,
         Convergence_Adaptation => Formule_2_R.Resultats_Convergent,
         Put_Parametres         => Formule_2_IO_R.Put_Parametres,
         Put_Resultat           => Formule_2_IO_R.Put_Resultat,
         Afficher_Formule       => Formule_2_IO_R.Afficher_Formule
      );

   procedure Min_Anonyme_2 is new Determiner_Min
      (Population_P => Population_Anonyme_2_P);

   package Trouver_Val_Param_P is new Demo_P.Trouver_Param_Valeur_G
      (Objectif => 50.0);
   package Trouver_Val_Param_IO is new Trouver_Val_Param_P.Text_IO;

   --  Expérimentation pour trouver les paramètres qui permettent d'atteindre
   --  une valeur.
   package Trouver_R    renames Trouver_Val_Param_P;
   package Trouver_IO_R renames Trouver_Val_Param_IO;

   use type Trouver_R.Resultat_T;

   package Population_Trouver_Parametres_P is new A_E_P.Algo_Evolutionnaire_G
      (
         Taille_Population      => Demo_P.Taille,
         Parametres_G_T         => Trouver_R.Anonyme_T,
         Generer                => Trouver_R.Generer,
         Accoupler              => Trouver_R.Accoupler,
         Resultat_Calcul_G_T    => Trouver_R.Resultat_T,
         Calculer               => Trouver_R.Calculer,
         Convergence_Adaptation => Trouver_R.Resultats_Convergent,
         Put_Parametres         => Trouver_IO_R.Put_Parametres,
         Put_Resultat           => Trouver_IO_R.Put_Resultat,
         Afficher_Formule       => Trouver_IO_R.Afficher_Formule
      );

   procedure Trouver_Parametres is new Determiner_Min
      (Population_P => Population_Trouver_Parametres_P);
begin
   --  Ada.Text_IO.Put      (Item => "Procédure : [");
   --  Ada.Text_IO.Put      (Item => GNAT.Source_Info.Enclosing_Entity);
   --  Ada.Text_IO.Put      (Item => "], une instance de : ");
   --  Ada.Text_IO.Put_Line (Item => GNAT.Source_Info.Source_Location);

   Min_Surface
      (Nom => "X",      Min => "5.88",         Reduire_Affichage => True);

   Min_Anonyme_1
      (Nom => "X",      Min => "0.0",          Reduire_Affichage => True);

   Min_Anonyme_2
      (Nom => "X et Y", Min => "-0.55, -1,55", Reduire_Affichage => True);

   Trouver_Parametres
      (Nom => "X et Y", Min =>   "45.0, 50.0", Reduire_Affichage => True);
end Executer;
