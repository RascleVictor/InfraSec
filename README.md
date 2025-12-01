# Infra-Secure – Infrastructure as Code avec Terraform et Ansible

## Table des matières

1. [Présentation du projet](#présentation-du-projet)
2. [Architecture](#architecture)
3. [Technologies utilisées](#technologies-utilisées)
4. [Démarche et étapes](#démarche-et-étapes)
5. [Configuration Terraform](#configuration-terraform)
6. [Configuration Ansible](#configuration-ansible)
7. [Problèmes rencontrés et solutions](#problèmes-rencontrés-et-solutions)
8. [Comment lancer le projet](#comment-lancer-le-projet)
9. [Conclusion](#conclusion)

---

## Présentation du projet

Le projet **Infra-Secure** a pour objectif de simuler la création d’une infrastructure cloud sécurisée et automatisée, comprenant :

- Un **VPC** avec des sous-réseaux publics et privés
- Une instance **Bastion** pour gérer les accès SSH
- Une base de données **PostgreSQL**
- Un service de **monitoring**
- Utilisation de **LocalStack** pour simuler les services AWS

L’infrastructure est **entièrement gérée en Infrastructure as Code**, grâce à **Terraform** pour le provisionnement et **Ansible** pour la configuration des services.


---

## Technologies utilisées

| Technologie | Rôle dans le projet |
|------------|-------------------|
| **Terraform** | Provisionnement de l’infrastructure (VPC, subnets, security groups, bastion, RDS simulé) |
| **Ansible** | Configuration des services (Bastion, PostgreSQL, Monitoring) |
| **LocalStack** | Simulation des services AWS en local |
| **Docker** | Conteneurisation de PostgreSQL et LocalStack |
| **PostgreSQL** | Base de données relationnelle simulée |
| **Python / psycopg2** | Gestion de la connexion PostgreSQL via Ansible |

---

## Démarche et étapes

1. **Création de l’infrastructure avec Terraform**
    - Définition du VPC, des subnets et des Security Groups
    - Simulation de l’instance Bastion et de la base RDS via LocalStack
    - Génération d’outputs pour faciliter la connexion Ansible

2. **Automatisation de la configuration avec Ansible**
    - Installation des packages sur le Bastion (git, htop, curl…)
    - Configuration de PostgreSQL (création de l’utilisateur et de la base)
    - Déploiement du service de monitoring

3. **Simulation et test en local**
    - Utilisation de containers Docker pour PostgreSQL et LocalStack
    - Connexion Ansible aux services via SSH simulé (`ansible_connection: local`)

---

## Configuration Terraform

- **VPC et Subnets** : séparés en publics et privés pour simuler un environnement sécurisé.
- **Security Groups** : règles strictes pour le Bastion et la base de données.
- **Bastion** : simulé via `null_resource` dans LocalStack pour éviter les limitations de la version gratuite.
- **RDS/PostgreSQL** : simulé ou container Docker pour éviter les limitations LocalStack.

---

## Configuration Ansible

- **Roles** : Bastion, PostgreSQL, Monitoring
- **Inventories** : connexion locale pour les containers (`ansible_connection: local`)
- **Variables** : définies dans `group_vars/all.yml`
- **Tasks** : mise à jour du cache APT, installation de packages, création de l’utilisateur PostgreSQL, création de la base, configuration du SSH

---

## Problèmes rencontrés et solutions

| Problème | Solution |
|----------|---------|
| LocalStack gratuit ne supporte pas RDS | Simulation via container PostgreSQL et `null_resource` pour Bastion |
| psycopg2 manquant pour Ansible | Installation via `python3-psycopg2` ou virtualenv Python pour Ansible |
| Variables Ansible non définies | Définition correcte dans `group_vars/all.yml` |
| Erreurs de connexion SSH / ports | Connexion locale pour les containers (`ansible_connection: local`) |
| Erreurs `apt update` dans Ansible | Vérification du cache APT, ajout de `update_cache: yes` |

---

## Comment lancer le projet

1. **Démarrer Docker Compose**
```bash
docker-compose up -d

terraform init
terraform apply -auto-approve

ansible-playbook -i inventories/local/hosts.yml playbooks/site.yml

