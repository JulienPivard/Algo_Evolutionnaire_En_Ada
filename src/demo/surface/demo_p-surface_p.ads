private with A_E_P.Valeur_Param_G;

pragma Elaborate_All (A_E_P.Valeur_Param_G);

--  @summary
--  Calcul la plus petit surface possible à volume contraint.
--  @description
--  Définition des méthodes utile pour résoudre
--  la minimisation d'une surface à volume contraint
--  en fonction d'un diamètre.
--  @group Formule
package Demo_P.Surface_P
   with
      Pure           => False,
      Preelaborate   => False,
      Elaborate_Body => True,
      Spark_Mode     => Off
is

   type Surface_T is private;

   procedure Generer
      (Parametres : in out Surface_T);
   --  Génère des valeurs aléatoires pour les paramètres stocké.
   --  @param Parametres
   --  Les paramètres.

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

   type Resultat_T is private;
   --  Stock le résultat des calculs.

   function Calculer
      (Parametres : in Surface_T)
      return Resultat_T;
   --  Calcul la formule en utilisant les valeurs de ses
   --  paramètres comme entrées de la fonction de la formule.
   --  @param Parametres
   --  Les paramètres de la fonction.
   --  @return Le résultat du calcul de la formule.

   function "<"
      (Gauche, Droite : in Resultat_T)
      return Boolean
      with Inline => True;
   --  Compare deux résultats.
   --  @param Gauche
   --  Le résultat à gauche de la comparaison.
   --  @param Droite
   --  Le résultat à droite de la comparaison.
   --  @return Gauche < Droite.

   function ">"
      (Gauche, Droite : in Resultat_T)
      return Boolean
      with Inline => True;
   --  Compare deux résultats.
   --  @param Gauche
   --  Le résultat à gauche de la comparaison.
   --  @param Droite
   --  Le résultat à droite de la comparaison.
   --  @return Gauche > Droite.

   function Resultats_Convergent
      (
         Reference : in Resultat_T;
         Actuel    : in Resultat_T
      )
      return Boolean
      with Inline => True;
   --  Le résultat actuel converge avec le résultat de référence.
   --  @param Reference
   --  Le résultat de référence.
   --  @param Actuel
   --  Le résultat dont on veut savoir si il converge.
   --  @return Le résultat converge vers la référence.

private

   package Valeur_Diametre_P is new A_E_P.Valeur_Param_G
      (
         Debut_Intervalle => 0.0,
         Fin_Intervalle   => 1100.0
      );

   type Surface_T is
      record
         Diametre : Valeur_Diametre_P.Valeur_Param_T;
         --  L'unique paramètre du calcul de surface.
      end record;

   function Lire_Parametre
      (P : in Surface_T)
      return A_E_P.V_Param_T
   is (Valeur_Diametre_P.Lire_Valeur (Parametre => P.Diametre));
   --  Lit la valeur d'un paramètre.
   --  @param Parametres
   --  Les paramètres.
   --  @return La valeur du paramètre demandé.

   type Resultat_T is
      record
         Surface : V_Calcule_T := 0.0;
         --  La surface totale nécessaire.
      end record;

   function "<"
      (Gauche, Droite : in Resultat_T)
      return Boolean
   is (Gauche.Surface < Droite.Surface);

   function ">"
      (Gauche, Droite : in Resultat_T)
      return Boolean
   is (Gauche.Surface > Droite.Surface);

   function Resultats_Convergent
      (
         Reference : in Resultat_T;
         Actuel    : in Resultat_T
      )
      return Boolean
   is
      (
         Reference.Surface - 0.5 <= Actuel.Surface
         and then
         Actuel.Surface <= Reference.Surface + 0.5
      );

end Demo_P.Surface_P;
