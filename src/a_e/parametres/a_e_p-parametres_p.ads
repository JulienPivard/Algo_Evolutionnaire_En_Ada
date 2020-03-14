--  @summary
--  Gestion des paramètres d'une fonction.
--  @description
--  Permet de gérer les paramètres multiple d'une
--  fonction.
--  @group Formule
package A_E_P.Parametres_P
   with
      Pure           => True,
      Preelaborate   => False,
      Elaborate_Body => False,
      Spark_Mode     => Off
is

   type Parametres_T is interface;
   --  Regroupe les valeurs des variables d'une fonction.

   procedure Generer
      (Parametres : in out Parametres_T)
   is abstract;
   --  Génère des valeurs aléatoires pour les paramètres stocké.
   --  @param Parametres
   --  Les paramètres.

   function Accoupler
      (
         Parametres : in Parametres_T;
         Autre      : in Parametres_T
      )
      return Parametres_T
   is abstract;
   --  Accouple deux paramètres pour obtenir un nouveau
   --  jeu de paramètres.
   --  @param Parametres
   --  Les paramètres, premier parent.
   --  @param Autre
   --  Les paramètres, second parent.
   --  @return Le jeu de paramètres issus de la combinaison des parents.

   function Calculer
      (Parametres : in Parametres_T)
      return V_Calcule_T
   is abstract;
   --  Calcul la formule en utilisant les valeurs de ses
   --  paramètres comme entrées de la fonction de la formule.
   --  @param Parametres
   --  Les paramètres de la fonction.

end A_E_P.Parametres_P;
