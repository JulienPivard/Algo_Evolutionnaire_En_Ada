with Demo_P.Graphe_P;

with Ada.Numerics.Discrete_Random;

package body Demo_P.Chemin_P.Evo_P
   with Spark_Mode => Off
is

   type Piece_T is (Pile, Face);

   subtype Poids_Areste_T is Graphe_P.Poids_Areste_T;
   subtype Poids_Tmp_T    is Poids_Areste_T range 2 .. Poids_Areste_T'Last;

   package Alea_Piece_P   is new Ada.Numerics.Discrete_Random
      (Result_Subtype => Piece_T);
   package Alea_Sommets_P is new Ada.Numerics.Discrete_Random
      (Result_Subtype => Sommets_T);
   package Alea_Poids_P   is new Ada.Numerics.Discrete_Random
      (Result_Subtype => Poids_Tmp_T);

   Generateur_Piece   : Alea_Piece_P.Generator;
   Generateur_Sommets : Alea_Sommets_P.Generator;
   Generateur_Poids   : Alea_Poids_P.Generator;

   ---------------------------------------------------------------------------
   procedure Generer
      (Parametres : in out Probleme_Chemin_T)
   is
      type Apparition_Sommets_T is array (Sommets_T) of Boolean;

      Sommets_Deja_Utilise : Apparition_Sommets_T :=
         Apparition_Sommets_T'(others => False);

      Sortir_Boucle_Trouver_Sommet : Boolean := False;
   begin
      Boucle_Construire_Chemin :
      for S of Parametres.Chemin.Sommets loop
         S := Alea_Sommets_P.Random (Gen => Generateur_Sommets);

         Boucle_Trouver_Sommet_Libre :
         loop
            Sortir_Boucle_Trouver_Sommet := not Sommets_Deja_Utilise (S);
            if Sommets_Deja_Utilise (S) then
               if S = Sommets_T'Last then
                  S := Sommets_T'First;
               else
                  S := Sommets_T'Succ (S);
               end if;
            else
               Sommets_Deja_Utilise (S) := True;
            end if;

            exit Boucle_Trouver_Sommet_Libre when Sortir_Boucle_Trouver_Sommet;
         end loop Boucle_Trouver_Sommet_Libre;
      end loop Boucle_Construire_Chemin;
   end Generer;
   ---------------------------------------------------------------------------

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

      return Resultat;
   end Accoupler;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   function Calculer
      (Parametres : in     Probleme_Chemin_T)
      return Resultat_T
   is
      Resultat : Score_T := Score_T'First;

      Chemin_Est_Valide : Boolean;
   begin
      Chemin_Est_Valide :=
         Est_Valide (Chemin => Parametres.Chemin, Graphe => Graphe);

      if Chemin_Est_Valide then
         Resultat := Calculer_Score
            (
               Chemin => Parametres.Chemin,
               Graphe => Graphe
            );
      else
         Resultat := Score_T'Last;
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
      Depart : Sommets_T := Sommets_T'First;
      Arrive : Sommets_T := Sommets_T'Succ (Sommets_T'First);
   begin
      Boucle_Init_Diagonale :
      loop
         Graphe.Ajouter_Areste
            (
               X => Depart,
               Y => Arrive,
               V => 1
            );

         exit Boucle_Init_Diagonale when Arrive = Sommets_T'Last;

         Depart := Sommets_T'Succ (Depart);
         Arrive := Sommets_T'Succ (Arrive);
      end loop Boucle_Init_Diagonale;
      Graphe.Ajouter_Areste
         (
            X => Sommets_T'First,
            Y => Sommets_T'Last,
            V => 1
         );
   end Bloc_Init_Diagonale;

   Graphe.Ajouter_Areste
      (
         X => A,
         Y => E,
         V => 7
      );

   Graphe.Ajouter_Areste
      (
         X => B,
         Y => D,
         V => 9
      );
   Graphe.Ajouter_Areste
      (
         X => B,
         Y => K,
         V => 3
      );

   Graphe.Ajouter_Areste
      (
         X => C,
         Y => G,
         V => 3
      );
   Graphe.Ajouter_Areste
      (
         X => C,
         Y => J,
         V => 2
      );

   Graphe.Ajouter_Areste
      (
         X => E,
         Y => I,
         V => 7
      );

   Graphe.Ajouter_Areste
      (
         X => F,
         Y => H,
         V => 2
      );
   Graphe.Ajouter_Areste
      (
         X => F,
         Y => K,
         V => 8
      );

   Graphe.Ajouter_Areste
      (
         X => G,
         Y => I,
         V => 4
      );

   Graphe.Ajouter_Areste
      (
         X => I,
         Y => K,
         V => 2
      );

end Demo_P.Chemin_P.Evo_P;
