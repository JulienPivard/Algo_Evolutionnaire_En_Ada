with Ada.Containers.Formal_Doubly_Linked_Lists;
with Ada.Numerics.Discrete_Random;

with Demo_P.Graphe_P;

package body Demo_P.Chemin_P.Evo_P
   with Spark_Mode => Off
is

   type Piece_T is (Pile, Face);

   subtype Poids_Areste_T is Graphe_P.Poids_Areste_T;
   subtype Poids_Tmp_T    is Poids_Areste_T range 2 .. Poids_Areste_T'Last;

   package Alea_Piece_P   is new Ada.Numerics.Discrete_Random
      (Result_Subtype => Piece_T);
   package Alea_Sommets_P is new Ada.Numerics.Discrete_Random
      (Result_Subtype => Sommet_T);
   package Alea_Poids_P   is new Ada.Numerics.Discrete_Random
      (Result_Subtype => Poids_Tmp_T);

   Generateur_Piece   : Alea_Piece_P.Generator;
   Generateur_Sommets : Alea_Sommets_P.Generator;
   Generateur_Poids   : Alea_Poids_P.Generator;

   ---------------------------------------------------------------------------
   procedure Generer
      (Parametres : in out Probleme_Chemin_T)
   is
      subtype Pos_Tmp_T is Position_T range Parametres.Chemin.Sommets'Range;

      Sommets_Deja_Utilise : Apparition_Sommets_T :=
         Apparition_Sommets_T'(others => False);

      Suite_Chemin_Est_Ok : Boolean := False;
      Chemin_Existe       : Boolean := False;
      Est_Une_Impasse     : Boolean := False;

      Nb_Tours : Natural := 0;
      S        : Sommet_T;
   begin
      Boucle_Construire_Chemin :
      for I in Pos_Tmp_T loop
         S := Alea_Sommets_P.Random (Gen => Generateur_Sommets);
         Nb_Tours := 0;

         Boucle_Trouver_Sommet_Libre :
         loop
            Nb_Tours        := Nb_Tours + 1;
            Est_Une_Impasse := Nb_Tours >= Parametres.Chemin.Sommets'Length;
            exit Boucle_Trouver_Sommet_Libre when Est_Une_Impasse;

            if I = Parametres.Chemin.Sommets'First then
               Chemin_Existe := True;
            else
               Chemin_Existe := Graphe_P.Sont_Adjacents
                  (
                     G => Graphe,
                     X => Parametres.Chemin.Sommets (Position_T'Pred (I)),
                     Y => S
                  );
            end if;
            Suite_Chemin_Est_Ok :=
               not Sommets_Deja_Utilise (S) and then Chemin_Existe;
            if Suite_Chemin_Est_Ok then
               Sommets_Deja_Utilise (S) := True;
            else
               if S = Sommet_T'Last then
                  S := Sommet_T'First;
               else
                  S := Sommet_T'Succ (S);
               end if;
            end if;

            exit Boucle_Trouver_Sommet_Libre when Suite_Chemin_Est_Ok;
         end loop Boucle_Trouver_Sommet_Libre;

         Parametres.Chemin.Sommets (I) := S;
      end loop Boucle_Construire_Chemin;
   end Generer;
   ---------------------------------------------------------------------------

   package Position_Sommets_En_Double_P is new
      Ada.Containers.Formal_Doubly_Linked_Lists (Element_Type => Position_T);
   subtype Position_Sommets_En_Double_T is Position_Sommets_En_Double_P.List
      (Capacity => Apparition_Sommets_T'Length);

   ---------------------------------------------------------------------------
   function Accoupler
      (
         Parametres : in     Probleme_Chemin_T;
         Autre      : in     Probleme_Chemin_T
      )
      return Probleme_Chemin_T
   is
      Piece    : Piece_T;
      Resultat : Probleme_Chemin_T;
      Sommet   : Sommet_T;

      Position_Sommets_En_Double : Position_Sommets_En_Double_T;
      Apparition_Sommets         : Apparition_Sommets_T :=
         Apparition_Sommets_T'(others => False);
   begin
      Boucle_Parcours_Chemins :
      for I in Position_T loop
         Piece := Alea_Piece_P.Random (Gen => Generateur_Piece);
         Resultat.Chemin.Sommets (I) :=
            (
               case Piece is
                  when Face =>
                     Parametres.Chemin.Sommets (I),
                  when Pile =>
                     Autre.Chemin.Sommets (I)
            );
      end loop Boucle_Parcours_Chemins;

      if not Sommets_Sont_Uniques (Chemin => Resultat.Chemin) then
         Boucle_Trouver_Sommets_En_Double :
         for I in Position_T loop
            Sommet := Resultat.Chemin.Sommets (I);
            if Apparition_Sommets (Sommet) then
               Position_Sommets_En_Double_P.Append
                  (
                     Container => Position_Sommets_En_Double,
                     New_Item  => I
                  );
            end if;
            Apparition_Sommets (Sommet) := True;
         end loop Boucle_Trouver_Sommets_En_Double;

         Bloc_Trouver_Sommet_Absent :
         declare
            Sortir : Boolean  := False;
            S      : Sommet_T := Sommet_T'First;
         begin
            Boucle_Remplacer_Sommets_En_Double :
            for P : Position_T of Position_Sommets_En_Double loop
               Boucle_Trouver_Sommet_Absent :
               loop
                  Sortir :=
                     not Apparition_Sommets (S)
                     or else
                     S = Sommet_T'Last;
                  exit Boucle_Trouver_Sommet_Absent when Sortir;
                  S := Sommet_T'Succ (S);
               end loop Boucle_Trouver_Sommet_Absent;

               Resultat.Chemin.Sommets (P) := S;
               Apparition_Sommets (S) := True;
            end loop Boucle_Remplacer_Sommets_En_Double;
         end Bloc_Trouver_Sommet_Absent;
      end if;

      return Resultat;
   end Accoupler;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   function Calculer
      (Parametres : in     Probleme_Chemin_T)
      return Resultat_T
   is
      Resultat : Score_T := Score_T'First;

      Chemin_Est_Valide : constant Boolean :=
         Est_Valide (Chemin => Parametres.Chemin, Graphe => Graphe);
   begin
      Resultat := Calculer_Score
         (
            Chemin => Parametres.Chemin,
            Graphe => Graphe
         );
      if not Chemin_Est_Valide then
         Resultat := Resultat + (Score_T'Last / 2);
      end if;
      return Resultat_T'(Score => Resultat);
   end Calculer;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   --                             Partie privée                             --
   ---------------------------------------------------------------------------

begin

   Alea_Piece_P.Reset   (Gen => Generateur_Piece);
   Alea_Sommets_P.Reset (Gen => Generateur_Sommets);
   Alea_Poids_P.Reset   (Gen => Generateur_Poids);

   Bloc_Init_Diagonale :
   declare
      Depart : Sommet_T := Sommet_T'First;
      Arrive : Sommet_T := Sommet_T'Succ (Sommet_T'First);
   begin
      Boucle_Init_Diagonale :
      loop
         Graphe.Ajouter_Areste
            (
               X => Depart,
               Y => Arrive,
               V => 1
            );

         exit Boucle_Init_Diagonale when Arrive = Sommet_T'Last;

         Depart := Sommet_T'Succ (Depart);
         Arrive := Sommet_T'Succ (Arrive);
      end loop Boucle_Init_Diagonale;
      Graphe.Ajouter_Areste
         (
            X => Sommet_T'First,
            Y => Sommet_T'Last,
            V => 1
         );
   end Bloc_Init_Diagonale;

   Bloc_Init_Autres_Points :
   declare
      Taille_Chemin : constant Natural := Table_Sommets_T'Length;
      Nb_Sommets    : constant Natural := ((Taille_Chemin**2) * 45) / 100;

      Depart : Sommet_T := Sommet_T'First;
      Arrive : Sommet_T := Sommet_T'Succ (Sommet_T'First);

      I : Natural := 0;
   begin
      Boucle_Init_Autres_Points :
      loop
         Depart := Alea_Sommets_P.Random (Gen => Generateur_Sommets);
         Arrive := Alea_Sommets_P.Random (Gen => Generateur_Sommets);

         if not Graphe.Sont_Adjacents (X => Depart, Y => Arrive)
            and then
            not (Depart = Arrive)
         then
            Graphe.Ajouter_Areste_Orientee
               (
                  X => Depart,
                  Y => Arrive,
                  V => Alea_Poids_P.Random (Gen => Generateur_Poids)
               );
            I := I + 1;
         end if;

         exit Boucle_Init_Autres_Points when I >= Nb_Sommets;
      end loop Boucle_Init_Autres_Points;
   end Bloc_Init_Autres_Points;

end Demo_P.Chemin_P.Evo_P;
