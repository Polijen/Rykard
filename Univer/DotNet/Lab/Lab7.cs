using System;
using System.IO;
using System.Linq;
using System.Collections.Generic;

namespace AlSapteleaMeuProgram
{
    class ProdusCSV
    {
        public string Nume { get; set; }
        public string Categorie { get; set; }
        public double Pret { get; set; }
    }

    class StudentCSV
    {
        public string Nume { get; set; }
        public double Nota1 { get; set; }
        public double Nota2 { get; set; }
        public double Nota3 { get; set; }
    }

    class Program
    {
        static void Main(string[] args)
        {
            // Generam fisierele CSV necesare pentru a testa exercitiile
            File.WriteAllText("produse.csv", "Nume,Categorie,Pret\nPaine,Alimente,3.5\nLapte,Alimente,6.0\nTelefon,IT,2500\nMouse,IT,150");
            File.WriteAllText("studenti.csv", "Nume,Nota1,Nota2,Nota3\nIon,8,9,10\nMaria,10,10,9\nVasile,5,6,7");

            //Exercitiul 1
            /*
Creați un fișier CSV care conține informații despre produse (nume, categorie, preț) 
și utilizați LINQ pentru a calcula prețul mediu al produselor pentru fiecare categorie.
            */
            Console.WriteLine("--- EXERCITIUL 1: Procesare produse din CSV ---");
            
            var liniiProduse = File.ReadAllLines("produse.csv").Skip(1); // Ignoram header-ul
            var produse = liniiProduse.Select(linie =>
            {
                var campuri = linie.Split(',');
                return new ProdusCSV
                {
                    Nume = campuri[0],
                    Categorie = campuri[1],
                    Pret = Convert.ToDouble(campuri[2])
                };
            }).ToList();

            var pretMediuPeCategorie = produse
                .GroupBy(p => p.Categorie)
                .Select(g => new { Categorie = g.Key, PretMediu = g.Average(p => p.Pret) });

            foreach (var cat in pretMediuPeCategorie)
            {
                Console.WriteLine($"Categoria: {cat.Categorie} are pretul mediu de {cat.PretMediu:F2}");
            }


            Console.WriteLine("\n--- EXERCITIUL 3: Procesare studenti din CSV ---");
            //Exercitiul 3
            /*
Folosind un fișier CSV care conține date despre studenți (nume, notă1, notă2, notă3), 
utilizați LINQ pentru a calcula media notelor pentru fiecare student și afișați numele și media obținută.
            */

            var liniiStudenti = File.ReadAllLines("studenti.csv").Skip(1);
            var studenti = liniiStudenti.Select(linie =>
            {
                var campuri = linie.Split(',');
                return new StudentCSV
                {
                    Nume = campuri[0],
                    Nota1 = Convert.ToDouble(campuri[1]),
                    Nota2 = Convert.ToDouble(campuri[2]),
                    Nota3 = Convert.ToDouble(campuri[3])
                };
            }).ToList();

            var studentiCuMedia = studenti.Select(s => new 
            { 
                Nume = s.Nume, 
                Media = (s.Nota1 + s.Nota2 + s.Nota3) / 3.0 
            });

            foreach (var student in studentiCuMedia)
            {
                Console.WriteLine($"Studentul {student.Nume} are media {student.Media:F2}");
            }
        }
    }
}