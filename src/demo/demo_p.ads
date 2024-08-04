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

   type Sommet_T is
      (
         A, B, C, D, E, F, G, H, I, J, K, L, M,
         N, O, P, Q, R, S, T, U, V, W, X, Y, Z
      );
   --  Les sommets d'un graphe.
   --  @value A
   --  Un sommet unique.
   --  @value B
   --  Un sommet unique.
   --  @value C
   --  Un sommet unique.
   --  @value D
   --  Un sommet unique.
   --  @value E
   --  Un sommet unique.
   --  @value F
   --  Un sommet unique.
   --  @value G
   --  Un sommet unique.
   --  @value H
   --  Un sommet unique.
   --  @value I
   --  Un sommet unique.
   --  @value J
   --  Un sommet unique.
   --  @value K
   --  Un sommet unique.
   --  @value L
   --  Un sommet unique.
   --  @value M
   --  Un sommet unique.
   --  @value N
   --  Un sommet unique.
   --  @value O
   --  Un sommet unique.
   --  @value P
   --  Un sommet unique.
   --  @value Q
   --  Un sommet unique.
   --  @value R
   --  Un sommet unique.
   --  @value S
   --  Un sommet unique.
   --  @value T
   --  Un sommet unique.
   --  @value U
   --  Un sommet unique.
   --  @value V
   --  Un sommet unique.
   --  @value W
   --  Un sommet unique.
   --  @value X
   --  Un sommet unique.
   --  @value Y
   --  Un sommet unique.
   --  @value Z
   --  Un sommet unique.

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
