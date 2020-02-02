package mylist

import classes.Song

abstract class Verketteliste : Listeninterface {

    private class SongNode (val song : Song, var next : SongNode?  )

        private var first : SongNode? = null


    override fun songHinzufuegen(obj: Song) {
        println("test")
        if (first == null) addfirst(obj) else {

        var runPointer = first

        while (runPointer?.next != null) {
            runPointer = runPointer.next
        }
        runPointer?.next = SongNode(obj, null)
           println( runPointer?.next?.song?.titel)
    }
    }

    /*override fun songEntnehmen() {

        if ( first?.next?.song == obj) {
            var runPointer = first

            runPointer?.next = runPointer?.next?.next
        }
    }*/

    override open fun zuruecksetzten( playlist : ArrayList<Song>, verketteliste: Verketteliste) {

        for (i in 0 until playlist.size)
            verketteliste.songHinzufuegen( playlist[i] )
    }

    override fun addfirst(obj: Song) {
        first = SongNode ( obj, null )
    }

    override fun laenge() : Int{
        var runpointer = first
        var i = 0
        if ( runpointer?.song != null) {
            i++
            runpointer.next = runpointer.next?.next
        }
     return i
    }

    override fun spieldauerBerechnung( ): Int {
        var rechnen = 0
        var runPointer = first
        if ( first == null) error( "leere Liste") else {
            while ( runPointer?.next != null) {
                rechnen += runPointer.song.spieldauer
                runPointer= runPointer.next
                println(rechnen)
                println(runPointer?.song?.titel)
            }
            rechnen += runPointer?.song?.spieldauer!!
            return rechnen
        }
    }

    override fun abspielen() {
        //TODO letztes Element hinzufuegen
        var runPointer = first
        if (first == null) error("leere Liste") else {
            while ( runPointer?.next != null) {
                runPointer.next = runPointer.next?.next
                for (sek in 0 until runPointer.song.spieldauer) {
                    if (sek == 0 || sek.rem(59) == 1) {
                        println(" Spiele: ${runPointer.song.titel} von ${runPointer.song.interpret}  (Bewertung: ${runPointer.song.bewertung})")

                    }
                }
            }
            println()
        }
    }


}

