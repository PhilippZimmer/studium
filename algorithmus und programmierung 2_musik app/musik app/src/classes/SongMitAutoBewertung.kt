package classes

class SongMitAutoBewertung (
    titel : String,
    interpret : String,
    spieldauer : Int,
    bewertung : Int
): Song (titel , interpret , spieldauer , bewertung ) {

    override fun abspielen () {
    super.abspielen()
        super.aendernDerBewertung(this.bewertung++)
    }
}