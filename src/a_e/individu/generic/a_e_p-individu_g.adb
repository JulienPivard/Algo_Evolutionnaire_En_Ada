package body A_E_P.Individu_G
   with Spark_Mode => Off
is

   ---------------------------------------------------------------------------
   procedure Modifier_Resultat
      (
         Individu : in out Individu_T;
         Valeur   : in     V_Calcule_T
      )
   is
   begin
      Individu.V_Calcule := Valeur;
   end Modifier_Resultat;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   function Lire_Resultat
      (Individu : in Individu_T)
      return V_Calcule_T
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
      Individu.V_Param.Generer;
   end Generer_Parametres;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   function Accoupler
      (
         Individu : in Individu_T;
         Autre    : in Individu_T
      )
      return Individu_T
   is
      Bebe : Individu_T;
   begin
      Bebe.V_Param := Individu.V_Param.Accoupler (Autre => Autre.V_Param);
      return Bebe;
   end Accoupler;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   procedure Appliquer_Formule
      (Individu : in out Individu_T)
   is
   begin
      Individu.V_Calcule := Individu.V_Param.Calculer;
   end Appliquer_Formule;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   function "<"
      (
         Gauche : in Individu_T;
         Droite : in Individu_T
      )
      return Boolean
   is
   begin
      return Gauche.V_Calcule < Droite.V_Calcule;
   end "<";
   ---------------------------------------------------------------------------

end A_E_P.Individu_G;
