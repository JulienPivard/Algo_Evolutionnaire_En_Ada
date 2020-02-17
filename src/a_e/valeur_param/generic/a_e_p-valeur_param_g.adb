with Ada.Numerics.Discrete_Random;

with Generateur_G;

pragma Elaborate_All (Generateur_G);

package body A_E_P.Valeur_Param_G
   with Spark_Mode => Off
is

   type Repartition_Caractere_T is
      (
         Pere,
         Mere,
         Moyenne,
         Composition_Pere_Mere,
         Composition_Mere_Pere
      );

   package Generateur_P       is new Generateur_G (Valeur_T => V_Param_T);
   package Alea_Repartition_P is new Ada.Numerics.Discrete_Random
      (Result_Subtype => Repartition_Caractere_T);

   Generateur_Repartition : Alea_Repartition_P.Generator;

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
                  V_Param_T'Fraction (Autre.Valeur),
                  V_Param_T'Exponent (Parametre.Valeur)
               );
         when Composition_Mere_Pere =>
            Bebe.Valeur := V_Param_T'Compose
               (
                  V_Param_T'Fraction (Parametre.Valeur),
                  V_Param_T'Exponent (Autre.Valeur)
               );
      end case;
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

end A_E_P.Valeur_Param_G;
