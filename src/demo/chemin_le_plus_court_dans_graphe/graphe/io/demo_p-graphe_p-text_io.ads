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

end Demo_P.Graphe_P.Text_IO;
