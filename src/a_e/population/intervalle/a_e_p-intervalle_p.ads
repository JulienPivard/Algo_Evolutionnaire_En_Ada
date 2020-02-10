--  @summary
--  Défini l'intervalle de valeurs de la population.
--  @description
--  Défini l'intervalle de valeurs de la population.
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

end A_E_P.Intervalle_P;