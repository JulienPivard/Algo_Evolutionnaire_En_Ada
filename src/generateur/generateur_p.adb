with Ada.Numerics.Float_Random;

package body Generateur_P
   with Spark_Mode => Off
is

   package Aleatoire_R renames Ada.Numerics.Float_Random;

   Generateur : Aleatoire_R.Generator;

   ---------------------------------------------------------------------------
   function Generer_Flottant
      (
         Borne_Inf : in Valeur_T := Valeur_T'First;
         Borne_Sup : in Valeur_T := Valeur_T'Last
      )
      return Valeur_T
   is
      Val_Aleatoire   : constant Valeur_T :=
         Valeur_T (Aleatoire_R.Random (Gen => Generateur));
   begin
      return Resultat : Valeur_T do
         Resultat :=
            (Borne_Sup - Borne_Inf)
            *
            Val_Aleatoire
            +
            Borne_Inf;
      end return;
   end Generer_Flottant;
   ---------------------------------------------------------------------------

begin

   Aleatoire_R.Reset (Gen => Generateur);

end Generateur_P;
