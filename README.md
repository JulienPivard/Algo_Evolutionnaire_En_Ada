# Implémentation en Ada d'un algorithme évolutionnaire

Les algorithmes évolutionnaire utilisent la théorie de l'évolution pour
résoudre des problèmes complexe qui sont trop long, ou qui demande trop de
ressources, pour être résolu efficacement par des algorithmes
déterministe classique.

Considérons que l'on veut trouver les valeurs des paramètres qui minimisent le
résultat d'une fonction. Un individu sera composé, pour chaque paramètre, d'une
valeur et du résultat de la fonction par rapport à ceux-ci (chaque individu est
une solution du problème). Une population sera composée de `n` individus.
À chaque génération, on applique la formule à tous les individus pour
déterminer son résultat, puis on tri les individus dans l'ordre croissant. Une
partie d'entre eux sera éliminé (il existe différentes façon de les
sélectionner) puis remplacé par des nouveaux issu d'accouplements entre les
survivants, de sélection aléatoire, d'un mélange de ces solutions, ou autres.

La pression de l'environnement est simulée par la fonction à optimiser. Le
génome d'un individu correspond aux paramètres de la fonction à résoudre, enfin
le résultat d'un individu, par l'application de la formule sur son génome,
correspond à son phénotype (l'expression de ses gènes dans l'environnement).

# Implémentation

Durant la phase d'initialisation, les valeurs des paramètres de tous les
individus de la population sont choisies au hasard dans l'intervalle de
valeurs autorisée pour chacune. Par exemple, si nous avons deux variables
`X` et `Y` avec `X` contraint dans l'intervalle `0 .. 100` et `Y`
contraint dans l'intervalle `-100 .. 0`, alors toutes les valeurs
aléatoires choisi pour `X` seront dans l'intervalle `0 .. 100` inclut, et
toutes celles de `Y` seront dans l'intervalle `-100 .. 0` inclut.

Une fois les valeurs des paramètres choisies, on applique la formule
à minimiser à tous les individus de la population et on l'enregistre dans
l'individu. Puis on tri nos individu en fonction du résultat du plus petit
au plus grand (l'inverse dans le cas d'une maximisation).

La phase d'initialisation est terminée.

Dans la version actuelle, on élimine les 25% de la population les moins
bien adapté, puis on va les remplacer, pour moitié, par de nouveaux
individus généré totalement au hasard, et, pour le reste, par des
individus issus d'accouplements dont les parents sont choisis au hasard.
(Tous les individus survivants ont les mêmes chances d'être sélectionné,
c'est ici qu'il faudrait introduire la sélection par tournois).

Avant de lancer la repopulation, on va vérifier que la population n'as pas
atteint un état de stagnation génétique. Celle-ci est atteinte quand le
génome de tous les individus est très similaire, et que donc l'expression
de celui-ci (ie. le résultat de la fonction pour chaque individu) est
considéré comme égal. On va donc comparer chaque individu survivant
à celui qui est le plus adapté. Si, pendant 25 générations d'affilé, tous
les individus survivants sont similaire à l'individu le plus adapté, alors
la population à atteint un état de stagnation génétique, il n'y aura plus
d'évolution possible. Nous avons notre résultat. Dans le cas d'une valeur
de résultat unique, on peux prendre la valeur la plus basse (la plus haute
si on veux maximiser) et considérer qu'elles sont égales à +/-0.5

Chaque accouplement ne donne qu'un seul nouvel individu, chaque variable
est considéré comme un gène. Pour créer le gène du nouvel individu, il
existe 5 scénarios équiprobable :
* On prend seulement le gène du père;
* On prend seulement le gène de la mère;
* On fait la moyenne des deux;
* On prend la mantisse du père et l'exposant de la mère;
* On prend la mantisse de la mère et l'exposant du père.

Viens ensuite la phase de mutation des nouveaux nés. Celle-ci a environ
10% de chances de se produire pour chaque enfant. Chacun des scénarios de
mutation a autant de chances de se produire qu'un autre, et ce,
indépendamment du scénarios d'accouplement choisi précédemment.
* On prend l'écart entre les valeurs de la variable des deux parents, et
  on choisi une valeur aléatoirement dans cet intervalle puis on l'ajoute
  à la valeur de la variable de l'enfant;
* On ajoute une valeur aléatoire prise entre 0 et 1;
* On retire une valeur aléatoire prise entre 0 et 1;
* On inverse le signe.

