# vim: nofoldenable: list:
# PIVARD Julien
# Dernière modification : Lundi 14 février[02] 2022

SHELL		:= /bin/sh
.DEFAULT_GOAL	:= all
# Les suffixes des fichiers dont on va tenir compte
.SUFFIXES:

srcdir		:= .

include ./config/makefile.fixe
ifeq ($(wildcard makefile.conf), )
    include ./config/makefile.conf.tmpl
else
    include ./makefile.conf
endif
include ./config/makefile.checks
include ./config/makefile.template

# Vérifie si le binaire existe. Sinon il ajoute la cible de compilation
# en dépendance.
ifeq ($(wildcard $(RESLT_COMPIL)), )
    DEPEND	= compiler
else
    DEPEND	=
endif

###################
config/makefile.conf.tmpl:

###################
makefile.conf: config/makefile.conf.tmpl
	cp ./config/makefile.conf.tmpl ./makefile.conf
	chmod u+w ./makefile.conf
	@echo " "

###################
.PHONY: run
run: $(DEPEND)
	$(RESLT_COMPIL) $(ARGUMENTSAPPLI)

###################
.PHONY: compiler
compiler: makefile.conf build
	@echo " ───────────────────────────────"
	@echo " [OK] Compilation du programme : [ $(NOMAPP) ] terminé"
	@echo "  "

###################
.PHONY: prod
prod: makefile.conf $(FAIRE_INITIALISATION)
	$(CC) -P$(GPR) $(OPT_GPR_PROD)
	@echo " ─────────────────────────────────────────────────────────────────"
	@echo " Résultat écrit dans [$(RESLT_COMPIL)]"
	@echo " ─────────────────────────────────────────────────────────────────"

###################
.PHONY: doc
doc: makefile.conf $(FAIRE_INITIALISATION)
	gnatls -v
	gnatdoc -P$(GPR) $(OPTGPR) $(OPTDOCUMENT)

###################
.PHONY: prove
prove: makefile.conf $(FAIRE_INITIALISATION)
	gnatprove -P$(GPR) $(OPTGPR) $(NIVEAU) $(RAPPORT) $(MODE_EXE)

###################
.PHONY: check
check: makefile.conf $(FAIRE_INITIALISATION)
	gnatcheck -P$(GPR) $(OPTGPR) $(OPT_CHECK)

###################
.PHONY: pretty
pretty: makefile.conf $(FAIRE_INITIALISATION)
	gnatpp -P$(GPR) $(Fichier)

###################
.PHONY: cleandoc
cleandoc: makefile.conf
	$(RM) $(OPTRM) doc

###################
.PHONY: help
help: makefile.conf
	@echo "Liste des commandes :"
	@echo " - all			: Compile l'application."
	@echo "    - build"
	@echo "    - compiler"
	@echo " - prod			: Compile avec l'option release active."
	@echo " - run			: Execute l'application avec les paramètres défini."
	@echo " - doc			: Génère la documentation du programme."
	@echo " "
	@echo " - clean 		: Efface tous les fichiers généré par le compilateur sauf les exécutables."
	@echo " - distclean		: Efface tous les fichiers généré par le compilateur."
	@echo " - cleandoc		: Supprime la documentation généré."
	@echo " "
	@echo " -  check		: Lance la vérification des règles de programmation sur les sources."
	@echo " -  prove		: Exécute l'outil gnatprove sur les fichiers sources."
	@echo " - pretty		: Reformate le fichier désigné par Fichier=/nom/du/fichier."
	@echo " "
	@echo " - compter		: Compte le nombre de lignes de code source."
	@echo "    - avec_find"
	@echo "    - avec_cloc"
	@echo " - compter_detail	: Compte le nombre de lignes de code source par fichier."
	@echo "    - avec_find_detail"
	@echo "    - avec_cloc_detail"
	@echo " "
	@echo " - maj_sous_modules	: Met à jour les sous modules"
	@echo " "
	@echo " - version_makefile	: La version des makefiles."
