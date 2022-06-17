##Inserta un alumno
create procedure insert_alumno(p_id_usuario int, p_no_control int, p_id_carrera int, p_id_semestre int)
language sql
    begin
        start transaction;
        insert into alumno(id_usuario, no_control ,id_carrera, id_semestre)
        values(p_id_usuario, p_no_control, p_id_carrera, p_id_semestre);
        commit;
    end;

##Inserta un docente
create procedure insert_docente(p_id_usuario int)
language sql
    begin
        start transaction ;
        insert into docente(id_usuario)
        values(p_id_usuario);
        commit;
    end;

##Inserta un visitante
create procedure insert_visitante(p_id_usuario int, p_institucion varchar(50))
language sql
    begin
        start transaction ;
        insert into visitante(id_usuario, institucion, fecha)
        values(p_id_usuario, p_institucion, curdate());
        commit;
    end;

##Inserta un usuario y a ese usuario le asigna un alumno 
create or replace procedure insert_usuario_alumno
(p_nombre varchar(50), p_apelllidos varchar(50), p_correo varchar(50), p_clave varchar(44),
p_genero char(1),p_fecha_nac date, p_no_control int, p_id_carrera int, p_id_semestre int)
language sql
    begin
        start transaction;
        set @correo = (select id from usuario where correo = p_correo);
        if @correo is null then
        set @no_control = (select no_control from alumno where no_control = p_no_control);
        if @no_control is null then
        insert into usuario(nombre, apellidos, correo, clave, genero, tipoUsuario, fecha_Nac)
        values(p_nombre, p_apelllidos, p_correo, password(p_clave), p_genero,'alumno', p_fecha_nac);
        set @id_usuario = (select id from usuario u where correo=p_correo);
        if @id_usuario is null then
            rollback ;
            signal sqlstate '45000'
            set message_text  = 'El usuario no existe';
        else
            call insert_alumno(@id_usuario,p_no_control,p_id_carrera,p_id_semestre);
            commit;
        commit;
            end if;
        else
            signal sqlstate '45000'
            set message_text  = 'El no. Control ya se encuentra registrado';
            end if;
        else
            signal sqlstate '45000'
            set message_text  = 'El correo ya se encuentra registrado';
            end if;
    end;

##Inserta un usuario y a ese usuario le asigna un docente
create or replace procedure insert_usuario_docente
(p_nombre varchar(50), p_apelllidos varchar(50), p_correo varchar(50), p_clave varchar(44),
p_genero char(1),p_fecha_nac date)
language sql
    begin
        start transaction ;
         set @correo = (select id from usuario where correo = p_correo);
        if @correo is null then
        insert into usuario(nombre, apellidos, correo, clave, genero, tipoUsuario, fecha_Nac)
        values(p_nombre, p_apelllidos, p_correo, password(p_clave), p_genero,'docente', p_fecha_nac);
        set @id_usuario = (select id from usuario u where correo=p_correo);
        if @id_usuario is null then
            signal sqlstate '45000'
            set message_text  = 'el usuario no existe';
            rollback ;
        else
            call insert_docente(@id_usuario);
            commit;
        commit;
            end if;
        else
            signal sqlstate '45000'
            set message_text  = 'El correo ya se encuentra registrado';
            end if;
    end;

##Inserta un usuario y a ese usuario le asigna un visitante
create or replace procedure insert_usuario_visitante
(p_nombre varchar(50), p_apelllidos varchar(50), p_correo varchar(50), p_clave varchar(44),
p_genero char(1),p_fecha_nac date, p_institucion varchar(50))
language sql
    begin
        start transaction ;
        set @correo = (select id from usuario where correo = p_correo);
        if @correo is null then
        insert into usuario(nombre, apellidos, correo, clave, genero, tipoUsuario, fecha_Nac)
        values(p_nombre, p_apelllidos, p_correo, password(p_clave), p_genero,'visitante', p_fecha_nac);
        set @id_usuario = (select id from usuario u where correo=p_correo);
        if @id_usuario is null then
            signal sqlstate '45000'
            set message_text  = 'el usuario no existe';
            rollback ;
        else
            call insert_visitante(@id_usuario,p_institucion);
            commit;
        commit;
            end if;
        else
             signal sqlstate '45000'
            set message_text  = 'El correo ya se encuentra registrado';
             end if;
    end;

##Verifica los datos corrrespondientes para hacer un login
create or replace procedure login (p_correo varchar(50), p_clave varchar(44))
language sql
    begin
        set @id = (select id from usuario where correo = p_correo and clave = password(p_clave));
        if @id is not null then
            select token from usuario where id = @id;
            else
            signal sqlstate '45000'
            set message_text  = 'Datos incorrectos';
            end if;
    end;


##Con base al id de un usuario retorna el id de la columna correspondiente al tipo de ese usuario
create or replace procedure get_id_tipo_Usuario(p_id int)
    language sql
begin
    set @tipoUsuario = (select tipoUsuario from usuario where id = p_id);
    if @tipoUsuario is not null then
        if @tipoUsuario like 'alumno' then
            select id from alumno where id_usuario = p_id;
        else
            if @tipoUsuario like 'docente' then
                select id from docente where id_usuario = p_id;
            else
                if @tipoUsuario like 'visitante' then
                    select id from visitante where id_usuario = p_id;
                else
                    signal sqlstate '45000'
                        set message_text = 'El tipo de usuario no existe';
                end if;
            end if;
        end if;
    else
        signal sqlstate '45000'
            set message_text = 'El usuario no existe';
    end if;
end;


##Con base al id del tipo de usuario  retorna el id de usuario de dicho tipo de usuario
create or replace procedure get_id_user(p_id int, p_tipo varchar(20))
    language sql
begin
    if p_tipo like 'alumno' then
        set @id = (select id_usuario from alumno where id = p_id);
        if @id is not null then
            select @id as id;
        else
            signal sqlstate '45000'
                set message_text = 'El alumno no existe';
        end if;
    end if;
    if p_tipo like 'docente' then
        set @id = (select id_usuario from docente where id = p_id);
        if @id is not null then
            select @id as id;
        else
            signal sqlstate '45000'
                set message_text = 'El alumno no existe';
        end if;
    end if;
    if p_tipo like 'visitante' then
        set @id = (select id_usuario from visitante where id = p_id);
        if @id is not null then
            select @id as id;
        else
            signal sqlstate '45000'
                set message_text = 'El alumno no existe';
        end if;
    end if;
end;