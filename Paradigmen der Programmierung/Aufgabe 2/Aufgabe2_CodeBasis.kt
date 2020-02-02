import java.lang.IllegalStateException

sealed class List <T> {

    class Node <T> ( val head : T , val tail : List<T>) : List<T> () {
        override fun toString () =
            "${head.toString()} , ${tail.toString()}"
    }
    object Nil : List<Nothing> ()  {
        override fun toString () = "NIL"
    }

    companion object {
        operator
        fun <T> invoke (vararg values : T ) : List<T>{
            val empty = Nil as List<T>
            val res = values.foldRight( empty , { v, l -> l.addFirst(v)   })
            return res
        }
    }

    fun addFirst ( head : T ) : List<T> = Node (head , this)

    fun removeFirst ()  : List <T> = when (this) {
        is Nil -> throw IllegalStateException()
        is Node<T> -> this.tail
    }

}
