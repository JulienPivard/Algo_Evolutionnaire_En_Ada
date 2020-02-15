generic

   with procedure Put
      (Item : in Parametres_G_T);
   --  Procédure d'affichage du contenu des paramètres.
   --  @param Item
   --  Les paramètres.

--  @summary
--  Affichage d'un individu.
--  @description
--  Affichage détaillé d'un individu.
--  @group Affichage Individu
package A_E_P.Individu_G.Text_IO
   with
      Pure           => False,
      Preelaborate   => False,
      Elaborate_Body => False,
      Spark_Mode     => Off
is

   procedure Put_Line
      (Item : in Individu_T);
   --  Affiche un Individu.
   --  @param Item
   --  L'individu.

end A_E_P.Individu_G.Text_IO;
