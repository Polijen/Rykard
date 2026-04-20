using System;

namespace AlPatruleaMeuProgram
{
    //Exercitiul 1
    /*
Creați o clasă Student cu proprietăți precum Name, Grade și StudentId. 
Adăugați metode pentru a calcula media notelor și pentru a afișa detaliile studentului.
    */
    class Student
    {
        public string Name { get; set; }
        public int StudentId { get; set; }
        public double[] Grades { get; set; } // Folosim un array pentru a putea calcula o medie

        public double CalculeazaMedia()
        {
            if (Grades == null || Grades.Length == 0) return 0;
            
            double sum = 0;
            foreach (double grade in Grades)
            {
                sum += grade;
            }
            return sum / Grades.Length;
        }

        public void AfiseazaDetalii()
        {
            Console.WriteLine($"ID: {StudentId} | Nume: {Name} | Media Notelor: {CalculeazaMedia():F2}");
        }
    }

    //Exercitiul 2
    /*
Implementați o clasă Book cu proprietăți precum Title, Author și ISBN. 
Adăugați o metodă pentru a afișa informațiile despre carte într-un format specific.
    */
    class Book
    {
        public string Title { get; set; }
        public string Author { get; set; }
        public string ISBN { get; set; }

        public void AfiseazaInformatii()
        {
            Console.WriteLine($"[CARTE] Titlu: '{Title}' | Autor: {Author} | ISBN: {ISBN}");
        }
    }

    class Program
    {
        static void not_Main(string[] args)
        {
            // Testare Ex 1
            Student s1 = new Student();
            s1.Name = "Mihai Popescu";
            s1.StudentId = 101;
            s1.Grades = new double[] { 8.5, 9.0, 10.0 };
            s1.AfiseazaDetalii();

            Console.WriteLine();

            // Testare Ex 2
            Book b1 = new Book();
            b1.Title = "Programare .NET - Îndrumător de laborator";
            b1.Author = "Valer Bocan";
            b1.ISBN = "978-0-123456-47-2";
            b1.AfiseazaInformatii();
        }
    }
}