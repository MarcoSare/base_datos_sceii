##Inserta un token a un usuario por su correo(el correo es único)
create or replace procedure insert_token(p_correo varchar(50), p_token varchar(400))
    language sql
    begin
    update usuario set token = p_token where correo = p_correo;
    end;