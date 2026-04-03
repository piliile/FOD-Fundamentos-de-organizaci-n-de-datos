{7. Realizar un programa que permita:
a) Crear un archivo binario a partir de la información almacenada en un archivo de texto. El
nombre del archivo de texto es: “novelas.txt”. La información en el archivo de texto
consiste en: código de novela, nombre, género y precio de diferentes novelas argentinas.
Los datos de cada novela se almacenan en dos líneas en el archivo de texto. La primera
línea contendrá la siguiente información: código novela, precio y género, y la segunda
línea almacenará el nombre de la novela.
b) Abrir el archivo binario y permitir la actualización del mismo. Se debe poder agregar una
novela y modificar una existente. Las búsquedas se realizan por código de novela.
NOTA: El nombre del archivo binario es proporcionado por el usuario desde el teclado.}

program ejercicio7;
type
    novela= record
        codigo: integer;
        nombre: string[30];
        genero: string[20];
        precio: real;
    end;
    
    archivo_binario = file of novela;
    
// INCISO A:
procedure crearArchivoBinario(var arcText: Text; var arc: archivo_binario);
var 
    n: novela;
    nombre_binario: string[20];
begin
    reset(arcText);
    writeln('Ingrese el nombre asignado al archivo binario: ');
    readln(nombre_binario);
    assign(arc, nombre_binario);
    rewrite(arc);
    while (not EOF(arcText)) do begin 
        readln(arcText, n.codigo, n.precio, n.genero);
        readln(arcText, n.nombre);
        write(arc, n);
    end;
    close(arcText);
    close(arc);
end;

// INCISO B: 
procedure leerNovela(var n: novela);
begin
    writeln('Ingrese el codigo de novela: ');
    readln(n.codigo);
    if (n.codigo <> 0) then begin
        writeln('Ingrese el precio de novela: ');
        readln(n.precio);
        writeln('Ingrese el genero de novela: ');
        readln(n.genero);
        writeln('Ingrese el nombre de novela: ');
        readln(n.nombre);
    end;
end;

procedure agregarNovela(var arc: archivo_binario);
var
    n: novela;
begin
    leerNovela(n);
    reset(arc);
    seek(arc, filesize(arc));
    while (n.codigo <> 0) do begin 
        write(arc, n);
        leerNovela(n); // si? no es una sola? o es por si de una ingresa el codigo 0?
    end;
    close(arc);
end;

procedure modificarNovela(var arc: archivo_binario);
var
    n: novela;
    codigoAModificar, opcion: integer;
    modifique: boolean;
begin
    writeln('Ingrese el codigo de novela que desea modificar: ');
    readln(codigoAModificar);
    writeln('Elige qué es lo que quiere modificar de la novela, las opciones son las siguientes: ');
    writeln('1: nombre. 2: precio. 3: género. 4: todo.');
    readln(opcion);
    modifique := false;
    reset(arc);
    while (not EOF(arc) and not modifique) do begin 
        read(arc, n);
        if (n.codigo = codigoAModificar) then begin 
            case opcion of 
                1: begin writeln('Ingrese el nombre a modificar: '); readln(n.nombre); end;
                2: begin writeln('Ingrese el precio a modificar: '); readln(n.precio); end;
                3: begin writeln('Ingrese el genero a modificar: '); readln(n.genero); end;
                4: begin writeln('Ingrese en orden todo a modificar: '); readln(n.nombre); readln(n.precio); readln(n.genero); end;
            else    
                writeln('Opción inválida.');
            end;
            modifique := true;
            seek(arc, filepos(arc) - 1);
            write(arc, n);
        end;
    end;
    close(arc);
end;

procedure actualizarArchivoBinario(var arc: archivo_binario);
var 
    opcion: integer;
begin
    writeln('Las opciones para actualizar un archivo binario son las siguientes: ');
    writeln('1: Agregar una novela.');
    writeln('2: Modificar una novela.');
    writeln('3: Salir.');
    writeln('Ingrese qué opción quiere realizar: ');
    readln(opcion);
    while (opcion <> 3) do begin
        case opcion of  
            1: agregarNovela(arc);
            2: modificarNovela(arc);
        else
            writeln('Opción inválida.');
        end;
        writeln('Ingrese otra opción: ');
        readln(opcion);
    end;
end;
    
// PROGRAMA PRINCIPAL: 
var
    arcText: text;
    arc: archivo_binario;
begin
    assign(arcText, 'novelas.txt');
    crearArchivoBinario(arcText, arc);
    actualizarArchivoBinario(arc);
end.
