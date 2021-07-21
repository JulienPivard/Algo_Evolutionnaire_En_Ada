generic
   type Valeur_Param_G_T is digits <>;
   --  Permet de spécifier la précision d'un paramètre.

   Debut_Intervalle : Valeur_Param_G_T;
   --  Le début de l'intervalle de valeurs.
   Fin_Intervalle   : Valeur_Param_G_T;
   --  La fin de l'intervalle de valeurs.

--  @summary
--  Une valeur de paramètre.
--  @description
--  Stock la valeur d'un paramètre, ainsi que
--  l'intervalle de valeurs dans lequel elle
--  est valide, ou a un sens.
--  @group Parametres
package A_E_P.Valeur_Param_Flottant_G
   with Spark_Mode => Off
is

   pragma Elaborate_Body;

   Borne_Inf_Min : constant := 0.0;
   Borne_Sup_Min : constant := 1.0;

   pragma Compile_Time_Error
      (
         Valeur_Param_G_T'First > Borne_Inf_Min
         or else
         Valeur_Param_G_T'Last  < Borne_Sup_Min,
         "Erreur, l'intervalle de valeurs doit inclure 0.0 et 1.0"
      );

   pragma Compile_Time_Error
      (
         Debut_Intervalle >= Fin_Intervalle,
         "La valeur de debut de l'intervalle doit etre inferieur " &
         "a la valeur de fin d'intervalle"
      );

   type Valeur_Param_T is private;
   --  Chaque paramètre est composé d'une valeur, et de son
   --  intervalle de valeurs autorisé.

   procedure Generer
      (Parametre : in out Valeur_Param_T);
   --  Remplace sa valeur actuelle par une nouvelle valeur
   --  prise au hasard dans son intervalle.
   --  @param Parametre
   --  La valeur à modifier.

   function Accoupler
      (
         Parametre : in     Valeur_Param_T;
         Autre     : in     Valeur_Param_T
      )
      return Valeur_Param_T;
   --  Crée une nouvelle valeur à partir des deux valeur parente.
   --  @param Parametre
   --  La première valeur.
   --  @param Autre
   --  La seconde valeur.
   --  @return Le résultat de l'accouplement des deux valeurs.

   procedure Modifier_Valeur
      (
         Parametre       : in out Valeur_Param_T;
         Nouvelle_Valeur : in     Valeur_Param_G_T
      );
   --  Modifie la valeur stocké dans le paramètre.
   --  @param Parametre
   --  Le paramètre.
   --  @param Nouvelle_Valeur
   --  La nouvelle valeur du paramètre.

   function Lire_Valeur
      (Parametre : in     Valeur_Param_T)
      return Valeur_Param_G_T;
   --  Lit la valeur stocké dans le paramètre.
   --  @param Parametre
   --  Le paramètre.
   --  @return La valeur du paramètre.

private

   procedure Verifier_Et_Ajuster_Borne_Valeur
      (Parametre : in out Valeur_Param_T);
   --  Vérifie seulement que la valeur du paramètre est
   --  dans les bornes définie.
   --  @param Parametre
   --  Le paramètre à vérifier.

   type Valeur_Param_T is
      record
         Valeur : Valeur_Param_G_T;
         --  La valeur du paramètre.
      end record;

end A_E_P.Valeur_Param_Flottant_G;
