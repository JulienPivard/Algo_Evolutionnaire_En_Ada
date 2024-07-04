package body A_E_P.Individu_G
   with Spark_Mode => Off
is

   ---------------------------------------------------------------------------
   procedure Modifier_Resultat
      (
         Individu : in out Individu_T;
         Valeur   : in     Resultat_Calcul_G_T
      )
   is
   begin
      Individu.V_Calcule := Valeur;
   end Modifier_Resultat;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   function Lire_Resultat
      (Individu : in     Individu_T)
      return Resultat_Calcul_G_T
   is
   begin
      return Individu.V_Calcule;
   end Lire_Resultat;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   procedure Generer_Parametres
      (Individu : in out Individu_T)
   is
   begin
      Generer_G (Parametres => Individu.V_Param);
   end Generer_Parametres;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   function Accoupler
      (
         Individu : in     Individu_T;
         Autre    : in     Individu_T
      )
      return Individu_T
   is
      Bebe : Individu_T;
   begin
      Bebe.V_Param := Accoupler_G
            (
               Parametres => Individu.V_Param,
               Autre      => Autre.V_Param
            );
      return Bebe;
   end Accoupler;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   procedure Appliquer_Formule
      (Individu : in out Individu_T)
   is
   begin
      Individu.V_Calcule := Calculer_G (Parametres => Individu.V_Param);
   end Appliquer_Formule;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   function Dans_Convergence
      (
         Reference : in     Individu_T;
         Actuel    : in     Individu_T
      )
      return Boolean
   is
   begin
      return Convergence_G
         (
            Reference => Reference.V_Calcule,
            Actuelle  => Actuel.V_Calcule
         );
   end Dans_Convergence;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   function "<"
      (Gauche, Droite : in     Individu_T)
      return Boolean
   is
   begin
      return Gauche.V_Calcule < Droite.V_Calcule;
   end "<";
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   function ">"
      (Gauche, Droite : in     Individu_T)
      return Boolean
   is
   begin
      return Gauche.V_Calcule > Droite.V_Calcule;
   end ">";
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   --                             Partie privée                             --
   ---------------------------------------------------------------------------

end A_E_P.Individu_G;
