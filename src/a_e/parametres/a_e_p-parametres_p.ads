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

   type Valeur_T is
      record
         Valeur           : V_Param_T := 0.0;
         --  La valeur du paramètre.
         Debut_Intervalle : V_Param_T := 0.0;
         --  Le début de l'intervalle de valeurs.
         Fin_Intervalle   : V_Param_T := 1100.0;
         --  La fin de l'intervalle de valeurs.
      end record;
   --  Chaque paramètre est composé d'une valeur, et de son
   --  intervalle de valeurs autorisé.

   procedure Generer
      (Valeur : in out Valeur_T);

   function Accoupler
      (
         Valeur : in Valeur_T;
         Autre  : in Valeur_T
      )
      return Valeur_T;

   type Parametres_T is
      record
         Param_1 : Valeur_T;
         --  L'unique paramètre (Pour le moment)
      end record;

end A_E_P.Parametres_P;
