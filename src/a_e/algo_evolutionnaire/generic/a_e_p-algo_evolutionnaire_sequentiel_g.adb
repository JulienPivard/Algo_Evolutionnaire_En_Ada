package body A_E_P.Algo_Evolutionnaire_G
   with Spark_Mode => Off
is

   use type Outils_P.NB_Tours_Sans_Divergences_T;
   use type Outils_P.NB_Tours_Sans_Amelioration_T;

   ---------------------------------------------------------------------------
   procedure Faire_Evoluer
      (
         Population     : in out Population_T;
         Debut, Fin     :    out Ada.Real_Time.Time;
         NB_Generations :    out Natural
      )
   is
      NB_Tours_Sans_Divergences  : Outils_P.NB_Tours_Sans_Divergences_T  :=
         Outils_P.NB_Tours_Sans_Divergences_T'First;
      NB_Tours_Sans_Amelioration : Outils_P.NB_Tours_Sans_Amelioration_T :=
         Outils_P.NB_Tours_Sans_Amelioration_T'First;

      Evolution_Est_Finie : Boolean;
   begin
      Outils_P.Initialiser (Population => Population.Pop);

      NB_Generations := Natural'First;
      Debut          := Ada.Real_Time.Clock;

      Boucle_Generation_Successive :
      loop
         Outils_P.Trier_Et_Verifier
            (
               Population                 => Population.Pop,
               NB_Tours_Sans_Divergences  => NB_Tours_Sans_Divergences,
               NB_Tours_Sans_Amelioration => NB_Tours_Sans_Amelioration
            );

         Evolution_Est_Finie :=
            (
               (
                  NB_Tours_Sans_Divergences
                  =
                  Outils_P.NB_Tours_Sans_Divergences_T'Last
               )
               or else
               (
                  NB_Tours_Sans_Amelioration
                  =
                  Outils_P.NB_Tours_Sans_Amelioration_T'Last
               )
            );
         exit Boucle_Generation_Successive when Evolution_Est_Finie;
         exit Boucle_Generation_Successive when NB_Generations = Natural'Last;

         NB_Generations := NB_Generations + 1;

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
