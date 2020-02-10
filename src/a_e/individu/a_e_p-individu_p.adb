package body A_E_P.Individu_P
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
   procedure Modifier_Parametre
      (
         Individu : in out Individu_T;
         Valeur   : in     V_Param_T
      )
   is
   begin
      Individu.V_Param := Valeur;
   end Modifier_Parametre;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   function Lire_Parametre
      (Individu : in Individu_T)
      return V_Param_T
   is
   begin
      return Individu.V_Param;
   end Lire_Parametre;
   ---------------------------------------------------------------------------

end A_E_P.Individu_P;
