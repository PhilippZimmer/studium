import kotlin.math.round
import kotlin.math.roundToInt
import kotlin.random.Random

val neuSensor : Sensor = SensorLogger(RoundValues(RandomSensor()))
interface Sensor {
    fun getTemperatur(): Float
}


class RandomSensor() : Sensor {
    override fun getTemperatur(): Float {
        val min = -100.0
        val max =  60.0
        val temp = Random.nextDouble( from = min, until = max)
        val tempFloat = temp.toFloat()
        return tempFloat
    }
}

class UpDownSensor() : Sensor {
    override fun getTemperatur(): Float {
        val temp = Random.nextDouble( from = -0.5, until = 0.5)
        val tempFloat = temp.toFloat()
        return tempFloat
    }

}

class SensorLogger ( val temp : Sensor) : Sensor {
    override fun getTemperatur(): Float {
        val ausgabe = temp.getTemperatur()
        print(ausgabe)
        return ausgabe
    }
}

class RoundValues ( val temp : Sensor ) : Sensor {
    override fun getTemperatur(): Float = round(temp.getTemperatur())
}

class SensorLimits ( val temp : Sensor ): Sensor {
    override fun getTemperatur(): Float {
        val min = -30.0
        val max = 50
        while ( true ) {
            val wert = temp.getTemperatur()
            if ( wert > min && wert < max) return wert
        }
    }
}


class IgnoreDuplicates ( val temp: Sensor): Sensor {
    override fun getTemperatur(): Float {
        val erzeugen = temp.getTemperatur()
        while (true) {
            val vergleich = temp.getTemperatur()
            if (erzeugen != vergleich) return vergleich
        }
    }
}

class Thermometer ( val temp : Sensor): Sensor {
    override fun getTemperatur(): Float {
        var aktTemp = 0.0f
        for (lauf in 0..10) {
        val aktTemp = temp.getTemperatur()
            println(aktTemp)
        }
        return aktTemp
    }
}
fun main () {
    println("Test")
    var test = neuSensor.getTemperatur()
    var thermo : Thermometer = Thermometer(SensorLogger(UpDownSensor()))
    thermo.getTemperatur()
    //print(thermometer)
    // for(lauf in 0 .. 1000){
    //  var test2 = Thermometer(SensorLogger)
    //}

    //test  += UpDownSensor().getTemperatur()
    //print(test)
}
