generic

   with procedure Put
      (Item : in     Valeur_Param_G_T);
   --  Formatage de l'affichage de la valeur.
   --  @param Item
   --  La valeur du paramètre à afficher.

   Afficher_Intervalle : Boolean := True;
   --  Affiche l'intervalle de valeurs lié.

--  @summary
--  Affiche une valeur.
--  @description
--  Affiche une valeur.
--  @group Affichage
package A_E_P.Valeur_Param_Flottant_G.Text_IO
   with Spark_Mode => Off
is

   pragma Elaborate_Body;

   procedure Put
      (Item : in     Valeur_Param_T);
   --  Affiche le contenu d'une valeur avec ses bornes.
   --  @param Item
   --  La valeur du paramètre à afficher.

end A_E_P.Valeur_Param_Flottant_G.Text_IO;
