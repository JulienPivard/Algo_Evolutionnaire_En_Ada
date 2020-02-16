with Ada.Numerics;

package body A_E_P.Parametres_P.Surface_P
   with Spark_Mode => Off
is

   ---------------------------------------------------------------------------
   overriding
   procedure Generer
      (Parametres : in out Surface_T)
   is
   begin
      Valeur_Param_1_P.Generer (Parametre => Parametres.Param_1);
   end Generer;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   overriding
   function Accoupler
      (
         Parametres : in Surface_T;
         Autre      : in Surface_T
      )
      return Surface_T
   is
      Bebe : Surface_T;
   begin
      Bebe.Param_1 := Valeur_Param_1_P.Accoupler
         (
            Parametre => Parametres.Param_1,
            Autre     => Autre.Param_1
         );
      return Bebe;
   end Accoupler;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   overriding
   function Calculer
      (Parametres : in Surface_T)
      return V_Calcule_T
   is
   begin
      return Formule_Surface (P => Parametres);
   end Calculer;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   --                               Partie privée                           --
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   function Lire_Parametre
      (Parametres : in Surface_T)
      return V_Param_T
   is
   begin
      return Valeur_Param_1_P.Lire_Valeur
         (Parametre => Parametres.Param_1);
   end Lire_Parametre;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   function Formule_Surface
      (P : in Surface_T)
      return V_Calcule_T
   is
      Pi : constant        := Ada.Numerics.Pi;
      Di : constant Math_T := Math_T (Lire_Parametre (Parametres => P));
   begin
      return V_Calcule_T (Pi * ((Di**2) / 2.0) + 4.0 * (160.0 / Di));
   end Formule_Surface;
   ---------------------------------------------------------------------------

end A_E_P.Parametres_P.Surface_P;
