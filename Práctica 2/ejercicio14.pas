program ejercicio14;
const
	valorAlto = 'ZZZ';
	
type
	vuelo = record
		destino: string[20];
		fecha: integer;
		horaSalida: integer;
		asientosDisponibles: integer;
	end;
	
	archivoMaestro = file of vuelo;
	
	registroDetalle = record
		destino: string[20];
		fecha: integer;
		horaSalida: integer;
		asientosComprados: integer;
	end;
	
	archivoDetalle = file of registroDetalle;
	
// procedimientos

procedure leerDetalle(var arcDet: archivoDetalle; var regDet: registroDetalle);
begin
	if (not EOF(arcDet)) then 
		read(arcDet, regDet);
	else
		regDet.destino := valorAlto;
end;

procedure minimo(var arcDet1, arcDet2: archivoDetalle; var regDet1, regDet2, min: registroDetalle);
begin
	if (regDet1.destino <= regDet2.destino) then begin
		min := regDet1;
		leerDetalle(arcDet1, regDet1);
	end	
	else begin 
		min := regDet2;
		leerDetalle(arcDet2, regDet2);
	end;
end;

procedure actualizarMaestro(var arcDet1, arcDet2: archivoDetalle; var arcMae: archivoMaestro);
var
    regDet1, regDet2, min: registroDetalle;
    regMae: registroMaestro;
    cantAsientosVendidos: integer;
begin
    reset(arcDet1); reset(arcDet2); reset(arcMae);
    leerDetalle(arcDet1, regDet1); leerDetalle(arcDet2, regDet2); leerMaestro(arcMae, regMae);
    minimo(arcDet1, arcDet2, regDet1, regDet2, min);

    while (min.destino <> valorAlto) do begin

        while (regMae.destino <> min.destino) or (regMae.fecha <> min.fecha) or (regMae.horaSalida <> min.horaSalida) do
            leerMaestro(arcMae, regMae);

        cantAsientosVendidos := 0;

        while (min.destino = regMae.destino) and (min.fecha = regMae.fecha) and (min.horaSalida = regMae.horaSalida) do begin
            cantAsientosVendidos := cantAsientosVendidos + min.cantAsientosComprados;
            minimo(arcDet1, arcDet2, regDet1, regDet2, min);
        end;

        regMae.cantAsientosDisponibles := regMae.cantAsientosDisponibles - cantAsientosVendidos;

        seek(arcMae, filepos(arcMae) - 1);
        write(arcMae, regMae);
    end;
    close(arcDet1); close(arcDet2); close(arcMae);
end;
