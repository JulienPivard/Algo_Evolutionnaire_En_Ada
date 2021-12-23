--  @summary
--  Affichage d'un graphe.
--  @description
--  Affichage d'un graphe.
--  @group Graphe
package Demo_P.Graphe_P.Text_IO
   with
      Pure           => False,
      Preelaborate   => False,
      Elaborate_Body => True,
      Spark_Mode     => Off
is

   procedure Put_Line
      (Item : in     Graphe_T);
   --  Affiche le graphe.
   --  @param Item
   --  Le graphe à afficher.

private

   procedure Tracer_Ligne_Encadrement;
   --  Trace une ligne horizontale de la bonne largeur
   --  pour l'encadrement du graphe.

   procedure Afficher_Sommets;
   --  Affiche tous les sommets sur une ligne

end Demo_P.Graphe_P.Text_IO;
