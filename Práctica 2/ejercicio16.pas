program ejercicio16;
const
	valorAlto = 9999;
	dimF = 100;
type	
	registroMaestro = record
		fecha: integer;
		codigoSemanario: integer;
		nombreSemanario: string[20];
		descripcion: string[40];
		precio: real;
		ejemplares: integer;
		ejemplaresVendidos: integer;
	end;
	
	archivoMaestro = file of registroMaestro;
	
	registroDetalle = record
		fecha: integer;
		codigoSemanario: integer;
		ejemplaresVendidos: integer;
	end;
	
	rango = 1..dimF;
	vectorRegistros = array [rango] of registroDetalle;
		
	archivoDetalle = file of registroDetalle;
	vectorArchivos = array [rango] of archivoDetalle;
	
// procedimientos

procedure leerDetalle(var arcDet: archivoDetalle; var regDet: registroDetalle);
begin
	if (not EOF (arcDet)) then 
		read(arcDet, regDet)
	else
		regDet.fecha := valorAlto;
end;

procedure minimo(var vecArc: vectorArchivos; var vecReg: vectorRegistros; var min: registroDetalle);
var
	i, pos: rango;
begin
	min.fecha := valorAlto;
	for i := 1 to dimF do begin
		if ((vecReg[i].fecha < min.fecha) or (vecReg[i].fecha = min.fecha and vecReg[i].codigoSemanario < min.codigoSemanario) then begin
			min := vecReg[i];
			pos := i;
		end;
	end;
	if (min.fecha <> valorAlto) then 
		leerDetalle(vecArc[pos], vecReg[pos]);
end;	
	
procedure informacionArchivos(var vecArc: vectorArchivos; var vecReg: vectorRegistros; var arcMae: archivoMaestro; var regMae: registroMaestro);
var
	i: rango;
	nombre: string[20];
begin
	writeln('Ingrese un nombre para el archivo maestro: ');
	readln(nombre);
	assign(arcMae, nombre);
	reset(arcMae);
	leerMaestro(arcMae, regMae);
	for i := 1 to dimF do begin 
		writeln('Ingrese un nombre para el archivo detalle ', i, ': ');
		readln(nombre);
		assign(vecArc[i], nombre);
		reset(vecArc[i]);
		leerDetalle(vecArc[i], vecReg[i]);
	end;
end;
		
procedure cerrarArchivos(var vecArc: vectorArchivos; var arcMae: archivoMaestro);
var
	i: rango;
begin
	close(arcMae);
	for i := 1 to dimF do
		close(vecArc[i]);
end;
{Realice las declaraciones necesarias, la llamada al procedimiento y el
procedimiento que recibe el archivo maestro y los 100 detalles y realice la actualización del archivo
maestro en función de las ventas registradas. Además deberá informar fecha y semanario que tuvo más
ventas y la misma información del semanario con menos ventas.
Nota: Todos los archivos están ordenados por fecha y código de semanario. No se realizan ventas de
semanarios si no hay ejemplares para hacerlo.
}
procedure actualizarMaestro(var vecArc: vectorArchivos; var arcMae: archivoMaestro);
var
    vecReg: vectorRegistros;
    minDet: registroDetalle;
    regMae: registroMaestro;
    total, codigoMax, codigoMin, fechaMax, fechaMin, fechaActual, codigoSemActual, max, min: integer;
begin
    informacionArchivos(vecArc, vecReg, arcMae, regMae);
    minimo(vecArc, vecReg, minDet);
	max := -1; min := valorAlto;
	read(arcMae, regMae);
    while (minDet.fecha <> valorAlto) do begin // ¿?
		while ((regMae.fecha < minDet.fecha) or (regMae.fecha = minDet.fecha and regMae.codigoSemanario < minDet.codigoSemanario)) do 
			read(arcMae, regMae);
		
		total := 0;
		fechaActual := minDet.fecha;
		while (fechaActual = minDet.fecha) do begin 
			codigoSemActual := minDet.codigoSemanario;
			while (fechaActual = minDet.fecha and codigoSemActual = minDet.codigoSemanario) do begin 
					total := total + minDet.ejemplaresVendidos;
					regMae.ejemplares := regMae.ejemplares -  minDet.ejemplaresVendidos;
					regMae.ejemplaresVendidos := regMae.ejemplaresVendidos + minDet.ejemplaresVendidos; 
					minimo(vecArc, vecReg, minDet);
			end;
			if (total > max) then begin
				max := total;
				fechaMax := fechaActual;
				codigoMax := codigoSemActual;
			end;
			if (total < min) then begin 	
				min := total;
				fechaMin := fechaActual;
				codigoMin := codigoSemActual;
			end;
			seek(arcMae, filepos(arcMae) - 1);
			write(arcMae, regMae);
		end;
    end;
	writeln('Semanario máximo: Fecha = ', fechaMax, '. Código = ', codigoMax);
    writeln('Semanario mínimo: Fecha = ', fechaMin, '. Código = ', codigoMin);
    cerrarArchivos(vecArc, arcMae);
end;
	
// programa principal

var
	vecArc: vectorArchivos;
	arcMae: archivoMaestro;
begin
	actualizarMaestro(vecArc, arcMae);
end.
