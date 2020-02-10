--  @summary
--  Générateur de nombre flottant aléatoire.
--  @description
--  Fourni une interface pour générer des nombres flottant
--  aléatoire compris entre deux bornes qui peuvent être
--  passé en paramètres lors de l'appel de la fonction.
--  @group Nombre aléatoire
package Generateur_P
   with
      Pure           => False,
      Preelaborate   => False,
      Elaborate_Body => False,
      Spark_Mode     => Off
is

   generic
      type Valeur_T is digits <>;
      --  Le type dont on veut générer une valeur aléatoirement.
   function Generer_Flottant
      (
         Borne_Inf : in Valeur_T := Valeur_T'First;
         Borne_Sup : in Valeur_T := Valeur_T'Last
      )
      return Valeur_T;
   --  Génère une valeur aléatoire comprise entre les bornes.
   --  @param Borne_Inf
   --  La borne inférieur de la valeur à générer.
   --  @param Borne_Sup
   --  La borne supérieur de la valeur à générer.
   --  @return La valeur aléatoire généré.

end Generateur_P;
