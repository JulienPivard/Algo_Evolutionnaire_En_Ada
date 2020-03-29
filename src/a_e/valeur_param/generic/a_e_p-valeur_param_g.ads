generic
   Debut_Intervalle : V_Param_T;
   --  Le début de l'intervalle de valeurs.
   Fin_Intervalle   : V_Param_T;
   --  La fin de l'intervalle de valeurs.

   Valeurs_Interdites : Valeurs_Interdites_T := Valeurs_Interdites_Vide;
   --  Les valeurs interdites pour le paramètre.

--  @summary
--  Une valeur de paramètre.
--  @description
--  Stock la valeur d'un paramètre, ainsi que
--  l'intervalle de valeurs dans lequel elle
--  est valide, ou a un sens.
--  @group Parametres
package A_E_P.Valeur_Param_G
   with
      Pure           => False,
      Preelaborate   => False,
      Elaborate_Body => False,
      Spark_Mode     => Off
is

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
         Parametre : in Valeur_Param_T;
         Autre     : in Valeur_Param_T
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
         Nouvelle_Valeur : in     V_Param_T
      );
   --  Modifie la valeur stocké dans le paramètre.
   --  @param Parametre
   --  Le paramètre.
   --  @param Nouvelle_Valeur
   --  La nouvelle valeur du paramètre.

   function Lire_Valeur
      (Parametre : in Valeur_Param_T)
      return V_Param_T;
   --  Lit la valeur stocké dans le paramètre.
   --  @param Parametre
   --  Le paramètre.
   --  @return La valeur du paramètre.

private

   procedure Verifier_Et_Ajuster_Valeur_Si_Interdite
      (Parametre : in out Valeur_Param_T);
   --  Vérifie si la valeur du paramètre correspond à
   --  une de celle qui sont interdite. Si c'est le
   --  cas, un ajustement sera généré entre 0 et 1.
   --  @param Parametre
   --  La valeur du paramètre à vérifier.

   procedure Verifier_Et_Ajuster_Borne_Valeur
      (Parametre : in out Valeur_Param_T);
   --  Vérifie seulement que la valeur du paramètre est
   --  dans les bornes définie.
   --  @param Parametre
   --  Le paramètre à vérifier.

   type Valeur_Param_T is
      record
         Valeur : V_Param_T := Debut_Intervalle;
         --  La valeur du paramètre.
      end record;

   type Ajuster_Valeur_Si_Interdite_A is not null access
      procedure (Parametre : in out Valeur_Param_T);

   Ajuster_Valeur : constant Ajuster_Valeur_Si_Interdite_A :=
      (
         if Valeurs_Interdites'Length <= 0 then
            Verifier_Et_Ajuster_Borne_Valeur'Access
         else
            Verifier_Et_Ajuster_Valeur_Si_Interdite'Access
      );

end A_E_P.Valeur_Param_G;
