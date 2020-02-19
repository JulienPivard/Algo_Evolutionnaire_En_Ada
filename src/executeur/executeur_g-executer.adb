with Ada.Text_IO;
with Ada.Real_Time;

with A_E_P;
with A_E_P.Parametres_P.Surface_P;
with A_E_P.Parametres_P.Surface_P.Text_IO;

with A_E_P.Algo_Evolutionnaire_G;

with A_E_P.Parametres_P.Formule_A_1_P;
with A_E_P.Parametres_P.Formule_A_1_P.Text_IO;

with A_E_P.Parametres_P.Formule_A_2_P;
with A_E_P.Parametres_P.Formule_A_2_P.Text_IO;

with Chrono_P;
with Intervalle_P;

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
         Min : in String;
         Nom : in String
      );
   --  Détermine le minimum de la formule.
   --  @param Min
   --  Le minimum attendu.
   --  @param Nom
   --  Le nom des variables.

   ------------------------
   procedure Determiner_Min
      (
         Min : in String;
         Nom : in String
      )
   is
      Population : Population_P.Population_T;
      Debut, Fin : Ada.Real_Time.Time;

      Nb_Generations : Natural := Natural'First;
   begin
      Population_P.Afficher_Details;

      Population_P.Initialiser (Population => Population);

      Ada.Text_IO.Put_Line
         (Item => "========== Valeurs de départ ==========");

      Ada.Text_IO.New_Line    (Spacing => 1);
      Population_P.Put_Line   (Item    => Population);
      Ada.Text_IO.Put_Line    (Item    => "=======");
      Ada.Text_IO.New_Line    (Spacing => 1);

      Population_P.Faire_Evoluer
         (
            Population      => Population,
            Debut           => Debut,
            Fin             => Fin,
            Nb_Generations  => Nb_Generations
         );

      Ada.Text_IO.Put_Line
         (Item => "======= Valeurs après évolution =======");
      Ada.Text_IO.Put_Line
         (Item => "La valeur de " & Nom & " pour le min : " & Min);

      Ada.Text_IO.New_Line    (Spacing => 1);
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
      Chrono_P.Affichage_Temps (Debut => Debut, Fin => Fin);

      Ada.Text_IO.New_Line (Spacing => 4);
      --------------------------------------
   end Determiner_Min;
   ---------------------------------------------------------------------------

   package Population_Surface_P  is new A_E_P.Algo_Evolutionnaire_G
      (
         Indice_Population_T => Intervalle_P.Indice_T,
         Parametres_G_T      => A_E_P.Parametres_P.Surface_P.Surface_T,
         Put                 => A_E_P.Parametres_P.Surface_P.Text_IO.Put
      );

   procedure Min_Surface is new Determiner_Min
      (Population_P => Population_Surface_P);

   package Population_Anonyme_1_P  is new A_E_P.Algo_Evolutionnaire_G
      (
         Indice_Population_T => Intervalle_P.Indice_T,
         Parametres_G_T      => A_E_P.Parametres_P.Formule_A_1_P.Anonyme_T,
         Put                 => A_E_P.Parametres_P.Formule_A_1_P.Text_IO.Put
      );

   procedure Min_Anonyme_1 is new Determiner_Min
      (Population_P => Population_Anonyme_1_P);

   package Population_Anonyme_2_P  is new A_E_P.Algo_Evolutionnaire_G
      (
         Indice_Population_T => Intervalle_P.Indice_T,
         Parametres_G_T      => A_E_P.Parametres_P.Formule_A_2_P.Anonyme_T,
         Put                 => A_E_P.Parametres_P.Formule_A_2_P.Text_IO.Put
      );

   procedure Min_Anonyme_2 is new Determiner_Min
      (Population_P => Population_Anonyme_2_P);
begin
   Min_Surface
      (Nom => "X",      Min => "5.88");

   Min_Anonyme_1
      (Nom => "X",      Min => "0.0");

   Min_Anonyme_2
      (Nom => "X et Y", Min => "-0.55, -1,55");
end Executer;
