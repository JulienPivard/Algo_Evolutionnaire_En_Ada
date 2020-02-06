with Ada.Text_IO;
with Ada.Real_Time;
with Ada.Numerics.Generic_Elementary_Functions;

with Aleatoire_P;
with Chrono_P;

separate (Executeur_G)
procedure Executer
   --  (Arguments)
is
   type Math_T      is digits 5;
   type V_Initial_T is new Math_T;
   type V_Calcule_T is new Math_T;

   type Element_T is
      record
         V_Initial : V_Initial_T := 0.0;
         V_Calcule : V_Calcule_T := 0.0;
      end record;

   type Indice_T       is range 1 .. 10;
   type Table_Calcul_T is array (Indice_T) of Element_T;

   package V_Initial_IO is new Ada.Text_IO.Float_IO (Num => V_Initial_T);
   package V_Calcule_IO is new Ada.Text_IO.Float_IO (Num => V_Calcule_T);

   package Math_P is new Ada.Numerics.Generic_Elementary_Functions (Math_T);

   X_1 : constant V_Initial_T := 5.0;
   X_2 : constant V_Initial_T := 2.0;

   R : V_Calcule_T;

   Resultats  : Table_Calcul_T;
   Debut, Fin : Ada.Real_Time.Time;

   Nombre_De_Tours : Natural := Natural'First;

   ---------------------------------------------------------------------------
   procedure Put_Line
      (Item : in Table_Calcul_T);
   --  Affiche le contenu d'un tableau de valeurs.
   --  @param Item
   --  Le tableau.

   procedure Put_Line
      (Item : in Table_Calcul_T)
   is
      package Natural_IO is new Ada.Text_IO.Integer_IO (Natural);

      I : Natural := 1;
   begin
      for E of Item loop
         Natural_IO.Put   (Item => I, Width => 2);
         Ada.Text_IO.Put  (Item => " Initial : ");
         V_Initial_IO.Put (Item => E.V_Initial, Fore => 3, Aft => 3, Exp => 0);
         Ada.Text_IO.Put  (Item => " | Résultat : ");
         V_Calcule_IO.Put (Item => E.V_Calcule, Fore => 3, Aft => 3, Exp => 0);

         Ada.Text_IO.New_Line (Spacing => 1);
         I := I + 1;
      end loop;
   end Put_Line;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   function Formule_Surface
      (D : in V_Initial_T)
      return V_Calcule_T;
   --  Calcul une surface en fonction du diamètre D donné.
   --  Convergera vers X = 5.9.
   --  @param D
   --  Le diamètre de la boite.
   --  @return La surface de la boite.

   function Formule_Surface
      (D : in V_Initial_T)
      return V_Calcule_T
   is
      Pi : constant        := Ada.Numerics.Pi;
      Di : constant Math_T := Math_T (D);
   begin
      return V_Calcule_T (Pi * ((Di**2) / 2.0) + 4.0 * (160.0 / Di));
   end Formule_Surface;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   function Formule_Anonyme
      (X : in V_Initial_T)
      return V_Calcule_T;
   --  Un autre calcul.
   --  Convergera vers X = 0.0.
   --  @param X
   --  La valeur de l'inconnue X.
   --  @return Le résultats de la formule en fonction de X.

   function Formule_Anonyme
      (X : in V_Initial_T)
      return V_Calcule_T
   is
      Pi : constant        := Ada.Numerics.Pi;
      Xi : constant Math_T := Math_T (X);
   begin
      return V_Calcule_T
         (10.0 + (Xi**2) - 10.0 * Math_P.Cos (X => 2.0 * Pi * Xi));
   end Formule_Anonyme;
   ---------------------------------------------------------------------------

   --  Deux inconnues
   --  Formule à ajouter : sin (x+y) + (x-y)^2 -1,5x + 2,5y + 1
   --  Convergence en :
   --   - x = -0,55
   --   - y = -1,55

   subtype Interval_Initial_T is V_Initial_T range 0.0 .. 110.0;

   function Generer is new Aleatoire_P.Generer_Flottant (Interval_Initial_T);
