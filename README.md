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
=======
Nombre de générations :  74
Temps total :
         0.8352 s


Population   : 1000
Formule : 10 + X^2 - 10 * cos (2 * pi * X)
Minimum :  | X :   0.000 [-10000.000 .. 10000.000]  |<>|  |=> Résultat :   0.000
=======
Nombre de générations :  96
Temps total :
         0.7388 s


Population   : 1000
Formule : sin (X + Y) + (X - Y)^2 - 1.5X + 2.5Y + 1.0
Minimum :  | X :  -0.550 [-1.000 .. 100.000]  | Y :  -1.549 [-2.000 .. 100.000]  |<>|  |=> Résultat :  -1.913
=======
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
=======
Nombre de générations :  72
Temps total :
         0.0466 s


Population   : 1000
Formule : 10 + X^2 - 10 * cos (2 * pi * X)
Minimum :  | X :  -0.000 [-10000.000 .. 10000.000]  |<>|  |=> Résultat :   0.000
=======
Nombre de générations :  90
Temps total :
         0.0369 s


Population   : 1000
Formule : sin (X + Y) + (X - Y)^2 - 1.5X + 2.5Y + 1.0
Minimum :  | X :  -0.539 [-1.000 .. 100.000]  | Y :  -1.540 [-2.000 .. 100.000]  |<>|  |=> Résultat :  -1.913
=======
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
=======
Nombre de générations :  72
Temps total :
         0.3985 s


Population   : 1000
Formule : 10 + X^2 - 10 * cos (2 * pi * X)
Minimum :  | X :   0.000 [-10000.000 .. 10000.000]  |<>|  |=> Résultat :   0.000
=======
Nombre de générations :  89
Temps total :
         0.2687 s


Population   : 1000
Formule : sin (X + Y) + (X - Y)^2 - 1.5X + 2.5Y + 1.0
Minimum :  | X :  -0.551 [-1.000 .. 100.000]  | Y :  -1.550 [-2.000 .. 100.000]  |<>|  |=> Résultat :  -1.913
=======
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
=======
Nombre de générations :  70
Temps total :
         0.0262 s


Population   : 1000
Formule : 10 + X^2 - 10 * cos (2 * pi * X)
Minimum :  | X :   0.000 [-10000.000 .. 10000.000]  |<>|  |=> Résultat :   0.000
=======
Nombre de générations :  95
Temps total :
         0.0260 s


Population   : 1000
Formule : sin (X + Y) + (X - Y)^2 - 1.5X + 2.5Y + 1.0
Minimum :  | X :  -0.543 [-1.000 .. 100.000]  | Y :  -1.545 [-2.000 .. 100.000]  |<>|  |=> Résultat :  -1.913
=======
Nombre de générations :  108
Temps total :
         0.0389 s
```

# TODO
- [ ] Ajouter une mécanique de sélection par tournois
- [ ] Parallélisation par découpage en plusieurs populations avec échange d'individus
- [ ] Possibilité de limiter les échanges de population aux îlots proches (processeur voisin)
