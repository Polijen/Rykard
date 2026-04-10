using System;

namespace PrimulMeuProgramC 
{ 
    class Program 
    { 
    static void Main(string[] args) 
        { 
            //Exercitiul 3
            /*
Scrieți un program C# care cere utilizatorului să introducă raza unui cerc și 
calculează și afișează aria și circumferința cercului, folosind valorile introduse. 
(Considerați π = 3.1415926) 
            */
        Console.WriteLine("Introduceti raza cercului:"); 
        int raza = Convert.ToInt32(Console.ReadLine());
        double PI = 3.1415926;
        double circ = 2 * PI * raza;
        double aria = PI * raza * raza;
        Console.WriteLine($"Display Aria: {aria}\n Display Circumferinta {circ}");

        //Exercitiul 5
        /*
(Mediu) Scrieți un program C# care cere utilizatorului să introducă două șiruri de 
caractere și verifică dacă primul șir apare în al doilea șir. Afișați un mesaj 
corespunzător. 
        */
        Console.WriteLine("Introduceti primul sir:");
        string str1 = Console.ReadLine() ?? "";       //In caza ca da fail la citire nu va returna null dar va da un empty string
        Console.WriteLine("Introduceti al doilea sir:");
        string str2 = Console.ReadLine() ?? "";
        //if (str1 != null && str2 != null){}   //Asta e tot o solutie
        int index = str2.IndexOf(str1); //returns the index of the first occurence of a specific ch or string within the curent instance of the stringa, if NOT FOUND returns -1
        if (index != -1)
            {   
                string rez = str2.Substring(index); //returneaza o portiune de string de la incputul index
                Console.WriteLine($"Sirul: {str1}\n Este prezent in Sirul: {str2}\n Aici: {rez}");
            }

        }
    }
}
