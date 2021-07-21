generic
   type Valeur_G_T is digits <>;
   --  Le type dont on veut générer une valeur aléatoirement.

--  @summary
--  Générateur de nombre flottant aléatoire.
--  @description
--  Fourni une interface pour générer des nombres flottant
--  aléatoire compris entre deux bornes qui peuvent être
--  passé en paramètres lors de l'appel de la fonction.
--  @group Nombre aléatoire
package Generateur_Flottant_G
   with Spark_Mode => Off
is

   pragma Elaborate_Body;

   function Generer_Flottant
      (
         Borne_Inferieur : in     Valeur_G_T;
         Borne_Superieur : in     Valeur_G_T
      )
      return Valeur_G_T;
   --  Génère une valeur aléatoire comprise entre les bornes.
   --  @param Borne_Inferieur
   --  La borne inférieur de la valeur à générer.
   --  @param Borne_Superieur
   --  La borne supérieur de la valeur à générer.
   --  @return La valeur aléatoire généré.

end Generateur_Flottant_G;
