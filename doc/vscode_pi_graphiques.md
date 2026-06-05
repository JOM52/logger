# VS Code + Raspberry Pi — Graphiques Python

## Prérequis (à faire une seule fois)

### 1. Installer les librairies sur le Pi
```bash
pip install ipykernel pandas matplotlib mysql-connector-python --break-system-packages
pip install "matplotlib_inline<0.2" --break-system-packages
```

### 2. Monter le Pi en local (sur la machine jo)
```bash
mkdir -p /home/jo/pi
sshfs pi@192.168.1.165:/home/pi /home/jo/pi
```
Pour démonter : `fusermount -u /home/jo/pi`

---

## Afficher des graphiques dans VS Code

### Option A — Notebook `.ipynb` (recommandée)

1. Ouvrir VS Code
2. `Ctrl+Shift+P` → **Remote-SSH: Connect to Host** → `pi@192.168.1.165`
3. Vérifier la barre verte en bas à gauche : `SSH: 192.168.1.165`
4. Installer l'extension **Python** côté Pi : Extensions (`Ctrl+Shift+X`) → chercher Python → **Install in SSH**
5. Ouvrir `/home/pi/projets_jo/logger/graphiques.ipynb`
6. Sélectionner le kernel Python 3 (bouton en haut à droite)
7. Lancer toutes les cellules : **Ctrl+F9**

Les graphiques s'affichent directement sous chaque cellule.

### Option B — Script `.py` avec cellules interactives

Ajouter `# %%` dans un script `.py` pour créer des cellules Jupyter :

```python
# %%
import matplotlib.pyplot as plt
import pandas as pd

# %%
plt.plot([1, 2, 3], [10, 20, 15])
plt.show()
```

Clic droit → **Run Current Cell** ou `Shift+Enter` sur une cellule.  
Les graphiques s'affichent dans le panneau **Interactive Window**.

---

## Fichiers du projet logger

| Fichier | Rôle |
|---|---|
| `logger.py` | Acquisition capteurs DS18B20 + DS2413, enregistrement MySQL |
| `graphiques.ipynb` | Visualisation interactive des données |
| `analyse.ipynb` | Analyse avancée |

## Service systemd

```bash
# Voir le statut
sudo systemctl status logger-jo

# Changer l'intervalle (fichier : /etc/systemd/system/logger-jo.service)
# RestartSec=60  → 1 minute entre chaque mesure

# Recharger après modif
sudo systemctl daemon-reload && sudo systemctl restart logger-jo
```

## Base de données MariaDB

- IP : `192.168.1.165`
- User : `root` / Password : `mablonde`
- DB : `logger`, table principale : `tlog`
- Colonnes : `t0`–`t16` (températures °C), `s10`–`s31` (états 0/1), `time_stamp`
- Valeur `-333` = erreur capteur (à filtrer)

## Dépannage

| Problème | Solution |
|---|---|
| Bouton "Install additional debugger" | Installer l'extension Python côté SSH (pas en local) |
| `AttributeError: RcParams._get` | `pip install "matplotlib_inline<0.2" --break-system-packages` |
| Montage sshfs perdu | Relancer `sshfs pi@192.168.1.165:/home/pi /home/jo/pi` |
| Kernel non trouvé | `pip install ipykernel --break-system-packages` sur le Pi |
