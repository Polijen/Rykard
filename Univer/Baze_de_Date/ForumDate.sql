-- ================================
--  ForumDate.sql
--  DML pentru populaţia iniţială
-- ================================

-- 2.1. Domenii (3 rânduri)
INSERT INTO fDomeniu(codD, denumire, descriere) VALUES
  ('Calc','Calculatoare','Articole despre software & hardware')

  INSERT INTO fDomeniu(codD, denumire, descriere) VALUES
  ('AI','Inteligență Artificială','Articole despre inteligență artificială și machine learning')

  INSERT INTO fDomeniu(codD, denumire, descriere) VALUES
  ('Web','Dezvoltare Web','Articole despre HTML, CSS, JavaScript')

-- 2.2. Autori (12 rânduri)
INSERT INTO fAutor(codAutor, nume, email) VALUES
  ('A001','Ion Popescu','ion.popescu@gmail.com')

  INSERT INTO fAutor(codAutor, nume, email) VALUES
  ('A002','Maria Ionescu','maria.ionescu@gmail.com')

  INSERT INTO fAutor(codAutor, nume, email) VALUES
  ('A003','Paul Marinescu','paul.marinescu@gmail.com')

  INSERT INTO fAutor(codAutor, nume, email) VALUES
  ('A004','Elena Georgescu','elena.georgescu@gmail.com')

  INSERT INTO fAutor(codAutor, nume, email) VALUES
  ('A005','Andrei Dumitru','andrei.dumitru@gmail.com')

  INSERT INTO fAutor(codAutor, nume, email) VALUES
  ('A006','Ana Preda','ana.preda@gmail.com')

  INSERT INTO fAutor(codAutor, nume, email) VALUES
  ('A007','Bogdan Radu','bogdan.radu@gmail.com')

  INSERT INTO fAutor(codAutor, nume, email) VALUES
  ('A008','Cristina Stoica','cristina.stoica@gmail.com')

  INSERT INTO fAutor(codAutor, nume, email) VALUES
  ('A009','Dan Mihăilescu','dan.mihailescu@gmail.com')

  INSERT INTO fAutor(codAutor, nume, email) VALUES
  ('A010','Gabriela Popa','gabriela.popa@gmail.com')

  INSERT INTO fAutor(codAutor, nume, email) VALUES
  ('A011','Mihai Vasile','mihai.vasile@gmail.com')

  INSERT INTO fAutor(codAutor, nume, email) VALUES
  ('A012','Valentina Moraru','valentina.moraru@gmail.com')

-- 2.3. Postări (9 rânduri)
INSERT INTO fPostare(codP, titlu, codAutor, codD, nLike, continut) VALUES
  ( 1, 'Introducere în Calculatoare','A001','Calc',12,'Ce este un calculator și cum funcționează el la nivel de hardware…')

  INSERT INTO fPostare(codP, titlu, codAutor, codD, nLike, continut) VALUES
  ( 2, 'Cum aleg un procesor?','A002','Calc',8,'Sfaturi pentru alegerea unui CPU în funcție de buget și necesități…')

  INSERT INTO fPostare(codP, titlu, codAutor, codD, nLike, continut) VALUES
  ( 3, 'Bazele Inteligenței Artificiale','A003','AI',34,'Întrebare: Cine este responsabil pentru daunele cauzate de IA?…')

  INSERT INTO fPostare(codP, titlu, codAutor, codD, nLike, continut) VALUES
  ( 4, 'Machine Learning vs Deep Learning','A004','AI',27,'Diferențele cheie între ML și DL și când să folosim fiecare…')

  INSERT INTO fPostare(codP, titlu, codAutor, codD, nLike, continut) VALUES
  ( 5, 'Construiește-ți propriul site web','A005','Web',15,'Pașii de la HTML static la framework-uri moderne…')

  INSERT INTO fPostare(codP, titlu, codAutor, codD, nLike, continut) VALUES
  ( 6, 'Optimizarea CSS-ului','A006','Web',5,'Tehnici pentru a reduce dimensiunea fișierelor CSS și a accelera încărcarea…')

  INSERT INTO fPostare(codP, titlu, codAutor, codD, nLike, continut) VALUES
  ( 7, 'Structuri de date în C++','A007','Calc',19,'Liste, stive, cozi și arbori – implementări și exemple…')

  INSERT INTO fPostare(codP, titlu, codAutor, codD, nLike, continut) VALUES
  ( 8, 'Rețele neuronale convoluționale','A008','AI',22,'Cum funcționează CNN-urile și unde se aplică…')

  INSERT INTO fPostare(codP, titlu, codAutor, codD, nLike, continut) VALUES
  ( 9, 'API-uri REST vs GraphQL','A009','Web',9,'Avantaje și dezavantaje, exemple de implementare…')

