with A_E_P.Valeur_Param_P;

--  @summary
--  Définit une classe de paramètre.
--  @description
--  Contient un enfant de la classe Parametres_T, définie
--  pour résoudre la minimisation d'une surface en
--  fonction d'un diamètre.
--  @group Formule
package A_E_P.Parametres_P.Surface_P
   with
      Pure           => False,
      Preelaborate   => False,
      Elaborate_Body => True,
      Spark_Mode     => Off
is

   type Surface_T is new Parametres_T with private;

   overriding
   procedure Generer
      (Parametres : in out Surface_T);
   --  Génère des valeurs aléatoires pour les paramètres stocké.
   --  @param Parametres
   --  Les paramètres.

   overriding
   function Accoupler
      (
         Parametres : in Surface_T;
         Autre      : in Surface_T
      )
      return Surface_T;
   --  Accouple deux paramètres pour obtenir un nouveau
   --  jeu de paramètres.
   --  @param Parametres
   --  Les paramètres, premier parent.
   --  @param Autre
   --  Les paramètres, second parent.
   --  @return Le jeu de paramètres issus de la combinaison des parents.

   overriding
   function Calculer
      (Parametres : in Surface_T)
      return V_Calcule_T;
   --  Calcul la formule en utilisant les valeurs de ses
   --  paramètres comme entrées de la fonction de la formule.
   --  @param Parametres
   --  Les paramètres de la fonction.

private

   type Surface_T is new Parametres_T with
      record
         Param_1 : A_E_P.Valeur_Param_P.Valeur_Param_T;
         --  L'unique paramètre (Pour le moment)
      end record;

   function Lire_Parametre
      (Parametres : in Surface_T)
      return V_Param_T;
   --  Lit la valeur d'un paramètre.
   --  @param Parametres
   --  Les paramètres.
   --  @return La valeur du paramètre demandé.

   function Formule_Surface
      (P : in Surface_T)
      return V_Calcule_T;
   --  Calcul une surface en fonction du diamètre D donné.
   --  Convergera vers X = 5.9.
   --  @param D
   --  Le diamètre de la boite.
   --  @return La surface de la boite.

   function Formule_Anonyme
      (P : in Surface_T)
      return V_Calcule_T;
   --  Un autre calcul.
   --  Convergera vers X = 0.0.
   --  @param X
   --  La valeur de l'inconnue X.
   --  @return Le résultats de la formule en fonction de X.

   --  Deux inconnues
   --  Formule à ajouter : sin (x+y) + (x-y)^2 -1,5x + 2,5y + 1
   --  Convergence en :
   --   - x = -0,55
   --   - y = -1,55

end A_E_P.Parametres_P.Surface_P;
