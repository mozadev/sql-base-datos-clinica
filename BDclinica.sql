create database BDClinica

USE BDClinica

create table tbmedico(
idmed char(5) primary key nonclustered not null,
nomMed varchar (50) not null,
apMed varchar (50) not null
	constraint UQ_NOMAPE UNIQUE (nomMed,apMed),
espMed VARCHAR (50) NOT NULL
	constraint CK_ESPECIALIDAD check (espMed IN ('Pediatría', 'Ginecología', 'Cardiología') ),

colMed CHAR (12) NOT NULL
	constraint CK_COLEGIATURA check (colMed IN ('2', '4', '6', '8') ),

)


--insercion de datos

insert into tbmedico(idmed,nomMed,apMed,espMed,colMed)
values ('2','karina','santos','Ginecología','6')


insert into tbmedico(idmed,nomMed,apMed,espMed,colMed)
values ('3','karina','reyes','Ginecología','6')

insert into tbmedico(idmed,nomMed,apMed,espMed,colMed)
values ('1','jose','torres','Ginecología','6')

insert into tbmedico(idmed,nomMed,apMed,espMed,colMed)
values ('4','jose','velasquez','Cardiología','4'),
('5','maria','morales','Pediatría','2'),
('6','pedro','tejada','Cardiología','8'),
('7','juan','terrazas','Pediatría','4')


select*from tbmedico

--CREACION DE TABLAS
CREATE TABLE TBPACIENTE
(
	idPac CHAR(5) PRIMARY KEY NOT NULL,
	nomPac VARCHAR (50) NOT NULL,
	apPac VARCHAR (50) NOT NULL,
	fnaPac DATE NOT NULL
		constraint CK_FECHANAC check (DATEPART(YEAR, fnaPac) >= 1950),
	fonoPac VARCHAR (10)  NOT NULL
		constraint CK_FONOPAC check (fonoPac LIKE '95432%' ),
)

--INSERCION DE DATOS
INSERT INTO TBPACIENTE (idPac, nomPac, apPac, fnaPac, fonoPac)
VALUES ('2', 'FABIOLA', 'ALVARADO', '01-01-2000', '9543293939')
INSERT INTO TBPACIENTE (idPac, nomPac, apPac, fnaPac, fonoPac)
values('3', 'cesar', 'mesa', '2017/08/25', '9543293939')
INSERT INTO TBPACIENTE (idPac, nomPac, apPac, fnaPac, fonoPac)
values('1', 'cesar', 'reyes', '2019/08/25', '9543293439')

INSERT INTO TBPACIENTE (idPac, nomPac, apPac, fnaPac, fonoPac)
values('4', 'jose', 'palacios', '2019/08/25', '9543293439'),
('5', 'mario', 'vela', '2019/08/25', '9543293439'),
('6', 'julio', 'paredes', '2015/07/25', '9543293439'),
('7', 'katy', 'chipana', '2018/08/20', '9543293439'),
('8', 'marcelo', 'alvares', '2019/07/02', '9543293439')
INSERT INTO TBPACIENTE (idPac, nomPac, apPac, fnaPac, fonoPac)
values('10', 'lurdes', 'alcantara', '2019/08/25', '9543293439')
INSERT INTO TBPACIENTE (idPac, nomPac, apPac, fnaPac, fonoPac)
values('9', 'carmen', 'davila', '2019/08/25', '9543293439')

INSERT INTO TBPACIENTE (idPac, nomPac, apPac, fnaPac, fonoPac)
values('11', 'camila', 'suarez', '2019/08/25', '9543293439')

delete from TBPACIENTE where idPac=11
select *from TBPACIENTE

SELECT DATEPART(yy, '2017/08/25') AS DatePartInt;


--CREACION DE TABLAS
CREATE TABLE TBRECETA
(
	numRec INT IDENTITY(1001,1) PRIMARY KEY NOT NULL,
	fecRec DATE NOT NULL constraint CK_FECHAREC DEFAULT getdate(),
		
	idPac CHAR(5) NOT NULL,
		constraint FK_IDPAC FOREIGN KEY (idPac) REFERENCES TBPACIENTE(idPac),
	idMed CHAR(5) NOT NULL
		constraint FK_IDMED FOREIGN KEY (idMed) REFERENCES TBMEDICO(idMed)
)

--INSERCION DE DATOS
INSERT INTO TBRECETA (idPac, idMed)
VALUES (1, 2)
INSERT INTO TBRECETA (idPac, idMed)
VALUES (8, 7),
(4, 4),
(5, 3),
(7, 5),
(4, 3)

delete from TBRECETA where numRec=1004

SELECT * FROM TBRECETA

--CREACION DE TABLAS
CREATE TABLE TBDETALLERECETA
(
	numRec INT NOT NULL,
	codMedicina CHAR(5) NOT NULL
		constraint PK_NUMREC_CODMED PRIMARY KEY (numRec, codMedicina),
		constraint FK_NUMREC FOREIGN KEY (numRec) REFERENCES TBRECETA(numRec),

	canti TINYINT NOT NULL
		constraint CK_CANTIDAD check (canti > 0),
	dosis VARCHAR(50) NOT NULL,
	indica VARCHAR(50) NOT NULL,
)

--INSERCION DE DATOS
INSERT INTO TBDETALLERECETA (numRec, codMedicina, canti, dosis, indica)
VALUES (1002, '1', 10, 'UNA PASTILLA', 'CADA 8 HORAS')

SELECT * FROM TBDETALLERECETA

--CREACION INDICE
--Cree un Índice único compuesto (fecha y idpaciente de RECETA)
--ordenado de forma ascendente
CREATE UNIQUE INDEX IX_FECHA_IDPACIENTE_RECETA
ON TBRECETA(fecRec, idPac ASC)

/*
b. Cree un Índice normal compuesto (nombre y apellidos del
paciente) ordenado de forma descendente para ambos campos.
*/
CREATE INDEX IX_NOMBRE_APELLIDO_PACIENTE
ON TBPACIENTE (nomPac DESC, apPac DESC)
--. Cree un Índice normal (apellido del médico), incluir el campo especialidad

CREATE INDEX IX_APELLIDO_MEDICO
ON TBMEDICO (apMed)