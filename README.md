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
![picture alt](https://cloud.githubusercontent.com/assets/10530469/20833946/898f3c54-b892-11e6-9820-ee0d4391cb28.png "up6")

* Choix de mise en seed par y/n
```
./up.sh fichier.xx (ou dossier)
```
![picture alt](https://cloud.githubusercontent.com/assets/10530469/20833944/87aa9852-b892-11e6-95e0-ba51947f234d.png "up5")


* Utilisation de boîtes de dialogue pour choix taille de pièces et mise en seed
```
./up.sh
```
![picture alt](https://cloud.githubusercontent.com/assets/10530469/20833931/753ee0f6-b892-11e6-9a64-cd2a8e4848b8.png "up1")

![picture alt](https://cloud.githubusercontent.com/assets/10530469/20833935/80801304-b892-11e6-9326-8a42a7313150.png "up2")

![picture alt](https://cloud.githubusercontent.com/assets/10530469/20833941/83509860-b892-11e6-98a3-03ee494273dc.png "up3")

![picture alt](https://cloud.githubusercontent.com/assets/10530469/20833943/85c4948e-b892-11e6-9bb8-4c994f9e8798.png "up4")
