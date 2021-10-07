with Ada.Text_IO;

with Demo_P.Graphe_P.Text_IO;

package body Demo_P.Chemin_P.Evo_P.Text_IO
   with Spark_Mode => Off
is

   ---------------------------------------------------------------------------
   procedure Put_Parametres
      (Item : in     Probleme_Chemin_T)
   is
   begin
      Boucle_Afficher_Chemin :
      for S of Item.Chemin.Sommets loop
         Ada.Text_IO.Put (Item => " " & S'Img);
      end loop Boucle_Afficher_Chemin;
   end Put_Parametres;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   procedure Put_Resultat
      (Item : in     Resultat_T)
   is
   begin
      Ada.Text_IO.Put_Line (Item => "Score : " & Item.Score'Img);
   end Put_Resultat;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   procedure Afficher_Formule is
   begin
      Graphe_P.Text_IO.Put_Line (Item => Graphe);
   end Afficher_Formule;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   --                             Partie privée                             --
   ---------------------------------------------------------------------------

end Demo_P.Chemin_P.Evo_P.Text_IO;
