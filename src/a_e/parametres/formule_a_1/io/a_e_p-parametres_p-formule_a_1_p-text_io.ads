--  @summary
--  Affiche le contenu d'un paramètre.
--  @description
--  Affiche le contenu d'un paramètre.
--  @group Affichage
package A_E_P.Parametres_P.Formule_A_1_P.Text_IO
   with
      Pure           => False,
      Preelaborate   => False,
      Elaborate_Body => True,
      Spark_Mode     => Off
is

   procedure Put
      (Item : in Anonyme_T);

   procedure Afficher_Formule;

end A_E_P.Parametres_P.Formule_A_1_P.Text_IO;
