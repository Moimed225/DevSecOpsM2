# TaskFlow API — projet fil rouge DevSecOps

Petite API de gestion de tâches (Flask + SQLite) utilisée pendant les 6 TP du module
DevSecOps (MAST CYBER A2, NEXA Digital School).

> **Attention** : ce projet contient **volontairement** des failles de sécurité
> (code, dépendances, image, infrastructure, pipeline). Il sert uniquement à
> l'apprentissage. **Ne jamais le déployer** sur un environnement réel.

## Contenu

| Dossier | Contenu | TP |
|---|---|---|
| `app/`, `tests/` | API Flask et tests pytest | 1, 2 |
| `requirements.txt` | Dépendances Python | 3 |
| `Dockerfile` | Image de l'application | 3, 5 |
| `infra/` | Terraform (AWS) — à analyser, pas à appliquer | 4 |
| `k8s/`, `charts/taskflow/` | Manifests Kubernetes et chart Helm | 4 |
| `audit/pipeline-a-auditer.yml` | Pipeline fourni pour le mini-audit | 6 |

## Démarrage

```bash
# 1. Créer votre propre dépôt GitHub (public) vide, puis :
git remote add origin https://github.com/<votre-compte>/nexa-taskflow.git
git push -u origin main

# 2. Lancer les tests en local
python -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt
pytest

# 3. Lancer l'application avec Docker
docker build -t taskflow:local .
docker run --rm -p 8085:8085 taskflow:local
curl http://localhost:8085/health
```

Gardez l'historique Git intact : il fait partie de l'exercice.

## Endpoints

| Méthode | Route | Rôle |
|---|---|---|
| GET | `/health` | État de l'API |
| GET | `/tasks?owner=...` | Lister les tâches d'un utilisateur |
| POST | `/tasks` | Créer une tâche (`{"title": "...", "owner": "..."}`) |
| POST | `/users` | Créer un utilisateur |
| GET | `/export?format=csv` | Exporter les tâches |
| POST | `/import` | Importer des tâches |
| GET | `/payment/status` | État du prestataire de paiement |

## Règles du jeu

- Les failles sont à **découvrir avec les outils** vus en cours, pas à chercher à la main.
- Chaque correction ou exception doit être **justifiée** dans votre pull request.
- Le scan DAST (TP 5) se fait **uniquement** sur votre instance locale ou dans votre CI.
