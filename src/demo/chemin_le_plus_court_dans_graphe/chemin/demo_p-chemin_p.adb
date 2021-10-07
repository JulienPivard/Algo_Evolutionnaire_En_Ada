package body Demo_P.Chemin_P
   with Spark_Mode => Off
is

   ---------------------------------------------------------------------------
   procedure Ajouter
      (
         Chemin           : in out Chemin_T;
         Sommet           : in     Sommets_T;
         Ajout_Est_Reussi :    out Boolean
      )
   is
   begin
      if Chemin.Nb_Sommets = 0 then
         Ajout_Est_Reussi := True;
         Chemin.Pos_Fin := Position_T'First;
      elsif Chemin.Pos_Fin = Position_T'Last then
         Ajout_Est_Reussi := False;
      elsif Chemin.Sommet_Est_Present (Sommet => Sommet) then
         Ajout_Est_Reussi := False;
      else
         Ajout_Est_Reussi := True;
         Chemin.Pos_Fin := Position_T'Succ (Chemin.Pos_Fin);
      end if;

      if Ajout_Est_Reussi then
         Chemin.Sommets (Chemin.Pos_Fin) := Sommet;
         Chemin.Nb_Sommets := Chemin.Nb_Sommets + 1;
      end if;
   end Ajouter;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   function Est_Valide
      (
         Chemin : in     Chemin_T;
         Graphe : in     Graphe_P.Graphe_T
      )
      return Boolean
   is
      P : Position_T := Position_T'First;

      Chemin_Est_Ok : Boolean := False;
      Est_Fini      : Boolean := False;
   begin
      if Sommets_Sont_Uniques (Chemin => Chemin) then
      Boucle_Verifier_Chemin :
      loop
         Chemin_Est_Ok := Graphe.Sont_Adjacents
            (
               X => Chemin.Sommets (P),
               Y => Chemin.Sommets (Position_T'Succ (P))
            );
         P := Position_T'Succ (P);

         Est_Fini := P = Position_T'Last;
         exit Boucle_Verifier_Chemin when Est_Fini or else not Chemin_Est_Ok;
      end loop Boucle_Verifier_Chemin;
      else
         Chemin_Est_Ok := False;
      end if;

      return Chemin_Est_Ok;
   end Est_Valide;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   function Calculer_Score
      (
         Chemin : in     Chemin_T;
         Graphe : in     Graphe_P.Graphe_T
      )
      return Score_T
   is
      Debut : constant Position_T := Position_T'Succ (Position_T'First);

      subtype Parcours_T is Position_T range Debut .. Position_T'Last;

      Position_Actuelle : Sommets_T := Chemin.Sommets (Position_T'First);
      Poids : Graphe_P.Poids_Areste_T;
      Score : Score_T := Score_T'First;
   begin
      Boucle_Parcours_Chemin :
      for S of Chemin.Sommets (Parcours_T) loop
         Poids := Graphe.Lire_Valeur_Areste
            (
               X => Position_Actuelle,
               Y => S
            );
         Score := Score + Score_T (Poids);

         Position_Actuelle := S;
      end loop Boucle_Parcours_Chemin;

      return Score;
   end Calculer_Score;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   function Sommets_Sont_Uniques
      (Chemin : in     Chemin_T)
      return Boolean
   is
      type Apparition_Sommets_T is array (Sommets_T) of Boolean;

      Apparition_Sommets : Apparition_Sommets_T :=
         Apparition_Sommets_T'(others => False);

         Sont_Uniques : Boolean := True;
   begin
      Boucle_Verifier_Chemin :
      for S of Chemin.Sommets loop
         if Apparition_Sommets (S) then
            Sont_Uniques := False;
         end if;
         Apparition_Sommets (S) := True;
      end loop Boucle_Verifier_Chemin;

      return Sont_Uniques;
   end Sommets_Sont_Uniques;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   function Sommet_Est_Present
      (
         Chemin : in     Chemin_T;
         Sommet : in     Sommets_T
      )
      return Boolean
   is
      subtype Indice_T is Position_T range Position_T'First .. Chemin.Pos_Fin;
   begin
      return (for all S of Chemin.Sommets (Indice_T) => S /= Sommet);
   end Sommet_Est_Present;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   --                             Partie privée                             --
   ---------------------------------------------------------------------------

end Demo_P.Chemin_P;
