program ejercicio8;
const
	valorAlto = 9999;
	dimF = 16;
type
	registroMaestro = record
		codigoProvincia: integer;
		nombreProvincia: string[20];
		habitantes: integer;
		yerbaConsumida: integer;
	end;
	
	archivoMaestro = file of registroMaestro;
	
	registroDetalle = record
		codigoProvincia: integer;
		yerbaConsumida: integer;
	end;
	
	archivoDetalle = file of registroDetalle;
	rango = 1..dimF;
	
	vectorArchivos = array [rango] of archivoDetalle;
	vectorRegistros = array [rango] of registroDetalle;
	
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
	if (not EOF (arcMae)) then 
		read(arcMae, regMae)
	else
		regMae.codigoProvincia := valorAlto;
end;

procedure crearArcsDet(var vecArc: vectorArchivos; var vecReg: vectorRegistros);
var
	i: rango;
	nombre: string[20];
begin
	for i := 1 to dimF do begin 
		writeln('Ingrese un nombre para el archivo detalle ', i, ': ');
		readln(nombre);
		assign(vecArc[i], nombre);
		reset(vecArc[i]);
		leerDetalle(vecArc[i], vecReg[i]);
	end;
end;

procedure minimo(var vecArc: vectorArchivos; var vecReg: vectorRegistros; var min: registroDetalle);
var
	i, pos: rango;
begin
	min.codigoProvincia := valorAlto;
	for i := 1 to dimF do begin 
		if(vecReg[i].codigoProvincia < min.codigoProvincia) then begin
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

procedure informeProvinciasMas10k(regMae: registroMaestro);
begin
	writeln('Código de la provincia: ', regMae.codigoProvincia, '. Nombre de la provincia: ', regMae.nombreProvincia, 
	'. Promedio de consumo por habitante: ', regMae.yerbaConsumida/regMae.habitantes);
end;

procedure actualizarMaestro(var vecArc: vectorArchivos; var arcMae: archivoMaestro);
var
	min: registroDetalle;
	vecReg: vectorRegistros;
	regMae: registroMaestro;
	cantidadYerba, codigoActual: integer;
begin
	crearArcsDet(vecArc, vecReg);
	reset(arcMae); 
	leerMaestro(arcMae, regMae);
	
	minimo(vecArc, vecReg, min);
	
	while (regMae.codigoProvincia <> valorAlto) do begin 
		if (regMae.codigoProvincia = min.codigoProvincia) then begin	
			codigoActual := min.codigoProvincia;
			cantidadYerba := 0;
			
			while (codigoActual = min.codigoProvincia) do begin
				cantidadYerba := cantidadYerba + min.yerbaConsumida;
				minimo(vecArc, vecReg, min);
			end;
			
			seek(arcMae, filepos(arcMae) - 1);
			regMae.yerbaConsumida := regMae.yerbaConsumida + cantidadYerba;
			write(arcMae, regMae);
		end;
		if (regMae.yerbaConsumida > 10000) then 
				informeProvinciasMas10k(regMae);
		leerMaestro(arcMae, regMae);
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
