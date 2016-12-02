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
![caps6](https://raw.github.com/exrat/upload-mktorrent/master/screenshot/up06.png)

* Choix de mise en seed par y/n
```
./up.sh fichier.xx (ou dossier)
```
![caps5](https://raw.github.com/exrat/upload-mktorrent/master/screenshot/up05.png)


* Utilisation de boîtes de dialogue pour choix taille de pièces et mise en seed
```
./up.sh
```

![caps1](https://raw.github.com/exrat/upload-mktorrent/master/screenshot/up01.png)

![caps2](https://raw.github.com/exrat/upload-mktorrent/master/screenshot/up02.png)

![caps3](https://raw.github.com/exrat/upload-mktorrent/master/screenshot/up03.png)

![caps4](https://raw.github.com/exrat/upload-mktorrent/master/screenshot/up04.png)
