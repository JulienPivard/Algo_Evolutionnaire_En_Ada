--  @summary
--  Affiche le contenu d'un paramètre.
--  @description
--  Affiche le contenu d'un paramètre.
--  @group Affichage
package Demo_P.Chemin_P.Evo_P.Text_IO
   with
      Pure           => False,
      Preelaborate   => False,
      Elaborate_Body => True,
      Spark_Mode     => Off
is

   procedure Put_Parametres
      (Item : in     Probleme_Chemin_T);
   --  Affiche le contenu des paramètre de la formule.
   --  @param Item
   --  Les paramètres.

   procedure Put_Resultat
      (Item : in     Resultat_T);
   --  Affiche le contenu des résultats de la formule.
   --  @param Item
   --  Les résultats.

   procedure Afficher_Formule;
   --  Affiche la formule associé aux paramètres.

private

end Demo_P.Chemin_P.Evo_P.Text_IO;
