with Ada.Strings.Fixed;
with Ada.Text_IO;

package body Demo_P.Graphe_P.Text_IO
   with Spark_Mode => Off
is

   package Sommet_IO is new Ada.Text_IO.Enumeration_IO (Enum => Sommets_T);

   ---------------------------------------------------------------------------
   procedure Put_Line
      (Item : in     Graphe_T)
   is
      Val_Arreste : String := " ";
   begin
      Ada.Text_IO.New_Line (Spacing => 1);
      Ada.Text_IO.Put (Item => "    ");

      Boucle_Afficher_Ligne :
      for S_L in Sommets_T loop
         Sommet_IO.Put   (Item => S_L);
         Ada.Text_IO.Put (Item => " ");
      end loop Boucle_Afficher_Ligne;
      Ada.Text_IO.New_Line (Spacing => 1);

      Tracer_Ligne_Encadrement;

      Boucle_Parcourir_Ligne :
      for S_L in Sommets_T loop
         Sommet_IO.Put   (Item => S_L);
         Ada.Text_IO.Put (Item => " | ");

         Boucle_Parcourir_Colonne :
         for S_C in Sommets_T loop
            if Item.Sont_Adjacents (X => S_L, Y => S_C) then
               Val_Arreste := Ada.Strings.Fixed.Trim
                  (
                     Source => Poids_Areste_T'Image
                        (Item.Lire_Valeur_Areste (X => S_L, Y => S_C)),
                     Side   => Ada.Strings.Both
                  );
               Ada.Text_IO.Put (Item => Val_Arreste & " ");
            else
               Ada.Text_IO.Put (Item => "- ");
            end if;
         end loop Boucle_Parcourir_Colonne;

         Ada.Text_IO.Put (Item => "| ");
         Sommet_IO.Put   (Item => S_L);
         Ada.Text_IO.New_Line (Spacing => 1);
      end loop Boucle_Parcourir_Ligne;

      Tracer_Ligne_Encadrement;

      Ada.Text_IO.Put (Item => "    ");
      Boucle_Afficher_Ligne_Fin :
      for S_L in Sommets_T loop
         Sommet_IO.Put   (Item => S_L);
         Ada.Text_IO.Put (Item => " ");
      end loop Boucle_Afficher_Ligne_Fin;
      Ada.Text_IO.New_Line (Spacing => 1);
   end Put_Line;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   --                             Partie privée                             --
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   procedure Tracer_Ligne_Encadrement is
   begin
      Ada.Text_IO.Put (Item => "  +-");

      Boucle_Separateur_Haut :
      for S_L in Sommets_T loop
         Ada.Text_IO.Put (Item => "--");
      end loop Boucle_Separateur_Haut;

      Ada.Text_IO.Put (Item => "+");
      Ada.Text_IO.New_Line (Spacing => 1);
   end Tracer_Ligne_Encadrement;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   procedure Afficher_Sommets is
   begin
      Ada.Text_IO.Put (Item => "    ");

      Boucle_Afficher_Ligne :
      for S_L in Sommets_T loop
         Sommet_IO.Put   (Item => S_L);
         Ada.Text_IO.Put (Item => " ");
      end loop Boucle_Afficher_Ligne;

      Ada.Text_IO.New_Line (Spacing => 1);
   end Afficher_Sommets;
   ---------------------------------------------------------------------------

end Demo_P.Graphe_P.Text_IO;
