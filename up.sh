#!/bin/bash
#
# Auteur ......... : ex_rat d'après le script d'Aerya | https://upandclear.org
#                    https://upandclear.org/2016/09/29/script-simpliste-de-creation-de-torrent/

# Variables ...... : A définir ici et ne pas modifier la suite du script

# User ruTorrent & URL d'annonce
USER=exrat
TRACKER="https://annonce.tracker.bt"

# Dossier adapté pour conf ruTorrent mondedie.fr
# On ne touche pas si on n'a pas une bonne raison
# Pour Transmission, ce sera surement: TORRENT="/home/$USER/download" (jamais testé !)

TORRENT="/home/$USER/torrents"
WATCH="/home/$USER/watch"

##################################################

# Récupération threads
THREAD=$(grep -c processor < /proc/cpuinfo)
if [ "$THREAD" = "" ]; then
	THREAD=1
fi

FONCAUTO () {
	TAILLE=$(du -s "$TORRENT"/"$FILE" | awk '{ print $1 }')

	if [ "$TAILLE" -lt 65536 ]; then # - de 64 Mo
		PIECE=15 # 32 Ko
	elif [ "$TAILLE" -lt 131072 ]; then # - de 128 Mo
		PIECE=16 # 64 Ko
	elif [ "$TAILLE" -lt 262144 ]; then # - de 256 Mo
		PIECE=17 # 128 Ko
	elif [ "$TAILLE" -lt 524288 ]; then # - de 512 Mo
		PIECE=18 # 256 Ko
	elif [ "$TAILLE" -lt 1048576 ]; then # - de 1 Go
		PIECE=19 # 512 Ko
	elif [ "$TAILLE" -lt 2097152 ]; then # - de 2 Go
		PIECE=20 # 1 Mo
	elif [ "$TAILLE" -lt 4194304 ]; then # - de 4 Go
		PIECE=21  # 2 Mo
	elif [ "$TAILLE" -lt 8388608 ]; then # - de 8 Go
		PIECE=22 # 4 Mo
	elif [ "$TAILLE" -lt 16777216 ]; then # - de 16 Go
		PIECE=23 # 8 Mo
	elif [ "$TAILLE" -lt 33554432 ]; then # - de 32 Go
		PIECE=24 # 16 Mo
	elif [ "$TAILLE" -ge 33554432 ]; then # + de 32 Go
		PIECE=25 # 32 Mo
	fi
}

FONCCREATE () {
	mktorrent -p -l "$PIECE" -a "$TRACKER" -t "$THREAD" "$TORRENT"/"$FILE"
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

	OPTION=$(whiptail --title "Taille de pièces" --menu "Choisissez la taille de pièces du .torrent" 15 60 8 \
	"01" " Automatique" \
	"02" "  32 Ko" \
	"03" "  64 Ko" \
	"04" " 128 Ko" \
	"05" " 256 Ko" \
	"06" " 512 Ko" \
	"07" "   1 Mo" \
	"08" "   2 Mo" \
	"09" "   4 Mo" \
	"10" "   8 Mo" \
	"11" "  16 Mo" \
	"12" "  32 Mo" 3>&1 1>&2 2>&3)

	if [ "$OPTION" = 01 ]; then
		FONCAUTO
	elif [ "$OPTION" = 02 ]; then
		PIECE=15 # 32 Ko
	elif [ "$OPTION" = 03 ]; then
		PIECE=16 # 64 Ko
	elif [ "$OPTION" = 04 ]; then
		PIECE=17 # 128 Ko
	elif [ "$OPTION" = 05 ]; then
		PIECE=18 # 256 Ko
	elif [ "$OPTION" = 06 ]; then
		PIECE=19 # 512 Ko
	elif [ "$OPTION" = 07 ]; then
		PIECE=20 # 1 Go
	elif [ "$OPTION" = 08 ]; then
		PIECE=21  # 2 Go
	elif [ "$OPTION" = 09 ]; then
		PIECE=22 # 4 Go
	elif [ "$OPTION" = 10 ]; then
		PIECE=23 # 8 Go
	elif [ "$OPTION" = 11 ]; then
		PIECE=24 # 16 Go
	elif [ "$OPTION" = 12 ]; then
		PIECE=25 # 32 Go
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
