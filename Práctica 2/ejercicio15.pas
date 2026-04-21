program ejercicio15;
const
	valorAlto = 9999;
	dimF = 10;
type	
	registroMaestro = record
		codigoProvincia: integer;
		nombreProvincia: string[20];
		codigoLocalidad: integer;
		nombreLocalidad: string[20];
		vSinLuz: integer;
		vSinGas: integer;
		vDeChapa: integer;
		vSinAgua: integer;
		vivSinSanitarios: integer;
	end;
	
	archivoMaestro = file of registroMaestro;
	
	registroDetalle = record
		codigoProvincia: integer;
		codigoLocalidad: integer;
		vivSinLuz: integer;
		vivConstruidas: integer;
		vivConAgua: integer;
		vivConGas: integer;
		entregaSanitarios: integer;
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
		regDet.codigoProvincia := valorAlto;
end;

procedure leerMaestro(var arcMae: archivoMaestro; var regMae: registroMaestro);
begin
    if (not EOF(arcMae)) then
        read(arcMae, regMae)
    else
        regMae.codigoProvincia := valorAlto;
end;

procedure minimo(var vecArc: vectorArchivos; var vecReg: vectorRegistros; var min: registroDetalle);
var
	i, pos: rango;
begin
	min.codigoProvincia := valorAlto;
	for i := 1 to dimF do begin
		if ((vecReg[i].codigoProvincia < min.codigoProvincia) or (vecReg[i].codigoProvincia = min.codigoProvincia and
            vecReg[i].codigoLocalidad < min.codigoLocalidad)) then begin
			min := vecReg[i];
			pos := i;
		end;
	end;
	if (min.codigoProvincia <> valorAlto) then 
		leerDetalle(vecArc[pos], vecReg[pos]);
end;	
		
procedure cerrarArchivos(var vecArc: vectorArchivos; var arcMae: archivoMaestro);
var
	i: rango;
begin
	close(arcMae);
	for i := 1 to dimF do
		close(vecArc[i]);
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

procedure actualizarMaestro(var vecArc: vectorArchivos; var arcMae: archivoMaestro);
var
    vecReg: vectorRegistros;
    min: registroDetalle;
    regMae: registroMaestro;
    sinChapa: integer;
begin
    sinChapa := 0;
    informacionArchivos(vecArc, vecReg, arcMae, regMae);
    minimo(vecArc, vecReg, min);

    while (regMae.codigoProvincia <> valorAlto) do begin

        while ((min.codigoProvincia < regMae.codigoProvincia) or (min.codigoProvincia = regMae.codigoProvincia and
            min.codigoLocalidad < regMae.codigoLocalidad)) do
            minimo(vecArc, vecReg, min);

        if (min.codigoProvincia = regMae.codigoProvincia) and (min.codigoLocalidad = regMae.codigoLocalidad) then begin
            regMae.vSinLuz := regMae.vSinLuz - min.vivSinLuz;
            regMae.vSinAgua := regMae.vSinAgua - min.vivConAgua;
            regMae.vSinGas := regMae.vSinGas - min.vivConGas;
            regMae.vivSinSanitarios := regMae.vivSinSanitarios - min.entregaSanitarios;
            regMae.vDeChapa := regMae.vDeChapa - min.vivConstruidas;
            minimo(vecArc, vecReg, min);
        end;

        if (regMae.vDeChapa = 0) then
            sinChapa := sinChapa + 1;

        seek(arcMae, filepos(arcMae) - 1);
        write(arcMae, regMae);

        leerMaestro(arcMae, regMae);
    end;

    writeln('La cantidad de localidades sin viviendas de chapa es: ', sinChapa);
    cerrarArchivos(vecArc, arcMae);
end;
	
// programa principal

var
	vecArc: vectorArchivos;
	arcMae: archivoMaestro;
begin
	actualizarMaestro(vecArc, arcMae);
end.
	
