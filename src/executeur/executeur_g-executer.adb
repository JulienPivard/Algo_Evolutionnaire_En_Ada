with Ada.Text_IO;
with Ada.Numerics.Generic_Elementary_Functions;
with Ada.Numerics.Float_Random;

separate (Executeur_G)
procedure Executer
   --  (Arguments)
is
   type Calcul_T is digits 5;

   type Element_T is
      record
         V_Initial : Calcul_T := 0.0;
         V_Calcule : Calcul_T := 0.0;
      end record;

   type Indice_T       is range 1 .. 10;
   type Table_Calcul_T is array (Indice_T) of Element_T;

   package Aleatoire_R renames Ada.Numerics.Float_Random;

   package Math_IO is new Ada.Text_IO.Float_IO (Calcul_T);
   package Math_P  is new Ada.Numerics.Generic_Elementary_Functions
      (Calcul_T);

   X_1 : constant Calcul_T := 5.0;
   X_2 : constant Calcul_T := 2.0;

   R : Calcul_T;

   Resultats : Table_Calcul_T;

   Generateur : Aleatoire_R.Generator;

   ---------------------------------------------------------------------------
   function Generer
      return Calcul_T;
   --  Génère une valeur aléatoire comprise entre les bornes.
   --  @return La valeur aléatoire généré.

   function Generer
      return Calcul_T
   is
      Resultat : Calcul_T;
   begin
      --  Pour un résultat entre 1.0 et 4.0;
      Resultat := Calcul_T (3.0 * Aleatoire_R.Random (Generateur) + 1.0);
      return Resultat;
   end Generer;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   procedure Put_Line
      (Item : in Table_Calcul_T);
   --  Affiche le contenu d'un tableau de valeurs.
   --  @param Item
   --  Le tableau.

   procedure Put_Line
      (Item : in Table_Calcul_T)
   is
   begin
      for E of Item loop
         Ada.Text_IO.Put ("I : ");
         Math_IO.Put     (Item => E.V_Initial, Fore => 3, Aft => 3, Exp => 0);
         Ada.Text_IO.Put (" R : ");
         Math_IO.Put     (Item => E.V_Calcule, Fore => 3, Aft => 3, Exp => 0);

         Ada.Text_IO.New_Line (Spacing => 1);
      end loop;
   end Put_Line;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   function Formule_Surface
      (D : in Calcul_T)
      return Calcul_T;
   --  Calcul une surface en fonction du diamètre D donné.
   --  @param D
   --  Le diamètre de la boite.
   --  @return La surface de la boite.

   function Formule_Surface
      (D : in Calcul_T)
      return Calcul_T
   is
      Resultat : Calcul_T;
   begin
      Resultat := Ada.Numerics.Pi * ((D**2) / 2.0) + 4.0 * (160.0 / D);
      return Resultat;
   end Formule_Surface;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   function Formule_Anonyme
      (X : in Calcul_T)
      return Calcul_T;
   --  Un autre calcul.
   --  @param X
   --  La valeur de l'inconnue X.
   --  @return Le résultats de la formule en fonction de X.

   function Formule_Anonyme
      (X : in Calcul_T)
      return Calcul_T
   is
      Pi : constant := Ada.Numerics.Pi;

      Resultat : Calcul_T;
   begin
      Resultat := 10.0 + (X**2) - 10.0 * Math_P.Cos (X => 2.0 * Pi * X);
      return Resultat;
   end Formule_Anonyme;
   ---------------------------------------------------------------------------
begin
   R := Formule_Anonyme (X => X_1);

   Math_IO.Put          (Item    => R, Fore => 3, Aft => 3, Exp => 0);
   Ada.Text_IO.New_Line (Spacing => 1);

   R := Formule_Surface (D => X_2);

   Math_IO.Put          (Item    => R, Fore => 3, Aft => 3, Exp => 0);
   Ada.Text_IO.New_Line (Spacing => 1);

   Aleatoire_R.Reset (Generateur);
   Boucle_Initialisation :
   for E of Resultats loop
      E.V_Initial := Generer;
   end loop Boucle_Initialisation;

   Boucle_Calcul :
   for E of Resultats loop
      E.V_Calcule := Formule_Surface (D => E.V_Initial);
   end loop Boucle_Calcul;

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
                  Tmp := Resultats (I);
                  Resultats (I) := Resultats (I + 1);
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

   Put_Line (Item => Resultats);
   --  Génère deux valeurs aléatoires et les places dans les deux
   --  dernières cases du tableau.
   Bloc_Genere_Nouvelles_Valeurs_Alea :
   declare
      subtype Intervalle_Tmp_T is Indice_T range
         Indice_T'Last - 3 .. Indice_T'Last - 1;
   begin
      Boucle_Genere_Nouvelles_Valeurs_Alea :
      for I in Intervalle_Tmp_T loop
         Resultats (I).V_Initial := Generer;
      end loop Boucle_Genere_Nouvelles_Valeurs_Alea;
   end Bloc_Genere_Nouvelles_Valeurs_Alea;

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

   Put_Line (Item => Resultats);

end Executer;
