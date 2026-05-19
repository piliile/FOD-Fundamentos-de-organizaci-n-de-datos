{El encargado de ventas de un negocio de productos de limpieza desea administrar el stock de los
productos que vende. Para ello, genera un archivo maestro donde figuran todos los productos que
comercializa. De cada producto se maneja la siguiente información: código de producto, nombre
comercial, precio de venta, stock actual y stock mínimo. Diariamente se genera un archivo detalle
donde se registran todas las ventas de productos realizadas. De cada venta se registran: código de
producto y cantidad de unidades vendidas. Resuelve los siguientes puntos:
a. Se pide realizar un procedimiento que actualice el archivo maestro con el archivo detalle,
teniendo en cuenta que:
i. Los archivos no están ordenados por ningún criterio.
ii. Cada registro del maestro puede ser actualizado por 0, 1 ó más registros del archivo
detalle.
b. ¿Qué cambios realizaría en el procedimiento del punto anterior si se sabe que cada registro
del archivo maestro puede ser actualizado por 0 o 1 registro del archivo detalle?}
// A.
program ejercicio8;
type
	producto = record
		codigo: integer;
		nombre: string[25];
		precio: real;
		stockActual: integer;
		stockMinimo: integer;
	end;
	archivoMaestro = file of producto;
	
	venta = record
		codigo: integer;
		cantidadVendidas: integer;
	end;
	archivoDetalle = file of venta;

// procedimientos 

procedure leerProducto(var p: producto);
begin
    write('Ingrese el codigo del producto (0 para terminar): ');
    readln(p.codigo);
    if (p.codigo <> 0) then begin
        write('Ingrese el nombre del producto: '); 
        readln(p.nombre);
        write('Ingrese el precio del producto: '); 
        readln(p.precio);
        write('Ingrese el stock actual del producto: '); 
        readln(p.stockActual);
        write('Ingrese el stock minimo del producto: '); 
        readln(p.stockMinimo);
    end;
end;

procedure creoMaestro(var maestro: archivoMaestro);
var
    p: producto;
	nombre: string[30];
begin	
	writeln('Ingrese el nombre a asignar al archivo maestro: ');
	readln(nombre);
	assign(maestro, nombre);
    rewrite(maestro); 
    leerProducto(p);
    while (p.codigo <> 0) do begin
        write(maestro, p); 
        leerProducto(p); 
    end;
    close(maestro);
end;

procedure leerVenta(var v: venta);
begin
    write('Ingrese el codigo del producto vendido (0 para terminar): ');
    readln(v.codigo);
    if (v.codigo <> 0) then begin
        write('Ingrese la cantidad de unidades vendidas: '); 
        readln(v.cantidadVendidas);
    end;
end;

procedure creoDetalle(var detalle: archivoDetalle);
var
    v: venta;
    nombre: string[30];
begin	
	writeln('Ingrese el nombre a asignar al archivo detalle: ');
	readln(nombre);
	assign(detalle, nombre);
    rewrite(detalle); 
    leerVenta(v); 
    while (v.codigo <> 0) do begin
        write(detalle, v);
        leerVenta(v);  
    end;
    close(detalle); 
end;

procedure actualizarMaestro(var maestro: archivoMaestro; var detalle: archivoDetalle);
var
    p: producto;
    v: venta;
    encontre: boolean;
begin
    reset(maestro);
    reset(detalle);
    while (not EOF(detalle)) do begin
        read(detalle, v);
        // tenemos que buscar el producto en el maestro 
        encontre := false;
        seek(maestro, 0); // nos poisicionamos al principio del maestro para empezar a buscar
        // recorremos el maestro viendo si coincide el codigo
        while (not EOF(maestro)) and (not encontre) do begin
            read(maestro, p);
            if (p.codigo = v.codigo) then begin // si encontramos el producto en el maestro
                encontre := true; // no hace falta seguir leyendo, encontramos el codigo a modificar
                p.stockActual := p.stockActual - v.cantidadVendidas; // restamos el stock actual con lo que se vendio
                seek(maestro, filepos(maestro) - 1); // como el read nos movio, volvemos atras 
                write(maestro, p); // pisamos el registro viejo con los datos actualizados 
            end;
        end;
    end;
    close(maestro);
    close(detalle);
end;

// programa principal

var
	maestro: archivoMaestro; 
	detalle: archivoDetalle;
begin
	creoMaestro(maestro);
	creoDetalle(detalle);
	actualizarMaestro(maestro, detalle);
end.
// B.
{No realizaría ningun cambio porque lo hago de manera eficiente al usar la variable boolean encontre. 
Hago solo una búsqueda y una sola escritura por producto vendido.}
