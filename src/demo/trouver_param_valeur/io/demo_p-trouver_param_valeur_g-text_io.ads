generic

--  @summary
--  Affiche le contenu des paramètres.
--  @description
--  Affiche le contenu des paramètres.
--  @group Affichage
package Demo_P.Trouver_Param_Valeur_G.Text_IO
   with
      Pure           => False,
      Preelaborate   => False,
      Elaborate_Body => False,
      Spark_Mode     => Off
is

   procedure Put_Parametres
      (Item : in     Anonyme_T);
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

   procedure Put
      (Item : in     V_Param_T);
   --  Affiche un paramètre.
   --  @param Item
   --  La valeur à afficher.

end Demo_P.Trouver_Param_Valeur_G.Text_IO;
