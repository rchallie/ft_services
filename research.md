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
	[xadki](https://www.youtube.com/watch?v=37VLg7mlHu8&list=PLn6POgpklwWqfzaosSgX2XEKpse5VY2v5&index=1)
