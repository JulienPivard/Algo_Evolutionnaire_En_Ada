--  @summary
--  Choix de la méthode de sélection du pivot.
--  @description
--  Fourni un moyen de contrôler la méthode utilisé
--  pour choisir le pivot lors du tri rapide.
--  @group Tri
package Sorte_De_Tri_P
   with
      Pure           => True,
      Preelaborate   => False,
      Elaborate_Body => False,
      Spark_Mode     => Off
is

   type Sorte_De_Tri_T is (Deterministe, Aleatoire);
   --  Détermine la façon dont le pivot sera choisi.
   --  @value Deterministe
   --  Choix de pivot déterministe.
   --  @value Aleatoire
   --  Choix de pivot aléatoirement dans l'intervalle.

end Sorte_De_Tri_P;
