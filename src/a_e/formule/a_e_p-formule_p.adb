with Ada.Numerics.Generic_Elementary_Functions;

package body A_E_P.Formule_P
   with Spark_Mode => Off
is

   package Math_P is new Ada.Numerics.Generic_Elementary_Functions (Math_T);

   ---------------------------------------------------------------------------
   function Formule_Surface
      (P : in Parametres_P.Parametres_T)
      return V_Calcule_T
   is
      Pi : constant        := Ada.Numerics.Pi;
      Di : constant Math_T := Math_T (Parametres_P.Lire_Parametre (P));
   begin
      return V_Calcule_T (Pi * ((Di**2) / 2.0) + 4.0 * (160.0 / Di));
   end Formule_Surface;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   function Formule_Anonyme
      (P : in Parametres_P.Parametres_T)
      return V_Calcule_T
   is
      Pi : constant        := Ada.Numerics.Pi;
      Xi : constant Math_T := Math_T (Parametres_P.Lire_Parametre (P));
   begin
      return V_Calcule_T
         (10.0 + (Xi**2) - 10.0 * Math_P.Cos (X => 2.0 * Pi * Xi));
   end Formule_Anonyme;
   ---------------------------------------------------------------------------

end A_E_P.Formule_P;
