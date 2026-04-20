using System;
using System.IO;

namespace AlSaseleaMeuProgram
{
    class Program
    {
        static void not_Main(string[] args)
        {
            //Exercitiul 1
            /*
Creați o aplicație care efectuează operații aritmetice pe baza intrărilor de la utilizator. 
Gestionați excepțiile pentru intrări nevalide, cum ar fi împărțirea la zero și depășirea limitelor de valori întregi.
            */
            Console.WriteLine("--- EXERCITIUL 1: Impartire cu Exceptii ---");
            try
            {
                Console.WriteLine("Introduceti deimpartitul (numar intreg):");
                int a = Convert.ToInt32(Console.ReadLine());

                Console.WriteLine("Introduceti impartitorul (numar intreg):");
                int b = Convert.ToInt32(Console.ReadLine());

                int rezultat = a / b;
                Console.WriteLine($"Rezultatul este: {rezultat}");
            }
            catch (DivideByZeroException)
            {
                Console.WriteLine("Eroare: Nu se poate imparti la zero!");
            }
            catch (FormatException)
            {
                Console.WriteLine("Eroare: Nu ati introdus un numar valid.");
            }
            catch (OverflowException)
            {
                Console.WriteLine("Eroare: Numarul introdus este prea mare sau prea mic pentru un Int32.");
            }

            Console.WriteLine("\n--- EXERCITIUL 2: Citire angajat din fisier ---");
            //Exercitiul 2
            /*
Implementați o aplicație care citește informații despre un angajat (nume, vârstă, salariu) din fișiere separate. 
Gestionați excepțiile pentru fișiere lipsă, formate nevalide și valori incorecte ale datelor.
            */
            
            // Generam un fisier dummy pentru test ca sa nu ne dea eroare la rulare
            File.WriteAllText("angajat.txt", "Marcel\n35\n4500.50");

            try
            {
                string path = "angajat.txt"; // schimba pe "angajat_lipsa.txt" ca sa testezi exceptia
                string[] linii = File.ReadAllLines(path);

                if (linii.Length < 3)
                {
                    throw new Exception("Fisierul nu contine suficiente date.");
                }

                string nume = linii[0];
                int varsta = Convert.ToInt32(linii[1]);
                double salariu = Convert.ToDouble(linii[2]);

                Console.WriteLine($"Date citite: Nume={nume}, Varsta={varsta}, Salariu={salariu}");
            }
            catch (FileNotFoundException)
            {
                Console.WriteLine("Eroare: Fisierul angajat.txt nu a fost gasit.");
            }
            catch (FormatException)
            {
                Console.WriteLine("Eroare: Datele din fisier nu au un format valid (ex: varsta sau salariul nu sunt numere).");
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Eroare generala: {ex.Message}");
            }
        }
    }
}