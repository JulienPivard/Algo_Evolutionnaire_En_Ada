with Ada.Text_IO;

package body A_E_P.Valeur_Param_Flottant_G.Text_IO
   with Spark_Mode => Off
is

   ---------------------------------------------------------------------------
   procedure Put
      (Item : in     Valeur_Param_T)
   is
   begin
      Put (Item => Item.Valeur);
      if Afficher_Intervalle then
         Ada.Text_IO.Put (Item => " [");
         Put (Item => Debut_Intervalle);
         Ada.Text_IO.Put (Item => " .. ");
         Put (Item => Fin_Intervalle);
         Ada.Text_IO.Put (Item => "]");
      end if;
      Ada.Text_IO.Put (Item => " ");
   end Put;
   ---------------------------------------------------------------------------

end A_E_P.Valeur_Param_Flottant_G.Text_IO;
