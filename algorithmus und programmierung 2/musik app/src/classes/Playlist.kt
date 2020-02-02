package classes

open class Playlist(var playlist: ArrayList<Song> = arrayListOf()) {

    fun songsVonInterpret(name: String) : Int {
        var anzahl = 0
        for (song in 0 until this.playlist.size)
            if (this.playlist[song].interpret == name)
                anzahl++
        return anzahl
    }


    //gesammt Dauer
    open fun dauer(): Int = this.playlist.sumBy { it.spieldauer }


    //Liste abspielen, geht in Song abspielen
    open fun alleSongsSpielen() {
        for (song in 0 until this.playlist.size) {
            this.playlist[song].abspielen()
        }
    }
}
