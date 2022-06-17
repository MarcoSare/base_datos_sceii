##Retorna las materias de un docente
create or replace procedure index_materia_docente(p_id int)
    language sql
begin
    set @id = (select id from docente where id = p_id);
    if @id is not null then
        select * from materia where id_docente = p_id;
    else
        signal sqlstate '45000'
            set message_text = 'El docente no existe';
    end if;
end;

##Crea una materia 
create or replace procedure crea_materia(p_nombre varchar(50), p_codigo varchar(10), p_id_docente int,p_id_semestre int)
    language sql
begin
    set @id_docente = (select id from docente where id = p_id_docente);
    if @id_docente is not null then
        set @id_semestre = (select id from semestre where id = p_id_semestre);
        if @id_semestre is not null then
            set @codigo = (select codigo from materia where codigo = p_codigo);
            if @codigo is null then
                insert into materia(nombre, codigo, id_docente, id_semestre)
                values (p_nombre, p_codigo, p_id_docente, p_id_semestre);
            else
                signal sqlstate '45000'
                    set message_text = 'El código ya existe';
            end if;
        else
            signal sqlstate '45000'
                set message_text = 'El semestre no existe';
        end if;
    else
        signal sqlstate '45000'
            set message_text = 'El docente  no existe';
    end if;
end;

##Elimina una materia
create or replace procedure delete_materia(p_id int)
    language sql
begin
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            select ('No se ha realizado la operación') as error;
            ROLLBACK;
        END;
    START TRANSACTION;
    DELETE from materia where id = p_id;
    COMMIT;
end;


##Edita los datos de una materia
create or replace procedure edit_materia(p_id int, p_nombre varchar(50), p_id_semestre int)
    language sql
begin

    START TRANSACTION;
    set @id_semestre = (select id from semestre where id = p_id_semestre);
    if @id_semestre is not null then
        set @id = (select id from materia where id = p_id);
        if @id is not null then
            update materia set nombre = p_nombre, id_semestre = p_id_semestre where id = p_id;
            COMMIT;
        else
            rollback;
            signal sqlstate '45000'
                set message_text = 'La materia no existe';
        end if;
    else
        rollback;
        signal sqlstate '45000'
            set message_text = 'El semestre no existe';
    end if;
end;


## verifica que el código de acceso para una materia no esté duplicado
create or replace procedure veri_codigo(p_codigo varchar(10))
    language sql
begin
    set @codigo = (select codigo from materia where codigo = p_codigo);
    if @codigo is not null then
        signal sqlstate '45000'
            set message_text = 'El código ya existe';
    end if;
end;

## Regresa el id del docente propietario de una materia, ingresando el id de la materia 
create or replace procedure get_docente_by_materia(p_id int)
    language sql
begin
    set @id_docente = (select id_docente from materia where id = p_id);
    if @id_docente is not null then
        select @id_docente as id_docente;
    else
        signal sqlstate '45000'
            set message_text = 'La materia no existe';
    end if;
end;





