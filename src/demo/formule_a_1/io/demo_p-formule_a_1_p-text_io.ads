--  @summary
--  Affiche le contenu d'un paramètre.
--  @description
--  Affiche le contenu d'un paramètre.
--  @group Affichage
package Demo_P.Formule_A_1_P.Text_IO
   with
      Pure           => False,
      Preelaborate   => False,
      Elaborate_Body => True,
      Spark_Mode     => Off
is

   procedure Put_Parametres
      (Item : in Anonyme_T);
   --  Affiche le contenu des paramètre de la formule.
   --  @param Item
   --  Les paramètres.

   procedure Put_Resultat
      (Item : in Resultat_T);
   --  Affiche le contenu des résultats de la formule.
   --  @param Item
   --  Les résultats.

   procedure Afficher_Formule;
   --  Affiche la formule associé aux paramètres.

end Demo_P.Formule_A_1_P.Text_IO;
