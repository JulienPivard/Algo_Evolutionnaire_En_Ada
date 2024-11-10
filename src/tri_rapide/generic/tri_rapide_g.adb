package body Tri_Rapide_G
   with Spark_Mode => Off
is

   ---------------------------------------------------------------------------
   procedure Tri_Rapide
      (Tableau : in out Table_G_T)
   is
   begin
      Tri_Rapide
         (
            Tableau => Tableau,
            Premier => Tableau'First,
            Dernier => Tableau'Last
         );
   end Tri_Rapide;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   --                             Partie privée                             --
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   procedure Tri_Rapide
      (
         Tableau : in out Table_G_T;
         Premier : in     Indice_G_T;
         Dernier : in     Indice_G_T
      )
   is
      Position_Pivot : Indice_G_T;
   begin
      if Premier < Dernier then
         --  Placement du pivot.
         Position_Pivot := Choisir_Pivot_G
            (
               Premier => Premier,
               Dernier => Dernier
            );

         --  Répartition des valeurs à gauche et à droite en
         --  fonction de leur valeur par rapport au pivot.
         Position_Pivot := Repartir_Valeurs
            (
               Tableau        => Tableau,
               Premier        => Premier,
               Dernier        => Dernier,
               Position_Pivot => Position_Pivot
            );

         --  Appel de tri rapide sur la partie inférieur des valeurs
         Tri_Rapide
            (
               Tableau => Tableau,
               Premier => Premier,
               Dernier =>
                  (
                     if Indice_G_T'First = Position_Pivot then
                        Position_Pivot
                     else
                        Indice_G_T'Pred (Position_Pivot)
                  )
            );

         --  Appel de tri rapide sur la partie supérieur des valeurs
         Tri_Rapide
            (
               Tableau => Tableau,
               Premier =>
                  (
                     if Indice_G_T'Last = Position_Pivot then
                        Position_Pivot
                     else
                        Indice_G_T'Succ (Position_Pivot)
                  ),
               Dernier => Dernier
            );
      end if;
   end Tri_Rapide;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   function Repartir_Valeurs
      (
         Tableau          : in out Table_G_T;
         Premier, Dernier : in     Indice_G_T;
         Position_Pivot   : in     Indice_G_T
      )
      return Indice_G_T
   is
      subtype Index_Sous_Table_T is Indice_G_T range Premier .. Dernier;

      J : Indice_G_T := Premier;
   begin
      --  On place le pivot à la fin du tableau.
      Echanger_G
         (
            T  => Tableau,
            P1 => Position_Pivot,
            P2 => Dernier
         );

      for I in Index_Sous_Table_T loop
         --  Si la valeur lu doit être à gauche du pivot,
         --  on l'échange avec le première valeur qui doit
         --  être à droite du pivot. Puis on déplace notre
         --  marqueur.
         if Comparer_G (T => Tableau, Gauche => I, Droite => Dernier) then
            Echanger_G
               (
                  T  => Tableau,
                  P1 => I,
                  P2 => J
               );

            J := Indice_G_T'Succ (J);
         end if;
      end loop;

      --  On met le pivot à la limite entre les valeurs plus grande
      --  et plus petites.
      Echanger_G
         (
            T  => Tableau,
            P1 => Dernier,
            P2 => J
         );
      return J;
   end Repartir_Valeurs;
   ---------------------------------------------------------------------------

end Tri_Rapide_G;
