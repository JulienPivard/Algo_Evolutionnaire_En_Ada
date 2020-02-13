--  @summary
--  Définition d'intervalle de valeurs.
--  @description
--  Défini l'intervalle de valeurs de la population,
--  et celui des valeurs des variables de la fonction.
--  @group Population
package Intervalle_P
   with
      Pure           => True,
      Preelaborate   => False,
      Elaborate_Body => False,
      Spark_Mode     => Off
is

   type Indice_T is range 1 .. 25;
   --  L'intervalle de valeurs de la population.

end Intervalle_P;
