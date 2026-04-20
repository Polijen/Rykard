using System;
using System.Collections.Generic;
using System.Linq;

namespace AlCincileaMeuProgram
{
    class Angajat
    {
        public string Nume { get; set; }
        public string Functie { get; set; }
        public double Salariu { get; set; }
    }

    class Produs
    {
        public string Nume { get; set; }
        public string Categorie { get; set; }
        public double Pret { get; set; }
    }

    class Program
    {
        static void not_Main(string[] args)
        {
            //Exercitiul 1
            /*
Creați o aplicație care gestionează o listă de angajați. Fiecare angajat are un nume, o funcție și un salariu. 
Utilizați LINQ pentru a efectua operații precum filtrarea angajaților după funcție, 
calcularea salariului mediu și găsirea angajatului cu cel mai mare salariu.
            */
            Console.WriteLine("--- EXERCITIUL 1: Angajati ---");
            List<Angajat> angajati = new List<Angajat>
            {
                new Angajat { Nume = "Ion", Functie = "Developer", Salariu = 5000 },
                new Angajat { Nume = "Ana", Functie = "Manager", Salariu = 8000 },
                new Angajat { Nume = "Vasile", Functie = "Developer", Salariu = 4500 }
            };

            var developeri = angajati.Where(a => a.Functie == "Developer");
            Console.WriteLine("Developeri:");
            foreach (var d in developeri) Console.WriteLine($" - {d.Nume}");

            var salariuMediu = angajati.Average(a => a.Salariu);
            Console.WriteLine($"\nSalariu mediu total: {salariuMediu}");

            var angajatMax = angajati.OrderByDescending(a => a.Salariu).First();
            Console.WriteLine($"Cel mai bine platit angajat: {angajatMax.Nume} ({angajatMax.Salariu})\n");


            //Exercitiul 2
            /*
Implementați o aplicație care gestionează un inventar de produse. Fiecare produs are un nume, o categorie și un preț. 
Utilizați LINQ pentru a efectua operații precum gruparea produselor după categorie, 
calcularea prețului mediu pentru fiecare categorie și găsirea celui mai scump și celui mai ieftin produs din fiecare categorie.
            */
            Console.WriteLine("--- EXERCITIUL 2: Produse ---");
            List<Produs> produse = new List<Produs>
            {
                new Produs { Nume = "Laptop", Categorie = "Electronice", Pret = 3500 },
                new Produs { Nume = "Telefon", Categorie = "Electronice", Pret = 2000 },
                new Produs { Nume = "Scaun", Categorie = "Mobila", Pret = 300 },
                new Produs { Nume = "Masa", Categorie = "Mobila", Pret = 600 }
            };

            var grupariCategorii = produse.GroupBy(p => p.Categorie);

            foreach (var grup in grupariCategorii)
            {
                Console.WriteLine($"Categorie: {grup.Key}");
                Console.WriteLine($" - Pret mediu: {grup.Average(p => p.Pret)}");
                Console.WriteLine($" - Cel mai scump: {grup.OrderByDescending(p => p.Pret).First().Nume}");
                Console.WriteLine($" - Cel mai ieftin: {grup.OrderBy(p => p.Pret).First().Nume}");
            }
        }
    }
}