begin
   R := Formule_Anonyme (X => X_1);

   Ada.Text_IO.Put_Line (Item    => "Formule arbitraire : ");
   V_Calcule_IO.Put     (Item    => R, Fore => 3, Aft => 3, Exp => 0);
   Ada.Text_IO.New_Line (Spacing => 1);

   R := Formule_Surface (D => X_2);

   Ada.Text_IO.Put_Line (Item    => "Formule surface : ");
   V_Calcule_IO.Put     (Item    => R, Fore => 3, Aft => 3, Exp => 0);
   Ada.Text_IO.New_Line (Spacing => 3);

   --  Initialisation du tableau avec des valeurs initial
   Boucle_Initialisation :
   for E of Resultats loop
      E.V_Initial := Generer;
   end loop Boucle_Initialisation;

   --  Premier calcul de toutes la valeurs.
   Boucle_Calcul :
   for E of Resultats loop
      E.V_Calcule := Formule_Surface (D => E.V_Initial);
   end loop Boucle_Calcul;

   Ada.Text_IO.Put_Line (Item    => "========== Valeurs de départ ==========");
   Ada.Text_IO.New_Line (Spacing => 1);
   Put_Line             (Item    => Resultats);
   Ada.Text_IO.New_Line (Spacing => 1);

   Debut := Ada.Real_Time.Clock;
   Boucle_Generation_Successive :
   loop
      --  Utilisation d'un tri à bulle pour le premier prototype.
      Boucle_De_Tri :
      loop
         Bloc_Tri_Bulle :
         declare
            subtype Intervalle_Tmp_T is Indice_T range
               Indice_T'First .. Indice_T'Last - 1;

            Echange : Boolean := False;
         begin
            Boucle_Tri_Bulle :
            for I in Intervalle_Tmp_T loop
               --  On cherche ici à minimiser le résultat.
               if Resultats (I).V_Calcule > Resultats (I + 1).V_Calcule then
                  Bloc_Echange_Valeur :
                  declare
                     Tmp : Element_T;
                  begin
                     Tmp               := Resultats (I);
                     Resultats (I)     := Resultats (I + 1);
                     Resultats (I + 1) := Tmp;
                  end Bloc_Echange_Valeur;

                  --  On note qu'un échange à été fait et que donc le tableau
                  --  n'est potentiellement pas totalement trié.
                  Echange := True;
               end if;
            end loop Boucle_Tri_Bulle;

            exit Boucle_De_Tri when not Echange;
         end Bloc_Tri_Bulle;
      end loop Boucle_De_Tri;

      --  Toutes les valeurs survivantes doivent se trouver autour
      --  de la valeur minimum du tableau +/-1
      Bloc_Verification_Convergence :
      declare
         subtype Intervalle_Tmp_T is Indice_T range
            Indice_T'First .. Indice_T'Last - 3;

         V_Ref : constant V_Calcule_T := Resultats (Resultats'First).V_Calcule;
      begin
         exit Boucle_Generation_Successive when
            (
               for all I in Intervalle_Tmp_T =>
                  Resultats (I).V_Calcule <= V_Ref + 1.0
                  and then
                  Resultats (I).V_Calcule >= V_Ref - 1.0
            );
      end Bloc_Verification_Convergence;

      --  Génère deux valeurs aléatoires et les places dans les deux
      --  dernières cases du tableau.
      Bloc_Genere_Nouvelles_Valeurs_Alea :
      declare
         subtype Intervalle_Tmp_T is Indice_T range
            Indice_T'Last - 2 .. Indice_T'Last - 1;
      begin
         Boucle_Genere_Nouvelles_Valeurs_Alea :
         for I in Intervalle_Tmp_T loop
            Resultats (I).V_Initial := Generer;
         end loop Boucle_Genere_Nouvelles_Valeurs_Alea;
      end Bloc_Genere_Nouvelles_Valeurs_Alea;

      --  Génère une nouvelle valeur à partir de plusieurs autres.
      Bloc_Accouplement_Valeur :
      declare
         subtype Intervalle_Tmp_T is Indice_T range
            Indice_T'First .. Indice_T'Last - 3;

         Moyenne : V_Initial_T := 0.0;
      begin
         Boucle_Calcul_Moyenne :
         for I in Intervalle_Tmp_T loop
            Moyenne := Moyenne + Resultats (I).V_Initial;
         end loop Boucle_Calcul_Moyenne;
         Moyenne := Moyenne / V_Initial_T (Resultats'Length - 3);
         --  Les 3 dernières valeurs ne font pas partit des survivantes

         Resultats (Resultats'Last).V_Initial := Moyenne;
      end Bloc_Accouplement_Valeur;

      Nombre_De_Tours := Nombre_De_Tours + 1;

      --  Il est inutile de recalculer toutes les valeurs. Seul les 3
      --  dernières sont nouvelles.
      Bloc_Calcul_Partiel :
      declare
         subtype Intervalle_Tmp_T is Indice_T range
            Indice_T'Last - 3 .. Indice_T'Last;
      begin
         Boucle_Calcul_Partiel :
         for I in Intervalle_Tmp_T loop
            Resultats (I).V_Calcule :=
               Formule_Surface (D => Resultats (I).V_Initial);
         end loop Boucle_Calcul_Partiel;
      end Bloc_Calcul_Partiel;

   end loop Boucle_Generation_Successive;
   Fin := Ada.Real_Time.Clock;

   Ada.Text_IO.Put_Line (Item    => "======= Valeurs après évolution =======");
   Ada.Text_IO.New_Line (Spacing => 1);
   Put_Line             (Item => Resultats);
   Ada.Text_IO.New_Line (Spacing => 1);

   Ada.Text_IO.Put_Line
      (Item => "Nombre de tours : " & Natural'Image (Nombre_De_Tours));

   --------------------------------------
   Ada.Text_IO.New_Line (Spacing => 1);
   --  Affiche le temps de filtrage du fichier.
   Ada.Text_IO.Put      (Item => "Temps total : ");
   Ada.Text_IO.New_Line (Spacing => 1);

   --  Conversion du temps pour faciliter l'affichage.
   Chrono_P.Affichage_Temps (Debut => Debut, Fin => Fin);

   Ada.Text_IO.New_Line (Spacing => 1);
   --------------------------------------
end Executer;
