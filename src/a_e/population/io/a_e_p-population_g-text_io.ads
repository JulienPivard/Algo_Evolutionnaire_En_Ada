with A_E_P.Individu_G.Text_IO;

generic
   with package Individu_G_IO is new Individu_G_P.Text_IO (<>);

--  @summary
--  Affichage de la population.
--  @description
--  Affichage détaillé de la population.
--  @group Affichage population
package A_E_P.Population_G.Text_IO
   with Spark_Mode => Off
is

   pragma Elaborate_Body;

   procedure Put_Line
      (Item : in     Population_T);
   --  Affiche le contenu d'un tableau de valeurs.
   --  @param Item
   --  La population à afficher.

   procedure Afficher_Details;
   --  Affiche la répartition détaillé des populations,
   --  des morts, des naissances et des mutants.

end A_E_P.Population_G.Text_IO;
