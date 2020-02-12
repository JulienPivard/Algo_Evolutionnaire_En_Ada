--  @summary
--  Définition d'intervalle de valeurs.
--  @description
--  Défini l'intervalle de valeurs de la population,
--  et celui des valeurs des variables de la fonction.
--  @group Population
package A_E_P.Intervalle_P
   with
      Pure           => True,
      Preelaborate   => False,
      Elaborate_Body => False,
      Spark_Mode     => Off
is

   type Indice_T is range 1 .. 25;
   --  L'intervalle de valeurs de la population.

   subtype Intervalle_Initial_T is V_Param_T range 0.0 .. 1100.0;
   --  Permet de définir l'intervalle de valeurs dans lequel
   --  va évoluer la variable de la fonction.

end A_E_P.Intervalle_P;
