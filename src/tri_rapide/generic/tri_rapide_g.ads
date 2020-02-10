with Sorte_De_Tri_P;

generic

   type Indice_G_T is (<>);
   --  Les indices du tableau à trier.

   type Element_G_T is limited private;
   --  Les éléments contenu dans le tableau à trier.

   type Table_G_T   is array (Indice_G_T range <>) of Element_G_T;
   --  Un tableau d'éléments à trier.

   Sorte_De_Tri : Sorte_De_Tri_P.Sorte_De_Tri_T :=
      Sorte_De_Tri_P.Deterministe;
   --  Permet de spécifier la méthode de sélection
   --  du pivot.
   --   - Soit déterministe : la valeur dans la
   --       première case du tableau deviens pivot;
   --   - soit aléatoire    : Une case est choisie
   --       au hasard dans le tableau.

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
--  Implémentation générique du tri rapide.
--  @description
--  Version la plus universel possible du tri rapide
--  @group Tri rapide
package Tri_Rapide_G
   with
      Pure           => False,
      Preelaborate   => False,
      Elaborate_Body => False,
      Spark_Mode     => Off
is

   procedure Tri_Rapide
      (Tableau : in out Table_G_T);
   --  Lance le tri rapide sur un tableau entier.
   --  @param Tableau
   --  Le tableau à trier.

private

   procedure Tri_Rapide
      (
         Tableau          : in out Table_G_T;
         Premier, Dernier : in     Indice_G_T
      );
   --  Lance le tri rapide sur une portion de tableau.
   --  @param Tableau
   --  Le tableau à trier.
   --  @param Premier
   --  L'indice de la première case de l'intervalle à trier.
   --  @param Dernier
   --  L'indice de la dernière case de l'intervalle à trier.

   function Choisir_Pivot_Deterministe
      (Premier, Dernier : in Indice_G_T)
      return Indice_G_T;
   --  Choisi la position du pivot dans l'intervalle donné.
   --  Le choix est fait de façon <strong>déterministe</strong>.
   --  @param Premier
   --  L'indice de la première case de l'intervalle.
   --  @param Dernier
   --  L'indice de la dernière case de l'intervalle.
   --  @return La position du pivot.

   function Choisir_Pivot_Aleatoire
      (Premier, Dernier : in Indice_G_T)
      return Indice_G_T;
   --  Choisi la position du pivot dans l'intervalle donné.
   --  Une valeur est choisie <strong>aléatoirement</strong>
   --  dans l'intervalle.
   --  @param Premier
   --  L'indice de la première case de l'intervalle.
   --  @param Dernier
   --  L'indice de la dernière case de l'intervalle.
   --  @return La position du pivot.

   function Repartir_Valeurs
      (
         Tableau          : in out Table_G_T;
         Premier, Dernier : in     Indice_G_T;
         Position_Pivot   : in     Indice_G_T
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
