{6. Agregar al menú del programa del ejercicio 5, opciones para:
a. Añadir uno o más celulares al final del archivo con sus datos ingresados por teclado.
b. Modificar el stock de un celular dado.
c. Exportar el contenido del archivo binario a un archivo de texto denominado: ”SinStock.txt”,
con aquellos celulares que tengan stock 0.
NOTA: Las búsquedas deben realizarse por nombre de celular.
}

program ejercicio5;
type
    celular = record
        codigo: integer;
        nombre: string[20];
        descripcion: string[30];
        marca: string[20];
        precio: real;
        stockMinimo: integer;
        stockDisponible: integer;
    end;
    archivo_celular = file of celular;


procedure imprimoDatosCelular(c: celular);
begin 
    writeln('Código: ', c.codigo, '. Nombre: ', c.nombre, '. Descripcion: ', c.descripcion, 
    '. Marca: ', c.marca, '. Precio: ', c.precio, '. Stock mínimo: ', c.stockMinimo, '. Stock Disponible: ', 
    c.stockDisponible, '.');
end;

// 5A: 
procedure crearArchivoCelulares(var arc: archivo_celular; var arcText: Text);
var
    nombreFisico: string[20];
    c: celular;
begin
    writeln('Ingrese el nombre del archivo: ');
    readln(nombreFisico);
    assign(arc, nombreFisico);
    rewrite(arc);
    reset(arcText);
    while(not EOF(arcText)) do begin
        readln(arcText, c.codigo, c.precio, c.marca);
        readln(arcText, c.stockDisponible, c.stockMinimo, c.descripcion);
        readln(arcText, c.nombre);
        write(arc, c);
    end;
    close(arc);
    close(arcText);
end;

// 5B:
procedure listadoStockMenorAlMinimo(var arc: archivo_celular);
var
    c: celular;
begin
    reset(arc);
    writeln('El listado de celulares con stock menor al stock mínimo es el siguiente: ');
    while (not EOF(arc)) do begin 
        read(arc, c);
        if (c.stockMinimo > c.stockDisponible) then 
            imprimoDatosCelular(c);
    end;
    close(arc);
end;
 
// 5C: 
procedure listadoDescripcionCaracteres(var arc: archivo_celular);
var 
    c: celular;
    descrip: string[30];
