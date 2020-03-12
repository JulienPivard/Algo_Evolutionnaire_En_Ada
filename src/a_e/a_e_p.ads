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

   type Indice_Val_Interdites_T is range 1 .. 10;
   --  Il est possible d'interdire entre 1 et 10 valeurs
   --  pour chaque paramètre.
   type Valeurs_Interdites_T    is array
      (Indice_Val_Interdites_T range <>) of V_Param_T;
   --  Les valeurs de paramètres interdites.

   subtype Intervalle_Vide_T     is Indice_Val_Interdites_T range 2 .. 1;
   --  Aucunes valeurs interdites.
   subtype Val_Interdites_Vide_T is Valeurs_Interdites_T (Intervalle_Vide_T);
   --  Table de valeurs interdites vide.

   Valeurs_Interdites_Vide : constant Val_Interdites_Vide_T :=
      Val_Interdites_Vide_T'(others => 0.0);

end A_E_P;
