program ejercicio5;
const
	valorAlto = 9999; // para el codigo
	dimF = 5;
type
	rango = 1..dimF;
	sesion = record
		codigo: integer;
		fecha: integer;
		tiempo: real;
	end;
	
	archivoDetalle = file of sesion;
	archivoMaestro = file of sesion;
	
	vectorDetalles = array [rango] of archivoDetalle;
	vectorRegistros = array [rango] of sesion;

// procedimiento leer
procedure leer(var arcDet: archivoDetalle; var s: sesion);
begin 
	if (not EOF(arcDet)) then 
		read(arcDet, s)
	else
		s.codigo := valorAlto;
end;

// creo archivos
procedure crearDetalle(var vecDet: vectorDetalles; var vecReg: vectorRegistros);
var
	i: rango;
	nombre: string[15];
begin
	for i := 1 to dimF do begin 
		writeln('ingrese el nombre del archivo detalle: ');
		readln(nombre);
		assign(vecDet[i], nombre);	
		reset(vecDet[i]);
		leer(vecDet[i], vecReg[i]);	
	end;
end;
procedure asignarMaestro(var arcMae: archivoMaestro);
var
	nombre: string[15];
begin
	writeln('Ingrese el nombre del archivo maestro: ');
	readln(nombre);
	assign(arcMae, nombre);
end;
	
// procedimiento cerrar archivos de vector detalles	
procedure cierroDetalle(var vecDet: vectorDetalles);
var
	i: rango;
begin
	for i := 1 to dimF do 
		close(vecDet[i]);
end;
		
// procedimiento minimo
procedure minimo(var vecDet: vectorDetalles; var vecReg: vectorRegistros; var min: sesion);	
var
	i, pos: rango;
begin
	min.codigo := valorAlto;
	min.fecha := valorAlto;
	for i := 1 to dimF do begin 
		if ((vecReg[i].codigo < min.codigo) or ((vecReg[i].codigo = min.codigo) 
			and (vecReg[i].fecha < min.fecha))) then begin
			min := vecReg[i];
			pos := i;
		end;
	end;
	if (min.codigo <> valorAlto) then
		leer(vecDet[pos], vecReg[pos]);
end;
	
// procedimiento asignar datos al maestro
procedure generacionMaestro(var vecDet: vectorDetalles; var arcMae: archivoMaestro);
var
	vecReg: vectorRegistros;
	min, actual: sesion;
begin
	crearDetalle(vecDet, vecReg);
	rewrite(arcMae);
	minimo(vecDet, vecReg, min);
	
	while (min.codigo <> valorAlto) do begin 
		actual.codigo := min.codigo;
		while (actual.codigo = min.codigo) do begin 	
			actual.fecha := min.fecha;
			actual.tiempo := 0;
			while (actual.codigo = min.codigo) and (actual.fecha = min.fecha) do begin 
				actual.tiempo := actual.tiempo + min.tiempo;
				minimo(vecDet, vecReg, min);
			end;
			write(arcMae, actual);
		end;
	end;
	close(arcMae);
	cierroDetalle(vecDet);
end;

// programa principal

var
	vecDet: vectorDetalles;
	arcMae: archivoMaestro;
begin
	asignarMaestro(arcMae); // capaz conviene hacerlo todo en uno, crearDetalleMaestro(vecDet, arcMae)
	generacionMaestro(vecDet, arcMae);
end.
