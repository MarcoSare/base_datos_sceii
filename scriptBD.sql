drop database sceii;
create database sceii;
use sceii;

create table carrera(
    id int not null auto_increment,
    nombre varchar(50) not null,
    constraint carreraPK primary key (id)
);

create table semestre(
    id int not null auto_increment,
    nombre varchar(50) not null,
    constraint semestrePK primary key (id)
);

create table usuario(
    id int not null auto_increment,
    token varchar(400) unique,
    nombre varchar(50) not null,
    apellidos varchar(50) not null,
    correo varchar(50) not null unique,
    clave char(44) not null,
    genero char(1) not null,
    tipoUsuario varchar(15) not null,
    fecha_Nac date,
    constraint usuarioPK primary key (id),
    constraint usuarioUN unique (correo),
    constraint usuarioCK1 check
        (genero = 'm' or genero = 'f' or genero = 'o'),
    constraint usuarioCK2 check
        (tipoUsuario = 'administrador' or tipoUsuario = 'docente' or
        tipoUsuario = 'alumno' or tipoUsuario = 'visitante')
);

create table administrador(
    id int not null auto_increment,
    id_usuario int,
    constraint adminPK primary key (id),
    constraint adminFK foreign key (id_usuario) references usuario (id)
);

create table docente(
    id int not null auto_increment,
    id_usuario int,
    constraint docentePK primary key (id),
    constraint docenteFK foreign key (id_usuario) references usuario (id)
);

create table alumno(
    id int not null auto_increment,
    no_control varchar(8) not null,
    id_usuario int,
    id_carrera int,
    id_semestre int,
    constraint alumnoPK primary key (id),
    constraint alumnoUN unique (no_control),
    constraint alumnoFK1 foreign key (id_usuario) references usuario (id),
    constraint alumnoFK2 foreign key (id_carrera) references carrera (id),
    constraint alumnoFK3 foreign key (id_semestre) references semestre (id)
);

create table visitante(
    id int not null auto_increment,
    institucion varchar(50),
    fecha date,
    id_usuario int,
    constraint visitantePK primary key (id),
    constraint visitanteFK1 foreign key (id_usuario) references usuario (id)
);

create table materia(
    id int not null auto_increment,
    nombre varchar(50) not null,
    codigo varchar(10) not null,
    id_docente int,
    id_semestre int,
    constraint materiaPK primary key (id),
    constraint materiaUN unique (codigo),
    constraint materiaFK1 foreign key (id_docente) references docente (id),
    constraint materiaFK2 foreign key (id_semestre) references semestre (id)
);



create table prestamo(
    id int not null auto_increment,
    descripcion varchar(100),
    fecha_Ini date,
    fecha_Fin date,
    fecha_Ent date,
    id_usuario int,
    constraint prestamoPK primary key (id),
    constraint prestamoFK foreign key (id_usuario) references usuario (id),
    constraint prestamoCK check (fecha_Ini < fecha_Ent)
);

create table practicas(
    id int not null auto_increment,
    nombre varchar(50) not null,
    valor float,
    porcentaje int,
    actividades int,
    realizo int,
    id_materia int,
    constraint practicasPK primary key (id),
    constraint practicasFK foreign key (id_materia) references materia (id),
    constraint practicasCK check (valor >= 0 and valor <= 100)
);

create table archivo(
    id int not null auto_increment,
    nombre varchar(50),
    enlace text(500),
    id_practica int,
    constraint archivoPK primary key (id),
    constraint archivoFK foreign key (id_practica) references practicas (id)
);

create table cuestionario(
    id int not null auto_increment,
    valor float,
    id_practica int,
    constraint cuestionarioPK primary key (id),
    constraint cuestionarioFK foreign key (id_practica) references practicas (id),
    constraint cuestionarioCK check (valor >= 0 and valor <= 100)
);

create table preguntas(
    id int not null auto_increment,
    descripcion varchar(100),
    id_cuestionario int,
    constraint preguntasPK primary key (id),
    constraint preguntasFK foreign key (id_cuestionario) references cuestionario (id)
);

create table respuestas(
    id int not null auto_increment,
    descripcion varchar(100),
    id_pregunta int,
    resultado boolean,
    constraint respuestasPK primary key (id),
    constraint respuestasFK foreign key (id_pregunta) references preguntas (id)
);

create table enlaces(
    id int not null auto_increment,
    enlace text(500),
    tipoEnlace varchar(30),
    id_materia int,
    constraint enlacesPK primary key (id),
    constraint enlacesFK foreign key (id_materia) references materia (id)
);

create table actividades (
    id int(11) not null auto_increment,
    nombre varchar(50) not null,
    realizado char(1) not null,
    id_practica int(11) not null,
    id_archivo int(11) default null,
    constraint actividadesPK primary key (id),
    constraint actividadesFK1 foreign key (id_practica) references practicas (id),
    constraint actividadesFK2 foreign key (id_archivo) references archivo (id)
);

create table alumno_materia(
    id int not null auto_increment,
    id_alumno int,
    id_materia int,
    constraint AMPK primary key (id),
    constraint AMFK1 foreign key (id_alumno) references alumno (id),
    constraint AMFK2 foreign key (id_materia) references materia (id)
);

create table alumno_practica(
    id int not null auto_increment,
    puntos float,
    id_alumno int,
    id_practica int,
    constraint APPK primary key (id),
    constraint APFK1 foreign key (id_alumno) references alumno (id),
    constraint APFK2 foreign key (id_practica) references practicas (id)
);

create table materia_practica(
    id int not null auto_increment,
    id_materia int,
    id_practica int,
    constraint MPPK primary key (id),
    constraint MPFK1 foreign key (id_materia) references materia (id),
    constraint MPFK2 foreign key (id_practica) references practicas (id)
);

create table practica_cuestionario(
    id int not null auto_increment,
    id_practica int,
    id_cuestionario int,
    constraint PCPK primary key (id),
    constraint PCFK1 foreign key (id_practica) references practicas (id),
    constraint PCFK2 foreign key (id_cuestionario) references cuestionario (id)
);

insert into carrera (nombre) values
	('Licenciatura en administracion'),
    ('Ingenier??a ambiental'),
    ('Ingenier??a bioqu??mica'),
    ('Ingenier??a electr??nica'),
    ('Ingenier??a en gesti??n empresarial'),
    ('Ingenier??a Industrial'),
    ('Ingenier??a mec??nica'),
    ('Ingenier??a mecatr??nica'),
    ('Ingenier??a en sistemas computacionales'),
    ('Ingenier??a qu??mica');


insert into semestre (nombre) values
	('1'),
    ('2'),
    ('3'),
    ('4'),
    ('5'),
    ('6'),
    ('7'),
    ('8'),
    ('9'),
    ('10'),
    ('11'),
    ('12'),
    ('otro');