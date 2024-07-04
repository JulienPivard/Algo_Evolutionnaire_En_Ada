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
      Afficher_Formule_G;
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
         Population                 : in out Population_T;
         NB_Tours_Sans_Divergences  : in out NB_Tours_Sans_Divergences_T;
         NB_Tours_Sans_Amelioration : in out NB_Tours_Sans_Amelioration_T
      )
   is
      Est_Ameliore : Boolean;
   begin
      Trier (Population => Population.Pop);

      --  Toutes les valeurs survivantes doivent se trouver autour
      --  de la valeur minimum du tableau pendant 25 générations.
      --  Intervalle de convergence
      if Verifier_Convergence (Population => Population.Pop) then
         NB_Tours_Sans_Divergences := NB_Tours_Sans_Divergences + 1;
      else
         NB_Tours_Sans_Divergences := 0;
      end if;

      Population_P.C_Est_Ameliore_Depuis_Gen_Precedente
         (
            Population   => Population.Pop,
            Est_Ameliore => Est_Ameliore
         );
      if Est_Ameliore then
         NB_Tours_Sans_Amelioration := 0;
      else
         NB_Tours_Sans_Amelioration := NB_Tours_Sans_Amelioration + 1;
      end if;
   end Trier_Et_Verifier;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   procedure Passer_A_La_Generation_Suivante
      (Population : in out Population_T)
   is
   begin
      Remplacer_Morts           (Population => Population.Pop);
      Calcul_Formule_Sur_Enfant (Population => Population.Pop);

      Faire_Evoluer_Par_Tournoi (Population => Population.Pop);
   end Passer_A_La_Generation_Suivante;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   procedure Accueillir_Migrants
      (
         Population : in out Population_T;
         Migrants   : in     Migrants_T;
         Resultats  : in     Resultat_Tournois_T
      )
   is
   begin
      Population_P.Accueillir_Migrants
         (
            Population => Population.Pop,
            Migrants   => Migrants.Pop,
            Resultats  => Resultats.Pop
         );
   end Accueillir_Migrants;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   procedure Selectionner_Migrants
      (
         Population : in     Population_T;
         Migrants   :    out Migrants_T;
         Resultats  :    out Resultat_Tournois_T
      )
   is
   begin
      Population_P.Selectionner_Migrants
         (
            Population => Population.Pop,
            Migrants   => Migrants.Pop,
            Resultats  => Resultats.Pop
         );
   end Selectionner_Migrants;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   --                             Partie privée                             --
   ---------------------------------------------------------------------------

end A_E_P.Outils_G;
