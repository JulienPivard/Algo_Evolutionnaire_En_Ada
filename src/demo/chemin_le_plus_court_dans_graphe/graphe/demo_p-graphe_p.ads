--  @summary
--  Matrice pour le problème de l'informaticien en vacance.
--  @description
--  Matrice pour le problème de l'informaticien en vacance.
--  @group Graphe
package Demo_P.Graphe_P
   with
      Pure           => True,
      Preelaborate   => False,
      Elaborate_Body => False,
      Spark_Mode     => Off
is

   type Poids_Areste_T is range 0 .. 9;
   type Poids_Sommet_T is range 0 .. 9;

   type Voisins_T is array (Natural range <>) of Sommets_T;

   type Graphe_T is tagged private;

   function Sont_Adjacents
      (
         G : in     Graphe_T;
         X : in     Sommets_T;
         Y : in     Sommets_T
      )
      return Boolean;
   --  Teste s'il y a une arête de x à y;

   function Lister_Les_Voisins
      (
         G : in     Graphe_T;
         X : in     Sommets_T
      )
      return Voisins_T;
   --  Liste les sommets qui sont adjacents à x;

   procedure Ajouter_Areste
      (
         G : in out Graphe_T;
         X : in     Sommets_T;
         Y : in     Sommets_T
      );
   --  Ajoute l'arête de x à y s'il n'y figure pas déjà;
   procedure Ajouter_Areste
      (
         G : in out Graphe_T;
         X : in     Sommets_T;
         Y : in     Sommets_T;
         V : in     Poids_Areste_T
      );
   --  Ajoute l'arête de x à y s'il n'y figure pas déjà;
   procedure Supprimer_Areste
      (
         G : in out Graphe_T;
         X : in     Sommets_T;
         Y : in     Sommets_T
      );
   --  Supprime l’arête de x à y si elle existe;

   function Lire_Valeur_Sommet
      (
         G : in     Graphe_T;
         X : in     Sommets_T
      )
      return Poids_Sommet_T;
   --  Retourne la valeur associée à x;
   procedure Fixer_Valeur_Sommet
      (
         G : in out Graphe_T;
         X : in     Sommets_T;
         V : in     Poids_Sommet_T
      );
   --  Fixe la valeur de x à v.

   function Lire_Valeur_Areste
      (
         G : in     Graphe_T;
         X : in     Sommets_T;
         Y : in     Sommets_T
      )
      return Poids_Areste_T;
   --  Retourne la valeur de l'arête (x, y);
   procedure Fixer_Valeur_Areste
      (
         G : in out Graphe_T;
         X : in     Sommets_T;
         Y : in     Sommets_T;
         V : in     Poids_Areste_T
      );
   --  Fixe à v la valeur de l’arête (x, y).

private

   subtype Lignes_T   is Sommets_T;
   --  Les lignes de la matrice de sommets.

   subtype Colonnes_T is Sommets_T;
   --  Les colonnes de la matrice de sommets.

   type Areste_T is
      record
         Presente : Boolean        := False;
         --  Il y a une arrête entre les sommets.
         Poids    : Poids_Areste_T := Poids_Areste_T'First;
         --  Le poids de l'arrête.
      end record;

   type Matrice_T is array (Lignes_T, Colonnes_T) of Areste_T;
   --  La matrice de sommets qui défini les liens entre eux.

   type Table_Poids_Sommets_T is array (Sommets_T) of Poids_Sommet_T;
   --  Les poids des sommets.

   type Graphe_T is tagged
      record
         Matrice      : Matrice_T;
         --  Les liens entre les sommets.
         Poids_Sommet : Table_Poids_Sommets_T;
         --  Les poids des sommets.
      end record;

   --    A B C D E    --
   --  A X         A  --
   --  B   X       B  --
   --  C     X     C  --
   --  D       X   D  --
   --  E         X E  --
   --    A B C D E    --

end Demo_P.Graphe_P;