begin
    reset(arc);
    writeln('Ingrese la descripción del celular: ');
    readln(descrip);
    writeln('El listado de celulares cuya descripción contenga una cadena de caracteres 
    proporcionada por el usuario es el siguiente: ');
    while (not EOF(arc)) do begin 
        read(arc, c);
        if (c.descripcion = descrip) then 
            imprimoDatosCelular(c);
    end;
    close(arc);
end;

// 5D: 
procedure exportarArchivoBinarioATexto(var arc: archivo_celular; var arcText: Text);
var 
    c: celular;
begin
    reset(arc);
    rewrite(arcText);
    while (not EOF(arc)) do begin 
        read(arc, c);
        writeln(arcText, c.codigo, ' ', c.precio:0:2, ' ', c.marca);
        writeln(arcText, c.stockDisponible, ' ', c.stockMinimo, ' ', c.descripcion);
        writeln(arcText, c.nombre);
    end;
    close(arc);
    close(arcText);
end;

// 6A
procedure leerCelular(var c: celular);
begin
    writeln('Ingrese el nombre del celular ("Fin" para terminar): ');
    readln(c.nombre);
    if (c.nombre <> 'Fin') then begin 
        writeln('Ingrese el codigo: ');
        readln(c.codigo);
        writeln('Ingrese la descripción: ');
        readln(c.descripcion);
        writeln('Ingrese la marca: ');
        readln(c.marca);
        writeln('Ingrese el precio: ');
        readln(c.precio);
        writeln('Ingrese el stock mínimo: ');
        readln(c.stockMinimo);
        writeln('Ingrese el stock disponible: ');
        readln(c.stockDisponible);
    end;
end;

procedure agregarCelular(var arc: archivo_celular);
var
    c: celular;
begin
    reset(arc);
    seek(arc, filesize(arc));
    leerCelular(c);
    while(c.nombre <> 'Fin') do begin 
        write(arc, c);
        leerCelular(c);
    end;
    close(arc);
end;

// 6B
procedure modificarStock(var arc: archivo_celular);
var 
    c: celular;
    stockNuevo: integer;
    nombreCelularDado: string[20];
    encontre: boolean;
begin
    writeln('Ingrese el nuevo stock: ');
    readln(stockNuevo);
    writeln('Ingrese el nombre de celular que quiera modificar su stock: ');
    readln(nombreCelularDado);
    encontre := false;
    reset(arc);
    while (not EOF(arc) and not encontre) do begin 
        read(arc, c);
        if (c.nombre = nombreCelularDado) then begin 
            encontre := true;
            c.stockDisponible := stockNuevo;
            seek(arc, filepos(arc) - 1);
            write(arc, c);
        end;
    end;
    close(arc);
end;

// 6C
// c. Exportar el contenido del archivo binario a un archivo de texto denominado: ”SinStock.txt”,
//con aquellos celulares que tengan stock 0.
procedure exportarArchivoBinarioATextoStock0(var arc: archivo_celulares);
var
   arcText: Text;
   c: celular;

begin
     reset(arc);
     assign(arcText, 'SinStock.txt');
     rewrite(arcText);
     while (not EOF(arc)) do begin
           read(arc, c);
           if (c.stockDisponible = 0) then begin
              writeln(arcText, c.codigo, ' ', c.precio:0:2, ' ', c.marca);
              writeln(arcText, c.stockDisponible, ' ', c.stockMinimo, ' ', c.descripcion);
              writeln(arcText, c.nombre);
           end;
     end;
     close(arc);
     close(arcText);
end;

// MENU DE OPCIONES:
procedure menuOpciones(var arc: archivo_celular; var arcText: Text);
var 
    opcion: integer;
begin
    writeln('Las opciones son las siguientes: ');
    writeln('1: Crear un archivo de registros no ordenados de celulares y cargarlo con datos ingresados desde un archivo de texto.');
    writeln('2: Listar en pantalla los datos de aquellos celulares que tengan un stock menor al stock mínimo.');
    writeln('3: Listar en pantalla los celulares del archivo cuya descripción contenga una cadena de caracteres proporcionada por el usuario.');
    writeln('4: Exportar el archivo binario creado en el inciso a) a un archivo de texto denominado “celulares.txt” con todos los celulares del mismo. ');
    writeln('5: Añadir uno o más celulares al final del archivo con sus datos ingresados por teclado.');
    writeln('6: Modificar el stock de un celular dado..');
    writeln('7: Exportar el contenido del archivo binario a un archivo de texto denominado: ”SinStock.txt”, con aquellos celulares que tengan stock 0.');
    writeln('8: Salir del menú.');
    writeln('Elija una opción: ');
    readln(opcion);
    while (opcion <> 8) do begin 
        case opcion of
            1: crearArchivoCelulares(arc, arcText);
            2: listadoStockMenorAlMinimo(arc);
            3: listadoDescripcionCaracteres(arc);
            4: exportarArchivoBinarioATexto(arc, arcText);
            5: agregarCelular(arc);
            6: modificarStock(arc);
            7: exportarArchivoBinarioATextoStock0(arc);
        else    
            writeln('Opción inválida.');
        end;
        writeln('Vuelva a elegir una opción: ');
        readln(opcion);
    end;
end;

// PROGRAMA PRINCIPAL: 
var 
    arc: archivo_celular;
    arcText: Text;
begin
    assign(arcText, 'celulares.txt');
    menuOpciones(arc, arcText);
end.
