package mylist

import classes.Playlist
import classes.Song

interface Listeninterface {

    fun songHinzufuegen ( obj : Song )
    fun songEntnehmen ( obj : Song )
    fun zuruecksetzten ( playliste : ArrayList<Song>, verketteliste: Verketteliste )

    fun addfirst ( obj : Song )
    fun laenge () : Int
    fun spieldauerBerechnung () : Int
    fun abspielen ( )

}