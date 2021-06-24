with Ada.Real_Time;

private with A_E_P.Outils_G;

generic

   Taille_Population : Taille_Population_T;
   --  La taille de la population à faire évoluer.

   type Parametres_G_T is private;
   --  Les paramètres de la fonction à résoudre,
   --  c'est une représentation du génome d'un individu.

   with procedure Generer
      (Parametres : in out Parametres_G_T);
   --  Génère des valeurs aléatoires pour les paramètres stocké.
   --  @param Parametres
   --  Les paramètres.

   with function Accoupler
      (
         Parametres : in     Parametres_G_T;
         Autre      : in     Parametres_G_T
      )
      return Parametres_G_T;
   --  Accouple deux paramètres pour obtenir un nouveau
   --  jeu de paramètres.
   --  @param Parametres
   --  Les paramètres, premier parent.
   --  @param Autre
   --  Les paramètres, second parent.
   --  @return Le jeu de paramètres issus de la combinaison des parents.

   type Resultat_Calcul_G_T is private;
   --  Le résultat du calcul de la formule avec les valeurs des paramètres.

   with function Calculer
      (Parametres : in     Parametres_G_T)
      return Resultat_Calcul_G_T;
   --  Calcul la formule en utilisant les valeurs de ses
   --  paramètres comme entrées de la fonction de la formule.
   --  @param Parametres
   --  Les paramètres de la fonction.

   with function Convergence_Adaptation
      (
         Reference : in     Resultat_Calcul_G_T;
         Actuelle  : in     Resultat_Calcul_G_T
      )
      return Boolean;
   --  Permet de régler la précision de la détection de convergence
   --  des individus vers un génome similaire. C'est grâce à ce
   --  critère que l'on mesure la diversité génétique de la
   --  population. Pour détecter si le minimum est atteint, on
   --  prend l'individu le mieux adapté comme référence, et si le
   --  résultat de chacun des autres individu survivant est dans
   --  l'intervalle valeur_de_référence +/- Intervalle_De_Convergence,
   --  alors on considère que la diversité génétique a disparu pour
   --  cette génération. Il faut que la diversité génétique ait
   --  disparue pendant 25 générations d’affilée pour que l'on
   --  déclare que le minimum a été trouvé.
   --  @param Reference
   --  La valeur à laquelle se référer.
   --  @param Actuelle
   --  La valeur à comparer à la référence.

   with procedure Put_Parametres
      (Item : in     Parametres_G_T);
   --  Procédure d'affichage du contenu des paramètres.
   --  @param Item
   --  Les paramètres.

   with procedure Put_Resultat
      (Item : in     Resultat_Calcul_G_T);
   --  Procédure d'affichage du contenu des résultats du calcul de la formule.
   --  @param Item
   --  Les résultats.

   with procedure Afficher_Formule;
   --  Affiche la formule qui va être résolue.

   with function "<"
      (Gauche, Droite : in     Resultat_Calcul_G_T)
      return Boolean
   is <>;
   --  Utilisé pour pouvoir trier les individus en
   --  fonction de leur adaptation.
   --  @param Gauche
   --  Le résultat à gauche de la comparaison.
   --  @param Droite
   --  Le résultat à droite de la comparaison.
   --  @return Gauche < Droite

   with function ">"
      (Gauche, Droite : in     Resultat_Calcul_G_T)
      return Boolean
   is <>;
   --  Utilisé pour pouvoir trier les individus en
   --  fonction de leur adaptation.
   --  @param Gauche
   --  Le résultat à gauche de la comparaison.
   --  @param Droite
   --  Le résultat à droite de la comparaison.
   --  @return Gauche > Droite

   Objectif : Objectif_T := Minimiser;
   --  Trouver les valeurs de paramètres qui vont
   --  minimiser ou maximiser le résultat de la fonction

--  @summary
--  Interface de regroupement pour utiliser l'algo évolutionnaire.
--  @description
--  Permet de n'avoir qu'un seul package à instancier
--  pour pouvoir utiliser cet algorithme.
--  @group Évolution
package A_E_P.Algo_Evolutionnaire_G
   with
      Pure           => False,
      Preelaborate   => False,
      Elaborate_Body => False,
      Spark_Mode     => Off
