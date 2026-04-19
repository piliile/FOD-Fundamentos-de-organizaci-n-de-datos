program ejercicio12;
const
	valorAlto = 9999;
type
	date = record
		año: integer;
		mes: integer;
		dia: integer;
	end;
	
	acceso = record
		fecha: date;
		idUsuario: integer;
		tiempoAcceso: real;
	end;
	
	archivo = file of acceso;
	
// procedimientos

procedure leerArchivo(var arc: archivo; var a: acceso);
begin
	if (not EOF(arc)) then 
		read(arc, a)
	else
		a.fecha.año := valorAlto;
end;

procedure asignarArchivo(var arc: archivo);
var
	nombre: string[20];
begin	
	writeln('Ingrese el nombre del archivo: ');
	readln(nombre);
	assign(arc, nombre);
end;

procedure informeArchivo(var arc: archivo);
var
	a: acceso;
	añoLeido: integer;
	tiempoTotalAño, tiempoTotalDiaMes, tiempoTotalMes, tiempoTotalUsuario: real;
	mesActual, diaActual, idActual: integer;
begin
	asignarArchivo(arc);
	reset(arc);
	
	writeln('Lea un año: ');
	readln(añoLeido);
	leerArchivo(arc, a);
	
	while (a.fecha.año <> valorAlto) and (a.fecha.año < añoLeido) do // si busco 2024 y leo 2022 --> sigo leyendo, 2024 =/ 2023, 2024 = 2024.
		leerArchivo(arc, a);
	if (añoLeido = a.fecha.año) then begin
			writeln('Año: ', añoLeido);
			tiempoTotalAño := 0;
			
			while (añoLeido = a.fecha.año) do begin 
				mesActual := a.fecha.mes;
				writeln('   Mes: ', mesActual);
				tiempoTotalMes := 0;
				
				while (añoLeido = a.fecha.año) and (mesActual = a.fecha.mes) do begin 
					diaActual := a.fecha.dia;
					writeln('      Día: ', diaActual);
					tiempoTotalDiaMes := 0;
					
					while (añoLeido = a.fecha.año) and (mesActual = a.fecha.mes) and (diaActual = a.fecha.dia) do begin 
						idActual := a.idUsuario;
						tiempoTotalUsuario := 0;
						
						while (añoLeido = a.fecha.año) and (mesActual = a.fecha.mes) and (diaActual = a.fecha.dia) and (idActual = a.idUsuario) do begin 
							tiempoTotalUsuario := tiempoTotalUsuario + a.tiempoAcceso;
							leerArchivo(arc, a);
						end;
					
						writeln('         idUsuario: ', idActual, '.    Tiempo total de acceso en el día ', diaActual, ' mes ', mesActual, ': ', tiempoTotalUsuario:0:2);
						tiempoTotalDiaMes := tiempoTotalDiaMes + tiempoTotalUsuario;
						
					end;
					writeln('      Tiempo total de acceso dia ', diaActual, ' mes', mesActual, ': ', tiempoTotalDiaMes:0:2);
					tiempoTotalMes := tiempoTotalMes + tiempoTotalDiaMes;
					
				end;
				writeln('   Total tiempo de acceso mes ', mesActual, ': ', tiempoTotalMes:0:2);
				tiempoTotalAño := tiempoTotalAño + tiempoTotalMes;
			end;
			writeln('Total tiempo de acceso año: ', tiempoTotalAño:0:2);
	end
	else
		writeln('Año no encontrado.');
	close(arc);
end;

// programa principal

var
	arc: archivo;
begin
	informeArchivo(arc);
end.
