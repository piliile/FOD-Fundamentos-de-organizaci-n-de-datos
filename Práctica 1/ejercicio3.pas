{3. Realizar un programa que presente un menú con opciones para:
a. Crear un archivo binario de registros no ordenados de empleados y
completarlo con datos ingresados desde teclado.
De cada empleado se registra:
número de empleado, apellido, nombre, edad y DNI.
Algunos empleados pueden ingresan el DNI con valor 0, lo
que significa que al momento de la carga puede no tenerlo.
La carga finaliza cuando se ingresa el String ‘fin’ como apellido.
b. Abrir el archivo anteriormente generado y
i. Listar en pantalla los datos de empleados que tengan un nombre o apellido
determinado, el cual se proporciona desde el teclado.
ii. Listar en pantalla los empleados de a uno por línea.
iii. Listar en pantalla los empleados mayores de 70 años, próximos a jubilarse.
NOTA: El nombre del archivo a crear o utilizar debe ser proporcionado por el usuario.}
program ejercicio3;
const
	corte = 'fin';
type
    empleado = record
             numero: integer;
             apellido: string;
             nombre: string;
             edad: integer;
             dni: integer;
    end;
    archivo_empleados = file of empleado;
    
procedure leer(var e: empleado);
begin
	writeln('Ingrese el apellido del empleado: ');
	readln(e.apellido);
	if (e.apellido  <> corte) then begin
    	writeln('Ingrese el numero del empleado: ');
		readln(e.numero);
		writeln('Ingrese el nombre del empleado: ');
		readln(e.nombre);
		writeln('Ingrese la edad del empleado: ');
		readln(e.edad);
		writeln('Ingrese el dni del empleado: ');
		readln(e.dni);
	end;
end;
procedure cargar(var arc: archivo_empleados);
var
	e: empleado;
begin
	leer(e);
	while (e.apellido <> corte) do begin
		write(arc, e);
		leer(e);
	end;	
	close(arc);
end;
procedure imprimirEmpleado(e: empleado);
begin
    writeln('Número: ', e.numero, '. Apellido: ', e.apellido, '. Nombre: ',
    e.nombre, '. Edad: ', e.edad, '. DNI: ', e.dni, '.');
end;
procedure empleadoDeterminado(arc: archivo_empleados);
var 
    nombreOApellido: string[15];
    e: empleado;
    
    function cumple(nom, ape, nomOApe: string): boolean;
    begin
        cumple := ((nom = nomOApe) or (ape = nomOApe));
    end;
begin
    reset(arc);
    writeln('Ingrese nombre o apellido de un empleado: ');
    readln(nombreOApellido);
    writeln('Los empleados que tienen un nombre/apellido igual a ', nombreOApellido, ' son: ');
    while (not EOF(arc)) do begin 
        read(arc, e);
        if (cumple(e.nombre, e.apellido, nombreOApellido)) then
            imprimirEmpleado(e);
    end;
    close(arc);
end;

procedure listadoEmpleados(arc: archivo_empleados);
var 
    e: empleado;
begin
    reset(arc);
    writeln('Listado de empleados: ');
    while(not EOF(arc)) do begin 
        read(arc, e);
        imprimirEmpleado(e);
    end;
    close(arc);
end;

procedure empleadosMayores70(arc: archivo_empleados);
var 
    e: empleado;
    
    function cumpleEdad(edad: integer): boolean;
    begin
        cumpleEdad := (edad > 70);
    end;
begin
    reset(arc);
    writeln('Los empleados próximos a jubilarse (+70) son: ');
    while(not EOF(arc)) do begin
        read(arc, e);
        if (cumpleEdad(e.edad)) then 
            imprimirEmpleado(e);
    end;
    close(arc);
end;

procedure menu(var arc: archivo_empleados);
var 
    opcion: integer;
begin
    writeln('Las opciones a elegir son las siguientes: ');
    writeln('Opción 1: listar en pantalla los datos de empleados que tengan un nombre o apellido determinado');
    writeln('Opción 2: listar en pantalla los empleados de a uno por línea');
    writeln('Opción 3: listar en pantalla los empleados mayores a 70 años, próximos a jubilarse');
    writeln('Opción 4: salir del menú.');
    readln(opcion);
    while (opcion <> 4) do begin 
        case opcion of
            1: empleadoDeterminado(arc);
            2: listadoEmpleados(arc);
            3: empleadosMayores70(arc);
        else    
            writeln('Opción inválida.');
        end;
        writeln('Vuelva a ingresar una opción: ');
        readln(opcion);
    end;
end;

end;
var
	archivo: archivo_empleados;
	nombre_fisico: string;
	e: empleado;
begin
	writeln('Ingrese el nombre del archivo de carga: ');
	readln(nombre_fisico);
	assign(archivo, nombre_fisico);
	rewrite(archivo);
	cargar(archivo);
	menu(archivo);
end.
