generic

--  @summary
--  Affiche une valeur.
--  @description
--  Affiche une valeur.
--  @group Affichage
package A_E_P.Valeur_Param_G.Text_IO
   with
      Pure           => False,
      Preelaborate   => False,
      Elaborate_Body => False,
      Spark_Mode     => Off
is

   procedure Put
      (Item : in Valeur_Param_T);

end A_E_P.Valeur_Param_G.Text_IO;
