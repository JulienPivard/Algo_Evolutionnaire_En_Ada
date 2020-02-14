with Ada.Numerics.Float_Random;

package body Generateur_G
   with Spark_Mode => Off
is

   package Aleatoire_R renames Ada.Numerics.Float_Random;

   Generateur : Aleatoire_R.Generator;

   ---------------------------------------------------------------------------
   function Generer_Flottant
      (
         Borne_Inferieur : in Valeur_T;
         Borne_Superieur : in Valeur_T
      )
      return Valeur_T
   is
      Val_Aleatoire : constant Valeur_T :=
         Valeur_T (Aleatoire_R.Random (Gen => Generateur));
   begin
      --  Le calcul :
      --       12.05 - (-12.05) = 24.1
      --       24.1 * 0.25      = 6.025
      --  Donne le même résultat que :
      --        12.05 * 0.25      =  3.0125
      --       -12.05 * 0.25      = -3.0125
      --       3.0125 - (-3.0125) = 6.025
      --  Le but est d'éviter les dépassements de valeurs max et min
      --  que le calcul Borne_Sup - Borne_Inf pouvait causer.
      return Resultat : Valeur_T do
         Resultat :=
            (Borne_Superieur * Val_Aleatoire)
            -
            (Borne_Inferieur * Val_Aleatoire)
            +
            Borne_Inferieur;
      end return;
   end Generer_Flottant;
   ---------------------------------------------------------------------------

begin

   Aleatoire_R.Reset (Gen => Generateur);

end Generateur_G;
