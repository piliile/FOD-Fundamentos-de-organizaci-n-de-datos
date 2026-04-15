program ejercicio6;
const
	valorAlto = 9999; // para el codigo
	dimF = 10;
type
	rango = 1..dimF;
	recuento = record
		codigoLocalidad: integer;
		codigoCepa: integer;
		cantidadActivos: integer;
		cantidadNuevos: integer;
		cantidadRecuperados: integer;
		cantidadFallecidos: integer;	
	end;
	registroMaestro = record
		nombreLocalidad: string[25];
		nombreCepa: string[25];
		rec: recuento;
	end;
	
	archivoDetalle = file of recuento;
	archivoMaestro = file of registroMaestro;
	
	vectorDetalles = array [rango] of archivoDetalle;
	vectorRegistros = array [rango] of sesion;

// procedimiento leer
procedure leer(var arcDet: archivoDetalle; var rec: recuento);
begin 
	if (not EOF(arcDet)) then 
		read(arcDet, rec)
	else
		rec.codigoLocalidad := valorAlto;
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
	
// procedimiento cerrar archivos de vector detalles	
procedure cierroDetalle(var vecDet: vectorDetalles);
var
	i: rango;
begin
	for i := 1 to dimF do 
		close(vecDet[i]);
end;
		
// procedimiento minimo
procedure minimo(var vecDet: vectorDetalles; var vecReg: vectorRegistros; var min: recuento);	
var
	i, pos: rango;
begin
	min.codigoLocalidad := valorAlto;
	min.codigoCepa := valorAlto;
	for i := 1 to dimF do begin 
		if ((vecReg[i].codigoLocalidad < min.codigoLocalidad) or ((vecReg[i].codigoLocalidad = min.codigoLocalidad) 
			and (vecReg[i].codigoCepa < min.codigoCepa))) then begin
			min := vecReg[i];
			pos := i;
		end;
	end;
	if (min.codigoLocalidad <> valorAlto) then
		leer(vecDet[pos], vecReg[pos]);
end;

// procedimiento actualizar registro del maestro
procedure actualizarRegistro(var regMae: registroMaestro; actual: recuento; totalFallecidos, totalRecuperados: integer);
begin
	regMae.rec.cantidadFallecidos := regMae.rec.cantidadFallecidos + totalFallecidos;
	regMae.rec.cantidadRecuperados := regMae.rec.cantidadRecuperados + totalRecuperados;
	regMae.rec.cantidadActivos := actual.cantidadActivos;
	regMae.rec.cantidadNuevos := actual.cantidadNuevos;
end;
	
	
// procedimiento asignar datos al maestro
procedure actualizoMaestro(var vecDet: vectorDetalles; var arcMae: archivoMaestro);
var
	vecReg: vectorRegistros;
	min, actual: recuento;
	regMae: registroMaestro;
	totalFallecidos, totalRecuperados, cantidadCasosLocalidad, cantidadLocalidadesMas50: integer;
begin
	crearDetalle(vecDet, vecReg);
	reset(arcMae);
	minimo(vecDet, vecReg, min);
	cantidadLocalidadesMas50 := 0;
	
	while (min.codigoLocalidad <> valorAlto) do begin 
		actual.codigoLocalidad := min.codigoLocalidad;
		cantidadCasosLocalidad := 0;
		while (actual.codigoLocalidad = min.codigoLocalidad) do begin 	
			actual.codigoCepa := min.codigoCepa;
			totalFallecidos := 0;
			totalRecuperados := 0;
			while (actual.codigoLocalidad = min.codigoLocalidad) and (actual.codigoCepa = min.codigoCepa) do begin 
				totalFallecidos := totalFallecidos + min.cantidadFallecidos;
				totalRecuperados := totalRecuperados + min.cantidadRecuperados;
				cantidadCasosLocalidad:= cantidadCasosLocalidad + min.cantidadActivos;
				actual.cantidadActivos := min.cantidadActivos;
				actual.cantidadNuevos := min.cantidadNuevos;
				minimo(vecDet, vecReg, min);
			end;
			// encuentro codigo loc y codigo cepa
			read(arcMae, regMae);
			while ((regMae.rec.codigoLocalidad <> actual.codigoLocalidad) or (regMae.rec.codigoCepa <> actual.codigoCepa)) do 
				read(arcMae, regMae);
			
			// cuando salgo del while es xq encontré ent me posiciono bien 
			seek(arcMae, filepos(arcMae) - 1);
			actualizarRegistro(regMae, actual, totalFallecidos, totalRecuperados);
			write(arcMae, regMae);
		end;
		if (cantidadCasosLocalidad > 50) then
			cantidadLocalidadesMas50 := cantidadLocalidadesMas50 + 1;
		
	end;
	writeln('La cantidad de localidas con más de 50 casos activos es: ', cantidadLocalidadesMas50)
	close(arcMae);
	cierroDetalle(vecDet);
end;

// programa principal

var
	vecDet: vectorDetalles;
	arcMae: archivoMaestro;
begin
	actualizoMaestro(vecDet, arcMae);
end.
