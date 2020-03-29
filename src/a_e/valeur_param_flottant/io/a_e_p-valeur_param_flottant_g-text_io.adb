with Ada.Text_IO;

package body A_E_P.Valeur_Param_Flottant_G.Text_IO
   with Spark_Mode => Off
is

   package V_Param_IO is new Ada.Text_IO.Float_IO (Num => Valeur_Param_G_T);

   ---------------------------------------------------------------------------
   procedure Put
      (Item : in Valeur_Param_T)
   is
   begin
      V_Param_IO.Put
         (
            Item => Item.Valeur,
            Fore => 3,
            Aft  => 3,
            Exp  => 0
         );
      Ada.Text_IO.Put (Item => " [");
      V_Param_IO.Put
         (
            Item => Debut_Intervalle,
            Fore => 1,
            Aft  => 3,
            Exp  => 0
         );
      Ada.Text_IO.Put (Item => " .. ");
      V_Param_IO.Put
         (
            Item => Fin_Intervalle,
            Fore => 1,
            Aft  => 3,
            Exp  => 0
         );
      Ada.Text_IO.Put (Item => "] ");
   end Put;
   ---------------------------------------------------------------------------

end A_E_P.Valeur_Param_Flottant_G.Text_IO;
