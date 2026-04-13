{El encargado de ventas de un negocio de productos de limpieza desea administrar el stock de los productos
que comercializa. Para ello, dispone de un archivo maestro en el que se registran todos los productos.
De cada producto se almacena la siguiente información: código de producto, nombre comercial, precio de venta,
stock actual y stock mínimo.
Diariamente se genera un archivo detalle donde se registran todas las ventas realizadas. De cada venta se
almacena: código de producto y cantidad de unidades vendidas.
Se solicita desarrollar un programa que permita:
a) Actualizar el archivo maestro a partir del archivo detalle, teniendo en cuenta que:
● Ambos archivos están ordenados por código de producto.
● Cada registro del archivo maestro puede ser actualizado por cero, uno o más registros del archivo
detalle.
● El archivo detalle sólo contiene registros cuyos códigos existen en el archivo maestro.
b) Generar un archivo de texto llamado “stock_minimo.txt” que contenga aquellos productos cuyo stock actual se
encuentre por debajo del stock mínimo permitido.}
program ejercicio2;
const
    valorAlto = 9999;
type
    producto = record
        codigo: integer;
        nombreComercial: string[20];
        precioVenta: real;
        stockActual: integer;
        stockMinimo: integer;
    end;
    venta = record
        codigo: integer;
        cantidadVendidas: integer;
    end;
    archivoProductos = file of producto;
    archivoVentas = file of venta;

procedure leerVenta(var arcDet: archivoVentas; var v: venta);
begin
    if (not EOF (arcDet)) then 
        read(arcDet, v);
    else
        v.codigo := valorAlto;
end;

procedure actualizarMaestro(var arcDet: archivoVentas; var arcMae: archivoProductos);
var
    p: producto;
    v: venta;
    codigoActual, totalVentas: integer;
begin
    reset(arcDet);
    reset(arcMae);
    leerVenta(arcDet, v);
    while (v.codigo <> valorAlto) do begin
        codigoActual := v.codigo;
        totalVentas := 0;
        while (codigoActual = v.codigo) do begin 
            totalVentas := totalVentas + v.cantidadVendidas;
            leerVenta(arcDet, v);
        end;
        read(arcMae, p);
        while (p.codigo <> codigoActual) do 
            read(arcMae, p);
        p.stockActual := p.stockActual - totalVentas;
        seek(arcMae, filepos(arcMae) - 1);    
        write(arcMae, p);
    end;
    close(arcDet);
    close(arcMae);
end;

procedure generarStockMin(var arcMae: archivoProductos);
var 
    arcText: text;
    p: producto;
begin
    reset(arcMae);
    assign(arcText, 'stock_minimo.txt');
    rewrite(arcText);
    while (not EOF (arcMae)) do begin 
        read(arcMae, p);
        if (p.stockActual < p.stockMinimo) then 
            writeln(arcText, 'Codigo: ', p.codigo, ' Nombre: ', p.nombreComercial, ' Stock actual: ', p.stockActual, 
            ' Stock minimo: ', p.stockMinimo););
    end;
    close(arcMae);
    close(arcText);
end;

var
    detalle: archivoVentas;
    maestro: archivoProductos;
    nombre1, nombre2: string[20];
begin
    writeln('Ingrese el nombre del archivo detalle: ');
    readln(nombre1);
    assign(detalle, nombre1);
    writeln('Ingrese el nombre del archivo maestro: ');
    readln(nombre2);
    assign(maestro, nombre2);
    actualizarMaestro(detalle, maestro);
    generarStockMin(maestro);
end.
