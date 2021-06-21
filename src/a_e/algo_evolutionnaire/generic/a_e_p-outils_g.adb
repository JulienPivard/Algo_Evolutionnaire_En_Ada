with Ada.Text_IO;

package body A_E_P.Outils_G
   with Spark_Mode => Off
is

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
   procedure Accueillir_Migrants
      (
         Population : in out Population_T;
         Migrants   : in     Migrants_T
      )
   is
   begin
      Population_P.Accueillir_Migrants
         (
            Population => Population.Pop,
            Migrants   => Migrants.Pop
         );
   end Accueillir_Migrants;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   function Faire_Migrer
      (Population : in     Population_T)
      return Migrants_T
   is
      Resultat : Migrants_T;
   begin
      Resultat.Pop :=
         Population_P.Faire_Migrer (Population => Population.Pop);
      return Resultat;
   end Faire_Migrer;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   --                               Partie privée                           --
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

end A_E_P.Outils_G;
