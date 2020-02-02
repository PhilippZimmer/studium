import classes.Uhrzeit
import classes.Parkschein
import classes.Parkhaus

fun main () {

    val parkschein1 = Parkschein ( einfahrtZeit = Uhrzeit(12,15),
        ausfahrtZeit = Uhrzeit(13,30))
    val parkschein2 = Parkschein ( einfahrtZeit = Uhrzeit(12, 16),
        ausfahrtZeit = Uhrzeit(14,15))
    val parkschein3 = Parkschein ( einfahrtZeit = Uhrzeit(12,17),
        ausfahrtZeit = Uhrzeit(20,12))
    val parkschein4 = Parkschein ( einfahrtZeit = Uhrzeit(12, 18),
        ausfahrtZeit = Uhrzeit(17,36))
    val parkschein5 = Parkschein ( einfahrtZeit = Uhrzeit(12,19),
        ausfahrtZeit = Uhrzeit(12,29))

    val listeMitParkscheinen = arrayListOf<Parkschein> ( parkschein1, parkschein2, parkschein3, parkschein4, parkschein5)
    val neuTest = Parkhaus( liste = listeMitParkscheinen, tarif =  3.50)

    println( "Die kuerzeste Parkzeit ist: ${neuTest.kuerzesteParkzeit(neuTest)} Minuten")
    println( "Die durchschnittliche Parkzeit ist: ${neuTest.durchschnittlicheParkzeit(neuTest)} Stunden")
    println( "Die Einnahmen sind: ${neuTest.einnahmen(neuTest)}€")
    val testen = neuTest.ueberpruefen(neuTest)
    if (testen == true) {
        println("Alles in Ordnung")
    }
    else {
        println ("Mind. ein Parkschein ist nicht in Ordnung")
    }

    listeMitParkscheinen.add(Parkschein( einfahrtZeit = Uhrzeit(20,12),
        ausfahrtZeit = Uhrzeit(12,12)))

    println( "Ein neuer Parkschein hinzugefügt")

    val fehlerNeu = neuTest.ueberpruefen(neuTest)
    if (fehlerNeu == true) {
        println("Alles in Ordnung")
    }
    else {
        println ("Mind. ein Parkschein ist nicht in Ordnung")
    }


}