with Ada.Text_IO;
with Ada.Real_Time;

with A_E_P;
with A_E_P.Population_G;
with A_E_P.Population_G.Text_IO;
with A_E_P.Individu_G;
with A_E_P.Individu_G.Text_IO;
with A_E_P.Parametres_P.Surface_P;
with A_E_P.Parametres_P.Surface_P.Text_IO;

with Chrono_P;
with Intervalle_P;

pragma Elaborate_All (A_E_P.Population_G);

separate (Executeur_G)
procedure Executer
   --  (Arguments)
is
   package Individu_Surface_P    is new A_E_P.Individu_G
      (Parametres_G_T => A_E_P.Parametres_P.Surface_P.Surface_T);
   package Individu_Surface_IO   is new Individu_Surface_P.Text_IO
      (Put => A_E_P.Parametres_P.Surface_P.Text_IO.Put);
   package Population_Surface_P  is new A_E_P.Population_G
      (
         Indice_Population_T => Intervalle_P.Indice_T,
         Individu_P          => Individu_Surface_P
      );
   package Population_Surface_IO is new Population_Surface_P.Text_IO
      (Individu_IO => Individu_Surface_IO);

   Population : Population_Surface_P.Population_T;
   Debut, Fin : Ada.Real_Time.Time;

   Nb_Generations : Natural := Natural'First;
begin
   Population_Surface_IO.Afficher_Details;

   Population_Surface_P.Initialiser (Population => Population);

   Ada.Text_IO.Put_Line (Item    => "========== Valeurs de départ ==========");

   Ada.Text_IO.New_Line             (Spacing => 1);
   Population_Surface_IO.Put_Line   (Item    => Population);
   Ada.Text_IO.New_Line             (Spacing => 1);

   Debut := Ada.Real_Time.Clock;
   Boucle_Generation_Successive :
   loop

      Population_Surface_P.Trier (Population => Population);

      --  Toutes les valeurs survivantes doivent se trouver autour
      --  de la valeur minimum du tableau +/-1
      --  Intervalle de convergence
      exit Boucle_Generation_Successive when
         Population_Surface_P.Verifier_Convergence (Population => Population);

      Nb_Generations := Nb_Generations + 1;

      Population_Surface_P.Remplacer_Morts (Population => Population);

      Population_Surface_P.Calcul_Formule_Sur_Enfant
         (Population => Population);

   end loop Boucle_Generation_Successive;
   Fin := Ada.Real_Time.Clock;

   Ada.Text_IO.Put_Line (Item    => "======= Valeurs après évolution =======");

   Ada.Text_IO.New_Line             (Spacing => 1);
   Population_Surface_IO.Put_Line   (Item    => Population);
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
