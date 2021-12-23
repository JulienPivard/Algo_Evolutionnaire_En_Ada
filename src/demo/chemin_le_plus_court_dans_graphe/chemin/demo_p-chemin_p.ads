with Demo_P.Graphe_P;

--  @summary
--  Un chemin entre deux sommets.
--  @description
--  Un chemin entre deux sommets.
--  @group Graphe
package Demo_P.Chemin_P
   with
      Pure           => True,
      Preelaborate   => False,
      Elaborate_Body => False,
      Spark_Mode     => Off
is

   E_Sommet_Deja_Ajoute : exception;

   type Chemin_T is tagged private;
   --  Un chemin entre deux points.

   procedure Ajouter
      (
         Chemin           : in out Chemin_T;
         Sommet           : in     Sommet_T;
         Ajout_Est_Reussi :    out Boolean
      );
   --  Ajoute un sommet à la suite du chemin.
   --  Chaque sommet ne peux apparaitre qu'une seule fois.
   --  @param Chemin
   --  Le chemin
   --  @param Sommet
   --  Le sommet à ajouter.
   --  @param Ajout_Est_Reussi
   --  L'ajout du sommet, au chemin, est réussi.

   function Est_Valide
      (
         Chemin : in     Chemin_T;
         Graphe : in     Graphe_P.Graphe_T
      )
      return Boolean;
   --  Vérifie que le chemin est un chemin valide sur le graphe.
   --  @param Chemin
   --  Le chemin.
   --  @param Graphe
   --  Le graphe.
   --  @return Le chemin est un chemin valide du graphe.

   function Calculer_Score
      (
         Chemin : in     Chemin_T;
         Graphe : in     Graphe_P.Graphe_T
      )
      return Score_T;
   --  Calcule le cout (ou score) du chemin.
   --  @param Chemin
   --  Le chemin à évaluer.
   --  @param Graphe
   --  Le graphe de sommets.
   --  @return Le score du chemin.

   function Sommets_Sont_Uniques
      (Chemin : in     Chemin_T)
      return Boolean;
   --  Chaque sommet n'apparait qu'une seule et unique fois.
   --  @param Chemin
   --  Le chemin.
   --  @return Chaque sommet n'apparait qu'une fois.

   function Est_Plein
      (Chemin : in     Chemin_T)
      return Boolean;
   --  Vérifie si le chemin est complet.
   --  @param Chemin
   --  Le chemin.
   --  @return Toutes les étapes du chemin sont présentes.

   function Sommet_Est_Present
      (
         Chemin : in     Chemin_T;
         Sommet : in     Sommet_T
      )
      return Boolean;
   --  Vérifie si le sommet est présent dans le chemin.
   --  @param Chemin
   --  Le chemin.
   --  @param Sommet
   --  Le sommet.
   --  @return Le sommet est dans le chemin.

private

   Premier : constant Sommet_T := Sommet_T'First;
   Dernier : constant Sommet_T := Sommet_T'Last;

   type Apparition_Sommets_T is array (Sommet_T) of Boolean;

   type Position_T is range 1 .. Apparition_Sommets_T'Length;

   type Table_Sommets_T is array (Position_T) of Sommet_T;

   type Chemin_T is tagged
      record
         Sommets    : Table_Sommets_T := Table_Sommets_T'(others => Premier);
         --  Le chemin.
         Pos_Fin    : Position_T := Position_T'First;
         --  Position du dernier sommet du chemin.
         Nb_Sommets : Natural    := 0;
         --  Le nombre de sommets sur le chemin.
      end record;

   ------------------
   function Est_Plein
      (Chemin : in     Chemin_T)
      return Boolean
   is (Chemin.Pos_Fin = Position_T'Last);

end Demo_P.Chemin_P;
