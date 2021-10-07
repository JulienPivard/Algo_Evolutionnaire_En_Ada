with A_E_P;
pragma Unreferenced (A_E_P);

--  @summary
--  Une petite collection de demos.
--  @description
--  Les démonstration d'utilisation sont regroupée sous ce package.
--  @group Demos
package Demo_P
   with
      Pure           => True,
      Preelaborate   => False,
      Elaborate_Body => False,
      Spark_Mode     => Off
is

   type Sommets_T is (A, B, C, D, E, F, G, H, I, J, K);
   --  Les sommets d'un graphe.

   type Score_T is range 0 .. 10_000;
   --  Le score d'un chemin. Plus il est faible, mieux c'est.

   type Math_T is digits 5;
   --  Les calculs seront tous fait avec un
   --  type de cette précision la.

   type V_Param_T   is new Math_T;
   --  Représentation des paramètres de la fonction à résoudre.
   type V_Calcule_T is new Math_T;
   --  Représentation du résultat de la fonction à résoudre.

   Taille : constant := 250;
   --  La taille de la population.

end Demo_P;
