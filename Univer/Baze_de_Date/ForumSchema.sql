CREATE TABLE fDomeniu (
    codD VARCHAR(10) PRIMARY KEY,
    denumire VARCHAR(100),
    descriere VARCHAR(255)
);

CREATE TABLE fAutor (
    codAutor VARCHAR(10) PRIMARY KEY,
    nume VARCHAR(100),
    email VARCHAR(100)
);

CREATE TABLE fPostare (
    codP INT PRIMARY KEY,
    titlu VARCHAR(255),
    codAutor VARCHAR(10),
    codD VARCHAR(10),
    nLike INT,
    continut VARCHAR(1000),
    FOREIGN KEY (codAutor) REFERENCES fAutor(codAutor),
    FOREIGN KEY (codD) REFERENCES fDomeniu(codD)
);

CREATE TABLE fComentariu (
    codP INT,
    codAutor VARCHAR(10),
    continut VARCHAR(500),
    nVotDa INT,
    nVotNu INT,
    FOREIGN KEY (codP) REFERENCES fPostare(codP),
    FOREIGN KEY (codAutor) REFERENCES fAutor(codAutor)
);
