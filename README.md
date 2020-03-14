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
