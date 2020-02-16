with Ada.Text_IO;
with Ada.Real_Time;

with A_E_P;
with A_E_P.Parametres_P.Surface_P;
with A_E_P.Parametres_P.Surface_P.Text_IO;

with A_E_P.Algo_Evolutionnaire_G;

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
begin
   Population_Surface_P.Afficher_Details;

   Population_Surface_P.Initialiser (Population => Population_Surface);

   Ada.Text_IO.Put_Line (Item    => "========== Valeurs de départ ==========");

   Ada.Text_IO.New_Line          (Spacing => 1);
   Population_Surface_P.Put_Line (Item    => Population_Surface);
   Ada.Text_IO.New_Line          (Spacing => 1);

   Debut := Ada.Real_Time.Clock;
   Boucle_Generation_Successive :
   loop

      Population_Surface_P.Trier (Population => Population_Surface);

      --  Toutes les valeurs survivantes doivent se trouver autour
      --  de la valeur minimum du tableau +/-1
      --  Intervalle de convergence
      exit Boucle_Generation_Successive when
         Population_Surface_P.Verifier_Convergence
            (Population => Population_Surface);

      Nb_Generations := Nb_Generations + 1;

      Population_Surface_P.Remplacer_Morts (Population => Population_Surface);

      Population_Surface_P.Calcul_Formule_Sur_Enfant
         (Population => Population_Surface);

   end loop Boucle_Generation_Successive;
   Fin := Ada.Real_Time.Clock;

   Ada.Text_IO.Put_Line (Item    => "======= Valeurs après évolution =======");

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
end Executer;
