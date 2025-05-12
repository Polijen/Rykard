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

--new table 

-- Tabelul pentru domenii
CREATE TABLE fDomeniu (
    codD VARCHAR(10) PRIMARY KEY, -- cheie primară
    denumire VARCHAR(100) NOT NULL, -- nu permite valori nule
    descriere VARCHAR(255) DEFAULT 'Nespecificat' -- valoare implicită
);

-- Tabelul pentru autori
CREATE TABLE fAutor (
    codAutor VARCHAR(10) PRIMARY KEY, -- cheie primară
    nume VARCHAR(100) NOT NULL, -- nu permite valori nule
    email VARCHAR(100) UNIQUE NOT NULL, -- unic + obligatoriu
    CHECK (INSTR(email, '@') > 1) -- constrângere: trebuie să conțină '@' (validare simplă)
);

-- Tabelul pentru postări
CREATE TABLE fPostare (
    codP INT PRIMARY KEY, -- cheie primară
    titlu VARCHAR(255) NOT NULL, -- titlu obligatoriu
    codAutor VARCHAR(10) NOT NULL,
    codD VARCHAR(10) NOT NULL,
    nLike INT DEFAULT 0 CHECK (nLike >= 0), -- număr de like-uri pozitiv
    continut VARCHAR(1000) NOT NULL, -- conținut obligatoriu
    FOREIGN KEY (codAutor) REFERENCES fAutor(codAutor) ON DELETE CASCADE,
    FOREIGN KEY (codD) REFERENCES fDomeniu(codD) ON DELETE SET NULL
);

-- Tabelul pentru comentarii
CREATE TABLE fComentariu (
    codP INT NOT NULL,
    codAutor VARCHAR(10) NOT NULL,
    continut VARCHAR(500) NOT NULL,
    nVotDa INT DEFAULT 0 CHECK (nVotDa >= 0),
    nVotNu INT DEFAULT 0 CHECK (nVotNu >= 0),
    PRIMARY KEY (codP, codAutor), -- un singur comentariu per autor per postare
    FOREIGN KEY (codP) REFERENCES fPostare(codP) ON DELETE CASCADE,
    FOREIGN KEY (codAutor) REFERENCES fAutor(codAutor) ON DELETE CASCADE
);
