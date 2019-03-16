create schema oblig06;
set search_path to "$user$", oblig06;

CREATE TABLE Kunde(
        kundenummer		int primary key,
	kundenavn		varchar(40),
	kundeadresse		varchar(40),
 	kundefakturadresse	varchar(40)
);

CREATE TABLE Offentlig_Etat(
       kundenummer	int primary key,
       departement 	varchar(40),
       foreign key(kundenummer) references Kunde(kundenummer)
);

CREATE TABLE Firma(
       kundenummer	int primary key,
       org_nummer 		int, 
       unique(org_nummer),
       foreign key (kundenummer) references Kunde(kundenummer)
);

CREATE TABLE Telefonnummer(
      nummer		 int primary key,
      kundenummer	 int,
      foreign key (kundenummer) references Kunde(kundenummer)
);

CREATE TABLE Gruppe(
       gruppenavn	 varchar(40) primary key,
       timelønn		 numeric(1000,00)
);

CREATE TABLE  Ansatt(
       ansattnr		int primary key,
       gruppenavn 	varchar(40),
       foreign key (gruppenavn) references Gruppe(gruppenavn)
);


CREATE TABLE Prosjekt(
       prosjektnummer	int primary key,
       prosjektleder	int,
       prosjektnavn	varchar(40),
       kundenummer 	int,
       foreign key (prosjektleder) references Ansatt(ansattnr),
       foreign key (kundenummer) references Kunde(kundenummer)
);

CREATE TABLE AnsattDeltarIProsjekt(
       ansattnr		int,
       prosjektnr 	int,
       unique(ansattnr, prosjektnr),
       foreign key (ansattnr) references Ansatt(ansattnr),
       foreign key (prosjektnr) references Prosjekt(prosjektnummer)
);

