{A partir de información sobre la alfabetización en la Argentina, se desea actualizar un archivo maestro
que contiene los siguientes datos: nombre de la provincia, cantidad de personas alfabetizadas y total de
encuestados.
Para ello, se dispone de dos archivos detalle, provenientes de distintas agencias de censo. Cada uno de
estos archivos contiene: nombre de la provincia, código de localidad, cantidad de personas alfabetizadas
y cantidad de encuestados.
Se solicita desarrollar los módulos necesarios para actualizar el archivo maestro a partir de la
información contenida en ambos archivos detalle.
Nota: Todos los archivos están ordenados por nombre de provincia. En los archivos detalle pueden
existir cero, uno o más registros por cada provincia.}
program ejercicio3;
const   
    valorAlto = 'ZZZ';
type
    infoAlfabetizacion = record
        provincia: string[25];
        cantidadAlfabetizados: integer;
        totalEncuestados: integer;
    end;
    
    infoAgencia = record
        provincia: string[25];
        codigoLocalidad: integer;
        cantidadAlfabetizados: integer;
        totalEncuestados: integer;
    end;
    
    archivoAlfabetizacion = file of alfabetizacion;
    archivoAgencia = file of agencia;
    

procedure leerInfoAgencia(var arcDet: archivoAgencia; var iAg: infoAgencia);
begin
    if (not EOF (arcDet)) then 
        read(arcDet, iAg);
    else    
        iAg.provincia = valorAlto;
end;

procedure minimo(var arcDet1, arcDet2: archivoAgencia; var iAg1, iAg2, min: infoAgencia);
begin
    if(iAg1.nombre <= iAg2.nombre) then begin
            min := iAg1;
            leer(arcDet1, iAg1);
    end
    else begin
        min := iAg2;
        leer(arcDet2, iAg2);
    end;
end;

procedure actualizarMaestro(var arcDet1, arcDet2: archivoAgencia; var arcMae: archivoAlfabetizacion);
var 
    iAg1, iag2, min: infoAgencia;
    iAlf: infoAlfabetizacion;
begin
    reset(arcDet1);
    reset(arcDet2)
    reset(arcMae);
    leerInfoAgencia(arcDet1, iAg1);
    leerInfoAgencia(arcDet2, iAg2);
    
    minimo(arcDet1, arcDet2, iAg1, iAg2, min);
    while (min.provincia <> valorAlto) do begin 
        read(arcMae, iAlf);
        while (iAlf.provincia <> min.provincia) do
            read(arcMae, iAlf);
        while (iAlf.provincia = min.provincia) do begin 
            iAlf.cantidadAlfabetizados := iAlf.cantidadAlfabetizados + min.cantidadAlfabetizados;
            iAlf.totalEncuestados := iAlf.totalEncuestados + min.totalEncuestados;
            minimo(arcDet1, arcDet2, iAg1, iAg2, min);
        end;
        seek(arcMae, filepos(arcMae)-1);
        write(arcMae, iAlf);
    end;
    close(arcDet1);
    close(arcDet2);
    close(arcMae);
end;
    
    
var
    detalle: archivoAgencia;
    maestro: archivoAlfabetizacion;
begin

end.
    
