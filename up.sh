#!/bin/bash
#
# Nom du script .. : up.sh
# Date ........... : 12.2016
# Auteur ......... : ex_rat d'après le script d'Aerya | https://upandclear.org
#                    https://upandclear.org/2016/09/29/script-simpliste-de-creation-de-torrent/
# # Description .... : Dossier/Fichier vers .torrent
#                      Taille pieces automatisée ou non
#                      Mise en seed
# Prerequis ...... : mktorrent (installé en cas de défaut)
#                    les fichiers ou dossiers sources se trouvent en /home/user/torrents
# Execution ...... :
#
# ./up.sh
# Boîtes de dialogues
# choix de taille des pièces du .torrent
# Choix de la mise en seed ou stockage en /home/user
#
# ./up.sh fichier.xx (ou dossier)
# Choix de mise en seed ou stockage en /home/user
#
# ./up.sh --auto fichier.xx (ou dossier)
# Mise en seed direct ou pour utilisation avec script d'upload auto
# Pas de verif' sur la présence de la source, attention à la typo !

# Variables ...... : A définir ici et ne pas modifier la suite du script

# User ruTorrent & URL d'annonce
USER=exrat
TRACKER="https://annonce.tracker.bt"

# Dossier adapté pour conf ruTorrent mondedie.fr
# On ne touche pas si on n'a pas une bonne raison
TORRENT="/home/$USER/torrents"
WATCH="/home/$USER/watch"

##############################

FONCAUTO () {
	TAILLE=$(du -s "$TORRENT"/"$FILE" | awk '{ print $1 }')

	if [ "$TAILLE" -lt 524288 ]; then
		PIECE=18 # 256 bytes
	elif [ "$TAILLE" -lt 1048576 ]; then
		PIECE=19 # 512 bytes
	elif [ "$TAILLE" -lt 2097152 ]; then
		PIECE=20 # 1024 bytes
	elif [ "$TAILLE" -lt 4194304 ]; then
		PIECE=21  # 2048 bytes
	elif [ "$TAILLE" -lt 8388608 ]; then
		PIECE=22 # 4096 bytes
	elif [ "$TAILLE" -lt 16777216 ]; then
		PIECE=23 # 8192 bytes
	elif [ "$TAILLE" -lt 33554432 ]; then
		PIECE=24 # 16384 bytes
	else
		PIECE=25 # 32768 bytes
	fi
}

FONCCREATE () {
	mktorrent -p -l "$PIECE" -a "$TRACKER" "$TORRENT"/"$FILE"
	chown "$USER":"$USER" "$FILE".torrent
}

FONCANNUL () {
	whiptail --title "Annulation" --msgbox " Création $FILE.torrent annulé" 13 60
	exit 0
}

command -v mktorrent >/dev/null 2>&1 # test presence mktorrent
if [ $? = 1 ]; then
	apt-get install -y mktorrent
fi

