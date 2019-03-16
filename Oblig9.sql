CREATE TABLE Movie(
	regnr varchar(40) primary key,
	forlag varchar(20),
	aldersårsgrense int not null,
	overtittel varchar(40) not null,
	undertittel varchar(40)

);

CREATE TABLE Worker(
	id varchar(25) primary key,
	fødselsdato date not null,
	fornavn varchar(20) not null,
	etternavn varchar(20),
	artistnavn varchar(20),
	land varchar(20) not null,
	check(etternavn is not null or artistnavn is not null),
	unique(fornavn, etternavn, artistnavn)
	
);

CREATE TABLE Function(
	navn varchar(40) primary key
);

CREATE TABLE WorkerHasFunctionInMovie(
	ansattid varchar(25) not null references Worker(id),
	regnr varchar(40)not null references Movie(regnr),
	navn varchar(40) not null references Function(navn),
	unique(regnr, ansattid),
	unique(ansattid, regnr, navn)
);


CREATE TABLE Soundtrack(
	nr varchar(20) primary key,
	sangid int,
	språk varchar(20),
	check(sangid is not null or språk is not null)
);

CREATE TABLE Scene(
	nr int primary key,
	regnr varchar(40) not null references Movie(regnr),
	ansattnr varchar(25) references Worker(id),
	lydspornr varchar(20) references Soundtrack(nr)
);

CREATE TABLE Picture(
	id int primary key,
	dato date not null,
	scenenr int not null references Scene(nr),
	ansattid varchar(25) not null references Worker(id),
	handling varchar(25) not null
);


INSERT INTO Movie(regnr, aldersårsgrense, overtittel)
VALUES ('AR3843', '13', 'Amazing Razë́');

INSERT INTO Movie(regnr, aldersårsgrense, overtittel)
VALUES('AFD4833', '15', 'Anne Franks dagbok');

INSERT INTO Movie(regnr, aldersårsgrense, overtittel)
VALUES('AFD4838', '18', 'Anne Frank');

INSERT INTO Movie(regnr, aldersårsgrense, overtittel, forlag)
VALUES('TGF834', '15', 'The god father', 'Steven Gleeze');

INSERT INTO Movie(regnr, aldersårsgrense, overtittel, undertittel)
VALUES('TGF34373', '18', 'The god father', 'part 2');


INSERT INTO Worker(id, fødselsdato, fornavn, etternavn, land)
VALUES ('23', '1984-01-23', 'Ellie', 'watson', 'Amerika' );

INSERT INTO Worker(id, fødselsdato, fornavn, artistnavn, land)
VALUES ('3438', '1983-08-11', 'Michael', 'Astro', 'Amerika');

INSERT INTO Worker(id, fødselsdato, fornavn, etternavn, land)
VALUES ('1234', '1990-01-23', 'Christian', 'Thomsen', 'Japan');

INSERT INTO Worker(id, fødselsdato, fornavn, artistnavn, land)
VALUES ('3482', '1994-01-23', 'Eva', 'Danielsen', 'Norge');

INSERT INTO Function
VALUES ('skuespiller');

INSERT INTO Function
VALUES ('fotograf');

INSERT INTO Function
VALUES ('komponist');


INSERT INTO Soundtrack(nr, språk)
VALUES(5, 'AS83MR483');

INSERT INTO Soundtrack(nr, språk)
VALUES(2, 'Engelsk');

INSERT INTO Scene(nr, regnr, ansattnr)
VALUES('2232232', 'AR3843', '3438');

INSERT INTO Scene(nr, regnr, ansattnr, lydspornr)
VALUES ('3', 'AR3843', '23', '2');


INSERT INTO Picture(id, dato, scenenr, ansattid, handling)
VALUES('1', '1884-06-24', '2232232', '828232', 'løping');

INSERT INTO WorkerHasFunctionInMovie
VALUES('23', 'AFD4833', 'skuespiller');

INSERT INTO WorkerHasFunctionInMovie
VALUES('3438', 'TGF834', 'komponist');

INSERT INTO WorkerHasFunctionInMovie
VALUES('1234', 'TGF834', 'fotograf');

SELECT w.fornavn, w.etternavn, w.artistnavn
FROM Worker w, WorkerHasFunctionInMovie whim, Picture p, Movie m, Scene s
WHERE w.id = whim.ansattid and whim.navn = 'skuespiller' and m.overtittel = 'Amazing Raze' and whim.regnr = m.regnr and p.dato > '1884-01-01' and p.dato < '1884-12-31'
and p.scenenr = s.nr and s.regnr = m.regnr;

SELECT w.fornavn, w.etternavn, w.artistnavn
FROM Worker w, Picture p, Scene s, Movie m, WorkerHasFunctionInMovie whim
WHERE  p.dato > '1884-01-01' and p.dato < '1884-12-31' and p.scenenr = s.nr and s.regnr = m.regnr and whim.regnr = m.regnr and whim.ansattid = w.id;

SELECT forlag
FROM Movie
WHERE aldersårsgrense = 15;

SELECT DISTINCT handling
FROM Picture
WHERE handling is not null;

SELECT whfim.navn
FROM WorkerHasFunctionInMovie whfim, Worker w
WHERE whfim.ansattid = w.id and w.fødselsdato > '1990-01-01' and w.fødselsdato < '1990-12-31';

SELECT w.fornavn, w.etternavn, w.artistnavn
FROM Worker w, WorkerHasFunctionInMovie whim
WHERE w.land = 'Amerika' and whim.navn = 'komponist';

SELECT regnr
FROM Movie 
WHERE overtittel is not null and undertittel is null;

SELECT w.fornavn, w.etternavn, w.artistnavn
FROM Worker w, WorkerHasFunctionInMovie whim
WHERE whim.ansattid = w.id and whim.navn = 'komponist';


SELECT w.fornavn, w.etternavn, w.artistnavn
FROM Worker w, Picture p, Movie m, WorkerHasFunctionInMovie whim
WHERE p.dato > '1939-01-01' and p.dato < '1945-12-31' and m.overtittel = 'Anne Franks Dagbok' and whim.ansattid = w.id and whim.regnr = m.regnr and w.id = p.ansattid
and whim.navn = 'fotograf';


/*Får feil på group by fornavn, etternavn og artistnavn*/
CREATE VIEW A(fornavn, etternavn, artistnavn, antallFilmer) as 
	SELECT w.fornavn, w.etternavn, w.artistnavn, count(*)
	FROM Worker w, Picture p, Scene s, Movie m, WorkerHasFunctionInMovie whim
	WHERE p.dato < '1994-01-01' and p.dato > '1994-12-31' and p.scenenr = s.nr and w.id = whim.ansattid and whim.regnr = m.regnr and m.regnr = s.regnr
	GROUP BY fornavn, etternavn, artistnavn;  


SELECT fornavn, artistnavn, etternavn
FROM A
HAVING max(antallfilmer) = antallfilmer;


/*Testene fungerere, men må få frem resultatet ved å legge til flere insert setninger*/

