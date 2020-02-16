with Ada.Text_IO;
with Ada.Real_Time;

with A_E_P;
with A_E_P.Parametres_P.Surface_P;
with A_E_P.Parametres_P.Surface_P.Text_IO;

with A_E_P.Algo_Evolutionnaire_G;

with A_E_P.Parametres_P.Formule_A_1_P;
with A_E_P.Parametres_P.Formule_A_1_P.Text_IO;

with Chrono_P;
with Intervalle_P;

separate (Executeur_G)
procedure Executer
   --  (Arguments)
is
   package Population_Surface_P  is new A_E_P.Algo_Evolutionnaire_G
      (
         Indice_Population_T => Intervalle_P.Indice_T,
         Parametres_G_T      => A_E_P.Parametres_P.Surface_P.Surface_T,
         Put                 => A_E_P.Parametres_P.Surface_P.Text_IO.Put
      );

   Population_Surface : Population_Surface_P.Population_T;
   Debut, Fin         : Ada.Real_Time.Time;

   Nb_Generations : Natural := Natural'First;

   package Population_Anonyme_1_P  is new A_E_P.Algo_Evolutionnaire_G
      (
         Indice_Population_T => Intervalle_P.Indice_T,
         Parametres_G_T      => A_E_P.Parametres_P.Formule_A_1_P.Anonyme_T,
         Put                 => A_E_P.Parametres_P.Formule_A_1_P.Text_IO.Put
      );

   Population_Anonyme : Population_Anonyme_1_P.Population_T;
begin
   Population_Surface_P.Afficher_Details;

   Population_Surface_P.Initialiser (Population => Population_Surface);

   Ada.Text_IO.Put_Line (Item => "========== Valeurs de départ ==========");

   Ada.Text_IO.New_Line          (Spacing => 1);
   Population_Surface_P.Put_Line (Item    => Population_Surface);
   Ada.Text_IO.New_Line          (Spacing => 1);

   Population_Surface_P.Faire_Evoluer
      (
         Population      => Population_Surface,
         Debut           => Debut,
         Fin             => Fin,
         Nb_Generations  => Nb_Generations
      );

   Ada.Text_IO.Put_Line (Item => "======= Valeurs après évolution =======");

   Ada.Text_IO.New_Line          (Spacing => 1);
   Population_Surface_P.Put_Line (Item    => Population_Surface);
   Ada.Text_IO.New_Line          (Spacing => 1);

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

   Population_Anonyme_1_P.Afficher_Details;

   Population_Anonyme_1_P.Initialiser (Population => Population_Anonyme);

   Ada.Text_IO.Put_Line (Item => "========== Valeurs de départ ==========");

   Ada.Text_IO.New_Line             (Spacing => 1);
   Population_Anonyme_1_P.Put_Line  (Item    => Population_Anonyme);
   Ada.Text_IO.New_Line             (Spacing => 1);

   Population_Anonyme_1_P.Faire_Evoluer
      (
         Population      => Population_Anonyme,
         Debut           => Debut,
         Fin             => Fin,
         Nb_Generations  => Nb_Generations
      );

   Ada.Text_IO.Put_Line (Item => "======= Valeurs après évolution =======");

   Ada.Text_IO.New_Line             (Spacing => 1);
   Population_Anonyme_1_P.Put_Line  (Item    => Population_Anonyme);
   Ada.Text_IO.New_Line             (Spacing => 1);

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