is

   type Population_T is private;
   --  La population à faire évoluer.

   procedure Faire_Evoluer
      (
         Population     : in out Population_T;
         Debut, Fin     :    out Ada.Real_Time.Time;
         Nb_Generations :    out Natural
      );
   --  Fait évoluer la population jusqu'à atteindre la
   --  convergence de ses individus.
   --  @param Population
   --  La population à faire évoluer.
   --  @param Debut
   --  Le chrono de début.
   --  @param Fin
   --  Le chrono de fin.
   --  @param Nb_Generations
   --  Le nombre de génération qu'il a fallut.

   procedure Initialiser
      (Population : in out Population_T)
      with Inline => True;
   --  Initialise les paramètres de toute une population.
   --  @param Population
   --  La population.

   procedure Put_Line
      (Item : in     Population_T)
      with Inline => True;
   --  Affiche le contenu d'un tableau de valeurs.
   --  @param Item
   --  La population à afficher.

   procedure Afficher_Details
      with Inline => True;
   --  Affiche la répartition détaillé des populations,
   --  des morts, des naissances et des mutants.

private

   package Outils_P is new A_E_P.Outils_G
      (
         Taille_Population      => Taille_Population,
         Parametres_G_T         => Parametres_G_T,
         Generer                => Generer,
         Accoupler              => Accoupler,
         Resultat_Calcul_G_T    => Resultat_Calcul_G_T,
         Calculer               => Calculer,
         Convergence_Adaptation => Convergence_Adaptation,
         Put_Parametres         => Put_Parametres,
         Put_Resultat           => Put_Resultat,
         Afficher_Formule       => Afficher_Formule,
         "<"                    => "<",
         ">"                    => ">",
         Objectif               => Objectif
      );

   type Population_T is
      record
         Pop : Outils_P.Population_T;
         --  La population.
      end record;

   type Id_Islot_T is mod 2**1;
   --  Identifiant des îlots.

   -----------------------------
   protected type Demarreur_T is
      entry Attendre
         (Population :    out Population_T);
      --  Attend l'autorisation de démarrage.
      --  @param Population
      --  La population de départ.
      procedure Demarrer
         (Population : in     Population_T);
      --  Autorise à démarrer avec une population de départ.
      --  @param Population
      --  La population de départ.
   private
      Demarrage_Autorise : Boolean := False;
      --  Drapeau de démarrage.
      Pop_Local        : Population_T;
      --  La population à transférer.
   end Demarreur_T;
   --  Contrôle le démarrage des îlots.

   type Table_De_Demarreurs_T is array (Id_Islot_T) of Demarreur_T;
   --  Pour définir les tables de transfert
   --  de population entre les îlots voisin.

   Table_De_Demarreurs : Table_De_Demarreurs_T;

   -----------------------------
   protected type Transfert_T is
      entry Attendre
         (Population :    out Outils_P.Migrants_T);
      --  Attend l'arrivée d'une population.
      --  @param Population
      --  La population qui arrive.
      procedure Envoyer
         (Population : in     Outils_P.Migrants_T);
      --  Envoi une population vers une autre île.
      --  @param Population
      --  La population à envoyer.
   private
      Echange_Autorise : Boolean := False;
      --  Une population est en attente de transfert.
      Pop_Local        : Outils_P.Migrants_T;
      --  La population à transférer.
   end Transfert_T;
   --  Permet à une population de passer d'une île à une autre.

   type Tables_De_Transfert_T is array (Id_Islot_T) of Transfert_T;
   --  Pour définir les tables de transfert
   --  de population entre les îlots voisin.

   Tables_De_Transfert : Tables_De_Transfert_T;
   --  Table de transfert de population.

   -----------------------------
   task type Islot_T (Id : Id_Islot_T) is
   end Islot_T;
   --  Un îlot de population qui évolue en vase clôt jusqu'à ce qu'un
   --  échange ait lieu.

   Islot_1 : Islot_T (Id => 0);
   Islot_2 : Islot_T (Id => 1);

end A_E_P.Algo_Evolutionnaire_G;
