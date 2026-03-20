{Realizar un algoritmo que cree un archivo binario de números enteros no ordenados y permita
incorporar datos al archivo. Los números son ingresados desde el teclado. La carga finaliza
cuando se ingresa el número 30000, que no debe incorporarse al archivo. El nombre del archivo
debe ser proporcionado por el usuario desde el teclado.}

program ejercicio1;
const
	corte = 30000;
type
	archivo_numeros_enteros = file of integer; // DEFINO UN TIPO DE ARCHIVO BINARIO (UN ARCHIVO QUE GUARDA ENTEROS, DE LONGITUD FIJA)
var
	numeros_enteros: archivo_numeros_enteros; // NOMBRE LÓGICO DEL ARCHIVO
	nombre_fisico: string;
	numero: integer;
begin
	writeln('Ingrese el nombre físico del archivo de carga: ');
	readln(nombre_fisico);
	assign(numeros_enteros, nombre_fisico);// AL NOMBRE LOGICO LE ASIGNO EL NOMBRE FISICO.
	rewrite(numeros_enteros); // CREO EL ARCHIVO, ADEMAS DE CREARLO SE ABRE. 
	writeln('Ingrese un número para añadirlo al archivo: ');
	readln(numero);
	while (numero <> corte) do begin 
		writeln(numeros_enteros, numero); // GUARDO EL NÚMERO EN EL ARCHIVO.
		writeln('Ingrese otro número: ');
		readln(numero);
	end;
	close(numeros_enteros); // SIEMPRE CIERRO EL ARCHIVO QUE ABRO.
end.