if [ "$1" = "" ]; then # mode boite de dialogue
	NAME=$(whiptail --title "Nom de la source" --inputbox "Entrez le nom du fichier ou dossier source" 10 60 3>&1 1>&2 2>&3)
	exitstatus=$?

	if [ $exitstatus = 0 ]; then
		FILE=$NAME
		if [ -d "$TORRENT/$FILE" ] || [ -f "$TORRENT/$FILE" ]; then
			echo
		else
			whiptail --title "Erreur" --msgbox "Le fichier ou dossier source n'existe pas\nVérifiez le nom exact" 13 60
			exit 0
		fi
	else
		FONCANNUL
	fi

	OPTION=$(whiptail --title "Taille de pièces" --menu "Choisissez la taille de pièces du .torrent" 15 60 9 \
	"1" " Automatique" \
	"2" " 256 Ko" \
	"3" " 512 Ko" \
	"4" "   1 Mo" \
	"5" "   2 Mo" \
	"6" "   4 Mo" \
	"7" "   8 Mo" \
	"8" "  16 Mo" \
	"9" "  32 Mo" 3>&1 1>&2 2>&3)

	if [ "$OPTION" = 1 ]; then
		FONCAUTO
	elif [ "$OPTION" = 2 ]; then
		PIECE=18 # 256 bytes
	elif [ "$OPTION" = 3 ]; then
		PIECE=19 # 512 bytes
	elif [ "$OPTION" = 4 ]; then
		PIECE=20 # 1024 bytes
	elif [ "$OPTION" = 5 ]; then
		PIECE=21  # 2048 bytes
	elif [ "$OPTION" = 6 ]; then
		PIECE=22 # 4096 bytes
	elif [ "$OPTION" = 7 ]; then
		PIECE=23 # 8192 bytes
	elif [ "$OPTION" = 8 ]; then
		PIECE=24 # 16384 bytes
	elif [ "$OPTION" = 9 ]; then
		PIECE=25 # 32768 bytes
	else
		FONCANNUL
	fi

	if [ -d /home/"$USER/$FILE".torrent ] || [ -f /home/"$USER/$FILE".torrent ]; then
		REMOVE=$(whiptail --title "Erreur" --menu "Le fichier $FILE.torrent existe déjà en :\n/home/$USER/$FILE.torrent\nvoulez vous le supprimer ?" 15 60 2 \
		"1" " Oui" \
		"2" " Non" 3>&1 1>&2 2>&3)
		if [ "$REMOVE" = 1 ]; then
			rm -f /home/"$USER"/"$FILE".torrent
		elif [ "$REMOVE" = 2 ]; then
			FONCANNUL
		else
			FONCANNUL
		fi
	fi

	FONCCREATE
	SEED=$(whiptail --title "Mise en seed" --menu "Voulez vous mettre le torrent en seed ?" 15 60 2 \
	"1" " Oui" \
	"2" " Non" 3>&1 1>&2 2>&3)

	if [ "$SEED" = 1 ]; then
		mv "$FILE".torrent "$WATCH"/"$FILE".torrent
		whiptail --title "Ok" --msgbox " Torrent ajouté en:\n $WATCH/$FILE.torrent\n Source:\n $TORRENT/$FILE" 13 60
	elif [ "$SEED" = 2 ]; then
		if [ -d /home/"$USER/$FILE".torrent ] || [ -f /home/"$USER/$FILE".torrent ]; then
			echo
		else # en cas de déplacement du script
			mv "$FILE".torrent /home/"$USER"/"$FILE".torrent
		fi
		whiptail --title "Ok" --msgbox " Torrent ajouté en:\n /home/$USER/$FILE.torrent\n Source:\n $TORRENT/$FILE" 13 60
	else
		rm "$FILE".torrent
		FONCANNUL
	fi

elif [ "$1" = "--auto" ]; then # mode full auto
	FILE="$2"

	if [ -d /home/"$USER/$FILE".torrent ] || [ -f /home/"$USER/$FILE".torrent ]; then
		rm -f /home/"$USER"/"$FILE".torrent # anti doublon multi test
	fi

	FONCAUTO
	FONCCREATE
	mv "$FILE".torrent "$WATCH"/"$FILE".torrent

else # mode semi auto
	FILE="$1"

	if [ -d "$TORRENT/$FILE" ] || [ -f "$TORRENT/$FILE" ]; then
		echo
	else
		echo "Erreur, vérifiez le nom du dossier ou fichier source"
		exit 0
	fi

	if [ -d /home/"$USER/$FILE".torrent ] || [ -f /home/"$USER/$FILE".torrent ]; then
		echo -n -e "$1.torrent existe déjà, voulez vous le supprimer ? (y/n): "
		read -r REMOVE

		if [ "$REMOVE" = "y" ]; then
			rm -f /home/"$USER"/"$FILE".torrent
		else
			exit 0
		fi
	fi

	FONCAUTO
	FONCCREATE
	echo -n -e "Voulez vous mettre le torrent en seed ? (y/n): "
	read -r SEED

	if [ "$SEED" = "y" ]; then
		mv "$FILE".torrent "$WATCH"/"$FILE".torrent
		echo "$FILE.torrent en seed"
	else
		if [ -d /home/"$USER/$FILE".torrent ] || [ -f /home/"$USER/$FILE".torrent ]; then
			echo
		else # en cas de déplacement du script
			mv "$FILE".torrent /home/"$USER"/"$FILE".torrent
			echo "$FILE.torrent en /home/$USER"
		fi
	fi
fi
