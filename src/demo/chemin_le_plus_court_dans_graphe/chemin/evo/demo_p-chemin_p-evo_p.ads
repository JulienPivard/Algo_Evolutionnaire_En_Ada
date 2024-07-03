--  @summary
--  Interface pour résoudre le problème du plus court chemin dans un graphe.
--  @description
--  Interface pour résoudre le problème du plus court chemin dans un graphe.
--  Le chemin doit passer par tous les sommets une seul et unique fois.
--  @group Chemin
package Demo_P.Chemin_P.Evo_P
   with
      Pure           => False,
      Preelaborate   => False,
      Elaborate_Body => True,
      Spark_Mode     => Off
is

   type Probleme_Chemin_T is private;
   --  Le problème de chemin à résoudre.

   procedure Generer
      (Pb_Chemin : in out Probleme_Chemin_T);
   --  Génère des valeurs aléatoires pour les paramètres stocké.
   --  @param Pb_Chemin
   --  Le chemin dans le graphe.

   function Accoupler
      (
         Premier_Chemin : in     Probleme_Chemin_T;
         Seconds_Chemin : in     Probleme_Chemin_T
      )
      return Probleme_Chemin_T;
   --  Accouple deux paramètres pour obtenir un nouveau
   --  jeu de paramètres.
   --  @param Premier_Chemin
   --  Le premier chemin, premier parent.
   --  @param Seconds_Chemin
   --  Le second chemin, second parent.
   --  @return Le jeu de paramètres issus de la combinaison des parents.

   type Resultat_T is private;
   --  Stock le résultat des calculs.

   function Calculer
      (Pb_Chemin : in     Probleme_Chemin_T)
      return Resultat_T;
   --  Calcul la formule en utilisant les valeurs de ses
   --  paramètres comme entrées de la fonction de la formule.
   --  @param Pb_Chemin
   --  Le chemin dans le graphe.
   --  @return Le résultat du calcul de la formule.

   function "<"
      (Gauche, Droite : in     Resultat_T)
      return Boolean;
   --  Compare deux résultats.
   --  @param Gauche
   --  Le résultat à gauche de la comparaison.
   --  @param Droite
   --  Le résultat à droite de la comparaison.
   --  @return Gauche < Droite.

   function ">"
      (Gauche, Droite : in     Resultat_T)
      return Boolean;
   --  Compare deux résultats.
   --  @param Gauche
   --  Le résultat à gauche de la comparaison.
   --  @param Droite
   --  Le résultat à droite de la comparaison.
   --  @return Gauche > Droite.

   function Resultats_Convergent
      (
         Reference : in     Resultat_T;
         Actuel    : in     Resultat_T
      )
      return Boolean;
   --  Le résultat actuel converge avec le résultat de référence.
   --  @param Reference
   --  Le résultat de référence.
   --  @param Actuel
   --  Le résultat dont on veut savoir si il converge.
   --  @return Le résultat converge vers la référence.

private

   type Probleme_Chemin_T is
      record
         Chemin : Chemin_T;
      end record;

   type Resultat_T is
      record
         Score : Score_T := Score_T'Last;
      end record;

   ------------
   function "<"
      (Gauche, Droite : in     Resultat_T)
      return Boolean
   is (Gauche.Score < Droite.Score);

   ------------
   function ">"
      (Gauche, Droite : in     Resultat_T)
      return Boolean
   is (Gauche.Score > Droite.Score);

   Seuil_De_Convergence : constant Score_T := 5;

   -----------------------------
   function Resultats_Convergent
      (
         Reference : in     Resultat_T;
         Actuel    : in     Resultat_T
      )
      return Boolean
   is
      (
         Reference.Score - Seuil_De_Convergence <= Actuel.Score
         and then
         Actuel.Score <= Reference.Score + Seuil_De_Convergence
      );

   pragma Annotate
      (
         gnatcheck,
         Exempt_On,
         "Global_Variables",
         "N'est pas modifié apres initialisation"
      );
   Graphe : Graphe_P.Graphe_T
      with Constant_After_Elaboration => True;
   pragma Annotate
      (
         gnatcheck,
         Exempt_Off,
         "Global_Variables"
      );

end Demo_P.Chemin_P.Evo_P;
