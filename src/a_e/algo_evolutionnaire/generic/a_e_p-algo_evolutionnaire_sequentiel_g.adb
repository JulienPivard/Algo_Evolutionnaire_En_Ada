package body A_E_P.Algo_Evolutionnaire_G
   with Spark_Mode => Off
is

   use type Outils_P.Nb_Tours_Sans_Divergences_T;
   use type Outils_P.Nb_Tours_Sans_Amelioration_T;

   ---------------------------------------------------------------------------
   procedure Faire_Evoluer
      (
         Population     : in out Population_T;
         Debut, Fin     :    out Ada.Real_Time.Time;
         Nb_Generations :    out Natural
      )
   is
      Nb_Tours_Sans_Divergences  : Outils_P.Nb_Tours_Sans_Divergences_T  :=
         Outils_P.Nb_Tours_Sans_Divergences_T'First;
      Nb_Tours_Sans_Amelioration : Outils_P.Nb_Tours_Sans_Amelioration_T :=
         Outils_P.Nb_Tours_Sans_Amelioration_T'First;

      Evolution_Est_Finie : Boolean;
   begin
      Outils_P.Initialiser (Population => Population.Pop);

      Nb_Generations := Natural'First;
      Debut          := Ada.Real_Time.Clock;

      Boucle_Generation_Successive :
      loop
         Outils_P.Trier_Et_Verifier
            (
               Population             => Population.Pop,
               Nb_Tours_Sans_Divergences  => Nb_Tours_Sans_Divergences,
               Nb_Tours_Sans_Amelioration => Nb_Tours_Sans_Amelioration
            );

         Evolution_Est_Finie :=
            (
               (
                  Nb_Tours_Sans_Divergences
                  =
                  Outils_P.Nb_Tours_Sans_Divergences_T'Last
               )
               or else
               (
                  Nb_Tours_Sans_Amelioration
                  =
                  Outils_P.Nb_Tours_Sans_Amelioration_T'Last
               )
            );
         exit Boucle_Generation_Successive when Evolution_Est_Finie;
         exit Boucle_Generation_Successive when Nb_Generations = Natural'Last;

         Nb_Generations := Nb_Generations + 1;

         Outils_P.Passer_A_La_Generation_Suivante
            (Population => Population.Pop);
      end loop Boucle_Generation_Successive;

      Fin := Ada.Real_Time.Clock;
   end Faire_Evoluer;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   procedure Initialiser
      (Population : in out Population_T)
   is
   begin
      Outils_P.Initialiser (Population => Population.Pop);
   end Initialiser;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   procedure Put_Line
      (Item : in     Population_T)
   is
   begin
      Outils_P.Put_Line (Item => Item.Pop);
   end Put_Line;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   procedure Afficher_Details is
   begin
      Outils_P.Afficher_Details;
   end Afficher_Details;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   --                             Partie privée                             --
   ---------------------------------------------------------------------------

end A_E_P.Algo_Evolutionnaire_G;
