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
