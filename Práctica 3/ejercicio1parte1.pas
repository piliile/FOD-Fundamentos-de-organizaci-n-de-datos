{Modificar el ejercicio 4 de la práctica 1 (programa de gestión de empleados) agregando una
opción que permita realizar bajas físicas en el archivo. La baja debe realizarse a partir del número
de empleado ingresado por teclado, identificando el registro correspondiente en el archivo. Una
vez encontrado, se debe reemplazar el registro a eliminar por el último registro del archivo, y luego
truncando el archivo en la posición del último registro de forma tal de evitar duplicados.
}
program ejercicio1parte1;
const
	corte = 'fin';
	valorAlto = 9999;
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
	if (e.apellido  <> corte) then begin
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
	rewrite(arc);
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

procedure empleadoDeterminado(var arc: archivo_empleados);
var 
    nombreOApellido: string;
    e: empleado;
begin
    reset(arc);
    writeln('Ingrese nombre o apellido de un empleado: ');
    readln(nombreOApellido);
    while (not EOF(arc)) do begin 
        read(arc, e);
        if ((e.nombre = nombreOApellido) or (e.apellido = nombreOApellido)) then
            imprimirEmpleado(e);
    end;
    close(arc);
end;

procedure listadoEmpleados(var arc: archivo_empleados);
var 
    e: empleado;
begin
    reset(arc);
    while(not EOF(arc)) do begin 
        read(arc, e);
        imprimirEmpleado(e);
    end;
    close(arc);
end;

procedure empleadosMayores70(var arc: archivo_empleados);
var 
    e: empleado;
begin
    reset(arc);
    while(not EOF(arc)) do begin
        read(arc, e);
        if (e.edad > 70) then 
            imprimirEmpleado(e);
    end;
    close(arc);
end;

procedure agregarEmpleado(var arc: archivo_empleados);
var
    e, aux: empleado;
    existe: boolean;
begin
    reset(arc);
    leer(e);
    while (e.apellido <> corte) do begin 
        existe := false;
        seek(arc, 0);
        while (not EOF(arc) and not existe) do begin
            read(arc, aux);
            if (aux.numero = e.numero) then existe := true;
        end;
        if (not existe) then begin 
            seek(arc, filesize(arc));
            write(arc, e);
        end
        else    
            writeln('El número ya existe.');
        leer(e);
    end;
    close(arc);
end;

procedure modificarEdad(var arc: archivo_empleados);
var
    e: empleado;
    num, edadNueva: integer;
    encontre: boolean;
begin
    reset(arc);
    encontre := false;
    writeln('Ingrese el número de empleado y luego la edad nueva: ');
    readln(num);
    readln(edadNueva);
    while (not EOF(arc) and not encontre) do begin 
        read(arc, e);
        if (e.numero = num) then begin
            encontre := true;
            e.edad := edadNueva;
            seek(arc, filePos(arc)-1);
            write(arc, e);
        end;
    end;
    close(arc);
end;    

procedure exportarContenido(var arc: archivo_empleados);
var
    archivo_texto: Text;
    e: empleado;
begin
    reset(arc);
    assign(archivo_texto, 'todos_empleados.txt');
    rewrite(archivo_texto);
    while (not EOF(arc)) do begin 
        read(arc, e);
        writeln(archivo_texto, 'Número: ', e.numero, '. Apellido: ', e.apellido, '. Nombre: ',
        e.nombre, '. Edad: ', e.edad, '. DNI: ', e.dni, '.');
    end;
    close(arc);
    close(archivo_texto);
end;
    
procedure exportarTextoDni(var arc: archivo_empleados);
var 
    e: empleado;
    archivo_texto: Text;
begin
    assign(archivo_texto, 'faltaDNIEmpleado.txt');
    rewrite(archivo_texto);
    reset(arc);
    while (not EOF(arc)) do begin 
        read(arc, e);
        if (e.dni = 0) then  
            writeln(archivo_texto, 'Número: ', e.numero, '. Apellido: ', e.apellido, '. Nombre: ',
            e.nombre, '. Edad: ', e.edad, '. DNI: ', e.dni, '.');
    end;
    close(arc);
    close(archivo_texto);
end;

procedure realizarBajaFisica(var arc: archivo_empleados);
var
	num, pos: integer;
	e, ultimoReg: empleado;
	encontrado: boolean;
begin
	writeln('Ingrese el número del empleado que quiere dar de baja: ');
	readln(num); 
	reset(arc);
	encontrado := false;
	while (not EOF(arc) and not encontrado) do begin
		read(arc, e);
		if (e.numero = num) then encontrado := true;
	end;
	if (encontrado) then begin
		pos := filePos(arc) - 1;
		seek(arc, filesize(arc) - 1);
		read(arc, ultimoReg);
		seek(arc, pos);
		write(arc, ultimoReg);
		seek(arc, filesize(arc) - 1);
		truncate(arc);
		writeln('Baja realizada.');
	end
	else writeln('No encontrado.');
	close(arc);
end;

procedure menu(var arc: archivo_empleados);
var 
    opcion: integer;
begin
    writeln('Opciones: ');
    writeln('1: listar por nombre/apellido');
    writeln('2: listar todos');
    writeln('3: listar mayores 70');
    writeln('4: agregar');
    writeln('5: modificar edad');
    writeln('6: exportar todos');
    writeln('7: exportar falta DNI');
    writeln('9: realizar baja fisica');
    writeln('0: salir');
    readln(opcion);
    while (opcion <> 0) do begin 
        case opcion of
            1: empleadoDeterminado(arc);
            2: listadoEmpleados(arc);
            3: empleadosMayores70(arc);
            4: agregarEmpleado(arc);
	        5: modificarEdad(arc);
	        6: exportarContenido(arc);
	        7: exportarTextoDni(arc);
	        9: realizarBajaFisica(arc);
        end;
        writeln('Ingrese opcion: ');
        readln(opcion);
    end;
end;

var
	archivo: archivo_empleados;
	nombre_fisico: string;
begin
	writeln('Ingrese el nombre del archivo: ');
	readln(nombre_fisico);
	assign(archivo, nombre_fisico);
	cargar(archivo);
	menu(archivo);
end.
