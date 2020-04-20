package body Tri_A_Bulle_G
   with Spark_Mode => Off
is

   ---------------------------------------------------------------------------
   procedure Tri_A_Bulle
      (Tableau : in out Table_G_T)
   is
      Debut : Indice_G_T := Tableau'First;
   begin
      Boucle_De_Tri :
      loop
         Bloc_Tri_Bulle :
         declare
            subtype Indice_Tmp_T is Indice_G_T range
               Indice_G_T'Succ (Debut) .. Tableau'Last;

            Echange : Boolean := False;
         begin
            Boucle_Tri_Bulle :
            for I in reverse Indice_Tmp_T loop
               --  On cherche ici à minimiser le résultat.
               if Comparer
                     (
                        T      => Tableau,
                        Gauche => I,
                        Droite => Indice_G_T'Pred (I)
                     )
               then
                  Echanger (T => Tableau, P1 => I, P2 => Indice_G_T'Pred (I));

                  --  On note qu'un échange à été fait et que donc le
                  --  tableau n'est potentiellement pas totalement trié.
                  Echange := True;
               end if;
            end loop Boucle_Tri_Bulle;

            exit Boucle_De_Tri when not Echange;

            Debut := Indice_G_T'Succ (Debut);
         end Bloc_Tri_Bulle;
      end loop Boucle_De_Tri;
   end Tri_A_Bulle;
   ---------------------------------------------------------------------------

end Tri_A_Bulle_G;
