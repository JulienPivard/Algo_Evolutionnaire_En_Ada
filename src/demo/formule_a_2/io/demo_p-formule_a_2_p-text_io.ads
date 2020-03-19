--  @summary
--  Affiche le contenu des paramètres.
--  @description
--  Affiche le contenu des paramètres.
--  @group Affichage
package Demo_P.Formule_A_2_P.Text_IO
   with
      Pure           => False,
      Preelaborate   => False,
      Elaborate_Body => True,
      Spark_Mode     => Off
is

   procedure Put
      (Item : in Anonyme_T);
   --  Affiche le contenu des paramètre de la formule.
   --  @param Item
   --  Les paramètres.

   procedure Afficher_Formule;
   --  Affiche la formule associé aux paramètres.

end Demo_P.Formule_A_2_P.Text_IO;
