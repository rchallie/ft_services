# Kubernetes

## <u>Kubernetes :</u> Du grec timonier ou pilote :
Basiquement "Borg" créer et utilisé par Google, il est une "extraction" de ce dernier
pour être utilisable par la communautée des dévellopers et reverser à la CNCF _(Voir [Définition](#cncf))_.
En 2014 Google avait 2 milliards de conteneurs lancés par semaines

On dit que kubernetes est un orchestrateur de conteneur. Faire de l'abstraction (gestion indépendante) avec la notion de service.
Concu pour avoir une production importante, toujour garder de la disponibilité et garde les conteneurs up.
Permet de lancer de multiples instances du même service en fonction de paramètres sans soucis.
Tout ça, peut importe le fournisseur _(Google cloud, aws, virtual machines...)_

### <u>Notions</u>:
- noeuds (serveurs) : physique ou virtuels
	- master ou simple noeud d'execution
- pods :
	- ensemble de conteuneurs qui à du sens
	- avec un ou plusieurs conteneurs
	- et une instance de kubernetes
- services : 
	- pour éviter la communications par ip (changeante car on est en conteneurs)
	- communication par service : service > ip/port > pods
	- un service est un couple ip/port qui permet de discuter entres les conteneurs
- volumes :
	- gestion des volumes (persistents ou non)
	- ce sont des lieux d'échanges entre les pods
	- lorsqu'il est à l'interieur des pods, il est non persistent
	- et à l'exterieur il l'est
- deployments : objet de gestion de déploiments
	- création / suppression
	- scaling : gestion de paramètres pour la montée en charge (ou réduction)
- namespaces : cluster virtuel (ensemble de services)
	- cloissone à l'intérieur du cluster (cohérence pour les droits, sécurté, cohérence général)

### <u>Pré-requis :</u>
#### Installer Kubernetes sous VM
	> Config de la VM recommandé :
	> 2 GB de ram
	> 2 GPU
	> ouverture réseau large entre les deux machines
	> pas de swap

#### Sous minikube
- [Installation de minikube](#minikube_inst)
- [Lancement de minikube](#minikube_start)
- [Accès à minikube](#minikube_access)
- [Arret de minikube](#minikube_stop)

### Le vif du sujet :
Les binaires qui peuvent être utilisés sont les suivants :
- kubeadm : installation d'un cluster
- kubelet : service qui tourne sur les machines (lancements de pods...)
- kubectl : permet la communication avec le cluster
Il est nécessaire de s'assurer que, si ils sont utiles et sont installés.

## Fonctionnement de Kubernetes
Le principe de base de kubernetes est de consevoir un "cluster" avec dans chacune des machines des pods _(Voir [Définition](#pod))_.
Ces pods sont gérés par des déploiements _(Voir [Définition](#pod))_.

## Minikube
On considèrera minikube comme étant un pseudocluster composé d'un noeud master et d'un noeud worker en même temps.<br>
<a name="minikube_inst"></a>
### Installation de minikube
- Il est nécessaire d'installer [Homebrew](https://brew.sh/index_fr)
- `$ brew install minikube`, minikube s'installera normalement sans trop de difficulté.

<a name="minikube_start"></a>
### Démarage de minikube
- `$ minikube start`, lancera minikube
	- `-p <name>`, créera une cluster minikube avec un nom custom
	- `--vm-driver=<VMApp>`, lancera minikube sous l'application VM choisi _(Exemple : virtualbox)_

<a name="minikube_access"></a>
### Accès à minikube
De base la VM minikube se lance en mode `headless`, c'est à dire sans ouvrir de fenètre, on peut toute fois y accèdes par `ssh`.
- `minikube ssh`, permettera d'accéder à minikube
	- `-p <name>`, précisera la cluster minikube auquel on veux accéder

<a name="minikube_stop"></a>
### Arret de minikube
- `minikube stop`, arrètera la cluster minikube
	- `-p <name>`, précisera la cluster à arréter

<a name="definition"></a>
## <u>Définition :</u>

<a name="cncf"></a>
### <u>CNCF (Cloud Native Computing Foundation):</u>
- Amazon
- Google
- Huawei
- Oracle
- Docker
- Citrix
- eBay
- Reddit
- Mastercard
- etc...

<a name="pod"></a>
### Pod :
Un Pod Kubernetes est un groupe d’un ou plusieurs conteneurs, liés entre eux à des fins d’administration et de mise en réseau.

<a name="deployement"></a>
### Déploiement :
Un déploiement fournit des mises à jour déclaratives pour les pods et les réplicas.

Vous décrivez un état souhaité dans un déploiement et le contrôleur de déploiement change l'état réel en l'état souhaité à un rythme contrôlé. Vous pouvez définir des déploiements pour créer de nouveaux ReplicaSets, ou pour supprimer des déploiements existants et adopter toutes leurs ressources avec de nouveaux déploiements.

Un Déploiement Kubernetes vérifie l’état de santé de votre Pod et redémarre le conteneur du Pod s’il se termine. Les déploiements sont le moyen recommandé pour gérer la création et la mise à l’échelle des Pods.

En gros ça gère les pods.

### Sources :
- [xadki](https://www.youtube.com/watch?v=37VLg7mlHu8&list=PLn6POgpklwWqfzaosSgX2XEKpse5VY2v5&index=1)
