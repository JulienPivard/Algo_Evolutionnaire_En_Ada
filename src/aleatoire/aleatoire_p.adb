with Ada.Numerics.Float_Random;

package body Aleatoire_P
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
      type F_Tmp_T is digits 10;

      Borne_Inferieur : constant F_Tmp_T := F_Tmp_T (Borne_Inf);
      Borne_Superieur : constant F_Tmp_T := F_Tmp_T (Borne_Sup);
      Val_Aleatoire   : constant F_Tmp_T :=
         F_Tmp_T (Aleatoire_R.Random (Gen => Generateur));

      Resultat : F_Tmp_T;
   begin
      Resultat :=
         (Borne_Superieur - Borne_Inferieur)
         *
         Val_Aleatoire
         +
         Borne_Inferieur;
      return Valeur_T (Resultat);
   end Generer_Flottant;
   ---------------------------------------------------------------------------

begin

   Aleatoire_R.Reset (Gen => Generateur);

end Aleatoire_P;
