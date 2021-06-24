package body A_E_P.Algo_Evolutionnaire_G
   with Spark_Mode => Off
is

   use type Outils_P.Nb_Tours_Sans_Divergences_T;

   ---------------------------------------------------------------------------
   procedure Faire_Evoluer
      (
         Population     : in out Population_T;
         Debut, Fin     :    out Ada.Real_Time.Time;
         Nb_Generations :    out Natural
      )
   is
      Nb_Tours_Sans_Divergences : Outils_P.Nb_Tours_Sans_Divergences_T := 0;
   begin
      Outils_P.Initialiser (Population => Population.Pop);

      Nb_Generations := Natural'First;
      Debut          := Ada.Real_Time.Clock;

      Boucle_Generation_Successive :
      loop
         Outils_P.Trier_Et_Verifier
            (
               Population             => Population.Pop,
               Tours_Sans_Divergences => Nb_Tours_Sans_Divergences
            );

         exit Boucle_Generation_Successive when Nb_Tours_Sans_Divergences = 25;
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
   --                               Partie privée                           --
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   protected body Transfert_T is
      --------------
      entry Attendre
         (Population :    out Outils_P.Migrants_T)
         when Echange_Autorise
      is
      begin
         Echange_Autorise := False;
         Population       := Pop_Local;
      end Attendre;
      --------------

      --------------
      procedure Envoyer
         (Population : in     Outils_P.Migrants_T)
      is
      begin
         Pop_Local        := Population;
         Echange_Autorise := True;
      end Envoyer;
      --------------
   end Transfert_T;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   task body Islot_T is
      Sortie     : Transfert_T renames Tables_De_Transfert (Id + 1);
      Entree     : Transfert_T renames Tables_De_Transfert (Id);

      Nb_Generations : Natural;
      Migrants       : Outils_P.Migrants_T;
      Population     : Population_T;
      Debut, Fin     : Ada.Real_Time.Time;

      Nb_Tours_Sans_Divergences : Outils_P.Nb_Tours_Sans_Divergences_T := 0;
   begin
      null;
   end Islot_T;
   ---------------------------------------------------------------------------

end A_E_P.Algo_Evolutionnaire_G;
