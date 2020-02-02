package classes

class Parkhaus ( val liste : ArrayList<Parkschein> , val tarif : Double ) {

    fun kuerzesteParkzeit(parkhaus: Parkhaus): Int {
        var kleinsteZahl = 9999999
        var i = 0

        for (parkschein in liste) {

            if (parkhaus.liste[i].parkzeit(parkschein) < kleinsteZahl) {
                kleinsteZahl = parkhaus.liste[i].parkzeit(parkschein)
                i++
            } else { }
        }

        return kleinsteZahl
    }

    fun durchschnittlicheParkzeit ( parkhaus: Parkhaus ) : Double{
        var summe = 0
        var i = 0
        var durchschnitt = 0.00

            for ( parkschein in liste ) {
                summe += parkhaus.liste[i].parkzeit(parkschein)
                i++
            }
            durchschnitt = summe / i.toDouble() / 60
            return durchschnitt
        }

    fun einnahmen ( parkhaus: Parkhaus ) : Double{
        var summe = 0
        var i = 0
        var gesamt = 0.00

             for ( parkschein in liste ) {
                 summe += parkhaus.liste[i].angefangeneStunde(parkschein)
             i++
             }
             gesamt = summe * tarif
             return gesamt
         }

    fun ueberpruefen ( parkhaus: Parkhaus ) : Boolean {
        var i = 0

             for ( parkschein in liste ) {

                if (parkhaus.liste[i].einfahrtZeit.stunden > parkhaus.liste[i].ausfahrtZeit.stunden ) {
                    return false

                }

                if ( parkhaus.liste[i].einfahrtZeit.stunden == parkhaus.liste[i].ausfahrtZeit.stunden &&
                        parkhaus.liste[i].einfahrtZeit.minuten >= parkhaus.liste[i].ausfahrtZeit.minuten) {
                    return false
                }
                i++
            }
        return true
    }
}
