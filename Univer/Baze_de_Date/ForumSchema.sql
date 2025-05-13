CREATE TABLE fDomeniu (
    codD VARCHAR(10) PRIMARY KEY,
    denumire VARCHAR(100) NOT NULL, 
    descriere VARCHAR(255) DEFAULT 'Nespecificat'
);


CREATE TABLE fAutor (
    codAutor VARCHAR(10) PRIMARY KEY, 
    nume VARCHAR(100) NOT NULL, 
    email VARCHAR(100) UNIQUE NOT NULL, 
    CHECK (INSTR(email, '@') > 1) 
);


CREATE TABLE fPostare (
    codP INT PRIMARY KEY, 
    titlu VARCHAR(255) NOT NULL,
    codAutor VARCHAR(10) NOT NULL,
    codD VARCHAR(10) NOT NULL,
    nLike INT DEFAULT 0 CHECK (nLike >= 0), 
    continut VARCHAR(1000) NOT NULL,
    FOREIGN KEY (codAutor) REFERENCES fAutor(codAutor) ON DELETE CASCADE,
    FOREIGN KEY (codD) REFERENCES fDomeniu(codD) ON DELETE SET NULL
);


CREATE TABLE fComentariu (
    codP INT NOT NULL,
    codAutor VARCHAR(10) NOT NULL,
    continut VARCHAR(500) NOT NULL,
    nVotDa INT DEFAULT 0 CHECK (nVotDa >= 0),
    nVotNu INT DEFAULT 0 CHECK (nVotNu >= 0),
    PRIMARY KEY (codP, codAutor), 
    FOREIGN KEY (codP) REFERENCES fPostare(codP) ON DELETE CASCADE,
    FOREIGN KEY (codAutor) REFERENCES fAutor(codAutor) ON DELETE CASCADE
);
