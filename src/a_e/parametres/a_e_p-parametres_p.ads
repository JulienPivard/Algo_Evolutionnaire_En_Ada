with A_E_P.Formule_P;
with A_E_P.Valeur_Param_P;

--  @summary
--  Gestion des paramètres d'une fonction.
--  @description
--  Permet de gérer les paramètres multiple d'une
--  fonction.
--  @group Formule
package A_E_P.Parametres_P
   with
      Pure           => False,
      Preelaborate   => False,
      Elaborate_Body => True,
      Spark_Mode     => Off
is

   type Parametres_T is private;
   --  Regroupe les valeurs des variables d'une fonction.

   procedure Generer
      (Parametres : in out Parametres_T);
   --  Génère des valeurs aléatoires pour les paramètres stocké.
   --  @param Parametres
   --  Les paramètres.

   function Accoupler
      (
         Parametres : in Parametres_T;
         Autre      : in Parametres_T
      )
      return Parametres_T;
   --  Accouple deux paramètres pour obtenir un nouveau
   --  jeu de paramètres.
   --  @param Parametres
   --  Les paramètres, premier parent.
   --  @param Autre
   --  Les paramètres, second parent.
   --  @return Le jeu de paramètres issus de la combinaison des parents.

   function Calculer
      (
         Parametres : in Parametres_T;
         Formule    : in A_E_P.Formule_P.Formule_T
      )
      return V_Calcule_T;
   --  Utilise une formule et lui applique les paramètres
   --  pour résoudre l'équation.
   --  @param Parametres
   --  Les paramètres.
   --  @param Formule
   --  La formule à résoudre.

   procedure Modifier_Parametre
      (
         Parametres  : in out Parametres_T;
         Valeur      : in     V_Param_T
      );
   --  Modifie la valeur d'un paramètre.
   --  @param Parametres
   --  Les paramètres.
   --  @param Valeur
   --  La nouvelle valeur du paramètre à modifier.

   function Lire_Parametre
      (Parametres : in Parametres_T)
      return V_Param_T;
   --  Lit la valeur d'un paramètre.
   --  @param Parametres
   --  Les paramètres.
   --  @return La valeur du paramètre demandé.

private

   type Parametres_T is
      record
         Param_1 : A_E_P.Valeur_Param_P.Valeur_Param_T;
         --  L'unique paramètre (Pour le moment)
      end record;

end A_E_P.Parametres_P;
