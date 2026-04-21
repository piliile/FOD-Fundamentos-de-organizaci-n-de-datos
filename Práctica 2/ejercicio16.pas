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
begin
    informacionArchivos(vecArc, vecReg, arcMae, regMae);
    minimo(vecArc, vecReg, minDet);

    while (minDet.fecha <> valorAlto) do begin // ayuda acá

       
    end;

    cerrarArchivos(vecArc, arcMae);
end;
	
// programa principal

var
	vecArc: vectorArchivos;
	arcMae: archivoMaestro;
begin
	actualizarMaestro(vecArc, arcMae);
end.
	