-- 2.4. Comentarii (16 rânduri)
INSERT INTO fComentariu(codComent, codP, codAutor, continut, nVotDa, nVotNu) VALUES
  ( 1, 1, 'A002','Foarte util, mulțumesc!',4, 0)

  INSERT INTO fComentariu(codComent, codP, codAutor, continut, nVotDa, nVotNu) VALUES
  ( 2, 1, 'A003','Aș adăuga și partea despre memoria cache.',2, 1)

  INSERT INTO fComentariu(codComent, codP, codAutor, continut, nVotDa, nVotNu) VALUES
  ( 3, 2, 'A001','Articol complet, clar și la obiect.',3, 0)

  INSERT INTO fComentariu(codComent, codP, codAutor, continut, nVotDa, nVotNu) VALUES
  ( 4, 2, 'A004','Poate ar fi bine să compari prețuri actuale.',1, 0)

  INSERT INTO fComentariu(codComent, codP, codAutor, continut, nVotDa, nVotNu) VALUES
  ( 5, 3, 'A005','Problema responsabilității este foarte complexă.',5, 2)

  INSERT INTO fComentariu(codComent, codP, codAutor, continut, nVotDa, nVotNu) VALUES
  ( 6, 3, 'A006','Unde găsim studii de caz pe tema asta?',2, 1)

  INSERT INTO fComentariu(codComent, codP, codAutor, continut, nVotDa, nVotNu) VALUES
  ( 7, 4, 'A001','Mi-a plăcut compararea conceptelor.',3, 0)

  INSERT INTO fComentariu(codComent, codP, codAutor, continut, nVotDa, nVotNu) VALUES
  ( 8, 4, 'A007','Lipsește un exemplu practic cu Keras.',4, 1)

  INSERT INTO fComentariu(codComent, codP, codAutor, continut, nVotDa, nVotNu) VALUES
  ( 9, 5, 'A008','Bun ghid de la zero.',2, 0)

  INSERT INTO fComentariu(codComent, codP, codAutor, continut, nVotDa, nVotNu) VALUES
  (10, 5, 'A009','Poți adăuga și un capitol despre SEO?',1, 1)

  INSERT INTO fComentariu(codComent, codP, codAutor, continut, nVotDa, nVotNu) VALUES
  (11, 6, 'A010','Metoda cu minificarea CSS mi s-a părut utilă.',3, 0)

  INSERT INTO fComentariu(codComent, codP, codAutor, continut, nVotDa, nVotNu) VALUES
  (12, 6, 'A011','Dar ce zici de autoprefixer?',2, 1)

  INSERT INTO fComentariu(codComent, codP, codAutor, continut, nVotDa, nVotNu) VALUES
  (13, 7, 'A012','Exemplul cu arbori este excelent.',4, 0)

  INSERT INTO fComentariu(codComent, codP, codAutor, continut, nVotDa, nVotNu) VALUES
  (14, 8, 'A009','Unde găsim dataset-ul pentru testare?',3, 1)

  INSERT INTO fComentariu(codComent, codP, codAutor, continut, nVotDa, nVotNu) VALUES
  (15, 8, 'A010','Explicația matematică e clară.',5, 0)

  INSERT INTO fComentariu(codComent, codP, codAutor, continut, nVotDa, nVotNu) VALUES
  (16, 9, 'A011','Mi-ar plăcea și un exemplu în Python.',2, 0)

--NEW inputs: 
-- Insert 3 domains
INSERT INTO fDomeniu VALUES ('Calc', 'Calculatoare', 'Articole despre software & hardware');
INSERT INTO fDomeniu VALUES ('Med', 'Medicină', 'Discuții despre sănătate și științe medicale');
INSERT INTO fDomeniu VALUES ('Econ', 'Economie', 'Analize financiare și economie globală');

-- Insert 12 authors
INSERT INTO fAutor VALUES ('A001', 'Mihai Popescu', 'mihai@gmail.com');
INSERT INTO fAutor VALUES ('A002', 'Elena Georgescu', 'elena@gmail.com');
INSERT INTO fAutor VALUES ('A003', 'Ion Barbu', 'ion@gmail.com');
INSERT INTO fAutor VALUES ('A004', 'Ana Ionescu', 'ana@gmail.com');
INSERT INTO fAutor VALUES ('A005', 'Vlad Marinescu', 'vlad@gmail.com');
INSERT INTO fAutor VALUES ('A006', 'Andreea Pavel', 'andreea@gmail.com');
INSERT INTO fAutor VALUES ('A007', 'Cristian Dinu', 'cristian.dinu@gmail.com');
INSERT INTO fAutor VALUES ('A008', 'Ioana Munteanu', 'ioana@gmail.com');
INSERT INTO fAutor VALUES ('A009', 'Radu Enache', 'radu@gmail.com');
INSERT INTO fAutor VALUES ('A010', 'Monica Dragomir', 'monica@gmail.com');
INSERT INTO fAutor VALUES ('A011', 'Paul Ionescu', 'paul908@gmail.com');
INSERT INTO fAutor VALUES ('A012', 'George Avram', 'george@gmail.com');

