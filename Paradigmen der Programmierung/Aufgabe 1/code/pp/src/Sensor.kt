/*import kotlin.random.Random
interface Sensor {

    fun getTemperatur() :Float

    fun RandomSensor() :Float {
        var test = 0.0f
        val randomValues = List(1) { Random.nextDouble(from =  -15.0, until = 50.0)}
        test.compareTo(randomValues[0])
        return test
    }

    fun UpDownSensor() : Double {
        var temp = RandomSensor()
        val schwankung = List (1) {Random.nextDouble(from = -2.0, until = 2.0)}
        if (schwankung[0] > -2.0  && schwankung[0] < 0)  temp - schwankung[0]
        else if ( schwankung[0] < 2.0 && schwankung[0] > 0) temp + schwankung[0]
        return schwankung[0]
    }

    fun SensorLogger ( temp: Int ) {
        println(temp)
    }

    fun RoundValues ( temp :Float ) : Int {
        var umrechnung = 0
        umrechnung.compareTo(temp)
        return umrechnung
    }

    fun SensorLimits ( min : Int, max : Int ): Float {
        var limitSensor = -100.0f
        while (limitSensor > max || limitSensor < min) {
            limitSensor = RandomSensor()
        }
        return limitSensor
    }

    fun IgnoreDuplicates ( temp: Float) {
        var erzeugen = 100.0f
        while ( temp != erzeugen) {
            erzeugen = RandomSensor()
        }
    }
}
