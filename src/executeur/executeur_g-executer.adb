with Ada.Text_IO;
with Ada.Real_Time;

with A_E_P;
with A_E_P.Intervalle_P;
with A_E_P.Population_G;
with A_E_P.Formule_P;

with Chrono_P;

pragma Elaborate_All (A_E_P.Population_G);

separate (Executeur_G)
procedure Executer
   --  (Arguments)
is
   package Population_P  is new A_E_P.Population_G
      (Indice_Population_T => A_E_P.Intervalle_P.Indice_T);

   Formule : constant A_E_P.Formule_P.Formule_T :=
      A_E_P.Formule_P.Formule_Surface'Access;

   Population : Population_P.Population_T;
   Debut, Fin : Ada.Real_Time.Time;

   Nb_Generations : Natural := Natural'First;
begin
   Population_P.Afficher_Details;

   Population_P.Initialiser
      (
         Population => Population,
         Formule    => Formule
      );

   Ada.Text_IO.Put_Line (Item    => "========== Valeurs de départ ==========");

   Ada.Text_IO.New_Line    (Spacing => 1);
   Population_P.Put_Line   (Item    => Population);
   Ada.Text_IO.New_Line    (Spacing => 1);

   Debut := Ada.Real_Time.Clock;
   Boucle_Generation_Successive :
   loop

      Population_P.Trier (Population => Population);

      --  Toutes les valeurs survivantes doivent se trouver autour
      --  de la valeur minimum du tableau +/-1
      --  Intervalle de convergence
      exit Boucle_Generation_Successive when
         Population_P.Verifier_Convergence (Population => Population);

      Nb_Generations := Nb_Generations + 1;

      Population_P.Remplacer_Morts (Population => Population);

      Population_P.Calcul_Formule_Sur_Enfant
         (
            Population => Population,
            Formule    => Formule
         );

   end loop Boucle_Generation_Successive;
   Fin := Ada.Real_Time.Clock;

   Ada.Text_IO.Put_Line (Item    => "======= Valeurs après évolution =======");

   Ada.Text_IO.New_Line    (Spacing => 1);
   Population_P.Put_Line   (Item    => Population);
   Ada.Text_IO.New_Line    (Spacing => 1);

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
