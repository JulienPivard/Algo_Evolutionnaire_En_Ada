with GNAT.Source_Info;

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
         Min               : in String;
         Nom               : in String;
         Reduire_Affichage : in Boolean := False
      );
   --  Détermine le minimum de la formule.
   --  @param Min
   --  Le minimum attendu.
   --  @param Nom
   --  Le nom des variables.

   ------------------------
   procedure Determiner_Min
      (
         Min               : in String;
         Nom               : in String;
         Reduire_Affichage : in Boolean := False
      )
   is
      Population : Population_P.Population_T;
      Debut, Fin : Ada.Real_Time.Time;

      Nb_Generations : Natural := Natural'First;
   begin
      if not Reduire_Affichage then
         Population_P.Afficher_Details;
      else
         Ada.Text_IO.Put_Line
            (
               Item => "Population   :" &
                  Population_P.Indice_Population_T'Image
                     (Population_P.Indice_Population_T'Last)
            );
      end if;

      Population_P.Initialiser (Population => Population);

      if not Reduire_Affichage then
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
      Chrono_P.Affichage_Temps (Debut => Debut, Fin => Fin);

      Ada.Text_IO.New_Line (Spacing => (if Reduire_Affichage then 2 else 4));
      --------------------------------------
   end Determiner_Min;
   ---------------------------------------------------------------------------

   --  Expérimentation avec une formule de calcul de surface d'un volume.
   package Surface_R renames A_E_P.Parametres_P.Surface_P;

   package Population_Surface_P  is new A_E_P.Algo_Evolutionnaire_G
      (
         Indice_Population_T       => Intervalle_P.Indice_T,
         Parametres_G_T            => Surface_R.Surface_T,
         Put                       => Surface_R.Text_IO.Put,
         Intervalle_De_Convergence => 0.5
      );

   procedure Min_Surface is new Determiner_Min
      (Population_P => Population_Surface_P);

   --  Expérimentation avec une formule à un paramètre
   package Formule_A_1_R renames A_E_P.Parametres_P.Formule_A_1_P;

   package Population_Anonyme_1_P  is new A_E_P.Algo_Evolutionnaire_G
      (
         Indice_Population_T       => Intervalle_P.Indice_T,
         Parametres_G_T            => Formule_A_1_R.Anonyme_T,
         Put                       => Formule_A_1_R.Text_IO.Put,
         Intervalle_De_Convergence => 0.5
      );

   procedure Min_Anonyme_1 is new Determiner_Min
      (Population_P => Population_Anonyme_1_P);

   --  Expérimentation avec une formule à deux paramètres
   package Formule_A_2_R renames A_E_P.Parametres_P.Formule_A_2_P;

   package Population_Anonyme_2_P  is new A_E_P.Algo_Evolutionnaire_G
      (
         Indice_Population_T       => Intervalle_P.Indice_T,
         Parametres_G_T            => Formule_A_2_R.Anonyme_T,
         Put                       => Formule_A_2_R.Text_IO.Put,
         Intervalle_De_Convergence => 0.5
      );

   procedure Min_Anonyme_2 is new Determiner_Min
      (Population_P => Population_Anonyme_2_P);
begin

   Ada.Text_IO.Put      (Item => "Procédure : [");
   Ada.Text_IO.Put      (Item => GNAT.Source_Info.Enclosing_Entity);
   Ada.Text_IO.Put      (Item => "], une instance de : ");
   Ada.Text_IO.Put_Line (Item => GNAT.Source_Info.Source_Location);

   Min_Surface
      (Nom => "X",      Min => "5.88",         Reduire_Affichage => True);

   Min_Anonyme_1
      (Nom => "X",      Min => "0.0",          Reduire_Affichage => True);

   Min_Anonyme_2
      (Nom => "X et Y", Min => "-0.55, -1,55", Reduire_Affichage => True);
end Executer;
