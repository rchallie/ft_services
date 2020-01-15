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
