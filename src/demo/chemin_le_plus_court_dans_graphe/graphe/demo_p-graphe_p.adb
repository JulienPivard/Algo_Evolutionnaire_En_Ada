package body Demo_P.Graphe_P
   with Spark_Mode => Off
is

   ---------------------------------------------------------------------------
   function Sont_Adjacents
      (
         G : in     Graphe_T;
         X : in     Sommets_T;
         Y : in     Sommets_T
      )
      return Boolean
   is
      Areste : Areste_T renames G.Matrice (X, Y);
   begin
      return Areste.Presente;
   end Sont_Adjacents;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   function Lister_Les_Voisins
      (
         G : in     Graphe_T;
         X : in     Sommets_T
      )
      return Voisins_T
   is
      Compteur : Natural := 0;
   begin
      Boucle_Compter_Nb_Voisins :
      for I in Sommets_T loop
         if G.Matrice (X, I).Presente or else G.Matrice (I, X).Presente then
            Compteur := Compteur + 1;
         end if;
      end loop Boucle_Compter_Nb_Voisins;

      Bloc_Lister_Voisins :
      declare
         subtype Tmp_T is Natural range 1 .. Compteur;
         Resultat : Voisins_T (Tmp_T);
      begin
         Compteur := 0;

         Boucle_Recenser_Voisins :
         for I in Sommets_T loop
            if G.Matrice (X, I).Presente or else G.Matrice (I, X).Presente then
               Compteur := Compteur + 1;
               Resultat (Compteur) := I;
            end if;
         end loop Boucle_Recenser_Voisins;

         return Resultat;
      end Bloc_Lister_Voisins;
   end Lister_Les_Voisins;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   procedure Ajouter_Areste
      (
         G : in out Graphe_T;
         X : in     Sommets_T;
         Y : in     Sommets_T
      )
   is
      Areste : Areste_T renames G.Matrice (X, Y);
   begin
      Areste.Presente := True;
   end Ajouter_Areste;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   procedure Ajouter_Areste
      (
         G : in out Graphe_T;
         X : in     Sommets_T;
         Y : in     Sommets_T;
         V : in     Poids_Areste_T
      )
   is
      Areste : Areste_T renames G.Matrice (X, Y);
   begin
      Areste.Presente := True;
      Areste.Poids    := V;
   end Ajouter_Areste;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   procedure Ajouter_Areste_Orientee
      (
         G : in out Graphe_T;
         X : in     Sommets_T;
         Y : in     Sommets_T;
         V : in     Poids_Areste_T
      )
   is
      Areste : Areste_T renames G.Matrice (X, Y);
   begin
      Areste.Presente := True;
      Areste.Poids    := V;
   end Ajouter_Areste_Orientee;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   procedure Supprimer_Areste
      (
         G : in out Graphe_T;
         X : in     Sommets_T;
         Y : in     Sommets_T
      )
   is
      Areste : Areste_T renames G.Matrice (X, Y);
   begin
      Areste.Presente := False;
   end Supprimer_Areste;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   function Lire_Valeur_Sommet
      (
         G : in     Graphe_T;
         X : in     Sommets_T
      )
      return Poids_Sommet_T
   is
   begin
      return G.Poids_Sommet (X);
   end Lire_Valeur_Sommet;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   procedure Fixer_Valeur_Sommet
      (
         G : in out Graphe_T;
         X : in     Sommets_T;
         V : in     Poids_Sommet_T
      )
   is
   begin
      G.Poids_Sommet (X) := V;
   end Fixer_Valeur_Sommet;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   function Lire_Valeur_Areste
      (
         G : in     Graphe_T;
         X : in     Sommets_T;
         Y : in     Sommets_T
      )
      return Poids_Areste_T
   is
      Areste : Areste_T renames G.Matrice (X, Y);
   begin
      return Areste.Poids;
   end Lire_Valeur_Areste;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   procedure Fixer_Valeur_Areste
      (
         G : in out Graphe_T;
         X : in     Sommets_T;
         Y : in     Sommets_T;
         V : in     Poids_Areste_T
      )
   is
      Areste : Areste_T renames G.Matrice (X, Y);
   begin
      Areste.Poids := V;
   end Fixer_Valeur_Areste;
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   --                             Partie privée                             --
   ---------------------------------------------------------------------------

end Demo_P.Graphe_P;
