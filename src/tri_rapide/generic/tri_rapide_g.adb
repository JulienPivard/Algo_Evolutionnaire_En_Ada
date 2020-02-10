with Ada.Numerics.Discrete_Random;

package body Tri_Rapide_G
   with Spark_Mode => Off
is

   ---------------------------------------------------------------------------
   procedure Tri_Rapide
      (Tableau : in out Table_G_T)
   is
   begin
      Tri_Rapide (Tableau, Tableau'First, Tableau'Last);
   end Tri_Rapide;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   procedure Tri_Rapide
      (
         Tableau          : in out Table_G_T;
         Premier, Dernier : in     Indice_G_T
      )
   is
      use type Sorte_De_Tri_P.Sorte_De_Tri_T;

      Position_Pivot : Indice_G_T;
   begin
      if Premier < Dernier then

         --  Placement du pivot.
         Position_Pivot :=
            (
               if Sorte_De_Tri = Sorte_De_Tri_P.Deterministe
               then
                  Choisir_Pivot_Deterministe (Premier, Dernier)
               else
                  Choisir_Pivot_Aleatoire    (Premier, Dernier)
            );

         --  Répartition des valeurs à gauche et à droite en
         --  fonction de leur valeur par rapport au pivot.
         Position_Pivot := Repartir_Valeurs
            (Tableau, Premier, Dernier, Position_Pivot);

         --  Appel de tri rapide sur la partie inférieur des valeurs
         Tri_Rapide
            (
               Tableau,
               Premier,
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
               Tableau,
               (
                  if Indice_G_T'Last = Position_Pivot then
                     Position_Pivot
                  else
                     Indice_G_T'Succ (Position_Pivot)
               ),
               Dernier
            );

      end if;
   end Tri_Rapide;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   function Choisir_Pivot_Deterministe
      (Premier, Dernier : in Indice_G_T)
      return Indice_G_T
   is
      pragma Unreferenced (Dernier);
   begin
      return Premier;
   end Choisir_Pivot_Deterministe;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   function Choisir_Pivot_Aleatoire
      (Premier, Dernier : in Indice_G_T)
      return Indice_G_T
   is
      subtype Index_Sous_Table_T is Indice_G_T range Premier .. Dernier;

      package Pivot_IO is new
         Ada.Numerics.Discrete_Random (Index_Sous_Table_T);

      Generateur : Pivot_IO.Generator;
   begin
      Pivot_IO.Reset (Generateur);
      return Indice_G_T (Pivot_IO.Random (Generateur));
   end Choisir_Pivot_Aleatoire;
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
      Echanger (Tableau, Position_Pivot, Dernier);

      for I in Index_Sous_Table_T loop

         --  Si la valeur lu doit être à gauche du pivot,
         --  on l'échange avec le première valeur qui doit
         --  être à droite du pivot. Puis on déplace notre
         --  marqueur.
         if Comparer (Tableau, I, Dernier) then
            Echanger (Tableau, I, J);
            J := Indice_G_T'Succ (J);
         end if;

      end loop;

      --  On met le pivot à la limite entre les valeurs plus grande
      --  et plus petites.
      Echanger (Tableau, Dernier, J);
      return J;
   end Repartir_Valeurs;
   ---------------------------------------------------------------------------

end Tri_Rapide_G;
