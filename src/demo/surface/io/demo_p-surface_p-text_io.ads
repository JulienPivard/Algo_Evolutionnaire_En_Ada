--  @summary
--  Affiche le contenu d'un paramètre.
--  @description
--  Affiche le contenu d'un paramètre.
--  @group Affichage
package Demo_P.Surface_P.Text_IO
   with
      Pure           => False,
      Preelaborate   => False,
      Elaborate_Body => True,
      Spark_Mode     => Off
is

   procedure Put
      (Item : in Surface_T);

   procedure Afficher_Formule;

end Demo_P.Surface_P.Text_IO;
