with A_E_P.Parametres_P;

--  @summary
--  Interface de la formule à résoudre.
--  @description
--  Contient l'interface de la formule à faire
--  résoudre à l'algorithme évolutionnaire,
--  ainsi que des exemples de formules.
--  @group Formule
package A_E_P.Formule_P
   with
      Pure           => False,
      Preelaborate   => False,
      Elaborate_Body => True,
      Spark_Mode     => Off
is

   type Formule_T is not null access
      function
         (P : in Parametres_P.Parametres_T)
         return V_Calcule_T;
   --  Interface généraliste d'une fonction à résoudre.

   function Formule_Surface
      (P : in Parametres_P.Parametres_T)
      return V_Calcule_T;
   --  Calcul une surface en fonction du diamètre D donné.
   --  Convergera vers X = 5.9.
   --  @param D
   --  Le diamètre de la boite.
   --  @return La surface de la boite.

   function Formule_Anonyme
      (P : in Parametres_P.Parametres_T)
      return V_Calcule_T;
   --  Un autre calcul.
   --  Convergera vers X = 0.0.
   --  @param X
   --  La valeur de l'inconnue X.
   --  @return Le résultats de la formule en fonction de X.

   --  Deux inconnues
   --  Formule à ajouter : sin (x+y) + (x-y)^2 -1,5x + 2,5y + 1
   --  Convergence en :
   --   - x = -0,55
   --   - y = -1,55

end A_E_P.Formule_P;
