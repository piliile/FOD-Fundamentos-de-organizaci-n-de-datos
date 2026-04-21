{ Una concesionaria de motos de la Ciudad de Chascomús, posee un archivo con información de las
motos que posee a la venta. De cada moto se registra: código, nombre, descripción, modelo, marca y
stock actual. Mensualmente se reciben 10 archivos detalles con información de las ventas de cada uno
de los 10 empleados que trabajan. De cada archivo detalle se dispone de la siguiente información:
código de moto, precio y fecha de la venta. Se debe realizar un proceso que actualice el stock del
archivo maestro desde los archivos detalles. Además se debe informar cuál fue la moto más vendida.
NOTA: Todos los archivos están ordenados por código de la moto y el archivo maestro debe ser recorrido
sólo una vez y en forma simultánea con los detalles.}
program ejercicio17;
const
	valorAlto = 9999;
	dimF = 10;
type
	moto = record
		codigo: integer;
		nombre: string[20];
		descripcion: string[30];
		modelo: string[15];
		marca: string[15];
		stockActual: integer;
	end;
	
	archivoMaestro = file of moto;
	
	venta = record
		codigo: integer;
		precio: real;
		fecha: integer;
	end;
	
	archivoDetalle = file of venta;
	rango = 1..dimF;
	
	vectorArchivos = array [rango] of archivoDetalle;
	vectorRegistros = array [rango] of venta;
	
// procedimientos

procedure leerDetalle(var arcDet: archivoDetalle; var v: venta);
begin
	if (not EOF (arcDet)) then 
		read(arcDet, v)
	else
		v.codigo := valorAlto;
end;

procedure leerMaestro(var arcMae: archivoMaestro; var m: moto);
begin
	if(not EOF (arcMae)) then 
		read(arcMae, m)
	else
		m.codigo := valorAlto
end;

procedure asignoArchivos(var vecArc: vectorArchivos; var arcMae: archivoMaestro); // ¿lo uso así o lo asigno sin un módulo?
var
	i: rango;
	nombre: string[20];
begin
	writeln('Ingrese un nombre para el archivo maestro: ');
	readln(nombre);
	assign(arcMae, nombre);
	for i := 1 to dimF do begin 
		writeln('Ingrese un nombre para el archivo detalle ', i, ': ');
		readln(nombre);
		assign(vecArc[i], nombre);
	end;
end;

procedure minimo (var vecArc: vectorArchivos; var vecReg: vectorRegistros; var min: venta);
var
	i, pos: rango;
begin
	min.codigo := valorAlto;
	for i := 1 to dimF do begin 
		if (vecReg[i].codigo < min.codigo) then begin
			min := vecReg[i];
			pos := i;
		end;
	end;
	if (min.codigo <> valorAlto) then 
		leerDetalle(vecArc[pos], vecReg[pos]);
end;

procedure actualizarMaestro(var vecArc: vectorArchivos; var arcMae: archivoMaestro);
var
	v: venta;
	m: moto;
	min: venta;
	totalVentas, codMax, max: integer;
	i: rango;
begin
	for i := 1 to dimF do begin 
		reset(vecArc[i]);
		leerDetalle(vecArc[i], vecReg[i]);
	end;
	reset(arcMae);
	minimo(vecArc, vecReg, min);
	leerMaestro(arcMae, m);
	max := -1;
	
	while (m.codigo <> valorAlto) do begin
		totalVentas := 0;
		
		while (m.codigo = min.codigo) do begin 
			totalVentas := totalVentas + 1;
			minimo(vecArc, vecReg, min);
		end;
		
		if (totalVentas > 0) then begin
			m.stockActual := m.stockActual - totalVentas;
			seek(arcMae, filepos(arcMae) - 1);
			write(arcMae, m);
		end;
		
		if (totalVentas > max) then begin
			max := totalVentas;
			codMax := m.codigo;
		end;
		
		leerMaestro(arcMae, m);
	end;
	writeln('El código de la moto más vendida es: ', codMax, '.');
	for i := 1 to dimF do 
		close(vecArc[i]);
	close(arcMae);
end;

// programa principal

var
	vecArc: vectorArchivos; 
	arcMae: archivoMaestro; 
begin
	asignoArchivos(vecArc, arcMae);
	actualizarMaestro(vecArc, arcMae);
end.
