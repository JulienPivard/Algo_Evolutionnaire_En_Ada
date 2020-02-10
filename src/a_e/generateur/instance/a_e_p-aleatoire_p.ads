with A_E_P.Generateur_P;

pragma Elaborate_All (A_E_P.Generateur_P);

--  @summary
--  Instance de la fonction aléatoire.
--  @description
--  Instancie une fonction de génération de nombres flottant aléatoire.
--  @group Nombre aléatoire
package A_E_P.Aleatoire_P
   with
      Pure           => False,
      Preelaborate   => False,
      Elaborate_Body => False,
      Spark_Mode     => Off
is

   subtype Intervalle_Initial_T is V_Param_T range 0.0 .. 1100.0;

   function Generer is new A_E_P.Generateur_P.Generer_Flottant
      (Intervalle_Initial_T);

end A_E_P.Aleatoire_P;
