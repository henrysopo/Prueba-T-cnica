/* SCRIPT DESARROLLO PUNTOS PRUEBA TÉCNICA */
/* 5.	Consulta de Clientes que han comprado un acumulado $100.000 en los últimos 60 días*/

select cli.cli_primer_nombre,
           cli.cli_segundo_nombre,
	   cli.cli_primer_apellido,
	   cli.cli_segundo_apellido
from pru_cliente cli, pru_factura fac
where cli.cli_documento = fac.fac_doc_cliente
and fac.fac_fecha > sysdate - 60
group by cli.cli_primer_nombre,
       cli.cli_segundo_nombre,
	   cli.cli_primer_apellido,
	   cli.cli_segundo_apellido
having sum(fac.fac_valor_total) > 100000;                 

 
/*6.	Consulta de los 100 productos más vendidos en los últimos 30 días.*/

select distinct rem.rem_id_repuesto
from pru_factura fac, pru_mantenimiento man, pru_repuesto_mantenimiento rem
where fac.fac_id_mantenimiento = man.man_id
and man.man_id = rem.rem_id_mantenimiento
and fac.fac_fecha > sysdate - 30
and rownum < 100;


/*8.	Consulta de todos los clientes que han tenido más de un(1) mantenimento en los últimos 30 días.*/

select cli.cli_document,
       cli.cli_primer_nombre,
       cli.cli_segundo_nombre,
	   cli.cli_primer_apellido,
	   cli.cli_segundo_apellido
from pru_mantenimiento man, pru_cliente cli, pru_factura fac
where man.man_doc_cliente = cli.cli_documento
and fac.fac_id_mantenimiento = man.man_id
and fac.fac_fecha > sysdate - 30
group by cli.cli_document,
       cli.cli_primer_nombre,
       cli.cli_segundo_nombre,
	   cli.cli_primer_apellido,
	   cli.cli_segundo_apellido
having count(cli.cli_documento) > 1;

/*9.	Procedimiento que reste la cantidad de productos del inventario de las tiendas cada que se presente una venta.*/


create or replace procedure spRestarInventario(
  p_id_repuesto number,
  p_unid_vendidas varchar2
)
is
begin
	update pru_repuesto rep
	  set rep.rep_unid_disponibles = rep.rep_unid_disponibles -      p_unid_vendidas
	where rep.rep_id = p_id_repuesto;
        commit;
		
end spRestarInventario;
