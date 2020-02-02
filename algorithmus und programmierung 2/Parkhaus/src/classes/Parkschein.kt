package classes

class Parkschein ( var einfahrtZeit : Uhrzeit, val ausfahrtZeit : Uhrzeit ) {

    fun parkzeit ( parkschein: Parkschein) : Int{

        val stdInMin = parkschein.ausfahrtZeit.stunden - parkschein.einfahrtZeit.stunden
        val min = stdInMin * 60
        val minuten =  min +(parkschein.ausfahrtZeit.minuten - parkschein.einfahrtZeit.minuten)
        return minuten
    }

    fun angefangeneStunde ( parkschein: Parkschein) : Int{

        val zeitInStd = parkschein.ausfahrtZeit.stunden - parkschein.einfahrtZeit.stunden
        val std = zeitInStd + 1
        return std

    }
}