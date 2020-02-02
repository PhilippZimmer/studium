package classes

import java.util.*

class Musikverwaltung(val songliste: ArrayList<Song>) {

    //füght hinzu
    fun songHinzufuegen(song: Song) = this.songliste.add(song)


    //benutzereingabe wird in klasse Song weiter geben und Boolen ausgewertet
    fun songUeberEinenSuchbegriffSuchen(benutzereingabe: String): Song? {
        var rueckgabe : Song? = null
        for (song in 0 until this.songliste.size) {
            var ergebniss = this.songliste[song].suchbegriffeUeberpruefen(benutzereingabe)
            if (ergebniss) {
                rueckgabe = this.songliste[song]
            }
        }

        return rueckgabe
    }


    //Rückgabe Song mit höchsten Bewertung
    fun besterSong(): Song {
        val besteSongs = songliste.sortedBy { it.bewertung }
        val ende = this.songliste.lastIndex

        return besteSongs[ende]
    }


    //Neue plist erstellt, gefüllt mit Song aus Musikverwaltung und mit randem Herausname aus Musikverwaltung zufällig überrefrenziert
    fun zufaelligePlaylistErzeugen(): Playlist {
        val zufallListe = Playlist(playlist = arrayListOf())
        zufallListe.playlist.addAll(this.songliste)
        val zufallsGenerator = Random()

        for (song in 0 until this.songliste.size) {
            val zufallsZahl = zufallsGenerator.nextInt(zufallListe.playlist.size)
            zufallListe.playlist[song] = this.songliste[zufallsZahl]
        }
        return zufallListe
    }
}