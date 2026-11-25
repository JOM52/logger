#!/bin/bash
# Met a jour GitHub (JOM52/airsens) depuis le Pi : commit local, pull (fusion), push
# Usage : bash ~/projets_jo/airsens/maj_github.sh

# Pause finale, meme en cas d'erreur
trap 'echo; read -r -p "Appuyer sur Entree pour terminer..." _' EXIT

cd "$(dirname "$0")" || exit 1

git add .
if ! git diff --cached --quiet; then
    echo "== Fichiers modifies :"
    git status --short
    echo
    read -r -p "Message du commit (Entree = date du jour) : " MSG
    [ -z "$MSG" ] && MSG="Mise a jour Pi $(date '+%d.%m.%Y %H:%M')"
    git commit -m "$MSG" || { echo "ERREUR commit"; exit 1; }
fi

echo "== Recuperation et fusion des modifications (git pull)"
if ! git pull --no-rebase --no-edit; then
    echo
    echo "CONFLIT : corriger les fichiers marques <<<<<<< / >>>>>>>,"
    echo "puis : git add . && git commit --no-edit && git push"
    exit 1
fi

echo "== Envoi (git push)"
git push || { echo "ERREUR git push"; exit 1; }
echo
echo "GitHub et le Pi sont a jour."