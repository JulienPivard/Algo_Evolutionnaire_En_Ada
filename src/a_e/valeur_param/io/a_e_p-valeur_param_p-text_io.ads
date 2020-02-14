--  @summary
--  Affiche une valeur.
--  @description
--  Affiche une valeur.
--  @group Affichage
package A_E_P.Valeur_Param_P.Text_IO
   with
      Pure           => False,
      Preelaborate   => False,
      Elaborate_Body => True,
      Spark_Mode     => Off
is

   procedure Put
      (Item : in Valeur_Param_T);

end A_E_P.Valeur_Param_P.Text_IO;
