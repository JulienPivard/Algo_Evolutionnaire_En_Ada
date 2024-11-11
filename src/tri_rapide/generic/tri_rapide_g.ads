generic

   type Indice_G_T is (<>);
   --  Les indices du tableau à trier.

   type Element_G_T is limited private;
   --  Les éléments contenu dans le tableau à trier.

   type Table_G_T   is array (Indice_G_T range <>) of Element_G_T;
   --  Un tableau d'éléments à trier.

   with function Comparer_G
      (
         G : in     Element_G_T;
         D : in     Element_G_T
      )
      return Boolean;
   --  Compare les valeurs contenu dans les deux cases
   --  désignée du tableau.
   --  @param G
   --  L'élément à gauche dans la comparaison.
   --  @param D
   --  L'élément à droite dans la comparaison.
   --  @return Le résultat de la comparaison.

   with procedure Echanger_G
      (
         T  : in out Table_G_T;
         P1 : in     Indice_G_T;
         P2 : in     Indice_G_T
      );
   --  Échange les deux cases désigné dans le tableau.
   --  @param T
   --  Le tableau de valeurs.
   --  @param P1
   --  La position de la première valeur.
   --  @param P2
   --  La position de la deuxième valeur.

   with function Choisir_Pivot_G
      (
         Premier : in     Indice_G_T;
         Dernier : in     Indice_G_T
      )
      return Indice_G_T;
   --  Choisit la position de la valeur qui servira de pivot, les
   --  bornes de l'intervalle font partit des pivots possible.
   --  @param Premier
   --  La première valeur de l'intervalle de positions.
   --  @param Dernier
   --  La dernière valeur de l'intervalle de positions.
   --  @return La position du pivot.

--  @summary
--  Implémentation générique du tri rapide.
--  @description
--  Version la plus universel possible du tri rapide.
--  @group Tri
package Tri_Rapide_G
   with Spark_Mode => Off
is

   pragma Pure;

   procedure Tri_Rapide
      (Tableau : in out Table_G_T);
   --  Lance le tri rapide sur un tableau entier.
   --  @param Tableau
   --  Le tableau à trier.

private

   procedure Tri_Rapide
      (
         Tableau : in out Table_G_T;
         Premier : in     Indice_G_T;
         Dernier : in     Indice_G_T
      );
   --  Lance le tri rapide sur une portion de tableau.
   --  @param Tableau
   --  Le tableau à trier.
   --  @param Premier
   --  L'indice de la première case de l'intervalle à trier.
   --  @param Dernier
   --  L'indice de la dernière case de l'intervalle à trier.

   function Repartir_Valeurs
      (
         Tableau        : in out Table_G_T;
         Premier        : in     Indice_G_T;
         Dernier        : in     Indice_G_T;
         Position_Pivot : in     Indice_G_T
      )
      return Indice_G_T;
   --  Répartit les valeurs à gauche et à droite du pivot en
   --  fonction de l'ordre de comparaison donné.
   --  @param Tableau
   --  Le tableau à trier.
   --  @param Premier
   --  L'indice de la première case de l'intervalle à trier.
   --  @param Dernier
   --  L'indice de la dernière case de l'intervalle à trier.
   --  @param Position_Pivot
   --  La position du pivot.
   --  @return La position du pivot à la fin du tri.

end Tri_Rapide_G;
