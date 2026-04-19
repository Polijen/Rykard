using System;

namespace AlDoileMeuProgramC
{
    class Program
    {
        static void Main(string[] args)
        {
            //Exercitiul 1
            /*
Scrieți un program care citește trei numere de la tastatură și afișează cel mai mare dintre ele.
            */
            Console.WriteLine("Introdu 3 numere ce vor fi comparate:");
            int a = Convert.ToInt32(Console.ReadLine());
            int b = Convert.ToInt32(Console.ReadLine());
            int c = Convert.ToInt32(Console.ReadLine());

            if ((a > b) && (a > c)){
                Console.WriteLine($"Cel mai mare numar introdus este: {a}");
            }
            else if((b > a) && (b > c))
            {
                Console.WriteLine($"Cel mai mare numar introdus este: {b}");
            }
            else
            {
                Console.WriteLine($"Cel mai mare numar introdus este: {c}");
            }

            //Exercitiul 4
            /*
Creați un program care calculează suma cifrelor unui număr introdus de utilizator. 
            */
            Console.WriteLine("Introdu un numar mai mare fara virgula pentru a calcula suma cifrelor");
            long nr = Convert.ToInt64(Console.ReadLine());
            nr = Math.Abs(nr);   
            long sum = 0;
            long cifra = -1;
            while (nr > 0)
            {
                cifra = nr % 10;
                sum += cifra;
                //Console.WriteLine($"Cifra = {cifra}");
                //sum += nr % 10; //better
                nr /= 10;        //Elimina ultima cifra
            }
            Console.WriteLine($"Suma este = {sum}");
        }

    }

}