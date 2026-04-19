program ejercicio11;
const
	valorAlto = 9999;
	dimF = 15;
type
	rango = 1..dimF;
	
	empleado = record
		departamento: integer;
		division: integer;
		numero: integer;
		categoria: rango;
		horasExtra: integer;
	end;
	
	archivo = file of empleado;
	
	vector = array[rango] of real;
	
	
// procedimientos

procedure asignarArchivoTexto(var arcText: text);
var
	nombre: string[20];
begin
	writeln('Ingrese el nombre del archivo de texto: ');
	readln(nombre);
	assign(arcText, nombre);
end;

procedure cargarVector(var v: vector; arcText: text);
var
	i, categoria: rango;
	monto: real;
begin
	asignarArchivoTexto(arcText);
	reset(arcText);
	for i := 1 to dimF do begin
		read(arcText, categoria, monto);
		v[categoria] := monto;
	end;
	close(arcText);
end;

procedure leerArchivo(var arc: archivo; var e: empleado);
begin
	if (not EOF(arc)) then 
		read(arc, e)
	else
		e.departamento := valorAlto;
end;

procedure asignarArchivo(var arc: archivo);
var
	nombre: string[20];
begin	
	writeln('Ingrese el nombre del archivo: ');
	readln(nombre);
	assign(arc, nombre);
end;

procedure actualizamosArchivo(var arc: archivo; v: vector);
var
	departamentoActual, divisionActual, numeroActual: integer;
	totalHorasEmpleado, totalHorasDivision, totalHorasDepartamento: integer;
	montoTotalDivision, montoTotalDepartamento, importeActual: real;
	e: empleado;
begin
	reset(arc);
	asignarArchivo(arc);
	leerArchivo(arc, e);
	
	while (e.departamento <> valorAlto) do begin
		departamentoActual := e.departamento;
		writeln('Departamento: ', departamentoActual);
		totalHorasDepartamento := 0; montoTotalDepartamento := 0;
		
		while (departamentoActual = e.departamento) do begin 
			divisionActual := e.division;
			totalHorasDivision := 0; montoTotalDivision := 0;
			writeln('Division: ', divisionActual);
			writeln('Número de empleado       Total horas       Importe a cobrar');
			
			while (departamentoActual = e.departamento) and (divisionActual = e.division) do begin 
				numeroActual := e.numero;
				importeActual := 0;
				totalHorasEmpleado := 0;
				
				while (departamentoActual = e.departamento) and (divisionActual = e.division) 
				and (numeroActual = e.numero) do begin 
					totalHorasEmpleado := totalHorasEmpleado + e.horasExtra;
					importeActual := importeActual + (e.horasExtra * v[e.categoria]);
					leerArchivo(arc, e);
				end;
				writeln('     ', numeroActual, '         ', totalHorasEmpleado, '          ', importeActual:0:2);
				
				totalHorasDivision := totalHorasDivision + totalHorasEmpleado;
				montoTotalDivision := montoTotalDivision + importeActual;
			end;
			writeln('   Total de horas división: ', totalHorasDivision);
			writeln('   Monto total división: ', montoTotalDivision:0:2);
			totalHorasDepartamento := totalHorasDepartamento + totalHorasDivision;
			montoTotalDepartamento := montoTotalDepartamento + montoTotalDivision;
		end;
		writeln('Total horas departamento: ', totalHorasDepartamento);
		writeln('Monto total departamento: ', montoTotalDepartamento:0:2);
	end;
	close(arc);
end;

// programa principal

var
	arcText: text;
	v: vector;
	arc: archivo;
begin
	cargarVector(v, arcText);
	actualizamosArchivo(arc, v);
end.