On vérifie que les variables font bien partit de l'intervalle de valeurs
autorisées, si ce n'est pas le cas on les ajuste sur le maximum, ou le
minimum selon le plus proche.

Une fois tous les nouveaux individu généré, on applique la formule sur les
nouveaux nés, puis on applique une mécanique de tournois sur 8% de la
population total. Seul les individus survivants sont éligible. Le perdant
du tournoi se voit remplacer par l'enfant de l'accouplement des deux
vainqueurs. Le nombre de tournois joué correspond à 8% de la population
total, et le nombre de participants par tournoi correspond à 8% lui aussi.
Après l'ajout de la sélection par tournois, le nombre de générations
nécessaire à été divisé par deux passant de environ 80-90 pour 1000
individus, à 40-45 toujours pour 1000 individus. Le temps total lui n'a
que très peu diminué.

Ultime étape, on tri la population. La génération vient de finir, on
recommence le cycle.

# Facteurs d'influence sur le temps de calcul et la précision

## Taille des intervalles de variables

La taille de l'intervalle autorisé pour chaque variable à une influence
direct sur la précision du résultat (à taille de population fixé). Plus
l'intervalle sera grand, et plus il faudra une population nombreuse pour
arriver à un résultat concluent. Après plusieurs essais, je n'ai pas
trouvé de formule toutes faites pour savoir de combien il fallait
augmenter la taille de la population en fonction de la taille de
l'intervalle.

## Nombre de variables

L'augmentation du nombre de variables va avoir une influence direct sur la
précision du résultat puisqu'on se retrouve très vite avec une explosion
du nombre de combinaison. Paradoxalement, le nombre de générations pour
obtenir un résultat ne semble pas augmenter de manière significative. Pour
retrouver un bon niveau de précision, il nous faut augmenter la taille de
la population, d'après mes essais, il faut la multiplier par 10 pour
chaque variable ajouté.

## Taille de la population de départ

La taille de la population à une influence direct sur le temps de calculs
et sur la précision du résultats obtenu, notamment à cause des phases de
tri. Une population trop petite aura tendance à tomber facilement dans des
minima locaux.

# Compilation des demo

## Environnement

Pour compiler, il vous faut un compilateur Ada. Vous trouverez le
compilateur Gnat de Adacore sur leur site dans l'onglet communauté.

## Compilation

Par défaut toutes les démos sont compilées dans la version actuelle. Pour
compiler, il suffit de taper dans un terminal :

```sh
make
```

Le résultat de la compilation se trouvera dans `./bin/debug/executable` ou
dans `./bin/release/executable` selon les options choisie dans le fichier
`makefile.conf`.

## Contenu des démos

### Démo 1

Le but est ici de minimiser une surface en jouant sur le diamètre du
cylindre pour un volume donné. Nous avons donc un paramètre et le
résultat.

### Démo 2

Une formule prise au hasard, toujours avec un seul paramètre, le but est
de minimiser son résultat en jouant sur la valeur de `X`. Le but est ici
de voir à partir de quelle taille de population on obtient un résultat
fiable (On trouve le minimum 99% du temps). L'intervalle de valeurs
autorisé pour `X` est volontairement grand.

### Démo 3

Une autre formule prise au hasard, mais on a cette fois ci deux
paramètres, `X` et `Y`, à faire varier pour minimiser le résultat de la
fonction. Le but est d'observer l'impact de l'augmentation du nombre
d'inconnues sur la précision du résultat. Réduire la taille de 200
individus à 150 nous fait passer sous la barre des 99% des chances de
trouver le minimum.

# Résultats à l'exécution

