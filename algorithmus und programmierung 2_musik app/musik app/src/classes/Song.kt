package classes

open class Song(val titel: String, val interpret: String, val spieldauer: Int, var bewertung: Int) {

    //anfang alle 60 sek.
    open fun abspielen() {
        for (sek in 0 until this.spieldauer) {
            if (sek == 0 || sek.rem(59) == 1) {
                println(" Spiele: ${this.titel} von ${this.interpret}  (Bewertung: ${this.bewertung})")
            }
        }
        println()
    }


    //begrenz Abänderungen
    fun aendernDerBewertung(aenderung: Int): Int {

        this.bewertung = +aenderung
        if (this.bewertung < 0)
            this.bewertung = 0
        if (this.bewertung > 100)
            this.bewertung = 100

        return bewertung

    }


    open fun suchbegriffeUeberpruefen(suche: String): Boolean {
println("dort")
        val t = this.titel.contains(suche)
        val i = this.interpret.contains(suche)

        return i || t
    }


}
