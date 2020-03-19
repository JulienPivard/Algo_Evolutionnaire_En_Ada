generic

   type Indice_G_T is (<>);
   --  Les indices du tableau à trier.

   type Element_G_T is limited private;
   --  Les éléments contenu dans le tableau à trier.

   type Table_G_T   is array (Indice_G_T range <>) of Element_G_T;
   --  Un tableau d'éléments à trier.

   with function Comparer
      (
         T              : in Table_G_T;
         Gauche, Droite : in Indice_G_T
      )
      return Boolean
   is <>;
   --  Compare les valeurs contenu dans les deux cases
   --  désignée du tableau.
   --  @param T
   --  Le tableau de valeurs.
   --  @param Gauche
   --  La position de la valeur qui sera à gauche dans la comparaison.
   --  @param Droite
   --  La position de la valeur qui sera à droite dans la comparaison.
   --  @return Le résultat de la comparaison.

   with procedure Echanger
      (
         T      : in out Table_G_T;
         P1, P2 : in     Indice_G_T
      );
   --  Échange les deux cases désigné dans le tableau.
   --  @param T
   --  Le tableau de valeurs.
   --  @param P1
   --  La position de la première valeur.
   --  @param P2
   --  La position de la deuxième valeur.

--  @summary
--  Implémentation générique du tri à bulle.
--  @description
--  Version la plus universel possible du tri à bulle.
--  Le tri se fait en partant de la fin du tableau.
--  @group Tri à bulle
package Tri_A_Bulle_G
   with
      Pure           => False,
      Preelaborate   => False,
      Elaborate_Body => False,
      Spark_Mode     => Off
is

   procedure Tri_A_Bulle
      (Tableau : in out Table_G_T);
   --  Tri un tableau à l'aide d'un tri à bulle.
   --  @param Tableau
   --  La population.

end Tri_A_Bulle_G;
