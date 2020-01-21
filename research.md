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

## Minikube
On considèrera minikube comme étant une node.<br>
<a name="minikube_inst"></a>
### Installation de minikube
- Il est nécessaire d'installer [Homebrew](https://brew.sh/index_fr)
- `$ brew install minikube`, minikube s'installera normalement sans trop de difficulté.

<a name="minikube_start"></a>
### Démarage de minikube
- `$ minikube start`, lancera minikube
	- `-p <name>`, créera une node minikube avec un nom custom
	- `--vm-driver=<VMApp>`, lancera minikube sous l'application VM choisi _(Exemple : virtualbox)_

<a name="minikube_access"></a>
### Accès à minikube
De base la VM minikube se lance en mode `headless`, c'est à dire sans ouvrir de fenètre, on peut toute fois y accèdes par `ssh`.
- `minikube ssh`, permettera d'accéder à minikube
	- `-p <name>`, précisera la node minikube auquel on veux accéder

<a name="minikube_stop"></a>
### Arret de minikube
- `minikube stop`, arrètera la node minikube
	- `-p <name>`, précisera la node à arréter

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

### Sources :
- [xadki](https://www.youtube.com/watch?v=37VLg7mlHu8&list=PLn6POgpklwWqfzaosSgX2XEKpse5VY2v5&index=1)
