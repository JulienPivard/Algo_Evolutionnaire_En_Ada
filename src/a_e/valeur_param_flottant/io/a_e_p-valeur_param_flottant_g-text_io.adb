with Ada.Text_IO;

package body A_E_P.Valeur_Param_Flottant_G.Text_IO
   with Spark_Mode => Off
is

   ---------------------------------------------------------------------------
   procedure Put
      (Item : in     Valeur_Param_T)
   is
   begin
      Put_G (Item => Item.Valeur);
      if Afficher_Intervalle_G then
         Ada.Text_IO.Put (Item => " [");
         Put_G (Item => Debut_Intervalle_G);
         Ada.Text_IO.Put (Item => " .. ");
         Put_G (Item => Fin_Intervalle_G);
         Ada.Text_IO.Put (Item => "]");
      end if;
      Ada.Text_IO.Put (Item => " ");
   end Put;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   --                             Partie privée                             --
   ---------------------------------------------------------------------------

end A_E_P.Valeur_Param_Flottant_G.Text_IO;
