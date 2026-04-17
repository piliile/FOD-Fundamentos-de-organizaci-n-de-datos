{Se dispone de un archivo maestro con información de los alumnos de la Facultad de Informática. Cada
registro del archivo maestro contiene: código de alumno, apellido, nombre, cantidad de cursadas
aprobadas y cantidad de materias con final aprobado. El archivo maestro está ordenado por código de
alumno.
Además, se dispone de dos archivos detalle con información sobre el desempeño académico de los
alumnos: un archivo de cursadas y un archivo de exámenes finales.
El archivo de cursadas contiene información sobre las materias cursadas por los alumnos. Cada registro
incluye: código de alumno, código de materia, año de cursada y resultado (solo interesa determinar si la
cursada fue aprobada o desaprobada).
Por su parte, el archivo de exámenes finales contiene información sobre los exámenes rendidos. Cada
registro incluye: código de alumno, código de materia, fecha del examen y nota obtenida.
Ambos archivos detalle están ordenados por código de alumno y código de materia, y pueden contener
cero, uno o más registros por alumno.
Un alumno puede cursar una misma materia varias veces, así como también rendir el examen final en
múltiples ocasiones.
Se solicita desarrollar un programa que actualice el archivo maestro, modificando la cantidad de cursadas
aprobadas y la cantidad de materias con final aprobado, a partir de la información contenida en los archivos
detalle.
Las reglas de actualización son las siguientes:
● Si un alumno aprueba una cursada, se incrementa en uno la cantidad de cursadas aprobadas.
● Si un alumno aprueba un examen final (nota mayor o igual a 4), se incrementa en uno la cantidad de
materias con final aprobado.
Notas:
● Los archivos deben procesarse en un único recorrido.
● No es necesario verificar inconsistencias en la información de los archivos detalle. En particular, se
garantiza que un alumno no puede aprobar más de una vez la cursada de una misma materia. De
manera análoga, tampoco puede aprobar más de una vez el examen final de una misma materia.
}
program ejercicio7;
const
	valorAlto = 9999;
type
	registroMaestro = record
		codigoAlumno: integer;
		apellido: string[20];
		nombre: string[20];
		cursadasAprobadas: integer;
		materiasFinalesAprobados: integer;
	end;
	
	archivoMaestro = file of registroMaestro;
	
	cursadas = record
		codigoAlumno: integer;
		codigoMateria: integer;
		año: integer;
		resultado: boolean;
	end;
	
	archivoCursadas = file of cursadas;
	
	finales = record
		codigoAlumno: integer;
		codigoMateria: integer;
		fecha: integer;
		nota: real;
	end;
	
	archivoFinales = file of finales;
	
// procedimientos
procedure asignarArchivos(var arcCursadas: archivoCursadas; var arcFinales: archivoFinales; var arcMae: archivoMaestro);
begin
	 assign(arcCursadas, 'cursadas');
     assign(arcFinales, 'finales');
     assign(arcMae, 'alumnos');
end;

procedure leerCursadas(var arcCursadas: archivoCursadas; var c: cursadas);
begin
	if (not EOF (arcCursadas)) then 
		read(arcCursadas, c)
	else
		c.codigoAlumno := valorAlto;
end;
procedure leerFinales(var arcFinales: archivoFinales; var f: finales);
begin
	if (not EOF (arcFinales)) then 
		read(arcFinales, f)
	else
		f.codigoAlumno := valorAlto;
end;

procedure abrirArchivos(var arcCursadas: archivoCursadas; var arcFinales: archivoFinales; var arcMae: archivoMaestro);
begin 
	reset(arcCursadas); 
	reset(arcFinales); 
	reset(arcMae);
end;

procedure cerrarArchivos(var arcCursadas: archivoCursadas; var arcFinales: archivoFinales; var arcMae: archivoMaestro);
begin
	close(arcCursadas); 
	close(arcFinales); 
	close(arcMae);
end;

procedure actualizarMaestro(var arcCursadas: archivoCursadas; var arcFinales: archivoFinales; var arcMae: archivoMaestro);
var
	c: cursadas;
	f: finales;
	codigoAlumnoActual: integer;
	regMae: registroMaestro;

begin	
	abrirArchivos(arcCursadas, arcFinales, arcMae);
	leerCursadas(arcCursadas, c);
	leerFinales(arcFinales, f);
	read(arcMae, regMae);

	while (c.codigoAlumno <> valorAlto) or (f.codigoAlumno <> valorAlto) do begin
		if (c.codigoAlumno < f.codigoAlumno) then 	
			codigoAlumnoActual := c.codigoAlumno
		else
			codigoAlumnoActual := f.codigoAlumno;
		
		while (regMae.codigoAlumno <> codigoAlumnoActual) do 
			read(arcMae, regMae);
			
		while (codigoAlumnoActual = c.codigoAlumno) do begin
			if (c.resultado) then 
				regMae.cursadasAprobadas := regMae.cursadasAprobadas + 1;
			leerCursadas(arcCursadas, c);
		end;
		
		while (codigoAlumnoActual = f.codigoAlumno) do begin 
			if (f.nota >= 4) then  
				regMae.materiasFinalesAprobados := regMae.materiasFinalesAprobados + 1;
			leerFinales(arcFinales, f);
		end;
		seek(arcMae, filepos(arcMae) - 1);
		write(arcMae, regMae);
	end;
	cerrarArchivos(arcCursadas, arcFinales, arcMae);
end;

// programa principal
var
	arcCursadas: archivoCursadas;
	arcFinales: archivoFinales;
	arcMae: archivoMaestro;
begin
	asignarArchivos(arcCursadas, arcFinales, arcMae);
	actualizarMaestro(arcCursadas, arcFinales, arcMae);
end.
