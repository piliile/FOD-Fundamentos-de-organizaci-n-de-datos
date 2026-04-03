{Realizar un programa para una tienda de celulares, que presente un menú con opciones para:
a. Crear un archivo de registros no ordenados de celulares y cargarlo con datos ingresados
desde un archivo de texto denominado “celulares.txt”. Los registros correspondientes a
los celulares deben contener: código de celular, nombre, descripción, marca, precio,
stock mínimo y stock disponible. El formato del archivo de texto de carga se especifica en
la NOTA 2 ubicada al final del ejercicio.
b. Listar en pantalla los datos de aquellos celulares que tengan un stock menor al stock mínimo.
c. Listar en pantalla los celulares del archivo cuya descripción contenga una cadena de
caracteres proporcionada por el usuario.
d. Exportar el archivo binario creado en el inciso a) a un archivo de texto denominado
“celulares.txt” con todos los celulares del mismo. El archivo de texto generado podría ser
utilizado en un futuro como archivo de carga (ver inciso a), por lo que debería respetar el
formato dado para este tipo de archivos en la NOTA 2.
NOTA 1: El nombre del archivo binario de celulares debe ser proporcionado por el usuario.
NOTA 2: El archivo de carga debe editarse de manera que cada celular se especifique en tres
líneas consecutivas. En la primera se especifica: código de celular, el precio y marca, en la
segunda el stock disponible, stock mínimo y la descripción y en la tercera nombre en ese orden.
Cada celular se carga leyendo tres líneas del archivo “celulares.txt”.
Ejemplo de Archivo
101 250000 Samsung
15 5 Galaxy A15 128GB
Galaxy A15
102 320000 Motorola
3 6 Moto G84 256GB color azul
Moto G84
104 950000 Apple
2 4 iPhone 15 256GB negro
iPhone 15}

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

// INCISO A: 
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

// INCISO B:
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
 
// INCISO C: 
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

// INCISO D: 
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
    writeln('5: Salir del menú.');
    writeln('Elija una opción: ');
    readln(opcion);
    while (opcion <> 5) do begin 
        case opcion of
            1: crearArchivoCelulares(arc, arcText);
            2: listadoStockMenorAlMinimo(arc);
            3: listadoDescripcionCaracteres(arc);
            4: exportarArchivoBinarioATexto(arc, arcText);
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