-- Insert 9 posts
INSERT INTO fPostare VALUES (101, 'Cum învăț rapid Python?', 'A001', 'Calc', 12, 'Sunt începător și vreau să învăț Python cât mai eficient. Ce resurse recomandați?');
INSERT INTO fPostare VALUES (102, 'Laptop pentru programare - sugestii?', 'A002', 'Calc', 5, 'Caut un laptop bun pentru programare (VS Code, Docker, etc). Buget: 4000-5000 lei.');
INSERT INTO fPostare VALUES (103, 'Alimente pentru memorie mai bună?', 'A003', 'Med', 8, 'Există alimente sau suplimente care ajută cu adevărat memoria și concentrarea?');
INSERT INTO fPostare VALUES (104, 'Inflația în România - efecte și soluții', 'A004', 'Econ', 6, 'Cum ne afectează inflația actuală și ce măsuri poate lua guvernul pentru a o controla?');
INSERT INTO fPostare VALUES (105, 'Cursuri gratuite de securitate cibernetică', 'A005', 'Calc', 10, 'Știe cineva cursuri online gratuite despre securitate cibernetică?');
INSERT INTO fPostare VALUES (106, 'Vaccinurile ARNm - păreri pro și contra', 'A006', 'Med', 2, 'Care sunt principalele avantaje și riscuri ale vaccinurilor pe bază de ARNm?');
INSERT INTO fPostare VALUES (107, 'Criptomonede - investiție sau speculație?', 'A007', 'Econ', 7, 'Credeți că investițiile în criptomonede sunt sustenabile sau doar o modă trecătoare?');
INSERT INTO fPostare VALUES (108, 'Cel mai bun editor de text pentru Linux?', 'A008', 'Calc', 9, 'Ce editor de text preferați pe Linux? Vim, Nano, VS Code sau altceva?');
INSERT INTO fPostare VALUES (109, 'Pericole Inteligență Artificială', 'A011', 'Calc', 34, 'Întrebare: Cine este responsabil pentru daunele cauzate de Inteligența Artificială? Cum putem reglementa acest domeniu?');


-- Insert 16 comments
INSERT INTO fComentariu VALUES (109, 'A003', 'O întrebare foarte actuală. AI-ul trebuie reglementat cât mai curând.', 4, 15);
INSERT INTO fComentariu VALUES (109, 'A004', 'Cred că responsabilitatea ar trebui să revină companiilor dezvoltatoare.', 2, 3);
INSERT INTO fComentariu VALUES (109, 'A005', 'Problema e că tehnologia avansează mai repede decât legislația.', 7, 1);
INSERT INTO fComentariu VALUES (109, 'A006', 'În UE deja se discută despre un AI Act. Ar fi un început bun.', 10, 0);
INSERT INTO fComentariu VALUES (101, 'A007', 'Recomand cursul "Automate the Boring Stuff with Python".', 5, 0);
INSERT INTO fComentariu VALUES (102, 'A008', 'Eu folosesc un Lenovo ThinkPad - merge perfect pentru dev.', 3, 2);
INSERT INTO fComentariu VALUES (103, 'A009', 'Pe mine mă ajută ginkgo biloba și somnul regulat.', 1, 1);
INSERT INTO fComentariu VALUES (104, 'A010', 'Inflația lovește în puterea de cumpărare, mai ales la alimente.', 6, 1);
INSERT INTO fComentariu VALUES (105, 'A011', 'Coursera are un curs gratuit de la IBM despre Cybersecurity.', 4, 0);
INSERT INTO fComentariu VALUES (106, 'A012', 'Vaccinurile ARNm sunt revoluționare, dar e nevoie de transparență.', 5, 0);
INSERT INTO fComentariu VALUES (107, 'A001', 'Criptomonedele sunt utile doar dacă înțelegi riscurile.', 2, 2);
INSERT INTO fComentariu VALUES (108, 'A002', 'VS Code cu extensii pentru Linux e super!', 7, 1);
INSERT INTO fComentariu VALUES (101, 'A003', 'Python e ușor de învățat dacă exersezi zilnic.', 6, 0);
INSERT INTO fComentariu VALUES (102, 'A004', 'Poate fi util să alegi ceva cu minim 16GB RAM.', 1, 3);
INSERT INTO fComentariu VALUES (103, 'A005', 'Recomand Omega-3 și ceai verde pentru concentrare.', 3, 1);
INSERT INTO fComentariu VALUES (104, 'A006', 'Educația financiară e cheia pentru a trece mai ușor peste criză.', 0, 4);



