program ejercicio13;
const
	valorAlto = 9999;
type
	registroMaestro = record
		numeroUsuario: integer;
		nombreUsuario: string[20];
		nombre: string[20];
		apellido: string[20];
		cantidadMailsEnviados: integer;
	end;
	
	archivoMaestro = file of registroMaestro;
	
	registroDetalle = record
		numeroUsuario: integer;
		cuentaDestino: string[20];
		cuerpoMensaje: string[30];
	end;
	
	archivoDetalle = file of registroDetalle;
	
// procedimientos

procedure leerArchivoDetalle(var arcDet: archivoDetalle; var regDet: registroDetalle);
begin
	if (not EOF(arcDet)) then 
		read(arcDet, regDet)
	else
		regDet.numeroUsuario := valorAlto;
end;

procedure asignarArchivos(var arcDet: archivoDetalle; var arcMae: archivoMaestro);
var
	nombre: string[20];
begin	
	assign(arcMae, 'logmail.dat');
	writeln('Ingrese el nombre del archivo detalle: ');
	readln(nombre);
	assign(arcDet, nombre);
end;

procedure exportarTexto(var arcMae: archivoMaestro); // b) i.
var
    regMae: registroMaestro;
    arcText: text;
begin
    reset(arcMae);
    assign(arcText, 'usuariosYMensajes.txt');
    rewrite(arcText);
    while(not EOF(arcMae)) do begin
            read(arcMae, infoMae);
            writeln(arcText, regMae.usuario, ' ', regMae.cant);
    end;
    close(arcText);
    close(arcMae);
end;

// a.
procedure actualizarMaestro(var arcDet: archivoDetalle; var arcMae: archivoMaestro);
var
	regDet: registroDetalle; regMae: registroMaestro;
	cantidadMailsTotal: integer;
	numeroUsuarioActual: integer;
	arcText: text;
begin
	asignarArchivos(arcDet, arcMae);
	reset(arcDet); reset(arcMae); // "diariamente el servidor de correo genera un archivo ..."
	leerArchivoDetalle(arcDet, regDet);
	leerArchivoMaestro(arcMae, regMae);
	
	
	while (regDet.numeroUsuario <> valorAlto) do begin 
		numeroUsuarioActual := regDet.numeroUsuario;
		cantidadMailsTotal := 0;
		while (numeroUsuarioActual = regDet.numeroUsuario) do begin 
			cantidadMailsTotal := cantidadMailsTotal + 1;
			leerArchivoDetalle(arcDet, regDet);
		end;
		
		while (regMae.numeroUsuario < numeroUsuarioActual) do 
			leerArchivoMaestro(arcMae, regMae);
		regMae.cantidadMailsEnviados := regMae.cantidadMailsEnviados + cantidadMailsTotal;
		
		
		seek(arcMae, filepos(arcMae) - 1);
		write(arcMae, regMae);
	end;
	close(arcDet); close(arcMae); close(arcText);
end;

// b) ii.

procedure actualizarMaestroYTexto(var arcDet: archivoDetalle; var arcMae: archivoMaestro);
var
    regDet: registroDetalle;
    regMae: registroMaestro;
    cantidadMailsTotal: integer;
    arcText: text;
begin
    assign(arcText, 'usuariosYMensajes.txt');
    rewrite(arcText);

    reset(arcDet);
    reset(arcMae);

    leerArchivoDetalle(arcDet, regDet);
    leerArchivoMaestro(arcMae, regMae);

    while (regMae.numeroUsuario <> valorAlto) do begin
        cantidadMailsTotal := 0;

        while (regDet.numeroUsuario < regMae.numeroUsuario) do
            leerArchivoDetalle(arcDet, regDet);

        while (regDet.numeroUsuario = regMae.numeroUsuario) do begin
            cantidadMailsTotal := cantidadMailsTotal + 1;
            leerArchivoDetalle(arcDet, regDet);
        end;

        regMae.cantidadMailsEnviados := regMae.cantidadMailsEnviados + cantidadMailsTotal;

        seek(arcMae, filepos(arcMae)-1);
        write(arcMae, regMae);

        writeln(arcText, regMae.numeroUsuario, ' ', cantidadMailsTotal);

        leerArchivoMaestro(arcMae, regMae);
    end;

    close(arcDet);
    close(arcMae);
    close(arcText);
end;

// programa principal

var
	arcDet: archivoDetalle;
	arcMae: archivoMaestro;
begin
	actualizarMaestro(arcDet, arcMae);
	exportarTexto(arcMae); // b) i.
end.

// i. si realizamos un procedimiento separado del A), aunque sea más legible, no es conveniente porq recorremos dos veces el vector, por lo tanto la mejor
// opción sería la ii., que es cargar el archivo de texto en el el mismo procedimiento de actualización del A). 
	