Les résultats de l'exécution :
* OS : GNU/linux avec CPU : Intel Pentium P6000; 1.87GHz; 2 core;
  1 thread/core : [Site ark Intel Pentium](https://ark.intel.com/fr/products/49058/Intel-Pentium-Processor-P6000-3M-Cache-1_86-GHz)
* OS : MacOS avec CPU : Intel Core i5; 2,7GHz; 2 core; 2 thread/core :
  [Site ark Intel Core i5](https://ark.intel.com/fr/products/85212/Intel-Core-i5-5200U-Processor-3M-Cache-up-to-2_70-GHz)

## Résultat sur la machine exécutant GNU/Linux

### Compilé en version debug

```
Population   : 1000
Formule : pi * (D^2 / 2) + 4 * (160 / D)
Minimum :  | D :   5.884 [0.000 .. 1100.000]  |<>|  |=> Résultat : 163.153
+=======
Nombre de générations :  74
Temps total :
         0.8352 s


Population   : 1000
Formule : 10 + X^2 - 10 * cos (2 * pi * X)
Minimum :  | X :   0.000 [-10000.000 .. 10000.000]  |<>|  |=> Résultat :   0.000
+=======
Nombre de générations :  96
Temps total :
         0.7388 s


Population   : 1000
Formule : sin (X + Y) + (X - Y)^2 - 1.5X + 2.5Y + 1.0
Minimum :  | X :  -0.550 [-1.000 .. 100.000]  | Y :  -1.549 [-2.000 .. 100.000]  |<>|  |=> Résultat :  -1.913
+=======
Nombre de générations :  102
Temps total :
         0.9255 s
```

### Compilé en version optimisé

La compilation se fait avec la commande `make prod` ou alors en modifiant
la variable `ACTIVER_DEBUG` dans le fichiers `makefile.conf` puis de
compiler avec `make`.

```
Population   : 1000
Formule : pi * (D^2 / 2) + 4 * (160 / D)
Minimum :  | D :   5.884 [0.000 .. 1100.000]  |<>|  |=> Résultat : 163.153
+=======
Nombre de générations :  72
Temps total :
         0.0466 s


Population   : 1000
Formule : 10 + X^2 - 10 * cos (2 * pi * X)
Minimum :  | X :  -0.000 [-10000.000 .. 10000.000]  |<>|  |=> Résultat :   0.000
+=======
Nombre de générations :  90
Temps total :
         0.0369 s


Population   : 1000
Formule : sin (X + Y) + (X - Y)^2 - 1.5X + 2.5Y + 1.0
Minimum :  | X :  -0.539 [-1.000 .. 100.000]  | Y :  -1.540 [-2.000 .. 100.000]  |<>|  |=> Résultat :  -1.913
+=======
Nombre de générations :  109
Temps total :
         0.0558 s
```

## Résultat sur la machine exécutant MacOs

### Compilé en version debug

```
Population   : 1000
Formule : pi * (D^2 / 2) + 4 * (160 / D)
Minimum :  | D :   5.884 [0.000 .. 1100.000]  |<>|  |=> Résultat : 163.153
+=======
Nombre de générations :  72
Temps total :
         0.3985 s


Population   : 1000
Formule : 10 + X^2 - 10 * cos (2 * pi * X)
Minimum :  | X :   0.000 [-10000.000 .. 10000.000]  |<>|  |=> Résultat :   0.000
+=======
Nombre de générations :  89
Temps total :
         0.2687 s


Population   : 1000
Formule : sin (X + Y) + (X - Y)^2 - 1.5X + 2.5Y + 1.0
Minimum :  | X :  -0.551 [-1.000 .. 100.000]  | Y :  -1.550 [-2.000 .. 100.000]  |<>|  |=> Résultat :  -1.913
+=======
Nombre de générations :  93
Temps total :
         0.4321 s
```

### Compilé en version optimisé

La compilation se fait avec la commande `make prod` ou alors en modifiant
la variable `ACTIVER_DEBUG` dans le fichiers `makefile.conf` puis de
compiler avec `make`.

```
Population   : 1000
Formule : pi * (D^2 / 2) + 4 * (160 / D)
Minimum :  | D :   5.885 [0.000 .. 1100.000]  |<>|  |=> Résultat : 163.153
+=======
Nombre de générations :  70
Temps total :
         0.0262 s


Population   : 1000
Formule : 10 + X^2 - 10 * cos (2 * pi * X)
Minimum :  | X :   0.000 [-10000.000 .. 10000.000]  |<>|  |=> Résultat :   0.000
+=======
Nombre de générations :  95
Temps total :
         0.0260 s


Population   : 1000
Formule : sin (X + Y) + (X - Y)^2 - 1.5X + 2.5Y + 1.0
Minimum :  | X :  -0.543 [-1.000 .. 100.000]  | Y :  -1.545 [-2.000 .. 100.000]  |<>|  |=> Résultat :  -1.913
+=======
Nombre de générations :  108
Temps total :
         0.0389 s
```

# TODO
- [x] Ajouter une mécanique de sélection par tournois; (En plus du tri et
  de l'élimination des 25%)
- [ ] Selection par tournois pour la partie principale;
- [x] Parallélisation par découpage en plusieurs populations avec échange
  d'individus;
- [ ] Possibilité de limiter les échanges de population aux îlots proches
  (processeur voisin).
