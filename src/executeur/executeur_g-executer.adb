with Ada.Text_IO;
with Ada.Real_Time;

with A_E_P;
with A_E_P.Population_P;
with A_E_P.Formule_P;

with Chrono_P;

separate (Executeur_G)
procedure Executer
   --  (Arguments)
is
   use type A_E_P.Math_T;
   use type A_E_P.V_Param_T;
   use type A_E_P.V_Calcule_T;

   Formule : constant A_E_P.Formule_P.Formule_T :=
      A_E_P.Formule_P.Formule_Surface'Access;

   Population : A_E_P.Population_P.Population_T;
   Debut, Fin : Ada.Real_Time.Time;

   Nb_Generations : Natural := Natural'First;

begin
   A_E_P.Population_P.Afficher_Details;

   A_E_P.Population_P.Initialiser
      (
         Population => Population,
         Formule    => Formule
      );

   Ada.Text_IO.Put_Line (Item    => "========== Valeurs de départ ==========");

   Ada.Text_IO.New_Line        (Spacing => 1);
   A_E_P.Population_P.Put_Line (Item    => Population);
   Ada.Text_IO.New_Line        (Spacing => 1);

   Debut := Ada.Real_Time.Clock;
   Boucle_Generation_Successive :
   loop
      A_E_P.Population_P.Trier (Population => Population);

      --  Toutes les valeurs survivantes doivent se trouver autour
      --  de la valeur minimum du tableau +/-1
      --  Intervalle de convergence
      exit Boucle_Generation_Successive when
         A_E_P.Population_P.Verifier_Convergence (Population => Population);

      A_E_P.Population_P.Remplacer_Morts (Population => Population);

      Nb_Generations := Nb_Generations + 1;

      A_E_P.Population_P.Calcul_Formule_Sur_Enfant
         (
            Population => Population,
            Formule    => Formule
         );

   end loop Boucle_Generation_Successive;
   Fin := Ada.Real_Time.Clock;

   Ada.Text_IO.Put_Line (Item    => "======= Valeurs après évolution =======");

   Ada.Text_IO.New_Line        (Spacing => 1);
   A_E_P.Population_P.Put_Line (Item    => Population);
   Ada.Text_IO.New_Line        (Spacing => 1);

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
