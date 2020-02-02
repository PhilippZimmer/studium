package classes

class DynamicPlaylist (playlist: ArrayList<Song> = arrayListOf()) : Playlist (playlist){
    init {
        for (i in 0 until playlist.size) {
            songHinzufuegen(playlist[i])
        }
    }

    private class SongNode (val song : Song, var next : SongNode?  )

    private var first : SongNode? = null

    fun songHinzufuegen(obj: Song) {

        first = SongNode ( obj, first)
        println(obj.titel)
    }


    fun songEntnehmen() {
        if ( first == null) error("leere Liste")
        else{ first = first?.next
        }
    }

    fun zuruecksetzten( ) {
        while ( first != null){
            songEntnehmen()
            println("Songloeschen")
        }
        for (i in 0 until playlist.size) {
            println("zurücksetzten")
            songHinzufuegen(playlist[i])
        }    }

    override fun dauer () : Int{
        var wert = 0
        var runPointer = first
        if (first == null) error("leere liste") else {
            while (runPointer?.next != null) {
                wert += runPointer.song.spieldauer
                println("$wert(mit vorigem Wert)")
                runPointer = runPointer.next
            }
            wert += if (runPointer?.song?.spieldauer != null) runPointer.song.spieldauer
            else throw NullPointerException("leere Stelle")
        }
        return wert
    }

    override fun alleSongsSpielen() {
        var runPointer = first

        if (first == null) error("leere Liste") else {
            while (runPointer?.next != null) {
                runPointer.song.abspielen()
                runPointer = runPointer.next
            }
        }
        if(runPointer?.song != null) runPointer.song.abspielen()
        else throw NullPointerException("leere Stelle")
    }
}