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

   type Voisins_T is array (Natural range <>) of Sommet_T;

   type Graphe_T is tagged private;

   function Sont_Adjacents
      (
         G : in     Graphe_T;
         X : in     Sommet_T;
         Y : in     Sommet_T
      )
      return Boolean;
   --  Teste s'il y a une arête de x à y;
   --  @param G
   --  Le graph de sommets.
   --  @param X
   --  Le premier sommet.
   --  @param Y
   --  Le deuxième sommet.

   function Lister_Les_Voisins
      (
         G : in     Graphe_T;
         X : in     Sommet_T
      )
      return Voisins_T;
   --  Liste les sommets qui sont adjacents à x;
   --  @param G
   --  Le graph de sommets.
   --  @param X
   --  Le sommet dont on veux lister les voisins.

   procedure Ajouter_Areste
      (
         G : in out Graphe_T;
         X : in     Sommet_T;
         Y : in     Sommet_T
      );
   --  Ajoute l'arête de x à y s'il n'y figure pas déjà;
   --  @param G
   --  Le graph de sommets.
   --  @param X
   --  Le premier sommet.
   --  @param Y
   --  Le deuxième sommet.
   procedure Ajouter_Areste
      (
         G : in out Graphe_T;
         X : in     Sommet_T;
         Y : in     Sommet_T;
         V : in     Poids_Areste_T
      );
   --  Ajoute l'arête de x à y s'il n'y figure pas déjà;
   --  @param G
   --  Le graph de sommets.
   --  @param X
   --  Le premier sommet.
   --  @param Y
   --  Le deuxième sommet.
   --  @param V
   --  Le poids du lien entre les sommets.
   procedure Ajouter_Areste_Orientee
      (
         G : in out Graphe_T;
         X : in     Sommet_T;
         Y : in     Sommet_T;
         V : in     Poids_Areste_T
      );
   --  Ajoute l'arête de x à y s'il n'y figure pas déjà;
   --  @param G
   --  Le graph de sommets.
   --  @param X
   --  Le premier sommet.
   --  @param Y
   --  Le deuxième sommet.
   --  @param V
   --  Le poids du lien entre les sommets.
   procedure Supprimer_Areste
      (
         G : in out Graphe_T;
         X : in     Sommet_T;
         Y : in     Sommet_T
      );
   --  Supprime l’arête de x à y si elle existe;
   --  @param G
   --  Le graph de sommets.
   --  @param X
   --  Le premier sommet.
   --  @param Y
   --  Le deuxième sommet.

   function Lire_Valeur_Sommet
      (
         G : in     Graphe_T;
         X : in     Sommet_T
      )
      return Poids_Sommet_T;
   --  Retourne la valeur associée à x;
   --  @param G
   --  Le graph de sommets.
   --  @param X
   --  Le premier sommet.
   procedure Fixer_Valeur_Sommet
      (
         G : in out Graphe_T;
         X : in     Sommet_T;
         V : in     Poids_Sommet_T
      );
   --  Fixe la valeur de x à v.
   --  @param G
   --  Le graph de sommets.
   --  @param X
   --  Le premier sommet.
   --  @param V
   --  Le poids du lien entre les sommets.

   function Lire_Valeur_Areste
      (
         G : in     Graphe_T;
         X : in     Sommet_T;
         Y : in     Sommet_T
      )
      return Poids_Areste_T;
   --  Retourne la valeur de l'arête (x, y);
   --  @param G
   --  Le graph de sommets.
   --  @param X
   --  Le premier sommet.
   --  @param Y
   --  Le deuxième sommet.
   procedure Fixer_Valeur_Areste
      (
         G : in out Graphe_T;
         X : in     Sommet_T;
         Y : in     Sommet_T;
         V : in     Poids_Areste_T
      );
   --  Fixe à v la valeur de l’arête (x, y).
   --  @param G
   --  Le graph de sommets.
   --  @param X
   --  Le premier sommet.
   --  @param Y
   --  Le deuxième sommet.
   --  @param V
   --  Le poids du lien entre les sommets.

private

   subtype Lignes_T   is Sommet_T;
   --  Les lignes de la matrice de sommets.

   subtype Colonnes_T is Sommet_T;
   --  Les colonnes de la matrice de sommets.

   type Areste_T is
      record
         Presente : Boolean        := False;
         --  Il y a une arrête entre les sommets.
         Poids    : Poids_Areste_T := Poids_Areste_T'Last;
         --  Le poids de l'arrête.
      end record;

   type Matrice_T is array (Lignes_T, Colonnes_T) of Areste_T;
   --  La matrice de sommets qui défini les liens entre eux.

   Matrice_Vide : constant Matrice_T :=
      Matrice_T'(others => (others => <>));

   type Table_Poids_Sommets_T is array (Sommet_T) of Poids_Sommet_T;
   --  Les poids des sommets.

   type Graphe_T is tagged
      record
         Matrice      : Matrice_T             := Matrice_Vide;
         --  Les liens entre les sommets.
         Poids_Sommet : Table_Poids_Sommets_T :=
            Table_Poids_Sommets_T'(others => Poids_Sommet_T'Last);
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
