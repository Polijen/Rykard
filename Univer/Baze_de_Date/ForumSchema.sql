-- ================================
--  ForumSchema.sql
--  DDL pentru schema bazei de date
-- ================================

-- 1. Tabel domenii
CREATE TABLE fDomeniu (
  codD       VARCHAR2(10) PRIMARY KEY,
  denumire   VARCHAR2(100) NOT NULL,
  descriere  VARCHAR2(500)
);

-- 2. Tabel autori
CREATE TABLE fAutor (
  codAutor   VARCHAR2(10) PRIMARY KEY,
  nume       VARCHAR2(100) NOT NULL,
  email      VARCHAR2(100) NOT NULL UNIQUE
);

-- 3. Tabel postări
CREATE TABLE fPostare (
  codP       NUMBER PRIMARY KEY,
  titlu      VARCHAR2(200) NOT NULL,
  codAutor   VARCHAR2(10)  NOT NULL,
  codD       VARCHAR2(10)  NOT NULL,
  nLike      NUMBER DEFAULT 0 CHECK (nLike >= 0),
  continut   VARCHAR2(1000),
  CONSTRAINT fk_post_autor   FOREIGN KEY (codAutor) REFERENCES fAutor(codAutor),
  CONSTRAINT fk_post_domeniu FOREIGN KEY (codD)     REFERENCES fDomeniu(codD)
);

-- 4. Tabel comentarii
CREATE TABLE fComentariu (
  codComent  NUMBER PRIMARY KEY,
  codP       NUMBER       NOT NULL,
  codAutor   VARCHAR2(10) NOT NULL,
  continut   VARCHAR2(500) NOT NULL,
  nVotDa     NUMBER DEFAULT 0 CHECK (nVotDa  >= 0),
  nVotNu     NUMBER DEFAULT 0 CHECK (nVotNu >= 0),
  CONSTRAINT fk_coment_post  FOREIGN KEY (codP)     REFERENCES fPostare(codP),
  CONSTRAINT fk_coment_autor FOREIGN KEY (codAutor) REFERENCES fAutor(codAutor)
);
-- Is pentru a genera automat ID ca sa nu fie introdus manual, nu le-am dat RUN pentru ca nu pare a fi la moment ceva ce as face by default
-- 5. (Opţional) secvenţe pentru chei surrogate
CREATE SEQUENCE seq_postare START WITH 1 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE seq_coment   START WITH 1 INCREMENT BY 1 NOCACHE;
