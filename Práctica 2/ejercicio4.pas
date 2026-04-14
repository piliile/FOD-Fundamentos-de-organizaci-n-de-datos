program ejercicio4;
const 
	dimF = 30;
	valorAlto = 9999;
type
	rango = 1..dimF;
	productoMaestro = record 
		codigo: integer;
		nombre: string[25];
		descripcion: string[25];
		stockDisponible: integer;
		stockMinimo: integer;
		precio: real;
	end;
	productoDetalle = record
		codigo: integer;
		cantidadVendida: integer;
	end;
	
	archivoMaestro = file of productoMaestro;
	archivoDetalle = file of productoDetalle;
	
	vectorArchivos = array [rango] of archivoDetalle;
	vectorRegistros = array [rango] of productoDetalle;
	
procedure leer(var arcDet: archivoDetalle; var prodDet: productoDetalle);
begin
    if(not eof(arcDet)) then
        read(arcDet, prodDet)
    else
        prodDet.codigo := valorAlto;
end;

procedure minimo(var vecArc: vectorArchivos; var vectorRegistros; var min: productoDetalle);
var
	i, pos: integer;
begin
	min.codigo := valorAlto;
	for i := 1 to dimF do begin 
		if (vecReg[i].codigo < min.codigo) then begin
			min.codigo := vecReg[i];
			pos := i;
		end;
	if (min.codigo <> valorAlto) then
		leer(vecArc[pos], vecReg[pos]);
end;

{procedure crearArchivoTexto(var arcMae: archivoMaestro);
var
	p: productoMaestro;
	
	reset(arcMae);
	rewrite(arcText);
	while (not EOF (arcMae)) do begin
		read(arcMae, p);
		
	end;
	close(arcMae);
	close(arcText);
end;}

procedure actualizarMaestro(var arcMae: archivoMaestro; var vecArc: vectorArchivos);
var
	min: productoDetalle;
	regM: productoMaestro;
	vecReg: vectorRegistros;
	i: rango;
	nombreFis: string[20];
	codigoActual, cantVendidas: integer;
	arcText: text;
begin
	reset(arcMae);
	
	for i := 1 to dimF do begin 
		writeln('Ingrese el nombre físico del archivo detalle: ');
		read(nombreFis);
		assign(vecArc[i], nombreFis);
		
		reset(vecArc[i]);
		leer(vecArc[i], vecReg[i]); // vecReg cargado?
	end;
	assign(arcText, 'archivo texto');
	rewrite(arcText);
	
	minimo(vecArc, vecReg, min);
	read(arcMae, regM);
	while (not EOF (arcMae)) do begin // recorrer por maestro
		codigoActual := min.codigo;
		cantVendidas := 0;
		
		while (min.codigo <> valorAlto) and (min.codigo = codigoActual) do begin
			cantVendidas := cantVendidas + min.cantidadVendida;
			minimo(vecArc, vecReg, min);
		end;
		while (regM.codigo <> codigoActual) do begin
			if (regM.stockDisponible < regM.stockMinimo) then 
				writeln(arcText, regM.nombre, '', regM.descripcion, '', regM.stockDisponible, '', regM.precio);
			read(arcMae, regM);
		end;
		
		seek(arcMae, filepos(arcMae) - 1);
		regM.stockDisponible := regM.stockDisponible - cantVendidas;
		write(arcMae, regM);
	
		if (regM.stockDisponible < regM.stockMinimo) then 
			writeln(arcText, regM.nombre, '', regM.descripcion, '', regM.stockDisponible, '', regM.precio);
		read(arcMae, regM);
	end;
	// crearArchivoTexto(arcMae);
	close(arcMae);
	close(arcText);
	for i := 1 to dimF do
		close(vecArc[i]);
end;
