with Ada.Text_IO;

package body A_E_P.Population_G.Text_IO
   with Spark_Mode => Off
is

   package V_Param_IO is new Ada.Text_IO.Float_IO
      (Num => A_E_P.V_Param_T);
   package V_Calcule_IO is new Ada.Text_IO.Float_IO
      (Num => A_E_P.V_Calcule_T);
   package Indice_IO    is new Ada.Text_IO.Integer_IO
      (Num => Indice_Population_T);

   ---------------------------------------------------------------------------
   procedure Put_Line
      (Item : in Population_T)
   is
      I : Indice_Population_T := Indice_Population_T'First;
   begin
      if Taille_Population <= 100 then
         for E of Item.Table loop
            Indice_IO.Put      (Item => I, Width => 3);

            if I in Intervalle_Survivants_T then
               Ada.Text_IO.Put (Item => " S   ");
            elsif I in Intervalle_Mort_T then
               Ada.Text_IO.Put (Item => " Mort");
            end if;
            if I in Intervalle_Enfant_Moyenne_T then
               Ada.Text_IO.Put (Item => " Moy");
            elsif I in Intervalle_Accouplements_T then
               Ada.Text_IO.Put (Item => " A  ");
            elsif I in Intervalle_Mutants_T then
               Ada.Text_IO.Put (Item => " Mut");
            else
               Ada.Text_IO.Put (Item => "    ");
            end if;

            Ada.Text_IO.Put    (Item => " | X : ");
            V_Param_IO.Put
               (
                  Item => A_E_P.Individu_P.Lire_Parametre (Individu => E),
                  Fore => 3,
                  Aft  => 3,
                  Exp  => 0
               );
            Ada.Text_IO.Put  (Item => " | Résultat : ");
            V_Calcule_IO.Put
               (
                  Item => A_E_P.Individu_P.Lire_Resultat (Individu => E),
                  Fore => 3,
                  Aft  => 3,
                  Exp  => 0
               );

            Ada.Text_IO.New_Line (Spacing => 1);
            if I < Indice_Population_T'Last then
               I := I + 1;
            end if;
         end loop;
      else
         Ada.Text_IO.Put (Item => "Minimum : ");
         Ada.Text_IO.Put (Item => " | X : ");
         V_Param_IO.Put
            (
               Item => A_E_P.Individu_P.Lire_Parametre
                  (Individu => Item.Table (Item.Table'First)),
               Fore => 3,
               Aft  => 3,
               Exp  => 0
            );
         Ada.Text_IO.Put (Item => " | Résultat : ");
         V_Calcule_IO.Put
            (
               Item => A_E_P.Individu_P.Lire_Resultat
                  (Individu => Item.Table (Item.Table'First)),
               Fore => 3,
               Aft  => 3,
               Exp  => 0
            );
         Ada.Text_IO.New_Line (Spacing => 1);

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

      if Taille_Population <= 50 then
         Ada.Text_IO.New_Line  (Spacing => 1);

         Ada.Text_IO.Put       (Item => "Survivants    : ");
         for I in Indice_Population_T loop
            if I in Intervalle_Survivants_T then
               Ada.Text_IO.Put (Item => "|");
               Indice_IO.Put   (Item => I, Width => 2);
            else
               Ada.Text_IO.Put (Item => "|  ");
            end if;
         end loop;
         Ada.Text_IO.Put_Line  (Item => "|");

         Ada.Text_IO.Put       (Item => "Morts         : ");
         for I in Indice_Population_T loop
            if I in Intervalle_Mort_T then
               Ada.Text_IO.Put (Item => "|");
               Indice_IO.Put   (Item => I, Width => 2);
            else
               Ada.Text_IO.Put (Item => "|  ");
            end if;
         end loop;
         Ada.Text_IO.Put_Line  (Item => "|");

         Ada.Text_IO.Put       (Item => "Naissance     : ");
         for I in Indice_Population_T loop
            if I in Intervalle_Naissance_T then
               Ada.Text_IO.Put (Item => "|");
               Indice_IO.Put   (Item => I, Width => 2);
            else
               Ada.Text_IO.Put (Item => "|  ");
            end if;
         end loop;
         Ada.Text_IO.Put_Line  (Item => "|");

         Ada.Text_IO.Put       (Item => "Enfant moyen  : ");
         for I in Indice_Population_T loop
            if I in Intervalle_Enfant_Moyenne_T then
               Ada.Text_IO.Put (Item => "|");
               Indice_IO.Put   (Item => I, Width => 2);
            else
               Ada.Text_IO.Put (Item => "|  ");
            end if;
         end loop;
         Ada.Text_IO.Put_Line  (Item => "|");

         Ada.Text_IO.Put       (Item => "Accouplements : ");
         for I in Indice_Population_T loop
            if I in Intervalle_Accouplements_T then
               Ada.Text_IO.Put (Item => "|");
               Indice_IO.Put   (Item => I, Width => 2);
            else
               Ada.Text_IO.Put (Item => "|  ");
            end if;
         end loop;
         Ada.Text_IO.Put_Line  (Item => "|");

         Ada.Text_IO.Put       (Item => "Mutants       : ");
         for I in Indice_Population_T loop
            if I in Intervalle_Mutants_T then
               Ada.Text_IO.Put (Item => "|");
               Indice_IO.Put   (Item => I, Width => 2);
            else
               Ada.Text_IO.Put (Item => "|  ");
            end if;
         end loop;
         Ada.Text_IO.Put_Line  (Item => "|");
      end if;

      Ada.Text_IO.New_Line (Spacing => 1);
   end Afficher_Details;
   ---------------------------------------------------------------------------

end A_E_P.Population_G.Text_IO;
