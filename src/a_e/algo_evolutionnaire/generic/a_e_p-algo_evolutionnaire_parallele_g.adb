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
   begin
      NB_Generations := Natural'First;
      Debut          := Ada.Real_Time.Clock;

      Outils_P.Initialiser (Population => Population.Pop);

      for E of Table_De_Demarreurs loop
         E.Demarrer (Population => Population);
      end loop;

      Controleur_Fin.Attendre_Fin
         (
            Population     => Population,
            NB_Generations => NB_Generations
         );

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

   ---------------------------------------------------------------------------
   protected body Demarreur_T is
      --------------
      entry Attendre
         (Population :    out Population_T)
         when Demarrage_Autorise
      is
      begin
         Demarrage_Autorise := False;
         Population         := Pop_Local;
      end Attendre;
      --------------

      --------------
      procedure Demarrer
         (Population : in     Population_T)
      is
      begin
         Demarrage_Autorise := True;
         Pop_Local          := Population;
      end Demarrer;
      --------------
   end Demarreur_T;
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

      --------------
      procedure Signaler_Fin_Evolution is
      begin
         Echange_Autorise := True;
      end Signaler_Fin_Evolution;
      --------------
   end Transfert_T;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   protected body Controleur_Fin is
      ------------------
      entry Attendre_Fin
         (
            Population     :    out Population_T;
            NB_Generations :    out Natural
         )
         when Evolution_Est_Finie
      is
      begin
         Population     := Population_Local;
         NB_Generations := NB_Generations_Local;
      end Attendre_Fin;
      ------------------

      ------------------
      procedure Signaler_Fin_Evolution
         (
            ID             : in     ID_Islot_T;
            Population     : in     Population_T;
            NB_Generations : in     Natural
         )
      is
      begin
         ID_Tasche_Finie      := ID;
         Population_Local     := Population;
         NB_Generations_Local := NB_Generations;
         Evolution_Est_Finie  := True;

         Boucle_Signaler_Fin_Evolution :
         for E of Tables_De_Transfert loop
            E.Signaler_Fin_Evolution;
         end loop Boucle_Signaler_Fin_Evolution;
      end Signaler_Fin_Evolution;
      ------------------

      ------------------
      function Un_Islot_A_Fini_D_Evoluer
         return Boolean
      is
      begin
         return Evolution_Est_Finie;
      end Un_Islot_A_Fini_D_Evoluer;
      ------------------
   end Controleur_Fin;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   task body Islot_T is
      Demarreur  : Demarreur_T renames Table_De_Demarreurs (ID);
      Sortie     : Transfert_T renames Tables_De_Transfert (ID + 1);
      Entree     : Transfert_T renames Tables_De_Transfert (ID);

      NB_Generations : Natural;
      Migrants       : Outils_P.Migrants_T;
      Resultats      : Outils_P.Resultat_Tournois_T;
      Population     : Population_T;

      NB_Tours_Sans_Divergences  : Outils_P.NB_Tours_Sans_Divergences_T  :=
         Outils_P.NB_Tours_Sans_Divergences_T'First;
      NB_Tours_Sans_Amelioration : Outils_P.NB_Tours_Sans_Amelioration_T :=
         Outils_P.NB_Tours_Sans_Amelioration_T'First;

      Evolution_Est_Finie : Boolean;
   begin
      Demarreur.Attendre (Population => Population);

      NB_Generations := Natural'First;

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

         if (NB_Generations mod 25) = 0 then
            Outils_P.Selectionner_Migrants
               (
                  Population => Population.Pop,
                  Migrants   => Migrants,
                  Resultats  => Resultats
               );
            Sortie.Envoyer  (Population => Migrants);
            Entree.Attendre (Population => Migrants);

            exit Boucle_Generation_Successive when
               Controleur_Fin.Un_Islot_A_Fini_D_Evoluer;

            Outils_P.Accueillir_Migrants
               (
                  Population => Population.Pop,
                  Migrants   => Migrants,
                  Resultats  => Resultats
               );
         end if;
      end loop Boucle_Generation_Successive;

      if not Controleur_Fin.Un_Islot_A_Fini_D_Evoluer then
         Controleur_Fin.Signaler_Fin_Evolution
            (
               ID             => ID,
               Population     => Population,
               NB_Generations => NB_Generations
            );
      end if;
   end Islot_T;
   ---------------------------------------------------------------------------

end A_E_P.Algo_Evolutionnaire_G;
