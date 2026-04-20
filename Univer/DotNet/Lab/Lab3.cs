using System;

namespace AlTreileaMeuProgram
{
    class Program
    {
        static void not_Main(string[] args)
        {
            //Exercitiul 1
            /*
Scrieți o metodă care primește un șir de caractere și returnează numărul de vocale din șir.
            */
            Console.WriteLine("Introduceti un sir de caractere pentru a numara vocalele:");
            string sir = Console.ReadLine() ?? "";
            int numarVocale = NumaraVocale(sir);
            Console.WriteLine($"Sirul introdus contine {numarVocale} vocale.\n");

            //Exercitiul 2
            /*
Creați o metodă care primește un număr întreg și returnează inversul său (ex: 123 -> 321).
            */
            Console.WriteLine("Introduceti un numar intreg pentru a-l inversa:");
            int numar = Convert.ToInt32(Console.ReadLine());
            int numarInversat = InverseazaNumar(numar);
            Console.WriteLine($"Inversul numarului {numar} este {numarInversat}.\n");
        }

        static int NumaraVocale(string text)
        {
            int count = 0;
            string vocale = "aeiouAEIOU"; // Toate vocalele posibile
            
            foreach (char c in text)
            {
                if (vocale.Contains(c))
                {
                    count++;
                }
            }
            return count;
        }

        static int InverseazaNumar(int n)
        {
            int invers = 0;
            int numarAbsolut = Math.Abs(n); // Pastram numarul pozitiv pentru logica

            while (numarAbsolut > 0)
            {
                int cifra = numarAbsolut % 10;
                invers = (invers * 10) + cifra;
                numarAbsolut /= 10;
            }

            // Daca numarul initial a fost negativ, il facem inapoi negativ
            if (n < 0)
            {
                invers *= -1;
            }

            return invers;
        }
    }
}