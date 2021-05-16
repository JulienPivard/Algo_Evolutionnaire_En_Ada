with Ada.Text_IO;

package body A_E_P.Algo_Evolutionnaire_G
   with Spark_Mode => Off
is

   ---------------------------------------------------------------------------
   procedure Faire_Evoluer
      (
         Population     : in out Population_T;
         Debut, Fin     :    out Ada.Real_Time.Time;
         Nb_Generations :    out Natural
      )
   is
      Nb_Tours_Sans_Divergences : Nb_Tours_Sans_Divergences_T := 0;
   begin
      Initialiser (Population => Population);

      Nb_Generations := Natural'First;
      Debut          := Ada.Real_Time.Clock;

      Boucle_Generation_Successive :
      loop
         Trier_Et_Verifier
            (
               Population             => Population,
               Tours_Sans_Divergences => Nb_Tours_Sans_Divergences
            );

         exit Boucle_Generation_Successive when Nb_Tours_Sans_Divergences = 25;
         exit Boucle_Generation_Successive when Nb_Generations = Natural'Last;

         Nb_Generations := Nb_Generations + 1;

         Passer_A_La_Generation_Suivante (Population => Population);
      end loop Boucle_Generation_Successive;

      Fin := Ada.Real_Time.Clock;
   end Faire_Evoluer;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   procedure Initialiser
      (Population : in out Population_T)
   is
   begin
      if not Population.Initialisee then
         Population_P.Initialiser (Population => Population.Pop);
         Population.Initialisee := True;
      end if;
   end Initialiser;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   procedure Put_Line
      (Item : in     Population_T)
   is
   begin
      Ada.Text_IO.Put (Item => "Formule : ");
      Afficher_Formule;
      Population_IO.Put_Line (Item => Item.Pop);
   end Put_Line;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   procedure Afficher_Details is
   begin
      Population_IO.Afficher_Details;
   end Afficher_Details;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   --                               Partie privée                           --
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   procedure Trier_Et_Verifier
      (
         Population             : in out Population_T;
         Tours_Sans_Divergences : in out Nb_Tours_Sans_Divergences_T
      )
   is
   begin
      Trier (Population => Population);

      --  Toutes les valeurs survivantes doivent se trouver autour
      --  de la valeur minimum du tableau pendant 25 générations.
      --  Intervalle de convergence
      if Verifier_Convergence (Population => Population) then
         Tours_Sans_Divergences := Tours_Sans_Divergences + 1;
      else
         Tours_Sans_Divergences := 0;
      end if;
   end Trier_Et_Verifier;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   procedure Passer_A_La_Generation_Suivante
      (Population : in out Population_T)
   is
   begin
      Remplacer_Morts           (Population => Population);
      Calcul_Formule_Sur_Enfant (Population => Population);

      Faire_Evoluer_Par_Tournoi (Population => Population);
   end Passer_A_La_Generation_Suivante;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   procedure Remplacer_Morts
      (Population : in out Population_T)
   is
   begin
      Population_P.Remplacer_Morts (Population => Population.Pop);
   end Remplacer_Morts;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   procedure Calcul_Formule_Sur_Enfant
      (Population : in out Population_T)
   is
   begin
      Population_P.Calcul_Formule_Sur_Enfant (Population => Population.Pop);
   end Calcul_Formule_Sur_Enfant;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   procedure Faire_Evoluer_Par_Tournoi
      (Population : in out Population_T)
   is
   begin
      Population_P.Organiser_Tournois (Population => Population.Pop);
   end Faire_Evoluer_Par_Tournoi;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   procedure Trier
      (Population : in out Population_T)
   is
   begin
      Population_P.Trier (Population => Population.Pop);
   end Trier;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   function Verifier_Convergence
      (Population : in     Population_T)
      return Boolean
   is
   begin
      return Population_P.Verifier_Convergence (Population => Population.Pop);
   end Verifier_Convergence;
   ---------------------------------------------------------------------------

end A_E_P.Algo_Evolutionnaire_G;
