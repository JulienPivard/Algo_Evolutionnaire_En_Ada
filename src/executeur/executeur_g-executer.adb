with Ada.Text_IO;
with Ada.Numerics.Generic_Elementary_Functions;
with Ada.Numerics.Float_Random;
with Ada.Real_Time;

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
   package R_T_R       renames Ada.Real_Time;

   package Math_IO is new Ada.Text_IO.Float_IO (Num => Calcul_T);
   package Math_P  is new Ada.Numerics.Generic_Elementary_Functions
      (Calcul_T);

   X_1 : constant Calcul_T := 5.0;
   X_2 : constant Calcul_T := 2.0;

   R : Calcul_T;

   Resultats  : Table_Calcul_T;
   Generateur : Aleatoire_R.Generator;
   Debut, Fin : R_T_R.Time;

   Nombre_De_Tours : Natural := Natural'First;

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
      --  Pour un résultat entre 1.0 et 7.0;
      Resultat := Calcul_T
         (6.0 * Aleatoire_R.Random (Gen => Generateur) + 1.0);
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
      package Natural_IO is new Ada.Text_IO.Integer_IO (Natural);

      I : Natural := 1;
   begin
      for E of Item loop
         Natural_IO.Put  (Item => I, Width => 2);
         Ada.Text_IO.Put (Item => " I : ");
         Math_IO.Put     (Item => E.V_Initial, Fore => 3, Aft => 3, Exp => 0);
         Ada.Text_IO.Put (Item => " R : ");
         Math_IO.Put     (Item => E.V_Calcule, Fore => 3, Aft => 3, Exp => 0);

         Ada.Text_IO.New_Line (Spacing => 1);
         I := I + 1;
      end loop;
   end Put_Line;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   function Formule_Surface
      (D : in Calcul_T)
      return Calcul_T;
   --  Calcul une surface en fonction du diamètre D donné.
   --  Convergera vers X = 5.9.
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
   --  Convergera vers X = 0.0.
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

   --  Deux inconnues
   --  Formule à ajouter : sin (x+y) + (x-y)^2 -1,5x + 2,5y + 1
   --  Convergence en :
   --   - x = -0,55
   --   - y = -1,55
begin
   R := Formule_Anonyme (X => X_1);

   Ada.Text_IO.Put_Line (Item    => "Formule arbitraire : ");
   Math_IO.Put          (Item    => R, Fore => 3, Aft => 3, Exp => 0);
   Ada.Text_IO.New_Line (Spacing => 1);

   R := Formule_Surface (D => X_2);

   Ada.Text_IO.Put_Line (Item    => "Formule surface : ");
   Math_IO.Put          (Item    => R, Fore => 3, Aft => 3, Exp => 0);
   Ada.Text_IO.New_Line (Spacing => 3);

   Aleatoire_R.Reset (Gen => Generateur);
   Boucle_Initialisation :
   for E of Resultats loop
      E.V_Initial := Generer;
   end loop Boucle_Initialisation;

   Boucle_Calcul :
   for E of Resultats loop
      E.V_Calcule := Formule_Surface (D => E.V_Initial);
   end loop Boucle_Calcul;

   Debut := R_T_R.Clock;
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

      --  Toutes les valeurs survivantes doivent se trouver autour
      --  de la valeur minimum du tableau +/-1
      Bloc_Verification_Convergence :
      declare
         subtype Intervalle_Tmp_T is Indice_T range
            Indice_T'First .. Indice_T'Last - 3;

         V_Ref : constant Calcul_T := Resultats (Resultats'First).V_Calcule;
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

      Bloc_Accouplement_Valeur :
      declare
         subtype Intervalle_Tmp_T is Indice_T range
            Indice_T'First .. Indice_T'Last - 3;

         Moyenne : Calcul_T := 0.0;
      begin
         Boucle_Calcul_Moyenne :
         for I in Intervalle_Tmp_T loop
            Moyenne := Moyenne + Resultats (I).V_Initial;
         end loop Boucle_Calcul_Moyenne;
         Moyenne := Moyenne / Calcul_T (Resultats'Length - 1);

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
   Fin := R_T_R.Clock;

   Put_Line (Item => Resultats);

   Ada.Text_IO.Put_Line
      (Item => "Nombre de tours : " & Natural'Image (Nombre_De_Tours));

   --------------------------------------
   Ada.Text_IO.New_Line (Spacing => 1);
   --  Affiche le temps de filtrage du fichier.
   Ada.Text_IO.Put (Item => "Temps total : ");
   Ada.Text_IO.New_Line (Spacing => 1);
   --  Conversion du temps pour faciliter l'affichage.

   Affichage_Temps :
   declare
      use type R_T_R.Time;

      type Temps_T is new Natural;

      Duree_Exact : constant Duration  :=
         R_T_R.To_Duration (TS => Fin - Debut);
      Duree       : constant Temps_T   := Temps_T (Duree_Exact);
      Minuttes    : constant Temps_T   := 60;
      Indentation : constant String    := "         ";

      package Duree_IO is new Ada.Text_IO.Fixed_IO    (Duration);
      package Temps_IO is new Ada.Text_IO.Integer_IO  (Temps_T);
   begin
      Ada.Text_IO.Put (Item => Indentation);
      Duree_IO.Put    (Item => Duree_Exact, Fore => 0, Aft => 4);
      Ada.Text_IO.Put_Line (Item => " s");

      --  Affichage en minutes.
      if Duree_Exact > 60.0 then
         Ada.Text_IO.Put (Item => Indentation);
         Temps_IO.Put    (Item => Duree / Minuttes, Width => 0);
         Ada.Text_IO.Put (Item => " min et ");
         Temps_IO.Put    (Item => Duree mod Minuttes, Width => 0);
         Ada.Text_IO.Put_Line (Item => " s");
      end if;

      --  Affichage en heures.
      if Duree_Exact > 3600.0 then
         Decoupage_En_Heures :
         declare
            Heures : constant Temps_T := 3600;
         begin
            Ada.Text_IO.Put (Item => Indentation);
            Temps_IO.Put    (Item => Duree / Heures, Width => 0);
            Ada.Text_IO.Put (Item => " h et ");
            Temps_IO.Put
               (Item => (Duree mod Heures) / Minuttes, Width => 0);
            Ada.Text_IO.Put_Line (Item => " m");
         end Decoupage_En_Heures;
      end if;
   end Affichage_Temps;
   Ada.Text_IO.New_Line (Spacing => 1);
   --------------------------------------
end Executer;
