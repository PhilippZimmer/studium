package classes

class SongMitText (
    titel : String,
    interpret : String,
    spieldauer : Int,
    bewertung : Int,
    var textzeile : String
) : Song ( titel , interpret , spieldauer , bewertung ) {

    init {
       // textzeile.toLowerCase()
       // textzeile = "test"
    }

    override fun suchbegriffeUeberpruefen(suche : String) : Boolean{
println("da")
        textzeile = "test"
        val te = this.textzeile.contains( suche)
        return te

    }


}


