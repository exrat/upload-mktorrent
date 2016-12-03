# Script d'upload rapide rTorrent avec mktorrent 

 D'après le script d'Aerya | https://upandclear.org

 https://upandclear.org/2016/09/29/script-simpliste-de-creation-de-torrent/

### Installation (en /home/user)
```
cd /tmp
git clone https://github.com/exrat/upload-mktorrent
cp /tmp/upload-mktorrent/up.sh /home/user/up.sh
chmod a+x /home/user/up.sh
```

 Modifier les variables en début:
```
# User ruTorrent & URL d'annonce
USER=toto
TRACKER="https://annonce.tracker.bt"
```

* Dans tous les cas, les fichiers sources sont en /home/user/torrents
* En cas de non mise en seed, le fichier .torrent sera stocké en /home/user

### 3 Utilisations possible
 
* Full auto, taille de pièces & mise en seed automatique
```
./up.sh --auto fichier.xx (ou dossier)
```
![picture alt](https://cloud.githubusercontent.com/assets/10530469/20858906/b737792e-b94f-11e6-8f9b-e1e6f123ca9b.png)

* Choix de mise en seed par y/n
```
./up.sh fichier.xx (ou dossier)
```
![picture alt](https://cloud.githubusercontent.com/assets/10530469/20858909/b784404c-b94f-11e6-8ebe-917946139352.png)


* Utilisation de boîtes de dialogue pour choix taille de pièces et mise en seed
```
./up.sh
```
![picture alt](https://cloud.githubusercontent.com/assets/10530469/20858907/b764e422-b94f-11e6-9480-722e7c3c2926.png)

![picture alt](https://cloud.githubusercontent.com/assets/10530469/20858911/b7895974-b94f-11e6-944f-54e85717689a.png)

![picture alt](https://cloud.githubusercontent.com/assets/10530469/20858910/b7885880-b94f-11e6-9c8e-c633874a5e39.png)

![picture alt](https://cloud.githubusercontent.com/assets/10530469/20858908/b776b904-b94f-11e6-8a33-b83e8986c9a0.png)
