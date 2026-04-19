program ejercicio10;
const
	valorAlto = 9999;
type
	mesa = record
		codigoProvincia: integer;
		codigoLocalidad: integer;
		numero: integer;
		cantidadVotos: integer;
	end;
	
	archivo = file of mesa;
	
// procedimientos

procedure leerArchivo(var arc: archivo; var m: mesa);
begin
	if (not EOF (arc)) then 
		read(arc, m)
	else
		m.codigoProvincia := valorAlto;
end;

procedure asignarArchivo(var arc: archivo);
var
	nombre: string[20];
begin
	writeln('Ingrese el nombre del archivo: ');
	readln(nombre);
	assign(arc, nombre);
end;

procedure contabilizarVotos(var arc: archivo);
var
	codProvActual, codLocActual: integer;
	m: mesa;
	cantVotosProv, cantVotosLoc, cantVotosGeneral: integer;
begin
	asignarArchivo(arc);
	reset(arc);
	leerArchivo(arc, m);
	cantVotosGeneral := 0;
	while (m.codigoProvincia <> valorAlto) do begin 
		codProvActual := m.codigoProvincia;
		cantVotosProv := 0;
		writeln('Código de provincia: ', codProvActual);
		writeln('Código de localidad        Total de votos');
		
		while (codProvActual = m.codigoProvincia) do begin 
			codLocActual := m.codigoLocalidad;
			cantVotosLoc := 0;
			
			while (codProvActual = m.codigoProvincia) and (codLocActual = m.codigoLocalidad) do begin 
				cantVotosProv := cantVotosProv + m.cantidadVotos;
				cantVotosLoc := cantVotosLoc + m.cantidadVotos;
				leerArchivo(arc, m);
			end;
			
			writeln(codLocActual, '                ', cantVotosLoc);
		end;
		writeln('Total de votos provincia: ', cantVotosProv);
		cantVotosGeneral := cantVotosGeneral + cantVotosProv;
	end;
	writeln('Total general de votos: ', cantVotosGeneral);
	close(arc);
end;

// programa principal

var
	arc: archivo;
begin
	contabilizarVotos(arc);
end.
