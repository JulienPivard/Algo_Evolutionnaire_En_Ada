--  @summary
--  Algorithme Évolutionnaire.
--  @description
--  Un Algorithme Évolutionnaire utilise les principes de
--  la théorie de l'évolution pour trouver les valeurs des
--  variables d'une fonction qui vont minimiser/maximiser
--  le résultat de celle-ci. L'aléatoire y est utilisé de
--  plusieurs manière pour mimer les mécanismes de l'évolution.
--  @group Évolution
package A_E_P
   with
      Pure           => True,
      Preelaborate   => False,
      Elaborate_Body => False,
      Spark_Mode     => Off
is

   type Math_T      is digits 5;
   --  Les calculs seront tous fait avec un
   --  type de cette précision la.

   type V_Param_T   is new Math_T;
   --  Représentation des paramètres de la fonction à résoudre.
   type V_Calcule_T is new Math_T;
   --  Représentation du résultat de la fonction à résoudre.

end A_E_P;
