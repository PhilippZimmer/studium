import classes.*
import mylist.Verketteliste
import java.util.ArrayList

fun main() {

    //Musikverwaltung erzeugen
    val verwaltung = Musikverwaltung(songliste = arrayListOf())


    //8 beliebige Song Objekte
    val song1 = Song("I enjoy my work", "Johnny Klimek", 300, 90)
    val song2 = Song("Battle for Camelt", "Tartalo Music", 295, 40)
    val song3 = Song("Seraphim", "City of the Fallen", 139, 100)
    val song4 = Song("Soccent Attack", "Steve Jablonsky", 127, 80)
    val song5 = Song("Aen Seidhe", "Mikolai Stroinski", 156, 70)
    val song6 = Song("Garador's Flight", "Jo Blankenburk", 169, 60)
    val song7 = Song("Solitude", "Lorne Balfe", 98, 50)
    val song8 = Song("Nightcall", "Kavinsky, Lovefoxxx", 360, 100)


    //Songs hinzufügen
    verwaltung.songHinzufuegen(song1)
    verwaltung.songHinzufuegen(song2)
    verwaltung.songHinzufuegen(song3)
    verwaltung.songHinzufuegen(song4)
    verwaltung.songHinzufuegen(song5)
    verwaltung.songHinzufuegen(song6)
    verwaltung.songHinzufuegen(song7)
    verwaltung.songHinzufuegen(song8)


    //Listen erzeugen
    val playlist = Playlist(arrayListOf(song1, song1, song1))
    val zufplaylist = verwaltung.zufaelligePlaylistErzeugen()

    /*
    println("Alle Songs der Erstelltenplaylist")
    playlist.alleSongsSpielen()
    println()
    println("Alle Songs der zufalls Liste")
    zufplaylist.alleSongsSpielen()
    println()


    println("Beste Songs")
    val best = verwaltung.besterSong()
    best.abspielen()
    println()


    /*do {
        println("Bitte geben Sie einen Suchbegriff ein oder stopp zum Beenden")
        val eingabe = readLine()
        if (eingabe != null) {
            val sucheErgebniss: Song = verwaltung.songUeberEinenSuchbegriffSuchen(eingabe)
        sucheErgebniss.abspielen()
        }

    } while (eingabe != "stopp")*/


    val eingabe = "Johnny Klimek"
    val test = playlist.songsVonInterpret(eingabe)
    println("$eingabe hat $test Songs in der Liste")


    val neu = SongMitText("titeltest", "interprettest",100,20,"Dings")
    neu.suchbegriffeUeberpruefen(test.toString())


    val erg = song1.suchbegriffeUeberpruefen(test.toString())
    println(erg)




     */

    val neueVerkPlaylist = DynamicPlaylist( arrayListOf(song4, song2, song4, song4, song2, song4, song4,song2 ))


    val dauer = neueVerkPlaylist.dauer()
    println("gesamt: $dauer")
    neueVerkPlaylist.alleSongsSpielen()
    println("Fertig Song")

    neueVerkPlaylist.songEntnehmen( )
    neueVerkPlaylist.songEntnehmen( )
    neueVerkPlaylist.songHinzufuegen( song8 )
    neueVerkPlaylist.songEntnehmen ( )

    val dauer2 = neueVerkPlaylist.dauer()
    println(dauer2)
    neueVerkPlaylist.alleSongsSpielen()

    neueVerkPlaylist.zuruecksetzten()
    neueVerkPlaylist.alleSongsSpielen()
    neueVerkPlaylist



}