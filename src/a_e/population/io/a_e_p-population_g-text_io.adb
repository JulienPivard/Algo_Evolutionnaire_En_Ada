with Ada.Text_IO;

package body A_E_P.Population_G.Text_IO
   with Spark_Mode => Off
is

   package Indice_IO is new Ada.Text_IO.Integer_IO
      (Num => Indice_Population_T);

   ---------------------------------------------------------------------------
   procedure Put_Line
      (Item : in Population_T)
   is
      I : Indice_Population_T := Indice_Population_T'First;
   begin
      if Taille_Population <= 50 then
         for E of Item.Table loop
            Indice_IO.Put      (Item => I, Width => 3);

            if I in Intervalle_Survivants_T then
               Ada.Text_IO.Put (Item => " S   ");
            elsif I in Intervalle_Mort_T then
               Ada.Text_IO.Put (Item => " Mort");
            end if;
            if I in Intervalle_Accouplements_T then
               Ada.Text_IO.Put (Item => " A  ");
            elsif I in Intervalle_Mutants_T then
               Ada.Text_IO.Put (Item => " Mut");
            else
               Ada.Text_IO.Put (Item => "    ");
            end if;

            Individu_IO.Put_Line (Item => E);

            if I < Indice_Population_T'Last then
               I := I + 1;
            end if;
         end loop;
      else
         Ada.Text_IO.Put (Item => "Minimum :");
         Individu_IO.Put_Line
            (Item => Item.Table (Item.Table'First));
      end if;
   end Put_Line;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   procedure Afficher_Details is
   begin
      Ada.Text_IO.Put      (Item    => "Population   : ");
      Indice_IO.Put        (Item    => Taille_Population);
      Ada.Text_IO.New_Line (Spacing => 1);
      Ada.Text_IO.Put      (Item    => "Survivants   : ");
      Indice_IO.Put        (Item    => Nb_Survivants);
      Ada.Text_IO.New_Line (Spacing => 1);
      Ada.Text_IO.Put      (Item    => "Morts        : ");
      Indice_IO.Put        (Item    => Nb_Morts);
      Ada.Text_IO.New_Line (Spacing => 1);
      Ada.Text_IO.Put      (Item    => "Future       : ");
      Indice_IO.Put        (Item    => Future_Nb_Enfants);
      Ada.Text_IO.New_Line (Spacing => 1);
      Ada.Text_IO.Put      (Item    => "Accouplement : ");
      Indice_IO.Put        (Item    => Nb_Accouplements);
      Ada.Text_IO.New_Line (Spacing => 1);
      Ada.Text_IO.Put      (Item    => "Mutants      : ");
      Indice_IO.Put        (Item    => Nb_Mutants);
      Ada.Text_IO.New_Line (Spacing => 1);
      Ada.Text_IO.Put      (Item    => "Tournois     : ");
      Indice_IO.Put        (Item    => Nb_Tournois);
      Ada.Text_IO.New_Line (Spacing => 1);
      Ada.Text_IO.Put      (Item    => "Participants : ");
      Indice_IO.Put        (Item    => Nb_Participants);
      Ada.Text_IO.New_Line (Spacing => 2);

      if Taille_Population <= 50 then
         Bloc_Affichage_Detaillee :
         declare
            ------------------------------------
            procedure Afficher_Table
               (Debut, Fin : in Indice_Population_T);

            ------------------------
            procedure Afficher_Table
               (Debut, Fin : in Indice_Population_T)
            is
               subtype Sous_Indice_T is Indice_Population_T range Debut .. Fin;
            begin
               for I in Indice_Population_T loop
                  if I in Sous_Indice_T then
                     Ada.Text_IO.Put (Item => "|");
                     Indice_IO.Put   (Item => I, Width => 2);
                  else
                     Ada.Text_IO.Put (Item => "|  ");
                  end if;
               end loop;
               Ada.Text_IO.Put_Line  (Item => "|");
            end Afficher_Table;
            ------------------------------------
         begin
            Ada.Text_IO.Put (Item => "Survivants      : ");
            Afficher_Table
               (
                  Debut => Intervalle_Survivants_T'First,
                  Fin   => Intervalle_Survivants_T'Last
               );

            Ada.Text_IO.Put (Item => "Tournois        : ");
            Afficher_Table
               (
                  Debut => Intervalle_Survivants_T'Last - Nb_Participants,
                  Fin   => Intervalle_Survivants_T'Last
               );

            Ada.Text_IO.Put (Item => "Naissance/Morts : ");
            Afficher_Table
               (
                  Debut => Intervalle_Naissance_T'First,
                  Fin   => Intervalle_Naissance_T'Last
               );

            Ada.Text_IO.Put (Item => "Accouplements   : ");
            Afficher_Table
               (
                  Debut => Intervalle_Accouplements_T'First,
                  Fin   => Intervalle_Accouplements_T'Last
               );

            Ada.Text_IO.Put (Item => "Mutants         : ");
            Afficher_Table
               (
                  Debut => Intervalle_Mutants_T'First,
                  Fin   => Intervalle_Mutants_T'Last
               );
         end Bloc_Affichage_Detaillee;
      else
         Bloc_Affichage_Stylise :
         declare
            type Indice_Tmp_T is range 1 .. 50;

            Nb_Survivants_IO     : constant Indice_Tmp_T :=
               100 - Indice_Tmp_T (Pop_A_Renouveler);
            --  Le nombre de survivants (environ 75%)
            Nb_Morts_IO          : constant Indice_Tmp_T :=
               100 - Nb_Survivants_IO;
            --  Le reste de la population que n'as pas survécu.
            Nb_Accouplements_IO  : constant Indice_Tmp_T :=
               Nb_Morts_IO / 2;
            --  Le nombre d'enfants par accouplement de deux valeur
            --  prises au hasard parmi les survivantes.
            Nb_Tournois_IO       : constant Indice_Tmp_T :=
               Indice_Tmp_T (Taille_Tournois);
            --  Nombre de tournois organisé.

            ------------------------------------
            procedure Afficher_Table
               (Debut, Fin : in Indice_Tmp_T);

            ------------------------
            procedure Afficher_Table
               (Debut, Fin : in Indice_Tmp_T)
            is
               subtype Sous_Indice_T is Indice_Tmp_T range Debut .. Fin;
            begin
               for I in Indice_Tmp_T loop
                  if (I mod 2) = 1 then
                     Ada.Text_IO.Put (Item => "|");
                  end if;
                  if I in Sous_Indice_T then
                     Ada.Text_IO.Put (Item => "##");
                  else
                     Ada.Text_IO.Put (Item => "  ");
                  end if;
               end loop;
               Ada.Text_IO.Put_Line  (Item => "|");
            end Afficher_Table;
            ------------------------------------
         begin
            Ada.Text_IO.Put (Item => "Survivants      : ");
            Afficher_Table  (Debut => 1, Fin => 38);

            Ada.Text_IO.Put (Item => "Tournois        : ");
            Afficher_Table (Debut => 31, Fin   => 38);

            Ada.Text_IO.Put (Item => "Naissance/Morts : ");
            Afficher_Table  (Debut => 39, Fin => 50);

            Ada.Text_IO.Put (Item => "Accouplements   : ");
            Afficher_Table  (Debut => 39, Fin => 44);

            Ada.Text_IO.Put (Item => "Mutants         : ");
            Afficher_Table  (Debut => 45, Fin => 50);
         end Bloc_Affichage_Stylise;
      end if;

      Ada.Text_IO.New_Line (Spacing => 1);
   end Afficher_Details;
   ---------------------------------------------------------------------------

end A_E_P.Population_G.Text_IO;
