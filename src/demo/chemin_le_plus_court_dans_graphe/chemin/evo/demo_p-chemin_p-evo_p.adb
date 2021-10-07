with Demo_P.Graphe_P;

with Ada.Numerics.Discrete_Random;

package body Demo_P.Chemin_P.Evo_P
   with Spark_Mode => Off
is

   type Piece_T is (Pile, Face);

   package Alea_Piece_P   is new Ada.Numerics.Discrete_Random
      (Result_Subtype => Piece_T);
   package Alea_Sommets_P is new Ada.Numerics.Discrete_Random
      (Result_Subtype => Sommets_T);

   Generateur_Piece   : Alea_Piece_P.Generator;
   Generateur_Sommets : Alea_Sommets_P.Generator;

   ---------------------------------------------------------------------------
   procedure Generer
      (Parametres : in out Probleme_Chemin_T)
   is
   begin
      Boucle_Construire_Chemin :
      for S of Parametres.Chemin.Sommets loop
         S := Alea_Sommets_P.Random (Gen => Generateur_Sommets);
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

   Graphe.Ajouter_Areste
      (
         X => A,
         Y => B,
         V => 1
      );
   Graphe.Ajouter_Areste
      (
         X => B,
         Y => C,
         V => 1
      );
   Graphe.Ajouter_Areste
      (
         X => C,
         Y => D,
         V => 1
      );
   Graphe.Ajouter_Areste
      (
         X => D,
         Y => E,
         V => 1
      );
   Graphe.Ajouter_Areste
      (
         X => E,
         Y => F,
         V => 1
      );
   Graphe.Ajouter_Areste
      (
         X => F,
         Y => G,
         V => 1
      );
   Graphe.Ajouter_Areste
      (
         X => G,
         Y => H,
         V => 1
      );
   Graphe.Ajouter_Areste
      (
         X => H,
         Y => I,
         V => 1
      );
   Graphe.Ajouter_Areste
      (
         X => I,
         Y => J,
         V => 1
      );
   Graphe.Ajouter_Areste
      (
         X => J,
         Y => K,
         V => 1
      );
   Graphe.Ajouter_Areste
      (
         X => K,
         Y => A,
         V => 1
      );

end Demo_P.Chemin_P.Evo_P;
