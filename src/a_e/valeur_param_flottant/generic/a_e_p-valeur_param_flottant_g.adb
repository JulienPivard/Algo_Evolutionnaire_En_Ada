with Ada.Numerics.Float_Random;
with Ada.Numerics.Discrete_Random;

with Generateur_Flottant_G;

pragma Elaborate_All (Generateur_Flottant_G);

package body A_E_P.Valeur_Param_Flottant_G
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
         Petite_Mutation_Moins,
         --  Retire au gène de l'enfant une valeur entre 0 et 1.
         Inverse_Signe
         --  Inverse le signe de la valeur. Cette mutation est
         --  sans effet si l'intervalle ne contient que des
         --  valeur positive ou négative.
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

   package Alea_Petites_Mutations_R renames Ada.Numerics.Float_Random;

   package Generateur_P       is new Generateur_Flottant_G
      (Valeur_G_T => Valeur_Param_G_T);

   package Alea_Repartition_P is new Ada.Numerics.Discrete_Random
      (Result_Subtype => Repartition_Caractere_T);
   package Proba_Mutation_P   is new Ada.Numerics.Discrete_Random
      (Result_Subtype => Proba_Mutation_T);
   package Alea_Mutation_P    is new Ada.Numerics.Discrete_Random
      (Result_Subtype => Mutation_Possible_T);

   Generateur_Repartition : Alea_Repartition_P.Generator;
   Generateur_Proba_Mute  : Proba_Mutation_P.Generator;
   Generateur_Mutation    : Alea_Mutation_P.Generator;

   Generateur_Petites_Mutations : Alea_Petites_Mutations_R.Generator;

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
         Parametre : in     Valeur_Param_T;
         Autre     : in     Valeur_Param_T
      )
      return Valeur_Param_T
   is
      Origine        : constant Repartition_Caractere_T :=
         Alea_Repartition_P.Random (Gen => Generateur_Repartition);
      Proba_Mutation : constant Proba_Mutation_T        :=
         Proba_Mutation_P.Random   (Gen => Generateur_Proba_Mute);

      Bebe : Valeur_Param_T;
   begin
      case Origine is
         when Pere                  =>
            Bebe.Valeur := Parametre.Valeur;
         when Mere                  =>
            Bebe.Valeur := Autre.Valeur;
         when Moyenne               =>
            Bebe.Valeur := (Parametre.Valeur + Autre.Valeur) / 2.0;
         when Composition_Pere_Mere =>
            Bebe.Valeur := Valeur_Param_G_T'Compose
               (
                  Valeur_Param_G_T'Fraction (Autre.Valeur),
                  --  Mantisse « mère »
                  Valeur_Param_G_T'Exponent (Parametre.Valeur)
                  --  Exposant « père »
               );
            Bebe.Valeur :=
               Valeur_Param_G_T'Copy_Sign (Bebe.Valeur, Autre.Valeur);
         when Composition_Mere_Pere =>
            Bebe.Valeur := Valeur_Param_G_T'Compose
               (
                  Valeur_Param_G_T'Fraction (Parametre.Valeur),
                  --  Mantisse « père »
                  Valeur_Param_G_T'Exponent (Autre.Valeur)
                  --  Exposant « mère »
               );
            Bebe.Valeur :=
               Valeur_Param_G_T'Copy_Sign (Bebe.Valeur, Parametre.Valeur);
      end case;

      --  Correspond à une probabilité de 10%
      if Proba_Mutation < 5 or else Proba_Mutation > 95 then
         case Alea_Mutation_P.Random (Gen => Generateur_Mutation) is
            when Alea_Intervalle_Parents =>
               --  Ajoute une mutation issu d'une valeurs dans un
               --  intervalle entre les deux parents.
               Bloc_Alea_Intervalle :
               declare
                  Ecart : constant Valeur_Param_G_T :=
                     Parametre.Valeur - Autre.Valeur;
               begin
                  Bebe.Valeur := Bebe.Valeur +
                     (
                        if Ecart < 0.0 then
                           Generateur_P.Generer_Flottant
                              (
                                 Borne_Inferieur => Ecart,
                                 Borne_Superieur => Valeur_Param_G_T (0.0)
                              )
                        else
                           Generateur_P.Generer_Flottant
                              (
                                 Borne_Inferieur => Valeur_Param_G_T (0.0),
                                 Borne_Superieur => Ecart
                              )
                     );
               end Bloc_Alea_Intervalle;
            when Petite_Mutation_Plus =>
               --  Ajoute une petite mutation au gène de l'enfant
               Bebe.Valeur :=
                  Bebe.Valeur
                  +
                  Valeur_Param_G_T (Alea_Petites_Mutations_R.Random
                     (Gen => Generateur_Petites_Mutations));
            when Petite_Mutation_Moins =>
               --  Soustrait une petite mutation au gène de l'enfant
               Bebe.Valeur :=
                  Bebe.Valeur
                  -
                  Valeur_Param_G_T (Alea_Petites_Mutations_R.Random
                     (Gen => Generateur_Petites_Mutations));
            when Inverse_Signe =>
               Bebe.Valeur := -Bebe.Valeur;
         end case;
      end if;

      --  On vérifie que la valeur est bien dans son intervalle.
      Verifier_Et_Ajuster_Borne_Valeur (Parametre => Bebe);

      return Bebe;
   end Accoupler;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   procedure Modifier_Valeur
      (
         Parametre       : in out Valeur_Param_T;
         Nouvelle_Valeur : in     Valeur_Param_G_T
      )
   is
   begin
      Parametre.Valeur := Nouvelle_Valeur;
   end Modifier_Valeur;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   function Lire_Valeur
      (Parametre : in     Valeur_Param_T)
      return Valeur_Param_G_T
   is
   begin
      return Parametre.Valeur;
   end Lire_Valeur;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   --                               Partie privée                           --
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   procedure Verifier_Et_Ajuster_Borne_Valeur
      (Parametre : in out Valeur_Param_T)
   is
   begin
      if    Parametre.Valeur < Debut_Intervalle then
         Parametre.Valeur := Debut_Intervalle;
      elsif Parametre.Valeur > Fin_Intervalle   then
         Parametre.Valeur := Fin_Intervalle;
      end if;
   end Verifier_Et_Ajuster_Borne_Valeur;
   ---------------------------------------------------------------------------

begin

   Alea_Repartition_P.Reset (Gen => Generateur_Repartition);
   Proba_Mutation_P.Reset   (Gen => Generateur_Proba_Mute);
   Alea_Mutation_P.Reset    (Gen => Generateur_Mutation);

   Alea_Petites_Mutations_R.Reset (Gen => Generateur_Petites_Mutations);

end A_E_P.Valeur_Param_Flottant_G;
