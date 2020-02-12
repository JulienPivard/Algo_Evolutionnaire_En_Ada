with A_E_P.Formule_P;

--  @summary
--  Un individu de la population.
--  @description
--  Un individu porte toutes ses spécificité en lui,
--  tel que les paramètres de la fonction et son
--  résultat en fonction de ceux-ci.
--  @group Population
package A_E_P.Individu_P
   with
      Pure           => True,
      Preelaborate   => False,
      Elaborate_Body => False,
      Spark_Mode     => Off
is

   type Individu_T is private;
   --  Un individu d'une population.

   procedure Modifier_Resultat
      (
         Individu : in out Individu_T;
         Valeur   : in     V_Calcule_T
      )
      with Inline => True;
   --  Modifie le résultat stocké dans l'individu.
   --  @param Individu
   --  L'individu d'une population.
   --  @param Valeur
   --  Le résultat à stocker.

   function Lire_Resultat
      (Individu : in Individu_T)
      return V_Calcule_T
      with Inline => True;
   --  Lit le résultat stocké dans l'individu.
   --  @param Individu
   --  L'individu d'une population.
   --  @return La valeur du résultat.

   procedure Generer_Parametres
      (Individu : in out Individu_T);
   --  Permet de générer de nouvelles valeurs pour chaque
   --  paramètres aléatoirement.
   --  @param Individu
   --  L'individu dont il faut régénérer les valeurs.

   function Accoupler
      (
         Individu : in Individu_T;
         Autre    : in Individu_T
      )
      return Individu_T;
   --  Accouple deux individus pour en obtenir un 3ieme.
   --  @param Individu
   --  Le premier membre du couple.
   --  @param Autre
   --  Le second membre du couple.
   --  @return Le résultat de l'union des deux Individu.

   procedure Appliquer_Formule
      (
         Individu : in out Individu_T;
         Formule  : in     A_E_P.Formule_P.Formule_T
      );
   --  Applique la formule sur l'individu.
   --  @param Individu
   --  L'individu.
   --  @param Formule
   --  La formule à appliquer.

   procedure Modifier_Parametre
      (
         Individu : in out Individu_T;
         Valeur   : in     V_Param_T
      )
      with Inline => True;
   --  Modifie le paramètre stocké dans l'individu.
   --  @param Individu
   --  L'individu d'une population.
   --  @param Valeur
   --  La valeur du paramètre à stocker.

   function Lire_Parametre
      (Individu : in Individu_T)
      return V_Param_T
      with Inline => True;
   --  Lit le paramètre stocké dans l'individu.
   --  @param Individu
   --  L'individu d'une population.
   --  @return La valeur du paramètre demandé.

private

   type Individu_T is
      record
         V_Param   : V_Param_T   := 0.0;
         --  L'inconnue utilisé par la fonction.
         V_Calcule : V_Calcule_T := 0.0;
         --  Le résultat de la fonction appliqué au paramètre.
      end record;

end A_E_P.Individu_P;
