with Ada.Numerics.Discrete_Random;

with Generateur_G;

pragma Elaborate_All (Generateur_G);

package body A_E_P.Valeur_Param_G
   with Spark_Mode => Off
is

   type Proba_Mutation_T is range 0 .. 100;
   --  Symbolise une probabilité de mutation.

   type Mutation_Possible_T is
      (
         Alea_Intervalle_Parents,
         --  Prend au hasard une valeur entre 0 et la différence
         --  entre les parents puis l'ajoute au gène de l'enfant.
         Petite_Mutation_Plus,
         --  Ajoute au gène de l'enfant une valeur entre 0 et 1.
         Petite_Mutation_Moins
         --  Retire au gène de l'enfant une valeur entre 0 et 1.
      );

   type Repartition_Caractere_T is
      (
         Pere,
         --  Ne prend que le gène du « père »
         Mere,
         --  Ne prend que le gène de la « mère »
         Moyenne,
         --  Fait la moyenne des deux valeurs.
         Composition_Pere_Mere,
         --  |signe|exposant | mantisse |
         --  |  1  | 8 ou 11 | 23 ou 52 |
         --  Garde la partie exposant du « père » et la
         --  mantisse de la « mère ».
         Composition_Mere_Pere
         --  |signe|exposant | mantisse |
         --  |  1  | 8 ou 11 | 23 ou 52 |
         --  Garde la partie exposant de la « mère » et la
         --  mantisse du « père ».
      );
   --  Permet de sélectionner aléatoirement la façons dont
   --  se fera le mélange de chaque gènes.

   package Generateur_P       is new Generateur_G
      (Valeur_T => V_Param_T);
   package Alea_Repartition_P is new Ada.Numerics.Discrete_Random
      (Result_Subtype => Repartition_Caractere_T);
   package Proba_Mutation_P   is new Ada.Numerics.Discrete_Random
      (Result_Subtype => Proba_Mutation_T);
   package Alea_Mutation_P    is new Ada.Numerics.Discrete_Random
      (Result_Subtype => Mutation_Possible_T);

   Generateur_Repartition : Alea_Repartition_P.Generator;
   Generateur_Proba_Mute  : Proba_Mutation_P.Generator;
   Generateur_Mutation    : Alea_Mutation_P.Generator;

   ---------------------------------------------------------------------------
   procedure Generer
      (Parametre : in out Valeur_Param_T)
   is
   begin
      Parametre.Valeur := Generateur_P.Generer_Flottant
         (
            Borne_Inferieur => Debut_Intervalle,
            Borne_Superieur => Fin_Intervalle
         );
   end Generer;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   function Accoupler
      (
         Parametre : in Valeur_Param_T;
         Autre     : in Valeur_Param_T
      )
      return Valeur_Param_T
   is
      Origine : constant Repartition_Caractere_T :=
         Alea_Repartition_P.Random (Gen => Generateur_Repartition);
      Proba_Mutation : constant Proba_Mutation_T :=
         Proba_Mutation_P.Random (Gen => Generateur_Proba_Mute);

      Bebe : Valeur_Param_T;
   begin
      case Origine is
         when Pere =>
            Bebe.Valeur := Parametre.Valeur;
         when Mere =>
            Bebe.Valeur := Autre.Valeur;
         when Moyenne =>
            Bebe.Valeur := (Parametre.Valeur + Autre.Valeur) / 2.0;
         when Composition_Pere_Mere =>
            Bebe.Valeur := V_Param_T'Compose
               (
                  V_Param_T'Fraction (Autre.Valeur),     --  Mantisse « mère »
                  V_Param_T'Exponent (Parametre.Valeur)  --  Exposant « père »
               );
         when Composition_Mere_Pere =>
            Bebe.Valeur := V_Param_T'Compose
               (
                  V_Param_T'Fraction (Parametre.Valeur), --  Mantisse « père »
                  V_Param_T'Exponent (Autre.Valeur)      --  Exposant « mère »
               );
      end case;

      --  Correspond à une probabilité de 1%
      if Proba_Mutation > 99 then
         case Alea_Mutation_P.Random (Gen => Generateur_Mutation) is
            when Alea_Intervalle_Parents =>
               null;
            when Petite_Mutation_Plus =>
               null;
            when Petite_Mutation_Moins =>
               null;
         end case;
      end if;

      --  On vérifie que la valeur est bien dans son intervalle.
      if Bebe.Valeur < Debut_Intervalle then
         Bebe.Valeur := Debut_Intervalle;
      elsif Bebe.Valeur > Fin_Intervalle then
         Bebe.Valeur := Fin_Intervalle;
      end if;
      return Bebe;
   end Accoupler;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   procedure Modifier_Valeur
      (
         Parametre       : in out Valeur_Param_T;
         Nouvelle_Valeur : in     V_Param_T
      )
   is
   begin
      Parametre.Valeur := Nouvelle_Valeur;
   end Modifier_Valeur;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   function Lire_Valeur
      (Parametre : in Valeur_Param_T)
      return V_Param_T
   is
   begin
      return Parametre.Valeur;
   end Lire_Valeur;
   ---------------------------------------------------------------------------

begin

   Alea_Repartition_P.Reset (Gen => Generateur_Repartition);
   Proba_Mutation_P.Reset   (Gen => Generateur_Proba_Mute);
   Alea_Mutation_P.Reset    (Gen => Generateur_Mutation);

end A_E_P.Valeur_Param_G;
