with Ada.Numerics.Discrete_Random;
with Ada.Text_IO;

package body A_E_P.Outils_G
   with Spark_Mode => Off
is

   ---------------------------------------------------------------------------
   procedure Initialiser
      (Population : in out Population_T)
   is
   begin
      if not Population.Initialisee then
         Population_P.Initialiser (Population => Population.Pop);
         Population.Initialisee := True;
      end if;
   end Initialiser;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   procedure Put_Line
      (Item : in     Population_T)
   is
   begin
      Ada.Text_IO.Put (Item => "Formule : ");
      Afficher_Formule_G;
      Population_IO.Put_Line (Item => Item.Pop);
   end Put_Line;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   procedure Afficher_Details is
   begin
      Population_IO.Afficher_Details;
   end Afficher_Details;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   procedure Trier_Et_Verifier
      (
         Population                 : in out Population_T;
         NB_Tours_Sans_Divergences  : in out NB_Tours_Sans_Divergences_T;
         NB_Tours_Sans_Amelioration : in out NB_Tours_Sans_Amelioration_T
      )
   is
      Est_Ameliore : Boolean;
   begin
      Population_P.Trier (Population => Population.Pop);

      --  Toutes les valeurs survivantes doivent se trouver autour
      --  de la valeur minimum du tableau pendant 25 générations.
      --  Intervalle de convergence
      if Verifier_Convergence (Population => Population.Pop) then
         NB_Tours_Sans_Divergences := NB_Tours_Sans_Divergences + 1;
      else
         NB_Tours_Sans_Divergences := 0;
      end if;

      Population_P.C_Est_Ameliore_Depuis_Gen_Precedente
         (
            Population   => Population.Pop,
            Est_Ameliore => Est_Ameliore
         );
      if Est_Ameliore then
         NB_Tours_Sans_Amelioration := 0;
      else
         NB_Tours_Sans_Amelioration := NB_Tours_Sans_Amelioration + 1;
      end if;
   end Trier_Et_Verifier;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   procedure Passer_A_La_Generation_Suivante
      (Population : in out Population_T)
   is
   begin
      Remplacer_Morts           (Population => Population.Pop);
      Calcul_Formule_Sur_Enfant (Population => Population.Pop);

      Faire_Evoluer_Par_Tournoi (Population => Population.Pop);
   end Passer_A_La_Generation_Suivante;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   function Lire_Taille
      (Population : in out Population_T)
      return Taille_Population_T
   is
   begin
      return Population_P.Lire_Taille (Population => Population.Pop);
   end Lire_Taille;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   procedure Accueillir_Migrants
      (
         Population : in out Population_T;
         Migrants   : in     Migrants_T;
         Resultats  : in     Resultat_Tournois_T
      )
   is
   begin
      Population_P.Accueillir_Migrants
         (
            Population => Population.Pop,
            Migrants   => Migrants.Pop,
            Resultats  => Resultats.Pop
         );
   end Accueillir_Migrants;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   procedure Selectionner_Migrants
      (
         Population : in     Population_T;
         Migrants   :    out Migrants_T;
         Resultats  :    out Resultat_Tournois_T
      )
   is
   begin
      Population_P.Selectionner_Migrants
         (
            Population => Population.Pop,
            Migrants   => Migrants.Pop,
            Resultats  => Resultats.Pop
         );
   end Selectionner_Migrants;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   --                             Partie privée                             --
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   procedure Trier
      (Population : in out Table_Population_T)
   is
   begin
      Trier_Individus (Tableau => Population);
   end Trier;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   function Comparer
      (
         Gauche : in     Individu_P.Individu_T;
         Droite : in     Individu_P.Individu_T
      )
      return Boolean
   is
   begin
      return Compareteur
         (
            Gauche => Gauche,
            Droite => Droite
         );
   end Comparer;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   function Comparer_Minimiser
      (Gauche, Droite : in     Individu_P.Individu_T)
      return Boolean
   is
      use type Individu_P.Individu_T;
   begin
      return Gauche < Droite;
   end Comparer_Minimiser;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   function Comparer_Maximiser
      (Gauche, Droite : in     Individu_P.Individu_T)
      return Boolean
   is
      use type Individu_P.Individu_T;
   begin
      return Gauche > Droite;
   end Comparer_Maximiser;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   procedure Echanger
      (
         Population     : in out Table_Population_T;
         Gauche, Droite : in     ID_Population_G_T
      )
   is
      Tmp : constant Individu_P.Individu_T := Population (Gauche);
   begin
      Population (Gauche) := Population (Droite);
      Population (Droite) := Tmp;
   end Echanger;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   function Choisir_Pivot_Deterministe
      (Premier, Dernier : in     ID_Population_G_T)
      return ID_Population_G_T
   is
      pragma Unreferenced (Dernier);
   begin
      return Premier;
   end Choisir_Pivot_Deterministe;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   function Choisir_Pivot_Aleatoire
      (Premier, Dernier : in     ID_Population_G_T)
      return ID_Population_G_T
   is
      subtype ID_Sous_Table_T is ID_Population_G_T range Premier .. Dernier;

      package Pivot_Aleatoire is new
         Ada.Numerics.Discrete_Random (Result_Subtype => ID_Sous_Table_T);

      Generateur : Pivot_Aleatoire.Generator;
   begin
      Pivot_Aleatoire.Reset (Gen => Generateur);
      return Pivot_Aleatoire.Random (Gen => Generateur);
   end Choisir_Pivot_Aleatoire;
   ---------------------------------------------------------------------------

end A_E_P.Outils_G;
