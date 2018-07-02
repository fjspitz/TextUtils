USE master
go


PRINT "<<<< CREATE DATABASE SABED>>>>"
go


IF EXISTS (SELECT 1 FROM master.dbo.sysdatabases
	   WHERE name = 'SABED')
	DROP DATABASE SABED
go


IF (@@error != 0)
BEGIN
	PRINT "Error dropping database 'SABED'"
	SELECT syb_quit()
END
go


CREATE DATABASE SABED
	    ON disp6_dat = '162M' -- 82944 pages
	     , disp6_dat = '36M' -- 18432 pages
	LOG ON disp3_log = '19M' -- 9728 pages
WITH DURABILITY = FULL
go


use SABED
go

exec sp_changedbowner 'OdeSABED', true 
go

exec master.dbo.sp_dboption SABED, 'select into/bulkcopy', true
go

exec master.dbo.sp_dboption SABED, 'trunc log on chkpt', true
go

exec master.dbo.sp_dboption SABED, 'abort tran on log full', true
go

checkpoint
go


-----------------------------------------------------------------------------
-- DDL for Table 'SABED.dbo.saat_alumnos'
-----------------------------------------------------------------------------
print '<<<<< CREATING Table - "SABED.dbo.saat_alumnos" >>>>>'
go

use SABED
go 

setuser 'dbo'
go 

create table saat_alumnos (
	id_alumno                       numeric(18,0)                    identity  ,
	id_persona                      numeric(18,0)                    not null  ,
	id_colegio                      numeric(18,0)                    not null  ,
	e_alumno                        varchar(15)                      not null  ,
	f_propuesta_beca                datetime                             null  ,
	x_observ_prop                   varchar(250)                         null  ,
	f_resul_prop                    datetime                             null  ,
	x_observ_resul_prop             varchar(250)                         null  ,
	e_estado_prop                   varchar(15)                          null  ,
	x_motivo_suspension             varchar(250)                         null  ,
	f_suspension                    smalldatetime                        null  ,
	f_baja                          datetime                             null  ,
	x_observ_baja                   varchar(250)                         null  ,
	d_anio_curso                    varchar(40)                          null  ,
	c_orient_colegio                numeric(18,0)                        null  ,
	c_modal_col                     numeric(18,0)                        null  ,
	m_auditoria                     numeric(18,0)                        null  ,
	c_cont_estudios                 numeric(18,0)                        null  ,
	c_carrera_cont_est              numeric(18,0)                        null  ,
	c_ocup_eleg                     numeric(18,0)                        null  ,
	e_registro                      char(1)                              null  ,
	id_tipo_beca                    numeric(18,0)                        null  ,
	x_observaciones                 varchar(250)                         null  ,
	c_usua_alta                     numeric(18,0)                    not null  ,
	f_alta                          smalldatetime                   DEFAULT  getDate() 
      null  ,
	c_usua_actuac                   numeric(18,0)                        null  ,
	f_actuac                        smalldatetime                        null  ,
	id_grupo                        numeric(18,0)                        null  ,
	c_cant_cuotas                   numeric(18,0)                        null  ,
 PRIMARY KEY CLUSTERED ( id_alumno )  on 'default',
CONSTRAINT saat_alum_check_e_alu CHECK  (e_alumno in ('CANDIDATO','POSTULANTE','BECADO','ELIMINADO',
                    'RECHAZADO','BAJABECA','SUSPENDIDO','COMPLETADO')),
		CONSTRAINT saat_alum_check_e_reg CHECK  (e_registro in ('A','B','D')),
		CONSTRAINT saat_alch_e_est_prop CHECK  (e_estado_prop in ('NUEVA','ANALISIS','TERMINADO')))
lock allpages
with dml_logging = full
, lob_compression = 
 on 'default'
go 

Grant Select on dbo.saat_alumnos to Usr_trp_SABED 
go
Grant Select on dbo.saat_alumnos to grp_cons_bbvaprod02_sabed 
go

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Table 'SABED.dbo.saat_alumnos_eval_academ'
-----------------------------------------------------------------------------
print '<<<<< CREATING Table - "SABED.dbo.saat_alumnos_eval_academ" >>>>>'
go

setuser 'dbo'
go 

create table saat_alumnos_eval_academ (
	id_eval_academ                  numeric(18,0)                    identity  ,
	id_alumno                       numeric(18,0)                    not null  ,
	f_eval_academ                   smalldatetime                    not null  ,
	id_periodo                      numeric(18,0)                    not null  ,
	e_registro                      char(1)                          not null  ,
	c_usua_alta                     numeric(18,0)                    not null  ,
	f_alta                          smalldatetime                   DEFAULT  getDate() 
      null  ,
	c_usua_actuac                   numeric(18,0)                        null  ,
	f_actuac                        smalldatetime                        null  ,
 PRIMARY KEY CLUSTERED ( id_eval_academ )  on 'default',
		CONSTRAINT saat_aeac_uk UNIQUE NONCLUSTERED ( id_alumno, f_eval_academ, id_periodo )  on 'default',
		CONSTRAINT saat_aeac_uk_aluper UNIQUE NONCLUSTERED ( id_alumno, id_periodo )  on 'default',
CONSTRAINT saat_aeac_check_e_reg CHECK  (e_registro in ('A','B','D')))
lock allpages
with dml_logging = full
, lob_compression = 
 on 'default'
go 

Grant Select on dbo.saat_alumnos_eval_academ to Usr_trp_SABED 
go
Grant Select on dbo.saat_alumnos_eval_academ to grp_cons_bbvaprod02_sabed 
go

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Table 'SABED.dbo.saat_alumnos_parentesco'
-----------------------------------------------------------------------------
print '<<<<< CREATING Table - "SABED.dbo.saat_alumnos_parentesco" >>>>>'
go

setuser 'dbo'
go 

create table saat_alumnos_parentesco (
	id_alumno                       numeric(18,0)                    not null  ,
	id_persona_rel                  numeric(18,0)                    not null  ,
	m_tit_tarjeta                   varchar(1)                      DEFAULT  'N' 
  not null  ,
	c_parentesco                    numeric(18,0)                        null  ,
	c_usua_alta                     numeric(18,0)                    not null  ,
	f_alta                          smalldatetime                   DEFAULT  getDate() 
      null  ,
	c_usua_actuac                   numeric(18,0)                        null  ,
	f_actuac                        smalldatetime                        null  ,
 PRIMARY KEY CLUSTERED ( id_alumno, id_persona_rel )  on 'default',
CONSTRAINT saat_alpa_check_m_tit CHECK  (m_tit_tarjeta in ('S','N')))
lock allpages
with dml_logging = full
, lob_compression = 
 on 'default'
go 

Grant Select on dbo.saat_alumnos_parentesco to Usr_trp_SABED 
go
Grant Select on dbo.saat_alumnos_parentesco to grp_cons_bbvaprod02_sabed 
go

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Table 'SABED.dbo.saat_alumnos_rendicion_gasto'
-----------------------------------------------------------------------------
print '<<<<< CREATING Table - "SABED.dbo.saat_alumnos_rendicion_gasto" >>>>>'
go

setuser 'dbo'
go 

create table saat_alumnos_rendicion_gasto (
	id_rendicion                    numeric(18,0)                    identity  ,
	id_alumno                       numeric(18,0)                    not null  ,
	f_rend_gasto                    smalldatetime                    not null  ,
	id_periodo                      numeric(18,0)                    not null  ,
	e_registro                      char(1)                          not null  ,
	c_usua_alta                     numeric(18,0)                    not null  ,
	f_alta                          smalldatetime                   DEFAULT  getDate() 
      null  ,
	c_usua_actuac                   numeric(18,0)                        null  ,
	f_actuac                        smalldatetime                        null  ,
 PRIMARY KEY CLUSTERED ( id_rendicion, id_alumno, f_rend_gasto, id_periodo )  on 'default',
CONSTRAINT saat_arga_check CHECK  (e_registro in ('A','B','D')))
lock allpages
with dml_logging = full
, lob_compression = 
 on 'default'
go 

Grant Select on dbo.saat_alumnos_rendicion_gasto to Usr_trp_SABED 
go
Grant Select on dbo.saat_alumnos_rendicion_gasto to grp_cons_bbvaprod02_sabed 
go

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Table 'SABED.dbo.saat_alumnos_tarjetas'
-----------------------------------------------------------------------------
print '<<<<< CREATING Table - "SABED.dbo.saat_alumnos_tarjetas" >>>>>'
go

setuser 'dbo'
go 

create table saat_alumnos_tarjetas (
	id_alu_tar                      numeric(18,0)                    identity  ,
	id_alumno                       numeric(18,0)                    not null  ,
	id_persona_tit                  numeric(18,0)                    not null  ,
	d_nro_tarjeta                   varchar(16)                      not null  ,
	d_nro_cta_cred                  varchar(10)                      not null  ,
	f_baja                          datetime                             null  ,
	f_vigencia_tar_dsd              datetime                         not null  ,
	f_vigencia_tar_hta              datetime                         not null  ,
	c_usua_alta                     numeric(18,0)                    not null  ,
	f_alta                          datetime                        DEFAULT  getDate() 
      null  ,
	c_usua_actuac                   numeric(18,0)                        null  ,
	f_actuac                        datetime                             null  ,
 PRIMARY KEY CLUSTERED ( id_alu_tar )  on 'default' 
)
lock allpages
with dml_logging = full
, lob_compression = 
 on 'default'
go 

Grant Select on dbo.saat_alumnos_tarjetas to Usr_trp_SABED 
go
Grant Select on dbo.saat_alumnos_tarjetas to grp_cons_bbvaprod02_sabed 
go

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Table 'SABED.dbo.saat_detalle_eval_academ'
-----------------------------------------------------------------------------
print '<<<<< CREATING Table - "SABED.dbo.saat_detalle_eval_academ" >>>>>'
go

setuser 'dbo'
go 

create table saat_detalle_eval_academ (
	id_det_eval_academ              numeric(18,0)                    identity  ,
	id_eval_academ                  numeric(18,0)                    not null  ,
	id_pregunta                     numeric(18,0)                    not null  ,
	id_respuesta                    numeric(18,0)                    not null  ,
	d_valor_rta                     varchar(250)                         null  ,
	c_usua_alta                     numeric(18,0)                    not null  ,
	f_alta                          smalldatetime                   DEFAULT  getDate() 
      null  ,
	c_usua_actuac                   numeric(18,0)                        null  ,
	f_actuac                        smalldatetime                        null  ,
 PRIMARY KEY CLUSTERED ( id_det_eval_academ )  on 'default' 
)
lock allpages
with dml_logging = full
, lob_compression = 
 on 'default'
go 

Grant Select on dbo.saat_detalle_eval_academ to Usr_trp_SABED 
go
Grant Select on dbo.saat_detalle_eval_academ to grp_cons_bbvaprod02_sabed 
go

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Table 'SABED.dbo.saat_detalle_rend_gasto'
-----------------------------------------------------------------------------
print '<<<<< CREATING Table - "SABED.dbo.saat_detalle_rend_gasto" >>>>>'
go

setuser 'dbo'
go 

create table saat_detalle_rend_gasto (
	id_detalle_rend                 numeric(18,0)                    identity  ,
	id_rendicion                    numeric(18,0)                    not null  ,
	id_alumno                       numeric(18,0)                    not null  ,
	f_rend_gasto                    smalldatetime                    not null  ,
	id_periodo                      numeric(18,0)                    not null  ,
	i_gasto                         numeric(18,2)                    not null  ,
	c_gasto                         numeric(18,0)                        null  ,
	x_descrip_otros_gastos          varchar(40)                          null  ,
	c_usua_alta                     numeric(18,0)                    not null  ,
	f_alta                          smalldatetime                   DEFAULT  getDate() 
      null  ,
	c_usua_actuac                   numeric(18,0)                        null  ,
	f_actuac                        smalldatetime                        null  ,
 PRIMARY KEY CLUSTERED ( id_rendicion, id_alumno, f_rend_gasto, id_periodo, id_detalle_rend )  on 'default' 
)
lock allpages
with dml_logging = full
, lob_compression = 
 on 'default'
go 

Grant Select on dbo.saat_detalle_rend_gasto to Usr_trp_SABED 
go
Grant Select on dbo.saat_detalle_rend_gasto to grp_cons_bbvaprod02_sabed 
go

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Table 'SABED.dbo.saat_preguntas_eval_academ'
-----------------------------------------------------------------------------
print '<<<<< CREATING Table - "SABED.dbo.saat_preguntas_eval_academ" >>>>>'
go

setuser 'dbo'
go 

create table saat_preguntas_eval_academ (
	id_pregunta                     numeric(18,0)                    identity  ,
	d_pregunta                      varchar(40)                      not null  ,
	id_seccion                      numeric(18,0)                    not null  ,
	c_usua_alta                     numeric(18,0)                    not null  ,
	f_baja                          smalldatetime                        null  ,
	n_orden                         int                              not null  ,
	d_modo_visualizacion            varchar(40)                      not null  ,
	f_alta                          smalldatetime                   DEFAULT  getDate() 
      null  ,
	c_usua_actuac                   numeric(18,0)                        null  ,
	f_actuac                        smalldatetime                        null  ,
	tipo_dato                       varchar(12)                          null  ,
 PRIMARY KEY CLUSTERED ( id_pregunta )  on 'default',
CONSTRAINT saat_preg_ev_acad_mod CHECK  (d_modo_visualizacion in ('CB','RB','TX')))
lock allpages
with dml_logging = full
, lob_compression = 
 on 'default'
go 

Grant Select on dbo.saat_preguntas_eval_academ to Usr_trp_SABED 
go
Grant Select on dbo.saat_preguntas_eval_academ to grp_cons_bbvaprod02_sabed 
go

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Table 'SABED.dbo.saat_respuestas_eval_academ'
-----------------------------------------------------------------------------
print '<<<<< CREATING Table - "SABED.dbo.saat_respuestas_eval_academ" >>>>>'
go

setuser 'dbo'
go 

create table saat_respuestas_eval_academ (
	id_respuesta                    numeric(18,0)                    identity  ,
	d_respuesta                     varchar(40)                          null  ,
	id_pregunta                     numeric(18,0)                    not null  ,
	n_orden                         int                              not null  ,
	c_usua_alta                     numeric(18,0)                    not null  ,
	f_alta                          smalldatetime                   DEFAULT  getDate() 
      null  ,
	c_usua_actuac                   numeric(18,0)                        null  ,
	f_actuac                        smalldatetime                        null  ,
 PRIMARY KEY CLUSTERED ( id_respuesta )  on 'default' 
)
lock allpages
with dml_logging = full
, lob_compression = 
 on 'default'
go 

Grant Select on dbo.saat_respuestas_eval_academ to Usr_trp_SABED 
go
Grant Select on dbo.saat_respuestas_eval_academ to grp_cons_bbvaprod02_sabed 
go

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Table 'SABED.dbo.saat_secciones_eval_academ'
-----------------------------------------------------------------------------
print '<<<<< CREATING Table - "SABED.dbo.saat_secciones_eval_academ" >>>>>'
go

setuser 'dbo'
go 

create table saat_secciones_eval_academ (
	id_seccion                      numeric(18,0)                    identity  ,
	d_seccion                       varchar(40)                      not null  ,
	c_usua_alta                     numeric(18,0)                    not null  ,
	f_baja                          smalldatetime                        null  ,
	n_orden                         int                                  null  ,
	f_alta                          smalldatetime                   DEFAULT  getDate() 
      null  ,
	c_usua_actuac                   numeric(18,0)                        null  ,
	f_actuac                        smalldatetime                        null  ,
	s_solo_ultimo                   int                                  null  ,
 PRIMARY KEY CLUSTERED ( id_seccion )  on 'default' 
)
lock allpages
with dml_logging = full
, lob_compression = 
 on 'default'
go 

Grant Select on dbo.saat_secciones_eval_academ to Usr_trp_SABED 
go
Grant Select on dbo.saat_secciones_eval_academ to grp_cons_bbvaprod02_sabed 
go

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Table 'SABED.dbo.saat_tipo_beca'
-----------------------------------------------------------------------------
print '<<<<< CREATING Table - "SABED.dbo.saat_tipo_beca" >>>>>'
go

setuser 'dbo'
go 

create table saat_tipo_beca (
	id_tipo_beca                    numeric(18,0)                    identity  ,
	d_tipo_beca                     varchar(40)                      not null  ,
	f_baja                          smalldatetime                        null  ,
	c_usua_alta                     numeric(18,0)                    not null  ,
	f_alta                          smalldatetime                   DEFAULT  getDate() 
      null  ,
	c_usua_actuac                   numeric(18,0)                        null  ,
	f_actuac                        smalldatetime                        null  ,
 PRIMARY KEY CLUSTERED ( id_tipo_beca )  on 'default' 
)
lock allpages
with dml_logging = full
, lob_compression = 
 on 'default'
go 

Grant Select on dbo.saat_tipo_beca to Usr_trp_SABED 
go
Grant Select on dbo.saat_tipo_beca to grp_cons_bbvaprod02_sabed 
go

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Table 'SABED.dbo.saat_tipo_beca_detalle'
-----------------------------------------------------------------------------
print '<<<<< CREATING Table - "SABED.dbo.saat_tipo_beca_detalle" >>>>>'
go

setuser 'dbo'
go 

create table saat_tipo_beca_detalle (
	id_tipo_beca_det                numeric(18,0)                    identity  ,
	id_tipo_beca                    numeric(18,0)                    not null  ,
	i_beca                          numeric(18,2)                    not null  ,
	f_vigencia_desde                smalldatetime                    not null  ,
	f_vigencia_hasta                smalldatetime                        null  ,
	c_usua_alta                     numeric(18,0)                    not null  ,
	f_alta                          smalldatetime                   DEFAULT  getDate() 
      null  ,
	c_usua_actuac                   numeric(18,0)                        null  ,
	f_actuac                        smalldatetime                        null  ,
 PRIMARY KEY CLUSTERED ( id_tipo_beca, f_vigencia_desde )  on 'default' 
)
lock allpages
with dml_logging = full
, lob_compression = 
 on 'default'
go 

Grant Select on dbo.saat_tipo_beca_detalle to Usr_trp_SABED 
go
Grant Select on dbo.saat_tipo_beca_detalle to grp_cons_bbvaprod02_sabed 
go

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Table 'SABED.dbo.sabed_log'
-----------------------------------------------------------------------------
print '<<<<< CREATING Table - "SABED.dbo.sabed_log" >>>>>'
go

setuser 'dbo'
go 

create table sabed_log (
	id_paso                         numeric(18,0)                    identity  ,
	numero                          numeric(18,2)                        null  ,
	fecha                           datetime                             null  ,
	descrip                         varchar(500)                         null  ,
	nom_proc                        varchar(40)                          null   
)
lock allpages
with dml_logging = full
, lob_compression = 
 on 'default'
go 

Grant Select on dbo.sabed_log to Usr_trp_SABED 
go
Grant Select on dbo.sabed_log to grp_cons_bbvaprod02_sabed 
go

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Table 'SABED.dbo.sact_periodos_eval_acad'
-----------------------------------------------------------------------------
print '<<<<< CREATING Table - "SABED.dbo.sact_periodos_eval_acad" >>>>>'
go

setuser 'dbo'
go 

create table sact_periodos_eval_acad (
	id_periodo                      numeric(18,0)                    identity  ,
	f_inicio_periodo                smalldatetime                    not null  ,
	f_fin_periodo                   smalldatetime                    not null  ,
	d_periodo                       varchar(40)                      not null  ,
	c_usua_alta                     numeric(18,0)                    not null  ,
	f_alta                          smalldatetime                   DEFAULT  getDate() 
      null  ,
	c_usua_actuac                   numeric(18,0)                        null  ,
	f_actuac                        smalldatetime                        null  ,
	s_ultimo                        int                                  null  ,
 PRIMARY KEY CLUSTERED ( id_periodo )  on 'default' 
)
lock allpages
with dml_logging = full
, lob_compression = 
 on 'default'
go 

Grant Select on dbo.sact_periodos_eval_acad to Usr_trp_SABED 
go
Grant Select on dbo.sact_periodos_eval_acad to grp_cons_bbvaprod02_sabed 
go

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Table 'SABED.dbo.sact_periodos_recargas'
-----------------------------------------------------------------------------
print '<<<<< CREATING Table - "SABED.dbo.sact_periodos_recargas" >>>>>'
go

setuser 'dbo'
go 

create table sact_periodos_recargas (
	id_periodo_recarga              numeric(18,0)                    identity  ,
	f_inicio_periodo                smalldatetime                    not null  ,
	f_fin_periodo                   smalldatetime                    not null  ,
	d_periodo                       varchar(40)                      not null  ,
	c_usua_alta                     numeric(18,0)                    not null  ,
	f_alta                          smalldatetime                   DEFAULT  getdate() 
      null  ,
	c_usua_actuac                   numeric(18,0)                        null  ,
	f_actuac                        smalldatetime                        null  ,
 PRIMARY KEY CLUSTERED ( id_periodo_recarga )  on 'default' 
)
lock allpages
with dml_logging = full
, lob_compression = 
 on 'default'
go 

Grant Select on dbo.sact_periodos_recargas to Usr_trp_SABED 
go
Grant Select on dbo.sact_periodos_recargas to grp_cons_bbvaprod02_sabed 
go

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Table 'SABED.dbo.sact_periodos_rendicion'
-----------------------------------------------------------------------------
print '<<<<< CREATING Table - "SABED.dbo.sact_periodos_rendicion" >>>>>'
go

setuser 'dbo'
go 

create table sact_periodos_rendicion (
	id_periodo                      numeric(18,0)                    identity  ,
	f_inicio_periodo                smalldatetime                    not null  ,
	f_fin_periodo                   smalldatetime                    not null  ,
	d_periodo                       varchar(40)                      not null  ,
	f_recarga_periodo               smalldatetime                    not null  ,
	c_usua_alta                     numeric(18,0)                    not null  ,
	f_alta                          smalldatetime                   DEFAULT  getDate() 
      null  ,
	c_usua_actuac                   numeric(18,0)                        null  ,
	f_actuac                        smalldatetime                        null  ,
 PRIMARY KEY CLUSTERED ( id_periodo )  on 'default' 
)
lock allpages
with dml_logging = full
, lob_compression = 
 on 'default'
go 

Grant Select on dbo.sact_periodos_rendicion to Usr_trp_SABED 
go
Grant Select on dbo.sact_periodos_rendicion to grp_cons_bbvaprod02_sabed 
go

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Table 'SABED.dbo.saft_avisos'
-----------------------------------------------------------------------------
print '<<<<< CREATING Table - "SABED.dbo.saft_avisos" >>>>>'
go

setuser 'dbo'
go 

create table saft_avisos (
	id_aviso                        numeric(18,0)                    identity  ,
	id_origen                       numeric(18,0)                    not null  ,
	c_tipo_aviso                    numeric(18,0)                        null  ,
	c_evento_calend                 numeric(18,0)                        null  ,
	f_envio                         smalldatetime                        null  ,
	x_cuerpo_mensaje                varchar(250)                         null  ,
	f_vigencia                      smalldatetime                        null  ,
	f_baja                          smalldatetime                        null  ,
	c_usua_alta                     numeric(18,0)                    not null  ,
	f_alta                          smalldatetime                   DEFAULT  getDate() 
      null  ,
	c_usua_actuac                   numeric(18,0)                        null  ,
	f_actuac                        smalldatetime                        null  ,
 PRIMARY KEY CLUSTERED ( id_aviso )  on 'default' 
)
lock allpages
with dml_logging = full
, lob_compression = 
 on 'default'
go 

Grant Select on dbo.saft_avisos to Usr_trp_SABED 
go
Grant Select on dbo.saft_avisos to grp_cons_bbvaprod02_sabed 
go

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Table 'SABED.dbo.saft_avisos_destinatarios'
-----------------------------------------------------------------------------
print '<<<<< CREATING Table - "SABED.dbo.saft_avisos_destinatarios" >>>>>'
go

setuser 'dbo'
go 

create table saft_avisos_destinatarios (
	id_aviso_dest                   numeric(18,0)                    identity  ,
	id_aviso                        numeric(18,0)                    not null  ,
	id_perfil                       numeric(18,0)                        null  ,
	id_usuario                      numeric(18,0)                        null  ,
	c_usua_alta                     numeric(18,0)                    not null  ,
	f_alta                          smalldatetime                   DEFAULT  getDate() 
      null  ,
	c_usua_actuac                   numeric(18,0)                        null  ,
	f_actuac                        smalldatetime                        null  ,
 PRIMARY KEY CLUSTERED ( id_aviso_dest )  on 'default',
		CONSTRAINT saft_avde_perf_uk UNIQUE NONCLUSTERED ( id_aviso, id_perfil )  on 'default' 
)
lock allpages
with dml_logging = full
, lob_compression = 
 on 'default'
go 

Grant Select on dbo.saft_avisos_destinatarios to Usr_trp_SABED 
go
Grant Select on dbo.saft_avisos_destinatarios to grp_cons_bbvaprod02_sabed 
go

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Table 'SABED.dbo.saft_noticias'
-----------------------------------------------------------------------------
print '<<<<< CREATING Table - "SABED.dbo.saft_noticias" >>>>>'
go

setuser 'dbo'
go 

create table saft_noticias (
	id_noticia                      numeric(18,0)                    identity  ,
	x_titulo                        varchar(250)                     not null  ,
	x_copete                        varchar(1000)                    not null  ,
	x_cuerpo_mensaje                varchar(16300)                   not null  ,
	f_vigencia_desde                smalldatetime                    not null  ,
	f_vigencia_hasta                smalldatetime                        null  ,
	f_baja                          smalldatetime                        null  ,
	c_usua_alta                     numeric(18,0)                    not null  ,
	f_alta                          smalldatetime                   DEFAULT  getDate() 
      null  ,
	c_usua_actuac                   numeric(18,0)                        null  ,
	f_actuac                        smalldatetime                        null  ,
 PRIMARY KEY CLUSTERED ( id_noticia )  on 'default' 
)
lock allpages
with dml_logging = full
, lob_compression = 
 on 'default'
go 

Grant Select on dbo.saft_noticias to Usr_trp_SABED 
go
Grant Select on dbo.saft_noticias to grp_cons_bbvaprod02_sabed 
go

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Table 'SABED.dbo.saft_ongs'
-----------------------------------------------------------------------------
print '<<<<< CREATING Table - "SABED.dbo.saft_ongs" >>>>>'
go

setuser 'dbo'
go 

create table saft_ongs (
	id_ong                          numeric(18,0)                    identity  ,
	d_nombre_ong                    varchar(40)                      not null  ,
	m_fundacion                     char(1)                         DEFAULT  'N' 
      null  ,
	q_becas                         numeric(7,0)                         null  ,
	e_registro                      char(1)                              null  ,
	d_cuit                          varchar(40)                      not null  ,
	d_mail                          varchar(40)                          null  ,
	d_calle                         varchar(40)                          null  ,
	d_nro                           varchar(40)                          null  ,
	d_piso                          varchar(40)                          null  ,
	d_depto                         varchar(40)                          null  ,
	d_localidad                     varchar(40)                          null  ,
	c_provincia                     numeric(18,0)                        null  ,
	f_baja                          smalldatetime                        null  ,
	c_tipo_ong                      numeric(18,0)                        null  ,
	d_suc_cuenta                    varchar(4)                           null  ,
	d_tipo_cuenta                   varchar(3)                           null  ,
	d_nro_cuenta                    varchar(7)                           null  ,
	c_usua_alta                     numeric(18,0)                    not null  ,
	f_alta                          smalldatetime                   DEFAULT  getDate() 
      null  ,
	c_usua_actuac                   numeric(18,0)                        null  ,
	f_actuac                        smalldatetime                        null  ,
	c_nro_cliente                   numeric(8,0)                         null  ,
 PRIMARY KEY CLUSTERED ( id_ong )  on 'default',
		CONSTRAINT saft_ongs_uk UNIQUE NONCLUSTERED ( d_cuit, d_nombre_ong, c_tipo_ong )  on 'default',
CONSTRAINT saft_ongs_check_e_reg CHECK  (e_registro in ('A','B','D')),
		CONSTRAINT sagt_ongs_check_m_fund CHECK  (m_fundacion in ('S','N')))
lock allpages
with dml_logging = full
, lob_compression = 
 on 'default'
go 

Grant Select on dbo.saft_ongs to Usr_trp_SABED 
go
Grant Select on dbo.saft_ongs to grp_cons_bbvaprod02_sabed 
go

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Table 'SABED.dbo.saft_personas_ong'
-----------------------------------------------------------------------------
print '<<<<< CREATING Table - "SABED.dbo.saft_personas_ong" >>>>>'
go

setuser 'dbo'
go 

create table saft_personas_ong (
	id_ong                          numeric(18,0)                    not null  ,
	id_persona                      numeric(18,0)                    not null  ,
	e_registro                      varchar(1)                           null  ,
	c_usua_alta                     numeric(18,0)                    not null  ,
	f_alta                          smalldatetime                   DEFAULT  getDate() 
      null  ,
	c_usua_actuac                   numeric(18,0)                        null  ,
	f_actuac                        smalldatetime                        null  ,
 PRIMARY KEY CLUSTERED ( id_ong, id_persona )  on 'default',
CONSTRAINT saft_pong_check CHECK  (e_registro in ('A','B','D')))
lock allpages
with dml_logging = full
, lob_compression = 
 on 'default'
go 

Grant Select on dbo.saft_personas_ong to Usr_trp_SABED 
go
Grant Select on dbo.saft_personas_ong to grp_cons_bbvaprod02_sabed 
go

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Table 'SABED.dbo.saft_tutores'
-----------------------------------------------------------------------------
print '<<<<< CREATING Table - "SABED.dbo.saft_tutores" >>>>>'
go

setuser 'dbo'
go 

create table saft_tutores (
	id_tutor                        numeric(18,0)                    identity  ,
	id_ong                          numeric(18,0)                    not null  ,
	id_persona                      numeric(18,0)                    not null  ,
	e_registro                      char(1)                          not null  ,
	c_usua_alta                     numeric(18,0)                    not null  ,
	f_alta                          smalldatetime                   DEFAULT  getDate() 
      null  ,
	c_usua_actuac                   numeric(18,0)                        null  ,
	f_actuac                        smalldatetime                        null  ,
 PRIMARY KEY CLUSTERED ( id_tutor )  on 'default',
		CONSTRAINT saft_tuto_uk UNIQUE NONCLUSTERED ( id_ong, id_persona )  on 'default',
CONSTRAINT saft_tuto_check CHECK  (e_registro in ('A','B','D')))
lock allpages
with dml_logging = full
, lob_compression = 
 on 'default'
go 

Grant Select on dbo.saft_tutores to Usr_trp_SABED 
go
Grant Select on dbo.saft_tutores to grp_cons_bbvaprod02_sabed 
go

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Table 'SABED.dbo.sagt_alumnos_tutores'
-----------------------------------------------------------------------------
print '<<<<< CREATING Table - "SABED.dbo.sagt_alumnos_tutores" >>>>>'
go

setuser 'dbo'
go 

create table sagt_alumnos_tutores (
	id_alumno                       numeric(18,0)                    not null  ,
	id_tutor                        numeric(18,0)                    not null  ,
	id_perfil                       numeric(18,0)                    not null  ,
	c_usua_alta                     numeric(18,0)                    not null  ,
	f_alta                          smalldatetime                   DEFAULT  getDate() 
      null  ,
	c_usua_actuac                   numeric(18,0)                        null  ,
	f_actuac                        smalldatetime                        null  ,
 PRIMARY KEY CLUSTERED ( id_alumno, id_tutor, id_perfil )  on 'default' 
)
lock allpages
with dml_logging = full
, lob_compression = 
 on 'default'
go 

Grant Select on dbo.sagt_alumnos_tutores to Usr_trp_SABED 
go
Grant Select on dbo.sagt_alumnos_tutores to grp_cons_bbvaprod02_sabed 
go

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Table 'SABED.dbo.sagt_colegios'
-----------------------------------------------------------------------------
print '<<<<< CREATING Table - "SABED.dbo.sagt_colegios" >>>>>'
go

setuser 'dbo'
go 

create table sagt_colegios (
	id_colegio                      numeric(18,0)                    identity  ,
	d_nombre_directora              varchar(40)                          null  ,
	d_nombre_colegio                varchar(40)                      not null  ,
	d_cuit                          varchar(40)                          null  ,
	d_mail                          varchar(40)                          null  ,
	d_calle                         varchar(40)                          null  ,
	d_nro                           varchar(40)                          null  ,
	d_piso                          varchar(40)                          null  ,
	d_depto                         varchar(40)                          null  ,
	d_localidad                     varchar(40)                      not null  ,
	c_provincia                     numeric(18,0)                    not null  ,
	e_registro                      char(1)                          not null  ,
	f_baja                          smalldatetime                        null  ,
	c_usua_alta                     numeric(18,0)                    not null  ,
	f_alta                          smalldatetime                   DEFAULT  getDate() 
      null  ,
	c_usua_actuac                   numeric(18,0)                        null  ,
	f_actuac                        smalldatetime                        null  ,
 PRIMARY KEY CLUSTERED ( id_colegio )  on 'default',
		CONSTRAINT sagt_cole_uk UNIQUE NONCLUSTERED ( d_nombre_colegio, c_provincia, d_localidad )  on 'default',
CONSTRAINT sagt_cole_check_e_reg CHECK  (e_registro in ('A','B','D')))
lock allpages
with dml_logging = full
, lob_compression = 
 on 'default'
go 

Grant Select on dbo.sagt_colegios to Usr_trp_SABED 
go
Grant Select on dbo.sagt_colegios to grp_cons_bbvaprod02_sabed 
go

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Table 'SABED.dbo.sagt_personas'
-----------------------------------------------------------------------------
print '<<<<< CREATING Table - "SABED.dbo.sagt_personas" >>>>>'
go

setuser 'dbo'
go 

create table sagt_personas (
	id_persona                      numeric(18,0)                    identity  ,
	c_documento                     numeric(18,0)                    not null  ,
	n_documento                     numeric(18,0)                    not null  ,
	d_apellido                      varchar(40)                      not null  ,
	d_nombre                        varchar(40)                      not null  ,
	d_cuil                          varchar(40)                          null  ,
	f_nacimiento                    smalldatetime                        null  ,
	c_nacionalidad                  numeric(18,0)                        null  ,
	c_ocupacion                     numeric(18,0)                        null  ,
	c_estado_civil                  numeric(18,0)                        null  ,
	d_mail                          varchar(40)                          null  ,
	d_calle                         varchar(40)                          null  ,
	d_nro                           varchar(40)                          null  ,
	d_piso                          varchar(40)                          null  ,
	d_depto                         varchar(40)                          null  ,
	d_localidad                     varchar(40)                          null  ,
	c_provincia                     numeric(18,0)                        null  ,
	c_sexo                          numeric(18,0)                        null  ,
	e_registro                      char(1)                              null  ,
	c_usua_alta                     numeric(18,0)                    not null  ,
	f_alta                          smalldatetime                   DEFAULT  getDate() 
      null  ,
	c_usua_actuac                   numeric(18,0)                        null  ,
	f_actuac                        smalldatetime                        null  ,
 PRIMARY KEY CLUSTERED ( id_persona )  on 'default',
		CONSTRAINT sagt_pers_uk_doc UNIQUE NONCLUSTERED ( c_documento, n_documento )  on 'default',
CONSTRAINT sagt_pers_check_e_reg CHECK  (e_registro in ('A','B','D')))
lock allpages
with dml_logging = full
, lob_compression = 
 on 'default'
go 

Grant Select on dbo.sagt_personas to Usr_trp_SABED 
go
Grant Select on dbo.sagt_personas to grp_cons_bbvaprod02_sabed 
go

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Table 'SABED.dbo.sagt_telefonos'
-----------------------------------------------------------------------------
print '<<<<< CREATING Table - "SABED.dbo.sagt_telefonos" >>>>>'
go

setuser 'dbo'
go 

create table sagt_telefonos (
	id_telefono                     numeric(18,0)                    identity  ,
	id_persona                      numeric(18,0)                        null  ,
	id_ong                          numeric(18,0)                        null  ,
	id_colegio                      numeric(18,0)                        null  ,
	d_telefono                      varchar(40)                      not null  ,
	c_tipo_telefono                 numeric(18,0)                        null  ,
	observaciones                   varchar(250)                         null  ,
	c_usua_alta                     numeric(18,0)                    not null  ,
	f_alta                          smalldatetime                   DEFAULT  getDate() 
      null  ,
	c_usua_actuac                   numeric(18,0)                        null  ,
	f_actuac                        smalldatetime                        null  ,
 PRIMARY KEY CLUSTERED ( id_telefono )  on 'default' 
)
lock allpages
with dml_logging = full
, lob_compression = 
 on 'default'
go 

Grant Select on dbo.sagt_telefonos to Usr_trp_SABED 
go
Grant Select on dbo.sagt_telefonos to grp_cons_bbvaprod02_sabed 
go

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Table 'SABED.dbo.sapt_param_conversiones'
-----------------------------------------------------------------------------
print '<<<<< CREATING Table - "SABED.dbo.sapt_param_conversiones" >>>>>'
go

setuser 'dbo'
go 

create table sapt_param_conversiones (
	id_conv                         numeric(18,0)                    identity  ,
	c_sistema_externo               varchar(40)                      not null  ,
	id_parametro                    numeric(18,0)                    not null  ,
	c_usua_alta                     numeric(18,0)                    not null  ,
	f_alta                          smalldatetime                   DEFAULT  getDate() 
      null  ,
	c_usua_actuac                   numeric(18,0)                        null  ,
	f_actuac                        smalldatetime                        null  ,
 PRIMARY KEY CLUSTERED ( id_conv )  on 'default' 
)
lock allpages
with dml_logging = full
, lob_compression = 
 on 'default'
go 

Grant Select on dbo.sapt_param_conversiones to Usr_trp_SABED 
go
Grant Select on dbo.sapt_param_conversiones to grp_cons_bbvaprod02_sabed 
go

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Table 'SABED.dbo.sapt_param_grupos'
-----------------------------------------------------------------------------
print '<<<<< CREATING Table - "SABED.dbo.sapt_param_grupos" >>>>>'
go

setuser 'dbo'
go 

create table sapt_param_grupos (
	id_grupo                        int                              identity  ,
	id_tabla_param                  int                              not null  ,
	d_valor                         varchar(150)                     not null  ,
	c_cuotas                        numeric(18,0)                    not null  ,
	u_alta                          numeric(18,0)                    not null  ,
	f_alta                          datetime                         not null  ,
	u_modif                         numeric(18,0)                        null  ,
	f_modif                         datetime                             null  ,
	u_baja                          numeric(18,0)                        null  ,
	f_baja                          int                                  null  ,
 PRIMARY KEY CLUSTERED ( id_grupo )  on 'default' 
)
lock allpages
with dml_logging = full
, lob_compression = 
 on 'default'
go 

Grant Select on dbo.sapt_param_grupos to Usr_trp_SABED 
go
Grant Select on dbo.sapt_param_grupos to grp_cons_bbvaprod02_sabed 
go

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Table 'SABED.dbo.sapt_param_tablas'
-----------------------------------------------------------------------------
print '<<<<< CREATING Table - "SABED.dbo.sapt_param_tablas" >>>>>'
go

setuser 'dbo'
go 

create table sapt_param_tablas (
	id_tabla                        numeric(18,0)                    identity  ,
	d_valor                         varchar(150)                     not null  ,
	c_usua_alta                     numeric(18,0)                    not null  ,
	f_alta                          smalldatetime                   DEFAULT  getDate() 
      null  ,
	c_usua_actuac                   numeric(18,0)                        null  ,
	f_actuac                        smalldatetime                        null  ,
 PRIMARY KEY CLUSTERED ( id_tabla )  on 'default' 
)
lock allpages
with dml_logging = full
, lob_compression = 
 on 'default'
go 

Grant Select on dbo.sapt_param_tablas to Usr_trp_SABED 
go
Grant Select on dbo.sapt_param_tablas to grp_cons_bbvaprod02_sabed 
go

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Table 'SABED.dbo.sapt_parametros'
-----------------------------------------------------------------------------
print '<<<<< CREATING Table - "SABED.dbo.sapt_parametros" >>>>>'
go

setuser 'dbo'
go 

create table sapt_parametros (
	id_parametro                    numeric(18,0)                    identity  ,
	id_tabla                        numeric(18,0)                    not null  ,
	d_valor                         varchar(150)                     not null  ,
	c_usua_alta                     numeric(18,0)                    not null  ,
	f_alta                          smalldatetime                   DEFAULT  getDate() 
      null  ,
	c_usua_actuac                   numeric(18,0)                        null  ,
	f_actuac                        smalldatetime                        null  ,
 PRIMARY KEY CLUSTERED ( id_parametro )  on 'default',
		CONSTRAINT sapt_para_uk UNIQUE NONCLUSTERED ( id_tabla, d_valor )  on 'default' 
)
lock allpages
with dml_logging = full
, lob_compression = 
 on 'default'
go 

Grant Select on dbo.sapt_parametros to Usr_trp_SABED 
go
Grant Select on dbo.sapt_parametros to grp_cons_bbvaprod02_sabed 
go

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Table 'SABED.dbo.sart_lotes_det_pago'
-----------------------------------------------------------------------------
print '<<<<< CREATING Table - "SABED.dbo.sart_lotes_det_pago" >>>>>'
go

setuser 'dbo'
go 

create table sart_lotes_det_pago (
	id_lote_det_pago                numeric(18,0)                    identity  ,
	id_lote_pago                    numeric(18,0)                    not null  ,
	id_lote_det_recarga             numeric(18,0)                    not null  ,
	d_fe_operacion                  varchar(10)                          null  ,
	d_tip_movi                      varchar(2)                           null  ,
	d_nro_clien                     varchar(8)                           null  ,
	d_suc_ctadeb                    varchar(4)                           null  ,
	d_tipo_cta_mon                  varchar(3)                           null  ,
	d_nro_cta                       varchar(7)                           null  ,
	d_cod_admin                     varchar(3)                           null  ,
	d_nro_cta_cred                  varchar(10)                          null  ,
	d_nro_tarjeta                   varchar(16)                          null  ,
	d_imp_recarga                   varchar(11)                          null  ,
	d_imp_comision                  varchar(11)                          null  ,
	d_fe_recarga                    varchar(10)                          null  ,
	d_cod_recarga                   varchar(1)                           null  ,
	d_ind_extr_efect                varchar(1)                           null  ,
	c_usua_alta                     numeric(18,0)                    not null  ,
	f_alta                          datetime                        DEFAULT  getDate() 
      null  ,
	c_usua_actuac                   numeric(18,0)                        null  ,
	f_actuac                        datetime                             null  ,
 PRIMARY KEY CLUSTERED ( id_lote_det_pago )  on 'default' 
)
lock allpages
with dml_logging = full
, lob_compression = 
 on 'default'
go 

Grant Select on dbo.sart_lotes_det_pago to Usr_trp_SABED 
go
Grant Select on dbo.sart_lotes_det_pago to grp_cons_bbvaprod02_sabed 
go

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Table 'SABED.dbo.sart_lotes_det_recarga'
-----------------------------------------------------------------------------
print '<<<<< CREATING Table - "SABED.dbo.sart_lotes_det_recarga" >>>>>'
go

setuser 'dbo'
go 

create table sart_lotes_det_recarga (
	id_lote_det_recarga             numeric(18,0)                    identity  ,
	id_lote_recarga                 numeric(18,0)                    not null  ,
	id_alumno                       numeric(18,0)                        null  ,
	id_alu_tar                      numeric(18,0)                        null  ,
	e_alumno                        varchar(4)                       not null  ,
	x_observacion                   varchar(250)                         null  ,
	q_becas_a_recargar              int                                  null  ,
	c_usua_alta                     numeric(18,0)                    not null  ,
	f_alta                          datetime                        DEFAULT  getdate() 
      null  ,
	c_usua_actuac                   numeric(18,0)                        null  ,
	f_actuac                        datetime                             null  ,
 PRIMARY KEY CLUSTERED ( id_lote_det_recarga )  on 'default',
CONSTRAINT sart_ldr_check_c_est_a CHECK  (e_alumno in ('S','N')))
lock allpages
with dml_logging = full
, lob_compression = 
 on 'default'
go 

Grant Select on dbo.sart_lotes_det_recarga to Usr_trp_SABED 
go
Grant Select on dbo.sart_lotes_det_recarga to grp_cons_bbvaprod02_sabed 
go

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Table 'SABED.dbo.sart_lotes_pago'
-----------------------------------------------------------------------------
print '<<<<< CREATING Table - "SABED.dbo.sart_lotes_pago" >>>>>'
go

setuser 'dbo'
go 

create table sart_lotes_pago (
	id_lote_pago                    numeric(18,0)                    identity  ,
	f_recarga                       datetime                         not null  ,
	e_lote_pago                     varchar(20)                      not null  ,
	c_usua_alta                     numeric(18,0)                    not null  ,
	f_alta                          datetime                        DEFAULT  getDate() 
      null  ,
	c_usua_actuac                   numeric(18,0)                        null  ,
	f_actuac                        datetime                             null  ,
 PRIMARY KEY CLUSTERED ( id_lote_pago )  on 'default',
CONSTRAINT sart_lpag_check_e_lote_pago CHECK  (e_lote_pago in ('PENDIENTE','GENERADO','RECHAZADO')))
lock allpages
with dml_logging = full
, lob_compression = 
 on 'default'
go 

Grant Select on dbo.sart_lotes_pago to Usr_trp_SABED 
go
Grant Select on dbo.sart_lotes_pago to grp_cons_bbvaprod02_sabed 
go

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Table 'SABED.dbo.sart_lotes_recarga'
-----------------------------------------------------------------------------
print '<<<<< CREATING Table - "SABED.dbo.sart_lotes_recarga" >>>>>'
go

setuser 'dbo'
go 

create table sart_lotes_recarga (
	id_lote_recarga                 numeric(18,0)                    identity  ,
	id_tutor                        numeric(18,0)                        null  ,
	id_periodo_recarga              numeric(18,0)                    not null  ,
	c_estado_lote                   varchar(15)                      not null  ,
	id_coordinador                  numeric(18,0)                        null  ,
	f_oper_coordinador              datetime                             null  ,
	id_adm_equipo_becas             numeric(18,0)                        null  ,
	f_oper_eq_becas                 datetime                             null  ,
	id_sup_equipo_becas             numeric(18,0)                        null  ,
	f_oper_sup_eq_becas             datetime                             null  ,
	f_oper_anulacion                datetime                             null  ,
	c_usua_alta                     numeric(18,0)                    not null  ,
	f_alta                          datetime                        DEFAULT  getdate() 
      null  ,
	c_usua_actuac                   numeric(18,0)                        null  ,
	f_actuac                        datetime                             null  ,
 PRIMARY KEY CLUSTERED ( id_lote_recarga )  on 'default',
CONSTRAINT sart_lrec_check_c_est_l CHECK  (c_estado_lote in ('EN_REVISION','CONFIRMADO','A_PAGAR','ENVIADO','ANULADO')))
lock allpages
with dml_logging = full
, lob_compression = 
 on 'default'
go 

Grant Select on dbo.sart_lotes_recarga to Usr_trp_SABED 
go
Grant Select on dbo.sart_lotes_recarga to grp_cons_bbvaprod02_sabed 
go

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Table 'SABED.dbo.sast_accesos'
-----------------------------------------------------------------------------
print '<<<<< CREATING Table - "SABED.dbo.sast_accesos" >>>>>'
go

setuser 'dbo'
go 

create table sast_accesos (
	id_acceso                       varchar(15)                      not null  ,
	d_acceso                        varchar(40)                      not null  ,
	id_menu                         numeric(18,0)                        null  ,
 PRIMARY KEY CLUSTERED ( id_acceso )  on 'default' 
)
lock allpages
with dml_logging = full
, lob_compression = 
 on 'default'
go 

Grant Select on dbo.sast_accesos to Usr_trp_SABED 
go
Grant Select on dbo.sast_accesos to grp_cons_bbvaprod02_sabed 
go

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Table 'SABED.dbo.sast_accesos_por_perfiles'
-----------------------------------------------------------------------------
print '<<<<< CREATING Table - "SABED.dbo.sast_accesos_por_perfiles" >>>>>'
go

setuser 'dbo'
go 

create table sast_accesos_por_perfiles (
	id_acceso                       varchar(15)                      not null  ,
	id_perfil                       numeric(18,0)                    not null  ,
	f_alta                          smalldatetime                   DEFAULT  getDate() 
      null  ,
 PRIMARY KEY CLUSTERED ( id_acceso, id_perfil )  on 'default' 
)
lock allpages
with dml_logging = full
, lob_compression = 
 on 'default'
go 

Grant Select on dbo.sast_accesos_por_perfiles to Usr_trp_SABED 
go
Grant Select on dbo.sast_accesos_por_perfiles to grp_cons_bbvaprod02_sabed 
go

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Table 'SABED.dbo.sast_login_usuarios'
-----------------------------------------------------------------------------
print '<<<<< CREATING Table - "SABED.dbo.sast_login_usuarios" >>>>>'
go

setuser 'dbo'
go 

create table sast_login_usuarios (
	usu_d_user                      varchar(40)                      not null  ,
	usu_habilitado                  varchar(1)                           null  ,
	usu_estado                      varchar(1)                           null  ,
	usu_ult_acceso                  varchar(12)                          null  ,
	usu_hora_acceso                 varchar(8)                           null  ,
	usu_clave1                      varchar(50)                          null  ,
	usu_clave2                      varchar(50)                          null  ,
	usu_clave3                      varchar(50)                          null  ,
	usu_clave4                      varchar(50)                          null  ,
	usu_int_fallidos                numeric(4,0)                     not null  ,
	usu_clave                       varchar(50)                          null   
)
lock allpages
with dml_logging = full
, lob_compression = 
 on 'default'
go 

Grant Select on dbo.sast_login_usuarios to Usr_trp_SABED 
go
Grant Select on dbo.sast_login_usuarios to grp_cons_bbvaprod02_sabed 
go

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Table 'SABED.dbo.sast_menu'
-----------------------------------------------------------------------------
print '<<<<< CREATING Table - "SABED.dbo.sast_menu" >>>>>'
go

setuser 'dbo'
go 

create table sast_menu (
	id_menu                         numeric(18,0)                    identity  ,
	d_menu                          varchar(40)                      not null  ,
	x_url_menu                      varchar(250)                     not null  ,
	id_padre                        numeric(18,0)                        null  ,
	n_orden                         numeric(18,0)                        null  ,
	c_usua_alta                     numeric(18,0)                    not null  ,
	f_alta                          smalldatetime                   DEFAULT  getDate() 
      null  ,
	c_usua_actuac                   numeric(18,0)                        null  ,
	f_actuac                        smalldatetime                        null  ,
	n_nivel                         numeric(1,0)                     not null  ,
 PRIMARY KEY CLUSTERED ( id_menu )  on 'default' 
)
lock allpages
with dml_logging = full
, lob_compression = 
 on 'default'
go 

Grant Select on dbo.sast_menu to Usr_trp_SABED 
go
Grant Select on dbo.sast_menu to grp_cons_bbvaprod02_sabed 
go

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Table 'SABED.dbo.sast_perfiles'
-----------------------------------------------------------------------------
print '<<<<< CREATING Table - "SABED.dbo.sast_perfiles" >>>>>'
go

setuser 'dbo'
go 

create table sast_perfiles (
	id_perfil                       numeric(18,0)                    identity  ,
	d_perfil                        varchar(40)                      not null  ,
	n_nivel_mensaje                 int                              not null  ,
	c_usua_alta                     numeric(18,0)                    not null  ,
	f_alta                          smalldatetime                   DEFAULT  getDate() 
      null  ,
	c_usua_actuac                   numeric(18,0)                        null  ,
	f_actuac                        smalldatetime                        null  ,
 PRIMARY KEY CLUSTERED ( id_perfil )  on 'default' 
)
lock allpages
with dml_logging = full
, lob_compression = 
 on 'default'
go 

Grant Select on dbo.sast_perfiles to Usr_trp_SABED 
go
Grant Select on dbo.sast_perfiles to grp_cons_bbvaprod02_sabed 
go

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Table 'SABED.dbo.sast_usuarios'
-----------------------------------------------------------------------------
print '<<<<< CREATING Table - "SABED.dbo.sast_usuarios" >>>>>'
go

setuser 'dbo'
go 

create table sast_usuarios (
	id_usuario                      numeric(18,0)                    identity  ,
	id_persona                      numeric(18,0)                        null  ,
	d_user                          varchar(40)                      not null  ,
	e_usuario                       char(1)                          not null  ,
	c_usua_alta                     numeric(18,0)                    not null  ,
	f_alta                          smalldatetime                   DEFAULT  getDate() 
      null  ,
	c_usua_actuac                   numeric(18,0)                        null  ,
	f_actuac                        smalldatetime                        null  ,
 PRIMARY KEY CLUSTERED ( id_usuario )  on 'default',
		CONSTRAINT sast_usu_uk_d_user UNIQUE NONCLUSTERED ( d_user )  on 'default',
CONSTRAINT sast_usua_check CHECK  (e_usuario in ('A','B','D')))
lock allpages
with dml_logging = full
, lob_compression = 
 on 'default'
go 

Grant Select on dbo.sast_usuarios to Usr_trp_SABED 
go
Grant Select on dbo.sast_usuarios to grp_cons_bbvaprod02_sabed 
go

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Table 'SABED.dbo.sast_usuarios_perfiles'
-----------------------------------------------------------------------------
print '<<<<< CREATING Table - "SABED.dbo.sast_usuarios_perfiles" >>>>>'
go

setuser 'dbo'
go 

create table sast_usuarios_perfiles (
	id_perfil                       numeric(18,0)                    not null  ,
	id_usuario                      numeric(18,0)                    not null  ,
	e_usu_perfil                    varchar(1)                       not null  ,
	c_usua_alta                     numeric(18,0)                    not null  ,
	f_alta                          smalldatetime                   DEFAULT  getDate() 
      null  ,
	c_usua_actuac                   numeric(18,0)                        null  ,
	f_actuac                        smalldatetime                        null  ,
 PRIMARY KEY CLUSTERED ( id_perfil, id_usuario )  on 'default' 
)
lock allpages
with dml_logging = full
, lob_compression = 
 on 'default'
go 

Grant Select on dbo.sast_usuarios_perfiles to Usr_trp_SABED 
go
Grant Select on dbo.sast_usuarios_perfiles to grp_cons_bbvaprod02_sabed 
go

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Table 'SABED.dbo.saut_auditoria'
-----------------------------------------------------------------------------
print '<<<<< CREATING Table - "SABED.dbo.saut_auditoria" >>>>>'
go

setuser 'dbo'
go 

create table saut_auditoria (
	id_auditoria                    numeric(18,0)                    identity  ,
	id_alumno                       numeric(18,0)                    not null  ,
	f_altaudit                      datetime                         not null  ,
	x_observ                        varchar(250)                         null  ,
	e_auditoria                     numeric(18,0)                        null  ,
	c_usua_alta                     numeric(18,0)                    not null  ,
	f_alta                          smalldatetime                   DEFAULT  getDate() 
      null  ,
	c_usua_actuac                   numeric(18,0)                        null  ,
	f_actuac                        smalldatetime                        null  ,
 PRIMARY KEY CLUSTERED ( id_auditoria )  on 'default' 
)
lock allpages
with dml_logging = full
, lob_compression = 
 on 'default'
go 

Grant Select on dbo.saut_auditoria to Usr_trp_SABED 
go
Grant Select on dbo.saut_auditoria to grp_cons_bbvaprod02_sabed 
go

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Table 'SABED.dbo.temp_lotes_det_recarga'
-----------------------------------------------------------------------------
print '<<<<< CREATING Table - "SABED.dbo.temp_lotes_det_recarga" >>>>>'
go

setuser 'dbo'
go 

create table temp_lotes_det_recarga (
	id_lote_recarga                 numeric(18,0)                    not null  ,
	id_alumno                       numeric(18,0)                        null  ,
	id_alu_tar                      numeric(18,0)                        null  ,
	e_alumno                        varchar(4)                       not null  ,
	x_observacion                   varchar(250)                         null  ,
	q_becas_a_recargar              int                                  null  ,
	c_usua_alta                     numeric(18,0)                    not null  ,
	f_alta                          datetime                        DEFAULT        getdate() 
      
  
  
  
  not null  ,
	id_periodo                      numeric(18,0)                        null  ,
	id_tutor                        numeric(18,0)                        null   
)
lock allpages
with dml_logging = full
 on 'default'
go 

Grant Select on dbo.temp_lotes_det_recarga to GrpTrpSabed 
go

setuser
go 

-----------------------------------------------------------------------------
-- DDL for View 'SABED.dbo.saav_alu_tut_ong'
-----------------------------------------------------------------------------

print '<<<<< CREATING View - "SABED.dbo.saav_alu_tut_ong" >>>>>'
go 

setuser 'dbo'
go 


create view saav_alu_tut_ong as 
select ALU.id_alumno, 
       ALU.id_persona id_persona_alu,
       ALU.e_alumno,
       ALU.e_registro e_registro_alu,
       ALU.id_tipo_beca, 
       ALU.f_actuac, 
       ALU.f_alta, 
       ALU.f_suspension, 
       ALU.f_baja, 
       ALU.f_resul_prop, 
       PER.d_nombre d_nombre_alu, 
       PER.d_apellido d_apellido_alu, 
       PER.n_documento n_documento_alu, 
       PER.c_documento c_documento_alu,
       PER.f_nacimiento, 
       PER.e_registro e_registro_per, 
       TUT.id_tutor,
       TUT.id_persona id_persona_tut,
       TUT.e_registro e_registro_tut, 
       ATUT.id_perfil id_perfil_tutor, 
       ONG.id_ong,
       ONG.d_nombre_ong,
       ONG.e_registro e_registro_ong,
       ONG.d_suc_cuenta,
       ONG.d_tipo_cuenta,
       ONG.d_nro_cuenta,
       ONG.c_nro_cliente
  from saat_alumnos ALU, 
       sagt_alumnos_tutores ATUT, 
       saft_tutores TUT, 
       saft_ongs ONG, 
       sagt_personas PER 
 where ATUT.id_alumno = ALU.id_alumno 
   and ATUT.id_tutor = TUT.id_tutor 
   and TUT.id_ong = ONG.id_ong 
   and PER.id_persona = ALU.id_persona

 
go 

Grant Select on dbo.saav_alu_tut_ong to grp_cons_bbvaprod02_sabed 
go
setuser
go 

-----------------------------------------------------------------------------
-- DDL for View 'SABED.dbo.sasv_usuarios_fund'
-----------------------------------------------------------------------------

print '<<<<< CREATING View - "SABED.dbo.sasv_usuarios_fund" >>>>>'
go 

setuser 'dbo'
go 


create view sasv_usuarios_fund as
Select pong.id_persona,
       usu.id_usuario   
  from saft_personas_ong pong, 
       sast_usuarios usu, 
       saft_ongs o
 where o.m_fundacion='S'
  and pong.id_ong = o.id_ong
  and usu.id_persona = pong.id_persona
  and pong.e_registro = 'D'
  and usu.e_usuario = 'D'
  and o.e_registro = 'D'
 
go 

Grant Select on dbo.sasv_usuarios_fund to grp_cons_bbvaprod02_sabed 
go
setuser
go 

-----------------------------------------------------------------------------
-- DDL for View 'SABED.dbo.sasv_usuarios_ongs'
-----------------------------------------------------------------------------

print '<<<<< CREATING View - "SABED.dbo.sasv_usuarios_ongs" >>>>>'
go 

setuser 'dbo'
go 


create view sasv_usuarios_ongs as
	select pong.id_persona,
	       ong.id_ong,
	       usu.id_usuario
   from saft_personas_ong pong,
	      sast_usuarios usu,
	      saft_ongs ong
	where pong.id_ong  = ong.id_ong
	  and usu.id_persona = pong.id_persona
    and pong.e_registro = 'D'
    and usu.e_usuario = 'D'
    and ong.e_registro = 'D'
 
go 

Grant Select on dbo.sasv_usuarios_ongs to grp_cons_bbvaprod02_sabed 
go
setuser
go 

-----------------------------------------------------------------------------
-- DDL for View 'SABED.dbo.sasv_usuarios_tut'
-----------------------------------------------------------------------------

print '<<<<< CREATING View - "SABED.dbo.sasv_usuarios_tut" >>>>>'
go 

setuser 'dbo'
go 


create view sasv_usuarios_tut as
	select usu.id_usuario,
         usu.id_persona,
         t.id_tutor
   from sast_usuarios usu,
        saft_tutores t
	where usu.id_persona = t.id_persona
    and usu.e_usuario = 'D'
    and t.e_registro = 'D'
 
go 

Grant Select on dbo.sasv_usuarios_tut to grp_cons_bbvaprod02_sabed 
go
setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_GetUsuario'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_GetUsuario" >>>>>'
go 

setuser 'dbo'
go 

create procedure sp_GetUsuario ( 
	@pi_usu_d_user      varchar (40),   
	@po_c_error         typ_c_error output,    
	@po_d_error         typ_d_error output) 
as 
-------------------------------------------------------------------    
--Objetivo: Obtener los datos de Login de un usuario   
-------------------------------------------------------------------     
begin    
  set @po_c_error = 0    
  set @po_d_error = null    
     
  If @pi_usu_d_user is null    
    begin    
      set @po_c_error = 3     
 
      set @po_d_error = 'No se inform? el usuario'    
      return          
  end    
     
  select usu_d_user,   
         usu_habilitado,   
         usu_estado,   
         usu_ult_acceso,   
         usu_hora_acceso,   
         usu_clave1,   
         usu_clave2,   
         usu_clave3,   
         usu_clave4,   
         usu_int_fallidos,   
         usu_clave   
    from sast_login_usuarios    
   where usu_d_user=@pi_usu_d_user   
     
  set @po_c_error = @@error   
  if (@po_c_error  <> 0)    
    begin      
    
    set @po_d_error = 'Error al consultar los datos del login'    
    end    
  end 

go 

Grant Execute on dbo.sp_GetUsuario to GrpTrpSabed 
go

sp_procxmode 'sp_GetUsuario', anymode
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_GuardarUsuario'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_GuardarUsuario" >>>>>'
go 

setuser 'dbo'
go 

create procedure sp_GuardarUsuario ( 
	@pi_usu_d_user	     varchar (40), 
	@pi_usu_habilitado   varchar (1), 
	@pi_usu_estado	     varchar (1), 
	@pi_usu_clave1	     varchar (50), 
	@pi_usu_clave2	     varchar (50), 
	@pi_usu_clave3	     varchar (50), 
	@pi_usu_clave4	     varchar (50), 
	@pi_usu_int_fallidos numeric(4), -- no se usa, pero lo dejo porque en el original estaba 
	@pi_usu_clave	     varchar (50), 
	@po_c_error          typ_c_error output,  
	@po_d_error          typ_d_error output) 
as  
-----------------------------------  
--Objetivo: Actualiza los datos del usuario 
----------------------------------- 
begin  
   
  set @po_c_error = 0  
  set @po_d_error = null  
   
  If @pi_usu_d_user is null  
    begin  
      set @po_c_error = 3 
      set @po_d_error = 'No se inform? el usuario'  
      return        
  end  
   
  /* si lo encuentra actualiza sino da de alta */ 
  if exists(select *  
              from sast_login_usuarios  
             where usu_d_user =@pi_usu_d_user) 
 
    begin   
      update sast_login_usuarios  
         set usu_habilitado	 = @pi_usu_habilitado,			 
	     usu_estado	         = @pi_usu_estado,		 
	     usu_ult_acceso	 	 = Convert (char(8), GetDate(), 112),  
	     usu_hora_acceso	 = Convert (char(8), GetDate(), 108),  /* Si la clave viene en blanco deja la que tenia*/ 
	     usu_clave           = CASE  WHEN  @pi_usu_clave ='' THEN (select usu_clave  
	                                                                 from sast_login_usuarios  
	                                                                where usu_d_user =@pi_usu_d_user) ELSE  @pi_usu_clave END 
       where usu_d_user =@pi_usu_d_user 
 
      set @po_c_error = @@error 
      if (@po_c_error  <> 0)  
        begin    
          set @po_d_error = 'Error al actualizar los datos del login'  
          return 
        end  
    end 
   
  else 
   
    begin 
	insert into sast_login_usuarios 
	  (usu_d_user, 
	   usu_habilitado,	 
	   usu_estado, 
	   usu_ult_acceso,	 
	   usu_hora_acceso,	 
	   usu_clave1,  
	   usu_clave2,  
	   usu_clave3,  
	   usu_clave4, 
	   usu_int_fallidos, 
	   usu_clave) 
	values 
	  (@pi_usu_d_user, 
	   @pi_usu_habilitado,	 
	   @pi_usu_estado, 
	   Convert (char(8), GetDate(), 112),  
	   Convert (char(8), GetDate(), 108) ,	 
	   '',  
	   '',  
	   '',  
	   '', 
	   0 , 
	   @pi_usu_clave) 
 
    set @po_c_error = @@error 
    if (@po_c_error  <> 0)  
      begin    
        set @po_d_error = 'Error al actualizar los datos del login'  
        return 
    end  
     
  end 
end 

go 

Grant Execute on dbo.sp_GuardarUsuario to GrpTrpSabed 
go

sp_procxmode 'sp_GuardarUsuario', anymode
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_UpdClaveUsuario'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_UpdClaveUsuario" >>>>>'
go 

setuser 'dbo'
go 

create procedure sp_UpdClaveUsuario ( 
	@pi_usu_d_user	     varchar (40),   
	@pi_usu_clave1	     varchar (50),   
	@pi_usu_clave2	     varchar (50),   
	@pi_usu_clave3	     varchar (50),   
	@pi_usu_clave4	     varchar (50),   
	@pi_usu_clave	     varchar (50),   
	@po_c_error     typ_c_error output,    
	@po_d_error     typ_d_error output) 
as 
-----------------------------------    
--Objetivo: Actualiza los datos del usuario   
-----------------------------------   
    
    
begin    
   
     
  set @po_c_error = 0    
  set @po_d_error = null    
     
  If (@pi_usu_d_user is null)  
    begin    
      set @po_c_error = 3   
      set @po_d_error = 'No se inform? el usuario'    
      return          
  end    
     
  update sast_login_usuarios    
     set usu_clave1=@pi_usu_clave1,   
         usu_clave2=@pi_usu_clave2,   
         usu_clave3=@pi_usu_clave3,   
         usu_clave4=@pi_usu_clave4,   
         usu_int_fallidos=0,   
         usu_estado='N',   
         usu_clave=@pi_usu_clave   
   where usu_d_user =@pi_usu_d_user   
   
  set @po_c_error = @@error   
  if (@po_c_error  <> 0)    
    begin      
      set @po_d_error = 'Error al consultar los datos del login'    
	  return  
  end    
end 

go 

Grant Execute on dbo.sp_UpdClaveUsuario to GrpTrpSabed 
go

sp_procxmode 'sp_UpdClaveUsuario', anymode
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_UpdUsuario'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_UpdUsuario" >>>>>'
go 

setuser 'dbo'
go 

create procedure sp_UpdUsuario (     
	@pi_usu_d_user	     varchar (40),   
	@pi_usu_habilitado   varchar (1),   
	@pi_usu_estado	     varchar (1),   
	@pi_usu_ult_acceso   varchar (12),   
	@pi_usu_hora_acceso  varchar (8),   
	@pi_usu_clave1	     varchar (50),   
	@pi_usu_clave2	     varchar (50),   
	@pi_usu_clave3	     varchar (50),   
	@pi_usu_clave4	     varchar (50),   
	@pi_usu_int_fallidos numeric(4),   
	@pi_usu_clave	     varchar (50),   
	@po_c_error          typ_c_error output,    
	@po_d_error          typ_d_error output)   
as    
-----------------------------------    
--Objetivo: Actualiza los datos del usuario   
-----------------------------------   
    
    
begin    
   
     
  set @po_c_error = 0    
  set @po_d_error = null    
     
  If (@pi_usu_d_user is null)  
    begin    
      set @po_c_error = 3  
      set @po_d_error = 'No se inform? el usuario'    
      return          
  end    
   
 update sast_login_usuarios    
    set usu_habilitado   = @pi_usu_habilitado,   
        usu_estado       = @pi_usu_estado,   
        usu_ult_acceso   = @pi_usu_ult_acceso,   
        usu_hora_acceso  = @pi_usu_hora_acceso,   
        usu_clave1       = @pi_usu_clave1,   
        usu_clave2       = @pi_usu_clave2,   
        usu_clave3       = @pi_usu_clave3,   
        usu_clave4       = @pi_usu_clave4,   
        usu_int_fallidos = @pi_usu_int_fallidos,   
        usu_clave        = @pi_usu_clave   
  where usu_d_user = @pi_usu_d_user   
    
   set @po_c_error = @@error   
  if (@po_c_error  <> 0)    
    begin      
      set @po_d_error = 'Error al consultar los datos del login'    
	  return  
    end    
end 

go 

Grant Execute on dbo.sp_UpdUsuario to GrpTrpSabed 
go

sp_procxmode 'sp_UpdUsuario', anymode
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_abm_noticia'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_abm_noticia" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_abm_noticia ( 
@pi_id_noticia         numeric(18,0), 
@pi_x_titulo           varchar(250), 
@pi_x_copete           varchar(1000), 
@pi_x_cuerpo_mensaje   varchar(16300), 
@pi_f_vigencia_desde   varchar(19), 
@pi_f_vigencia_hasta   varchar(19), 
@pi_f_baja             varchar(19), 
@pi_c_usua             numeric(18,0), 
@po_id_noticia         numeric(18,0) output, 
@po_c_error            typ_c_error output, 
@po_d_error            typ_d_error output 
) 
as 
-------------------------------------------  
------------------------ 
--Objetivo: ABM de Noticia 
------------------------------------------------------------------- 
begin 
  declare  
         @f_vigencia_hasta   smalldatetime, 
         @f_vigencia_desde   smalldatetime, 
         @f_baja             smalldatetime 
 
  -- analizo los parametros de entrada		  
  if (@pi_x_titulo is null) 
    begin 
      set @po_c_error = 3 
      set @po_d_error = 'No se recibio titulo' 
      return        
  end 
 
  if (@pi_x_copete is null) 
    begin 
      set @po_c_error = 2 
      set @po_d_error = 'No se recibio copete' 
      return        
  end 
 
  if (@pi_x_cuerpo_mensaje is null) 
    begin 
      set @po_c_error = 2 
      set @po_d_error = 'No se recibio cuerpo mensaje' 
      return        
  end 
 
  if (@pi_f_vigencia_desde is null) 
    begin 
      set @po_c_error = 3
      set @po_d_error = 'No se recibio fecha vigencia desde' 
      return        
  end 
 
  if (@pi_c_usua is null or @pi_c_usua = 0) 
    begin 
      set @po_c_error = 3 
      set @po_d_error = 'No se recibio usuario' 
      return        
  end 
 
  -- convierto a Date las fechas 
  begin 
    execute sp_convierte_char_en_fecha @pi_fecha_char     = @pi_f_vigencia_desde, 
                                       @po_fecha_datetime = @f_vigencia_desde output, 
                                       @po_c_error        = @po_c_error output, 
                                       @po_d_error        = @po_d_error output 
                                
    if (@po_c_error  <> 0) 
      begin 
		set @po_d_error = 'Error llamando a sp_convierte_char_en_fecha : ' + @po_d_error
        return        
    end   
  end   
   
  If @pi_f_vigencia_hasta is not null 
    begin 
      execute sp_convierte_char_en_fecha @pi_fecha_char     = @pi_f_vigencia_hasta, 
                                         @po_fecha_datetime = @f_vigencia_hasta output, 
                                         @po_c_error        = @po_c_error output, 
                                         @po_d_error        = @po_d_error output 
                                
      if (@po_c_error  <> 0) 
        begin 
		 
          return        
      end   
       
      -- Controlo que las fechas informadsa sean v?lidas 
      If @f_vigencia_hasta<@f_vigencia_desde 
        begin 
          set @po_c_error = 2 
          set @po_d_error = 'La fecha desde es mayor a la fecha hasta' 
          return        
      end 
       
  end 
 
  if @pi_f_baja is not null 
    begin 
      execute sp_convierte_char_en_fecha @pi_fecha_char     = @pi_f_baja, 
                                         @po_fecha_datetime = @f_baja output, 
                                         @po_c_error        = @po_c_error output, 
                                         @po_d_error        = @po_d_error output 
                                
      if (@po_c_error  <> 0) 
        begin 
		  set @po_d_error = 'Error llamando a sp_convierte_char_en_fecha : ' + @po_d_error		
          return        
      end   
  end 
 
  -- Como todo fue OK, veo si es un alta o una modificacion 
  set @po_c_error = 0 
  set @po_d_error = null 
 
  If (@pi_id_noticia is null or @pi_id_noticia = 0)  
    begin 
   
      insert into saft_noticias  (x_titulo, x_copete, x_cuerpo_mensaje, f_vigencia_desde, f_vigencia_hasta, f_baja, c_usua_alta)  
      values (@pi_x_titulo, @pi_x_copete, @pi_x_cuerpo_mensaje, @f_vigencia_desde, @f_vigencia_hasta, @f_baja, @pi_c_usua) 
   
      set @po_c_error = @@error  
      if (@po_c_error  <> 0) 
        begin     
          set @po_d_error = 'Error en asl intentar insertar la noticia' 
return
      end  
 
      set @po_id_noticia = @@identity 
       
    end 
   
  else -- es modificacion 
   
    begin 
     
      update saft_noticias   
         set x_titulo = @pi_x_titulo,  
             x_copete = @pi_x_copete,  
             x_cuerpo_mensaje = @pi_x_cuerpo_mensaje,  
             f_vigencia_desde = @f_vigencia_desde, 
             f_vigencia_hasta = @f_vigencia_hasta, 
             f_baja = @f_baja, 
             c_usua_actuac = @pi_c_usua, 
             f_actuac = getdate()  
       where id_noticia = @pi_id_noticia 
   
      set @po_c_error = @@error     
      if (@po_c_error  <> 0) 
        begin     
          set @po_d_error = 'Error al intentar modificar la noticia' 
return
      end  
       
      set @po_id_noticia = @pi_id_noticia 
       
  end -- de ver si es actualizacion o alta   
   
end -- sp_abm_noticia
 
go 

Grant Execute on dbo.sp_abm_noticia to GrpTrpSabed 
go

sp_procxmode 'sp_abm_noticia', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_abm_periodo_eval_acad'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_abm_periodo_eval_acad" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_abm_periodo_eval_acad (           



@pi_id_periodo	          numeric(18,0),       



@pi_f_inicio_periodo      varchar (19),       



@pi_f_fin_periodo	      varchar (19),       



@pi_d_periodo	          varchar (60),       



@pi_id_usuario   		  numeric(18,0),    



@s_ultimo                  int,   



@po_c_error      typ_c_error output,       



@po_d_error      typ_d_error output       



)       



as       



-------------------------------------------------------------------       



--Objetivo: Mantener los periodos de evaluacion academica       



--Par?metros de salida:        



--po_c_error y po_d_error       



-------------------------------------------------------------------       



       



begin       



  declare        



  @f_inicio_periodo      smalldatetime,       



  @f_fin_periodo	 	 smalldatetime,       



  @estado                varchar(1)   



       



  if (@pi_f_inicio_periodo is null)       



    begin       



      set @po_c_error = 3     



      set @po_d_error = 'No se recibi? fecha de inicio'       



      return       



  end           



       



  if (@pi_f_fin_periodo is null)       



    begin       



      set @po_c_error = 3       



      set @po_d_error = 'No se recibi? fecha de finalizacion'       



      return       



  end           



  if (@s_ultimo is null)       



    begin       



      set @po_c_error = 3       



      set @po_d_error = 'No se recibi? si es ?ltimo per?odo o no'       



      return       



  end      



  if (@pi_d_periodo  is null)       



    begin       



      set @po_c_error = 3       



      set @po_d_error = 'No se recibio la descripci?n del per?odo'        



      return              



  end       



         



  if (@pi_id_usuario is null or @pi_id_usuario = 0)       



    begin       



      set @po_c_error = 3       



      set @po_d_error = 'No se recibi? usuario'       



      return       



  end         



         



  set @po_c_error = 0       



  set @po_d_error = null       



       



  set @pi_f_inicio_periodo = @pi_f_inicio_periodo + 'T00:00' 



  set @pi_f_fin_periodo    = @pi_f_fin_periodo    + 'T23:59' 



 



  set @f_inicio_periodo = convert(datetime, @pi_f_inicio_periodo) 



  set @f_fin_periodo    = convert(datetime, @pi_f_fin_periodo) 



       



  If @f_fin_periodo <  @f_inicio_periodo       



  begin       



     set @po_c_error = 2      



     set @po_d_error = 'La fecha desde es mayor a la hasta'       



     return       



  end         



     



  -- Evaluo que el periodo no sea interanual     



  If datepart(yy,@f_fin_periodo) <> datepart(yy,@f_inicio_periodo)       



  begin       



     set @po_c_error = 2       



     set @po_d_error = 'El periodo no debe incluir a?os diferentes'       



     return       



  end       







   -- Evaluo si no esta superpuesto con otro periodo ya insetado       



   if exists (select 1        



                     from sact_periodos_eval_acad per       



                   where ((per.f_inicio_periodo <= @f_fin_periodo and per.f_fin_periodo >= @f_fin_periodo)       



                         or (per.f_inicio_periodo <= @f_inicio_periodo and per.f_fin_periodo >= @f_inicio_periodo))       



                  and (id_periodo <> @pi_id_periodo or isnull(@pi_id_periodo,0)=0)    



              )                



   begin                   



     set @po_c_error = 2        



     set @po_d_error = 'El per?odo informado se superpone con uno existente'        



     return        



   end       



   



  -- vemos si es modificacion o alta       



  If (@pi_id_periodo is null or @pi_id_periodo=0)    



    begin       



       



      -- Insertamos el registro       



      insert into sact_periodos_eval_acad  (f_inicio_periodo,f_fin_periodo,d_periodo,c_usua_alta,s_ultimo)        



      values (@f_inicio_periodo,@f_fin_periodo,@pi_d_periodo,@pi_id_usuario,@s_ultimo)       



       



      set @po_c_error = @@error           



      if (@po_c_error  <> 0)       



      begin           



        set @po_d_error = 'Error al insertar el periodo'           



        return       



      end       



       



    end        



       



  else       



       



    begin       



       



      --     



      -- Verificamos que el estado del periodo se pueda modificar     



      execute sp_est_periodo_eval_acad     



                   @pi_id_periodo = @pi_id_periodo,      



                   @po_estado     = @estado   output,      



                   @po_c_error    = @po_c_error output,      



                   @po_d_error    = @po_d_error output        



      if (@po_c_error  <> 0)      



      begin  



		set @po_d_error = 'Error llamando a sp_est_periodo_eval_acad : ' + @po_d_error 



        return          



      end     



     



      If @estado <> 'F'    



      begin     



        set @po_c_error = 2     



        set @po_d_error = 'No se puede utilizar el per?odo de evaluaci?n informado'     



        return     



      end         



       



      -- actualizamos el resgistro       



      update sact_periodos_eval_acad        



         set f_inicio_periodo=@f_inicio_periodo,        



             f_fin_periodo=@f_fin_periodo,        



             d_periodo=@pi_d_periodo,       



             c_usua_actuac=@pi_id_usuario,        



             f_actuac=getdate(),



             s_ultimo=@s_ultimo        



       where id_periodo=@pi_id_periodo       



       



      set @po_c_error = @@error           



      if (@po_c_error  <> 0)       



      begin           



        set @po_d_error = 'Error al actualizar el periodo'            



        return       



      end         



        



    end        



       



end
 
go 

Grant Execute on dbo.sp_abm_periodo_eval_acad to GrpTrpSabed 
go

sp_procxmode 'sp_abm_periodo_eval_acad', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_abm_periodo_recarga'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_abm_periodo_recarga" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_abm_periodo_recarga (      
@pi_id_periodo	        numeric(18,0),      
@pi_f_inicio_periodo    varchar (19),      
@pi_f_fin_periodo	varchar (19),      
@pi_d_periodo	        varchar (60),      
@pi_id_usuario          numeric(18,0),      
@po_c_error             typ_c_error output,      
@po_d_error             typ_d_error output      
)      
as      
-------------------------------------------------------------------      
--Objetivo: Mantener los periodos de recargas 
--Par?metros de salida:       
--po_c_error y po_d_error      
-------------------------------------------------------------------      
      
begin      
  declare       
  @f_inicio_periodo      smalldatetime,      
  @f_fin_periodo	 smalldatetime,      
  @estado                varchar(1)  
      
  if (@pi_f_inicio_periodo is null)      
    begin      
      set @po_c_error = 3     
      set @po_d_error = 'No se recibi? fecha de inicio'      
      return      
  end          
      
  if (@pi_f_fin_periodo is null)      
    begin      
      set @po_c_error = 3       
      set @po_d_error = 'No se recibi? fecha de finalizaci?n'      
      return      
  end          
      
  if (@pi_d_periodo  is null)      
    begin      
      set @po_c_error = 3      
      set @po_d_error = 'No se recibio la descripci?n del per?odo'       
      return             
  end      
        
  if (@pi_id_usuario is null or @pi_id_usuario = 0)      
    begin      
      set @po_c_error = 3
      set @po_d_error = 'No se recibi? usuario'      
      return      
  end        
        
  set @po_c_error = 0      
  set @po_d_error = null 
  
  set @pi_f_inicio_periodo = @pi_f_inicio_periodo + 'T00:00'
  set @pi_f_fin_periodo    = @pi_f_fin_periodo    + 'T23:59'

  set @f_inicio_periodo = convert(datetime, @pi_f_inicio_periodo)
  set @f_fin_periodo    = convert(datetime, @pi_f_fin_periodo)

  If @f_fin_periodo <  @f_inicio_periodo      
  begin      
     set @po_c_error =2     
     set @po_d_error = 'La fecha desde es mayor ? igual a la hasta'      
     return      
  end        
    
  -- Evaluo que el periodo no sea interanual    
  If datepart(yy,@f_fin_periodo) <> datepart(yy,@f_inicio_periodo)      
  begin      
     set @po_c_error = 2      
     set @po_d_error = 'El periodo no debe incluir a?os diferentes'      
     return      
  end      
  
   -- Evaluo si no esta superpuesto con otro periodo ya insertado      
   if exists (select 1       
                     from sact_periodos_recargas per      
                   where ((per.f_inicio_periodo <= @f_fin_periodo and per.f_fin_periodo >= @f_fin_periodo)      
                         or (per.f_inicio_periodo <= @f_inicio_periodo and per.f_fin_periodo >= @f_inicio_periodo))      
                  and (id_periodo_recarga <> @pi_id_periodo or isnull(@pi_id_periodo,0)=0)   
              )               
   begin                  
     set @po_c_error = 2       
     set @po_d_error = 'El per?odo informado se superpone con uno existente'       
     return       
   end      
  
  -- vemos si es modificacion o alta      
  If (@pi_id_periodo is null or @pi_id_periodo = 0)   
    begin      
      
      -- Insertamos el registro      
      insert into sact_periodos_recargas  (f_inicio_periodo,f_fin_periodo,d_periodo,c_usua_alta)       
      values (@f_inicio_periodo,@f_fin_periodo,@pi_d_periodo,@pi_id_usuario)      
      
      set @po_c_error = @@error          
      if (@po_c_error  <> 0)      
      begin          
        set @po_d_error = 'Error al insertar el periodo'         
        return      
      end      
      
    end       
      
  else      
      
    begin      
      
      --    
      -- Verificamos que el estado del periodo se pueda modificar    
      execute sp_est_periodo_recarga 
                   @pi_id_periodo = @pi_id_periodo,     
                   @po_estado     = @estado   output,     
                   @po_c_error    = @po_c_error output,     
                   @po_d_error    = @po_d_error output       
      if (@po_c_error  <> 0)     
      begin    
	    set @po_d_error = 'Error llamando a sp_est_periodo_recarga : ' + @po_d_error	
        return         
      end    
    
      If @estado <> 'F'   
      begin    
        set @po_c_error = 2    
        set @po_d_error = 'No se puede utilizar el per?odo de recarga'    
        return    
      end        
      
      -- actualizamos el registro      
      update sact_periodos_recargas       
         set f_inicio_periodo = @f_inicio_periodo,       
             f_fin_periodo    = @f_fin_periodo,       
             d_periodo        = @pi_d_periodo,      
             c_usua_actuac    = @pi_id_usuario,       
             f_actuac         = getdate()       
       where id_periodo_recarga = @pi_id_periodo      
      
      set @po_c_error = @@error          
      if (@po_c_error  <> 0)      
      begin          
        set @po_d_error = 'Error al actualizar el per?odo'          
        return      
      end        
       
    end       
      
end --sp_abm_periodo_recarga
 
go 

Grant Execute on dbo.sp_abm_periodo_recarga to GrpTrpSabed 
go

sp_procxmode 'sp_abm_periodo_recarga', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_abm_periodo_rend_gastos'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_abm_periodo_rend_gastos" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_abm_periodo_rend_gastos (     
@pi_id_periodo	        numeric(18,0),     
@pi_f_inicio_periodo    varchar (19),     
@pi_f_fin_periodo	varchar (19),     
@pi_f_recarga_periodo   varchar (19),  
@pi_d_periodo	        varchar (60),     
@pi_id_usuario          numeric(18,0),     
@po_c_error             typ_c_error output,     
@po_d_error             typ_d_error output
)     
as     
-------------------------------------------------------------------     
--Objetivo: Mantener los periodos   
--          de rendicion de gastos    
--Par?metros de salida:      
--po_c_error y po_d_error     
-------------------------------------------------------------------     
     
begin     
  declare      
  @f_inicio_periodo  smalldatetime,     
  @f_fin_periodo     smalldatetime,     
  @f_recarga_periodo smalldatetime,   
  @estado            varchar(1)   
   
  if (@pi_f_inicio_periodo is null)     
    begin     
      set @po_c_error = 3
      set @po_d_error = 'No se recibi? fecha de inicio'     
      return     
  end         
     
  if (@pi_f_fin_periodo is null)     
    begin     
      set @po_c_error = 3     
      set @po_d_error = 'No se recibi? fecha de finalizacion'     
      return     
  end         
  
  if (@pi_f_recarga_periodo is null)   
    begin     
      set @po_c_error = 3     
      set @po_d_error = 'No se recibi? fecha de recarga'     
      return     
  end         
  
  if (@pi_d_periodo  is null)     
    begin     
      set @po_c_error = 3     
      set @po_d_error = 'No se recibio la descripci?n del per?odo'      
      return            
  end     
       
  if (@pi_id_usuario is null or @pi_id_usuario = 0)     
    begin     
      set @po_c_error = 3     
      set @po_d_error = 'No se recibi? usuario'     
      return     
  end       
       
  set @po_c_error = 0     
  set @po_d_error = null     
     
  set @pi_f_inicio_periodo = @pi_f_inicio_periodo + 'T00:00'
  set @pi_f_fin_periodo    = @pi_f_fin_periodo    + 'T23:59'

  set @f_inicio_periodo = convert(datetime, @pi_f_inicio_periodo)
  set @f_fin_periodo    = convert(datetime, @pi_f_fin_periodo)
  
 --convierto el varchar de entrada a date para el insert en la tabla     
  execute sp_convierte_char_en_fecha @pi_fecha_char     = @pi_f_recarga_periodo,     
                                                                @po_fecha_datetime = @f_recarga_periodo output,     
                                                                @po_c_error        = @po_c_error output,     
                                                                @po_d_error        = @po_d_error output     
                                    
    if (@po_c_error  <> 0)     
    begin     
	  set @po_d_error = 'Error llamando a sp_convierte_char_en_fecha : ' + @po_d_error		
      return            
    end        
  
  If @f_fin_periodo <  @f_inicio_periodo     
  begin     
     set @po_c_error = 2     
     set @po_d_error = 'La fecha desde es mayor a la hasta'     
     return     
  end       
   
  If @f_fin_periodo > @f_recarga_periodo     
  begin     
     set @po_c_error = 2     
     set @po_d_error = 'La fecha de recarga debe ser mayor a la fecha de finalizaci?n del per?odo'     
     return     
  end   
  
  -- Evaluo que el periodo no sea interanual   
  If datepart(yy,@f_fin_periodo) <> datepart(yy,@f_inicio_periodo)     
  begin     
     set @po_c_error = 2     
     set @po_d_error = 'El periodo no debe incluir a?os diferentes'     
     return     
  end     
   
     -- Evaluo si no esta superpuesto con otro periodo ya insetado     
  if exists (select 1      
               from sact_periodos_rendicion per     
              where ((per.f_inicio_periodo <= @f_fin_periodo and per.f_fin_periodo >= @f_fin_periodo)     
                     or (per.f_inicio_periodo <= @f_inicio_periodo and per.f_fin_periodo >= @f_inicio_periodo))     
                and (id_periodo <> @pi_id_periodo or isnull(@pi_id_periodo,0)=0)  
             )              
  begin                 
    set @po_c_error = 2     
    set @po_d_error = 'El per?odo informado se superpone con uno existente'      
    return      
  end   
   
  -- vemos si es modificacion o alta     
  If (@pi_id_periodo is null or @pi_id_periodo=0)  
    begin     
     
      -- Insertamos el registro     
      insert into sact_periodos_rendicion (f_inicio_periodo,f_fin_periodo,f_recarga_periodo,d_periodo,c_usua_alta)      
      values (@f_inicio_periodo,@f_fin_periodo,@f_recarga_periodo,@pi_d_periodo,@pi_id_usuario)     
     
      set @po_c_error = @@error         
      if (@po_c_error  <> 0)     
      begin         
        set @po_d_error = 'Error al insertar el periodo'        
        return     
      end     
     
    end      
     
  else     
     
    begin     
     
      --   
      -- Verificamos que el estado del periodo se pueda modificar   
      execute sp_est_periodo_rend_gas   
                   @pi_id_periodo = @pi_id_periodo,    
                   @po_estado     = @estado   output,    
                   @po_c_error    = @po_c_error output,    
                   @po_d_error    = @po_d_error output      
      if (@po_c_error  <> 0)    
      begin   
	    set @po_d_error = 'Error llamando a sp_est_periodo_rend_gas : ' + @po_d_error
        return        
      end   
   
      If @estado <> 'F'  
      begin   
        set @po_c_error = 2  
        set @po_d_error = 'No se puede utilizar el per?odo de rendicion informado'   
        return   
      end      
     
      -- actualizamos el resgistro     
      update sact_periodos_rendicion  
            set f_inicio_periodo=@f_inicio_periodo,      
                f_fin_periodo=@f_fin_periodo,      
                f_recarga_periodo=@f_recarga_periodo,  
                d_periodo=@pi_d_periodo,     
                c_usua_actuac=@pi_id_usuario,      
                f_actuac=getdate()      
      where id_periodo=@pi_id_periodo     
          
      set @po_c_error = @@error         
      if (@po_c_error  <> 0)     
      begin         
        set @po_d_error = 'Error al actualizar el periodo'         
        return     
      end       
      
    end      
     
end --sp_abm_periodo_rend_gastos
 
go 

Grant Execute on dbo.sp_abm_periodo_rend_gastos to GrpTrpSabed 
go

sp_procxmode 'sp_abm_periodo_rend_gastos', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_alta_candidato'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_alta_candidato" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_alta_candidato(     

 @pi_id_usuario          numeric(18,0),     

 @pi_id_persona          numeric(18,0),          

 @pi_id_colegio          numeric(18,0),          

 @pi_c_anio_curso        varchar(40),          

 @pi_c_orient_colegio    numeric(18,0),          

 @pi_c_modal_col         numeric(18,0),     

 @pi_e_registro          char(1),    

 @pi_l_fliares           typ_lista,     

 @pi_x_observaciones     varchar(250),    

 @pi_id_tutor_adm        numeric(18,0),     

 @pi_id_tutor_ped        numeric(18,0),   

 @pi_id_grupo 	         numeric(18,0),     

 @pi_c_cant_cuotas       numeric(18,0),      

 @po_id_alumno           numeric(18,0) output,     

 @po_c_error             typ_c_error   output,     

 @po_d_error             typ_d_error   output     

)     

as     

     

--objetivo: dar de alta un candidato a beca    

--la lista de familiares "id_per_rel:c_parentesco:m_tit_tarjeta"    

     

begin     

    

  --    

  -- Valido los par?metros de entrada    

  if (@pi_id_usuario is null or @pi_id_usuario = 0)       

    begin     

      set @po_c_error = 3    

      set @po_d_error = 'No se recibi? pi_id_usuario'     

      return            

    end     

       

  if (@pi_id_persona is null or @pi_id_persona = 0)     

    begin     

      set @po_c_error = 3   

      set @po_d_error = 'No se recibi? pi_id_persona'     

      return            

    end     

    

  if (@pi_id_colegio is null or @pi_id_colegio = 0)     

    begin     

      set @po_c_error = 2   

      set @po_d_error = 'Se debe seleccionar un colegio'    

      return            

    end     

    

  if (isnull(@pi_id_tutor_ped,0) = 0)     

    begin     

      set @po_c_error = 2   

      set @po_d_error = 'Se debe seleccionar un tutor pedag?gico'    

      return            

    end     

    

  if (isnull(@pi_id_tutor_adm,0) = 0)     

    begin     

      set @po_c_error = 2 

      set @po_d_error = 'Se debe seleccionar un tutor administrativo'    

      return            

    end     

    

    

 if @pi_c_orient_colegio = 0 set @pi_c_orient_colegio = null    

 if @pi_c_modal_col = 0 set @pi_c_modal_col = null            

    

  declare     

   @e_alumno  varchar (15),    

   @id_tutor  numeric (18,0),    

   @id_ong    numeric (18,0),    

   @id_alumno numeric (18,0),    

   @aux       typ_lista, 

   @e_definitivo varchar(1) 

       

    

  set @e_alumno = null    

  set @id_tutor = -1    

  set @id_ong  = -1    

  set @po_c_error = 0     

  set @po_d_error = null     

    

  begin tran alta_candidato    

  --    

  --  Verifico si la persona ya tiene otorgada una beca    

  Select top 1     

         @e_alumno = saatalu.e_alumno    

    From saat_alumnos saatalu    

   where saatalu.id_persona = @pi_id_persona    

     and saatalu.e_alumno in ('BECADO','CANDIDATO','SUSPENDIDO','POSTULANTE')    

    

  set @po_c_error = @@error      

  if (@po_c_error  <> 0)    

    begin     

      set @po_d_error =  convert(varchar,@po_c_error)     

                         + ' - Error al consultar la condicion de la persona. '    

  end    

    

  If (@e_alumno is not null)    

    begin      

      set @po_c_error = 2    

      set @po_d_error = 'El alumno ya es '+ @e_alumno    

      rollback tran alta_candidato    

      return            

    end     

    

  --    

  -- Veo que la persona no sea Tutor    

  Select top 1    

         @id_tutor = tut.id_tutor    

    from saft_tutores tut    

   where tut.id_persona = @pi_id_persona    

     and tut.e_registro <> 'B'    

    

  if (@@rowcount = 0)     

    begin     

      set @id_tutor = -99    

    end     

    

  set @po_c_error = @@error     

  if (@po_c_error  <> 0)    

    begin     

      set @po_d_error =  convert(varchar,@po_c_error)     

                         + ' - Error al consultar la condicion de tutor de la persona. '    

  end      

    

  if (@id_tutor = -1)    

    begin     

      set @po_c_error = 3    

      set @po_d_error = 'La persona que intenta cargar como candidato es Tutor'    

      rollback tran alta_candidato    

      return            

    end     

    

  --    

  -- Veo que la paersona no sea de una ONG    

  Select top 1    

         @id_ong = ong.id_ong    

    from saft_personas_ong ong    

   where ong.id_persona = @pi_id_persona    

     and ong.e_registro <> 'B'    

    

  if (@@rowcount = 0)     

    begin     

      set @id_ong = -99    

    end     

    

  set @po_c_error = @@error    

  if (@po_c_error  <> 0)    

    begin     

      set @po_d_error =  convert(varchar,@po_c_error)     

                         + ' - Error al consultar la condicion de tutor de la persona. '    

  end      

    

  If (@id_ong  = -1)    

    begin     

      set @po_c_error = 2   

      set @po_d_error = 'La persona que intenta carga como candidato una empleado de ONG o de la fundacion'    

      rollback tran alta_candidato    

      return            

    end     

     

  -- 

  -- Veo si la persona esta en estado definitivo 

  --procedure q retorna los codigos del estado de registro definitivo   

  execute sp_obtiene_e_definitivo   @po_c_valor  = @e_definitivo output,   

                                    @po_c_error  = @po_c_error output,   

                                    @po_d_error  = @po_d_error output   

                                  

  if (@po_c_error  <> 0)   

    begin   

      set @po_d_error = 'Error llamando a sp_obtiene_e_definitivo : ' + @po_d_error	    

      return          

  end 

   

  If not exists (select 1  

                   from sagt_personas  

                  where id_persona=@pi_id_persona  

                    and e_registro=@e_definitivo) 

    begin 

      set @po_c_error = 2 

      set @po_d_error = 'La persona no se encuentra en estado definitivo'	    

      return     

  end 

        

  --    

  -- doy el alta    

  insert into saat_alumnos (id_persona,id_colegio,e_alumno,     

                            d_anio_curso,c_orient_colegio,c_modal_col,    

                            e_registro,x_observaciones, c_usua_alta,id_grupo,c_cant_cuotas)     

                    values (@pi_id_persona,@pi_id_colegio,'CANDIDATO',     

                            @pi_c_anio_curso,@pi_c_orient_colegio,@pi_c_modal_col,    

                            @pi_e_registro, @pi_x_observaciones,@pi_id_usuario,@pi_id_grupo,@pi_c_cant_cuotas)    

                                

  set @po_c_error = @@error, @id_alumno = @@identity    

  if (@po_c_error  <> 0)    

    begin     

      set @po_d_error =  convert(varchar,@po_c_error)     

                         + ' - Error al intentar dar de alta el candidato. '    

      rollback tran alta_candidato    

      return    

  end    

      

  insert into sagt_alumnos_tutores (id_alumno, id_tutor, id_perfil,c_usua_alta)    

                         values (@id_alumno, @pi_id_tutor_adm, 1,@pi_id_usuario)    

    

  set @po_c_error = @@error          

  if (@po_c_error  <> 0)    

    begin     

      set @po_d_error =  'Error al intentar dar de alta el tutor adm. '     

      rollback tran alta_candidato    

      return    

  end    

    

  insert into sagt_alumnos_tutores (id_alumno, id_tutor, id_perfil,c_usua_alta)    

                         values (@id_alumno, @pi_id_tutor_ped, 2,@pi_id_usuario)        

                                

  set @po_c_error = @@error            

  if (@po_c_error  <> 0)    

    begin     

      set @po_d_error =  'Error al intentar dar de alta el tutor ped. '     

      rollback tran alta_candidato    

      return    

  end    

      

  execute sp_inserta_grupo_fliar     

            @pi_id_usuario = @pi_id_usuario,    

            @pi_id_alumno  = @id_alumno,    

            @pi_l_fliares  = @pi_l_fliares,    

            @pi_e_registro = @pi_e_registro,  

            @po_c_error    = @po_c_error output,    

            @po_d_error    = @po_d_error output      

      

  if (@po_c_error  <> 0)      

  begin    

      rollback tran alta_candidato    

      return        

  end     

        

  set @po_id_alumno = @id_alumno    

        

  commit tran alta_candidato      

      

end
 
go 

Grant Execute on dbo.sp_alta_candidato to GrpTrpSabed 
go

sp_procxmode 'sp_alta_candidato', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_alumnos_beca_baja'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_alumnos_beca_baja" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_alumnos_beca_baja( 
-- drop procedure sp_alumnos_beca_baja 
@pi_anio      int, 
@pi_id_tutor  numeric(18,0), 
@pi_id_ong    numeric(18,0), 
@po_c_error   typ_c_error   output, 
@po_d_error   typ_d_error   output 
) 
as 
-- 
--objetivo: obtener los candidatos que se encuentran en Guardar Avance 
-- 
 
begin 
 
  set @po_c_error = 0 
  set @po_d_error = null 
   
  if @pi_id_tutor = 0  
      set @pi_id_tutor = null 
       
  if @pi_id_ong = 0  
      set @pi_id_ong = null   
 
  select saatalu.id_persona_alu id_persona, 
         saatalu.id_alumno,   
         saatalu.f_nacimiento,                 
         (select id_tutor 
            from saav_alu_tut_ong 
           where id_alumno = saatalu.id_alumno 
             and id_perfil_tutor = 1 
             and e_registro_tut = 'D' 
         )  id_tutor_adm, 
         (select id_tutor 
            from saav_alu_tut_ong 
           where id_alumno = saatalu.id_alumno 
             and id_perfil_tutor = 2 
             and e_registro_tut = 'D' 
         )  id_tutor_ped, 
         saatalu.id_ong, 
         saatalu.d_apellido_alu + ', '+ saatalu.d_nombre_alu  apenom 
    from saav_alu_tut_ong saatalu         
   where saatalu.e_alumno = 'BAJABECA' 
     and saatalu.e_registro_alu = 'D' 
     and saatalu.e_registro_tut = 'D' 
     and saatalu.e_registro_per = 'D' 
     and saatalu.e_registro_ong = 'D' 
     and saatalu.id_tutor = isnull(@pi_id_tutor, saatalu.id_tutor) 
     and saatalu.id_ong = isnull(@pi_id_ong, saatalu.id_ong)           
     and datepart(yy,saatalu.f_baja) = @pi_anio 
 
  set @po_c_error = @@error     
  if (@po_c_error  <> 0) 
    begin  
      set @po_d_error =  'Error en sp_alumnos_beca_baja. ' 
  end 
  
end --sp_alumnos_beca_baja
 
go 

Grant Execute on dbo.sp_alumnos_beca_baja to GrpTrpSabed 
go

sp_procxmode 'sp_alumnos_beca_baja', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_alumnos_beca_recha'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_alumnos_beca_recha" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_alumnos_beca_recha( 
@pi_anio      int, 
@pi_id_tutor  numeric(18,0), 
@pi_id_ong    numeric(18,0), 
@po_c_error   typ_c_error   output, 
@po_d_error   typ_d_error   output 
) 
as 
-- 
--objetivo: obtener los candidatos que se encuentran en Guardar Avance 
-- 
 
begin 
 
  set @po_c_error = 0 
  set @po_d_error = null 
 
  if @pi_id_tutor = 0  
      set @pi_id_tutor = null 
       
  if @pi_id_ong = 0  
      set @pi_id_ong = null 
 
  select saatalu.id_persona_alu id_persona, 
         saatalu.id_alumno,  
         saatalu.f_nacimiento,               
         (select id_tutor 
            from saav_alu_tut_ong 
           where id_alumno = saatalu.id_alumno 
             and id_perfil_tutor = 1 
             and e_registro_tut = 'D' 
         )  id_tutor_adm, 
         (select id_tutor 
            from saav_alu_tut_ong 
           where id_alumno = saatalu.id_alumno 
             and id_perfil_tutor = 2 
             and e_registro_tut = 'D' 
         )  id_tutor_ped, 
         saatalu.id_ong, 
         saatalu.d_apellido_alu + ', '+ saatalu.d_nombre_alu  apenom 
    from saav_alu_tut_ong saatalu         
   where saatalu.e_alumno = 'RECHAZADO' 
     and saatalu.e_registro_alu = 'D' 
     and saatalu.e_registro_tut = 'D' 
     and saatalu.e_registro_per = 'D' 
     and saatalu.e_registro_ong = 'D' 
     and saatalu.id_tutor = isnull(@pi_id_tutor, saatalu.id_tutor) 
     and saatalu.id_ong = isnull(@pi_id_ong, saatalu.id_ong)           
     and datepart(yy,saatalu.f_resul_prop) = @pi_anio 
 
  set @po_c_error = @@error     
  if (@po_c_error  <> 0) 
    begin  
      set @po_d_error =  'Error en sp_alumnos_beca_recha. ' 
  end 
  
end --sp_alumnos_beca_recha
 
go 

Grant Execute on dbo.sp_alumnos_beca_recha to GrpTrpSabed 
go

sp_procxmode 'sp_alumnos_beca_recha', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_alumnos_beca_susp'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_alumnos_beca_susp" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_alumnos_beca_susp( 
@pi_anio      int, 
@pi_id_tutor  numeric(18,0), 
@pi_id_ong    numeric(18,0), 
@po_c_error   typ_c_error   output, 
@po_d_error   typ_d_error   output 
) 
as 
-- 
--objetivo: obtener los candidatos que se encuentran en Guardar Avance 
-- 
 
begin 
 
  set @po_c_error = 0 
  set @po_d_error = null 
   
  if @pi_id_tutor = 0  
      set @pi_id_tutor = null 
       
  if @pi_id_ong = 0  
      set @pi_id_ong = null   
 
  select saatalu.id_persona_alu id_persona, 
         saatalu.id_alumno, 
         saatalu.f_nacimiento, 
         (select id_tutor 
            from saav_alu_tut_ong 
           where id_alumno = saatalu.id_alumno 
             and id_perfil_tutor = 1 
             and e_registro_tut = 'D' 
         )  id_tutor_adm, 
         (select id_tutor 
            from saav_alu_tut_ong 
           where id_alumno = saatalu.id_alumno 
             and id_perfil_tutor = 2 
             and e_registro_tut = 'D' 
         )  id_tutor_ped, 
         saatalu.id_ong, 
         saatalu.d_apellido_alu + ', '+ saatalu.d_nombre_alu  apenom 
    from saav_alu_tut_ong saatalu          
   where saatalu.e_alumno = 'SUSPENDIDO' 
     and saatalu.e_registro_alu = 'D' 
     and saatalu.e_registro_tut = 'D' 
     and saatalu.e_registro_per = 'D' 
     and saatalu.e_registro_ong = 'D' 
     and saatalu.id_tutor = isnull(@pi_id_tutor, saatalu.id_tutor) 
     and saatalu.id_ong = isnull(@pi_id_ong, saatalu.id_ong)      
     and datepart(yy,saatalu.f_suspension) = @pi_anio 
 
  set @po_c_error = @@error     
  if (@po_c_error  <> 0) 
    begin  
      set @po_d_error =  'Error en sp_alumnos_beca_susp. ' 
  end 
  
end --sp_alumnos_beca_susp
 
go 

Grant Execute on dbo.sp_alumnos_beca_susp to GrpTrpSabed 
go

sp_procxmode 'sp_alumnos_beca_susp', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_alumnos_estados'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_alumnos_estados" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_alumnos_estados(   
@pi_anio      int,   
@pi_id_tutor  numeric(18,0),   
@pi_id_ong    numeric(18,0),   
@pi_estado    varchar(15), 
@po_c_error   typ_c_error   output,   
@po_d_error   typ_d_error   output   
)   
as   
--   
--objetivo: obtener los alumnos que no tienen cargada la Situaci?n Acad?mica   
--   
   
begin   
   
  set @po_c_error = 0   
  set @po_d_error = null   
     
  if @pi_id_tutor = 0    
      set @pi_id_tutor = null   
         
  if @pi_id_ong = 0    
      set @pi_id_ong = null   
       
  if @pi_estado is null 
    begin    
      set @po_d_error =  'No se informo el estado a buscar'   
      set @po_c_error = 3   
      return 
  end  
   
-- Alumnos  
Select distinct alu.id_persona,  
       alu.id_alumno,  
       per.f_nacimiento,  
       null id_tutor_adm, -- no hace falta hasta ahora 
       null id_tutor_ped, -- no hace falta hasta ahora       
       tut.id_ong,  
       per.d_apellido + ', '+ per.d_nombre apenom  
  from sagt_alumnos_tutores alutut,  
       saat_alumnos alu,  
       saft_tutores tut,  
       sagt_personas per  
 where (tut.id_tutor = @pi_id_tutor or @pi_id_tutor is null)  
   and (tut.id_ong = @pi_id_ong or @pi_id_ong is null)  
   and tut.id_tutor = alutut.id_tutor  
   and per.id_persona = alu.id_persona  
   and alutut.id_alumno = alu.id_alumno  
   and alu.e_alumno = @pi_estado 
 order by per.d_apellido + ', '+ per.d_nombre  
   
  set @po_c_error = @@error       
  if (@po_c_error  <> 0)   
    begin    
      set @po_d_error =  'Error en sp_alumnos_estados. '     
  end   
    
end -- sp_alumnos_estados
 
go 

Grant Execute on dbo.sp_alumnos_estados to GrpTrpSabed 
go

sp_procxmode 'sp_alumnos_estados', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_alumnos_recargas'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_alumnos_recargas" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_alumnos_recargas(        
@pi_id_alumno            numeric(18,0),        
@pi_id_periodo_recarga   numeric(18,0),      
@pi_id_lote_det_recarga  numeric(18,0),      
@pi_id_usuario           numeric(18,0),          
@po_saldo                varchar(18)   output,      
@po_supero               varchar(1)    output,      
@po_estado_sit_acad      varchar(30)   output,      
@po_sn                   varchar(15)   output, -- 2
@po_f_ult_recarga        varchar(12)   output,      
@po_id_periodo_sit_acad  numeric(18,0) output,      
@po_id_periodo_rendicion numeric(18,0) output,   
@po_observacion          varchar(250)  output,  
@po_m_error_val          varchar(1)    output,     
@po_error_val_mensaje    typ_d_error   output,     
@po_c_error   typ_c_error              output,        
@po_d_error   typ_d_error              output        
)        
as        
--        
--objetivo: Obtener el detalle de saldo dinero y       
--          situacion academica de los alumnos.      
--          Adem?s validar los datos de la tarjeta del alumno; en el po_error_val_mensaje    
--          se retorna la concatenaci?n de los errores asociados a los datos del alumno    
--        
        
begin        
           
  if @pi_id_alumno = 0 or @pi_id_alumno is null      
    begin      
      set @po_c_error = 3        
      set @po_d_error = 'No se informo el alumno (ID)'      
      return     
  end      
              
  if @pi_id_periodo_recarga = 0 or @pi_id_periodo_recarga is null      
    begin      
      set @po_c_error = 3        
      set @po_d_error = 'No se informo el periodo de recarga'   
      return   
  end      
        
  if @pi_id_usuario = 0 or @pi_id_usuario is null      
    begin      
      set @po_c_error = 3        
      set @po_d_error = 'No se informo el usuario'        
      return     
  end      
        
  declare      
    @id_periodo_rendicion numeric(18,0),       
    @id_periodo_sit_acad  numeric(18,0),      
    @saldo                numeric(18,0),      
    @porcentaje           numeric(18,0),      
    @cant                 numeric(18,0),      
    @valorbeca            numeric(18,0),      
    @id_tipo_beca         numeric(18,0),      
    @f_ult_recarga        datetime,      
    @f_consulta           datetime, 
    @f_consulta_val       datetime 
          
  set @po_supero = 'N'        
  set @po_c_error = 0        
  set @po_d_error = null        
        
  -- obtengo los ID para buscar el saldo y la situacion academica      
  execute sp_obt_per_eval_acad       
                  @pi_id_periodo_recarga = @pi_id_periodo_recarga,      
                  @po_id_periodo = @id_periodo_sit_acad output,       
                  @po_c_error    = @po_c_error output,        
                  @po_d_error    = @po_d_error output         
  if (@po_c_error  <> 0)        
    begin         
      set @po_d_error =  'Error en sp_obt_per_eval_acad: ' + @po_d_error           
      return   
  end      
        
  execute sp_obt_per_rend_activo      
                  @pi_id_periodo_recarga = @pi_id_periodo_recarga,      
                  @po_id_periodo = @id_periodo_rendicion output,       
                  @po_c_error    = @po_c_error output,        
                  @po_d_error    = @po_d_error output         
  if (@po_c_error  <> 0)        
    begin         
      set @po_d_error =  'Error en sp_obt_per_rend_activo: ' + @po_d_error             
      return     
  end      
        
  --      
  -- Obtengo el saldo y el resultado de la situacion academica      
  execute sp_cons_saldo_alumno      
                   @pi_id_alumno  = @pi_id_alumno,      
                   @pi_id_periodo = @id_periodo_rendicion,        
                   @pi_id_usuario = @pi_id_usuario ,        
                   @pi_tipo       = 'F',         
                   @po_saldo      = @po_saldo output,        
                   @po_c_error    = @po_c_error output,        
                   @po_d_error    = @po_d_error output         
  if (@po_c_error  <> 0)        
    begin         
      set @po_d_error =  'Error en sp_cons_saldo_alumno: ' + @po_d_error           
      return     
  end      
        
  execute sp_eval_acad_completa       
                   @pi_id_usuario = @pi_id_usuario ,        
                   @pi_id_alumno  = @pi_id_alumno,      
                   @pi_id_periodo = @id_periodo_sit_acad,        
                   @po_completa   = @po_estado_sit_acad output,      
                   @po_c_error    = @po_c_error output,        
                   @po_d_error    = @po_d_error output         
  if (@po_c_error  <> 0)        
    begin         
      set @po_d_error =  'Error en sp_eval_acad_completa: ' + @po_d_error           
      return           
  end      
         
  --      
  -- Veo en funcion del saldo la marca de color      
  set @saldo = convert(numeric(18,0),@po_saldo)      
        
  -- obtengo el porcentaje      
  Select @porcentaje=convert(numeric(18,0),par.d_valor)      
    from sapt_parametros par      
   where par.id_parametro=134      
        
  set @po_c_error = @@error,@cant=@@rowcount            
  if (@po_c_error  <> 0)        
    begin         
      set @po_d_error =  'Error al obtener de parametros el porcentaje'            
      return     
  end         
  If @cant=0       
    begin         
      set @po_d_error =  'Error no se encuentra el parametro del porcentaje (134)'        
      set @po_c_error = 3      
      return     
  end       
   
  If @pi_id_periodo_recarga is not null or @pi_id_periodo_recarga <> 0 
    begin 
      select @f_consulta=f_fin_periodo 
        from sact_periodos_recargas 
       where id_periodo_recarga=@pi_id_periodo_recarga 
        
      set @po_c_error = @@error,@cant=@@rowcount            
      if (@po_c_error  <> 0)      
        begin         
          set @po_d_error =  'Error al obtener el periodo de recarga'             
          return     
      end         
      If @cant=0       
        begin         
          set @po_d_error =  'No se pudo determinar la fecha de consulta'        
          set @po_c_error = 3      
          return     
      end     
  end 
  else 
    set @f_consulta = getdate()    
      
  --      
  -- Obtengo el valor de la poliza del alumno      
  execute sp_obtiene_tbeca_alumno       
                   @pi_id_alumno     = @pi_id_alumno,       
                   @pi_f_consulta    = @f_consulta,      
                   @po_id_tipo_beca  = @id_tipo_beca output,       
                   @po_valor_beca    = @valorbeca  output,      
                   @po_c_error       = @po_c_error output,        
                   @po_d_error       = @po_d_error output         
  if (@po_c_error  <> 0)        
    begin         
      set @po_d_error =  'Error en sp_obtiene_tbeca_alumno: ' + @po_d_error              
      return     
  end      
      
  if @saldo >= (@valorbeca * (@porcentaje/100))      
  begin      
    set @po_supero = 'S'      
  end      
        
  --      
  -- Obtengo la marca de S/N y Observaciones en caso de tenerlas     
  --    
  -- Me fijo si ya formaba parte del lote para tomar el s/n de alli    
  If @pi_id_lote_det_recarga <> 0     
    begin 
    
      Select @po_sn = case when (ldr.q_becas_a_recargar<=1) then ldr.e_alumno      
                           when (ldr.q_becas_a_recargar>=2) then convert(varchar(2),ldr.q_becas_a_recargar) end, 
            @po_observacion = ldr.x_observacion   
        from sart_lotes_det_recarga ldr    
       where ldr.id_lote_det_recarga = @pi_id_lote_det_recarga    
           
      set @po_c_error = @@error      
      if @po_c_error <>0      
        begin         
          set @po_d_error =  'Error al intentar obtener el S/N de lote'             
          return     
      end      

      --
      -- Analizamos segundas recargas
      If @po_sn='N'
        begin
         
          If exists (Select 1
                       from sart_lotes_recarga lr2, 
                            sart_lotes_det_recarga ldr2
                      where ldr2.id_alumno = @pi_id_alumno
                        and ldr2.e_alumno = 'S'
                        and ldr2.id_lote_recarga=lr2.id_lote_recarga
                        and lr2.c_estado_lote ='ENVIADO'
                        and lr2.id_tutor is null       -- lote de seg. recarga
                        and lr2.id_coordinador is null -- lote de seg. recarga
                        and lr2.id_periodo_recarga = @pi_id_periodo_recarga)
            Begin
              set @po_sn = 'Seg.Rec.'
          end

      end -- if de N


  end    
  else  --  Si no formaba parte de un lote    
    begin    
      --  Si se superio el % se sugiere N (no), caso contrario S (si)     
      If @po_supero = 'S'    
        set @po_sn = 'N'      
      else    
        set @po_sn = 'S'    
  end     
        
  --      
  -- obtengo la ultima recarga      
  execute sp_obtiene_ultima_recarga       
                   @pi_id_alumno     = @pi_id_alumno,       
                   @po_f_ult_recarga = @f_ult_recarga output,      
                   @po_c_error       = @po_c_error output,        
                   @po_d_error       = @po_d_error output         
  if (@po_c_error  <> 0)        
    begin         
      set @po_d_error =  'Error en sp_obtiene_ultima_recarga: ' + @po_d_error        
      return           
  end      
        
  If @f_ult_recarga is not null      
    begin      
       
      set @po_f_ult_recarga=convert(varchar(12),@f_ult_recarga,112)      
        
      set @po_c_error = @@error      
      if @po_c_error <>0      
        begin         
          set @po_d_error =  'Error al intentar convertir la fecha de ultima recarga'         
          return        
      end            
  end      
       
  set @po_id_periodo_sit_acad  = @id_periodo_sit_acad     
  set @po_id_periodo_rendicion = @id_periodo_rendicion     
      
  -- obtengo la marca de validaci?n     
  execute sp_valida_recarga_alu     
                   @pi_id_alumno         = @pi_id_alumno,     
                   @pi_f_consulta        = @f_consulta,  
                   @po_m_error_val       = @po_m_error_val output,      
                   @po_error_val_mensaje = @po_error_val_mensaje output,    
                   @po_c_error           = @po_c_error output,        
                   @po_d_error           = @po_d_error output         
  if (@po_c_error  <> 0)        
    begin         
      set @po_d_error =  'Error en sp_valida_recarga_alu: ' +  @po_d_error    
      return         
  end    
        
end -- sp_alumnos_recargas
 
go 

Grant Execute on dbo.sp_alumnos_recargas to GrpTrpSabed 
go

sp_procxmode 'sp_alumnos_recargas', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_alumnos_sin_eval_acad'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_alumnos_sin_eval_acad" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_alumnos_sin_eval_acad(   
@pi_anio      int,  
@pi_id_tutor  numeric(18,0),  
@pi_id_ong    numeric(18,0),  
@po_c_error   typ_c_error   output,  
@po_d_error   typ_d_error   output  
)  
as  
--  
--objetivo: obtener los alumnos que no tienen cargada la Situaci?n Acad?mica  
--  
  
begin  
  
  set @po_c_error = 0  
  set @po_d_error = null  
    
  if @pi_id_tutor = 0   
      set @pi_id_tutor = null  
        
  if @pi_id_ong = 0   
      set @pi_id_ong = null  
 
-- 
-- Alumnos que no tienen cargada la situacion academica  
Select alu.id_persona, 
       alu.id_alumno, 
       per.f_nacimiento, 
       ------------------ 
       --alutut.id_tutor, 
       ------------------ 
       null id_tutor_adm, 
       alutut.id_tutor id_tutor_ped, 
       ------------------ 
       tut.id_ong, 
       per.d_apellido + ', '+ per.d_nombre apenom 
  from sagt_alumnos_tutores alutut, 
       saat_alumnos alu, 
       saft_tutores tut, 
       sagt_personas per 
 where not exists (select 1  
                     from sact_periodos_eval_acad perrend, 
                          saat_alumnos_eval_academ aluevaaca 
                    where perrend.f_inicio_periodo <= getdate()  
                      and convert(numeric(4,0),datepart(yy,perrend.f_inicio_periodo))=@pi_anio 
                      and perrend.id_periodo = aluevaaca.id_periodo 
                      and aluevaaca.id_alumno = alu.id_alumno) 
   and (tut.id_tutor = @pi_id_tutor or @pi_id_tutor is null) 
   and (tut.id_ong = @pi_id_ong or @pi_id_ong is null) 
   and alutut.id_perfil = 2 -- pedagogico 
   and tut.id_tutor = alutut.id_tutor 
   and per.id_persona = alu.id_persona 
   and alutut.id_alumno = alu.id_alumno 
   and alu.e_alumno in ('BECADO','SUSPENDIDO') 
order by per.d_apellido + ', '+ per.d_nombre 
  
  
  set @po_c_error = @@error      
  if (@po_c_error  <> 0)  
    begin   
      set @po_d_error =  'Error en sp_alumnos_sin_eval_acad. '   
  end  
   
end -- sp_alumnos_sin_eval_acad
 
go 

Grant Execute on dbo.sp_alumnos_sin_eval_acad to GrpTrpSabed 
go

sp_procxmode 'sp_alumnos_sin_eval_acad', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_alumnos_sin_rend_gastos'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_alumnos_sin_rend_gastos" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_alumnos_sin_rend_gastos(  
@pi_anio      int,  
@pi_id_tutor  numeric(18,0),  
@pi_id_ong    numeric(18,0),  
@po_c_error   typ_c_error   output,  
@po_d_error   typ_d_error   output  
)  
as  
--  
--objetivo: obtener los alumnos que no tienen cargada la Situaci?n Acad?mica  
--  
  
begin  
  
  set @po_c_error = 0  
  set @po_d_error = null  
    
  if @pi_id_tutor = 0   
      set @pi_id_tutor = null  
        
  if @pi_id_ong = 0   
      set @pi_id_ong = null  
  
  
-- Alumnos que no tienn cargada la rendicion de gastos  
Select alu.id_persona, 
       alu.id_alumno, 
       per.f_nacimiento, 
       ------------------ 
       --alutut.id_tutor, 
       ------------------ 
       null id_tutor_adm, 
       alutut.id_tutor id_tutor_ped, 
       ------------------        
       tut.id_ong, 
       per.d_apellido + ', '+ per.d_nombre apenom 
  from sagt_alumnos_tutores alutut, 
       saat_alumnos alu, 
       saft_tutores tut, 
       sagt_personas per 
 where not exists (select 1  
                     from sact_periodos_rendicion perrend, 
                          saat_alumnos_rendicion_gasto alurendgas 
                    where perrend.f_inicio_periodo <= getdate()  
                      and convert(numeric(4,0),datepart(yy,perrend.f_inicio_periodo))=@pi_anio 
                      and perrend.id_periodo = alurendgas.id_periodo 
                      and alurendgas.id_alumno = alu.id_alumno) 
   and (tut.id_tutor = @pi_id_tutor or @pi_id_tutor is null) 
   and (tut.id_ong = @pi_id_ong or @pi_id_ong is null) 
   and alutut.id_perfil = 1 -- administrativo  
   and tut.id_tutor = alutut.id_tutor 
   and per.id_persona = alu.id_persona 
   and alutut.id_alumno = alu.id_alumno 
   and alu.e_alumno in ('BECADO','SUSPENDIDO') 
 order by per.d_apellido + ', '+ per.d_nombre 
 
  
  set @po_c_error = @@error      
  if (@po_c_error  <> 0)  
    begin   
      set @po_d_error =  'Error en sp_alumnos_sin_rend_gastos. '   
  end  
   
end -- sp_alumnos_sin_rend_gastos
 
go 

Grant Execute on dbo.sp_alumnos_sin_rend_gastos to GrpTrpSabed 
go

sp_procxmode 'sp_alumnos_sin_rend_gastos', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_alumnos_starjeta'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_alumnos_starjeta" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_alumnos_starjeta(    
@pi_anio      int,    
@pi_id_tutor  numeric(18,0),    
@pi_id_ong    numeric(18,0),    
@po_c_error   typ_c_error   output,    
@po_d_error   typ_d_error   output    
)    
as    
--    
--objetivo: Listar los alumnos si tarjeta cargada  
--    
    
begin    
    
  set @po_c_error = 0    
  set @po_d_error = null    
      
  if @pi_id_tutor = 0     
      set @pi_id_tutor = null    
          
  if @pi_id_ong = 0     
      set @pi_id_ong = null 
      
-- Alumnos sin tarjeta  
Select distinct alu.id_persona,   
       alu.id_alumno,   
       per.f_nacimiento,   
       null id_tutor_adm,  
       null id_tutor_ped,      
       tut.id_ong,   
       per.d_apellido + ', '+ per.d_nombre apenom   
  from sagt_alumnos_tutores alutut,   
       saat_alumnos alu,   
       saft_tutores tut,   
       sagt_personas per  
 where (tut.id_tutor = @pi_id_tutor or @pi_id_tutor is null)   
   and (tut.id_ong = @pi_id_ong or @pi_id_ong is null)   
   and not exists (Select 1   
                     from saat_alumnos_tarjetas atar  
                    Where atar.id_alumno = alu.id_alumno  
                      and atar.f_baja is null
                      and f_vigencia_tar_dsd <= getDate() and f_vigencia_tar_hta >= getDate()
                  )  
   and tut.id_tutor = alutut.id_tutor   
   and per.id_persona = alu.id_persona   
   and alutut.id_alumno = alu.id_alumno   
   and alu.e_alumno in ('BECADO','SUSPENDIDO')  
 order by per.d_apellido + ', '+ per.d_nombre   
    
  set @po_c_error = @@error        
  if (@po_c_error  <> 0)    
    begin     
      set @po_d_error =  'Error en sp_alumnos_starjeta. '       
  end    
     
end -- sp_alumnos_starjeta
 
go 

Grant Execute on dbo.sp_alumnos_starjeta to GrpTrpSabed 
go

sp_procxmode 'sp_alumnos_starjeta', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_analisis_beca'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_analisis_beca" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_analisis_beca( 
@pi_id_usuario      numeric(18,0), 
@pi_id_alumno       numeric(18,0), 
@po_c_error         typ_c_error output, 
@po_d_error         typ_d_error output 
) 
as 
/* 
Objetivo:  
*/ 
 
begin 
 
  if (@pi_id_usuario is null or @pi_id_usuario = 0)
    begin 
      set @po_c_error = 3
      set @po_d_error = 'No se recibi? pi_id_usuario' 
      return        
  end 
 
  set @po_c_error = 0 
  set @po_d_error = null 
   
  --verificamos q el alumno este en estado de prop NUEVA 
  if not exists (select 1 
              from saat_alumnos alu 
             where alu.id_alumno = @pi_id_alumno   
               and e_estado_prop = 'NUEVA' 
               and e_alumno = 'POSTULANTE' 
             ) 
  begin 
      set @po_d_error =  'Error, el postulante no est? en propuesta de beca. ' 
      set @po_c_error = 2
      return         
  end 
 
  update saat_alumnos 
  set e_estado_prop = 'ANALISIS', 
      f_actuac = getDate(), 
      c_usua_actuac = @pi_id_usuario 
  where id_alumno = @pi_id_alumno   
  
  set @po_c_error = @@error     
 
  if (@po_c_error  <> 0) 
  begin  
      set @po_d_error =  convert(varchar,@po_c_error)  
                         + ' - Error al poner en ANALISIS la beca. ' 
      return 
  end 
  
end --sp_analisis_beca
 
go 

Grant Execute on dbo.sp_analisis_beca to GrpTrpSabed 
go

sp_procxmode 'sp_analisis_beca', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_baja_alumno_tarjeta'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_baja_alumno_tarjeta" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_baja_alumno_tarjeta (   
@pi_id_usuario          numeric(18,0),  
@pi_id_alu_tar          numeric(18,0),  
@po_c_error             typ_c_error output,  
@po_d_error             typ_d_error output  
)  
as  
-------------------------------------------------------------------  
--Objetivo:  dar de baja la tarjeta del alumno 
--Par?metros de entrada:   
--Par?metros de salida:   
--po_c_error y po_d_error  
-------------------------------------------------------------------  
  
begin  
   
  if (@pi_id_usuario is null or @pi_id_usuario = 0)   
  begin  
      set @po_c_error = 3
      set @po_d_error = 'No se recibi? usuario. '  
      return  
  end    
 
  if (@pi_id_alu_tar is null or @pi_id_alu_tar = 0) 
  begin  
    set @po_c_error = 3
    set @po_d_error = 'No se recibi? el id de la relacion alumno tarjeta para dar de baja'  
    return  
  end      
    
 update saat_alumnos_tarjetas  
    set f_baja             = getDate(),  
        c_usua_actuac      = @pi_id_usuario,  
        f_actuac           = getDate()  
  where id_alu_tar = @pi_id_alu_tar  
  
  set @po_c_error = @@error      
      
  if (@po_c_error  <> 0)  
  begin      
    set @po_d_error = 'Error al dar de baja la tarjeta del alumno ' 
return 
  end  
   
end -- sp_baja_alumno_tarjeta  
 
go 

Grant Execute on dbo.sp_baja_alumno_tarjeta to GrpTrpSabed 
go

sp_procxmode 'sp_baja_alumno_tarjeta', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_baja_candidato'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_baja_candidato" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_baja_candidato( 
 @pi_id_usuario       numeric(18,0),  
 @pi_id_alumno        numeric(18,0),  
 @pi_x_observaciones  varchar(250), 
 @po_c_error          typ_c_error output,  
 @po_d_error          typ_d_error output  
)  
as  
  
--objetivo: dar de baja un candidato a beca 
-- 
  
begin  
 
  -- 
  -- Valido los par?metros de entrada 
  if (@pi_id_usuario is null or @pi_id_usuario = 0)  
    begin  
      set @po_c_error = 3
      set @po_d_error = 'No se recibi? identificador de usuario'  
      return         
    end  
    
  if (@pi_id_alumno is null or @pi_id_alumno = 0)   
    begin  
      set @po_c_error = 3
      set @po_d_error = 'No se recibi? identificador de alumno'  
      return         
    end  
 
 
  set @po_c_error = 0  
  set @po_d_error = null  
 
  declare  
   @e_alumno varchar(15) 
 
  set @e_alumno = null 
 
  -- 
  --  Verifico si la persona ya tiene otrogada una beca 
  Select top 1 
         @e_alumno = saatalu.e_alumno 
    From saat_alumnos saatalu 
   where saatalu.id_alumno = @pi_id_alumno 
     and saatalu.e_alumno = 'CANDIDATO' 
 
  set @po_c_error = @@error       
  if (@po_c_error  <> 0) 
    begin  
      set @po_d_error =  convert(varchar,@po_c_error)  
                         + ' - Error al consultar la condicion del alumno. ' 
      return 
  end 
 
  If (@e_alumno <> 'CANDIDATO') 
    begin  
      set @po_c_error = 2 
      set @po_d_error = 'El alumno no es candidato' 
      return         
    end  
   
  -- 
  -- Doy de baja al candidato 
  update saat_alumnos  
     set e_registro='B', 
         f_baja=getdate(), 
         e_alumno ='ELIMINADO', 
         x_observaciones = @pi_x_observaciones, 
         f_actuac=getdate(), 
         c_usua_actuac = @pi_id_usuario          
   where id_alumno=@pi_id_alumno 
 
  set @po_c_error = @@error    
   
  if (@po_c_error  <> 0) 
    begin  
      set @po_d_error =  convert(varchar,@po_c_error)  
                         + ' - Error al intentar dar de baja al candidato. ' 
      return 
  end   
 
end -- sp_baja_candidato
 
go 

Grant Execute on dbo.sp_baja_candidato to GrpTrpSabed 
go

sp_procxmode 'sp_baja_candidato', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_baja_de_beca'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_baja_de_beca" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_baja_de_beca(
-- drop procedure sp_baja_de_beca
@pi_id_usuario      numeric(18,0),
@pi_id_alumno       numeric(18,0),
@pi_x_observ_baja   varchar(250),
@po_c_error         typ_c_error output,
@po_d_error         typ_d_error output
)
as
/*
Objetivo: 
*/

begin

  if (@pi_id_usuario is null or @pi_id_usuario = 0)
    begin
      set @po_c_error = 3
      set @po_d_error = 'No se recibi? pi_id_usuario'
      return       
  end

  --verificamos q el alumno este en estado BECADO
  if not exists (select 1
              from saat_alumnos alu
             where alu.id_alumno = @pi_id_alumno  
               and e_alumno = 'BECADO'
             )
  begin
      set @po_d_error =  'Error, el alumno no est? becado. '
      set @po_c_error = 3
      return        
  end

  set @po_c_error = 0
  set @po_d_error = null

  update saat_alumnos
  set e_alumno = 'BAJABECA',
      f_baja = getDate(),
      x_observ_baja = @pi_x_observ_baja,
      f_actuac = getDate(),
      c_usua_actuac = @pi_id_usuario
  where id_alumno = @pi_id_alumno  
 
  set @po_c_error = @@error    

  if (@po_c_error  <> 0)
  begin 
      set @po_d_error =  convert(varchar,@po_c_error) 
                         + ' - Error al dar de baja la beca. '
      return
  end
  
end --sp_baja_de_beca
 
go 

Grant Execute on dbo.sp_baja_de_beca to GrpTrpSabed 
go

sp_procxmode 'sp_baja_de_beca', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_baja_noticia'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_baja_noticia" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_baja_noticia ( 
@pi_id_noticia         numeric(18,0), 
@pi_f_baja             varchar(19), 
@pi_c_usua             numeric(18,0), 
@po_c_error            typ_c_error output, 
@po_d_error            typ_d_error output 
) 
as 
-------------------------------------------  
------------------------ 
--Objetivo: Baja de Noticia 
------------------------------------------------------------------- 
begin 
  declare  
         @f_baja             smalldatetime 
 
  
  if (@pi_id_noticia is null or @pi_id_noticia = 0) 
    begin 
      set @po_c_error = 3 
      set @po_d_error = 'No se recibio identificador de noticia' 
      return        
  end 
 
  if (@pi_c_usua is null or @pi_c_usua = 0) 
    begin 
      set @po_c_error = 3 
      set @po_d_error = 'No se recibio usuario' 
      return        
  end 
 
  if (@pi_f_baja is null) 
    begin 
      set @po_c_error = 3 
      set @po_d_error = 'No se recibio fecha de baja' 
      return        
  end 
 
      execute sp_convierte_char_en_fecha @pi_fecha_char     = @pi_f_baja, 
                                         @po_fecha_datetime = @f_baja output, 
                                         @po_c_error        = @po_c_error output, 
                                         @po_d_error        = @po_d_error output 
                                
      if (@po_c_error  <> 0) 
        begin 
		  set @po_d_error = 'Error llamando a sp_convierte_char_en_fecha : ' + @po_d_error	
          return        
      end   
 
  -- Como todo fue OK, veo si es un alta o una modificacion 
  set @po_c_error = 0 
  set @po_d_error = null 
 
      update saft_noticias   
         set f_baja = @f_baja 
       where id_noticia = @pi_id_noticia 
   
      set @po_c_error = @@error     
      if (@po_c_error  <> 0) 
        begin     
          set @po_d_error = 'Error al intentar modificar la noticia' 
      end  
   
end -- sp_baja_noticia 
 
go 

Grant Execute on dbo.sp_baja_noticia to GrpTrpSabed 
go

sp_procxmode 'sp_baja_noticia', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_baja_tipo_beca'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_baja_tipo_beca" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_baja_tipo_beca (     
@pi_id_tipo_beca	numeric(18,0),   
@pi_f_baja              varchar(19),  
@pi_id_usuario          numeric(18,0),   
@po_c_error             typ_c_error output,   
@po_d_error             typ_d_error output   
)   
   
as   
--Objetivo: Dar de baja un tipo de beca  
   
begin   
      
  if (@pi_id_usuario is null or @pi_id_usuario = 0)   
    begin   
      set @po_c_error = 3   
      set @po_d_error = 'No se recibi? usuario '   
      return          
  end   
   
  if (@pi_id_tipo_beca is null or @pi_id_tipo_beca = 0)   
    begin   
      set @po_c_error = 3   
      set @po_d_error = 'No se recibi? el detalle de la beca'   
      return          
  end   
   
  if (@pi_f_baja is null)   
    begin   
      set @po_c_error = 3   
      set @po_d_error = 'No se recibi? la fecha de baja'   
      return          
  end  
  
  if exists (select id_tipo_beca
               from saat_tipo_beca
              where id_tipo_beca = @pi_id_tipo_beca
                and f_baja is not null 
             )         
  begin
      set @po_c_error = 2     
      set @po_d_error = 'El tipo de Beca ha sido dado de Baja. '
      return            
  end   
    
  declare    
  @f_baja datetime   
          
  set @po_c_error = 0        
  set @po_d_error = null        
        
  --convierto el varchar de entrada a date para el insert en la tabla        
     
  execute sp_convierte_char_en_fecha @pi_fecha_char     = @pi_f_baja,       
                                     @po_fecha_datetime = @f_baja output,        
                                     @po_c_error        = @po_c_error output,        
                                     @po_d_error        = @po_d_error output        
  if (@po_c_error  <> 0)        
    begin        
	  set @po_d_error = 'Error llamando a sp_convierte_char_en_fecha : ' + @po_d_error	
      return               
  end         
         
  -- doy de baja         
  Update saat_tipo_beca    
     set f_baja = @f_baja       
   where id_tipo_beca = @pi_id_tipo_beca   
           
  set @po_c_error = @@error       
  if (@po_c_error  <> 0)   
    begin    
      set @po_d_error = 'Error al intentar dar de baja'   
  end   
     
end  -- sp_baja_tipo_beca
 
go 

Grant Execute on dbo.sp_baja_tipo_beca to GrpTrpSabed 
go

sp_procxmode 'sp_baja_tipo_beca', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_bec_asignados_a_tutor'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_bec_asignados_a_tutor" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_bec_asignados_a_tutor(
@pi_id_tutor  numeric(18,0),
@pi_id_perfil numeric(18,0),
@po_c_error   typ_c_error output,
@po_d_error   typ_d_error output
)
as

/*Obtener lista de Becarios asignados a un Tutor
Objetivo: este servicio obtiene el listado de becarios que tiene asignado un 
Tutor Adm o Ped. Este listado permitir? reasignar esos becarios a otro tutor; 
Descripci?n de par?metros
Par?metros de entrada:
Par?metros de Salida
 Lista de Becarios: ID de becario y Nombre y Apellido 
*/

begin

  if (@pi_id_tutor is null or @pi_id_tutor = 0)
    begin
      set @po_c_error = 3
      set @po_d_error = 'No se recibi? pi_id_tutor'
      return       
  end

  if (@pi_id_perfil is null or @pi_id_perfil = 0)
    begin
      set @po_c_error = 3
      set @po_d_error = 'No se recibi? pi_id_perfil'
      return       
  end

  declare @e_BECADO varchar(15)

  set @po_c_error = 0
  set @po_d_error = null
  set @e_BECADO = 'BECADO'

  select alt.id_alumno, p.d_apellido + ', ' + p.d_nombre nombre_completo, al.id_tipo_beca, tb.d_tipo_beca
  from sagt_personas p, saat_alumnos al, sagt_alumnos_tutores alt, saat_tipo_beca tb
  where al.id_persona = p.id_persona
    and al.id_alumno = alt.id_alumno
    and al.e_alumno = @e_BECADO
    and alt.id_tutor = @pi_id_tutor
    and alt.id_perfil = @pi_id_perfil
    and al.id_tipo_beca = tb.id_tipo_beca
  
  set @po_c_error = @@error    
  if (@po_c_error  <> 0)
    begin 
      set @po_d_error =  convert(varchar,@po_c_error) 
                         + ' - Error al obtener becados asignados a un tutor. '
  end
  
end --sp_bec_asignados_a_tutor
 
go 

Grant Execute on dbo.sp_bec_asignados_a_tutor to GrpTrpSabed 
go

sp_procxmode 'sp_bec_asignados_a_tutor', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_becas_disp_xtipo_ong'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_becas_disp_xtipo_ong" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_becas_disp_xtipo_ong( 
@pi_id_usuario           numeric(18,0), 
@pi_id_ong               numeric(18,0), 
@po_c_error              typ_c_error output, 
@po_d_error              typ_d_error output 
) 
as 
/* 
Objetivo: informa para la ong; cuantas becas consumidas por tipo tiene 
*/ 
 
begin 
 
  if (@pi_id_usuario is null or @pi_id_usuario = 0)
    begin 
      set @po_c_error = 3
      set @po_d_error = 'No se recibi? pi_id_usuario' 
      return        
  end 
 
  if (@pi_id_ong is null or @pi_id_ong = 0)
    begin 
      set @po_c_error = 3
      set @po_d_error = 'No se recibi? pi_id_ong' 
      return        
  end 
   
    -- obtengo la cantidad de x tipo becados de la ong en cuestion 
  select tbeca.id_tipo_beca,
         tbeca.d_tipo_beca,
         count(distinct(a.id_alumno)) n_cant_becas 
    from saat_alumnos a, 
         sagt_alumnos_tutores sat, 
         saft_tutores st, 
         saat_tipo_beca tbeca 
   where tbeca.id_tipo_beca = a.id_tipo_beca 
     and st.id_ong = @pi_id_ong   
     and st.id_tutor = sat.id_tutor    
     and sat.id_alumno = a.id_alumno 
     and a.e_alumno in ('BECADO', 'POSTULANTE', 'SUSPENDIDO') 
   group by tbeca.id_tipo_beca,tbeca.d_tipo_beca  
     
  set @po_c_error = @@error     
  if (@po_c_error  <> 0) 
  begin  
      set @po_d_error =  convert(varchar,@po_c_error)  
                         + ' - Error al obtener la cantidad de becas de la ong: ' + 
                         convert (varchar,@pi_id_ong) 
      return 
  end 
   
 end -- sp_becas_disp_xtipo_ong
 
go 

Grant Execute on dbo.sp_becas_disp_xtipo_ong to GrpTrpSabed 
go

sp_procxmode 'sp_becas_disp_xtipo_ong', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_becas_disponibles_ong'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_becas_disponibles_ong" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_becas_disponibles_ong( 
@pi_id_usuario           numeric(18,0), 
@pi_id_ong               numeric(18,0), 
@po_d_nombre_ong         varchar(40) output, 
@po_q_becas_disponibles  int         output, 
@po_c_error              typ_c_error output, 
@po_d_error              typ_d_error output 
) 
as 
/* 
Objetivo: informa para la ong; cuantas becas disponibles tiene 
*/ 
 
begin 
 
  if (@pi_id_usuario is null or @pi_id_usuario = 0)
    begin 
      set @po_c_error = 3
      set @po_d_error = 'No se recibi? pi_id_usuario' 
      return        
  end 
 
  if (@pi_id_ong is null or @pi_id_ong = 0)
    begin 
      set @po_c_error = 3
      set @po_d_error = 'No se recibi? pi_id_ong' 
      return        
  end 
 
  declare  
    @q_becas       int, 
    @q_becados     int 
     
  -- obtengo la cantidad de becas disponibles para otorgar de la ong   
  select @q_becas = q_becas 
    from saft_ongs 
   where id_ong = @pi_id_ong  
 
  set @po_c_error = @@error     
 
  if (@po_c_error  <> 0) 
  begin  
      set @po_d_error =  convert(varchar,@po_c_error)  
                         + ' - Error al obtener las becas disponibles de la ong: ' + 
                         convert (varchar,@pi_id_ong) 
      return 
  end 
   
    -- obtengo la cantidad de becados de la ong en cuestion 
  select @q_becados = count(distinct(a.id_alumno)) 
    from saat_alumnos a, 
         sagt_alumnos_tutores sat, 
         saft_tutores st 
   where st.id_ong = @pi_id_ong   
     and st.id_tutor = sat.id_tutor    
     and sat.id_alumno = a.id_alumno 
     and a.e_alumno in ('BECADO', 'POSTULANTE', 'SUSPENDIDO') 
     
 
  set @po_c_error = @@error     
 
  if (@po_c_error  <> 0) 
  begin  
      set @po_d_error =  convert(varchar,@po_c_error)  
                         + ' - Error al obtener la cantidad de becados de la ong: ' + 
                         convert (varchar,@pi_id_ong) 
      return 
  end 
   
  set @po_q_becas_disponibles = @q_becas - @q_becados 
   
end --sp_becas_disponibles_ong
 
go 

Grant Execute on dbo.sp_becas_disponibles_ong to GrpTrpSabed 
go

sp_procxmode 'sp_becas_disponibles_ong', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_borra_per_eval_acad'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_borra_per_eval_acad" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_borra_per_eval_acad (   
@pi_id_periodo	        numeric(18,0),   
@po_c_error      typ_c_error output,   
@po_d_error      typ_d_error output   
)   
as   
-------------------------------------------------------------------   
--Objetivo: Elimina un periodo de rendicion evaluacion academica  
--Par?metros de salida:    
--po_c_error y po_d_error   
-------------------------------------------------------------------   
   
begin   
  declare   
    @estado varchar(1) 
     
      
  set @po_c_error = 0   
  set @po_d_error = null   
    
  If (@pi_id_periodo is null  or @pi_id_periodo = 0)
  begin       
    set @po_d_error = 'No se informo per?odo'   
    set @po_c_error = 3
    return   
  end  
        
      --    
      -- Verificamos que el estado del periodo se pueda modificar    
      execute sp_est_periodo_eval_acad    
                   @pi_id_periodo = @pi_id_periodo,     
                   @po_estado     = @estado   output,     
                   @po_c_error    = @po_c_error output,     
                   @po_d_error    = @po_d_error output       
      if (@po_c_error  <> 0)     
      begin    
		set @po_d_error = 'Error llamando a sp_est_periodo_eval_acad : ' + @po_d_error
        return         
      end    
    
      If @estado <> 'F'   
      begin    
        set @po_c_error = 2    
        set @po_d_error = 'No se puede utilizar el per?odo de evaluaci?n informado'    
        return    
      end   
        
      delete sact_periodos_eval_acad where id_periodo=@pi_id_periodo  
        
      set @po_c_error = @@error       
      if (@po_c_error  <> 0)   
      begin       
        set @po_d_error = 'Error al intentar eliminar el registro'   
        return   
      end  
	  
end --sp_borra_per_eval_acad
 
go 

Grant Execute on dbo.sp_borra_per_eval_acad to GrpTrpSabed 
go

sp_procxmode 'sp_borra_per_eval_acad', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_borra_per_recarga'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_borra_per_recarga" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_borra_per_recarga (   
@pi_id_periodo	 numeric(18,0),   
@po_c_error      typ_c_error output,   
@po_d_error      typ_d_error output   
)   
as   
-------------------------------------------------------------------   
--Objetivo: Elimina un periodo de recarga 
--Par?metros de salida:    
--po_c_error y po_d_error   
-------------------------------------------------------------------   
   
begin   
  declare   
    @estado varchar(1) 
     
      
  set @po_c_error = 0   
  set @po_d_error = null   
    
  If (@pi_id_periodo is null  or @pi_id_periodo = 0)
  begin       
    set @po_d_error = 'No se informo per?odo'   
    set @po_c_error = 3
    return   
  end  
        
      --    
      -- Verificamos que el estado del periodo se pueda modificar    
      execute sp_est_periodo_recarga 
                   @pi_id_periodo = @pi_id_periodo,     
                   @po_estado     = @estado   output,     
                   @po_c_error    = @po_c_error output,     
                   @po_d_error    = @po_d_error output       
      if (@po_c_error  <> 0)     
      begin    
		set @po_d_error = 'Error llamando a sp_est_periodo_recarga : ' + @po_d_error
        return         
      end    
    
      If @estado <> 'F'   
      begin    
        set @po_c_error = 2    
        set @po_d_error = 'No se puede utilizar el per?odo informado'    
        return    
      end   
        
      delete sact_periodos_recargas where id_periodo_recarga = @pi_id_periodo  
        
      set @po_c_error = @@error       
      if (@po_c_error  <> 0)   
      begin       
        set @po_d_error = 'Error al intentar eliminar el registro'   
        return   
      end  
	  
end --sp_borra_per_recarga
 
go 

Grant Execute on dbo.sp_borra_per_recarga to GrpTrpSabed 
go

sp_procxmode 'sp_borra_per_recarga', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_borra_per_rend_gastos'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_borra_per_rend_gastos" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_borra_per_rend_gastos (    
@pi_id_periodo	        numeric(18,0),   
@po_c_error      typ_c_error output,   
@po_d_error      typ_d_error output   
)   
as   
-------------------------------------------------------------------   
--Objetivo: Elimina un periodo de rendicion de gastos  
--Par?metros de salida:    
--po_c_error y po_d_error   
-------------------------------------------------------------------   
   
begin   
  declare   
    @estado varchar(1)  
      
  set @po_c_error = 0   
  set @po_d_error = null   
    
  If (@pi_id_periodo is null or @pi_id_periodo = 0)
  begin       
    set @po_d_error = 'No se informo per?odo'   
    set @po_c_error = 3   
    return   
  end  
        
      --    
      -- Verificamos que el estado del periodo se pueda modificar    
      execute sp_est_periodo_rend_gas    
                   @pi_id_periodo = @pi_id_periodo,     
                   @po_estado     = @estado   output,     
                   @po_c_error    = @po_c_error output,     
                   @po_d_error    = @po_d_error output       
      if (@po_c_error  <> 0)     
      begin    
		set @po_d_error = 'Error llamando a sp_est_periodo_rend_gas : ' + @po_d_error 
        return         
      end    
    
      If @estado <> 'F'   
      begin    
        set @po_c_error = 2   
        set @po_d_error = 'No se puede utilizar el per?odo de rendicion informado'    
        return    
      end  
        
      delete sact_periodos_rendicion where id_periodo=@pi_id_periodo  
        
      set @po_c_error = @@error       
      if (@po_c_error  <> 0)   
      begin       
        set @po_d_error = 'Error al intentar eliminar el registro'    
        return   
      end  
	  
end --sp_borra_per_rend_gastos
 
go 

Grant Execute on dbo.sp_borra_per_rend_gastos to GrpTrpSabed 
go

sp_procxmode 'sp_borra_per_rend_gastos', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_candidatos_en_ga'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_candidatos_en_ga" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_candidatos_en_ga( 
@pi_anio      int, 
@pi_id_tutor  numeric(18,0), 
@pi_id_ong    numeric(18,0), 
@po_c_error   typ_c_error   output, 
@po_d_error   typ_d_error   output 
) 
as 
-- 
--objetivo: obtener los candidatos que se encuentran en Guardar Avance 
-- 
 
begin 
 
  set @po_c_error = 0 
  set @po_d_error = null 
   
  if @pi_id_tutor = 0  
      set @pi_id_tutor = null 
       
  if @pi_id_ong = 0  
      set @pi_id_ong = null 
 
  select saatalu.id_persona_alu id_persona, 
         saatalu.id_alumno,     
         saatalu.f_nacimiento,             
         (select id_tutor 
            from saav_alu_tut_ong 
           where id_alumno = saatalu.id_alumno 
             and id_perfil_tutor = 1 
             and e_registro_tut = 'D' 
         )  id_tutor_adm, 
         (select id_tutor 
            from saav_alu_tut_ong 
           where id_alumno = saatalu.id_alumno 
             and id_perfil_tutor = 2 
             and e_registro_tut = 'D' 
         )  id_tutor_ped, 
         saatalu.id_ong, 
         saatalu.d_apellido_alu + ', '+ saatalu.d_nombre_alu  apenom 
    from saav_alu_tut_ong saatalu          
   where saatalu.e_alumno = 'CANDIDATO' 
     and saatalu.e_registro_alu = 'A' 
     and saatalu.e_registro_tut = 'D' 
     and saatalu.e_registro_per = 'D' 
     and saatalu.e_registro_ong = 'D' 
     and saatalu.id_tutor = isnull(@pi_id_tutor, saatalu.id_tutor) 
     and saatalu.id_ong = isnull(@pi_id_ong, saatalu.id_ong) 
     and datepart(yy,isnull(saatalu.f_actuac,saatalu.f_alta)) = @pi_anio 
 
  set @po_c_error = @@error     
  if (@po_c_error  <> 0) 
    begin  
      set @po_d_error =  'Error en sp_candidatos_en_ga. ' 
  end 
  
end --sp_candidatos_en_ga
 
go 

Grant Execute on dbo.sp_candidatos_en_ga to GrpTrpSabed 
go

sp_procxmode 'sp_candidatos_en_ga', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_complete_alumnos_recargas'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_complete_alumnos_recargas" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_complete_alumnos_recargas(    
-- drop  procedure sp_complete_alumnos_recargas
       
        @pi_id_usuario      numeric(18,0),           
        @pi_id_tutor        numeric(18,0),           
        @pi_id_ong          numeric(18,0),           
        @pi_id_periodo_rec  numeric(18,0),           
        @pi_origen          varchar(15),  -- --BECARIOS - RECARGAS          
        @po_id_lote_recarga numeric(18,0) output,            
        @po_inserta         varchar(1)  output,           
        @po_confirma        varchar(1)  output,           
        @po_al_pago         varchar(1)  output,       
        @po_c_error         typ_c_error output,           
        @po_d_error         typ_d_error output           
)           
as
           
/*           
Objetivo: Levanta los registros para la seleccion de las recargas de tarjetas           
*/           
           
begin

CREATE TABLE #tmp_tabla_pre_alumnos (

        id_lote_det_recarga  numeric(18,0) null,        
        id_tutor             numeric(18,0) null,     
        id_alumno            numeric(18,0) null,     
        id_persona           numeric(18,0) null,     
        apenom               varchar(200)  null

)

CREATE TABLE #tmp_tabla_post_alumnos (

      id_alumno            numeric(18,0) null,   
      
      id_tutor             numeric(18,0) null,     
      
      id_persona           numeric(18,0) null,     
      
      apenom               varchar(200)  null,      

      id_periodo_recarga   numeric(18,0) null,       

      id_lote_det_recarga  numeric(18,0) null,       

      id_usuario           numeric(18,0) null,           

      saldo                varchar(18)   null,       

      supero               varchar(1)    null,       

      estado_sit_acad      varchar(30)   null,       

      sn                   varchar(15)   null, 

      f_ult_recarga        varchar(12)   null,       

      id_periodo_sit_acad  numeric(18,0) null,       

      id_periodo_rendicion numeric(18,0) null,    

      observacion          varchar(250)  null,   

      m_error_val          varchar(1)    null,

      error_val_mensaje               varchar(200)  null
)

  print "Datos cursor sp_consulta_alumnos_recargas : %1! / %2! / %3! /pi_id_periodo_rec=> %4! /pi_origen=> %5! " , 
              @pi_id_usuario,        
              @pi_id_tutor,                                          
              @pi_id_ong,
              @pi_id_periodo_rec,      
              @pi_origen

execute sp_consulta_alumnos_recargas 
                               
                      @pi_id_usuario      = @pi_id_usuario,           
                      @pi_id_tutor        = @pi_id_tutor,           
                      @pi_id_ong          = @pi_id_ong,           
                      @pi_id_periodo_rec  = @pi_id_periodo_rec,           
                      @pi_origen          = @pi_origen,  -- --BECARIOS - RECARGAS          
                      @po_id_lote_recarga = @po_id_lote_recarga output,            
                      @po_inserta         = @po_inserta output,           
                      @po_confirma        = @po_confirma output,           
                      @po_al_pago         = @po_al_pago output,       
                      @po_c_error         = @po_c_error output,
                      @po_d_error         = @po_d_error output 



--print "ejecuto sp_consulta_alumnos_recargas"

declare     @var_id_lote_det_recarga numeric(18,0) ,    
            
            @var_id_tutor            numeric(18,0),     
            
            @var_id_alumno           numeric(18,0),     
            
            @var_id_persona          numeric(18,0),     

            @var_apenom              varchar(200),

            @var_saldo                varchar(18)   ,       

            @var_supero               varchar(1)    ,       

            @var_estado_sit_acad      varchar(30)   ,       

            @var_sn                   varchar(15)   , 

            @var_f_ult_recarga        varchar(12)   ,       

            @var_id_periodo_sit_acad  numeric(18,0) ,       

            @var_id_periodo_rendicion numeric(18,0) ,    

            @var_observacion          varchar(250)  ,   

            @var_m_error_val          varchar(1)    ,      

            @var_error_val_mensaje    typ_d_error   



--print "Inicia cursor tmp_tabla_pre_alumnos"

declare curs cursor for 

SELECT  #tmp_tabla_pre_alumnos.id_lote_det_recarga, 
        #tmp_tabla_pre_alumnos.id_tutor, 
        #tmp_tabla_pre_alumnos.id_alumno, 
        #tmp_tabla_pre_alumnos.id_persona, 
        #tmp_tabla_pre_alumnos.apenom 
FROM #tmp_tabla_pre_alumnos

/* open the cursor */
open curs

/* fetch the first row */
fetch curs into @var_id_lote_det_recarga ,    
            
            @var_id_tutor  ,     
            
            @var_id_alumno ,     
            
            @var_id_persona ,     

            @var_apenom  

/* now loop, processing all the rows
** @@sqlstatus = 0 means successful fetch
** @@sqlstatus = 1 means error on previous fetch
** @@sqlstatus = 2 means end of result set reached
*/

--print "@@sqlstatus_init ===> %1!", @@sqlstatus

while (@@sqlstatus != 2)
begin  

 /* check for errors */
    if (@@sqlstatus = 1)
    begin

      print "error en cursor"

      set @po_c_error = 3          
      set @po_d_error = 'Error al ejecutar el cursor'     
      return
    end

 
    print "Datos cursor sp_alumnos_recargas : %1! / %2! / %3! / %4! / %5! " , 
              @var_id_alumno,        
              @pi_id_periodo_rec,                                          
              @po_id_lote_recarga,
              @pi_id_tutor,      
              @pi_id_usuario



 
    execute sp_alumnos_recargas     

                      @pi_id_alumno            = @var_id_alumno ,         

                      @pi_id_periodo_recarga   = @pi_id_periodo_rec,       

                      @pi_id_lote_det_recarga  = @var_id_lote_det_recarga, --@po_id_lote_recarga,      

                      @pi_id_tutor             = @pi_id_tutor ,           

                      @pi_id_usuario           = @pi_id_usuario ,           

                      @po_saldo                = @var_saldo output,       

                      @po_supero               = @var_supero output,       

                      @po_estado_sit_acad      = @var_estado_sit_acad output,           

                      @po_sn                   = @var_sn output,

                      @po_f_ult_recarga        = @var_f_ult_recarga output,

                      @po_id_periodo_sit_acad  = @var_id_periodo_sit_acad output,      

                      @po_id_periodo_rendicion = @var_id_periodo_rendicion output,      

                      @po_observacion          = @var_observacion output,      

                      @po_m_error_val          = @var_m_error_val output,      

                      @po_error_val_mensaje    = @var_error_val_mensaje output,      

                      @po_c_error              = @po_c_error output,      

                      @po_d_error              = @po_d_error output



     print "Datos as  insertar tmp_tabla_post_alumnos : %1! / %2! / %3! /@var_sn =  %4! / %5! / %6! / %7! /@var_observacion = %8! / %9! / %10! " , 
                       
              @var_saldo                

              ,@var_supero               

              ,@var_estado_sit_acad      

              ,@var_sn                   

              ,@var_f_ult_recarga        

              ,@var_id_periodo_sit_acad  

              ,@var_id_periodo_rendicion 

              ,@var_observacion          

              ,@var_m_error_val

              ,@var_error_val_mensaje



    INSERT INTO #tmp_tabla_post_alumnos
                (  id_alumno  
                  
                  ,id_tutor  
                  
                  ,id_persona 
                  
                  ,apenom 

                  ,id_periodo_recarga 

                  ,id_lote_det_recarga

                  ,id_usuario         

                  ,saldo              

                  ,supero             

                  ,estado_sit_acad    

                  ,sn                 

                  ,f_ult_recarga      

                  ,id_periodo_sit_acad

                  ,id_periodo_rendicion

                  ,observacion             

                  ,m_error_val    

                  ,error_val_mensaje         

            )
      values(
           @var_id_alumno     
          
          ,@var_id_tutor  
          
          ,@var_id_persona 
          
          ,@var_apenom

          ,@pi_id_periodo_rec  

          ,@po_id_lote_recarga  

          ,@pi_id_usuario           

          ,@var_saldo                

          ,@var_supero               

          ,@var_estado_sit_acad      

          ,@var_sn                   

          ,@var_f_ult_recarga        

          ,@var_id_periodo_sit_acad  

          ,@var_id_periodo_rendicion 

          ,@var_observacion          

          ,@var_m_error_val

          ,@var_error_val_mensaje
      )
    


    /* fetch the next row */
    fetch curs into @var_id_lote_det_recarga ,    
            
            @var_id_tutor  ,     
            
            @var_id_alumno ,     
            
            @var_id_persona ,     

            @var_apenom  


    --print "@@sqlstatus_fin ===> %1!", @@sqlstatus

end
/* close the cursor and return */
close curs


--print "DROP tmp_tabla_pre_alumnos"

 DROP TABLE #tmp_tabla_pre_alumnos

/* Adaptive Server has expanded all '*' elements in the following statement */ 

--print "SELECT tmp_tabla_post_alumnos"

--declare cursor_consulta cursor for 

      SELECT  #tmp_tabla_post_alumnos.id_alumno, 
              #tmp_tabla_post_alumnos.id_tutor, 
              #tmp_tabla_post_alumnos.id_persona, 
              #tmp_tabla_post_alumnos.apenom, 
              #tmp_tabla_post_alumnos.id_periodo_recarga, 
              #tmp_tabla_post_alumnos.id_lote_det_recarga, 
              #tmp_tabla_post_alumnos.id_usuario, 
              #tmp_tabla_post_alumnos.saldo, 
              #tmp_tabla_post_alumnos.supero, 
              #tmp_tabla_post_alumnos.estado_sit_acad, 
              #tmp_tabla_post_alumnos.sn,
              #tmp_tabla_post_alumnos.f_ult_recarga, 
              #tmp_tabla_post_alumnos.id_periodo_sit_acad, 
              #tmp_tabla_post_alumnos.id_periodo_rendicion, 
              #tmp_tabla_post_alumnos.observacion, 
              #tmp_tabla_post_alumnos.m_error_val, 
              #tmp_tabla_post_alumnos.error_val_mensaje 
      FROM #tmp_tabla_post_alumnos

--open cursor_consulta

end
 
go 

Grant Execute on dbo.sp_complete_alumnos_recargas to GrpTrpSabed 
go

sp_procxmode 'sp_complete_alumnos_recargas', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_conceptos_rendicion'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_conceptos_rendicion" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_conceptos_rendicion (
-- drop procedure sp_conceptos_rendicion
@po_c_error       typ_c_error output,
@po_d_error       typ_d_error output
)

as
-- Objetivo: Listar los conceptos de rendicion de gastos
--

begin

  --
  -- Traigo los datos
  select id_parametro,d_valor from sapt_parametros
  Where d_valor !='#OTROS#'
    and id_tabla = 9
  order by d_valor

  set @po_c_error = @@error    
  if (@po_c_error  <> 0)
    begin 
      set @po_d_error =  convert(varchar,@po_c_error) 
                         + ' - Error al intentar obtener conceptos de rendicion de gastos. '
      return
  end  

end  -- sp_conceptos_rendicion
 
go 

Grant Execute on dbo.sp_conceptos_rendicion to GrpTrpSabed 
go

sp_procxmode 'sp_conceptos_rendicion', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_confirma_recargas'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_confirma_recargas" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_confirma_recargas( 
@pi_id_usuario          numeric(18,0),   
@pi_id_lote             numeric(18,0),   
@pi_f_oper_coordinador  varchar(20),      
@pi_l_alu               typ_lista,      
@po_c_error             typ_c_error output,   
@po_d_error             typ_d_error output   
)   
as   
/*   
Objetivo: inserta los lotes de recargas con alumnos   
@pi_l_alu es de la forma:    
@id_alu_tar:@e_alumno:@q_recargas:@id_tipo_beca:@x_observacion   
*/   
   
begin   
   
  if @pi_id_usuario is null or @pi_id_usuario=0
    begin   
      set @po_c_error = 3   
      set @po_d_error = 'No se recibi? pi_id_usuario'   
      return          
  end   
  
    if @pi_id_lote is null or @pi_id_lote=0
    begin   
      set @po_c_error = 3   
      set @po_d_error = 'No se recibi? pi_id_lote'   
      return          
  end  
  if @pi_f_oper_coordinador is null
    begin   
      set @po_c_error = 3   
      set @po_d_error = 'No se recibi? pi_f_oper_coordinador'   
      return          
  end  
  if @pi_l_alu is null 
    begin   
      set @po_c_error = 3   
      set @po_d_error = 'No se recibi? pi_l_alu'
      return          
  end  
   
  declare @f_oper_coordinador  datetime,   
          @f_oper_eq_becas     datetime,   
          @f_oper_sup_eq_becas datetime   
   
  set @po_c_error = 0   
  set @po_d_error = null   
      
  --convierto el varchar de entrada a date    
  execute sp_convierte_char_en_fecha @pi_fecha_char     = @pi_f_oper_coordinador,   
                                     @po_fecha_datetime = @f_oper_coordinador output,   
                                     @po_c_error        = @po_c_error  output,   
                                     @po_d_error        = @po_d_error  output   
                              
  if (@po_c_error  <> 0)    
  begin   
    set @po_d_error =  'Error en sp_convierte_char_en_fecha: ' +  @po_d_error   
    return     
  end   
  
  If exists (select 1 
               from sart_lotes_recarga
              where id_lote_recarga = @pi_id_lote
                and c_estado_lote   = 'EN_REVISION')
    begin 
    
      begin tran recargas  
     
      --updateo el usuario que revisa la recarga por SI o por NO   
      update sart_lotes_recarga   
      set   c_estado_lote       = 'CONFIRMADO',   
            id_coordinador      = @pi_id_usuario,   
            f_oper_coordinador  = @f_oper_coordinador,   
            c_usua_actuac       = @pi_id_usuario,   
            f_actuac            = getDate()   
      where id_lote_recarga = @pi_id_lote   
     
      set @po_c_error = @@error     
      if (@po_c_error  <> 0)    
        begin   
          rollback tran recargas    
          set @po_d_error =  'Error al actualizar lote de recargas. '   
          return     
      end     
   
      execute sp_inserta_det_recarga   
        @pi_id_usuario      = @pi_id_usuario,   
        @pi_id_lote         = @pi_id_lote,   
        @pi_l_alu           = @pi_l_alu,   
        @pi_valida          = 'N',
        @po_c_error         = @po_c_error  output,   
        @po_d_error         = @po_d_error  output   
       
      if (@po_c_error  <> 0)    
      begin   
          set @po_d_error =  'Error en sp_inserta_det_recarga: ' +  @po_d_error 
          rollback tran recargas    
          return     
      end   
         
      commit tran recargas
      
  end
  else
    begin
      set @po_c_error = 3   
      set @po_d_error = 'El lote no esta en estado EN_REVISION'
      return 
  end
end -- sp_confirma_recargas
 
go 

Grant Execute on dbo.sp_confirma_recargas to GrpTrpSabed 
go

sp_procxmode 'sp_confirma_recargas', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_cons_alumnos_estados'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_cons_alumnos_estados" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_cons_alumnos_estados(     
@pi_anio      int,   
@pi_id_tutor  numeric(18,0),   
@pi_id_ong    numeric(18,0),   
@pi_estado    varchar(15), 
@po_c_error   typ_c_error   output,   
@po_d_error   typ_d_error   output   
)   
as   
--   
--objetivo: Listar los alumnos con un estado predeterminado  
--   
   
begin   
   
  set @po_c_error = 0   
  set @po_d_error = null   
     
  if @pi_id_tutor = 0    
      set @pi_id_tutor = null   
         
  if @pi_id_ong = 0    
      set @pi_id_ong = null   
       
  if @pi_estado is null 
    begin    
      set @po_d_error =  'No se informo el estado a buscar'   
      set @po_c_error = 3   
      return 
  end  
   
-- Alumnos  
Select distinct alu.id_persona,  
       alu.id_alumno,  
       per.f_nacimiento,  
       null id_tutor_adm, -- no hace falta hasta ahora 
       null id_tutor_ped, -- no hace falta hasta ahora       
       tut.id_ong,  
       per.d_apellido + ', '+ per.d_nombre apenom  
  from sagt_alumnos_tutores alutut,  
       saat_alumnos alu,  
       saft_tutores tut,  
       sagt_personas per  
 where (tut.id_tutor = @pi_id_tutor or @pi_id_tutor is null)  
   and (tut.id_ong = @pi_id_ong or @pi_id_ong is null)  
   and tut.id_tutor = alutut.id_tutor  
   and per.id_persona = alu.id_persona  
   and alutut.id_alumno = alu.id_alumno  
   and alu.e_alumno = @pi_estado 
 order by per.d_apellido + ', '+ per.d_nombre  
   
  set @po_c_error = @@error       
  if (@po_c_error  <> 0)   
    begin    
      set @po_d_error =  'Error en sp_cons_alumnos_estados. '   
  end   
    
end -- sp_cons_alumnos_estados
 
go 

Grant Execute on dbo.sp_cons_alumnos_estados to GrpTrpSabed 
go

sp_procxmode 'sp_cons_alumnos_estados', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_cons_becado_tut_administra'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_cons_becado_tut_administra" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_cons_becado_tut_administra(
 @pi_id_usuario          numeric(18,0), 
 @pi_c_tpo_doc           numeric(18,0),      
 @pi_n_documento         numeric(18,0), 
 @pi_apellido            varchar(40), 
 @pi_nombre              varchar(40), 
 @po_c_error             typ_c_error output, 
 @po_d_error             typ_d_error output   
) 
as 
 
--objetivo: consultar por filtros una persona becada,
--por tipo y nro de documento o por nombre y apellido 
 
begin 
 
  if (@pi_id_usuario  is null or @pi_id_usuario = 0) 
    begin 
      set @po_c_error = 3
      set @po_d_error = 'No se recibi? usuario' 
      return        
    end 
   
  set @po_c_error = 0 
  set @po_d_error = null 

  declare 
   @id_ong      numeric(18,0),
   @m_fundacion char(1),
   @id_perfil   numeric(18,0),
   @cant_filas  int

  execute sp_obtiene_prfl_adm @po_id_perfil = @id_perfil output,
                              @po_c_error   = @po_c_error output,
                              @po_d_error   = @po_d_error output
                               
  if (@po_c_error  <> 0) 
	begin
		set @po_d_error = 'Error llamando a sp_obtiene_prfl_adm : ' + @po_d_error
		return       
	end
  
  execute sp_obtiene_ong_usu  @pi_id_usuario = @pi_id_usuario,
                              @pi_id_perfil  = @id_perfil,
                              @po_id_ong     = @id_ong     output,
                              @po_c_error    = @po_c_error output,
                              @po_d_error    = @po_d_error output
                               
  if (@po_c_error  <> 0) 
 	begin
		set @po_d_error = 'Error llamando a sp_obtiene_ong_usu : ' + @po_d_error
		return       
	end 

  select distinct 
         p.id_persona, 
         p.c_documento, 
         pa.d_valor desc_documento, 
         p.n_documento, 
         p.d_apellido, 
         p.d_nombre, 
         p.d_cuil, 
         p.f_nacimiento, 
         p.c_nacionalidad, 
         p.c_ocupacion, 
         p.c_estado_civil, 
         p.d_mail, 
         p.c_provincia, 
         p.d_localidad, 
         p.d_calle, 
         p.d_nro, 
         p.d_piso, 
         p.d_depto,          
         p.c_sexo, 
         p.e_registro,
         null m_edita -- se puso solo para que queden todos iguales           
    from sagt_personas p, 
         sapt_parametros pa,
         saat_alumnos alu,
         sagt_alumnos_tutores alutut,
         saft_tutores tut
   where (    (p.c_documento    = @pi_c_tpo_doc or @pi_c_tpo_doc is null)      
          and (p.n_documento    = @pi_n_documento or @pi_n_documento is null)
          and (p.d_apellido     = @pi_apellido or @pi_apellido is null)
          and (p.d_nombre       = @pi_nombre or  @pi_nombre is null)
         ) 
     and p.c_documento = pa.id_parametro 
     and alu.id_persona = p.id_persona
     and alutut.id_alumno = alu.id_alumno
     and alutut.id_tutor = tut.id_tutor  
     and alu.e_alumno ='BECADO'
     and (tut.id_ong = @id_ong or @id_ong is null)
     and p.e_registro = 'D'
     and alu.e_registro = 'D'
     and tut.e_registro = 'D'

  set @po_c_error = @@error,
      @cant_filas = @@rowcount

  if (@po_c_error  <> 0)
    begin 
      set @po_d_error =  convert(varchar,@po_c_error) 
                         + ' - Error al consultar por filtros de becado. '
      return
  end  
          
  if (@cant_filas = 0) 
    begin 
      set @po_c_error = 1
      set @po_d_error = 'No se encontraron datos. ' 
      return       
    end 
 
end -- sp_cons_becado_tut_administra
 
go 

Grant Execute on dbo.sp_cons_becado_tut_administra to GrpTrpSabed 
go

sp_procxmode 'sp_cons_becado_tut_administra', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_cons_becado_tut_pedagogico'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_cons_becado_tut_pedagogico" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_cons_becado_tut_pedagogico(
-- drop procedure sp_cons_becado_tut_pedagogico
 @pi_id_usuario          numeric(18,0), 
 @pi_c_tpo_doc           numeric(18,0),      
 @pi_n_documento         numeric(18,0), 
 @pi_apellido            varchar(40), 
 @pi_nombre              varchar(40), 
 @po_c_error             typ_c_error output, 
 @po_d_error             typ_d_error output 
) 
as 
 
--objetivo: consultar por filtros una persona para que sea un becado
--por tipo y nro de documento 
--o por nombre y apellido 
 
begin 
 
  if (@pi_id_usuario  is null or @pi_id_usuario = 0) 
    begin 
      set @po_c_error = 3
      set @po_d_error = 'No se recibi? usuario' 
      return        
    end 
   
  set @po_c_error = 0 
  set @po_d_error = null 

  declare 
   @id_ong      numeric(18,0),
   @m_fundacion char(1),
   @id_perfil   numeric(18,0),
   @cant_filas  int
  
  execute sp_obtiene_prfl_ped @po_id_perfil = @id_perfil output,
                              @po_c_error   = @po_c_error output,
                              @po_d_error   = @po_d_error output
                               
  if (@po_c_error <> 0) 
	begin
		set @po_d_error = 'Error llamando a sp_obtiene_prfl_ped : ' + @po_d_error
		return       
	end

  execute sp_obtiene_ong_usu  @pi_id_usuario = @pi_id_usuario,
                              @pi_id_perfil  = @id_perfil,
                              @po_id_ong     = @id_ong     output,
                              @po_c_error    = @po_c_error output,
                              @po_d_error    = @po_d_error output
                               
  if (@po_c_error  <> 0) 
 	begin
		set @po_d_error = 'Error llamando a sp_obtiene_ong_usu : ' + @po_d_error
		return       
	end 

  select distinct 
         p.id_persona, 
         p.c_documento, 
         pa.d_valor desc_documento, 
         p.n_documento, 
         p.d_apellido, 
         p.d_nombre, 
         p.d_cuil, 
         p.f_nacimiento, 
         p.c_nacionalidad, 
         p.c_ocupacion, 
         p.c_estado_civil, 
         p.d_mail, 
         p.c_provincia, 
         p.d_localidad, 
         p.d_calle, 
         p.d_nro, 
         p.d_piso, 
         p.d_depto,          
         p.c_sexo, 
         p.e_registro,
         null m_edita -- se puso solo para que queden todos iguales           
    from sagt_personas p, 
         sapt_parametros pa,
         saat_alumnos alu,
         sagt_alumnos_tutores alutut,
         saft_tutores tut
   where (    (p.c_documento    = @pi_c_tpo_doc or @pi_c_tpo_doc is null)      
          and (p.n_documento    = @pi_n_documento or @pi_n_documento is null)
          and (p.d_apellido     = @pi_apellido or @pi_apellido is null)
          and (p.d_nombre       = @pi_nombre or  @pi_nombre is null)
         ) 
     and p.c_documento = pa.id_parametro 
     and alu.id_persona = p.id_persona
     and alutut.id_alumno = alu.id_alumno
     and alutut.id_tutor = tut.id_tutor  
     and alu.e_alumno ='BECADO'
     and (tut.id_ong = @id_ong or @id_ong is null)
     and p.e_registro = 'D'
     and alu.e_registro = 'D'
     and tut.e_registro = 'D'     
          
 
  set @po_c_error = @@error,
      @cant_filas = @@rowcount
  
  if (@po_c_error  <> 0)
    begin 
      set @po_d_error =  convert(varchar,@po_c_error) 
                         + ' - Error al consultar por filtros de becado. '
      return
  end
  if (@cant_filas = 0) 
    begin 
      set @po_c_error = 1 
      set @po_d_error = 'No se encontraron datos. ' 
      return       
    end 
  
end -- sp_cons_becado_tut_pedagogico
 
go 

Grant Execute on dbo.sp_cons_becado_tut_pedagogico to GrpTrpSabed 
go

sp_procxmode 'sp_cons_becado_tut_pedagogico', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_cons_familia_programa'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_cons_familia_programa" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_cons_familia_programa ( 
-- drop procedure sp_cons_familia_programa 
@pi_personas              typ_lista, 
@po_programa              varchar(1) output, 
@po_c_error               typ_c_error output, 
@po_d_error               typ_d_error output 
) 
 
as 
--Objetivo: identificar si alguna de las personas informas  
--          son beneficiarios del programa de becas 
-- 
-- Parametros de entrada: 
--   pi_personas :String conteniendo la lista de personas. 
-- 
-- Parametro de Salida: 
--   po_programa : S/N    
 
begin 
 
  set @po_c_error   = 0 
  set @po_d_error   = ''   
  set @po_programa  ='N' 
 
  declare  
  @vpersonas   typ_lista, 
  @vid_persona numeric(18,0), 
  @sep         varchar(1), 
  @dummy       varchar(1) 
 
  execute sp_separador_registros 
             @po_separador_registro    = @sep        output, 
             @po_separador_campo       = @dummy      output, 
             @po_c_error               = @po_c_error output, 
             @po_d_error               = @po_d_error output              
  if (@po_c_error  <> 0) 
    begin 
	  set @po_d_error = 'Error llamando a sp_separador_registros : ' + @po_d_error	
      return     
  end 
 
 
  Set @vpersonas = @pi_personas+ @sep 
 
  while (@vpersonas is not null) 
  begin 
   
    set @vid_persona  = convert(numeric,substring(@vpersonas , 1,charindex(@sep,@vpersonas )-1)) 
 
    Select @po_programa='S' 
      from saat_alumnos 
     where id_persona = @vid_persona 
       and e_registro='D' 
       and f_baja is null 
       and e_alumno in ('BECADO','SUSPENDIDO') 
 
    set @po_c_error = @@error     
    if (@po_c_error  <> 0) 
    begin  
        set @po_d_error =  convert(varchar,@po_c_error)  
                         + ' - Error al buscar al alumno ' 
        return 
    end 
 
    if (@po_programa = 'S') 
    begin  
      return       
    end 
 
    set @vpersonas  = substring(@vpersonas,charindex(@sep,@vpersonas)+1, char_length(@vpersonas))                           
 
  end    --while 
 
end -- sp_cons_familia_programa
 
go 

Grant Execute on dbo.sp_cons_familia_programa to GrpTrpSabed 
go

sp_procxmode 'sp_cons_familia_programa', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_cons_familiartitular'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_cons_familiartitular" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_cons_familiartitular ( 
     @pi_id_usuario numeric(18,0), 
     @po_c_error    typ_c_error output, 
     @po_d_error    typ_d_error output 
) 
 
--Objetivo: Obtener la lista de parentescos v?lidos para titular de TJ 
 
as 
begin 
 
  if (@pi_id_usuario is null or @pi_id_usuario = 0) 
    begin 
      set @po_c_error = 3 
      set @po_d_error = 'No se recibi? pi_id_usuario' 
      return        
  end 
  
  declare 
      @id_tabla   numeric(18,0),
      @id_perfil  numeric(18,0),
      @e_definitivo varchar (1)
  
  set @po_c_error = 0 
  set @po_d_error = null 
  
  execute sp_obtiene_prfl_eqBecas 
           @po_id_perfil = @id_perfil output, 
           @po_c_error   = @po_c_error output, 
           @po_d_error   = @po_d_error output 
  if (@po_c_error  <> 0)       
    begin    
      set @po_d_error = 'Error llamando a sp_obtiene_prfl_eqBecas : ' + @po_d_error   
      return        
  end 
  
  execute sp_obtiene_e_definitivo @po_c_valor  = @e_definitivo output,    
                                  @po_c_error  = @po_c_error output,    
                                  @po_d_error  = @po_d_error output    
                                   
  if (@po_c_error  <> 0)    
    begin    
     set @po_d_error = 'Error llamando a sp_obtiene_e_definitivo : ' + @po_d_error   
     return           
  end
  
  If exists (Select 1
               from sast_usuarios_perfiles usu
              Where usu.id_usuario = @pi_id_usuario
                and usu.id_perfil = @id_perfil
                and e_usu_perfil = @e_definitivo)
    begin
      set @id_tabla=11 -- tabla de parentescos

       select id_parametro, id_parametro d_valor
         from sapt_parametros 
        where id_tabla = @id_tabla

  end
  else

    begin
      set @id_tabla = 21 -- tabla de parentescos para titular de tarjeta
 
       select d_valor id_parametro, d_valor
        from sapt_parametros 
       where id_tabla = @id_tabla

  end
     
 
end --sp_cons_familiartitular
 
go 

Grant Execute on dbo.sp_cons_familiartitular to GrpTrpSabed 
go

sp_procxmode 'sp_cons_familiartitular', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_cons_noticia_bienvenida'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_cons_noticia_bienvenida" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_cons_noticia_bienvenida (   
@po_c_error     	typ_c_error output,   
@po_d_error     	typ_d_error output   
)   
as   
-------------------------------------------------------------------   
--Objetivo: Obtener las noticias del sistema   
--Par?metros de entrada:  
--	ID_NOTICIA  
--Par?metros de salida:    
--      cursor con los valores las noticias    
--po_c_error y po_d_error   
-------------------------------------------------------------------    
begin   
   
  set @po_c_error = 0   
  set @po_d_error = null   
     
  select id_noticia, 
	     x_titulo,  
         x_copete,  
         x_cuerpo_mensaje, 
         convert(char(12),f_vigencia_desde,112) f_vigencia_desde, 
         convert(char(12),f_vigencia_hasta,112) f_vigencia_hasta 
    from saft_noticias  
   where f_vigencia_desde <= getDate()   
     and f_vigencia_hasta >= getDate() 
     and (f_baja is null or f_baja > getDate()) 
   order by f_vigencia_desde,f_vigencia_hasta 
 
  set @po_c_error = @@error      
  if (@po_c_error  <> 0)   
    begin     
      set @po_d_error = 'Error al consultar los noticias'         
  end   
   
end -- sp_cons_noticia_bienvenida
 
go 

Grant Execute on dbo.sp_cons_noticia_bienvenida to GrpTrpSabed 
go

sp_procxmode 'sp_cons_noticia_bienvenida', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_cons_per_no_vinculadas'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_cons_per_no_vinculadas" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_cons_per_no_vinculadas(  
 @pi_id_usuario          numeric(18,0),   
 @pi_c_tpo_doc           numeric(18,0),        
 @pi_n_documento         numeric(18,0),   
 @pi_apellido            varchar(40),   
 @pi_nombre              varchar(40),
 @po_c_error             typ_c_error output,   
 @po_d_error             typ_d_error output   
)   
as   
/*  
objetivo: consultar por filtros una persona que no sea TUTOR, ALUMNO y   
          PERSONAL de las ONG y FUNDACION por tipo y nro de documento ?  
          por nombre y apellido   
*/  
  
begin   
  
  if (@pi_id_usuario  is null or @pi_id_usuario =0)   
    begin   
      set @po_c_error = 3
      set @po_d_error = 'No se recibi? usuario'   
      return          
    end   
  
  declare @cant_filas int  
     
  set @po_c_error = 0   
  set @po_d_error = null   

  select distinct p.id_persona,   
         p.c_documento,   
         pa.d_valor desc_documento,   
         p.n_documento,   
         p.d_apellido,   
         p.d_nombre,   
         p.d_cuil,   
         p.f_nacimiento,   
         p.c_nacionalidad,   
         p.c_ocupacion,   
         p.c_estado_civil,   
         p.d_mail,   
         p.c_provincia,   
         p.d_localidad,   
         p.d_calle,   
         p.d_nro,   
         p.d_piso,   
         p.d_depto,            
         p.c_sexo,   
         p.e_registro,  
         null m_edita --para que quede igual q el resto  
  from sagt_personas p
  inner join sapt_parametros pa on p.c_documento = pa.id_parametro 
  where (             
          (p.c_documento    = @pi_c_tpo_doc or isnull(@pi_c_tpo_doc,0) = 0) and 
          (p.n_documento    = @pi_n_documento or isnull(@pi_n_documento,0) = 0) and 
          (upper(p.d_apellido)     like  '%' + upper(@pi_apellido) + '%' or @pi_apellido is null) and 
          (upper(p.d_nombre)       like  '%' + upper(@pi_nombre) + '%' or  @pi_nombre is null) 
          )  and   
          not exists (select 1 from saat_alumnos alu   
                      where alu.id_persona = p.id_persona   
                        and alu.e_registro = 'D'  
                        and alu.e_alumno in ( 'BECADO', 'POSTULANTE', 'SUSPENDIDO')) and              
          not exists (select 1 from sast_usuarios usu, sast_usuarios_perfiles uperf  
                      where usu.id_persona = p.id_persona   
                        and usu.id_usuario = uperf.id_usuario  
                        and usu.e_usuario = 'D'  
                        and uperf.e_usu_perfil = 'D'  
                        and uperf.id_perfil in (4,7)  
                      )and              
          not exists (select 1 from saft_tutores tut   
                      where tut.id_persona = p.id_persona   
                        and tut.e_registro = 'D') and    
          not exists (select 1 from saft_personas_ong perong   
                      where perong.id_persona = p.id_persona   
                        and perong.e_registro = 'D')   
    order by 3,4 
     
  set @po_c_error = @@error,  
      @cant_filas = @@rowcount  
  
  if (@po_c_error  <> 0)  
    begin   
      set @po_d_error =  convert(varchar,@po_c_error)   
                         + ' - Error al consultar por filtros de persona no vinculada. '  
      return  
  end   
  
  if (@cant_filas = 0)   
    begin   
      set @po_c_error = 1  
      set @po_d_error = 'No se encontraron datos. '   
      return         
    end   
  
end --sp_cons_per_no_vinculadas

go 

Grant Execute on dbo.sp_cons_per_no_vinculadas to GrpTrpSabed 
go

sp_procxmode 'sp_cons_per_no_vinculadas', anymode
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_cons_saldo_RenGas'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_cons_saldo_RenGas" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_cons_saldo_RenGas( 
 @pi_id_persona          numeric(18,0),
 @pi_id_periodo          numeric(18,0),          
 @pi_id_usuario          numeric(18,0),          
 @pi_tipo                varchar(1),           
 @po_saldo               varchar(18) output,          
 @po_c_error             typ_c_error output,           
 @po_d_error             typ_d_error output           
) 
as
--
-- objetivo: Obtener el saldo para la pantalla de rendicion de gastos
--
begin
  --
  -- Controlo el parametro @pi_id_persona, el resto lo controla el proceso llamado
  If @pi_id_persona is null or @pi_id_persona=0
    begin
      set @po_c_error = 3 
      set @po_d_error = 'No se recibi? pi_id_persona'     
      return   
  end

  declare 
    @id_alumno numeric(18,0),
    @cant_filas int

  --
  -- obtengo el id de Alumno
  Select @id_alumno = alu.id_alumno
   from saat_alumnos alu
  Where alu.id_persona = @pi_id_persona      
    and alu.e_alumno in ('BECADO','SUSPENDIDO')   
    and alu.e_registro  = 'D'
    
 set @po_c_error = @@error,    
      @cant_filas = @@rowcount    
      
  if (@po_c_error  <> 0)    
    begin     
      set @po_d_error =  convert(varchar,@po_c_error)     
                         + ' - Error al consultar el identificador de alumno'      
      return    
  end      
  if (@cant_filas = 0)     
    begin     
      set @po_c_error = 2     
      set @po_d_error = 'La persona informada no es alumno o no esta Becado o Suspendido'     
      return           
  end       
  
  execute sp_cons_saldo_alumno  
         @pi_id_alumno  = @id_alumno,
         @pi_id_periodo = @pi_id_periodo,          
         @pi_id_usuario = @pi_id_usuario,          
         @pi_tipo       = @pi_tipo,           
         @po_saldo      = @po_saldo output,          
         @po_c_error    = @po_c_error output,           
         @po_d_error    = @po_d_error output
 
  if (@po_c_error  <> 0)
    begin 
      return
  end 
  
end -- sp_cons_saldo_RenGas
 
go 

Grant Execute on dbo.sp_cons_saldo_RenGas to GrpTrpSabed 
go

sp_procxmode 'sp_cons_saldo_RenGas', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_cons_saldo_alumno'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_cons_saldo_alumno" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_cons_saldo_alumno(             
 @pi_id_alumno           numeric(18,0),         
 @pi_id_periodo          numeric(18,0),         
 @pi_id_usuario          numeric(18,0),         
 @pi_tipo                varchar(1),          
 @po_saldo               varchar(18) output,         
 @po_c_error             typ_c_error output,          
 @po_d_error             typ_d_error output          
)          
as          
          
--objetivo: Obtener el saldo de un alumno a una fecha         
          
begin          
          
  if (@pi_id_usuario is null or @pi_id_usuario = 0)    
    begin          
      set @po_c_error = 3    
      set @po_d_error = 'No se recibi? usuario'          
      return                 
  end            
      
  if (@pi_id_alumno is null or @pi_id_alumno = 0)    
    begin          
      set @po_c_error = 3    
      set @po_d_error = 'No se recibi? alumno'          
      return                 
  end          
      
  if (@pi_id_periodo is null or @pi_id_periodo = 0)    
    begin          
      set @po_c_error = 3    
      set @po_d_error = 'No se recibi? periodo'          
      return                 
  end          
          
  If (@pi_tipo not in ('I','F') or @pi_tipo is null)    
    begin          
      set @po_c_error = 3    
      set @po_d_error = 'No se recibi? un tipo de saldo v?lido'          
      return                 
  end            
            
  declare        
    @f_hasta          datetime,        
    @anio             numeric,
    @cant             int,   
    @Saldo_rendicion  numeric (18,2),        
    @Saldo_recarga    numeric (18,2), 
    @f_hasta_numero   numeric 
          
  set @Saldo_rendicion=0            
  set @Saldo_recarga=0        
          
  set @po_c_error = 0          
  set @po_d_error = null          
  --        
  -- Obtengo las fechas desde y hasta del periodo de la referencia para calcular el saldo         
  Select @f_hasta = f_fin_periodo        
    from sact_periodos_rendicion        
   where id_periodo = @pi_id_periodo    
     
  set @po_c_error = @@error,@cant = @@rowcount         
  if (@po_c_error <> 0)         
    begin          
      set @po_d_error =  'No se pudo determinar el periodo'         
      return         
  end         
  If @cant=0   
    begin          
      set @po_d_error =  'No se pudo obtener el periodo de rendicion vigente'         
      set @po_c_error = 3   
      return         
  end     
     
  --        
  -- determino el a?o de que tenemos que buscar       '  
  set @anio = datepart (yy,@f_hasta)        
               
  --        
  -- Obtengo el saldo de las rendiciones del A?o         
  Select @Saldo_rendicion = sum(drg.i_gasto) 
    from saat_detalle_rend_gasto drg,        
         sact_periodos_rendicion prg        
   where drg.id_alumno = @pi_id_alumno        
     and drg.id_periodo = prg.id_periodo        
     and ((prg.f_fin_periodo < @f_hasta and @pi_tipo ='I') -- para que tome rendiciones anteriores        
          or (prg.f_fin_periodo <= @f_hasta and @pi_tipo ='F'))-- para que tome rendiciones anteriores y la actual   
     and datepart (yy,prg.f_fin_periodo) = @anio -- para que tome las del a?o        
    
  set @po_c_error = @@error,@cant=@@rowcount 
  if (@po_c_error <> 0)         
    begin          
      set @po_d_error =  'No se pudo determinar el saldo de rendicion al periodo ('+@pi_tipo+')'         
      return         
  end   
  If @cant=0 
    begin 
      set @Saldo_rendicion =0 
  end 
                             
   -- Nota: 
   -- Para simplificar como el formato de d_fe_recarga es YYYY-MM-DD la manipulamos para convertirla en  
   -- el n?mero YYYYMMDD o solo tomamos la parte del YYYY, conrespecto al campo f_hasta lo pasamos 
   -- al n?mero YYYYMMDD para poder comparar 
   -- 
   
   set @f_hasta_numero = convert(numeric,str_replace(convert (varchar(10),@f_hasta,111),'/',NULL)) 
 
   Select @Saldo_recarga = sum(convert(numeric(11,2),str_replace(ldp.d_imp_recarga,',','.')))     
    from sart_lotes_pago lp,       
         sart_lotes_det_pago ldp,         
         sart_lotes_det_recarga ldr   
   where ldr.id_alumno = @pi_id_alumno         
     and ldr.id_lote_det_recarga = ldp.id_lote_det_recarga   
     and lp.e_lote_pago <> 'RECHAZADO'      
     and lp.id_lote_pago = ldp.id_lote_pago 
     and convert(numeric,substring(ldp.d_fe_recarga,1,4)) = @anio -- para que tome las del a?o        
     and convert(numeric,str_replace(ldp.d_fe_recarga,'-',NULL)) <= @f_hasta_numero -- se agrego

     --and ((convert(numeric,str_replace(ldp.d_fe_recarga,'-',NULL)) < @f_hasta_numero and @pi_tipo ='I')-- para que tome recargas anteriores        
     --       or (convert(numeric,str_replace(ldp.d_fe_recarga,'-',NULL)) <= @f_hasta_numero and @pi_tipo ='F')) -- para que tome recargas anteriores    

        
   set @po_c_error = @@error,@cant=@@rowcount         
   if (@po_c_error <> 0)         
     begin          
       set @po_d_error =  'No se pudo determinar el saldo recarga al periodo ('+@pi_tipo+')'         
       return         
   end                               
  If @cant=0 
    begin 
      set @Saldo_recarga = 0 
  end 

  --        
  -- Fijo el saldo      
  set @po_saldo =  convert(varchar,(isnull(@Saldo_recarga,0) - isnull(@Saldo_rendicion,0)))        
          
  set @po_c_error = @@error         
  if (@po_c_error <> 0)         
    begin          
      set @po_d_error =  'No se pudo calcular el saldo'         
      return         
  end         
           
end -- sp_cons_saldo_alumno
 
go 

Grant Execute on dbo.sp_cons_saldo_alumno to GrpTrpSabed 
go

sp_procxmode 'sp_cons_saldo_alumno', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_cons_tipos_beca'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_cons_tipos_beca" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_cons_tipos_beca(  
-- drop procedure sp_cons_tipos_beca  
@pi_id_tipo_beca    numeric(18,0),  
@po_c_error         typ_c_error output,  
@po_d_error         typ_d_error output  
)  
as  
/*  
Objetivo: obtiene los tipos de beca para el mantenedor 
*/  
  
begin  
  
  set @po_c_error = 0  
  set @po_d_error = null  
     
  --  
  -- Busco las becas vigentes   
  select tb.id_tipo_beca, 
         tb.d_tipo_beca,  
         convert (varchar(10),tb.f_baja,112)  f_baja     
    from saat_tipo_beca tb          
   where (tb.id_tipo_beca = @pi_id_tipo_beca or isnull(@pi_id_tipo_beca,0) =0) 
   order by tb.d_tipo_beca 
      
  set @po_c_error = @@error     
  if (@po_c_error  <> 0)  
  begin   
      set @po_d_error =  convert(varchar,@po_c_error) + ' - Error en consulta los tipos de beca'  
      return  
  end  
    
end -- sp_cons_tipos_beca
 
go 

Grant Execute on dbo.sp_cons_tipos_beca to GrpTrpSabed 
go

sp_procxmode 'sp_cons_tipos_beca', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_cons_tipos_beca_detalle'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_cons_tipos_beca_detalle" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_cons_tipos_beca_detalle(  
-- drop procedure sp_cons_tipos_beca_detalle  
@pi_id_tipo_beca    	numeric(18,0),  
@pi_id_tipo_beca_det    numeric(18,0),  
@po_c_error         typ_c_error output,  
@po_d_error         typ_d_error output  
)  
as  
/*  
Objetivo: obtiene los detalles de los tipos de beca  
*/  
  
begin  
  
  set @po_c_error = 0  
  set @po_d_error = null  
   
  if (@pi_id_tipo_beca is null or @pi_id_tipo_beca = 0)
    begin   
      set @po_d_error =  'No se informo el id de tipo de beca'  
      set @po_c_error = 3
      return  
  end    
     
  --  
  -- Busco las becas vigentes   
  select tbd.id_tipo_beca_det, 
         tbd.i_beca,           
         convert (varchar(10),tbd.f_vigencia_desde,112) f_vigencia_desde,   
	 convert (varchar(10),tbd.f_vigencia_hasta,112) f_vigencia_hasta            
    from saat_tipo_beca_detalle tbd          
   where tbd.id_tipo_beca = @pi_id_tipo_beca  
     and (tbd.id_tipo_beca_det = @pi_id_tipo_beca_det or isnull (@pi_id_tipo_beca_det,0)=0)  
   order by tbd.f_vigencia_desde, tbd.f_vigencia_hasta 
      
  set @po_c_error = @@error     
  if (@po_c_error  <> 0)  
  begin   
      set @po_d_error =  convert(varchar,@po_c_error)    
                         + ' - Error en consulta el detalle de tipos de beca. '  
      return  
  end  
    
end -- sp_cons_tipos_beca_detalle
 
go 

Grant Execute on dbo.sp_cons_tipos_beca_detalle to GrpTrpSabed 
go

sp_procxmode 'sp_cons_tipos_beca_detalle', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_cons_tutores_accrapido'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_cons_tutores_accrapido" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_cons_tutores_accrapido (   
-- drop procedure sp_cons_tutores_accrapido    
 @pi_id_usuario          numeric(18,0),    
 @pi_id_ong              numeric(18,0),         
 @po_c_error             typ_c_error output,    
 @po_d_error             typ_d_error output    
)    
as    
    
--objetivo: consultar por filtros una persona para que sea TUTOR   
--por tipo y nro de documento    
--o por nombre y apellido    
    
begin    
    
  if (@pi_id_usuario is null or @pi_id_usuario = 0)    
    begin    
      set @po_c_error = 3    
      set @po_d_error = 'No se recibi? usuario'    
      return           
    end    
 
  if (@pi_id_ong is null or @pi_id_ong = 0)    
    begin    
      set @po_c_error = 3    
      set @po_d_error = 'No se recibi? ONG'    
      return           
    end    
      
  set @po_c_error = 0    
  set @po_d_error = null    
   
  declare    
   @cant_filas  int   
   
  select p.id_persona,    
         tut.id_tutor,   
         tut.id_ong, 
         p.d_apellido+', '+  p.d_nombre apenom 
    from sagt_personas p,    
         saft_tutores tut   
   where tut.id_persona = p.id_persona   
     and tut.id_ong = @pi_id_ong   
   order by p.d_apellido+', '+  p.d_nombre 
        
  set @po_c_error = @@error,   
      @cant_filas = @@rowcount         
  if (@po_c_error  <> 0)   
  begin    
      set @po_d_error =  convert(varchar,@po_c_error)    
                         + ' - Error al consultar por filtros de tutores. '    
      return   
  end   
   
  if (@cant_filas = 0)    
    begin    
      set @po_c_error = 1    
      set @po_d_error = 'No se encontraron datos. '    
      return          
    end    
     
end -- sp_cons_tutores_accrapido
 
go 

Grant Execute on dbo.sp_cons_tutores_accrapido to GrpTrpSabed 
go

sp_procxmode 'sp_cons_tutores_accrapido', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_consulta_alumno'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_consulta_alumno" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_consulta_alumno(    

 @pi_id_usuario          numeric(18,0),     

 @pi_id_persona          numeric(18,0),     

 @po_c_error             typ_c_error output,     

 @po_d_error             typ_d_error output     

)     

as      

--objetivo: Consultar los datos de un alumno    

--     

--    

begin     

    

  --    

  -- Valido los par?metros de entrada    

  if (@pi_id_persona is null or @pi_id_persona = 0)   

    begin     

      set @po_c_error = 3   

      set @po_d_error = 'No se recibi? el identificador de persona'     

      return            

    end     

        

  if (@pi_id_usuario is null or @pi_id_usuario = 0)   

  begin    

      set @po_c_error = 3   

      set @po_d_error = 'No se recibi? el identificador de usuario. '    

      return           

  end        

    

  declare @cant_filas       int    

    

  set @po_c_error = 0    

  set @po_d_error = null    

    

    

  -- verifica si el usuario loggeado @pi_id_usuario puede acceder al alumno @pi_id_persona    

  execute sp_verifica_accesibilidad    

                    @pi_id_usuario = @pi_id_usuario,    

                    @pi_id_persona = @pi_id_persona,    

                    @po_c_error    = @po_c_error output,    

                    @po_d_error    = @po_d_error output    

                                   

  if (@po_c_error  <> 0)       

  begin    

      return        

  end     

    

  Select saatalu.id_alumno,    

         saatalu.id_colegio,    

         cole.d_nombre_colegio,    

         saatalu.e_alumno,    

         saatalu.f_propuesta_beca,    

         saatalu.x_observ_prop,    

         convert (varchar(10),saatalu.f_resul_prop,112) f_resul_prop,    

         saatalu.e_estado_prop,    

         saatalu.x_motivo_suspension,    

         convert (varchar(10),saatalu.f_suspension,112) f_suspension,    

         convert (varchar(10),saatalu.f_baja,112) f_baja,    

         saatalu.x_observ_baja,    

         saatalu.d_anio_curso,    

         saatalu.c_orient_colegio,    

         saatalu.c_modal_col,    

         saatalu.m_auditoria,    

         saatalu.c_cont_estudios,    

         saatalu.c_carrera_cont_est,    

         saatalu.c_ocup_eleg,    

         saatalu.e_registro,    

         saatalu.id_tipo_beca,    

         (select tdb.d_tipo_beca     

            from saat_tipo_beca tdb     

           where tdb.id_tipo_beca = saatalu.id_tipo_beca) d_tipo_beca,    

         case when  saatalu.e_alumno = 'CANDIDATO' then saatalu.x_observaciones 

              when  saatalu.e_alumno = 'POSTULANTE' then saatalu.x_observ_prop 

              when  saatalu.e_alumno = 'BECADO' then saatalu.x_observ_resul_prop 

              when  saatalu.e_alumno = 'ELIMINADO' then saatalu.x_observ_resul_prop 

              when  saatalu.e_alumno = 'RECHAZADO' then saatalu.x_observ_resul_prop 

              when  saatalu.e_alumno = 'BAJABECA' then saatalu.x_observ_baja 

              when  saatalu.e_alumno = 'SUSPENDIDO' then saatalu.x_motivo_suspension 

              when  saatalu.e_alumno = 'COMPLETADO' then saatalu.x_observaciones end x_observaciones,    

         (select id_ong    

            from saav_alu_tut_ong    

           where id_alumno = saatalu.id_alumno    

             and id_perfil_tutor = 1    

             and e_registro_tut = 'D'    

         )  id_ong,             

         (select id_tutor    

            from saav_alu_tut_ong    

           where id_alumno = saatalu.id_alumno    

             and id_perfil_tutor = 1    

             and e_registro_tut = 'D'    

         )  id_tutor_adm,    

         (select id_tutor    

            from saav_alu_tut_ong    

           where id_alumno = saatalu.id_alumno    

             and id_perfil_tutor = 2    

             and e_registro_tut = 'D'    

         )  id_tutor_ped 

			,saatalu.id_grupo

			,saatalu.c_cant_cuotas

    from saat_alumnos saatalu,    

         sagt_colegios cole,    

         saav_alu_tut_ong vaong    

   where saatalu.id_persona = @pi_id_persona    

    and  cole.id_colegio = saatalu.id_colegio    

    and vaong.id_alumno = saatalu.id_alumno    

    and vaong.id_perfil_tutor = 1    

   

  set @po_c_error = @@error    

      ,@cant_filas = @@rowcount    

    

  if (@po_c_error  <> 0)    

    begin     

      set @po_d_error =  convert(varchar,@po_c_error)     

                         + ' - Error al consultar al alumno. '    

      return    

  end      

      

  if (@cant_filas = 0)     

    begin     

      set @po_c_error = 1    

      set @po_d_error = 'El alumno no posee datos'     

      return            

    end     

      

end
 
go 

Grant Execute on dbo.sp_consulta_alumno to GrpTrpSabed 
go

sp_procxmode 'sp_consulta_alumno', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_consulta_alumnos_recargas'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_consulta_alumnos_recargas" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_consulta_alumnos_recargas (
	@pi_id_usuario      numeric(18,0),
	@pi_id_tutor        numeric(18,0),
	@pi_id_ong          numeric(18,0),
	@pi_id_periodo_rec  numeric(18,0),
	@pi_origen          varchar(15),  -- --BECARIOS - RECARGAS
	@po_id_lote_recarga numeric(18,0) output,
	@po_inserta         varchar(1)  output,
	@po_confirma        varchar(1)  output,
	@po_al_pago         varchar(1)  output,
	@po_c_error         typ_c_error output,
	@po_d_error         typ_d_error output)
as
	/*
	Objetivo: Levanta los registros para la seleccion de las recargas de tarjetas
	*/

	begin

	  if (@pi_id_usuario is null or @pi_id_usuario = 0)
		begin
		  set @po_c_error = 3
		  set @po_d_error = 'No se recibi?: pi_id_usuario'
		  return
	  end

	  if (@pi_id_ong is null or @pi_id_ong = 0)
		begin
		  set @po_c_error = 3
		  set @po_d_error = 'No se recibi?: pi_id_ong'
		  return
	  end

	  if @pi_origen not in ('BECARIOS' , 'RECARGAS')
		begin
		  set @po_c_error = 3
		  set @po_d_error = 'No se recibi?: origen del llamado'
		  return
	  end

	-- Se elimino la validacion del tutor para aceptar todos los tutores de una ONG
	--  If @pi_origen = 'RECARGAS' and (@pi_id_tutor is null or @pi_id_tutor =0)
	--    begin
	--      set @po_c_error = 3
	--      set @po_d_error = 'No se identifico un tutor'
	--      return
	--  end

	  declare @n_nivel_mensaje int,
		  @c_estado_lote   varchar(15),
		  @estado_periodo  varchar(1),
		  @dummy           numeric(18,0),
		  @id_perfil_administrativo numeric(18,0)

	  set @po_c_error = 0
	  set @po_d_error = null

	  set @dummy = null
	  set @po_inserta  = 'N'
	  set @po_confirma = 'N'
	  set @po_al_pago  = 'N'

	  execute sp_obtiene_prfl_adm
			  @po_id_perfil = @id_perfil_administrativo output,
			  @po_c_error   = @po_c_error output,
			  @po_d_error   = @po_d_error output

	  if (@po_c_error  <> 0)
		begin
		  set @po_d_error = 'Error llamando a sp_obtiene_prfl_adm : ' + @po_d_error
		  return
	  end

	  if @pi_origen = 'BECARIOS'
	  begin

		  execute sp_consulta_becarios
				  @pi_id_usuario     = @pi_id_usuario,
				  @pi_id_tutor       = @pi_id_tutor,
				  @pi_id_ong         = @pi_id_ong,
				  @pi_id_periodo_rec = @pi_id_periodo_rec,
				  @pi_id_perfil      = @dummy,
				  @po_c_error        = @po_c_error output,
				  @po_d_error        = @po_d_error output

		  if (@po_c_error  <> 0)
			begin
			  return
		  end

	  end
	  else -- RECARGAS
		begin

		  --
		  -- Veo el estado del periodo
		  execute sp_est_periodo_recarga
					  @pi_id_periodo = @pi_id_periodo_rec,
					  @po_estado     = @estado_periodo output,
					  @po_c_error    = @po_c_error output,
					  @po_d_error    = @po_d_error output
		  if (@po_c_error  <> 0)
			begin
			  set @po_d_error='Error llamando a sp_est_periodo_recarga : ' + @po_d_error
			  return
		  end

		  --si llaman de la pantalla de RECARGAS y existe el lote para
		  --el periodo ingresado, miro el estado de ese lote y quien inspecciona
		  if exists ( select 1
						from sart_lotes_recarga lr
					   where lr.id_periodo_recarga = @pi_id_periodo_rec
						 --and lr.id_tutor = @pi_id_tutor //se reemplazo por la condicion de abajo para aceptar todos los tutores
						 and (lr.id_tutor = @pi_id_tutor or isnull(@pi_id_tutor,0)=0)
						 and lr.c_estado_lote <> 'ANULADO'
					)
			begin

			  --
			  -- Obtengo el estado del lote
			  select @c_estado_lote = lr.c_estado_lote,
					 @po_id_lote_recarga = lr.id_lote_recarga
				from sart_lotes_recarga lr
			   where lr.id_periodo_recarga = @pi_id_periodo_rec
				 --and lr.id_tutor = @pi_id_tutor //se reemplazo por la condicion de abajo para aceptar todos los tutores
				 and (lr.id_tutor = @pi_id_tutor or isnull(@pi_id_tutor,0)=0)

			  --
			  -- Seteo los botones
			  if exists (select 1
						   from sast_usuarios_perfiles up,
								sast_perfiles perf
						  Where perf.n_nivel_mensaje = 2
							and up.id_usuario =  @pi_id_usuario
							and up.id_perfil=perf.id_perfil)
				 and @c_estado_lote = 'EN_REVISION' and @estado_periodo='A'
				begin
				  set @po_confirma = 'S'
			  end

			  if exists (select 1
						   from sast_usuarios_perfiles up,
								sast_perfiles perf
						  Where perf.n_nivel_mensaje = 1
							and up.id_usuario =  @pi_id_usuario
							and up.id_perfil=perf.id_perfil)
				 and @c_estado_lote = 'CONFIRMADO' and @estado_periodo='A'
				begin
				  set @po_al_pago  = 'S'
			  end
				  /*Se agrega la condicion origen recarga ya que al momento de consultar los lotes estaba devolviendo informacion erronea*/
			   IF(@pi_id_tutor is null or @pi_id_tutor =0)
				BEGIN
					 execute sp_consulta_becarios
						  @pi_id_usuario     = @pi_id_usuario,
						  @pi_id_tutor       = @pi_id_tutor,
						  @pi_id_ong         = @pi_id_ong,
						  @pi_id_periodo_rec = @pi_id_periodo_rec,
						  @pi_id_perfil      = @id_perfil_administrativo,
						  @po_c_error        = @po_c_error output,
						  @po_d_error        = @po_d_error output
				END
			   ELSE
				BEGIN
				  execute sp_consulta_recargas
						  @pi_id_usuario      = @pi_id_usuario,
						  @pi_id_tutor        = @pi_id_tutor,
						  @pi_id_lote_recarga = @po_id_lote_recarga,
						  @po_c_error         = @po_c_error output,
						  @po_d_error         = @po_d_error output
				END

			  if (@po_c_error  <> 0)
				begin
				  return
			  end

		  end
		  else
			begin
			  --llaman de la pantalla de RECARGAS y NO EXISTE el lote para
			  --el periodo ingresado
			  execute sp_nivel_usuario_max
					  @pi_id_usuario      = @pi_id_usuario,
					  @po_n_nivel_mensaje = @n_nivel_mensaje output,
					  @po_c_error         = @po_c_error output,
					  @po_d_error         = @po_d_error output
			  if (@po_c_error  <> 0)
				begin
				  set @po_d_error='Error llamando a sp_nivel_usuario_max : ' + @po_d_error
				  return
			  end

			  -- Seteo el boton
			  if     @n_nivel_mensaje = 3 --TUTOR ADM
				 and @estado_periodo='A'
				begin
				  set @po_inserta  = 'S'
			  end

			  execute sp_consulta_becarios
						  @pi_id_usuario     = @pi_id_usuario,
						  @pi_id_tutor       = @pi_id_tutor,
						  @pi_id_ong         = @pi_id_ong,
						  @pi_id_periodo_rec = @pi_id_periodo_rec,
						  @pi_id_perfil      = @id_perfil_administrativo,
						  @po_c_error        = @po_c_error output,
						  @po_d_error        = @po_d_error output

			   if (@po_c_error  <> 0)
				 begin
				   return
			   end
		  end
	  end
	end

go 

Grant Execute on dbo.sp_consulta_alumnos_recargas to GrpTrpSabed 
go

sp_procxmode 'sp_consulta_alumnos_recargas', anymode
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_consulta_alumnos_seg_rec'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_consulta_alumnos_seg_rec" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_consulta_alumnos_seg_rec(          
@pi_id_usuario      numeric(18,0),          
@pi_id_tutor        numeric(18,0),          
@pi_id_ong          numeric(18,0),          
@pi_id_persona      numeric(18,0),
@pi_id_periodo_rec  numeric(18,0),          
@po_enviar          varchar(1)  output,          
@po_c_error         typ_c_error output,          
@po_d_error         typ_d_error output          
)          
as          
/*          
Objetivo: Obtener los id de alumno para segundas recarags
*/          
          
begin          
          
  if (@pi_id_usuario is null or @pi_id_usuario = 0)    
    begin          
      set @po_c_error = 3   
      set @po_d_error = 'No se recibi? pi_id_usuario'          
      return                 
  end          
          
  if (@pi_id_periodo_rec is null or @pi_id_periodo_rec = 0)   
    begin          
      set @po_c_error = 2   
      set @po_d_error = 'No se inform? un per?odo de busqueda/recarga'          
      return                 
  end                   
          
  declare 
     @n_nivel_mensaje  int,
     @e_definitivo     varchar(1),   
     @cant             int
          
  set @po_c_error = 0          
  set @po_d_error = null                        
     
  --procedure q retorna los codigos del estado de registro definitivo   
  execute sp_obtiene_e_definitivo @po_c_valor  = @e_definitivo output,   
                                  @po_c_error  = @po_c_error output,   
                                  @po_d_error  = @po_d_error output   
                                  
  if (@po_c_error  <> 0)   
    begin   
     set @po_d_error = 'Error llamando a sp_obtiene_e_definitivo : ' + @po_d_error  
     return          
  end   
   
  --
  -- Obtengo los alumnos que forman parte del grupo que se le puede hacer segunda recarga
  --
  select null id_lote_det_recarga,
         tut.id_tutor,    
         alu.id_alumno,    
         per.id_persona,    
         per.d_apellido + ', ' + per.d_nombre apenom         
    from sagt_personas per,    
         saat_alumnos  alu,   
         saft_tutores  tut
   where exists (select 1 
                 from sagt_alumnos_tutores atut
                where atut.id_alumno = alu.id_alumno   
                  and atut.id_tutor = tut.id_tutor
                  and atut.id_perfil = 1 -- nos intereza saber el tutor administrativo
                 ) -- ver si el tutor es del alumno
     and exists (Select 1 
                   from sart_lotes_det_recarga ldr,
                        sart_lotes_recarga lr
                  Where ldr.e_alumno = 'N' -- me importan los N
                    and ldr.id_alumno = alu.id_alumno
                    and ldr.id_lote_recarga = lr.id_lote_recarga
                    and lr.id_periodo_recarga = @pi_id_periodo_rec
                    and lr.c_estado_lote ='ENVIADO'  
                 ) -- ver si fue en el lote como N
     and not exists (Select 1 
                       from sart_lotes_det_recarga ldr,
                            sart_lotes_recarga lr
                      Where ldr.e_alumno = 'S' -- me importan los S
                        and ldr.id_alumno = alu.id_alumno
                        and ldr.id_lote_recarga = lr.id_lote_recarga
                        and lr.id_periodo_recarga = @pi_id_periodo_rec
                        and lr.c_estado_lote in ('ENVIADO','A_PAGAR')
                        and lr.id_coordinador is null -- Marca de que el lote se gener? desde Seg Recarga
                        and lr.id_tutor is null -- Marca de que el lote se gener? desde Seg Recarga
                     ) -- ver si ya fue generado un lote de segunda recarga en el que este esta persona como S
     and alu.e_alumno = 'BECADO'   
     and alu.e_registro = @e_definitivo   
     and alu.id_persona = per.id_persona        
     and per.e_registro = @e_definitivo -- puede que sea redundante, pero lo dejo
     and (per.id_persona = @pi_id_persona or @pi_id_persona is null or @pi_id_persona=0)     
     and tut.e_registro = @e_definitivo        
     and (tut.id_tutor = @pi_id_tutor or @pi_id_tutor is null or @pi_id_tutor=0)   
     and (tut.id_ong = @pi_id_ong or @pi_id_ong is null or @pi_id_ong=0)
   order by per.d_apellido, per.d_nombre   
    
  set @po_c_error = @@error,@cant=@@rowcount
  if (@po_c_error  <> 0)   
    begin    
      set @po_d_error =  convert(varchar,@po_c_error) + ' - Error al consultar los alumnos para segunda recarga'
      return   
  end   
  if @cant = 0
   begin   
      set @po_c_error = 1
      set @po_d_error = 'No se encontraron becarios'
      set @po_enviar = 'N'
      return          
  end             

  set @po_enviar = 'S'

end -- sp_consulta_alumnos_seg_rec
 
go 

Grant Execute on dbo.sp_consulta_alumnos_seg_rec to GrpTrpSabed 
go

sp_procxmode 'sp_consulta_alumnos_seg_rec', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_consulta_alus_a_recargar'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_consulta_alus_a_recargar" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_consulta_alus_a_recargar(  
@pi_id_usuario      numeric(18,0), 
@pi_id_tutor        numeric(18,0), 
@po_c_error         typ_c_error output, 
@po_d_error         typ_d_error output 
) 
as 
/* 
Objetivo: Levanta los registros para la seleccion de las recargas de tarjetas 
*/ 
 
begin 
 
  if (@pi_id_usuario is null or @pi_id_usuario = 0)
    begin 
      set @po_c_error = 3
      set @po_d_error = 'No se recibi? pi_id_usuario' 
      return        
  end 
 
/* si ingresan por el circuito extraordinario el alta no la hace el tutor 
  if (@pi_id_tutor is null or @pi_id_tutor = 0)
    begin 
      set @po_c_error = 3
      set @po_d_error = 'No se recibi? pi_id_tutor' 
      return        
  end 
  */ 
 
  set @po_c_error = 0 
  set @po_d_error = null 
   
  declare @e_definitivo varchar(1) 
   
  --procedure q retorna los codigos del estado de registro definitivo 
  execute sp_obtiene_e_definitivo @po_c_valor  = @e_definitivo output, 
                                  @po_c_error  = @po_c_error output, 
                                  @po_d_error  = @po_d_error output 
                                
  if (@po_c_error  <> 0) 
  begin 
	 set @po_d_error = 'Error llamando a sp_obtiene_e_definitivo : ' + @po_d_error
     return        
  end     
 
  select t.id_tutor,  
         t.id_ong,  
         a.id_alumno,  
         p.id_persona,  
         p.d_apellido + ', ' + p.d_nombre apenom       
  from    sagt_personas p,  
          saat_alumnos  a, 
          saft_tutores t, 
          sagt_alumnos_tutores atut 
 where atut.id_alumno = a.id_alumno 
   and atut.id_tutor = t.id_tutor   
   and a.id_persona = p.id_persona 
   and a.e_alumno = 'BECADO' 
   and a.e_registro = @e_definitivo 
   and t.e_registro = @e_definitivo 
   and p.e_registro = @e_definitivo 
   and t.id_tutor = @pi_id_tutor 
  
  set @po_c_error = @@error     
  if (@po_c_error  <> 0) 
  begin  
      set @po_d_error =  convert(varchar,@po_c_error)  
                         + ' - Error al consultar para recargas. ' 
      return 
  end 
  
end --sp_consulta_alus_a_recargar
 
go 

Grant Execute on dbo.sp_consulta_alus_a_recargar to GrpTrpSabed 
go

sp_procxmode 'sp_consulta_alus_a_recargar', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_consulta_aviso'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_consulta_aviso" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_consulta_aviso (    
@pi_id_aviso               numeric(18,0),    
@po_id_origen              numeric(18,0) output,  
@po_d_apenom               varchar(81)   output,       
@po_c_tipo_aviso           numeric(18,0) output,   
@po_c_evento_calend        numeric(18,0) output,   
@po_d_evento_calend        varchar(250) output, 
@po_f_envio                varchar(19) output,   
@po_x_cuerpo_mensaje       varchar(250) output,   
@po_f_vigencia             varchar(19) output,   
@po_c_error                typ_c_error output,    
@po_d_error                typ_d_error output    
)    
    
as    
-- Objetivo: obtener el detalle de un aviso   
-- Parametros de entrada:    
--   a.pi_id_aviso: Identificador de aviso   
--    
    
begin    
    
  --    
  -- verifico los par?metros de entrada    
  if (@pi_id_aviso  is null or @pi_id_aviso = 0)    
    begin    
      set @po_c_error = 3    
      set @po_d_error = 'No se recibi? identificador de aviso '    
      raiserror @po_c_error @po_d_error    
      return           
  end    
  
  declare @cant_filas int  
  
      
  Select @po_id_origen        = saftavi.id_origen,    
         @po_d_apenom         = d_apellido+', '+ d_nombre, 
         @po_c_tipo_aviso     = saftavi.c_tipo_aviso,            
         @po_c_evento_calend  = saftavi.c_evento_calend,
         @po_d_evento_calend  = saptpar.d_valor,   
         @po_f_envio          = convert(varchar(19),saftavi.f_envio,117),   
         @po_x_cuerpo_mensaje = saftavi.x_cuerpo_mensaje,   
         @po_f_vigencia       = convert(varchar(19),saftavi.f_vigencia,117)   
    from saft_avisos saftavi, 
         sast_usuarios sastusu, 
         sagt_personas sagtper,
         sapt_parametros saptpar
   Where saptpar.id_parametro =* saftavi.c_evento_calend
     and sagtper.id_persona = sastusu.id_persona 
     and sastusu.id_usuario = saftavi.id_origen 
     and saftavi.id_aviso = @pi_id_aviso 
   
  set @po_c_error = @@error,  
      @cant_filas = @@rowcount  
  
  if (@po_c_error  <> 0)    
  begin    
    set @po_d_error = 'Error al recuperar aviso'      
    return                 
  end    
  
  if (@cant_filas = 0)   
    begin   
      set @po_c_error = 1   
      set @po_d_error = 'No se encontraron datos del aviso '   
      return         
    end    
   
  Select id_perfil from saft_avisos_destinatarios where id_aviso = @pi_id_aviso   
    
end  --sp_consulta_aviso
 
go 

Grant Execute on dbo.sp_consulta_aviso to GrpTrpSabed 
go

sp_procxmode 'sp_consulta_aviso', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_consulta_becado'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_consulta_becado" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_consulta_becado(   
 @pi_id_usuario          numeric(18,0),   
 @pi_c_tpo_doc           numeric(18,0),         
 @pi_n_documento         numeric(18,0),    
 @pi_apellido            varchar(40),    
 @pi_nombre              varchar(40),
 @pi_numero_tarjeta      varchar(16),
 @pi_numero_cuenta       varchar(10),  
 @po_c_error             typ_c_error output,    
 @po_d_error             typ_d_error output    
)    
as    
    
--objetivo: consultar por filtros una persona para que sea becado   
--por tipo y nro de documento    
--o por nombre y apellido    
    
begin    
   
  if (@pi_id_usuario  is null or @pi_id_usuario = 0)    
    begin    
      set @po_c_error = 3
      set @po_d_error = 'No se recibi? usuario'    
      return           
    end    
      
  set @po_c_error = 0    
  set @po_d_error = null    
   
  declare    
   @dummy       numeric(18,0),      
   @id_ong_usu  numeric(18,0),   
   @id_tutor    numeric(18,0),  
   @cant_filas  int 
   
  set @id_tutor = null  
   
  -- Obtengo la ONG de quien esta logueado 
  -- El procedure, si es del equipo de becas o superior en jerarquia, 
  -- la ONG viene en NULL  
  execute sp_obtiene_ong_usu  @pi_id_usuario = @pi_id_usuario,   
                              @pi_id_perfil  = @dummy,   
                              @po_id_ong     = @id_ong_usu output,   
                              @po_c_error    = @po_c_error output,   
                              @po_d_error    = @po_d_error output                          
  if (@po_c_error  <> 0) 
	begin
		set @po_d_error = 'Error llamando a sp_obtiene_ong_usu : ' + @po_d_error 
		return   
	end
  -- 
  -- Veo si el usuario logueado es Tutor   
  select @id_tutor = id_tutor  
    from sasv_usuarios_tut   
   where id_usuario = @pi_id_usuario                               
   
  -- 
  -- Obtengo los datos de los alumnos   
  select distinct   
         p.id_persona,    
         p.c_documento,    
         pa.d_valor desc_documento,    
         p.n_documento,    
         p.d_apellido,    
         p.d_nombre,    
         p.d_cuil,    
         p.f_nacimiento,    
         p.c_nacionalidad,    
         p.c_ocupacion,    
         p.c_estado_civil,    
         p.d_mail,    
         p.c_provincia,    
         p.d_localidad,    
         p.d_calle,    
         p.d_nro,    
         p.d_piso,    
         p.d_depto,             
         p.c_sexo,    
         p.e_registro,  
         case when @id_ong_usu is null Then 'S' -- quiere decir que es Equipo de becas o superior  
              when @id_ong_usu = tut.id_ong and @id_tutor is null Then 'S' -- quiere decir que es ADM ONG o Coordinador ONG  
              when tut.id_ong = @id_ong_usu and exists (select 1  
                                                          from sagt_alumnos_tutores alutut2  
                                                         where alutut2.id_tutor = @id_tutor 
                                                           and alutut2.id_alumno = alu.id_alumno) then 'S'  
              else 'N' end m_edita  
    from sagt_personas p    
    inner join sapt_parametros pa on p.c_documento = pa.id_parametro 
    inner join saat_alumnos alu on alu.id_persona = p.id_persona     
    inner join sagt_alumnos_tutores alutut on alutut.id_alumno = alu.id_alumno -- para saber la ONG del alumno 
    inner join saft_tutores tut on tut.id_tutor = alutut.id_tutor -- para saber la ONG del alumno         
    left join saat_alumnos_tarjetas pt on pt.id_alumno = alu.id_alumno
    where (    
          (p.c_documento    = @pi_c_tpo_doc or isnull(@pi_c_tpo_doc,0) = 0 ) and 
          (p.n_documento    = @pi_n_documento or isnull(@pi_n_documento,0) = 0 ) and 
          (upper(p.d_apellido)     like  '%' + upper(@pi_apellido) + '%' or @pi_apellido is null) and 
          (upper(p.d_nombre)       like  '%' + upper(@pi_nombre) + '%' or  @pi_nombre is null) and 
          (upper(pt.d_nro_tarjeta) = upper(@pi_numero_tarjeta) or  @pi_numero_tarjeta is null ) and 
          (upper(pt.d_nro_cta_cred) =  upper(@pi_numero_cuenta) or  @pi_numero_cuenta is null ) 
      )         
      and alu.e_alumno in ('BECADO','SUSPENDIDO')  
      and alu.e_registro     = 'D' 
      and p.e_registro       = 'D'
    order by 3,4  

     
  set @po_c_error = @@error,   
      @cant_filas = @@rowcount   
     
  if (@po_c_error  <> 0)   
    begin    
      set @po_d_error =  convert(varchar,@po_c_error)    
                         + ' - Error al consultar por filtros de becado. '     
      return   
  end     
  if (@cant_filas = 0)    
    begin    
      set @po_c_error = 1    
      set @po_d_error = 'No se encontraron datos. '    
      return          
    end         
end -- sp_consulta_becado


go 

Grant Execute on dbo.sp_consulta_becado to GrpTrpSabed 
go

sp_procxmode 'sp_consulta_becado', anymode
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_consulta_becarios'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_consulta_becarios" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_consulta_becarios (
	@pi_id_usuario      numeric(18,0),      
	@pi_id_tutor        numeric(18,0),      
	@pi_id_ong          numeric(18,0),      
	@pi_id_periodo_rec  numeric(18,0),     
	@pi_id_perfil       numeric(18,0),    
	@po_c_error         typ_c_error output,      
	@po_d_error         typ_d_error output)      
as      
/*      
Objetivo: Levanta los registros para la seleccion de las recargas de tarjetas      
*/      
      
begin      
      
  if (@pi_id_usuario is null  or @pi_id_usuario = 0)     
    begin      
      set @po_c_error = 3     
      set @po_d_error = 'No se recibi? pi_id_usuario'      
      return             
  end      
      
  if (@pi_id_ong is null or @pi_id_ong = 0)     
    begin      
      set @po_c_error = 3     
      set @po_d_error = 'No se recibi? pi_id_ong'      
      return             
  end      
      
  set @po_c_error = 0      
  set @po_d_error = null      
        
  declare @e_definitivo  varchar(1),      
          @f_fin_periodo datetime ,   
          @cant          int     
        
  --procedure q retorna los codigos del estado de registro definitivo      
  execute sp_obtiene_e_definitivo @po_c_valor  = @e_definitivo output,      
                                  @po_c_error  = @po_c_error output,      
                                  @po_d_error  = @po_d_error output      
                                     
  if (@po_c_error  <> 0)      
    begin      
     set @po_d_error = 'Error llamando a sp_obtiene_e_definitivo : ' + @po_d_error     
     return             
  end       
     
  --   
  --  Obtengo la finalizacion del per??­odo   
  select @f_fin_periodo = f_fin_periodo      
    from sact_periodos_recargas      
   where id_periodo_recarga = @pi_id_periodo_rec      
     
  --   
  -- Obtengo la lista de alumnos   
  select distinct null id_lote_det_recarga,      
          tut.id_tutor,       
          alu.id_alumno,   
          alu.e_alumno, -- Se agrega el campo estado Alumno    
          alut.d_nro_tarjeta,  --Se aagrega el campo nro tarjeta       
          per.id_persona,       
          per.d_apellido + ', ' + per.d_nombre apenom             
    from sagt_personas per       
         INNER JOIN saat_alumnos  alu ON alu.id_persona = per.id_persona        
         INNER JOIN sagt_alumnos_tutores atut ON atut.id_alumno = alu.id_alumno   
         INNER JOIN saft_tutores tut ON atut.id_tutor = tut.id_tutor   
		 LEFT JOIN saat_alumnos_tarjetas alut ON alu.id_alumno = alut.id_alumno --se agrega la tabla tarjetas_alumnos   
   where alu.e_alumno in('BECADO','POSTULANTE', 'CANDIDATO') --COndicion para solamente traer los estados BECADO - POSTULANTE - CANDIDATO   
     and atut.id_perfil = isnull(@pi_id_perfil, atut.id_perfil)   
     and alu.e_registro = @e_definitivo      
     and tut.e_registro = @e_definitivo      
     and per.e_registro = @e_definitivo      
     and (tut.id_tutor = @pi_id_tutor or @pi_id_tutor is null or @pi_id_tutor=0)      
     and tut.id_ong = @pi_id_ong      
     and isnull(alu.f_actuac, alu.f_alta) < @f_fin_periodo      --el alta del alumno pertenece al periodo en cuesti??³n 
	 and alut.f_baja is null     -- se agrega condicion para que solo traiga la ultima tarjeta vigente  
   order by alut.d_nro_tarjeta      
       
  set @po_c_error = @@error,@cant=@@rowcount   
  if (@po_c_error  <> 0)      
    begin       
      set @po_d_error =  convert(varchar,@po_c_error)       
                         + ' - Error al consultar alumnos. '      
      return      
  end      
  if @cant = 0   
   begin      
      set @po_c_error = 1     
      set @po_d_error = 'No se encontraron becarios'      
      return             
  end   
     
end --sp_consulta_becarios

go 

Grant Execute on dbo.sp_consulta_becarios to GrpTrpSabed 
go

sp_procxmode 'sp_consulta_becarios', anymode
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_consulta_becarios2'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_consulta_becarios2" >>>>>'
go 

setuser 'dbo'
go 



create procedure sp_consulta_becarios2(    

@pi_id_usuario      numeric(18,0),    

@pi_id_tutor        numeric(18,0),    

@pi_id_ong          numeric(18,0),    

@pi_id_periodo_rec  numeric(18,0),   

@pi_id_perfil       numeric(18,0),  

@po_c_error         typ_c_error output,    

@po_d_error         typ_d_error output    

)    

as    

/*    

Objetivo: Levanta los registros para la seleccion de las recargas de tarjetas    

*/    

begin 


  if (@pi_id_usuario is null  or @pi_id_usuario = 0)   

    begin    

      set @po_c_error = 3   

      set @po_d_error = 'No se recibió pi_id_usuario'    

      return           

  end    

    

  if (@pi_id_ong is null or @pi_id_ong = 0)   

    begin    

      set @po_c_error = 3   

      set @po_d_error = 'No se recibió pi_id_ong'    

      return           

  end    

    

  set @po_c_error = 0    

  set @po_d_error = null    

      
  declare @e_definitivo  varchar(1),    

          @f_fin_periodo datetime , 

          @cant          int   

      

  --procedure q retorna los codigos del estado de registro definitivo    

  execute sp_obtiene_e_definitivo @po_c_valor  = @e_definitivo output,    

                                  @po_c_error  = @po_c_error output,    

                                  @po_d_error  = @po_d_error output    

                                   

  if (@po_c_error  <> 0)    

    begin    

     set @po_d_error = 'Error llamando a sp_obtiene_e_definitivo : ' + @po_d_error   

     return           

  end     

   

  -- 

  --  Obtengo la finalizacion del período 

  select @f_fin_periodo = f_fin_periodo    

    from sact_periodos_recargas    

   where id_periodo_recarga = @pi_id_periodo_rec    

   

  -- 

  -- Obtengo la lista de alumnos 
  if(@pi_id_perfil = null)
  begin
    select distinct null id_lote_det_recarga,    

           tut.id_tutor,     

           alu.id_alumno,     

           per.id_persona,     

           per.d_apellido + ', ' + per.d_nombre apenom          

      from sagt_personas per,     

           saat_alumnos  alu,    

           saft_tutores tut 

     where exists (select 1  

                   from sagt_alumnos_tutores atut 

                  where atut.id_alumno = alu.id_alumno    

                    and atut.id_tutor = tut.id_tutor 

                    and atut.id_perfil = isnull(@pi_id_perfil, atut.id_perfil) 

                   ) 

       and alu.id_persona = per.id_persona    

       and alu.e_alumno = 'BECADO'    

       and alu.e_registro = @e_definitivo    

       and tut.e_registro = @e_definitivo    

       and per.e_registro = @e_definitivo    

       and (tut.id_tutor = @pi_id_tutor or @pi_id_tutor is null or @pi_id_tutor=0)    

       and tut.id_ong = @pi_id_ong    

       and isnull(alu.f_actuac, alu.f_alta) < @f_fin_periodo      --el alta del alumno pertenece al periodo en cuestión    

     order by per.d_apellido, per.d_nombre    
  end
  else
  begin
    
    insert into #tmp_tabla_pre_alumnos 
      (

        id_lote_det_recarga ,    
        id_tutor  ,     
        id_alumno ,     
        id_persona ,     
        apenom 

       )

    select distinct null id_lote_det_recarga,    

           tut.id_tutor,     

           alu.id_alumno,     

           per.id_persona,     

           per.d_apellido + ', ' + per.d_nombre apenom          

  --    into #tmp_tabla_pre_alumnos 

      from sagt_personas per,     

           saat_alumnos  alu,    

           saft_tutores tut 

     where exists (select 1  

                   from sagt_alumnos_tutores atut 

                  where atut.id_alumno = alu.id_alumno    

                    and atut.id_tutor = tut.id_tutor 

                    and atut.id_perfil = isnull(@pi_id_perfil, atut.id_perfil) 

                   ) 

       and alu.id_persona = per.id_persona    

       and alu.e_alumno = 'BECADO'    

       and alu.e_registro = @e_definitivo    

       and tut.e_registro = @e_definitivo    

       and per.e_registro = @e_definitivo    

       and (tut.id_tutor = @pi_id_tutor or @pi_id_tutor is null or @pi_id_tutor=0)    

       and tut.id_ong = @pi_id_ong    

       and isnull(alu.f_actuac, alu.f_alta) < @f_fin_periodo      --el alta del alumno pertenece al periodo en cuestión    

     order by per.d_apellido, per.d_nombre    

  end
     

  set @po_c_error = @@error,@cant=@@rowcount 

  if (@po_c_error  <> 0)    

    begin     

      set @po_d_error =  convert(varchar,@po_c_error)     

                         + ' - Error al consultar alumnos. '    

      return    

  end    

  if @cant = 0 

   begin    

      set @po_c_error = 1   

      set @po_d_error = 'No se encontraron becarios'    

      return           

  end
end
 
go 

Grant Execute on dbo.sp_consulta_becarios2 to GrpTrpSabed 
go

sp_procxmode 'sp_consulta_becarios2', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_consulta_colegio_edad'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_consulta_colegio_edad" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_consulta_colegio_edad(       



 @pi_id_persona          numeric(18,0),     



 @po_c_error             typ_c_error output,     



 @po_d_error             typ_d_error output     



)     



as      



--objetivo: Consultar los datos de un alumno    



--     



--    



begin     



    



  --    



  -- Valido los par?metros de entrada    



  if (@pi_id_persona is null or @pi_id_persona = 0)   



    begin     



      set @po_c_error = 3   



      set @po_d_error = 'No se recibi? el identificador de persona'     



      return            



    end     



              



    



  declare @cant_filas       int    



    



  set @po_c_error = 0    



  set @po_d_error = null    



    



    



  -- verifica si el usuario loggeado @pi_id_usuario puede acceder al alumno @pi_id_persona    



select(datediff(month,f_nacimiento,getdate()) -

          case

           when (datepart(day,f_nacimiento) > datepart(day

,getdate()))

           then 1          else 0

        end

       ) / 12 as n_edad

,d_nombre_colegio from sagt_personas a



inner join saat_alumnos b on a.id_persona = b.id_persona



inner join sagt_colegios c on b.id_colegio = c.id_colegio



where b.id_alumno = @pi_id_persona 

   



   



  set @po_c_error = @@error    



      ,@cant_filas = @@rowcount    



    



  if (@po_c_error  <> 0)    



    begin     



      set @po_d_error =  convert(varchar,@po_c_error)     



                         + ' - Error al consultar al alumno. '    



      return    



  end      



      



  if (@cant_filas = 0)     



    begin     



      set @po_c_error = 1    



      set @po_d_error = 'El alumno no posee datos'     



      return            



    end     



      



end
 
go 

Grant Execute on dbo.sp_consulta_colegio_edad to GrpTrpSabed 
go

sp_procxmode 'sp_consulta_colegio_edad', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_consulta_colegios'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_consulta_colegios" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_consulta_colegios (  
@po_c_error     typ_c_error output,  
@po_d_error     typ_d_error output  
)  
as  
-------------------------------------------------------------------  
--Objetivo: Obtener los colegios del sistema  
--Par?metros de entrada: No posee  
--Par?metros de salida:   
--      cursor con los valores los colegios,   
--po_c_error y po_d_error  
-------------------------------------------------------------------   
  
  
begin  
 
  declare @cant_filas int 
    
  set @po_c_error = 0  
  set @po_d_error = null  
    
  Select id_colegio,   
         d_nombre_colegio 
    from sagt_colegios 
   Where e_registro = 'D'     
   order by d_nombre_colegio 
 
  set @po_c_error = @@error, 
      @cant_filas = @@rowcount 
  
  if (@po_c_error  <> 0) 
    begin  
      set @po_d_error =  convert(varchar,@po_c_error)  
                         + ' - Error al consultar los colegios. '  
  end   
  
  if (@cant_filas = 0)  
    begin  
      set @po_c_error = 1 
      set @po_d_error = 'No se encontraron colegios en el sistema'  
      return        
    end  
  
end --sp_consulta_colegios
 
go 

Grant Execute on dbo.sp_consulta_colegios to GrpTrpSabed 
go

sp_procxmode 'sp_consulta_colegios', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_consulta_colegios_x_filtro'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_consulta_colegios_x_filtro" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_consulta_colegios_x_filtro (  
@pi_d_nombre_col varchar(40), 
@pi_d_localidad  varchar(40), 
@pi_c_provincia  numeric(18,0), 
@po_c_error     typ_c_error output,  
@po_d_error     typ_d_error output  
)  
as  
/*------------------------------------------------------------------ 
--Objetivo: Lista de Colegios: la misma se obtiene a trav?s de: 
 - nombre de Colegio 
 - localidad  
 - provincia.  
 - Se debe aplicar filtro CUIT para el caso de los colegios privados 
--Par?metros de entrada:  
--Par?metros de salida:   
--      cursor con los valores los colegios,   
--po_c_error y po_d_error  
----------------------------------------------------------------*/ 
begin  
 
  declare @cant_filas int 
    
  set @po_c_error = 0  
  set @po_d_error = null  
  set @pi_d_nombre_col = upper (@pi_d_nombre_col)    
  set @pi_d_localidad = upper (@pi_d_localidad)   
 
  Select c.id_colegio,  
         --c.d_cuit, 
         c.d_nombre_colegio, 
         c.d_nombre_directora,  
         c.d_mail, 
         c.d_calle, 
         c.d_nro, 
         c.d_piso, 
         c.d_depto, 
         c.d_localidad, 
         c.c_provincia,   
         p.d_valor desc_prov, 
         c.e_registro 
    from sagt_colegios c, sapt_parametros p  
   where c.c_provincia = p.id_parametro 
    and  c.e_registro in ('A','D') 
    and  ( 
         (UPPER(c.d_nombre_colegio)   like '%' + UPPER(@pi_d_nombre_col)+ '%' or @pi_d_nombre_col is null)   
    and  (c.c_provincia        = @pi_c_provincia or isnull(@pi_c_provincia,0) = 0)    
    and  (UPPER(c.d_localidad)        like '%' + UPPER(@pi_d_localidad) + '%' or @pi_d_localidad is null)    
         ) 
 
  set @po_c_error = @@error, 
      @cant_filas = @@rowcount 
          
  if (@po_c_error  <> 0) 
    begin  
      set @po_d_error =  convert(varchar,@po_c_error)  
                         + ' - Error al consultar los colegios. ' 
  end 
          
  if (@cant_filas = 0)  
    begin  
      set @po_c_error = 1 
      set @po_d_error = 'No se encontraron colegios en el sistema'  
      return        
    end  
  
end -- sp_consulta_colegios_x_filtro
 
go 

Grant Execute on dbo.sp_consulta_colegios_x_filtro to GrpTrpSabed 
go

sp_procxmode 'sp_consulta_colegios_x_filtro', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_consulta_coord_tut'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_consulta_coord_tut" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_consulta_coord_tut(
@pi_id_ong   numeric(18,0),
@po_c_error  typ_c_error output,
@po_d_error  typ_d_error output
)
as
/*

Objetivo: la funci?n de este servicio es brindar una lista de coordinador 
de tutores si hay m?s de uno. 
Par?metros de salida del servicio:
 - ID: identificador del coordinador
 - Apellido
 - Nombre
*/
--

begin

  if (@pi_id_ong is null or @pi_id_ong = 0)
    begin
      set @po_c_error = 3
      set @po_d_error = 'No se recibi? pi_id_ong'
      return       
  end

  declare @id_perfil    numeric(18,0),
          @e_definitivo char(1)

  set @po_c_error = 0
  set @po_d_error = null

  --procedure q retorna los codigos del estado de registro definitivo
  execute sp_obtiene_e_definitivo @po_c_valor  = @e_definitivo output,
                                  @po_c_error  = @po_c_error output,
                                  @po_d_error  = @po_d_error output
                               
  if (@po_c_error  <> 0)
  begin
	 set @po_d_error = 'Error llamando a sp_obtiene_e_definitivo : ' + @po_d_error
     return       
  end  
  
  execute sp_obtiene_prfl_coord_tut @po_id_perfil = @id_perfil output,
                                    @po_c_error   = @po_c_error output,
                                    @po_d_error   = @po_d_error output
                               
  if (@po_c_error  <> 0)
  begin
 	 set @po_d_error = 'Error llamando a sp_obtiene_prfl_coord_tut : ' + @po_d_error 
     return       
  end  
  select t.id_tutor,
         p.d_apellido + ', ' + p.d_nombre nombre_completo
  from   sast_usuarios u,
         sast_usuarios_perfiles up,
         saft_tutores t,
         sagt_personas p
  where  u.id_usuario = up.id_usuario
    and  u.id_persona = t.id_persona
    and  up.id_perfil = @id_perfil
    and  t.id_ong = @pi_id_ong
    and  up.e_usu_perfil = @e_definitivo
    and  u.e_usuario = @e_definitivo
    and  u.id_persona = p.id_persona

  set @po_c_error = @@error    
  if (@po_c_error  <> 0)
    begin 
      set @po_d_error =  convert(varchar,@po_c_error) 
                         + ' - Error al obtener perfil de coord de tutores. '
  end
  
end --sp_consulta_coord_tut
 
go 

Grant Execute on dbo.sp_consulta_coord_tut to GrpTrpSabed 
go

sp_procxmode 'sp_consulta_coord_tut', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_consulta_cuotas_grupo'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_consulta_cuotas_grupo" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_consulta_cuotas_grupo  ( 

@pi_id_grupo 	numeric(18,0), 

@po_c_error typ_c_error output, 

@po_d_error typ_d_error output 

)    as        

/*       

Objetivo: se lo llama para retornar el id, la descripcion y la cantidad de cuotas de todos los grupos. 

*/           

begin             

select c_cuotas     

  from sapt_param_grupos  

  where id_grupo = @pi_id_grupo		

  order by id_grupo

  set @po_c_error = 0    

  set @po_d_error = null 

end
 
go 

Grant Execute on dbo.sp_consulta_cuotas_grupo to GrpTrpSabed 
go

sp_procxmode 'sp_consulta_cuotas_grupo', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_consulta_grupofamiliar'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_consulta_grupofamiliar" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_consulta_grupofamiliar(
 @pi_id_alumno          numeric(18,0), 
 @po_c_error             typ_c_error output, 
 @po_d_error             typ_d_error output 
) 
as 
 
--objetivo: Consultar los datos de un alumno
--
 
begin 

  --
  -- Valido los par?metros de entrada
  if (@pi_id_alumno is null or @pi_id_alumno = 0) 
    begin 
      set @po_c_error = 3
      set @po_d_error = 'No se recibi? identificador del alumno' 
      return        
    end 

  set @po_c_error = 0 
  set @po_d_error = null 

  Select saatapa.id_persona_rel,
         sagtper.c_documento,
         saptpar.d_valor d_documento,
         sagtper.n_documento,
         sagtper.d_apellido,
         sagtper.d_nombre,
         sagtper.d_cuil,
         convert(varchar(8),sagtper.f_nacimiento,112) f_nacimiento,
         sagtper.c_nacionalidad,
         saptpar3.d_valor d_nacionalidad,
         sagtper.c_ocupacion,
         sagtper.c_estado_civil,
         sagtper.d_mail,
         sagtper.d_calle,
         sagtper.d_nro,
         sagtper.d_piso,
         sagtper.d_depto,
         sagtper.d_localidad,
         sagtper.c_provincia,
         saptpar2.d_valor d_provincia,
         sagtper.c_sexo,
         sagtper.e_registro,
         saatapa.m_tit_tarjeta,
         saatapa.c_parentesco,
         saptpar.d_valor d_parentesco
    From saat_alumnos_parentesco saatapa,
         sagt_personas sagtper,
         sapt_parametros saptpar,
         sapt_parametros saptpar2,
         sapt_parametros saptpar3,
         sapt_parametros saptpar4
   where sagtper.c_documento *= saptpar4.id_parametro
     and sagtper.c_nacionalidad *= saptpar3.id_parametro
     and sagtper.c_provincia *= saptpar2.id_parametro
     and saptpar.id_parametro =* saatapa.c_parentesco
     and sagtper.id_persona = saatapa.id_persona_rel
     and saatapa.id_alumno = @pi_id_alumno
     --and sagtper.e_registro = 'D'
   order by sagtper.d_apellido,sagtper.d_nombre,saptpar.d_valor

  set @po_c_error = @@error      
  
  if (@po_c_error  <> 0)
  begin 
      set @po_d_error =  convert(varchar,@po_c_error) 
                         + ' - Error al consultar el grupo familiar del alumno. '
      return
  end
  
end -- sp_consulta_grupofamiliar
 
go 

Grant Execute on dbo.sp_consulta_grupofamiliar to GrpTrpSabed 
go

sp_procxmode 'sp_consulta_grupofamiliar', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_consulta_mensajes'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_consulta_mensajes" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_consulta_mensajes(   
@pi_id_usuario     numeric(18,0),  
@po_c_error        typ_c_error output,  
@po_d_error        typ_d_error output  
)  
as  
  
--objetivo: mostrara los mensajes en la grilla de Bienvenida. S?lo se muestran los  
--mensajes recibidos, no los que el usuario envi?.  
--  
  
begin  
  
  if (@pi_id_usuario is null  or @pi_id_usuario = 0) 
    begin  
      set @po_c_error = 3 
      set @po_d_error = 'No se recibi? pi_id_usuario'  
      return         
  end  
    
  declare   
      @id_ong         numeric(18,0),  
      @id_dummy       numeric(18,0),
      @e_definitivo   varchar(1)
  
  set @po_c_error = 0  
  set @po_d_error = null  
  
  --procedure q retorna los codigos del estado de registro definitivo  
  execute sp_obtiene_e_definitivo   @po_c_valor  = @e_definitivo output,  
                                    @po_c_error  = @po_c_error output,  
                                    @po_d_error  = @po_d_error output  
                                 
  if (@po_c_error  <> 0)  
    begin  
      set @po_d_error = 'Error llamando a sp_obtiene_e_definitivo : ' + @po_d_error	 
      return         
    end
  
  --obtener ong del usuario: @pi_id_usuario     
  execute sp_obtiene_ong_usu  @pi_id_usuario = @pi_id_usuario,  
                              @pi_id_perfil  = @id_dummy,  
                              @po_id_ong     = @id_ong output,  
                              @po_c_error    = @po_c_error output,  
                              @po_d_error    = @po_d_error output  
                                 
  if (@po_c_error  <> 0)     
  begin  
	  set @po_d_error = 'Error llamando a sp_obtiene_ong_usu : ' + @po_d_error 
      return      
  end       
  
  -- Traigo los mensaje para la bandeja de entrada   
  --   Ser?an todos los mensajes que me enviaron ya   
  --   sea a mi perfil como a mi de manera particular  
  --  
  select distinct av.id_aviso,   
         av.id_origen emisor_mensaje,   
         convert(char(12),av.f_envio,112) f_envio,   
         av.x_cuerpo_mensaje,  
         pa.id_parametro c_asunto,  
         pa.d_valor desc_asunto  
    from saft_avisos av,  
         saft_avisos_destinatarios avd,  
         sapt_parametros pa  
   where av.c_evento_calend *= pa.id_parametro  
     and av.f_vigencia >= getDate()  
     and av.id_aviso = avd.id_aviso  
     and (avd.id_usuario = @pi_id_usuario  
          or (   avd.id_perfil = any (select usuper.id_perfil  
                                        from sast_usuarios_perfiles usuper  
                                       where usuper.id_usuario = @pi_id_usuario  
                                         and usuper.e_usu_perfil = @e_definitivo)  
               and (  av.id_origen in (Select fund.id_usuario  
                                         from sasv_usuarios_fund fund  
                                        where fund.id_usuario = av.id_origen)-- fundacion  
                      or   
                      av.id_origen in (Select ong.id_usuario  
                                         from sasv_usuarios_ongs ong  
                                        where ong.id_ong = @id_ong  
                                          and ong.id_usuario = av.id_origen) -- Persona de mi misma ONG  
                      or   
                      av.id_origen in (Select tut.id_usuario  
                                         from sasv_usuarios_tut tut  
                                        where tut.id_usuario = av.id_origen) -- Persona de mi misma ONG                                            
                   )  
             )  
         )  
  order by av.f_envio
  
  set @po_c_error = @@error      
  if (@po_c_error  <> 0)  
  begin   
      set @po_d_error =  convert(varchar,@po_c_error)   
                         + ' - Error al obtener tareas del usuario: ' +   
                        convert (varchar(7), @pi_id_usuario)  
      return  
  end  
    
end --sp_consulta_mensajes
 
go 

Grant Execute on dbo.sp_consulta_mensajes to GrpTrpSabed 
go

sp_procxmode 'sp_consulta_mensajes', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_consulta_menu'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_consulta_menu" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_consulta_menu ( 
@pi_id_usuario  numeric(18,0), 
@po_c_error     typ_c_error output, 
@po_d_error     typ_d_error output 
) 
as 
------------------------------------------------------------------- 
--Objetivo: obtener las entradas de men? para los roles	 
-- de un usuario del sistema 
--Par?metros de entrada: pi_usuario (varchar2) 
--Par?metros de salida:  
--      cursor con los valores del men?: XXXX,  
--po_c_error y po_d_error 
------------------------------------------------------------------- 
 
begin 
   
  if (@pi_id_usuario is null or @pi_id_usuario = 0)
    begin 
      set @po_c_error = 3
      set @po_d_error = 'No se recibi? usuario. ' 
      return 
  end 
   
  declare @cant_filas int 
    
  set @po_c_error = 0 
  set @po_d_error = null 
   
--agregamos la opci?n de men? Home en duro, ya que ninguna entrada de men? lo  
--tiene como padre 
select m.id_menu,                  
       m.d_menu,  
       m.x_url_menu, 
       m.id_padre, 
       m.n_nivel, 
       m.n_orden   
from sast_menu m 
where id_menu in (1,32) -- home y cambio de clave 
union   
select m.id_menu,                  
       m.d_menu,  
       m.x_url_menu, 
       m.id_padre, 
       m.n_nivel, 
       m.n_orden   
from sast_menu m 
where exists  ( 
                select * 
                  from   sast_accesos a,                   --id_acceso, id_menu 
                         sast_accesos_por_perfiles ap,     --id_perfil 
                         sast_usuarios_perfiles up  --id_perfil, id_usuario 
                  where  a.id_acceso = ap.id_acceso   
                    and  ap.id_perfil = up.id_perfil 
                    and  up.id_usuario =  @pi_id_usuario   
                    and  (a.id_menu = m.id_menu) 
                ) 
union 
select m1.id_menu,                  
       m1.d_menu,  
       m1.x_url_menu, 
       m1.id_padre, 
       m1.n_nivel, 
       m1.n_orden   
                  from   sast_accesos a,                   --id_acceso, id_menu 
                         sast_accesos_por_perfiles ap,     --id_perfil 
                         sast_usuarios_perfiles up,  --id_perfil, id_usuario 
                         sast_menu m, 
                         sast_menu m1 
                  where  a.id_acceso = ap.id_acceso   
                    and  ap.id_perfil = up.id_perfil 
                    and  up.id_usuario =  @pi_id_usuario   
                    and  a.id_menu = m.id_menu 
                    and  m.id_padre = m1.id_menu 
union 
select m2.id_menu,                  
       m2.d_menu,  
       m2.x_url_menu, 
       m2.id_padre, 
       m2.n_orden,          
       m2.n_nivel 
                  from   sast_accesos a,                   --id_acceso, id_menu 
                         sast_accesos_por_perfiles ap,     --id_perfil 
                         sast_usuarios_perfiles up,  --id_perfil, id_usuario 
                         sast_menu m, 
                         sast_menu m1, 
                         sast_menu m2                          
                  where  a.id_acceso = ap.id_acceso   
                    and  ap.id_perfil = up.id_perfil 
                    and  up.id_usuario =  @pi_id_usuario   
                    and  a.id_menu = m.id_menu 
                    and  m.id_padre = m1.id_menu 
                    and  m1.id_padre = m2.id_menu                     
order by 5,6 
 
  set @po_c_error = @@error, 
      @cant_filas = @@rowcount   
 
  if (@po_c_error  <> 0) 
    begin 
      set @po_d_error = convert(varchar,@po_c_error) +  
                        ' - Error al consultar menu' 
    end 
 
  if (@cant_filas = 0) 
    begin 
      set @po_c_error = 1 
      set @po_d_error = 'No se encontraron datos del men?. ' 
      return       
    end 
	
end --sp_consulta_menu
 
go 

Grant Execute on dbo.sp_consulta_menu to GrpTrpSabed 
go

sp_procxmode 'sp_consulta_menu', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_consulta_noticia'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_consulta_noticia" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_consulta_noticia (  
@pi_id_noticia 		numeric(18,0), 
@po_c_error     	typ_c_error output,  
@po_d_error     	typ_d_error output  
)  
as  
-------------------------------------------------------------------  
--Objetivo: Obtener las noticias del sistema  
--Par?metros de entrada: 
--	ID_NOTICIA 
--Par?metros de salida:   
--      cursor con los valores las noticias   
--po_c_error y po_d_error  
-------------------------------------------------------------------   
begin  
  
  set @po_c_error = 0  
  set @po_d_error = null  
    
  select x_titulo, 
         x_copete, 
         x_cuerpo_mensaje,
         convert(char(12),f_vigencia_desde,112) f_vigencia_desde,
         convert(char(12),f_vigencia_hasta,112) f_vigencia_hasta,
         convert(char(12),f_baja,112) f_baja
    from saft_noticias 
   where id_noticia = @pi_id_noticia
   order by f_vigencia_desde,f_vigencia_hasta

  set @po_c_error = @@error     
  if (@po_c_error  <> 0)  
    begin    
      set @po_d_error = 'Error al consultar los noticias' 
      return       
  end  
  
end -- sp_consulta_noticia
 
go 

Grant Execute on dbo.sp_consulta_noticia to GrpTrpSabed 
go

sp_procxmode 'sp_consulta_noticia', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_consulta_ongs'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_consulta_ongs" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_consulta_ongs (  
@po_c_error     typ_c_error output,  
@po_d_error     typ_d_error output  
)  
as  
-------------------------------------------------------------------  
--Objetivo: Obtener las ongs del sistema  
--Par?metros de entrada: No posee  
--Par?metros de salida:   
--      cursor con los valores las ongs,   
--po_c_error y po_d_error  
-------------------------------------------------------------------   
  
  
begin  
  declare @cant_filas int 
    
  set @po_c_error = 0  
  set @po_d_error = null  
    
  Select id_ong, 
         d_nombre_ong 
    from saft_ongs 
   Where e_registro = 'D'  
   order by d_nombre_ong 
    
  set @po_c_error = @@error, 
      @cant_filas = @@rowcount 
       
  if (@po_c_error  <> 0) 
  begin  
      set @po_d_error =  convert(varchar,@po_c_error)  
                         + ' - Error al consultar las ongs. '    
return   
  end    
   
  if (@cant_filas = 0)  
  begin  
      set @po_c_error = 1 
      set @po_d_error = 'No se encontraron ongs en el sistema' 
      return        
  end  
  
end --sp_consulta_ongs      
 
go 

Grant Execute on dbo.sp_consulta_ongs to GrpTrpSabed 
go

sp_procxmode 'sp_consulta_ongs', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_consulta_ongs_x_filtro'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_consulta_ongs_x_filtro" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_consulta_ongs_x_filtro ( 
@pi_d_cuit       varchar(40), 
@pi_d_nombre_ong varchar(40), 
@pi_c_tipo_ong   numeric(18,0), 
@pi_d_localidad  varchar(40), 
@pi_c_provincia  numeric(18,0), 
@po_c_error      typ_c_error output,  
@po_d_error      typ_d_error output  
)  
as  
/*-------------------------------------------------------------------  
--Objetivo: Lista de ONG?; la misma se obtiene a trav?s de: 
 - nombre de la ONG  
 - CUIT  
 - localidad  
 - provincia 
--Par?metros de salida:   
--      cursor con los valores de las ongs 
--po_c_error y po_d_error  
-------------------------------------------------------------------*/ 
  
begin  
   
  declare   
       @cantFilas int 
   
  set @po_c_error = 0  
  set @po_d_error = null  
   
   
  if @pi_d_cuit is null print @pi_d_cuit 
                else print 'd_cuit es no nulo' 
   
  set @pi_d_nombre_ong = upper (@pi_d_nombre_ong) 
  set @pi_d_localidad =  upper (@pi_d_localidad) 
   
  select o.id_ong, 
         o.d_cuit, 
         o.d_nombre_ong, 
         o.q_becas, 
         o.c_tipo_ong, 
         p.d_valor desc_tipo_ong, 
         o.d_localidad, 
         o.c_provincia, 
         p2.d_valor desc_prov, 
         o.d_mail, 
         o.d_calle, 
         o.d_nro, 
         o.d_piso, 
         o.d_depto, 
         o.d_suc_cuenta,  
         o.d_tipo_cuenta,  
         o.d_nro_cuenta,  
		 o.c_nro_cliente,
         o.e_registro         
    from saft_ongs o, sapt_parametros p, sapt_parametros p2 
   where o.c_tipo_ong  *= p.id_parametro  
     and o.c_provincia *= p2.id_parametro 
     --and o.e_registro = 'D' 
     and o.m_fundacion = 'N'    
     and ( 
         (UPPER(o.d_nombre_ong) like '%'+UPPER(@pi_d_nombre_ong)+'%' or @pi_d_nombre_ong is null) and           
         (UPPER(o.d_localidad)  like '%'+UPPER(@pi_d_localidad)+'%' or @pi_d_localidad is null)   and  
         (o.d_cuit       = @pi_d_cuit or @pi_d_cuit is null)                and           
         (o.c_tipo_ong   = @pi_c_tipo_ong or isnull(@pi_c_tipo_ong,0) = 0)  and 
         (o.c_provincia  = @pi_c_provincia or isnull(@pi_c_provincia,0) = 0) 
          
         ) 
   order by d_nombre_ong 
 
  set @po_c_error = @@error,          
      @cantFilas  = @@rowcount        
 
  if (@cantFilas = 0)  
    begin  
      set @po_c_error = 1  
      set @po_d_error = 'No se encontraron ongs en el sistema' 
      return        
    end  
 
  if (@po_c_error  <> 0) 
    begin  
      set @po_d_error =  convert(varchar,@po_c_error)  
                         + ' - Error al consultar las ongs x filtro. ' 
      return
  end   
   
end --sp_consulta_ongs_x_filtro
 
go 

Grant Execute on dbo.sp_consulta_ongs_x_filtro to GrpTrpSabed 
go

sp_procxmode 'sp_consulta_ongs_x_filtro', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_consulta_param_tabla'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_consulta_param_tabla" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_consulta_param_tabla (
@po_c_error typ_c_error output,
@po_d_error typ_d_error output
)
as
-------------------------------------------------------------------
--Objetivo: obtener todos los c?digos y descripci?n de la tabla
--Par?metros de entrada: No posee
--Par?metros de salida: curso con los valores: id_tabla (num?rico),
--tabla (varchar2)
--po_c_error y po_d_error
-------------------------------------------------------------------

begin

  declare @cant_filas int
  
  set @po_c_error = 0
  set @po_d_error = null

  select id_tabla, d_valor
  from   sapt_param_tablas
  order by d_valor

  set @po_c_error = @@error,
      @cant_filas = @@rowcount

  if (@po_c_error  <> 0)
  begin 
      set @po_d_error =  convert(varchar,@po_c_error) 
                         + ' - Error al obtener tablas de parametros. '
      return
  end
  
  if (@cant_filas = 0)
    begin
      set @po_c_error = 1
      set @po_d_error = 'No se encontraron datos. '
      return      
    end  

end --sp_consulta_param_tabla
 
go 

Grant Execute on dbo.sp_consulta_param_tabla to GrpTrpSabed 
go

sp_procxmode 'sp_consulta_param_tabla', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_consulta_parametros'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_consulta_parametros" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_consulta_parametros ( 



@pi_id_tabla 	numeric(18,0), 



@po_c_error typ_c_error output, 



@po_d_error typ_d_error output 



)  as



--Objetivo: obtener todos los c?digos y descripciones de una tabla de par?metros 



--Par?metros de entrada: pi_id_tabla (num?rico) 



--Par?metros de salida: curso con los valores:  



--id_tabla (num?rico) ,  



--c_valor (varcha2),  



--d_valor (varcha2),  



--po_c_error  



--po_d_error 



 







begin 



 



  if (@pi_id_tabla is null or @pi_id_tabla = 0) 



    begin 



      set @po_c_error = 3 



      set @po_d_error = 'No se recibi? id de tabla ' 



      return        



  end 



  declare @cant_filas int 



  set @po_c_error = 0 



  set @po_d_error = null 



  



  if @pi_id_tabla  = (select id_tabla from sapt_param_tablas where d_valor = 'GRUPO')



  -- si el id de tabla es el de grupos se llama al stored que obtiene los grupos con cuotas.



	begin



		select id_grupo, d_valor,c_cuotas     



  from sapt_param_grupos  



  order by id_grupo







	end



  else 



	  begin



		  select id_parametro, d_valor 

    --nuevo 21/12/12

        ,c_cuota = -1

--fin nuevo 21/12/12

		  from   sapt_parametros  



		  where id_tabla = @pi_id_tabla 



		  order by d_valor 



	  end   



  set @po_c_error = @@error, 



      @cant_filas = @@rowcount 



       



  if (@po_c_error  <> 0) 



  begin  



      set @po_d_error =  convert(varchar,@po_c_error)  



                         + ' - Error en sp_consulta_parametros: '+  



                        convert(varchar(7),@pi_id_tabla) 



      return 



  end 



   



  if (@cant_filas = 0) 



    begin 



      set @po_c_error = 1 



      set @po_d_error = 'No se encontraron datos. ' 



      return       



    end   



end
 
go 

Grant Execute on dbo.sp_consulta_parametros to GrpTrpSabed 
go

sp_procxmode 'sp_consulta_parametros', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_consulta_per_rend_gastos'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_consulta_per_rend_gastos" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_consulta_per_rend_gastos (  
@pi_id_periodo	        numeric(18,0),  
@pi_anio                numeric (4,0),  
@po_c_error      typ_c_error output,  
@po_d_error      typ_d_error output  
)  
as  
-------------------------------------------------------------------  
--Objetivo: Obtener los periodos de  
--               rendicion de gastos 
--Par?metros de salida:   
--po_c_error y po_d_error  
-------------------------------------------------------------------  
  
begin  
    
  set @po_c_error = 0  
  set @po_d_error = null  
   
      Select id_periodo, 
             convert(varchar,f_inicio_periodo,112)f_inicio_periodo,   
             convert(varchar,f_fin_periodo,112)f_fin_periodo,   
             convert(varchar,f_recarga_periodo,112) f_recarga_periodo, 
             d_periodo, 
             case when (f_inicio_periodo<= getdate() and f_fin_periodo>=getdate()) then 'A'  
                  when (f_fin_periodo<getdate()) then 'C' 
                  when (f_inicio_periodo>getdate()) then 'F' end c_estado_periodo  
        from sact_periodos_rendicion 
      where (id_periodo=@pi_id_periodo or isnull(@pi_id_periodo,0)=0) 
         and  (datepart(yy,f_inicio_periodo) = @pi_anio or isnull(@pi_anio,0)=0)  
      order by f_inicio_periodo    
  
      set @po_c_error = @@error      
      if (@po_c_error  <> 0)  
      begin      
        set @po_d_error = 'Error al obtener los periodos'   
        return  
      end  
   
end --sp_consulta_per_rend_gastos
 
go 

Grant Execute on dbo.sp_consulta_per_rend_gastos to GrpTrpSabed 
go

sp_procxmode 'sp_consulta_per_rend_gastos', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_consulta_perfiles'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_consulta_perfiles" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_consulta_perfiles (
@pi_id_usuario numeric(18,0),
@po_c_error    typ_c_error output,
@po_d_error    typ_d_error output
)
as

--objetivo: retorna solo los perfiles que puede acceder el usuario informado
--

begin

  if (@pi_id_usuario  is null or @pi_id_usuario = 0) 
    begin
      set @po_c_error = 3
      set @po_d_error = 'No se recibi? pi_id_usuario'
      return       
  end

  declare @cant_filas int

  set @po_c_error = 0
  set @po_d_error = null

  select up.id_perfil, p.d_perfil , p.n_nivel_mensaje
    from sast_usuarios_perfiles up, sast_perfiles p
   where up.id_usuario = @pi_id_usuario
     and up.id_perfil = p.id_perfil  

  set @po_c_error = @@error,
      @cant_filas = @@rowcount

  if (@po_c_error  <> 0)
    begin 
      set @po_d_error =  convert(varchar,@po_c_error) 
                         + ' - Error en consulta de perfiles. '
  end

  if (@cant_filas = 0)
    begin
      set @po_c_error = 1
      set @po_d_error = 'No se encontraron datos. '
      return      
    end

end --sp_consulta_perfiles
 
go 

Grant Execute on dbo.sp_consulta_perfiles to GrpTrpSabed 
go

sp_procxmode 'sp_consulta_perfiles', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_consulta_perfiles_N3'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_consulta_perfiles_N3" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_consulta_perfiles_N3 (  
@pi_id_usuario numeric(18,0), 
@po_c_error    typ_c_error output, 
@po_d_error    typ_d_error output 
) 
as 
 
--objetivo: retorna solo los perfiles denivel 3 
-- 
 
begin 
 
  if (@pi_id_usuario  is null  or @pi_id_usuario = 0)
    begin 
      set @po_c_error = 3
      set @po_d_error = 'No se recibi? pi_id_usuario' 
      return        
  end 
 
  declare @cant_filas int 
 
  set @po_c_error = 0 
  set @po_d_error = null 
 
  select p.id_perfil,  
         p.d_perfil ,  
         p.n_nivel_mensaje 
    from sast_perfiles p 
   where p.n_nivel_mensaje = 3 
 
  set @po_c_error = @@error, 
      @cant_filas = @@rowcount 
 
  if (@po_c_error  <> 0) 
    begin  
      set @po_d_error =  convert(varchar,@po_c_error)  
                         + ' - Error en consulta de perfiles de nivel 3. ' 
  end 
 
  if (@cant_filas = 0) 
    begin 
      set @po_c_error = 1 
      set @po_d_error = 'No se encontraron datos. ' 
      return       
    end 
 
end --sp_consulta_perfiles_N3
 
go 

Grant Execute on dbo.sp_consulta_perfiles_N3 to GrpTrpSabed 
go

sp_procxmode 'sp_consulta_perfiles_N3', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_consulta_periodo_eval_acad'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_consulta_periodo_eval_acad" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_consulta_periodo_eval_acad (   

-- drop procedure sp_consulta_periodo_eval_acad  

@pi_id_periodo	        numeric(18,0),   

@pi_anio                numeric(4,0),   

@po_c_error      typ_c_error output,   

@po_d_error      typ_d_error output   

)   

as   

-------------------------------------------------------------------   

--Objetivo: Obtener los periodos de   

--          rendicion de situacion academica  

--Par?metros de salida:    

--po_c_error y po_d_error   

-------------------------------------------------------------------   

   

begin   

     

  set @po_c_error = 0   

  set @po_d_error = null   

   

      Select id_periodo,  

             convert(varchar,f_inicio_periodo,112)f_inicio_periodo,    

             convert(varchar,f_fin_periodo,112)f_fin_periodo,	              

             d_periodo,  

             s_ultimo,   

             case when (f_inicio_periodo<= getdate() and f_fin_periodo>=getdate()) then 'A'   

                  when (f_fin_periodo<getdate()) then 'C'  

                  when (f_inicio_periodo>getdate()) then 'F' end c_estado_periodo   

        from sact_periodos_eval_acad  

      where (id_periodo=@pi_id_periodo or isnull(@pi_id_periodo,0) = 0)  

         and  (datepart(yy,f_inicio_periodo) = @pi_anio or isnull(@pi_anio,0) = 0)    

      order by f_inicio_periodo     

   

      set @po_c_error = @@error       

      if (@po_c_error  <> 0)   

      begin       

        set @po_d_error = 'Error al obtener los periodos'   

        return   

      end   

    

end
 
go 

Grant Execute on dbo.sp_consulta_periodo_eval_acad to GrpTrpSabed 
go

sp_procxmode 'sp_consulta_periodo_eval_acad', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_consulta_periodo_recargas'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_consulta_periodo_recargas" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_consulta_periodo_recargas (   
@pi_id_periodo	        numeric(18,0),  
@pi_anio                numeric(4,0),  
@po_c_error      typ_c_error output,  
@po_d_error      typ_d_error output  
)  
as  
-------------------------------------------------------------------  
--Objetivo: Obtener los periodos de recargas 
--Par?metros de salida:   
--po_c_error y po_d_error  
-------------------------------------------------------------------  
  
begin  
    
  set @po_c_error = 0  
  set @po_d_error = null  
  
      Select id_periodo_recarga, 
             convert(varchar,f_inicio_periodo,112)f_inicio_periodo,   
             convert(varchar,f_fin_periodo,112)f_fin_periodo,   
             d_periodo, 
             case when (f_inicio_periodo<= getdate() and f_fin_periodo>=getdate()) then 'A'  
                  when (f_fin_periodo<getdate()) then 'C' 
                  when (f_inicio_periodo>getdate()) then 'F' end c_estado_periodo  
        from sact_periodos_recargas 
      where (id_periodo_recarga=@pi_id_periodo or isnull(@pi_id_periodo,0) = 0) 
         and  (datepart(yy,f_inicio_periodo) = @pi_anio or isnull(@pi_anio,0) = 0)   
      order by f_inicio_periodo    
  
      set @po_c_error = @@error      
      if (@po_c_error  <> 0)  
      begin      
        set @po_d_error = 'Error al obtener los periodos'   
        return  
      end  
   
end --sp_consulta_periodo_recargas
 
go 

Grant Execute on dbo.sp_consulta_periodo_recargas to GrpTrpSabed 
go

sp_procxmode 'sp_consulta_periodo_recargas', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_consulta_periodos_gastos'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_consulta_periodos_gastos" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_consulta_periodos_gastos (
@pi_id_alumno               numeric(18,0),
@po_c_error                 typ_c_error output,
@po_d_error                 typ_d_error output
)
as
-- Objetivo: consultar los per?odos en los que se informaron gastos
-- Parametros de entrada:
--   a.ID alumno: se enviar? el identificador del alumno. 
--

begin

  --
  -- verifico los par?metros de entrada
  if (@pi_id_alumno is null or @pi_id_alumno = 0)
    begin
      set @po_c_error = 3
      set @po_d_error = 'No se recibi? el identificador de alumno '
      return       
  end

  Select distinct (gasto.id_periodo)
    from saat_alumnos_rendicion_gasto gasto
   where gasto.id_alumno = @pi_id_alumno
   order by gasto.id_periodo

  set @po_c_error = @@error   
  
  if (@po_c_error  <> 0)
  begin
    set @po_d_error = convert(varchar,@po_c_error) 
                      + ' - Error al recuperar los per?odos de gastos'
    return             
  end

end  --sp_consulta_periodos_gastos
 
go 

Grant Execute on dbo.sp_consulta_periodos_gastos to GrpTrpSabed 
go

sp_procxmode 'sp_consulta_periodos_gastos', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_consulta_persona_x_id'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_consulta_persona_x_id" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_consulta_persona_x_id(
-- drop procedure sp_consulta_persona_x_id
@pi_id_usuario          numeric(18,0),
@pi_id_persona          numeric(18,0), 
@po_c_error  typ_c_error output,
@po_d_error  typ_d_error output
)
as

--objetivo: consultar por id de persona

begin

  if (@pi_id_usuario  is null or @pi_id_usuario = 0)
    begin
      set @po_c_error = 3
      set @po_d_error = 'No se recibi? usuario'
      return       
  end
  
  if (@pi_id_persona  is null or @pi_id_persona = 0)
    begin
      set @po_c_error = 3
      set @po_d_error = 'No se recibi? id de persona'
      return       
  end
  
  declare @cant_filas int
  
  set @po_c_error = 0
  set @po_d_error = null

  select p.c_documento,
         p.n_documento,
         p.d_apellido,
         p.d_nombre,
         p.d_cuil,
         p.f_nacimiento,
         p.c_nacionalidad,
         p.c_ocupacion,
         p.c_estado_civil,
         --p.n_telefono,
         p.d_mail,
         p.d_calle,
         p.d_nro,
         p.d_piso,
         p.d_depto,
         p.d_localidad,
         p.c_provincia,
         p.c_sexo,
         p.e_registro
    from sagt_personas p
   where p.id_persona = @pi_id_persona
   
  set @po_c_error = @@error,
      @cant_filas = @@rowcount

  if (@po_c_error  <> 0)
  begin 
      set @po_d_error =  convert(varchar,@po_c_error) 
                         + ' - Error al consultar por id de persona. '
      return
  end
  
  if (@cant_filas = 0)
    begin
      set @po_c_error = 1
      set @po_d_error = 'No se encontraron datos. '
      return      
    end

end --sp_consulta_persona_x_id
 
go 

Grant Execute on dbo.sp_consulta_persona_x_id to GrpTrpSabed 
go

sp_procxmode 'sp_consulta_persona_x_id', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_consulta_personas'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_consulta_personas" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_consulta_personas(    
 @pi_id_usuario          numeric(18,0),  
 @pi_c_tpo_doc           numeric(18,0),       
 @pi_n_documento         numeric(18,0),  
 @pi_apellido            varchar(40),  
 @pi_nombre              varchar(40),
 @po_c_error             typ_c_error output,  
 @po_d_error             typ_d_error output  
)  
as  
  
/*  
objetivo: consultar por filtros una persona; por tipo y nro de documento  
          o por nombre y apellido
          en esta consulta se filtra al administrador del sistema
*/  
  
begin  
  
/*  
declare   
@pi_c_tpo_doc           numeric(18,0),     
@pi_n_documento         numeric(18,0),  
@pi_apellido            varchar(40),  
@pi_nombre              varchar(40)

set @pi_c_tpo_doc           = 1  
set @pi_n_documento         = null  
set @pi_apellido            = null  
set @pi_nombre              = 'USU'

*/  
  
  if (@pi_id_usuario  is null or @pi_id_usuario = 0)  
    begin  
      set @po_c_error = 3
      set @po_d_error = 'No se recibi?suario'  
      return         
    end  
    
  declare @cant_filas int  
    
  set @po_c_error = 0  
  set @po_d_error = null  
  
  select distinct p.id_persona,  
         p.c_documento,  
         pa.d_valor desc_documento,  
         p.n_documento,  
         p.d_apellido,  
         p.d_nombre,  
         p.d_cuil,  
         p.f_nacimiento,  
         p.c_nacionalidad,  
         p.c_ocupacion,  
         p.c_estado_civil,  
         p.d_mail,  
         p.c_provincia,  
         p.d_localidad,  
         p.d_calle,  
         p.d_nro,  
         p.d_piso,  
         p.d_depto,           
         p.c_sexo,  
         p.e_registro, 
         null m_edita -- se puso solo para que queden todos iguales            
    from sagt_personas p
    inner join sapt_parametros pa on p.c_documento = pa.id_parametro 
    where (  
          (p.c_documento    = @pi_c_tpo_doc or isnull(@pi_c_tpo_doc,0) = 0 ) and 
          (p.n_documento    = @pi_n_documento or isnull(@pi_n_documento,0) = 0 ) and 
          (upper(p.d_apellido)     like  '%' + upper(@pi_apellido) + '%' or @pi_apellido is null) and 
          (upper(p.d_nombre)       like  '%' + upper(@pi_nombre) + '%' or  @pi_nombre is null)
          )
          and n_documento <> 100 --filtro el administrador del sistema 
  
  set @po_c_error = @@error,  
      @cant_filas = @@rowcount  
           
  if (@po_c_error  <> 0)  
  begin   
     set @po_d_error =  convert(varchar,@po_c_error)   
                        + ' - Error al consultar por filtros de persona . '  
  end  
  
  if (@cant_filas = 0)	  
    begin  
      set @po_c_error = 1  
      set @po_d_error = 'No se encontraron datos. '  
      return        
    end  
 
end --sp_consulta_personas


go 

Grant Execute on dbo.sp_consulta_personas to GrpTrpSabed 
go

sp_procxmode 'sp_consulta_personas', anymode
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_consulta_postulante'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_consulta_postulante" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_consulta_postulante(      
 @pi_id_usuario          numeric(18,0),    
 @pi_c_tpo_doc           numeric(18,0),         
 @pi_n_documento         numeric(18,0),    
 @pi_apellido            varchar(40),    
 @pi_nombre              varchar(40),
 @po_c_error             typ_c_error output,    
 @po_d_error             typ_d_error output    
)    
as    
   
/*    
--objetivo: consultar los postulantes  
--por tipo y nro de documento    
--o por nombre y apellido    
*/    
begin    
    
  if (@pi_id_usuario  is null or @pi_id_usuario = 0)    
    begin    
      set @po_c_error = 3
      set @po_d_error = 'No se recibi? usuario'    
      return           
    end    
      
  set @po_c_error = 0    
  set @po_d_error = null    
   
  declare    
   @dummy       numeric(18,0),      
   @id_ong_usu  numeric(18,0),   
   @id_tutor    numeric(18,0),  
   @cant_filas  int 
   
  set @id_tutor = null  
   
  -- Obtengo la ONG de quien esta logueado 
  -- El procedure, si es del equipo de becas o superior en jerarquia, 
  -- la ONG viene en NULL  
  execute sp_obtiene_ong_usu  @pi_id_usuario = @pi_id_usuario,   
                              @pi_id_perfil  = @dummy,   
                              @po_id_ong     = @id_ong_usu output,   
                              @po_c_error    = @po_c_error output,   
                              @po_d_error    = @po_d_error output                          
  if (@po_c_error  <> 0) 
	begin
		set @po_d_error = 'Error llamando a sp_obtiene_ong_usu : ' + @po_d_error
		return   
	end
   
  -- 
  -- Veo si el usuario logueado es Tutor   
  select @id_tutor = id_tutor  
    from sasv_usuarios_tut   
   where id_usuario = @pi_id_usuario                               
   
  -- 
  -- Obtengo los datos de los alumnos   
  select distinct      
         p.id_persona,    
         p.c_documento,    
         pa.d_valor desc_documento,    
         p.n_documento,    
         p.d_apellido,    
         p.d_nombre,    
         p.d_cuil,    
         p.f_nacimiento,    
         p.c_nacionalidad,    
         p.c_ocupacion,    
         p.c_estado_civil,    
         p.d_mail,    
         p.c_provincia,    
         p.d_localidad,    
         p.d_calle,    
         p.d_nro,    
         p.d_piso,    
         p.d_depto,             
         p.c_sexo,    
         p.e_registro,   
         case when @id_ong_usu is null Then 'S' -- quiere decir que es Equipo de becas o superior  
              when @id_ong_usu = tut.id_ong and @id_tutor is null Then 'S' -- quiere decir que es ADM ONG o Coordinador ONG  
              when tut.id_ong = @id_ong_usu and exists (select 1  
                                                          from sagt_alumnos_tutores alutut2  
                                                         where alutut2.id_tutor = @id_tutor 
                                                           and alutut2.id_alumno = alu.id_alumno) then 'S'  
              else 'N' end m_edita    
    
    from sagt_personas p    
    inner join sapt_parametros pa on p.c_documento = pa.id_parametro 
    inner join saat_alumnos alu on alu.id_persona = p.id_persona     
    inner join sagt_alumnos_tutores alutut on alutut.id_alumno = alu.id_alumno -- para saber la ONG del alumno 
    inner join saft_tutores tut on tut.id_tutor = alutut.id_tutor -- para saber la ONG del alumno             
    where (    
        (p.c_documento    = @pi_c_tpo_doc or isnull(@pi_c_tpo_doc,0) = 0 ) and 
        (p.n_documento    = @pi_n_documento or isnull(@pi_n_documento,0) = 0 ) and 
        (upper(p.d_apellido)     like  '%' + upper(@pi_apellido) + '%' or @pi_apellido is null) and 
        (upper(p.d_nombre)       like  '%' + upper(@pi_nombre) + '%' or  @pi_nombre is null) 
    )    
      and alu.e_alumno       = 'POSTULANTE'  
      and alu.e_registro     = 'D' 
      and p.e_registro       = 'D'   
    order by 3,4 
   
  set @po_c_error = @@error,      
      @cant_filas = @@rowcount   
     
  if (@po_c_error  <> 0)   
    begin    
      set @po_d_error =  convert(varchar,@po_c_error)    
                         + ' - Error al consultar por filtros de becado. '    
      return   
  end     
   
  if (@cant_filas = 0)    
    begin    
      set @po_c_error = 1   
      set @po_d_error = 'No se encontraron datos de candidatos. '    
      return          
    end   
    
end -- sp_consulta_postulante


go 

Grant Execute on dbo.sp_consulta_postulante to GrpTrpSabed 
go

sp_procxmode 'sp_consulta_postulante', anymode
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_consulta_recargas'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_consulta_recargas" >>>>>'
go 

setuser 'dbo'
go 



create procedure sp_consulta_recargas(         
@pi_id_usuario      numeric(18,0),       
@pi_id_tutor        numeric(18,0),       
@pi_id_lote_recarga  numeric(18,0),       
@po_c_error         typ_c_error output,       
@po_d_error         typ_d_error output       
)       
as       
/*       
Objetivo: Levanta los registros para la seleccion de las recargas de tarjetas       
*/       
       
begin       
       
  if (@pi_id_usuario is null or @pi_id_usuario = 0)      
    begin       
      set @po_c_error = 3    
      set @po_d_error = 'No se recibi??????³ pi_id_usuario'       
      return              
  end       
       
  if (@pi_id_lote_recarga  is null or  @pi_id_lote_recarga = 0)    
    begin       
      set @po_c_error = 3    
      set @po_d_error = 'No se recibi??????³ pi_id_lote_recarga'       
      return              
  end       
       
  set @po_c_error = 0       
  set @po_d_error = null       
         
  declare @e_definitivo varchar(1),   
          @cant         int,   
          @id_perfil_administrativo numeric (18,0)   
   
  execute sp_obtiene_prfl_adm   
          @po_id_perfil = @id_perfil_administrativo output,   
          @po_c_error   = @po_c_error output,             
          @po_d_error   = @po_d_error output             
       
  if (@po_c_error  <> 0)             
    begin             
      set @po_d_error = 'Error llamando a sp_obtiene_prfl_adm : ' + @po_d_error     
      return                
  end     
         
  --procedure q retorna los codigos del estado de registro definitivo       
  execute sp_obtiene_e_definitivo @po_c_valor  = @e_definitivo output,       
                                  @po_c_error  = @po_c_error output,       
                                  @po_d_error  = @po_d_error output       
                                      
  if (@po_c_error  <> 0)       
  begin       
     set @po_d_error = 'Error llamando a sp_obtiene_e_definitivo : ' + @po_d_error     
     return              
  end           
       
	select distinct (ldr.id_lote_det_recarga),  
         lr.id_tutor,       
         alu.id_alumno,     
         alu.e_alumno, -- Se agrega el campo estado Alumno     
         alut.d_nro_tarjeta,  --Se aagrega el campo nro tarjeta      
         per.id_persona,        
         per.d_apellido + ', ' + per.d_nombre apenom               
	from   sagt_personas per     
		inner join saat_alumnos  alu on  alu.id_persona = per.id_persona       
		inner join sart_lotes_det_recarga ldr on alu.id_alumno = ldr.id_alumno  
		inner join sart_lotes_recarga lr on lr.id_lote_recarga = ldr.id_lote_recarga       
		inner join sagt_alumnos_tutores atut  on atut.id_alumno = alu.id_alumno   
		inner join sagt_alumnos_tutores atut2  on atut2.id_tutor = lr.id_tutor  
		LEFT JOIN saat_alumnos_tarjetas alut ON alu.id_alumno = alut.id_alumno --se agrega la tabla tarjetas_alumnos   
	where alu.e_alumno in('BECADO','POSTULANTE', 'CANDIDATO')   
		and alu.e_registro = @e_definitivo        
		and per.e_registro = @e_definitivo   
		and (lr.id_tutor = @pi_id_tutor or isnull(@pi_id_tutor,0)=0)   
		and atut.id_perfil = @id_perfil_administrativo --SOLO TRAIGO LOS ALUMNOS Q LO TIENEN COMO ADMINISTRATIVO   
		and lr.id_lote_recarga = @pi_id_lote_recarga 
		and alut.f_baja is null 		-- se agrega condicion para que solo traiga la ultima tarjeta vigente 
		order by alut.d_nro_tarjeta  
        
  set @po_c_error = @@error,@cant=@@rowcount   
  if (@po_c_error  <> 0)       
  begin        
      set @po_d_error =  convert(varchar,@po_c_error)        
                         + ' - Error al consultar para recargas. '          
      return       
  end       
  if @cant = 0   
    begin      
      set @po_c_error = 1     
      set @po_d_error = 'No se encontraron becarios'      
      return             
  end   
end -- sp_consulta_recargas  
 



go 

Grant Execute on dbo.sp_consulta_recargas to GrpTrpSabed 
go

sp_procxmode 'sp_consulta_recargas', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_consulta_rend_otros_gastos'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_consulta_rend_otros_gastos" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_consulta_rend_otros_gastos (
@pi_id_persona               numeric(18,0),
@pi_id_periodo               numeric(18,0),
@po_c_error                 typ_c_error output,
@po_d_error                 typ_d_error output
)
as
-- Objetivo: consultar una rendicion de gastos
-- Parametros de entrada:
--   a.ID alumno: se enviar? el identificador del motivo seleccionado. 
--   b.Periodo : per?odo al que corresponde el gasto con el formato YYYYMM
--

begin

  --
  -- verifico los par?metros de entrada
  if (@pi_id_persona is null or @pi_id_persona = 0)
    begin
      set @po_c_error = 3
      set @po_d_error = 'No se recibi? el alumno '
      return       
  end
  if (@pi_id_periodo is null or @pi_id_periodo = 0)
    begin
      set @po_c_error = 3
      set @po_d_error = 'No se recibi? el per?odo a informar'
      return       
  end

  declare 
    @vc_otros_gastos numeric(18,0)

  --
  -- Obtengo el valor de Otros
  Select @vc_otros_gastos=id_parametro 
    from sapt_parametros 
   where id_tabla=9 
     and d_valor ='#OTROS#'
  If (@@rowcount = 0)
  begin
    set @po_c_error = 3
    set @po_d_error = 'No se pudo establecer el c?digo de rendicion para otros gastos'
    return       
  end
  
  Select gasto.id_rendicion,
         gasto.id_alumno,
         convert(char(12),gasto.f_rend_gasto,112) f_rend_gasto, -- cambiado por bsilvestre: (gasto.f_rend_gasto)
         gasto.id_periodo,
         convert(varchar,gasto.i_gasto) i_gasto, 
         gasto.x_descrip_otros_gastos
    From saat_detalle_rend_gasto gasto inner join saat_alumnos alu
      on gasto.id_alumno = alu.id_alumno inner join sagt_personas per
      on alu.id_persona = per.id_persona
   Where per.id_persona = @pi_id_persona
     and gasto.id_periodo = @pi_id_periodo
     and gasto.c_gasto  =  @vc_otros_gastos
     and alu.e_registro= 'D'
     and per.e_registro= 'D'
   Order by gasto.f_rend_gasto
   
  set @po_c_error = @@error   
  if (@po_c_error  <> 0)
  begin 
      set @po_d_error =  convert(varchar,@po_c_error) 
                         + ' -  Error al recuperar el detalle de gastos. '
      return
  end

end  --sp_consulta_rend_otros_gastos
 
go 

Grant Execute on dbo.sp_consulta_rend_otros_gastos to GrpTrpSabed 
go

sp_procxmode 'sp_consulta_rend_otros_gastos', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_consulta_rendicion_gastos'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_consulta_rendicion_gastos" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_consulta_rendicion_gastos (   
@pi_id_usuario        numeric(18,0),   
@pi_id_persona        numeric(18,0),   
@pi_id_periodo        numeric(18,0),   
@po_c_error           typ_c_error output,   
@po_d_error           typ_d_error output   
)  
   
as   
-- Objetivo: consultar una rendicion de gastos   
-- Parametros de entrada:   
--   a.ID alumno: se enviar? el identificador del motivo seleccionado.    
--   b.Periodo : per?odo al que corresponde el gasto con el formato YYYYMM   
   
begin   
  
  --   
  -- verifico los par?metros de entrada   
  if (@pi_id_persona is null or @pi_id_persona=0)   
    begin   
      set @po_c_error = 3  
      set @po_d_error = 'No se recibi? el alumno '   
      return          
  end   
   
  if (@pi_id_periodo is null or @pi_id_periodo =0)   
    begin   
      set @po_c_error = 2   
      set @po_d_error = 'No se inform? per?odo'
      return          
  end   
   
  declare    
    	  @vc_otros_gastos numeric(18,0),   
          @cant_filas     int   
            
    
  set @po_c_error = 0    
  set @po_d_error = null    
   
  -- verifica si el usuario loggeado @pi_id_usuario puede acceder al alumno @pi_id_persona  
  execute sp_verifica_accesibilidad  
                    @pi_id_usuario = @pi_id_usuario,  
                    @pi_id_persona = @pi_id_persona,  
                    @po_c_error    = @po_c_error output,  
                    @po_d_error    = @po_d_error output  
                                 
  if (@po_c_error  <> 0)     
  begin  
	  set @po_d_error = 'Error llamando a sp_verifica_accesibilidad : ' + @po_d_error
      return      
  end   
   
  --  
  -- Obtengo el valor de Otros  
  select @vc_otros_gastos=id_parametro    
    from sapt_parametros   
   where id_tabla=9 and d_valor ='#OTROS#'  
  If (@@rowcount = 0)  
    begin  
      set @po_c_error = 3  
      set @po_d_error = 'No se pudo establecer el c?digo de rendicion para otros gastos'  
      return         
  end  
     
 Select gasto.id_rendicion,   
        gasto.id_alumno,   
        convert(char(12),gasto.f_rend_gasto,112) f_rend_gasto, -- cambiado por bsilvestre: (gasto.f_rend_gasto)  
        gasto.id_periodo,   
        convert(varchar,gasto.i_gasto) i_gasto,   
        gasto.c_gasto,   
        param.d_valor   
    From saat_detalle_rend_gasto gasto inner join saat_alumnos alu  
        on gasto.id_alumno = alu.id_alumno inner join sagt_personas per  
        on alu.id_persona = per.id_persona, sapt_parametros param   
  Where per.id_persona = @pi_id_persona  
    and gasto.id_periodo = @pi_id_periodo   
    and gasto.c_gasto   <> @vc_otros_gastos   
    and param.id_parametro  = gasto.c_gasto   
    and alu.e_registro= 'D'  
    and per.e_registro= 'D'  
  Order by gasto.f_rend_gasto   
   
set @po_c_error = @@error  
if (@po_c_error  <> 0)  
begin   
  set @po_d_error =  convert(varchar,@po_c_error)   
                     + ' - Error al recuperar el detalle de gastos. '  
  return  
end  
    
end  --sp_consulta_rendicion_gastos
 
go 

Grant Execute on dbo.sp_consulta_rendicion_gastos to GrpTrpSabed 
go

sp_procxmode 'sp_consulta_rendicion_gastos', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_consulta_tablero'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_consulta_tablero" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_consulta_tablero(      
@pi_id_usuario  numeric(18,0),   
@pi_id_tutor    numeric(18,0),   
@pi_id_ong      numeric(18,0),   
@pi_id_opcion   varchar(20),   
@po_ver_sa      int           output,   
@po_ver_rg      int           output,   
@po_ver_alumnos int           output,   
@po_ver_tutores int           output,   
@po_ver_ong     int           output,  
@po_ver_tj      int           output,    
@po_c_error     typ_c_error   output,   
@po_d_error     typ_d_error   output   
)   
as   
--   
--objetivo: obtener la consulta que solicita el tablero de pendientes   
--de acuerdo al nivel del usuario loggeado   
--   
--Valores posibles para el param: @pi_id_opcion   
   
--ALU_SIN_RG   
--ALU_SIN_SA   
--CANDIDA_GA   
--ALU_RECHA   
--ALU_BAJA   
--ALU_SUSP   
--ONG_GA   
--ALU_STJ 
--ALU_POS 
--ALU_BECA 
-----------------------------------------------   
   
begin   
   
  declare    
      @anio int   
   
  set @po_c_error = 0   
  set @po_d_error = null   
  set @anio = datepart(yy, getDate())   
   
  -- 
  -- inicializo las variables de salida 
  set @po_ver_sa = 0   
  set @po_ver_rg = 0   
  set @po_ver_alumnos = 0   
  set @po_ver_tutores = 0   
  set @po_ver_ong = 0   
  set @po_ver_tj = 0 
   
  if @pi_id_opcion = 'ALU_POS'   
  begin   
      execute sp_cons_alumnos_estados   
                    @pi_anio       = @anio,    
                    @pi_id_tutor   = @pi_id_tutor,   
                    @pi_id_ong     = @pi_id_ong,   
                    @pi_estado     = 'POSTULANTE', 
                    @po_c_error    = @po_c_error output,   
                    @po_d_error    = @po_d_error output      
   
      if (@po_c_error  <> 0)   
      begin    
            set @po_d_error =  'Error llamando a sp_cons_alumnos_estados : ' + @po_d_error
           return   
      end      
         
      set @po_ver_alumnos = 1   
  end   
   
  if @pi_id_opcion = 'ALU_BECA'   
  begin   
      execute sp_cons_alumnos_estados   
                    @pi_anio       = @anio,    
                    @pi_id_tutor   = @pi_id_tutor,   
                    @pi_id_ong     = @pi_id_ong,   
                    @pi_estado     = 'BECADO', 
                    @po_c_error    = @po_c_error output,   
                    @po_d_error    = @po_d_error output      
   
      if (@po_c_error  <> 0)   
      begin    
            set @po_d_error =  'Error llamando a sp_cons_alumnos_estados : ' + @po_d_error   
            return   
      end      
         
      set @po_ver_alumnos = 1   
  end  
   
  if @pi_id_opcion = 'ALU_STJ'   
  begin   
      execute sp_alumnos_starjeta   
                    @pi_anio       = @anio,    
                    @pi_id_tutor   = @pi_id_tutor,   
                    @pi_id_ong     = @pi_id_ong,   
                    @po_c_error    = @po_c_error output,   
                    @po_d_error    = @po_d_error output      
   
      if (@po_c_error  <> 0)   
      begin    
            set @po_d_error =  'Error llamando a sp_alumnos_starjeta : ' + @po_d_error   
           return   
      end      
         
      set @po_ver_tj = 1   
  end  
   
  if @pi_id_opcion = 'ALU_SIN_RG'   
  begin   
      execute sp_alumnos_sin_rend_gastos   
                    @pi_anio       = @anio,    
                    @pi_id_tutor   = @pi_id_tutor,   
                    @pi_id_ong     = @pi_id_ong,   
                    @po_c_error    = @po_c_error output,   
                    @po_d_error    = @po_d_error output      
   
      if (@po_c_error  <> 0)   
      begin    
            set @po_d_error =  'Error llamando a sp_alumnos_sin_rend_gastos : ' + @po_d_error
            return  
      end      
         
      set @po_ver_rg = 1   
  end   
   
  if @pi_id_opcion = 'ALU_SIN_SA'   
  begin   
      execute sp_alumnos_sin_eval_acad   
                    @pi_anio       = @anio,    
                    @pi_id_tutor   = @pi_id_tutor,   
                    @pi_id_ong     = @pi_id_ong,   
                    @po_c_error    = @po_c_error output,   
                    @po_d_error    = @po_d_error output       
   
      if (@po_c_error  <> 0)   
      begin    
            set @po_d_error =  'Error llamando a sp_alumnos_sin_eval_acad : ' + @po_d_error
            return   
      end         
         
      set @po_ver_sa = 1   
  end      
   
  if @pi_id_opcion = 'CANDIDA_GA'   
  begin   
      execute sp_candidatos_en_ga   
                    @pi_anio       = @anio,    
                    @pi_id_tutor   = @pi_id_tutor,   
                    @pi_id_ong     = @pi_id_ong,   
                    @po_c_error    = @po_c_error output,   
                    @po_d_error    = @po_d_error output        
   
      if (@po_c_error  <> 0)   
      begin    
            set @po_d_error =  'Error llamando a sp_candidatos_en_ga : ' + @po_d_error
            return   
      end         
         
      set @po_ver_alumnos = 1   
  end     
   
  if @pi_id_opcion = 'ALU_RECHA'   
  begin   
      execute sp_alumnos_beca_recha   
                    @pi_anio       = @anio,    
                    @pi_id_tutor   = @pi_id_tutor,   
                    @pi_id_ong     = @pi_id_ong,   
                    @po_c_error    = @po_c_error output,   
                    @po_d_error    = @po_d_error output        
   
      if (@po_c_error  <> 0)   
      begin    
            set @po_d_error =  'Error llamando a sp_alumnos_beca_recha : ' + @po_d_error
            return 
      end         
         
      set @po_ver_alumnos = 1   
  end     
     
  if @pi_id_opcion = 'ALU_BAJA'   
  begin   
      execute sp_alumnos_beca_baja   
                    @pi_anio       = @anio,    
                    @pi_id_tutor   = @pi_id_tutor,   
                    @pi_id_ong     = @pi_id_ong,   
                    @po_c_error    = @po_c_error output,   
                    @po_d_error    = @po_d_error output     
   
      if (@po_c_error  <> 0)   
      begin    
            set @po_d_error =  'Error llamando a sp_alumnos_beca_baja : ' + @po_d_error
           return
      end         
         
      set @po_ver_alumnos = 1   
  end   
                       
  if @pi_id_opcion = 'ALU_SUSP'   
  begin   
      execute sp_alumnos_beca_susp   
                    @pi_anio       = @anio,    
                    @pi_id_tutor   = @pi_id_tutor,   
                    @pi_id_ong     = @pi_id_ong,   
                    @po_c_error    = @po_c_error output,   
                    @po_d_error    = @po_d_error output    
   
      if (@po_c_error  <> 0)   
      begin    
            set @po_d_error =  'Error llamando a sp_alumnos_beca_susp : ' + @po_d_error    
return
      end         
         
      set @po_ver_alumnos = 1   
  end   
                       
  if @pi_id_opcion = 'ONG_GA'   
  begin   
      execute sp_ong_en_ga   
                    @pi_anio       = @anio,   
                    @pi_id_ong     = @pi_id_ong,   
                    @po_c_error    = @po_c_error output,   
                    @po_d_error    = @po_d_error output    
   
      if (@po_c_error  <> 0)   
      begin    
            set @po_d_error =  'Error llamando a sp_ong_en_ga : ' + @po_d_error    
            return  
      end         
         
      set @po_ver_ong = 1   
  end   
  
/*   
  if @pi_id_opcion = 'TUTOR_GA'   
  begin   
      execute sp_tutor_en_ga   
                    @pi_id_tutor   = @pi_id_tutor,   
                    @pi_id_ong     = @pi_id_ong,   
                    @po_c_error    = @po_c_error output,   
                    @po_d_error    = @po_d_error output    
   
      if (@po_c_error  <> 0)   
      begin    
            set @po_d_error =  'Error llamando a sp_tutor_en_ga : ' + @po_d_error    
            set @po_c_error = 3   
      end         
         
      set @po_ver_tutores = 1   
  end   
  */  
    
end -- sp_consulta_tablero
 
go 

Grant Execute on dbo.sp_consulta_tablero to GrpTrpSabed 
go

sp_procxmode 'sp_consulta_tablero', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_consulta_tarjeta_tit'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_consulta_tarjeta_tit" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_consulta_tarjeta_tit( 
 @pi_id_usuario          numeric(18,0), 
 @pi_id_persona          numeric(18,0), 
 @pi_id_alu_tar          numeric(18,0), 
 @po_id_alumno           numeric(18,0) output, 
 @po_id_persona_tit      numeric(18,0) output, 
 @po_ape_nom_titular     varchar(90)   output, 
 @po_d_descrip_doc 	     varchar(150)  output, 
 @po_n_documento 	       numeric(18)   output, 
 @po_d_nro_tarjeta       varchar(16)   output, 
 @po_d_nro_cta_cred      varchar(10)   output, 
 @po_f_vigencia_tar_dsd  varchar(19)   output, 
 @po_f_vigencia_tar_hta  varchar(19)   output, 
 @po_f_baja              varchar(19)   output, 
 @po_c_error             typ_c_error   output,  
 @po_d_error             typ_d_error   output  
)  
as  
--  
--objetivo: Con el @pi_id_persona q viene como par?metro obtengo  
--el alumno correspondiente y posteriormente busco los datos del titular. 
-- 
begin  
    declare 
      @id_alumno           numeric(18,0), 
      @f_vigencia_tar_dsd  datetime, 
      @f_vigencia_tar_hta  datetime, 
      @f_baja              datetime 
 
  -- 
  -- Valido los par?metros de entrada 
  if (@pi_id_persona is null or @pi_id_persona = 0)    
  begin  
      set @po_c_error = 3
      set @po_d_error = 'No se recibi? el identificador de persona para el usuario en cuesti?n'  
      return         
  end 
 
  if (@pi_id_usuario is null or @pi_id_usuario = 0)    
  begin  
      set @po_c_error = 3 
      set @po_d_error = 'No se recibi? identificador de usuario'  
      return         
  end 
   
  -- Obtengo el id de alumno 
  select @id_alumno = id_alumno  
  	from saat_alumnos 
  where e_alumno in ('BECADO','SUSPENDIDO')
    and id_persona = @pi_id_persona 
   
  set  @po_id_alumno = @id_alumno 
   
  if exists (select 1 
               from saat_alumnos_tarjetas 
              where id_alumno = @id_alumno 
              and id_alu_tar = @pi_id_alu_tar 
            )             
  begin 
      --es el n?mero de cta visa y el n?mero de la tarjeta, m?s fechas de vig. 
      select 
             @po_id_alumno   = id_alumno, 
             @po_id_persona_tit     = id_persona_tit, 
             @po_d_nro_tarjeta      = d_nro_tarjeta, 
             @po_d_nro_cta_cred     = d_nro_cta_cred, 
             @f_vigencia_tar_dsd = f_vigencia_tar_dsd, 
             @f_vigencia_tar_hta = f_vigencia_tar_hta, 
             @f_baja = f_baja 
        from saat_alumnos_tarjetas 
       where id_alumno = @id_alumno 
         and id_alu_tar = @pi_id_alu_tar 
 
       set @po_c_error = @@error   
        
       if (@po_c_error  <> 0) 
       begin  
           set @po_d_error =  'Error al consultar de alumnos tarjetas. ' 
return
       end        
 
  end 
  else 
  begin 
      --s?lo hay un miembro del grupo familiar q es titular de la tarjeta 
      select @po_id_persona_tit     = id_persona_rel 
        from saat_alumnos_parentesco 
       where id_alumno = @id_alumno 
         and m_tit_tarjeta = 'S' 
 
       set @po_c_error = @@error   
        
       if (@po_c_error  <> 0) 
       begin   
           set @po_d_error =  'Error al consultar de alumnos parentesco. ' 
return
       end        
  end 
 
  --retorna datos del titular y de la tarjeta 
  select @po_ape_nom_titular = pe.d_apellido + ', ' + pe.d_nombre, 
         @po_d_descrip_doc = pa.d_valor, 	 
         @po_n_documento 	= pe.n_documento 
    from sagt_personas pe, sapt_parametros pa 
  where pe.id_persona = @po_id_persona_tit 
    and pa.id_parametro = pe.c_documento 
 
  set @po_c_error = @@error   
   
  if (@po_c_error  <> 0) 
  begin  
      set @po_d_error =  'Error al consultar datos de personas. '
return 
  end 
 
  -- convierto fechas a varchar 
  execute sp_convierte_fecha_en_char @pi_fecha_datetime = @f_vigencia_tar_dsd,     
                                     @po_fecha_char     = @po_f_vigencia_tar_dsd   output,     
                                     @po_c_error        = @po_c_error output,     
                                     @po_d_error        = @po_d_error output     
  if (@po_c_error  <> 0) 
	begin
		set @po_d_error = 'Error llamando a sp_convierte_fecha_en_char : ' + @po_d_error 
		return 
	end
   
  execute sp_convierte_fecha_en_char @pi_fecha_datetime = @f_vigencia_tar_hta,     
                                     @po_fecha_char     = @po_f_vigencia_tar_hta   output,     
                                     @po_c_error        = @po_c_error output,     
                                     @po_d_error        = @po_d_error output 
  if (@po_c_error  <> 0) 
 	begin
		set @po_d_error = 'Error llamando a sp_convierte_fecha_en_char : ' + @po_d_error 
		return 
	end 
   
  execute sp_convierte_fecha_en_char @pi_fecha_datetime = @f_baja,     
                                     @po_fecha_char     = @po_f_baja   output,     
                                     @po_c_error        = @po_c_error output,     
                                     @po_d_error        = @po_d_error output 
  if (@po_c_error  <> 0) 
   	begin
		set @po_d_error = 'Error llamando a sp_convierte_fecha_en_char : ' + @po_d_error 
		return 
	end 
   
  -- po_f_vigencia_tar_hta 
 
end --sp_consulta_tarjeta_tit
 
go 

Grant Execute on dbo.sp_consulta_tarjeta_tit to GrpTrpSabed 
go

sp_procxmode 'sp_consulta_tarjeta_tit', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_consulta_tarjeta_tit_parent'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_consulta_tarjeta_tit_parent" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_consulta_tarjeta_tit_parent(  
 @pi_id_usuario          numeric(18,0),  
 @pi_id_alumno           numeric(18,0),  
 @pi_id_periodo_recarga  numeric(18,0),  
 @po_d_parentesco        varchar(150)  output,   
 @po_id_alumno           numeric(18,0) output, 
 @po_id_persona_tit      numeric(18,0) output,  
 @po_ape_nom_titular     varchar(90)   output,  
 @po_d_descrip_doc 	     varchar(150)  output,  
 @po_n_documento 	     numeric(18)   output,  
 @po_d_nro_tarjeta       varchar(16)   output,  
 @po_d_nro_cta_cred      varchar(10)   output,  
 @po_f_vigencia_tar_dsd  varchar(19)   output,  
 @po_f_vigencia_tar_hta  varchar(19)   output,  
 @po_f_baja              varchar(19)   output,  
 @po_c_error             typ_c_error   output,   
 @po_d_error             typ_d_error   output   
)   
as   
begin

  declare 
      @cant           int,
      @id_persona     numeric(18,0),
      @id_alu_tar     numeric(18,0)

  select @id_persona = alu.id_persona
  from saat_alumnos alu
  where alu.e_alumno in ('BECADO','SUSPENDIDO')
    and alu.id_alumno = @pi_id_alumno

  select @id_alu_tar = atar.id_alu_tar
    from saat_alumnos_tarjetas atar,
         sact_periodos_recargas per
   where atar.id_alumno = @pi_id_alumno  
     and per.id_periodo_recarga = @pi_id_periodo_recarga
     and per.f_fin_periodo <= atar.f_vigencia_tar_hta
     and atar.f_baja is null


  --obtengo los separadores de registros y de campos  
  execute sp_consulta_tarjeta_tit
                  @pi_id_usuario 	 = @pi_id_usuario,
                  @pi_id_persona 	 = @id_persona,
                  @pi_id_alu_tar 	 = @id_alu_tar,
                  @po_id_alumno 	 = @po_id_alumno          output,
                  @po_id_persona_tit 	 = @po_id_persona_tit     output,
                  @po_ape_nom_titular	 = @po_ape_nom_titular    output,
                  @po_d_descrip_doc 	 = @po_d_descrip_doc      output,
                  @po_n_documento 	 = @po_n_documento        output,
                  @po_d_nro_tarjeta 	 = @po_d_nro_tarjeta      output,
                  @po_d_nro_cta_cred 	 = @po_d_nro_cta_cred     output,
                  @po_f_vigencia_tar_dsd = @po_f_vigencia_tar_dsd output,
                  @po_f_vigencia_tar_hta = @po_f_vigencia_tar_hta output,
                  @po_f_baja 		 = @po_f_baja             output,
                  @po_c_error            = @po_c_error 		  output,     
                  @po_d_error            = @po_d_error 		  output   
   
    if (@po_c_error  <> 0)   
    begin   
	  set @po_d_error = 'Error llamando a sp_separador_registros : ' + @po_d_error 
      return          
    end

  select @po_d_parentesco = p.d_valor
  from saat_alumnos_parentesco ap,
       sapt_parametros p
  where ap.id_alumno = @pi_id_alumno
    and ap.id_persona_rel = @po_id_persona_tit
    and ap.c_parentesco = p.id_parametro

    set @po_c_error = @@error

    if (@po_c_error  <> 0)   
    begin   
	  set @po_d_error = 'Error obteniendo el parentesco con el titular. '
      return          
    end
    
end --sp_consulta_tarjeta_tit_parent
 
go 

Grant Execute on dbo.sp_consulta_tarjeta_tit_parent to GrpTrpSabed 
go

sp_procxmode 'sp_consulta_tarjeta_tit_parent', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_consulta_tarjetas'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_consulta_tarjetas" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_consulta_tarjetas( 
 @pi_id_usuario          numeric(18,0), 
 @pi_id_persona          numeric(18,0), 
 @po_c_error             typ_c_error   output,  
 @po_d_error             typ_d_error   output  
)  
as  
--  
--objetivo: Obtener los datos de todas las tarjetas del alumno. 
-- 
begin  
 
  -- Valido los par?metros de entrada 
  if (@pi_id_usuario is null or @pi_id_usuario = 0)    
  begin  
      set @po_c_error = 3 
      set @po_d_error = 'No se recibi? identificador de usuario'  
      return         
  end 
   
  if (@pi_id_persona is null or @pi_id_persona = 0)  
	  begin  
	      set @po_c_error = 3
	      set @po_d_error = 'No se recibi? el identificador de persona para el Alumno en cuesti?n'  
	      return         
	  end 
 
    declare 
      @id_alumno  numeric(18,2) 
   
  -- Obtengo el id de alumno 
  select @id_alumno = id_alumno  
  	from saat_alumnos 
  where id_persona = @pi_id_persona 
  	 
  if exists (select 1 
               from saat_alumnos_tarjetas 
              where id_alumno = @id_alumno 
            ) 
  begin 
      --es el n?mero de cta visa y el n?mero de la tarjeta, m?s fechas de vig. 
      select atar.id_alu_tar, 
             atar.id_alumno, 
             atar.d_nro_tarjeta, 
             atar.d_nro_cta_cred, 
             convert(varchar,atar.f_baja,117) f_baja, 
             pe.d_apellido + ', ' + pe.d_nombre nombre_completo, 
             pa.d_valor d_doc, 	 
             pe.n_documento              
        from saat_alumnos_tarjetas atar, 
             sagt_personas pe,  
             sapt_parametros pa 
       where id_alumno = @id_alumno 
         and pe.id_persona = atar.id_persona_tit 
         and pa.id_parametro = pe.c_documento
       order by atar.f_baja asc,atar.d_nro_tarjeta,atar.d_nro_cta_cred
 
       set @po_c_error = @@error   
        
       if (@po_c_error  <> 0) 
       begin  
           set @po_d_error =  'Error al consultar de alumnos tarjetas. '
           return 
       end        
 
  end 
  else 
  begin 
      set @po_c_error = 1 
      set @po_d_error = 'No existen datos de tarjetas para el alumno consultado. ' 
return
  end        
 
end --sp_consulta_tarjetas
 
go 

Grant Execute on dbo.sp_consulta_tarjetas to GrpTrpSabed 
go

sp_procxmode 'sp_consulta_tarjetas', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_consulta_tel_col'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_consulta_tel_col" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_consulta_tel_col(
@pi_id_colegio   numeric(18,0),
@po_c_error      typ_c_error output,
@po_d_error      typ_d_error output
) 
as

--objetivo: informa los telefonos de una institucion
--

begin

  if (@pi_id_colegio is null or @pi_id_colegio = 0)
    begin
      set @po_c_error = 3
      set @po_d_error = 'No se recibi? pi_id_colegio'
      return       
  end

  set @po_c_error = 0
  set @po_d_error = null
  
  select t.id_telefono, t.d_telefono, 
         t.c_tipo_telefono, p.d_valor, t.observaciones
    from sagt_telefonos t, sapt_parametros p
   where t.id_colegio = @pi_id_colegio
     and t.c_tipo_telefono = p.id_parametro

  set @po_c_error = @@error    

  if (@po_c_error  <> 0)
    begin 
      set @po_d_error =  convert(varchar,@po_c_error) 
                         + ' - Error al consultar telefonos de colegios. '
  end
end --sp_consulta_tel_col
 
go 

Grant Execute on dbo.sp_consulta_tel_col to GrpTrpSabed 
go

sp_procxmode 'sp_consulta_tel_col', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_consulta_tel_ong'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_consulta_tel_ong" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_consulta_tel_ong(
@pi_id_ong      numeric(18,0),
@po_c_error     typ_c_error output,
@po_d_error     typ_d_error output
) 
as

--objetivo: informa los telefonos de una institucion
--

begin

  if (@pi_id_ong is null or @pi_id_ong = 0)
    begin
      set @po_c_error = 3
      set @po_d_error = 'No se recibi? pi_id_ong'
      return       
  end

  set @po_c_error = 0
  set @po_d_error = null
  
  select t.id_telefono, t.d_telefono, 
         t.c_tipo_telefono, p.d_valor, t.observaciones
    from sagt_telefonos t, sapt_parametros p
   where t.id_ong = @pi_id_ong
     and t.c_tipo_telefono = p.id_parametro

  set @po_c_error = @@error    

  if (@po_c_error  <> 0)
    begin 
      set @po_d_error =  convert(varchar,@po_c_error) 
                         + ' - Error al consultar telefonos de ong. '
return
  end
end --sp_consulta_tel_ong
 
go 

Grant Execute on dbo.sp_consulta_tel_ong to GrpTrpSabed 
go

sp_procxmode 'sp_consulta_tel_ong', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_consulta_tel_persona'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_consulta_tel_persona" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_consulta_tel_persona(
@pi_id_persona  numeric(18,0),
@po_c_error     typ_c_error output,
@po_d_error     typ_d_error output
) 
as

--objetivo: informa los telefonos de una institucion
--

begin

  if (@pi_id_persona is null or @pi_id_persona = 0)
    begin
      set @po_c_error = 3
      set @po_d_error = 'No se recibi? pi_id_persona'
      return       
  end

  set @po_c_error = 0
  set @po_d_error = null
  
  select t.id_telefono, t.d_telefono, 
         t.c_tipo_telefono, p.d_valor, t.observaciones
    from sagt_telefonos t, sapt_parametros p
   where t.id_persona = @pi_id_persona
     and t.c_tipo_telefono = p.id_parametro

  set @po_c_error = @@error    

  if (@po_c_error  <> 0)
    begin 
      set @po_d_error =  convert(varchar,@po_c_error) 
                         + ' - Error al consultar telefonos. '
      return
  end
end --sp_consulta_tel_persona
 
go 

Grant Execute on dbo.sp_consulta_tel_persona to GrpTrpSabed 
go

sp_procxmode 'sp_consulta_tel_persona', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_consulta_tipos_beca'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_consulta_tipos_beca" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_consulta_tipos_beca(   
@pi_id_tipo_beca     numeric(18,0), 
@pi_f_inspeccion    varchar(19),  
@po_c_error         typ_c_error output,  
@po_d_error         typ_d_error output  
)  
as  
/*  
Objetivo: obtiene los tipos de beca q puede otorgar la Fundaci?n  
*/  
  
begin  
  
  set @po_c_error = 0  
  set @po_d_error = null  
    
  if @pi_f_inspeccion is null  
  begin  
      set @po_c_error = 3  
      set @po_d_error = 'No se recibio la fecha de visualizaci?n'  
      return         
  end  
    
  declare  
    @f_inspeccion smalldatetime  
     
    --convierto el varchar de entrada a date para el insert en la tabla       
  execute sp_convierte_char_en_fecha @pi_fecha_char     = @pi_f_inspeccion,       
                                     @po_fecha_datetime = @f_inspeccion output,       
                                     @po_c_error        = @po_c_error output,       
                                     @po_d_error        = @po_d_error output       
    if (@po_c_error  <> 0)       
    begin       
	  set @po_d_error = 'Error llamando a sp_convierte_char_en_fecha : ' + @po_d_error
      return              
    end  
     
  --  
  -- Busco las becas vigentes   
  select tb.id_tipo_beca c_beca,   
         tb.d_tipo_beca,   
         tbd.i_beca,           
         convert (varchar(10),tbd.f_vigencia_desde,112)  f_vigencia_desde,   
	 convert (varchar(10),tbd.f_vigencia_hasta,112) f_vigencia_hasta            
    from saat_tipo_beca tb,   
         saat_tipo_beca_detalle tbd          
    where (tb.id_tipo_beca = @pi_id_tipo_beca or @pi_id_tipo_beca is null or @pi_id_tipo_beca=0)  
      and tb.id_tipo_beca = tbd.id_tipo_beca  
      and isnull (tbd.f_vigencia_hasta,@f_inspeccion) >= @f_inspeccion 
      and tbd.f_vigencia_desde <= @f_inspeccion   
      and tb.f_baja is null  
   
  set @po_c_error = @@error     
  
  if (@po_c_error  <> 0)  
  begin   
      set @po_d_error =  convert(varchar,@po_c_error)    
                         + ' - Error en consulta de tipos de beca. '  
      return  
  end  
    
end -- sp_consulta_tipos_beca
 
go 

Grant Execute on dbo.sp_consulta_tipos_beca to GrpTrpSabed 
go

sp_procxmode 'sp_consulta_tipos_beca', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_consulta_tut_recargas'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_consulta_tut_recargas" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_consulta_tut_recargas(  
@pi_id_usuario  numeric(18,0), 
@pi_id_ong      numeric(18,0), 
@m_lista        varchar(20),     --BECARIOS - RECARGAS 
@po_c_error     typ_c_error output, 
@po_d_error     typ_d_error output 
) 
as 
 
--objetivo: retorna un cursor con los tutores administrativos de una ong 
-- 
 
begin 
 
  if (@pi_id_usuario is null or @pi_id_usuario = 0)
    begin 
      set @po_c_error = 3
      set @po_d_error = 'No se recibi? pi_id_usuario' 
      return        
  end 
   
  if (@pi_id_ong is null or @pi_id_ong = 0)
    begin 
      set @po_c_error = 3
      set @po_d_error = 'No se recibi? pi_id_ong' 
      return        
  end 
 
  if @m_lista not in ('BECARIOS' , 'RECARGAS') 
  begin 
      set @po_c_error = 3
      set @po_d_error = 'No se recibi? la marca de lista' 
      return              
  end  
 
  declare @c_perfil_adm       numeric(18,0), 
          @n_nivel_mensaje     int,  
          @e_definitivo        varchar(1) 
 
  set @c_perfil_adm = null 
  
  --procedure q retorna los codigos del estado de registro definitivo 
  execute sp_obtiene_e_definitivo @po_c_valor  = @e_definitivo output, 
                                  @po_c_error  = @po_c_error output, 
                                  @po_d_error  = @po_d_error output 
                                
  if (@po_c_error  <> 0) 
  begin 
 	 set @po_d_error = 'Error llamando a sp_obtiene_e_definitivo : ' + @po_d_error 
     return        
  end             
 
  if @m_lista = 'RECARGAS' 
  begin 
          execute sp_obtiene_prfl_adm @po_id_perfil = @c_perfil_adm output, 
                                      @po_c_error   = @po_c_error    output, 
                                      @po_d_error   = @po_d_error    output 
                                        
          if (@po_c_error  <> 0) 
          begin 
			 set @po_d_error = 'Error llamando a sp_obtiene_prfl_adm : ' + @po_d_error
             return        
          end 
  end 
   
  execute sp_nivel_usuario 
      @pi_id_usuario       = @pi_id_usuario,  
      @po_n_nivel_mensaje  = @n_nivel_mensaje output, 
      @po_c_error          = @po_c_error      output, 
      @po_d_error          = @po_d_error      output 
                             
  if (@po_c_error  <> 0) 
  begin 
   	 set @po_d_error = 'Error llamando a sp_nivel_usuario : ' + @po_d_error 
     return        
  end   
 
  if @n_nivel_mensaje = 3 --nivel de tutores
  begin 
          -- si el nivel es de tutores, s?lo devuelvo el nombre del tutor indicado
          select distinct tu.id_tutor, p.d_apellido + ', ' + p.d_nombre nombre_completo 
            from saft_tutores tu, 
                 sagt_personas p, 
                 sast_usuarios u, 
                 sast_usuarios_perfiles up 
           where tu.id_persona = p.id_persona 
             and u.id_persona = p.id_persona 
             and u.id_usuario = up.id_usuario      
             and u.id_usuario = @pi_id_usuario 
             and (up.id_perfil = @c_perfil_adm or @c_perfil_adm is null) 
             and tu.e_registro = @e_definitivo 
             and u.e_usuario = @e_definitivo 
             and up.e_usu_perfil = @e_definitivo 
             and p.e_registro = @e_definitivo 
             and tu.id_ong = @pi_id_ong  
      
  end 
  else 
  begin 
   
          execute sp_consulta_tutores_x_prfl 
                  @pi_id_usuario  = @pi_id_usuario, 
                  @pi_id_ong      = @pi_id_ong, 
                  @pi_id_perfil   = @c_perfil_adm, 
                  @po_c_error     = @po_c_error, 
                  @po_d_error     = @po_d_error 
           
              
        	  if (@po_c_error  <> 0) 
        	  begin  
        	      set @po_d_error =  'Error ' + convert(varchar,@po_c_error)  
        	                         + ' llamando a sp_consulta_tutores_x_prfl - Error al obtener tutores ' + @po_d_error
        	  end 
  end  
   
end --sp_consulta_tut_recargas
 
go 

Grant Execute on dbo.sp_consulta_tut_recargas to GrpTrpSabed 
go

sp_procxmode 'sp_consulta_tut_recargas', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_consulta_tutores'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_consulta_tutores" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_consulta_tutores(  
-- drop procedure sp_consulta_tutores   
 @pi_id_usuario          numeric(18,0),   
 @pi_c_tpo_doc           numeric(18,0),        
 @pi_n_documento         numeric(18,0),   
 @pi_apellido            varchar(40),   
 @pi_nombre              varchar(40),   
 @po_c_error             typ_c_error output,   
 @po_d_error             typ_d_error output   
)   
as   
   
--objetivo: consultar por filtros una persona para que sea TUTOR  
--por tipo y nro de documento   
--o por nombre y apellido   
   
begin   
   
  if (@pi_id_usuario  is null or @pi_id_usuario = 0)   
    begin   
      set @po_c_error = 3
      set @po_d_error = 'No se recibi? usuario'   
      return          
    end   
     
  set @po_c_error = 0   
  set @po_d_error = null   
  
  declare   
   @id_ong      numeric(18,0),  
   @m_fundacion char(1),  
   @id_perfil   numeric(18,0),  
   @cant_filas  int  
    
  execute sp_obtiene_prfl_coord_tut   
                    @po_id_perfil = @id_perfil output,  
                    @po_c_error   = @po_c_error output,  
                    @po_d_error   = @po_d_error output  
                                 
  if (@po_c_error  <> 0)  
  begin  
	 set @po_d_error = 'Error llamando a sp_obtiene_prfl_coord_tut : ' + @po_d_error
     return         
  end    
  
  --  
  -- Obtengo la ONG del usuario que intenta inspeccionar  
  Select @id_ong = ong.id_ong,  
         @m_fundacion = ong.m_fundacion  
    from sast_usuarios usu,  
         saft_personas_ong perong,  
         saft_ongs ong  
   Where usu.id_usuario = @pi_id_usuario   
     and usu.id_persona = perong.id_persona  
     and ong.id_ong = perong.id_ong  
  
  set @po_c_error = @@error,  
      @cant_filas = @@rowcount     
    
  if (@po_c_error  <> 0)  
  begin   
      set @po_d_error =  convert(varchar,@po_c_error)   
                         + ' - Error al consultar el id de ONG de un usuario. '   
      return  
  end  
    
  if (@cant_filas = 0)   
    begin   
        
      --  
      -- Veo si es un coordinador de tutores  
      Select @id_ong = ong.id_ong,  
             @m_fundacion = ong.m_fundacion  
        from sast_usuarios usu,  
             sast_usuarios_perfiles usuper,  
             saft_tutores tut,  
             saft_ongs ong  
       Where usu.id_usuario = @pi_id_usuario   
         and usu.id_usuario = usuper.id_usuario  
         and usuper.id_perfil = @id_perfil  
         and usuper.e_usu_perfil = 'D'  
         and tut.id_persona = usu.id_persona  
         and ong.id_ong = tut.id_ong  
  
      set @po_c_error = @@error,  
          @cant_filas = @@rowcount  
  
     if (@po_c_error  <> 0)  
     begin   
          set @po_d_error =  convert(varchar,@po_c_error)   
                         + ' - Error al consultar el id de ONG de un usuario. '  
          return  
     end  
  
      if (@cant_filas = 0)   
        begin   
          set @po_c_error = 1   
          set @po_d_error = 'El usuario no tiene permisos para buscar tutores'   
          return    
        end   
  
    end  
  
  
  If (@m_fundacion = 'S') set @id_ong = NULL  
  
  
  select p.id_persona,   
         p.c_documento,   
         pa.d_valor desc_documento,   
         p.n_documento,   
         p.d_apellido,   
         p.d_nombre,   
         p.d_cuil,   
         p.f_nacimiento,   
         p.c_nacionalidad,   
         p.c_ocupacion,   
         p.c_estado_civil,   
         p.d_mail,   
         p.c_provincia,   
         p.d_localidad,   
         p.d_calle,   
         p.d_nro,   
         p.d_piso,   
         p.d_depto,            
         p.c_sexo,   
         p.e_registro,  
         tut.id_tutor,  
         tut.id_ong, 
         null m_edita -- se puso solo para que queden todos iguales            
    from sagt_personas p,   
         sapt_parametros pa,   
         saft_tutores tut  
   where (      
          (p.c_documento    = @pi_c_tpo_doc or isnull(@pi_c_tpo_doc,0) = 0)      and  
          (p.n_documento    = @pi_n_documento or isnull(@pi_n_documento,0) = 0)  and  
          (upper(p.d_apellido)     like  '%' + upper(@pi_apellido) + '%' or @pi_apellido is null)        and  
          (upper(p.d_nombre)       like  '%' + upper(@pi_nombre) + '%' or  @pi_nombre is null)   
         )   
     and p.c_documento = pa.id_parametro    
     and tut.id_persona = p.id_persona  
     and (tut.id_ong = @id_ong or @id_ong is null)  
       
  set @po_c_error = @@error,  
      @cant_filas = @@rowcount     
  
  if (@po_c_error  <> 0)  
  begin   
      set @po_d_error =  convert(varchar,@po_c_error)   
                         + ' - Error al consultar por filtros de tutores. '   
      return  
  end  
  
  if (@cant_filas = 0)   
    begin   
      set @po_c_error = 1   
      set @po_d_error = 'No se encontraron datos. '   
      return         
    end   
    
end -- sp_consulta_tutores
 
go 

Grant Execute on dbo.sp_consulta_tutores to GrpTrpSabed 
go

sp_procxmode 'sp_consulta_tutores', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_consulta_tutores_adm'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_consulta_tutores_adm" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_consulta_tutores_adm( 
@pi_id_usuario  numeric(18,0), 
@pi_id_ong      numeric(18,0), 
@po_c_error     typ_c_error output, 
@po_d_error     typ_d_error output 
) 
as 
 
--objetivo: retorna un cursor con los tutores administrativos de una ong 
-- 
 
begin 
 
  if (@pi_id_usuario is null or @pi_id_usuario = 0)
    begin 
      set @po_c_error = 3
      set @po_d_error = 'No se recibi? pi_id_usuario' 
      return        
  end 
   
  if (@pi_id_ong is null or @pi_id_ong = 0)
    begin 
      set @po_c_error = 3
      set @po_d_error = 'No se recibi? pi_id_ong' 
      return        
  end 
 
  declare @id_perfil numeric(18,0) 
   
  execute sp_obtiene_prfl_adm @po_id_perfil = @id_perfil output, 
                              @po_c_error   = @po_c_error output, 
                              @po_d_error   = @po_d_error output 
                                
  if (@po_c_error  <> 0) 
  begin 
     set @po_d_error = 'Error llamando a sp_obtiene_prfl_adm : ' + @po_d_error
     return        
  end   
 
  execute sp_consulta_tutores_x_prfl 
          @pi_id_usuario  = @pi_id_usuario, 
          @pi_id_ong      = @pi_id_ong, 
          @pi_id_perfil   = @id_perfil, 
          @po_c_error     = @po_c_error, 
          @po_d_error     = @po_d_error 
   
      
  if (@po_c_error  <> 0) 
    begin  
      set @po_d_error =  'Error ' + convert(varchar,@po_c_error)  
                         + ' llamando a sp_consulta_tutores_x_prfl - Error al obtener tutores administrativos. ' + @po_d_error
return
  end 
end --sp_consulta_tutores_adm
 
go 

Grant Execute on dbo.sp_consulta_tutores_adm to GrpTrpSabed 
go

sp_procxmode 'sp_consulta_tutores_adm', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_consulta_tutores_ped'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_consulta_tutores_ped" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_consulta_tutores_ped(  
@pi_id_usuario  numeric(18,0), 
@pi_id_ong      numeric(18,0), 
@po_c_error  typ_c_error output, 
@po_d_error  typ_d_error output 
) 
as 
 
--objetivo:  
-- 
 
begin 
 
  if (@pi_id_usuario is null or @pi_id_usuario = 0)
    begin 
      set @po_c_error = 3
      set @po_d_error = 'No se recibi? pi_id_usuario' 
      return        
  end 
   
  if (@pi_id_ong is null or @pi_id_ong = 0)
    begin 
      set @po_c_error = 3
      set @po_d_error = 'No se recibi?pi_id_ong' 
      return        
  end   
 
  declare @id_perfil numeric(18,0) 
   
  execute sp_obtiene_prfl_ped @po_id_perfil = @id_perfil  output, 
                              @po_c_error   = @po_c_error output, 
                              @po_d_error   = @po_d_error output 
                                
  if (@po_c_error  <> 0) 
  begin 
     set @po_d_error = 'Error llamando a sp_obtiene_prfl_ped : ' + @po_d_error
     return        
  end   
 
  execute sp_consulta_tutores_x_prfl 
          @pi_id_usuario  = @pi_id_usuario, 
          @pi_id_ong      = @pi_id_ong, 
          @pi_id_perfil   = @id_perfil, 
          @po_c_error     = @po_c_error, 
          @po_d_error     = @po_d_error 
 
  if (@po_c_error  <> 0) 
  begin  
      set @po_d_error =  'Error ' + convert(varchar,@po_c_error)  
                         + ' llamando a sp_consulta_tutores_x_prfl - Error al obtener tutores pedag?gicos. ' + @po_d_error
return
  end 
end --sp_consulta_tutores_ped
 
go 

Grant Execute on dbo.sp_consulta_tutores_ped to GrpTrpSabed 
go

sp_procxmode 'sp_consulta_tutores_ped', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_consulta_tutores_x_prfl'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_consulta_tutores_x_prfl" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_consulta_tutores_x_prfl( 
@pi_id_usuario  numeric(18,0), 
@pi_id_ong      numeric(18,0), 
@pi_id_perfil   numeric(18,0), 
@po_c_error     typ_c_error output, 
@po_d_error     typ_d_error output 
) 
as 
 
--objetivo: Obtengo los tutores de una ONG para el perfil pasado por  
--          parametro 
-- 
 
begin 
 
  if (@pi_id_usuario is null or @pi_id_usuario = 0)
    begin 
      set @po_c_error = 3
      set @po_d_error = 'No se recibi? pi_id_usuario' 
      return        
  end 
   
  if (@pi_id_ong is null or @pi_id_ong = 0)
    begin 
      set @po_c_error = 3
      set @po_d_error = 'No se recibi? pi_id_ong' 
      return        
  end   
 
  set @po_c_error = 0 
  set @po_d_error = null 
 
  declare @e_definitivo varchar(1) 
   
  --procedure q retorna los codigos del estado de registro definitivo 
  execute sp_obtiene_e_definitivo @po_c_valor  = @e_definitivo output, 
                                  @po_c_error  = @po_c_error output, 
                                  @po_d_error  = @po_d_error output 
                                
  if (@po_c_error  <> 0) 
  begin 
	 set @po_d_error = 'Error llamando a sp_obtiene_e_definitivo : ' + @po_d_error
     return        
  end   
 
  select distinct tu.id_tutor, p.d_apellido + ', ' + p.d_nombre nombre_completo 
    from saft_tutores tu, 
         sagt_personas p, 
         sast_usuarios u, 
         sast_usuarios_perfiles up 
   where tu.id_persona = p.id_persona 
     and u.id_persona = p.id_persona 
     and u.id_usuario = up.id_usuario      
     and tu.e_registro = @e_definitivo 
     and u.e_usuario = @e_definitivo 
     and up.e_usu_perfil = @e_definitivo 
     and p.e_registro = @e_definitivo 
     and (up.id_perfil = @pi_id_perfil or @pi_id_perfil is null) 
     and tu.id_ong = @pi_id_ong 
      
  set @po_c_error = @@error     
 
  if (@po_c_error  <> 0) 
  begin  
      set @po_d_error =  convert(varchar,@po_c_error)  
                         + ' - Error al obtener tutores por perfil. ' 
return
  end 
end --sp_consulta_tutores_x_prfl
 
go 

Grant Execute on dbo.sp_consulta_tutores_x_prfl to GrpTrpSabed 
go

sp_procxmode 'sp_consulta_tutores_x_prfl', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_consulta_usuario'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_consulta_usuario" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_consulta_usuario (
	@pi_id_usuario_loggeado numeric(18,0),
	@pi_id_persona          numeric(18,0),
	@po_id_usuario          numeric(18,0) output,
	@po_nombre_usuario      varchar(40)   output,
	@po_id_ong              numeric(18,0) output,
	@po_blanquea_usu        varchar(1)    output,
	@po_c_error             typ_c_error   output,
	@po_d_error             typ_d_error   output)
as

--objetivo: consulta el nombre de usuario y los perfiles q tiene el usuario
--q se informa
--
begin
----to do-----------------------------------------------------------------------
  -- @pi_id_usuario_loggeado: se utilizar? en futuras modificaciones
  -- para filtar la info q se retorna
----to do----------------------------------------------
-------------------------

	if (@pi_id_persona is null or @pi_id_persona = 0)
	begin
		set @po_c_error = 3
		set @po_d_error = 'No se recibi? pi_id_persona'
		return
	end

	set @po_c_error = 0
	set @po_d_error = null
	set @po_blanquea_usu ='N'

	declare 
		@e_definitivo   		varchar(1),
        @dummy          		numeric(18,0),
        @id_ong_usu_log 		numeric(18,0),
        @n_nivel_mensaje_log  	int,
        @n_nivel_mensaje      	int

	--procedure q retorna los codigos del estado de registro definitivo
	execute sp_obtiene_e_definitivo @po_c_valor  = @e_definitivo output,
									@po_c_error  = @po_c_error output,
									@po_d_error  = @po_d_error output

	if (@po_c_error  <> 0)
	begin
		set @po_d_error = 'Error llamando a sp_obtiene_e_definitivo : ' + @po_d_error
		return
	end

	select 	@po_id_usuario = u.id_usuario,
			@po_nombre_usuario = d_user
	from sast_usuarios u
	where u.id_persona = @pi_id_persona

	set @po_c_error = @@error

	if (@po_c_error  <> 0)
	begin
		set @po_d_error = convert(varchar,@po_c_error) + ' - Error al obtener nombre e identificador de usuario. '
		return
	end

	--si el usuario a?n no existe (en el alta) no es necesario retornar datos
	if @po_id_usuario is null
	begin
		return
	end

	-- Veo la ONG del usuario que estamos consultado
	execute sp_obtiene_ong_usu
           @pi_id_usuario      = @po_id_usuario,
           @pi_id_perfil       = @dummy,
           @po_id_ong          = @po_id_ong  output,
           @po_c_error         = @po_c_error output,
           @po_d_error         = @po_d_error output
	if (@po_c_error  <> 0)
	begin
		set @po_d_error = 'Error llamando a sp_obtiene_ong_usu : ' + @po_d_error
		return
	end

	-- Veo la ONG del usuario logueado
	execute sp_obtiene_ong_usu
		@pi_id_usuario      = @pi_id_usuario_loggeado,
		@pi_id_perfil       = @dummy,
        @po_id_ong          = @id_ong_usu_log  	output,
        @po_c_error         = @po_c_error      	output,
        @po_d_error         = @po_d_error     	output
	if (@po_c_error  <> 0)
	begin
	  set @po_d_error = 'Error llamando a sp_obtiene_ong_usu : ' + @po_d_error
	  return
	end

	-- Veo si la la persona logueada puede mantener al usuario
	if  (@id_ong_usu_log is not null and @po_id_ong is not null and @id_ong_usu_log <> @po_id_ong) or 
		(@id_ong_usu_log is not null and @po_id_ong is null) -- ONG vs ONG
		begin
			set @po_d_error = 'No posee permisos para gestionar al usuario'
			set @po_c_error = 2
			return
		end
	else -- el caso en que se esten viendo dos usuarios que no tienen ONG
		begin
		-- Analizo los niveles de mensaje
		execute sp_nivel_usuario
				@pi_id_usuario      = @pi_id_usuario_loggeado,
				@po_n_nivel_mensaje = @n_nivel_mensaje_log    output,
				@po_c_error         = @po_c_error             output,
				@po_d_error         = @po_d_error             output
		if (@po_c_error  <> 0)
		begin
			set @po_d_error = 'Error llamando a sp_nivel_usuario : ' + @po_d_error
			return
		end

		execute sp_nivel_usuario
                @pi_id_usuario      = @po_id_usuario,
                @po_n_nivel_mensaje = @n_nivel_mensaje output,
                @po_c_error         = @po_c_error      output,
                @po_d_error         = @po_d_error      output
      
		if (@po_c_error  <> 0)
		begin
			set @po_d_error = 'Error llamando a sp_nivel_usuario : ' + @po_d_error
			return
		end

		if ((@id_ong_usu_log is null and @po_id_ong is null) or 
			(@id_ong_usu_log is not null and @po_id_ong is not null and @id_ong_usu_log = @po_id_ong)) and 
			-- misma ong o vacia y nivel equivocado
		   ((@n_nivel_mensaje_log > @n_nivel_mensaje) or 
		    (@n_nivel_mensaje_log = @n_nivel_mensaje and @n_nivel_mensaje <> 0))
		begin
			set @po_d_error = 'No posee permisos para gestionar al usuario'
			set @po_c_error = 2
			return
		end
		--
		-- Si lleg? hasta aca, se puede blanquear la clave
		set @po_blanquea_usu ='S'
	end

	select up.id_perfil, p.d_perfil , p.n_nivel_mensaje
	from 
		sast_usuarios u,
		sast_usuarios_perfiles up,
		sast_perfiles p
	where 
		u.id_persona = @pi_id_persona and 
		u.id_usuario = up.id_usuario and 
		up.id_perfil = p.id_perfil and 
		u.e_usuario = @e_definitivo and 
		up.e_usu_perfil = @e_definitivo

	set @po_c_error = @@error
	if (@po_c_error <> 0)
	begin
		set @po_d_error =  convert(varchar,@po_c_error) + ' - Error al obtener perfiles. '
		return
	end
end

go 

Grant Execute on dbo.sp_consulta_usuario to GrpTrpSabed 
go

sp_procxmode 'sp_consulta_usuario', anymode
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_control_cuit'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_control_cuit" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_control_cuit ( 
      @pi_cuil   		 numeric, 
      @po_c_error        typ_c_error   output,  
      @po_d_error        typ_d_error   output  
)  
as  
-------------------------------------------------------------------------------  
--objetivo: Controlar el digito verificador del CUIL 
-------------------------------------------------------------------------------  
begin  
  
  set @po_c_error = 0  
  set @po_d_error = null  
 
declare 
 
      @nsuma        numeric (4), 
      @nresto       numeric (2), 
      @ndife        numeric (2), 
      @ndigito      numeric (2), 
      @cdummy    	VARCHAR (10) 
  
      set @cdummy = substring (convert (varchar(11),@pi_cuil), 1, 10) 
  
      set @nsuma = 0 
      set @nsuma = convert(numeric,substring (@cdummy, 1, 1)) * 5 
      set @nsuma = @nsuma + convert(numeric,substring (@cdummy, 2, 1)) * 4 
      set @nsuma = @nsuma + convert(numeric,substring (@cdummy, 3, 1)) * 3 
      set @nsuma = @nsuma + convert(numeric,substring (@cdummy, 4, 1)) * 2 
      set @nsuma = @nsuma + convert(numeric,substring (@cdummy, 5, 1)) * 7 
      set @nsuma = @nsuma + convert(numeric,substring (@cdummy, 6, 1)) * 6 
      set @nsuma = @nsuma + convert(numeric,substring (@cdummy, 7, 1)) * 5 
      set @nsuma = @nsuma + convert(numeric,substring (@cdummy, 8, 1)) * 4 
      set @nsuma = @nsuma + convert(numeric,substring (@cdummy, 9, 1)) * 3 
      set @nsuma = @nsuma + convert(numeric,substring (@cdummy, 10, 1)) * 2 
      -- 
      set @nresto = @nsuma%11 
      set @ndife  = 11 - @nresto 
 
      if (@ndife = 10) 
      begin   
         set @po_d_error =  'Error en CUIL/CUIT' 
         set @po_c_error = 2 
         return  
      end    
 
      IF (@nresto = 0)  
         set @ndigito = 0 
      ELSE 
         set @ndigito = @ndife 
 
      If @ndigito <> convert(numeric,substring (convert (varchar(11),@pi_cuil), 11, 1)) 
      begin   
         set @po_d_error =  'Digito verificador inv?lido' 
         set @po_c_error = 2 
         return  
      end  
 
   END -- sp_control_cuit
 
go 

Grant Execute on dbo.sp_control_cuit to GrpTrpSabed 
go

sp_procxmode 'sp_control_cuit', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_convierte_char_en_fecha'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_convierte_char_en_fecha" >>>>>'
go 

setuser 'dbo'
go 

create procedure sp_convierte_char_en_fecha ( 
	@pi_fecha_char      varchar(19), 
	@po_fecha_datetime  datetime output, 
	@po_c_error    typ_c_error output, 
	@po_d_error    typ_d_error output) 
as 
begin  
 
 set @po_c_error = 0 
 set @po_d_error = null  
 
 --formato in 'dd/mm/yyyy hh:mm:ss'  
 set @po_fecha_datetime = convert(datetime, @pi_fecha_char, 111)  
 
 set @po_c_error = @@error    
   
 if (@po_c_error  <> 0) 
 begin 
    set @po_d_error = 'Error al convertir char en date: ' + @pi_fecha_char + '. ' 
    set @po_c_error = 3                  
    return              
 end 
end 

go 

Grant Execute on dbo.sp_convierte_char_en_fecha to GrpTrpSabed 
go

sp_procxmode 'sp_convierte_char_en_fecha', anymode
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_convierte_fecha_en_char'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_convierte_fecha_en_char" >>>>>'
go 

setuser 'dbo'
go 

create procedure sp_convierte_fecha_en_char ( 
@pi_fecha_datetime  datetime, 
@po_fecha_char      varchar(19) output, 
@po_c_error         typ_c_error output, 
@po_d_error         typ_d_error output 
) 
as 
begin  
 
 set @po_c_error = 0 
 set @po_d_error = null  
  
 --formato de retorno 'dd/mm/yyyy hh:mm:ss'  
 set @po_fecha_char = convert(varchar(19), @pi_fecha_datetime, 121)  
 
 set @po_c_error = @@error 
  
  if (@po_c_error  <> 0) 
  begin 
    set @po_d_error = convert(varchar,@po_c_error) +  
                      ' - Error al convertir date en char. ' 
    set @po_c_error = 3                  
    return              
  end 
 
end --sp_convierte_fecha_en_char 
 
 

go 

Grant Execute on dbo.sp_convierte_fecha_en_char to GrpTrpSabed 
go

sp_procxmode 'sp_convierte_fecha_en_char', anymode
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_crea_tarea'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_crea_tarea" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_crea_tarea (  
@pi_id_usuario              numeric(18,0), 
@pi_c_motivo_tarea          numeric(18,0), 
@pi_d_detalle               typ_lista,  
@pi_f_tarea                 varchar(19), 
@pi_l_invol                 typ_lista, 
@po_c_error                 typ_c_error output, 
@po_d_error                 typ_d_error output 
) 
 
as 
--Objetivo: crear una tarea para un usuario en una fecha 
--Parametros de entrada: 
--a.ID de usuario: identificador del usuario que crea la tarea. 
--b.Motivo: se enviar? el identificador del motivo seleccionado.  
--c.Detalle: cadena de caracteres. 
--d.Fecha de tarea: es una cadena de caracteres que tiene el formato ?yyyyMMdd?  
--f.Involucrados: recibe el perfil del destinatario; si selecciona m?s de uno, 
--  ser?n concatenados usando el s?mbolo # (?001#002?) 
 
begin 
    
  if (@pi_id_usuario is null or @pi_id_usuario = 0) 
    begin 
      set @po_c_error = 3
      set @po_d_error = 'No se recibi? usuario ' 
      return        
  end 
 
  if (@pi_d_detalle is null) 
    begin 
      set @po_c_error = 3
      set @po_d_error = 'No se recibi? el detalle de tarea ' 
      return        
  end 
 
  if (@pi_f_tarea is null) 
    begin 
      set @po_c_error = 3
      set @po_d_error = 'No se recibi? fecha de la tarea' 
      return        
  end 
     
  if (@pi_l_invol  is null) 
    begin 
      set @po_c_error = 2
      set @po_d_error = 'No se recibieron involucrados en la tarea' 
      return        
  end 
 
  if (@pi_c_motivo_tarea is null or @pi_c_motivo_tarea = 0) 
    begin 
      set @po_c_error = 2
      set @po_d_error = 'No se recibi? motivo de tarea' 
      return        
  end 
 
 
  declare  
   @aux                   typ_lista, 
   @v_l_invol             typ_lista, 
   @v_invol               numeric(18,0), 
   @v_id_aviso            numeric(18,0), 
   @sep                   varchar(1), 
   @dummy                 varchar(1), 
   @c_tipo_aviso          numeric(18,0),     
   @valid                 integer,
   @c_7                   integer
   
  --validacion de codigo de motivo valido -- 
  select @valid = 1 
    from sapt_parametros p 
   where p.id_parametro = @pi_c_motivo_tarea 
 
  if @valid is null 
    begin 
      set @po_c_error = 3
      set @po_d_error = 'El c?digo de motivo de tarea es inv?lido ' 
      return        
  end   
 
  set @po_c_error            = 0 
  set @po_d_error            = ''   
   
  execute sp_separador_registros 
             @po_separador_registro    = @sep        output, 
             @po_separador_campo       = @dummy      output, 
             @po_c_error               = @po_c_error output, 
             @po_d_error               = @po_d_error output   
              
  if (@po_c_error  <> 0) 
    begin 
	  set @po_d_error = 'Error llamando a sp_separador_registros : ' + @po_d_error
      return     
  end 
  
  --procedure q retorna la cantidad de d?as 
  execute sp_obtiene_dias_vig_tarea @po_c_valor = @c_7 output, 
                                    @po_c_error = @po_c_error output, 
                                    @po_d_error = @po_d_error output
                                
    if (@po_c_error  <> 0) 
    begin 
	  set @po_d_error = 'Error llamando a sp_obtiene_dias_vig_tarea : ' + @po_d_error	
      return        
    end  
   
  set @v_l_invol             = @pi_l_invol + @sep 
 
  --procedure q retorna los codigos del tipo de aviso TAREA 
  execute sp_obtiene_cod_aviso @po_id_parametro  = @c_tipo_aviso output, 
                               @po_c_error       = @po_c_error output, 
                               @po_d_error       = @po_d_error output 
                                
    if (@po_c_error  <> 0) 
    begin 
	  set @po_d_error = 'Error llamando a sp_obtiene_cod_aviso : ' + @po_d_error	
      return        
    end  
     
    if @c_tipo_aviso is null  
    begin 
      set @po_c_error = 3 
      set @po_d_error = 'Error no se encuentra codigo de tipo de aviso' 
      return        
    end      
   
  insert into saft_avisos ( 
               id_origen, 
               c_tipo_aviso, 
               c_evento_calend, 
               f_envio,   
               f_vigencia,	 
               x_cuerpo_mensaje, 
               c_usua_alta 
         )  
       values ( 
               @pi_id_usuario,                     --id_origen, 
               @c_tipo_aviso,                      --c_tipo_aviso 
               @pi_c_motivo_tarea,                 --c_evento_calend 
               convert(datetime,@pi_f_tarea,111),  --f_envio 
               dateadd(day,@c_7,convert(datetime,@pi_f_tarea,111)), --f_vigencia  
               @pi_d_detalle,                      --x_cuerpo_mensaje 
               @pi_id_usuario                      --c_usua_alta 
              ) 
 
  set @po_c_error = @@error     
 
  if (@po_c_error  <> 0) 
  begin  
      set @po_d_error =  convert(varchar,@po_c_error)  
                         + ' - Error al crear aviso. ' 
      return 
  end 
     
  --recupero el id_aviso insertado por la columna identity               
  set @v_id_aviso = @@identity 
   
  --almaceno los destinatarios de la tarea 
  while (@v_l_invol is not null) 
  begin 
   
  set @v_invol = convert(numeric,    
                       substring(@v_l_invol, 1,charindex(@sep,@v_l_invol)-1) 
                        ) 
                         
  insert into saft_avisos_destinatarios (            	 
               id_aviso, 
               id_perfil, 
               c_usua_alta 
               )  
       values ( 
               @v_id_aviso, 
               @v_invol, 
               @pi_id_usuario 
                ) 
                 
  set @po_c_error = @@error     
 
  if (@po_c_error  <> 0) 
  begin  
      set @po_d_error =  convert(varchar,@po_c_error)  
                         + ' - Error al insertar destinatario. '  
      return 
  end 
                 
  set @v_l_invol = substring(@v_l_invol, 
                             charindex(@sep,@v_l_invol)+1,  
                             char_length(@v_l_invol) 
                             )          
  end    --while 
 
  set @po_c_error = @@error     
 
  if (@po_c_error  <> 0) 
  begin  
      set @po_d_error =  convert(varchar,@po_c_error)  
                         + ' - Error en sp_crear_tarea. ' 
      return 
  end 
end  --sp_crea_tarea
 
go 

Grant Execute on dbo.sp_crea_tarea to GrpTrpSabed 
go

sp_procxmode 'sp_crea_tarea', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_datos_tel'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_datos_tel" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_datos_tel( 
@pi_sublista_tel    typ_lista,  
@pi_subSep          varchar(1), 
@po_d_telefono      typ_lista  output, 
@po_c_tipo_telefono numeric(18,0)output, 
@po_observaciones   varchar(250) output, 
@po_c_error         typ_c_error  output, 
@po_d_error         typ_d_error  output 
) 
as 
 
--objetivo: parsear la lista de datos q contiene el telefono y otros datos  
--del mismo 
-- 
 
begin 
 
      set @po_c_error = 0 
      set @po_d_error = null 
       
      --limpio las variables de OUT PUT 
      set @po_d_telefono = null 
      set @po_c_tipo_telefono = null 
      set @po_observaciones = null 
       
      --insert into sabed_log(descrip) values ('lista entera: ' + @pi_sublista_tel)   
       
       
      if  @pi_sublista_tel is not null  begin 
        set @po_d_telefono 	   = substring(@pi_sublista_tel,1,charindex(@pi_subSep,@pi_sublista_tel)-1) 
 
        set @pi_sublista_tel    = substring(@pi_sublista_tel, 
                                   charindex(@pi_subSep,@pi_sublista_tel)+1,  
                                   char_length(@pi_sublista_tel) 
                                   ) 
        --insert into sabed_log(descrip) values ('d_telefono: ' + @po_d_telefono) 
        --insert into sabed_log(descrip) values ('resto de lista: ' + @pi_sublista_tel)                                    
      end   
         
      if  @pi_sublista_tel is not null  begin 
        set @po_c_tipo_telefono = convert(numeric,substring(@pi_sublista_tel,1,charindex(@pi_subSep,@pi_sublista_tel)-1)) 
        set @pi_sublista_tel    = substring(@pi_sublista_tel, 
                                   charindex(@pi_subSep,@pi_sublista_tel)+1,  
                                   char_length(@pi_sublista_tel) 
                                   )  
                                    
        --insert into sabed_log(descrip) values ('c_tipo_telefono: ' + convert(varchar,@po_c_tipo_telefono)) 
        --insert into sabed_log(descrip) values ('resto de lista: ' + @pi_sublista_tel)                                    
                                                          
      end   
 
      if  @pi_sublista_tel is not null  begin 
        set @po_observaciones 	 = substring(@pi_sublista_tel,1,charindex(@pi_subSep,@pi_sublista_tel)-1) 
        set @pi_sublista_tel    = substring(@pi_sublista_tel, 
                                   charindex(@pi_subSep,@pi_sublista_tel)+1,  
                                   char_length(@pi_sublista_tel) 
                                   ) 
        --insert into sabed_log(descrip) values ('observaciones: ' + @po_observaciones) 
        --insert into sabed_log(descrip) values ('resto de lista: ' + @pi_sublista_tel)                                    
 
      end   
 
      set @po_c_error = @@error     
      if (@po_c_error  <> 0) 
      begin  
            set @po_d_error =  convert(varchar,@po_c_error)  
                            + ' - Error en sp_datos_tel. ' 
      end 
end --sp_datos_tel
 
go 

Grant Execute on dbo.sp_datos_tel to GrpTrpSabed 
go

sp_procxmode 'sp_datos_tel', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_datos_tel_id'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_datos_tel_id" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_datos_tel_id(
@pi_sublista_tel    varchar(250), 
@pi_subSep          varchar(1),
@po_id_telefono     numeric(18,0)output,
@po_d_telefono      typ_lista    output,
@po_c_tipo_telefono numeric(18,0)output,
@po_observaciones   varchar(250) output,
@po_c_error         typ_c_error  output,
@po_d_error         typ_d_error  output
)
as

--objetivo: parsear la lista de datos q contiene el telefono y otros datos 
--del mismo
--

begin
      set @po_c_error = 0
      set @po_d_error = null
      set @pi_sublista_tel = @pi_sublista_tel + @pi_subSep
      
      --limpio las variables de OUT PUT
      set @po_id_telefono = null
      set @po_d_telefono = null
      set @po_c_tipo_telefono = null
      set @po_observaciones = null
      
      
        set @po_id_telefono 	   = convert(numeric,substring(@pi_sublista_tel,1,charindex(@pi_subSep,@pi_sublista_tel)-1))

        set @pi_sublista_tel    = substring(@pi_sublista_tel,
                                   charindex(@pi_subSep,@pi_sublista_tel)+1, 
                                   char_length(@pi_sublista_tel)
                                   )
      
        set @po_d_telefono 	   = substring(@pi_sublista_tel,1,charindex(@pi_subSep,@pi_sublista_tel)-1)

        set @pi_sublista_tel    = substring(@pi_sublista_tel,
                                   charindex(@pi_subSep,@pi_sublista_tel)+1, 
                                   char_length(@pi_sublista_tel)
                                   )
        
        set @po_c_tipo_telefono = convert(numeric,substring(@pi_sublista_tel,1,charindex(@pi_subSep,@pi_sublista_tel)-1))
        set @pi_sublista_tel    = substring(@pi_sublista_tel,
                                   charindex(@pi_subSep,@pi_sublista_tel)+1, 
                                   char_length(@pi_sublista_tel)
                                   ) 

        set @po_observaciones 	 = substring(@pi_sublista_tel,1,charindex(@pi_subSep,@pi_sublista_tel)-1)
        set @pi_sublista_tel    = substring(@pi_sublista_tel,
                                   charindex(@pi_subSep,@pi_sublista_tel)+1, 
                                   char_length(@pi_sublista_tel)
                                   )

      set @po_c_error = @@error    

      if (@po_c_error  <> 0)
      begin 
            set @po_d_error =  convert(varchar,@po_c_error) 
                            + ' - Error al obtener los telefonos. '
      end
end --sp_datos_tel_id
 
go 

Grant Execute on dbo.sp_datos_tel_id to GrpTrpSabed 
go

sp_procxmode 'sp_datos_tel_id', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_detalle_envio_recarga'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_detalle_envio_recarga" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_detalle_envio_recarga (
@pi_id_usuario         numeric(18,0),
@pi_id_ong             numeric(18,0),
@po_c_error     typ_c_error output,
@po_d_error     typ_d_error output
)
as
-------------------------------------------------------------------
--Objetivo: Obtener el detalle del env?o a recarga
--Par?metros de entrada:
--Par?metros de salida:
--      cursor con el detalle,
--po_c_error y po_d_error
-------------------------------------------------------------------

begin
  declare @cant_filas          int,
          @sep_reg             varchar(1),
          @sep_campo           varchar(1),
          @id_ong              numeric(18,0),
          @d_nombre_ong        varchar(40),
          @n_cant_becas        numeric(18,0),
          @n_cant_recargas_sol numeric(18,0),
          @n_monto_recarga     numeric(18,0),
          @id_lote_det_recarga numeric(18,0),
          @f_fin_periodo       smalldatetime,
		  @id_lote_recarga	   numeric(18,0),
          @lista_lotes         varchar(5000),
          @largo               int,
          --
          @id_ong_filtro       numeric(18,0),
          --
          @n_cant_becas_tot        numeric(18,0),
          @n_cant_recargas_sol_tot numeric(18,0),
          @n_monto_recarga_tot     numeric(18,0),
          @id_ong_aux              numeric(18,0),
          @d_nombre_ong_aux        varchar(40),
          @id_tipo_beca            numeric(18,0),
          @i_beca                  numeric(18,2) ,
		  @id_lote_rec		       numeric(18,0)

  create table #salida (
	id_ong					numeric(18,0),
	d_nombre_ong			varchar(40),
	n_cant_becas			numeric(18,0),
	n_cant_recargas_sol 	numeric(18,0),
	n_monto_recarga			numeric(18,0),
	lista_lotes				varchar(1862),
	id_lote_recarga			numeric(18,0))

  declare curs cursor for
     Select ong.id_ong,
            ong.d_nombre_ong,
            1 n_cant_becas,
            isnull (ldr.q_becas_a_recargar,1) n_cant_recargas_sol,
            alu.id_tipo_beca id_tipo_beca,
            ldr.id_lote_det_recarga id_lote_det_recarga,
            pr.f_fin_periodo f_fin_periodo,
			ldr.id_lote_recarga
       from sart_lotes_recarga lr,
            sart_lotes_det_recarga ldr,
            sagt_alumnos_tutores atu,
            saft_tutores tut,
            saft_ongs ong,
            saat_alumnos alu,
            sact_periodos_recargas pr
      where pr.id_periodo_recarga= lr.id_periodo_recarga
        and lr.c_estado_lote = 'A_PAGAR' -- es el ultimos estado antes de que se pase al pago
        and lr.id_lote_recarga = ldr.id_lote_recarga
        and ldr.e_alumno ='S' -- solo los que estan marcados con S van al pago
        and ldr.id_alumno = atu.id_alumno
        and alu.id_alumno = atu.id_alumno
        and atu.id_perfil = 1
        and atu.id_tutor = tut.id_tutor
        and ong.id_ong = tut.id_ong
        and (ong.id_ong = @id_ong_filtro or @id_ong_filtro is null)
      Order by ong.id_ong

  set @po_c_error = 0
  set @po_d_error = null

  --obtengo el separador de registros
  execute sp_separador_registros
               @po_separador_registro    = @sep_reg   output,
               @po_separador_campo       = @sep_campo output,
               @po_c_error               = @po_c_error   output,
               @po_d_error               = @po_d_error   output
  if (@po_c_error  <> 0)
    begin
      set @po_d_error ='Error llamando a sp_separador_registros : '+@po_d_error
      return
  end

  If (@pi_id_usuario is null or @pi_id_usuario = 0)
    begin
      set @po_c_error = 3
      set @po_d_error = 'No se inform? el usuario'
      return
  end

  If (@pi_id_ong <> 0) set @id_ong_filtro = @pi_id_ong

  --
  -- Recorro el cursor
  open curs

    fetch curs into @id_ong,@d_nombre_ong,@n_cant_becas,@n_cant_recargas_sol,@id_tipo_beca,@id_lote_det_recarga,@f_fin_periodo,@id_lote_recarga

    set @cant_filas = 0

    --
    -- Marco para el corte de control
    set @id_ong_aux       = @id_ong
    set @d_nombre_ong_aux = @d_nombre_ong
	set @id_lote_rec = @id_lote_recarga
    set @lista_lotes = null
    set @n_cant_becas_tot = 0
    set @n_cant_recargas_sol_tot = 0
    set @n_monto_recarga_tot = 0
    set @n_monto_recarga = 0

    while (@@sqlstatus != 2)
      begin

        --verifico que la beca est? vigente y obtengo el importe
        execute sp_importe_beca
                @pi_id_tipo_beca    = @id_tipo_beca,
                @pi_fecha           = @f_fin_periodo,   -- usanos la fecha de fin porque se paga despues del fin del periodo
                @po_i_beca          = @i_beca       output,
                @po_c_error         = @po_c_error   output,
                @po_d_error         = @po_d_error   output

	commit --Maru

	if (@po_c_error  <> 0)
          begin
            set @po_d_error ='Error llamando a sp_importe_beca : '+@po_d_error
            return
        end

        set @cant_filas = @cant_filas + 1

        if (@po_c_error  = 0)
        begin
                --
                -- verifico si rompio
                If @id_ong != @id_ong_aux
                begin

                  set @largo = CHAR_LENGTH (@lista_lotes)-1
                  set @lista_lotes = substring(@lista_lotes,1,@largo) -- quito el ultimo separador
                  insert into #salida (id_ong,d_nombre_ong,n_cant_becas,n_cant_recargas_sol,
                                       n_monto_recarga,lista_lotes,id_lote_recarga)
                               values (@id_ong_aux,@d_nombre_ong_aux,@n_cant_becas_tot,@n_cant_recargas_sol_tot,
                                       @n_monto_recarga_tot,@lista_lotes,@id_lote_rec)
                  set @po_c_error = @@error
                  if (@po_c_error  <> 0)
                    begin
                      set @po_d_error =  'Error al procesar los totales por ONG'
                      return
                  end

		commit  -- Maru
                  --
                  -- preparo para la proxima vuelta
                  set @id_ong_aux       = @id_ong
                  set @d_nombre_ong_aux = @d_nombre_ong
				  set @id_lote_rec = @id_lote_recarga
                  --
                  set @lista_lotes = null
                  set @n_cant_becas_tot = 0
                  set @n_cant_recargas_sol_tot = 0
                  set @n_monto_recarga_tot = 0

                end

                set @n_monto_recarga = @i_beca * @n_cant_recargas_sol

                --
                -- Voy calculando los totales
                set @lista_lotes = @lista_lotes + convert (varchar(18),@id_lote_det_recarga)+ @sep_reg
                set @n_cant_becas_tot = @n_cant_becas_tot + @n_cant_becas
                set @n_cant_recargas_sol_tot = @n_cant_recargas_sol_tot + @n_cant_recargas_sol
                set @n_monto_recarga_tot = @n_monto_recarga_tot + @n_monto_recarga
        end
        --
        -- Proxima vuelta
        fetch curs into @id_ong,@d_nombre_ong,@n_cant_becas,@n_cant_recargas_sol,@id_tipo_beca,@id_lote_det_recarga,@f_fin_periodo,@id_lote_recarga

    end

    --
    -- Inserto el ultimo registro
    If @cant_filas > 0
      begin

        set @largo = CHAR_LENGTH (@lista_lotes)-1
        set @lista_lotes = substring(@lista_lotes,1,@largo) -- quito el ultimo separador
        insert into #salida (id_ong,d_nombre_ong,n_cant_becas,n_cant_recargas_sol,
                             n_monto_recarga,lista_lotes,id_lote_recarga)
                     values (@id_ong_aux,@d_nombre_ong_aux,@n_cant_becas_tot,@n_cant_recargas_sol_tot,
                             @n_monto_recarga_tot,@lista_lotes,@id_lote_rec)
        set @po_c_error = @@error

	commit --Maru

        if (@po_c_error  <> 0)
          begin
            set @po_d_error =  'Error al procesar los totales por ONG'
            return
        end
    end

  close curs

  --
  -- Genero la salida
  Select id_ong,
         d_nombre_ong,
         n_cant_becas,
         n_cant_recargas_sol,
         n_monto_recarga,
         lista_lotes,
		 id_lote_recarga
    from #salida

  set @po_c_error = @@error,
      @cant_filas = @@rowcount
  if (@po_c_error  <> 0)
  begin
      set @po_d_error =  convert(varchar,@po_c_error)
                         + ' - Error al consultar el detalle. '
return
  end
  if (@cant_filas = 0)
    begin
      set @po_c_error = 1
      set @po_d_error = 'No se encontraron registros en estado para pagar'
      return
  end

end -- sp_detalle_envio_recarga


go 

Grant Execute on dbo.sp_detalle_envio_recarga to GrpTrpSabed 
go

sp_procxmode 'sp_detalle_envio_recarga', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_dias_tar_emitidas'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_dias_tar_emitidas" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_dias_tar_emitidas (  
@pi_id_usuario          numeric(18,0), 
@pi_anio                integer, 
@pi_mes                 integer, 
@pi_sep                 varchar(1), 
@pi_subSep              varchar(1), 
@pi_c_tipo_aviso        numeric(18,0),   
@po_lista_fechas        typ_lista output, 
@po_c_error             typ_c_error output, 
@po_d_error             typ_d_error output 
) 
as 
 
--Crear SP que retorne lista de d?as para un mes y a?o en particular de un  
--determinado usuario, el mismo recibe 3 par?metros y retorna la lista de d?as  
--concatenada con el s?mbolo # para el caso de que haya m?s de una tarea para  
--ese mes y a?o. 
 
begin 
   
declare @dia_envio       integer, 
        @m_origen        varchar(1), 
        @salida          typ_lista
 
set @salida= convert(varchar(100),@pi_c_tipo_aviso) 
  
 
  set @po_c_error = 0 
  set @po_d_error = null 
  set @po_lista_fechas = null 
 
  --lista de d?as: output 
  -- Declaro el cursor  
  declare cur_fechas cursor   
  for select distinct datepart(dd,av.f_envio), 'P' -- Propias 
        from saft_avisos av 
       where av.id_origen = @pi_id_usuario 
         and datepart(mm,av.f_envio) = @pi_mes 
         and datepart(yy,av.f_envio) = @pi_anio 
         and av.c_tipo_aviso = @pi_c_tipo_aviso          
         and av.f_baja is null 
     
    -- Abro el cursor  
    open cur_fechas  
  
    fetch cur_fechas into @dia_envio, @m_origen 
    
    -- Si @@sqlstatus = 2 entonces no hay mas datos.  
    if (@@sqlstatus = 2)  
    begin  
        close cur_fechas  
        return  
    end  
 
    -- Mientras haya datos  
    while (@@sqlstatus = 0)  
    begin           
     
        if @po_lista_fechas is null 
            set @po_lista_fechas =  convert(varchar(2),@dia_envio) + @pi_subSep  + @m_origen  
        else 
            set @po_lista_fechas =  @po_lista_fechas + @pi_sep + 
                                    convert(varchar(2),@dia_envio) + @pi_subSep  + @m_origen      
         
        fetch cur_fechas into @dia_envio, @m_origen 
 
    end 
     
    close cur_fechas  
  
    deallocate cursor cur_fechas  
     
  if @po_lista_fechas is not null 
      set @po_lista_fechas =  @po_lista_fechas + @pi_sep     
 
  set @po_c_error = @@error     
  if (@po_c_error  <> 0) 
  begin  
      set @po_d_error =  convert(varchar,@po_c_error)  
                         + ' - Error al obtener d?as. ' 
      return 
  end   
 
end --sp_dias_tar_emitidas
 
go 

Grant Execute on dbo.sp_dias_tar_emitidas to GrpTrpSabed 
go

sp_procxmode 'sp_dias_tar_emitidas', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_dias_tar_recibidas_fund'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_dias_tar_recibidas_fund" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_dias_tar_recibidas_fund (   
@pi_id_usuario          numeric(18,0),  
@pi_anio                integer,  
@pi_mes                 integer,  
@pi_sep                 varchar(1),  
@pi_subSep              varchar(1),  
@pi_c_tipo_aviso        numeric(18,0),    
@po_lista_fechas        typ_lista output,  
@po_c_error             typ_c_error output,  
@po_d_error             typ_d_error output  
)  
as  
  
--Crear SP que retorne lista de d?as para un mes y a?o en particular de un   
--determinado usuario, el mismo recibe 3 par?metros y retorna la lista de d?as   
--concatenada con el s?mbolo # para el caso de que haya m?s de una tarea para   
--ese mes y a?o.  
  
begin  
    
declare @dia_envio       integer,  
        @m_origen        varchar(1)  
  
  set @po_c_error = 0  
  set @po_d_error = null  
  set @po_lista_fechas = null 
  
  --lista de d?as: output  
  -- Declaro el cursor   
  declare cur_fechas_fund cursor for  
    --**************************************************************************  
      select distinct datepart(dd,av.f_envio) dia_envio , 'A' m_origen -- Ajenas  
        from saft_avisos               av,  
             saft_avisos_destinatarios avd,  
             saft_personas_ong pong, 
             saft_ongs ong, 
             sast_usuarios usu 
       where datepart(mm,av.f_envio) = @pi_mes  
         and datepart(yy,av.f_envio) = @pi_anio  
         and av.c_tipo_aviso  = @pi_c_tipo_aviso  
         and av.f_baja is null  
         and ong.m_fundacion='S' 
         and pong.id_ong = ong.id_ong 
         and usu.id_usuario= av.id_origen 
         and pong.id_persona = usu.id_persona 
         and av.id_aviso = avd.id_aviso 
         and pong.e_registro = 'D' 
         and usu.e_usuario = 'D' 
         and ong.e_registro = 'D'           
         and avd.id_perfil = any  (select id_perfil  
                                     from  sast_usuarios_perfiles  
                                    where id_usuario = @pi_id_usuario  
                                      and e_usu_perfil = 'D' 
                                   )  
 
  --**************************************************************************      
  -- Abro el cursor   
  open cur_fechas_fund  
 
  fetch cur_fechas_fund into @dia_envio, @m_origen  
   
  -- Si @@sqlstatus = 2 entonces no hay mas datos.   
  if (@@sqlstatus = 2)   
  begin   
      close cur_fechas_fund  
      return   
  end   
 
  -- Mientras haya datos   
  while (@@sqlstatus = 0)   
  begin            
        
      if @po_lista_fechas is null 
          set @po_lista_fechas =  convert(varchar(2),@dia_envio) + @pi_subSep  + @m_origen  
      else  
          set @po_lista_fechas =  @po_lista_fechas + @pi_sep +  
                                  convert(varchar(2),@dia_envio) + @pi_subSep  + @m_origen   
        
      fetch cur_fechas_fund into @dia_envio,  @m_origen  
        
  end  
      
  close cur_fechas_fund  
   
  deallocate cursor cur_fechas_fund  
  
  if @po_lista_fechas is not null 
      set @po_lista_fechas =  @po_lista_fechas + @pi_sep 
  
  set @po_c_error = @@error      
   
  if (@po_c_error  <> 0) 
  begin  
      set @po_d_error =  convert(varchar,@po_c_error)  
                         + ' - Error al obtener dias. ' 
      return 
  end 
 
end --sp_dias_tar_recibidas_fund
 
go 

Grant Execute on dbo.sp_dias_tar_recibidas_fund to GrpTrpSabed 
go

sp_procxmode 'sp_dias_tar_recibidas_fund', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_dias_tar_recibidas_ind'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_dias_tar_recibidas_ind" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_dias_tar_recibidas_ind ( 
@pi_id_usuario          numeric(18,0), 
@pi_anio                integer, 
@pi_mes                 integer, 
@pi_sep                 varchar(1), 
@pi_subSep              varchar(1), 
@pi_c_tipo_aviso        numeric(18,0),   
@po_lista_fechas        typ_lista output, 
@po_c_error             typ_c_error output, 
@po_d_error             typ_d_error output 
) 
as 
 
--Crear SP que retorne lista de d?as para un mes y a?o en particular de un  
--determinado usuario, el mismo recibe 3 par?metros y retorna la lista de d?as  
--concatenada con el s?mbolo # para el caso de que haya m?s de una tarea para  
--ese mes y a?o. 
 
begin 
   
declare @dia_envio       integer, 
        @m_origen        varchar(1) 
 
  set @po_c_error = 0 
  set @po_d_error = null 
  set @po_lista_fechas = null 
 
  --lista de d?as: output 
    -- Declaro el cursor  
  declare cur_fechas cursor   
  for select distinct datepart(dd,av.f_envio), 'A' -- Ajenas 
        from saft_avisos av,saft_avisos_destinatarios avd 
       where datepart(mm,av.f_envio) = @pi_mes  
         and datepart(yy,av.f_envio) = @pi_anio 
         and av.c_tipo_aviso  = @pi_c_tipo_aviso 
         and av.f_baja is null 
         and av.id_aviso = avd.id_aviso 
         and avd.id_usuario = @pi_id_usuario 
 
     
    -- Abro el cursor  
    open cur_fechas  
  
    fetch cur_fechas into @dia_envio, @m_origen 
    
    -- Si @@sqlstatus = 2 entonces no hay mas datos.  
    if (@@sqlstatus = 2)  
    begin  
        close cur_fechas  
        return  
    end  
 
    -- Mientras haya datos  
    while (@@sqlstatus = 0)  
    begin           
         
        if @po_lista_fechas is null 
            set @po_lista_fechas =  convert(varchar(2),@dia_envio) + @pi_subSep  + @m_origen  
        else 
            set @po_lista_fechas =  @po_lista_fechas + @pi_sep + 
                                    convert(varchar(2),@dia_envio) + @pi_subSep  + @m_origen  
         
        fetch cur_fechas into @dia_envio,@m_origen 
         
    end 
     
    close cur_fechas  
  
    deallocate cursor cur_fechas  
     
  if @po_lista_fechas is not null 
      set @po_lista_fechas =  @po_lista_fechas + @pi_sep     
 
  set @po_c_error = @@error     
   
  if (@po_c_error  <> 0) 
  begin  
      set @po_d_error =  convert(varchar,@po_c_error)  
                         + ' - Error al obtener dias. ' 
      return 
  end 
 
end --sp_dias_tar_recibidas_ind
 
go 

Grant Execute on dbo.sp_dias_tar_recibidas_ind to GrpTrpSabed 
go

sp_procxmode 'sp_dias_tar_recibidas_ind', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_dias_tar_recibidas_ong'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_dias_tar_recibidas_ong" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_dias_tar_recibidas_ong ( 
@pi_id_usuario          numeric(18,0), 
@pi_id_ong              numeric(18,0), 
@pi_anio                integer, 
@pi_mes                 integer, 
@pi_sep                 varchar(1), 
@pi_subSep              varchar(1), 
@pi_c_tipo_aviso        numeric(18,0),   
@po_lista_fechas        typ_lista    output, 
@po_c_error             typ_c_error  output, 
@po_d_error             typ_d_error  output 
) 
as 
 
--Crear SP que retorne lista de d?as para un mes y a?o en particular de un  
--determinado usuario, el mismo recibe 3 par?metros y retorna la lista de d?as  
--concatenada con el s?mbolo | para el caso de que haya m?s de una tarea para  
--ese mes y a?o. 
 
begin 
   
declare @dia_envio       integer, 
        @m_origen        varchar(1) 

  set @po_c_error = 0 
  set @po_d_error = null 
  set @po_lista_fechas = null 
 
  --lista de d?as: output 
    -- Declaro el cursor  
  declare cur_fechas cursor for 
    --************************************************************************** 
      select distinct datepart(dd,av.f_envio) dia , 'A' m_origen -- Ajenas 
        from saft_avisos               av, 
             saft_avisos_destinatarios avd, 
             sasv_usuarios_ongs        vuo 
       where datepart(mm,av.f_envio) = @pi_mes 
         and datepart(yy,av.f_envio) = @pi_anio 
         and av.c_tipo_aviso  = @pi_c_tipo_aviso 
         and av.f_baja is null 
         and av.id_aviso = avd.id_aviso 
         and avd.id_perfil = any  (select id_perfil 
                                     from  sast_usuarios_perfiles 
              			    where id_usuario = @pi_id_usuario 
              			      and e_usu_perfil = 'D' 
                                   ) 
         and vuo.id_usuario <> @pi_id_usuario
         and av.id_origen = vuo.id_usuario 
         and vuo.id_ong = @pi_id_ong 
    --**************************************************************************     
    -- Abro el  cursor  
    open cur_fechas  
  
    fetch cur_fechas into @dia_envio, @m_origen 
    
    -- Si @@sqlstatus = 2 entonces no hay mas datos.  
    if (@@sqlstatus = 2)  
    begin  
        close cur_fechas  
        return  
    end  
 
    -- Mientras haya datos  
    while (@@sqlstatus = 0)  
    begin           
         
        if @po_lista_fechas is null 
            begin 
                
            	set @po_lista_fechas =  convert(varchar(2),@dia_envio) + @pi_subSep  + @m_origen  
                
            end 
        else 
            begin 
                
            	set @po_lista_fechas =  @po_lista_fechas + @pi_sep +      
                	                convert(varchar(2),@dia_envio) + @pi_subSep  + @m_origen  
                
            end                                      
         
        fetch cur_fechas into @dia_envio,@m_origen 
         
    end 
     
    close cur_fechas  
  
    deallocate cursor cur_fechas  
     
  set @po_c_error = @@error     
  if (@po_c_error  <> 0) 
  begin  
      set @po_d_error =  convert(varchar,@po_c_error)  
                         + ' - Error al obtener dias de tareas recibidas de la ong. ' 
      return 
  end 
 
end --sp_dias_tar_recibidas_ong
 
go 

Grant Execute on dbo.sp_dias_tar_recibidas_ong to GrpTrpSabed 
go

sp_procxmode 'sp_dias_tar_recibidas_ong', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_elimina_colegio'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_elimina_colegio" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_elimina_colegio (
-- drop procedure sp_elimina_colegio
@pi_id_colegio       numeric(18,0),
@pi_c_usua_actuac    numeric(18,0),
@po_c_error      		 typ_c_error output,
@po_d_error      		 typ_d_error output
)
as
------------------------------------------- 
------------------------
--Objetivo: Eliminacion de ONG. 
--Par?metros de entrada:
--	ID_COLEGIO
--	C_USUA_ACTUAC
--Par?metros de salida: po_c_error y po_d_error
-------------------------------------------------------------------

begin
  if (@pi_id_colegio is null or @pi_id_colegio = 0)
    begin
      set @po_c_error = 3
      set @po_d_error = 'No se recibio colegio'
      return       
  end

  if (@pi_c_usua_actuac is null or @pi_c_usua_actuac = 0)
    begin
      set @po_c_error = 3
      set @po_d_error = 'No se recibio usuario'
      return       
  end

  set @po_c_error = 0
  set @po_d_error = null

  update sagt_colegios
     set c_usua_actuac = @pi_c_usua_actuac,
         f_actuac = getDate(),
         f_baja = getDate(),
         e_registro = 'B'
   where id_colegio = @pi_id_colegio
  
  set @po_c_error = @@error    

  if (@po_c_error  <> 0)
    begin 
      set @po_d_error =  convert(varchar,@po_c_error) 
                         + ' - Error en sp_elimina_colegio. '
  end
  
end --sp_elimina_colegio
 
go 

Grant Execute on dbo.sp_elimina_colegio to GrpTrpSabed 
go

sp_procxmode 'sp_elimina_colegio', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_elimina_ong'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_elimina_ong" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_elimina_ong (
-- drop procedure sp_elimina_ong
@pi_id_ong                numeric(18,0),
@pi_c_usua_actuac         numeric(18,0),
@po_c_error      				  typ_c_error output,
@po_d_error      				  typ_d_error output
)
as
------------------------------------------- 
------------------------
--Objetivo: Eliminacion de ONG. 
--Par?metros de entrada:
--	ID_ONG
--	C_USUA_ACTUAC
--Par?metros de salida: po_c_error y po_d_error
-------------------------------------------------------------------

begin
  if (@pi_id_ong is null or @pi_id_ong = 0)
    begin
      set @po_c_error = 3
      set @po_d_error = 'No se recibio ONG'
      return       
  end

  if (@pi_c_usua_actuac is null or @pi_c_usua_actuac = 0)
    begin
      set @po_c_error = 3
      set @po_d_error = 'No se recibio usuario de eliminaci?n'
      return       
  end

  set @po_c_error = 0
  set @po_d_error = null

  update saft_ongs
     set c_usua_actuac = @pi_c_usua_actuac,
         f_actuac = getDate(),
         f_baja = getDate(),
         e_registro = 'B'
   where id_ong = @pi_id_ong
  
  set @po_c_error = @@error    

  if (@po_c_error  <> 0)
    begin 
      set @po_d_error =  convert(varchar,@po_c_error) 
                         + ' - Error en sp_elimina_ong. '
  end
  
end --sp_elimina_ong
 
go 

Grant Execute on dbo.sp_elimina_ong to GrpTrpSabed 
go

sp_procxmode 'sp_elimina_ong', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_elimina_parametro'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_elimina_parametro" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_elimina_parametro(  

@pi_id_tabla        numeric(18,0),  

@pi_id_parametro    numeric(18,0),  

@pi_id_usuario      numeric(18,0),  

@po_c_error         typ_c_error output,  

@po_d_error         typ_d_error output  

)  

--Objetivo: Elimina un par?metro de la tabla de par?metros  

--Par?metros de entrada: pi_id_tabla (num?rico), pi_c_valor (varchar2)  

--Par?metros de salida: po_c_error y po_d_error  

as  

  

begin  

  

  --Validaci?n de Par?metros  

  if (@pi_id_tabla  is null or @pi_id_tabla = 0)  

    begin  

      set @po_c_error = 3 

      set @po_d_error = 'No se recibi? id_tabla'  

      return         

  end  

  

  if (@pi_id_parametro  is null or @pi_id_parametro = 0)  

    begin  

      set @po_c_error = 3 

      set @po_d_error = 'No se recibi? cod_valor'  

      return   

  end  

    

  set @po_c_error = 0  

  set @po_d_error = null  

  if @pi_id_tabla  = (select id_tabla from sapt_param_tablas where d_valor = 'GRUPO')

  begin

    delete from sapt_param_grupos

  where id_tabla_param = @pi_id_tabla  

    and id_grupo = @pi_id_parametro 

  end

  else

  begin

  delete from sapt_parametros  

  where id_tabla = @pi_id_tabla  

    and id_parametro = @pi_id_parametro  

  end

  

  set @po_c_error = @@error      

  if (@po_c_error  = 547)  

  begin      

      set @po_d_error = 'El c?digo de par?metro est? siendo usado. No puede eliminarse '    

      set @po_c_error = 2 

      return   

  end  

  else  if (@po_c_error  <> 0)  

        begin  

             set @po_d_error =  convert(varchar,@po_c_error)   

                         + ' - Error al modificar tablas de parametros: '  

                               + convert(varchar(7),@pi_id_tabla)  

             return  

        end  

  

end
 
go 

Grant Execute on dbo.sp_elimina_parametro to GrpTrpSabed 
go

sp_procxmode 'sp_elimina_parametro', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_elimina_tarea'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_elimina_tarea" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_elimina_tarea(
@pi_id_aviso   numeric(18,0),
@pi_id_usuario numeric(18,0),
@po_c_error    typ_c_error output,
@po_d_error    typ_d_error output
)
------------------------------------------------------------------------------
--Objetivo: elimina la tarea creada por el usuario de creacion
--Par?metros de entrada: 
--Par?metros de salida: po_c_error y po_d_error
------------------------------------------------------------------------------
as

begin

  if (@pi_id_aviso  is null or @pi_id_aviso = 0)
    begin
      set @po_c_error = 3
      set @po_d_error = 'No se recibi? id de aviso'
      return       
  end

  if (@pi_id_usuario  is null or @pi_id_usuario = 0)
    begin
      set @po_c_error = 3
      set @po_d_error = 'No se recibi?id de usuario'
      return       
  end
  
  declare 
    @usuario_origen numeric(18,0),
    @can            numeric(18,0)
    
  set @po_c_error = 0
  set @po_d_error = null
  
  --si la tarea fue cargada por el usuario se marca la baja
  select @can = 1
  from saft_avisos
  where id_aviso = @pi_id_aviso 
    and id_origen = @pi_id_usuario
    
  if (@@rowcount = 0) 
  begin
      set @po_c_error = 1
      set @po_d_error = 'La tarea no fue cargada por el usuario. '
      return
  end     
 
  update saft_avisos 
  set f_baja  = getdate(),
      c_usua_actuac =  @pi_id_usuario,
      f_actuac      = getDate()
  where id_aviso = @pi_id_aviso 
    and id_origen = @pi_id_usuario

  set @po_c_error = @@error    

  if (@po_c_error  <> 0)
  begin 
      set @po_d_error =  'Error al eliminar tarea. '
      return
  end

end --sp_elimina_tarea
 
go 

Grant Execute on dbo.sp_elimina_tarea to GrpTrpSabed 
go

sp_procxmode 'sp_elimina_tarea', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_elimina_usuario_perfiles'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_elimina_usuario_perfiles" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_elimina_usuario_perfiles( 
@pi_id_usuario_logg      numeric(18,0), 
@pi_id_persona           numeric(18,0), 
@pi_id_usuario           numeric(18,0), 
@pi_id_ong               numeric(18,0), 
@pi_l_perfiles           typ_lista,  
@pi_sep                  varchar(1),  
@po_c_error              typ_c_error output, 
@po_d_error              typ_d_error output 
) 
as 
 
--objetivo: eliminar los perfiles indicados en la lista de parametros para un 
--usuario. Antes de eliminar el perfil, verifico que efectivamente tiene asignado el  
--mismo 
-- 
 
begin 
 
  --begin tran modifica_usuario 
   
  declare  
   @aux                  typ_lista, 
   @l_perfiles           typ_lista, 
   @perfil               numeric(18,0), 
   @dummy                varchar(1), 
   @n_nivel              integer, 
   @descr_perfil         varchar(40), 
   @id_fundacion         numeric(18,0), 
   --@id_ong               numeric(18,0), 
   @e_definitivo         char(1), 
   @e_baja               char(1), 
   @n_cant               integer, 
   @id_tutor             numeric(18,0), 
   @n_cant_alumnos       integer, 
   @cant_usu             int, 
   @existe_perfil        int, 
   @cant_tutores         int, 
   @cant_fundacion       int, 
   @cant_ong             int, 
   @d_user               varchar(40)   
    
    
  set @po_c_error = 0 
  set @po_d_error = null 
 
  --procedure q retorna los codigos del estado de registro definitivo 
  execute sp_obtiene_e_definitivo @po_c_valor  = @e_definitivo output, 
                                  @po_c_error  = @po_c_error output, 
                                  @po_d_error  = @po_d_error output 
                                
  if (@po_c_error  <> 0) 
  begin 
	 set @po_d_error = 'Error llamando a sp_obtiene_e_definitivo : ' + @po_d_error
     return        
  end 
 
  --procedure q retorna los codigos del estado de registro definitivo 
  execute sp_obtiene_e_baja @po_c_valor  = @e_baja output, 
                            @po_c_error  = @po_c_error output, 
                            @po_d_error  = @po_d_error output 
                                
  if (@po_c_error  <> 0) 
  begin 
    set @po_d_error = 'Error llamando a sp_obtiene_e_baja : ' + @po_d_error
    return        
  end 
 
  set @l_perfiles            = @pi_l_perfiles + @pi_sep 
   
   
  if char_length(@l_perfiles) > 1 
  begin 
  --proceso lista de perfiles 
  while (@l_perfiles is not null) 
  begin 
         
        --obtengo un perfil a eliminar de la lista pasada por parametro 
        set @perfil = convert(numeric,    
                             substring(@l_perfiles, 1,charindex(@pi_sep,@l_perfiles)-1) 
                              ) 
                               
        --obtengo el nivel de mensaje 
        select @n_nivel = n_nivel_mensaje, @descr_perfil = d_perfil 
          from sast_perfiles p 
         where p.id_perfil = @perfil 
          
        --la lista de perfiles a eliminar contiene perfiles q 
        --el usuario puede no tener asociados 
        --xq pasan la lista de perfiles q quedaron sin chequear en la pantalla 
        --sin diferenciar si el perfil existe o no 
        --entonces verifico q exista el perfil asociado al usuario 
        --antes de eliminarlo 
        select @existe_perfil = count(*) 
          from sast_usuarios_perfiles  
         where id_perfil  = @perfil 
           and id_usuario = @pi_id_usuario 
           and e_usu_perfil  = @e_definitivo          
         
        if @existe_perfil > 0  
        begin 
                --limpio la variable que controla q no se repita la persona y su ong o tutor 
                set @n_cant = 0 
               
                if @n_nivel = 1 --FUNDACION 
                begin 
                 
                           --obtengo id de fundacion  
                           select @id_fundacion = o.id_ong 
                             from saft_ongs o           
                            where o.m_fundacion = 'S' 
                              and o.e_registro = @e_definitivo 
                   
                           if @id_fundacion is null   
                           begin 
                                --set @po_d_error = 'Error, la Fundaci?n no fue dada de alta. ' 
                                set @po_d_error = 'El Equipo de Becas no ha sido dado de alta en Instituciones. ' 
                                set @po_c_error = 2
                                return        
                           end 
                             
                           --verifico que tenga otros perfiles de nivel 1  
                           select @cant_fundacion = count(*) 
                             from sast_usuarios_perfiles up, 
                                  sast_perfiles p 
                            where up.id_perfil = p.id_perfil 
                              and up.id_usuario = @pi_id_usuario  
                              and p.n_nivel_mensaje = @n_nivel --1 
                              and up.e_usu_perfil = @e_definitivo 
                            
                           if @cant_fundacion = 1  
                           begin 
                                    update saft_personas_ong  
                                       set e_registro = @e_baja,  
                                           c_usua_actuac  = @pi_id_usuario_logg, 
                                           f_actuac       = getDate() 
                                     where id_ong = @id_fundacion 
                                      and  id_persona     = @pi_id_persona 
                   
                                     set @po_c_error = @@error 
                           
                                     if (@po_c_error  <> 0) 
                                     begin 
                                         set @po_d_error = 'Error al dar de baja en personas_ong'          
                                         return        
                                     end  
                           end 
                end --@n_nivel = 1 --FUNDACION 
                 
                if  @n_nivel = 2 -- ONG 
                begin 
                        --verifico que tenga otros perfiles de nivel 2  
                        select @cant_ong = count(*) 
                          from sast_usuarios_perfiles up, 
                               sast_perfiles p 
                         where up.id_perfil = p.id_perfil 
                           and up.id_usuario = @pi_id_usuario  
                           and p.n_nivel_mensaje = @n_nivel --2 
                           and up.e_usu_perfil = @e_definitivo 
                           
                        if @cant_ong = 1 
                        begin 
                                    update saft_personas_ong  
                                       set e_registro = @e_baja,  
                                           c_usua_actuac  = @pi_id_usuario_logg, 
                                           f_actuac       = getDate() 
                                     where id_ong = @pi_id_ong 
                                      and  id_persona     = @pi_id_persona 
                        
                                    set @po_c_error = @@error 
                                                  
                                    if (@po_c_error  <> 0) 
                                    begin 
                                          set @po_d_error = 'Error al dar de baja en personas_ong. '          
                                          return        
                                    end   
                        end        
                      
                end --@n_nivel = 2 -- ONG 
                 
                if @n_nivel = 3 -- TUTOR 
                begin 
 
                            --obtengo el id del tutor  
                            select @id_tutor = id_tutor 
                              from saft_tutores 
                             where id_ong     = @pi_id_ong 
                               and id_persona = @pi_id_persona 
                               and e_registro = @e_definitivo 
                 
                 --insert into sabed_log(descrip) values ('id_tutor: ' + convert(varchar, @id_tutor))                   
                             
                            if @id_tutor is not null 
                            begin 
                                    --verificar q no tenga alumnos asociados                   
                                    select @n_cant_alumnos = count(atut.id_alumno) 
                                      from sagt_alumnos_tutores atut, 
                                           saat_alumnos a  
                                     where atut.id_tutor = @id_tutor 
                                       and atut.id_perfil = @perfil 
                                       and atut.id_alumno = a.id_alumno 
                                       and a.e_alumno in ('BECADO','POSTULANTE','SUSPENDIDO')
                                       
                 --insert into sabed_log(descrip) values ('cant. de alus asociados: ' + convert(varchar, @n_cant_alumnos))                   
                                        
                                     
                                    if @n_cant_alumnos <> 0  
                                    begin 
                                         set @po_c_error = 2 
                                         set @po_d_error = 'El tutor tiene alumnos asociados, no puede eliminarse el perfil: ' + 
                                                           @descr_perfil 
                                         return                  
                                    end 
                                    else --no tiene alumnos asociados --                                     
                                    begin   
                                        --verifico que tenga otros perfiles de nivel 3  
                                        select @cant_tutores = count(*) 
                                          from sast_usuarios_perfiles up, 
                                               sast_perfiles p 
                                         where up.id_perfil = p.id_perfil 
                                           and up.id_usuario = @pi_id_usuario  
                                           and p.n_nivel_mensaje = @n_nivel --3 
                                           and up.e_usu_perfil = @e_definitivo 
                                         
                                        if @cant_tutores = 1  
                                        begin 
                                            update saft_tutores  
                                               set e_registro = @e_baja,  
                                                   c_usua_actuac  = @pi_id_usuario_logg, 
                                                   f_actuac       = getDate() 
                                              where id_ong     = @pi_id_ong 
                                                and id_persona = @pi_id_persona 
                       
                                            set @po_c_error = @@error 
                       
                                            if (@po_c_error  <> 0) 
                                            begin 
                                             set @po_d_error = 'Error al dar de baja en tutores'               
                                             return        
                                            end 
                                        end  
                                         
                                     end    
                                  
                            end   --@id_tutor is not null   
                             
                end  --@n_nivel = 3 -- TUTOR 
                 
                update sast_usuarios_perfiles  
                set e_usu_perfil  = @e_baja, 
                    c_usua_actuac = @pi_id_usuario_logg, 
                    f_actuac      = getDate() 
                where id_perfil  = @perfil 
                  and id_usuario = @pi_id_usuario 
                  --and e_usu_perfil  = @e_definitivo 
                       
               
                set @po_c_error = @@error     
                 
                if (@po_c_error  <> 0) 
                begin   
                    set @po_d_error = 'Error al dar de alta en usuarios_perfiles. ' 
                    return   
                end 
                 
        end --if @existe_perfil > 0 
         
        set @l_perfiles = substring(@l_perfiles, 
                                   charindex(@pi_sep,@l_perfiles)+1,  
                                   char_length(@l_perfiles) 
                                   )          
  end    --while 
  end --if 
   
  select @cant_usu = count(*) 
    from sast_usuarios_perfiles 
   where id_usuario = @pi_id_usuario 
     and e_usu_perfil  = @e_definitivo 
      
  if @cant_usu = 0 
  begin 
        update sast_usuarios 
        set e_usuario     = @e_baja, 
            c_usua_actuac = @pi_id_usuario_logg, 
            f_actuac      = getDate() 
        where id_usuario = @pi_id_usuario 
 
        set @po_c_error = @@error     
         
        if (@po_c_error  <> 0) 
        begin 
            set @po_d_error = 'Error al dar de baja en usuarios. ' 
            return   
        end 
         
        select @d_user = d_user 
        from sast_usuarios 
        where id_usuario = @pi_id_usuario 
         
        --agrego la baja l?gica en las tablas de login 
        update sast_login_usuarios  
         set usu_habilitado	 = 'N'	 
       where usu_d_user = @d_user 
 
      set @po_c_error = @@error 
       
      if (@po_c_error  <> 0)  
        begin    
          set @po_d_error = 'Error al actualizar los datos del login'  
          return 
        end 
           
  end 
   
end --sp_elimina_usuario_perfiles
 
go 

Grant Execute on dbo.sp_elimina_usuario_perfiles to GrpTrpSabed 
go

sp_procxmode 'sp_elimina_usuario_perfiles', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_envio_recargas'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_envio_recargas" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_envio_recargas(
@pi_id_usuario          numeric(18,0),
@pi_id_lote             numeric(18,0),
@pi_id_sup_equipo_becas numeric(18,0),
@pi_f_oper_sup_eq_becas varchar(20),  
@pi_l_alu               typ_lista,   
@po_c_error             typ_c_error output,
@po_d_error             typ_d_error output
)
as
/*
Objetivo: inserta los lotes de recargas con alumnos
@pi_l_alu es de la forma: 
@id_alu_tar:@e_alumno:@q_recargas:@id_tipo_beca:@x_observacion
*/

begin

  if (@pi_id_usuario is null or @pi_id_usuario = 0)
    begin
      set @po_c_error = 3
      set @po_d_error = 'No se recibi? pi_id_usuario'
      return       
  end
  
  if (@pi_id_lote is null or @pi_id_lote = 0)
    begin
      set @po_c_error = 3
      set @po_d_error = 'No se recibi? pi_id_lote'
      return       
  end  
  
  if (@pi_id_sup_equipo_becas is null or @pi_id_sup_equipo_becas = 0)
    begin
      set @po_c_error = 3
      set @po_d_error = 'No se recibi? pi_id_sup_equipo_becas'
      return       
  end  

  if (@pi_f_oper_sup_eq_becas is null or @pi_f_oper_sup_eq_becas = 0)
    begin
      set @po_c_error = 3
      set @po_d_error = 'No se recibi? pi_f_oper_sup_eq_becas'
      return       
  end  

  declare @f_oper_coordinador     datetime,
          @f_oper_eq_becas     datetime,
          @f_oper_sup_eq_becas datetime

  set @po_c_error = 0
  set @po_d_error = null
  
  begin tran recargas
  
  --convierto el varchar de entrada a date 
  execute sp_convierte_char_en_fecha @pi_fecha_char     = @pi_f_oper_sup_eq_becas,
                                     @po_fecha_datetime = @f_oper_sup_eq_becas output,
                                     @po_c_error        = @po_c_error  output,
                                     @po_d_error        = @po_d_error  output
                           
  if (@po_c_error  <> 0) 
  begin
      rollback tran recargas 
	  set @po_d_error = 'Error llamando a sp_convierte_char_en_fecha : ' + @po_d_error
      return  
  end  
  
  --updateo el usuario que revisa la recarga por SI o por NO
  update sart_lotes_recarga
  set   c_estado_lote       = 'ENVIADO',
        id_sup_equipo_becas = @pi_id_sup_equipo_becas,                      
        f_oper_sup_eq_becas = @f_oper_sup_eq_becas,  
        c_usua_actuac       = @pi_id_usuario,
        f_actuac            = getDate()
  where id_lote_recarga = @pi_id_lote
  
  set @po_c_error = @@error
  
  if (@po_c_error  <> 0) 
  begin
      rollback tran recargas 
      set @po_d_error =  'Error al actualizar lote de recargas. '
      return  
  end  

  execute sp_inserta_det_recarga
    @pi_id_usuario      = @pi_id_usuario,
    @pi_id_lote         = @pi_id_lote,
    @pi_l_alu           = @pi_l_alu,
    @po_c_error         = @po_c_error  output,
    @po_d_error         = @po_d_error  output

  if (@po_c_error  <> 0) 
  begin
      rollback tran recargas 
	  set @po_d_error = 'Error llamando a sp_inserta_det_recarga : ' + @po_d_error
      return  
  end
  
  commit tran recargas
  
end --sp_envio_recargas
 
go 

Grant Execute on dbo.sp_envio_recargas to GrpTrpSabed 
go

sp_procxmode 'sp_envio_recargas', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_est_periodo_eval_acad'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_est_periodo_eval_acad" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_est_periodo_eval_acad (   
@pi_id_periodo	 numeric(18,0),  
@po_estado       varchar(1) output,  
@po_c_error      typ_c_error output,   
@po_d_error      typ_d_error output   
) as   
-------------------------------------------------------------------   
--Objetivo: Estado del periodo  
--Par?metros de salida:    
-- po_estado, po_c_error y po_d_error   
-------------------------------------------------------------------   
   
begin   
     
  set @po_c_error = 0   
  set @po_d_error = null   
    
  If (@pi_id_periodo is null  or @pi_id_periodo = 0)
  begin       
    set @po_d_error = 'No se inform? periodo'   
    set @po_c_error = 3   
    return   
  end   
   
      Select @po_estado = case when (f_inicio_periodo<= getdate() and f_fin_periodo>=getdate()) then 'A'   
                  when (f_fin_periodo<getdate()) then 'C'  
                  when (f_inicio_periodo>getdate()) then 'F' end  
        from sact_periodos_eval_acad  
      where id_periodo=@pi_id_periodo  
            
      set @po_c_error = @@error       
      if (@po_c_error  <> 0)   
      begin       
        set @po_d_error = 'Error al obtener los periodos'   
        set @po_c_error = 3   
        return   
      end   
    
end --sp_est_periodo_eval_acad
 
go 

Grant Execute on dbo.sp_est_periodo_eval_acad to GrpTrpSabed 
go

sp_procxmode 'sp_est_periodo_eval_acad', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_est_periodo_recarga'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_est_periodo_recarga" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_est_periodo_recarga (     
@pi_id_periodo	 numeric(18,0),  
@po_estado       varchar(1) output,  
@po_c_error      typ_c_error output,   
@po_d_error      typ_d_error output   
) as   
-------------------------------------------------------------------   
--Objetivo: Estado del periodo  
--Par?metros de salida:    
-- po_estado, po_c_error y po_d_error   
-------------------------------------------------------------------   
   
begin   
     
  set @po_c_error = 0   
  set @po_d_error = null   
    
  If @pi_id_periodo is null  
  begin       
    set @po_d_error = 'No se inform? periodo'   
    set @po_c_error = 3   
    return   
  end   
   
      Select @po_estado = case when (f_inicio_periodo<= getdate() and f_fin_periodo>=getdate()) then 'A'   
                  when (f_fin_periodo<getdate()) then 'C'  
                  when (f_inicio_periodo>getdate()) then 'F' end  
        from sact_periodos_recargas 
      where id_periodo_recarga = @pi_id_periodo  
            
      set @po_c_error = @@error       
      if (@po_c_error  <> 0)   
      begin       
        set @po_d_error = 'Error al obtener los per?odos'   
        set @po_c_error = 3   
        return   
      end   
    
end --sp_est_periodo_recarga
 
go 

Grant Execute on dbo.sp_est_periodo_recarga to GrpTrpSabed 
go

sp_procxmode 'sp_est_periodo_recarga', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_est_periodo_rend_gas'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_est_periodo_rend_gas" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_est_periodo_rend_gas (   
@pi_id_periodo	 numeric(18,0),  
@po_estado       varchar(1) output,  
@po_c_error      typ_c_error output,   
@po_d_error      typ_d_error output   
) as   
-------------------------------------------------------------------   
--Objetivo: Estado del periodo  
--Par?metros de salida:    
-- po_estado, po_c_error y po_d_error   
-------------------------------------------------------------------   
   
begin   
     
  set @po_c_error = 0   
  set @po_d_error = null   
    
  If (@pi_id_periodo is null  or @pi_id_periodo = 0)
  begin       
    set @po_d_error = 'No se inform? periodo'   
    set @po_c_error = 3   
    return   
  end   
   
      Select @po_estado = case when (f_inicio_periodo<= getdate() and f_fin_periodo>=getdate()) then 'A'   
                  when (f_fin_periodo<getdate()) then 'C'  
                  when (f_inicio_periodo>getdate()) then 'F' end  
        from sact_periodos_rendicion  
      where id_periodo=@pi_id_periodo  
            
      set @po_c_error = @@error       
      if (@po_c_error  <> 0)   
      begin       
        set @po_d_error = 'Error al obtener los periodos'   
        set @po_c_error = 3   
        return   
      end   
    
end --sp_est_periodo_rend_gas
 
go 

Grant Execute on dbo.sp_est_periodo_rend_gas to GrpTrpSabed 
go

sp_procxmode 'sp_est_periodo_rend_gas', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_eval_acad_completa'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_eval_acad_completa" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_eval_acad_completa( 
@pi_id_usuario          numeric(18,0),  
@pi_id_alumno           numeric(18,0),  
@pi_id_periodo          numeric(18,0),   
@po_completa            varchar(30)  output, 
@po_c_error             typ_c_error output,  
@po_d_error             typ_d_error output  
)  
as   
--objetivo: indica si el alumno recibido tiene la Situaci?n Acad?mica completa 
begin 
 
  set @po_completa = 'COMPLETA' 
 
  --retorna las preguntas q no se contestaron para el alumno en ese per?do 
  --si retorna algo es q est? incompleto 
  if exists ( 
    select 1 
      from saat_respuestas_eval_academ r 
     where id_pregunta not in (select aed.id_pregunta 
                                 from saat_alumnos_eval_academ ae, 
                                      saat_detalle_eval_academ aed, 
                                      saat_preguntas_eval_academ p 
                               where  p.id_pregunta = aed.id_pregunta 
                                  and ae.id_eval_academ = aed.id_eval_academ  
                                  and ae.id_alumno = @pi_id_alumno  
                                  and ae.e_registro = 'D'    
                                  and ae.id_periodo = @pi_id_periodo 
                             group by aed.id_pregunta) 
            ) 
  begin 
      set @po_completa = 'PENDIENTE' 
  end            
 
end -- sp_eval_acad_completa
 
go 

Grant Execute on dbo.sp_eval_acad_completa to GrpTrpSabed 
go

sp_procxmode 'sp_eval_acad_completa', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_evaluacion_acad'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_evaluacion_acad" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_evaluacion_acad(            
@pi_id_usuario     numeric(18,0),       
@pi_id_persona     numeric(18,0),       
@pi_id_periodo     numeric(18,0),       
@po_id_alumno      numeric(18,0) output,       
@po_c_error        typ_c_error   output,       
@po_d_error        typ_d_error   output       
)       
as       
/*       
Objetivo: retorna un cursor con las secciones, preguntas       
          y respuestas, si hubiera, de cada alumno       
          para las evaluaciones acad?micas de los alumnos,      
          retorna todos los per?odos, as? est?n      
          CERRADOS, ABIERTOS O FUTUROS.     
*/       
        
begin        
        
  if (@pi_id_usuario is null or @pi_id_usuario = 0) 
    begin       
      set @po_c_error = 3       
      set @po_d_error = 'No se recibi? pi_id_usuario'      
      return              
  end       
     
  if (@pi_id_periodo is null or @pi_id_periodo = 0) 
    begin       
      set @po_c_error = 3 
      set @po_d_error = 'No se recibi? per?odo'      
      return              
  end    
        
  if (@pi_id_persona is null or @pi_id_persona = 0) 
    begin       
      set @po_c_error = 3 
      set @po_d_error = 'No se recibi? la persona'      
      return              
  end       
        
  declare @fecha      varchar(10),       
          @fecha_date   datetime,                
          @cant_filas   int
	-- nuevo 19/12/12	
	declare	 
		  @switch INT
    -- fin nuevo 19/12/12    
  set @po_c_error = 0       
  set @po_d_error = null       
  set @fecha_date = getDate()       
      
  -- verifica si el usuario loggeado @pi_id_usuario puede acceder al alumno @pi_id_persona     
  execute sp_verifica_accesibilidad     
                    @pi_id_usuario = @pi_id_usuario,     
                    @pi_id_persona = @pi_id_persona,     
                    @po_c_error    = @po_c_error output,     
                    @po_d_error    = @po_d_error output     
                                     
  if (@po_c_error  <> 0)        
  begin     
      return         
  end     
      
  --convierto el varchar de entrada a date        
  execute sp_convierte_fecha_en_char @pi_fecha_datetime = @fecha_date,       
                                     @po_fecha_char     = @fecha      output,       
                                     @po_c_error        = @po_c_error output,       
                                     @po_d_error        = @po_d_error output       
                                   
  if (@po_c_error  <> 0)  
   begin 
      set @po_d_error = 'Error llamando a sp_convierte_fecha_en_char : ' + @po_d_error   
      return         
   end 
          
  select @po_id_alumno = id_alumno       
    from saat_alumnos       
   where id_persona = @pi_id_persona     
     and e_alumno in ('BECADO','SUSPENDIDO')     
           
  set @po_c_error = @@error        
          
  if (@po_c_error  <> 0)       
  begin        
      set @po_d_error =  'Error al consultar identificador de alumno. '       
      set @po_c_error = 3       
      return       
  end    
  
 
 
 if ((select s_ultimo from sact_periodos_eval_acad where id_periodo = @pi_id_periodo) = 1)
	begin        
		set @switch = 1
    end   
  
        
select (select aea.id_eval_academ   
         from saat_detalle_eval_academ det,   
              saat_alumnos_eval_academ aea    
        where p.id_pregunta = det.id_pregunta     
          and aea.id_eval_academ = det.id_eval_academ   
          and p.id_pregunta = det.id_pregunta   
          and aea.id_alumno = @po_id_alumno    
          and aea.id_periodo =@pi_id_periodo) id_eval_academ,      
       s.d_seccion,   
       p.d_pregunta,   
       r.d_respuesta,    
       p.d_modo_visualizacion,     
       (select det.d_valor_rta    
         from saat_detalle_eval_academ det,    
              saat_alumnos_eval_academ aea    
        where  p.id_pregunta = det.id_pregunta     
          and aea.id_eval_academ = det.id_eval_academ   
          and p.id_pregunta = det.id_pregunta   
          and aea.id_alumno = @po_id_alumno    
          and aea.id_periodo =@pi_id_periodo)   d_valor_rta,     
       (select det.id_respuesta    
         from saat_detalle_eval_academ det,   
              saat_alumnos_eval_academ aea    
        where  p.id_pregunta = det.id_pregunta     
          and aea.id_eval_academ = det.id_eval_academ   
          and p.id_pregunta = det.id_pregunta   
          and aea.id_alumno = @po_id_alumno    
          and aea.id_periodo = @pi_id_periodo)id_respuesta_alumno,     
       s.id_seccion,   
       p.id_pregunta,   
       r.id_respuesta,
        p.tipo_dato      
  from saat_secciones_eval_academ s,       
       saat_preguntas_eval_academ p,       
       saat_respuestas_eval_academ r   
  where s.id_seccion = p.id_seccion       
    and r.id_pregunta = p.id_pregunta 
-- NUEVO 19/12/12
   and p.f_baja is null
   and (s.s_solo_ultimo = 0
   or s.s_solo_ultimo = @switch)
-- FIN NUEVO 19/12/12        
  order by s.n_orden, p.n_orden, r.n_orden   
       
         
  set @po_c_error = @@error                 
  if (@po_c_error  <> 0)       
  begin        
      set @po_d_error =  convert(varchar,@po_c_error)        
                         + ' - Error al consultar lista de preguntas. '           
      return       
  end       
     
end
 
go 

Grant Execute on dbo.sp_evaluacion_acad to GrpTrpSabed 
go

sp_procxmode 'sp_evaluacion_acad', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_genera_lineas_pago'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_genera_lineas_pago" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_genera_lineas_pago(
@pi_id_usuario      	   numeric(18,0), 
@pi_id_lote_pago    	   numeric(18,0),
@po_nombre_archivo         varchar(250) output,
@po_c_error         	   typ_c_error output,
@po_d_error         	   typ_d_error output
)
as
/*
Objetivo: 
*/

begin

  if (@pi_id_usuario is null or @pi_id_usuario = 0)
    begin
      set @po_c_error = 3
      set @po_d_error = 'No se recibi? pi_id_usuario'
      return       
  end
  
  if (@pi_id_lote_pago is null or @pi_id_lote_pago = 0)
    begin
      set @po_c_error = 3
      set @po_d_error = 'No se recibi? pi_id_lote_pago'
      return       
  end  

  declare @CantArch int

  set @po_c_error = 0
  set @po_d_error = null

  select d_fe_operacion,
         d_tip_movi,
         d_nro_clien,
         d_suc_ctadeb,
         d_tipo_cta_mon,
         d_nro_cta,
         d_cod_admin,
         d_nro_cta_cred,
         d_nro_tarjeta,
         d_imp_recarga,
         d_imp_comision,
         d_fe_recarga,
         d_cod_recarga,
         d_ind_extr_efect + replicate(' ',63) d_ind_extr_efect -- le agregamos los campos de la definicion: CLI-CASH NRO-EMPRESA  RETORNO FILLER
    from sart_lotes_pago c, sart_lotes_det_pago d    
   where c.id_lote_pago = d.id_lote_pago  
     and d.id_lote_pago = @pi_id_lote_pago
     AND c.e_lote_pago <> 'ANULADO'
   order by d_imp_comision
  
  set @po_c_error = @@error
                  
  if (@po_c_error  <> 0) 
  begin
      set @po_d_error =  'Error al obtener las lineas para el archivo. '
      return  
  end
  
  update sart_lotes_pago
  set c_usua_actuac = @pi_id_usuario,  
      f_actuac = getDate(),  
      e_lote_pago = 'GENERADO'
  where id_lote_pago = @pi_id_lote_pago
  
  set @po_c_error = @@error
                  
  if (@po_c_error  <> 0) 
    begin
      set @po_d_error =  'Error al actualizar lotes de pago. '
      return  
  end
  
  --
  -- Armo el nombre del archivo 
  set @po_nombre_archivo ='RECAR00'

  Select @CantArch=count(0)
    from sart_lotes_pago
   where convert (varchar(12),isnull(f_actuac,f_alta),112) = convert (varchar(12),getDate(),112)
     and e_lote_pago = 'GENERADO'
     --and id_lote_pago = @pi_id_lote_pago

  set @po_nombre_archivo =@po_nombre_archivo +convert(varchar,@CantArch)+'-'+str_replace(convert (varchar(8),getdate(),12),'/','')+'.txt'

  If @CantArch>9 
    begin
      set @po_c_error = 2
      set @po_d_error =  'El sistema que procesa el pago solo acepta hasta nueve archivos por d?a, esta intentando procesar el decimo'
      return  
  end

end --sp_genera_lineas_pago
 
go 

Grant Execute on dbo.sp_genera_lineas_pago to GrpTrpSabed 
go

sp_procxmode 'sp_genera_lineas_pago', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_historia_becas_alumno'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_historia_becas_alumno" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_historia_becas_alumno (
@pi_id_persona    numeric(18,0),
@po_c_error       typ_c_error output,
@po_d_error       typ_d_error output
)

as
-- Objetivo: Obtener el historial de becas de un alumno
-- Parametros de entrada:
--   a.id_persona : Identificador de persona
--

begin

  --
  -- verifico los par?metros de entrada
  if (@pi_id_persona is null or @pi_id_persona = 0)
    begin
      set @po_c_error = 3
      set @po_d_error = 'No se recibi? Identificador de persona '
      return       
  end

  --
  -- Traigo los datos
  select id_alumno,
         e_alumno,
         case when e_alumno = 'CANDIDATO' then isnull(f_actuac,f_alta)
              when e_alumno = 'POSTULANTE' then f_propuesta_beca 
              when e_alumno = 'BECADO' then f_resul_prop
              when e_alumno = 'ELIMINADO' then f_actuac
              when e_alumno = 'RECHAZADO' then f_resul_prop
              when e_alumno = 'BAJABECA' then f_baja
              when e_alumno = 'SUSPENDIDO' then f_suspension
              when e_alumno = 'TEMINADO' then f_actuac end fecha,
         case when e_alumno = 'CANDIDATO' then 'Candidato sin postular a beca'
              when e_alumno = 'POSTULANTE' then isnull(x_observ_prop,'Postulado para beca')
              when e_alumno = 'BECADO' then isnull( x_observ_resul_prop,'Becado')
              when e_alumno = 'ELIMINADO' then 'Registro eliminado'
              when e_alumno = 'RECHAZADO' then isnull( x_observ_resul_prop,'Propuesta de Beca rechazada')
              when e_alumno = 'BAJABECA' then isnull(x_observ_baja,'Beca dada de baja')
              when e_alumno = 'SUSPENDIDO' then isnull(x_motivo_suspension,'Beca suspendida')
              when e_alumno = 'TEMINADO' then 'Beca terminada' end Observacion
   from saat_alumnos
  Where id_persona = @pi_id_persona
  order by 3

  set @po_c_error = @@error    
  
  if (@po_c_error  <> 0)
  begin 
      set @po_d_error =  convert(varchar,@po_c_error) 
                         + ' - Error al intentar obtener los datos del historial de becas. '
      return
  end
end  -- sp_historia_becas_alumno
 
go 

Grant Execute on dbo.sp_historia_becas_alumno to GrpTrpSabed 
go

sp_procxmode 'sp_historia_becas_alumno', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_importe_beca'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_importe_beca" >>>>>'
go 

setuser 'dbo'
go 

create procedure sp_importe_beca (  
	@pi_id_tipo_beca    numeric(18,0),  
	@pi_fecha           varchar(20),  
	@po_i_beca          numeric(18,2) output,  
	@po_c_error         typ_c_error   output,  
	@po_d_error         typ_d_error   output)  
as  
--  
--objetivo: obtener el importe de beca vigente  
--  
begin  
  
  if @pi_id_tipo_beca = 0 or @pi_id_tipo_beca is null   
    begin   
      set @po_c_error = 3    
      set @po_d_error = 'No se recibi? el identificador de beca' 
      return 
  end   
  
  if @pi_fecha is null   
    begin   
      set @po_c_error = 3   
      set @po_d_error = 'No se recibi? la fecha de inspecci?n'       
      return 
  end   
  
  declare @fecha              smalldatetime,  
          @cant_filas         int  
  
  set @po_c_error = 0  
  set @po_d_error = null  
  
  --convierto el varchar de entrada a date   
  execute sp_convierte_char_en_fecha @pi_fecha_char     = @pi_fecha,  
                                     @po_fecha_datetime = @fecha       output,  
                                     @po_c_error        = @po_c_error  output,  
                                     @po_d_error        = @po_d_error  output  
                             
  if (@po_c_error  <> 0)   
  begin  
      set @po_d_error ='Error llamando a sp_convierte_char_en_fecha:'+@po_d_error 
      rollback tran recargas   
      return    
  end  
  
  select @po_i_beca = i_beca  
    from saat_tipo_beca_detalle tbd,    
         saat_tipo_beca tb   
   where tb.id_tipo_beca = @pi_id_tipo_beca 
     and tb.id_tipo_beca = tbd.id_tipo_beca    
     and (tb.f_baja is null or tb.f_baja > @fecha)        
     and tbd.f_vigencia_desde <= @fecha    
     and tbd.f_vigencia_hasta >= @fecha  
  
  set @po_c_error = @@error, @cant_filas = @@rowcount  
  if (@po_c_error  <> 0)  
  begin   
      set @po_d_error = 'Error en sp_importe_beca. Al buscar datos del tipo de beca. ' 
  end  
  
  if (@cant_filas  = 0)  
    begin   
      set @po_d_error = 'Error en sp_importe_beca. No se encontraron datos del tipo de beca: ' + convert(varchar,@pi_id_tipo_beca) 
      set @po_c_error = 3 
  end  
end 

go 

Grant Execute on dbo.sp_importe_beca to GrpTrpSabed 
go

sp_procxmode 'sp_importe_beca', anymode
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_iniciar_sesion'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_iniciar_sesion" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_iniciar_sesion(  
@d_user            varchar(40),  
@po_usuario_id     numeric(18,0) output,  
@po_sep_listas     varchar(1)    output,  
@po_sep_sublistas  varchar(1)    output,  
@po_full_name      varchar(120)  output,  
@po_id_ong         numeric(18,0) output,  
@po_d_nombre_ong   varchar(40)   output,  
@po_c_error        typ_c_error   output,  
@po_d_error        typ_d_error   output  
)  
as  
-------------------------------------------------------------------------------  
--objetivo: se llamar? al entrar a la aplicaci?n. El po_usuario_id ser? el q se  
--maneje a lo largo de la aplicaci?n por el resto de los servicios.  
---- Parametros de entrada:   
---- d_user: usuario de loggeo del sistema   
---- Parametros de salida: separadores de listas, para utilizar  
---- en la aplicaci?n y en la base.  
---- Cursor de Accesos de acuerdo a los perfiles del usuario  
-------------------------------------------------------------------------------  
begin  
 
  declare @dummy numeric(18,0) 
  
  set @po_c_error = 0  
  set @po_d_error = null  
  
  --obtener el id de usuario  
  select @po_usuario_id = usu.id_usuario,  
         @po_full_name  = per.d_nombre+', '+ per.d_apellido  
    from sast_usuarios usu,  
         sagt_personas per  
   where usu.id_persona = per.id_persona  
     and usu.d_user = @d_user  
     and usu.e_usuario = 'D' 
  
  set @po_c_error = @@error      
  if (@po_c_error  <> 0)  
  begin   
      set @po_d_error =  convert(varchar,@po_c_error)   
                         + ' - Error al obtener id del usuario. '   
      return  
  end  
    
  --obtener el cursor con los permisos  
  select distinct ac.id_acceso, ac.d_acceso  
    from sast_usuarios_perfiles up,  
         sast_accesos_por_perfiles ap,  
         sast_accesos ac  
   where up.id_usuario = @po_usuario_id  
    and  ap.id_perfil = up.id_perfil    
    and  ac.id_acceso = ap.id_acceso    
    and e_usu_perfil = 'D' 
  
  set @po_c_error = @@error      
  if (@po_c_error  <> 0)  
  begin   
      set @po_d_error =  convert(varchar,@po_c_error)   
                         + ' - Error al obtener los permisos del usuario. '   
  
      return  
  end    
   
  --obtengo los separadores de registros y de campos 
  execute sp_separador_registros  
                              @po_separador_registro = @po_sep_listas output,  
                              @po_separador_campo    = @po_sep_sublistas output,  
                              @po_c_error            = @po_c_error output,  
                              @po_d_error            = @po_d_error output  
  
    if (@po_c_error  <> 0)  
    begin  
	  set @po_d_error = 'Error llamando a sp_separador_registros : ' + @po_d_error
      return         
    end                                     
 
  -- Obtengo la ONG de quien esta logueado, si es del equipo de becas o superior  
  --en jerarquia, la ONG viene en NULL  
  execute sp_obtiene_ong_usu  @pi_id_usuario = @po_usuario_id,   
                              @pi_id_perfil  = @dummy,   
                              @po_id_ong     = @po_id_ong output,   
                              @po_c_error    = @po_c_error output,   
                              @po_d_error    = @po_d_error output                          
  if (@po_c_error  <> 0) 
	begin
		set @po_d_error = 'Error llamando a sp_obtiene_ong_usu : ' + @po_d_error	
		return 
	end
   
   
  --obtengo la descrip de la ong 
  select @po_d_nombre_ong = o.d_nombre_ong 
  from   saft_ongs o 
  where o.id_ong = @po_id_ong 
    and o.e_registro = 'D' 
    and o.m_fundacion = 'N' 
 
end --sp_iniciar_sesion
 
go 

Grant Execute on dbo.sp_iniciar_sesion to GrpTrpSabed 
go

sp_procxmode 'sp_iniciar_sesion', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_ins_detalle_recarga'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_ins_detalle_recarga" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_ins_detalle_recarga( 
@pi_id_usuario      numeric(18,0), 
@pi_id_lote         numeric(18,0), 
@pi_id_tutor_coord  numeric(18,0), 
@pi_n_periodo       int, 
@pi_l_alu           typ_lista,    
@po_c_error         typ_c_error output, 
@po_d_error         typ_d_error output 
) 
as 
/* 
Objetivo: limpia e inserta los detalles de recargas de tarjetas de los alumnos 
*/ 
 
begin 
 
  if (@pi_id_usuario is null or @pi_id_usuario = 0)
    begin 
      set @po_c_error = 3 
      set @po_d_error = 'No se recibi? pi_id_usuario' 
      return        
  end 
 
  declare @f_operacion      datetime, 
          @sep              varchar(1), 
          @subSep           varchar(1), 
          @v_lista          typ_lista,  
          @reg_detalle      typ_lista, 
          @id_lote_recarga  numeric(18,0), 
          @id_alu_tar       numeric(18,0), 
          @id_tipo_beca     numeric(18,0), 
          @e_alumno         varchar(1), 
          @q_recargas       int 
 
  set @po_c_error = 0 
  set @po_d_error = null 
   
  execute sp_separador_registros 
             @po_separador_registro    = @sep        output, 
             @po_separador_campo       = @subSep     output, 
             @po_c_error               = @po_c_error output, 
             @po_d_error               = @po_d_error output   
              
  if (@po_c_error  <> 0)  
  begin 
	  set @po_d_error = 'Error llamando a sp_separador_registros : ' + @po_d_error
      return   
  end 
   
  delete sart_lotes_det_recarga 
  where id_lote_recarga = @pi_id_lote 
   
  set @po_c_error = @@error 
   
  if (@po_c_error  <> 0)  
  begin 
      set @po_d_error =  'Error al limpiar detalle de recargas. ' 
      return   
  end   
 
  set @v_lista             = @pi_l_alu + @sep 
 
  --parseo la lista 
  while (@v_lista is not null) 
  begin 
 
                   
                  --obtengo un elemento de la lista 
                  set @reg_detalle = substring(@v_lista, 1,charindex(@sep,@v_lista)-1) +  @subSep  
                                         
                  --obtengo el resto de la lista                         
                  set @v_lista = substring(@v_lista, 
                                             charindex(@sep,@v_lista)+1,  
                                             char_length(@v_lista) 
                                             )                          
                  
                  --desarmo el registro de detalle  
                  set @id_alu_tar   = null 
                  set @e_alumno     = null 
                  set @q_recargas   = null 
                  set @id_tipo_beca = null 
                   
 
                  set @id_alu_tar	   = convert(numeric,substring(@reg_detalle,1,charindex(@subSep,@reg_detalle)-1)) 
                 
                  set @reg_detalle    = substring(@reg_detalle, 
                                                      charindex(@subSep,@reg_detalle)+1,  
                                                      char_length(@reg_detalle) 
                                                     ) 
 
                  set @e_alumno 	   = substring(@reg_detalle,1,charindex(@subSep,@reg_detalle)-1) 
                 
                  set @reg_detalle    = substring(@reg_detalle, 
                                                      charindex(@subSep,@reg_detalle)+1,  
                                                      char_length(@reg_detalle) 
                                                     ) 
 
                  set @q_recargas 	   = convert(numeric,substring(@reg_detalle,1,charindex(@subSep,@reg_detalle)-1)) 
                 
                  set @reg_detalle    = substring(@reg_detalle, 
                                                      charindex(@subSep,@reg_detalle)+1,  
                                                      char_length(@reg_detalle) 
                                                     )  
 
 
                  set @id_tipo_beca 	   = convert(numeric,substring(@reg_detalle,1,charindex(@subSep,@reg_detalle)-1)) 
                 
                  set @reg_detalle    = substring(@reg_detalle, 
                                                      charindex(@subSep,@reg_detalle)+1,  
                                                      char_length(@reg_detalle) 
                                                     )  
                                                      
                  insert into sart_lotes_det_recarga (                                                             
                                id_lote_recarga, 
                                id_alu_tar, 
                                --id_tipo_beca, 
                                e_alumno,                                 
                                q_becas_a_recargar, 
                                c_usua_alta) 
                              values ( 
                                @id_lote_recarga,   
                                @id_alu_tar, 
                                --@id_tipo_beca,                                 
                                @e_alumno, -- SI, NO 
                                @q_recargas, 
                                @pi_id_usuario 
                                ) 
  
                  set @po_c_error = @@error     
                 
                  if (@po_c_error  <> 0) 
                  begin  
                      rollback tran recargas 
                      set @po_d_error =  'Error al insertar detalle de recargas. ' 
                      return 
                  end 
  end --while 
  
end --sp_ins_detalle_recarga 
 
go 

Grant Execute on dbo.sp_ins_detalle_recarga to GrpTrpSabed 
go

sp_procxmode 'sp_ins_detalle_recarga', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_ins_tipo_beca_det'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_ins_tipo_beca_det" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_ins_tipo_beca_det (     
@pi_id_tipo_beca	numeric(18,0),     
@pi_id_tipo_beca_det	numeric(18,0),     
@pi_i_beca	        varchar(25), 
@pi_f_vigencia_desde	varchar(19),     
@pi_f_vigencia_hasta	varchar(19),      
@pi_id_usuario          numeric(18,0),    
@po_c_error             typ_c_error output,     
@po_d_error             typ_d_error output     
)     
     
as     
--Objetivo: mantener los valores del detalle de las becas     
     
begin     
        
  if (@pi_id_usuario is null or @pi_id_usuario = 0)     
  begin     
      set @po_c_error = 3     
      set @po_d_error = 'No se recibi? usuario '     
      return            
  end     
     
  if (@pi_id_tipo_beca is null or @pi_id_tipo_beca = 0)      
  begin     
      set @po_c_error = 2     
      set @po_d_error = 'Debe seleccionar un tipo de beca '     
      return            
  end     
     
  if (@pi_i_beca is null) or (convert(numeric,@pi_i_beca) <= 0)
  begin     
      set @po_c_error = 2    
      set @po_d_error = 'Debe ingresar el importe para el tipo de beca '     
      return            
  end     
         
  if (@pi_f_vigencia_desde  is null)     
  begin     
      set @po_c_error = 2     
      set @po_d_error = 'Debe ingresar la fecha de inicio de la vigencia '    
  
      return            
  end     
     
  declare      
  @f_vigencia_desde	datetime,    
  @f_vigencia_hasta     datetime,
  @today00              datetime      
            
  set @po_c_error = 0          
  set @po_d_error = null   
  
  if exists (select id_tipo_beca
               from saat_tipo_beca
              where id_tipo_beca = @pi_id_tipo_beca
                and f_baja is not null 
             )         
  begin
      set @po_c_error = 2     
      set @po_d_error = 'El tipo de Beca est? dado de Baja, no puede modificarlo. '
      return            
  end             
  
  set @pi_f_vigencia_desde = @pi_f_vigencia_desde + 'T00:00'
  set @f_vigencia_desde = convert(datetime, @pi_f_vigencia_desde)
  
  set @today00 = convert(datetime, convert(varchar,getDate(),112)+ 'T00:00' )
          
  -- veo que la fecha desde sea valida     
  if @f_vigencia_desde < @today00 
  begin     
      set @po_c_error = 2     
      set @po_d_error = 'La fecha desde debe ser mayor ? igual a la fecha del d?a'
      return            
  end       
      
  If @pi_f_vigencia_hasta is not null     
  begin    
  
  set @pi_f_vigencia_hasta = @pi_f_vigencia_hasta + 'T23:59'
  set @f_vigencia_hasta = convert(datetime, @pi_f_vigencia_hasta)  

      -- Evaluo que el periodo sea valido     
      If @f_vigencia_hasta < @f_vigencia_desde    
        begin               
          set @po_c_error = 2     
          set @po_d_error = 'La fecha desde debe ser menor a la fecha hasta'
          return            
      end     
          
  end    
      
  --    
  -- Evaluo que el periodo no se superponga con otro ya existente  
   
  if exists (select 1          
               from saat_tipo_beca_detalle per         
              where per.f_vigencia_desde <= @f_vigencia_desde     
                and isnull(per.f_vigencia_hasta,@f_vigencia_desde) >= @f_vigencia_desde        
 
                and id_tipo_beca = @pi_id_tipo_beca    
                and (id_tipo_beca_det <> @pi_id_tipo_beca_det or isnull(@pi_id_tipo_beca_det,0)=0)      
             )                  
    begin                     
      set @po_c_error = 2           
      set @po_d_error = 'El per?odo informado se superpone con uno existente'          
      return          
  end     
             
  -- Evaluo si no esta superpuesto con otro periodo ya insertado     
  if @pi_id_tipo_beca_det is not null and @pi_id_tipo_beca_det <> 0   
     begin          
            
       -- ver actualizo el ultimo periodo     
       Update saat_tipo_beca_detalle      
          set f_vigencia_desde = @f_vigencia_desde,     
              f_vigencia_hasta = @f_vigencia_hasta,     
              c_usua_actuac =@pi_id_usuario,     
              f_actuac = getdate(),  
              i_beca = convert(numeric(18,2),@pi_i_beca)         
        where id_tipo_beca_det = @pi_id_tipo_beca_det     
            
       set @po_c_error = @@error         
       if (@po_c_error  <> 0)     
       begin      
         set @po_d_error = 'Error al actualizar del detalle del tipo de la beca'       
         return     
       end     
            
    end     
  else     
    -- es un alta     
    begin     
           
      -- cargo el proximo periodo     
      Insert into saat_tipo_beca_detalle (id_tipo_beca,i_beca,f_vigencia_desde,f_vigencia_hasta,c_usua_alta)     
      values (@pi_id_tipo_beca,convert(numeric(18,2),@pi_i_beca),@f_vigencia_desde,@f_vigencia_hasta,@pi_id_usuario)                  
      set @po_c_error = @@error         
      if (@po_c_error  <> 0)     
        begin      
          set @po_d_error = 'Error al insertar el detalle del tipo de beca'                
          return     
      end     
           
  end -- de ver si es un alta o una modificacion    
           
end  -- sp_ins_tipo_beca_det 
 
go 

Grant Execute on dbo.sp_ins_tipo_beca_det to GrpTrpSabed 
go

sp_procxmode 'sp_ins_tipo_beca_det', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_inserta_alumno_tarjeta'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_inserta_alumno_tarjeta" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_inserta_alumno_tarjeta (     
@pi_id_usuario          numeric(18,0),     
@pi_id_alu_tar          numeric(18,0),     
@pi_id_alumno           numeric(18,0),     
@pi_id_persona_tit      numeric(18,0),     
@pi_d_nro_tarjeta       varchar(16),     
@pi_d_nro_cta_cred      varchar(10),    
@pi_f_vigencia_tar_dsd  varchar(20),      
@pi_f_vigencia_tar_hta  varchar(20),     
@po_id_alu_tar          numeric(18,0) output,     
@po_c_error             typ_c_error   output,     
@po_d_error             typ_d_error   output     
)     
as     
-------------------------------------------------------------------     
--Objetivo: mantener los datos de la tarejeta del alumno     
--          asociado al titular    
--Par?metros de entrada:      
--Par?metros de salida:      
--po_c_error y po_d_error     
-------------------------------------------------------------------     
     
begin     
      
  if (@pi_id_usuario is null or @pi_id_usuario = 0)     
  begin     
      set @po_c_error = 3     
      set @po_d_error = 'No se recibi? pi_id_usuario'     
      return     
  end       
       
  if (@pi_f_vigencia_tar_dsd is null)     
  begin     
      set @po_c_error = 2     
      set @po_d_error = 'No se recibi? fecha de inicio de vigencia'     
      return     
  end       
       
  if (@pi_f_vigencia_tar_hta is null)     
  begin     
      set @po_c_error = 2     
      set @po_d_error = 'No se recibi? fecha de fin de vigencia'     
      return     
  end         
     
  if @pi_d_nro_tarjeta is null     
  begin     
      set @po_c_error = 2     
      set @po_d_error = 'No se recibi? el nro. Tarjeta'     
      return     
  end    
          
  if @pi_d_nro_cta_cred is null    
  begin     
      set @po_c_error = 2     
      set @po_d_error = 'No se recibi? el nro. cuenta cr?dito'     
      return     
  end    
           
  if (@pi_id_alumno is null or @pi_id_alumno = 0) 
  begin     
      set @po_c_error = 3     
      set @po_d_error = 'No se recibi? pi_id_alumno'     
      return     
  end         
      
  if (@pi_id_persona_tit is null or @pi_id_persona_tit = 0) 
  begin     
      set @po_c_error = 3 
      set @po_d_error = 'No se recibi? pi_id_persona_tit'     
      return     
  end   
  
  if exists ( select 1
              from saat_alumnos_tarjetas
              where d_nro_tarjeta = @pi_d_nro_tarjeta
                and (id_alu_tar <> @pi_id_alu_tar or @pi_id_alu_tar=0 or @pi_id_alu_tar is null))
  begin     
      set @po_c_error = 2
      set @po_d_error = 'Ya se di? de alta una tarjeta con el n?mero: ' + @pi_d_nro_tarjeta 
      return     
  end   
             
  if not exists (select 1
                   from saat_alumnos
                  where id_alumno = @pi_id_alumno
                    and e_alumno in ('BECADO','SUSPENDIDO'))
  begin
    set @po_c_error = 2    
    set @po_d_error = 'El alumno no se encuentra en estado BECADO o SUSPENDIDO'     
    return    
  end       

  declare     
      @f_vigencia_tar_dsd  datetime,      
      @f_vigencia_tar_hta  datetime,    
      @cantidad            numeric(18,0),
      @id_lote_det_recarga numeric(18,0)
     
  set @po_c_error = 0     
  set @po_d_error = null   
  
  set @pi_f_vigencia_tar_dsd = @pi_f_vigencia_tar_dsd + 'T00:00'
  set @pi_f_vigencia_tar_hta = @pi_f_vigencia_tar_hta    + 'T23:59'

  set @f_vigencia_tar_dsd = convert(datetime, @pi_f_vigencia_tar_dsd)
  set @f_vigencia_tar_hta = convert(datetime, @pi_f_vigencia_tar_hta)  
     
  If @f_vigencia_tar_hta is not null and @f_vigencia_tar_dsd is not null and @f_vigencia_tar_hta < @f_vigencia_tar_dsd  
    begin     
      set @po_c_error = 2    
      set @po_d_error = 'La fecha hasta es menor a la desde'     
      return     
  end    

  if exists (select 1
               from saat_alumnos_tarjetas alutar
              where alutar.id_alumno = @pi_id_alumno
                and alutar.f_vigencia_tar_dsd<=@pi_f_vigencia_tar_hta
                and alutar.f_vigencia_tar_hta>=@pi_f_vigencia_tar_dsd
                and alutar.f_baja is null
                and (alutar.id_alu_tar <> @pi_id_alu_tar or @pi_id_alu_tar=0 or @pi_id_alu_tar is null))
  begin
    set @po_c_error = 2    
    set @po_d_error = 'El alumno ya posee una tarjeta vigente para la vigencia de la tarjeta que esta ingresando'     
    return    
  end    

  --
  -- Veo si es un alta o una modificacion   
  if @pi_id_alu_tar is null or @pi_id_alu_tar = 0     
    begin  -- Alta
  
      --
      -- Inserto la tarjeta
      insert into saat_alumnos_tarjetas (id_alumno,     
                                         id_persona_tit,     
                                         d_nro_tarjeta,    
                                         d_nro_cta_cred,     
                                         f_vigencia_tar_dsd,     
                                         f_vigencia_tar_hta,     
                                         c_usua_alta)      
                                 values (@pi_id_alumno,     
                                         @pi_id_persona_tit,     
                                         @pi_d_nro_tarjeta,     
                                         @pi_d_nro_cta_cred,    
                                         @f_vigencia_tar_dsd,     
                                         @f_vigencia_tar_hta,     
                                         @pi_id_usuario)     
           
      set @po_c_error = @@error, @po_id_alu_tar = @@identity         
      if (@po_c_error  <> 0)     
        begin         
          set @po_d_error = 'Error al insertar la tarjeta del alumno'    
          return    
      end     
      
      --
      -- Lotes de acreditacion a modificar
      declare lotes_acred cursor for
       select @id_lote_det_recarga = id_lote_det_recarga
         from sart_lotes_recarga r, 
              sart_lotes_det_recarga dr,
              sact_periodos_recargas per
        where r.id_lote_recarga = dr.id_lote_recarga
          and r.c_estado_lote in ('EN_REVISION','CONFIRMADO','A_PAGAR')
          and dr.id_alumno = @pi_id_alumno
          and r.id_periodo_recarga = per.id_periodo_recarga
          and @f_vigencia_tar_dsd <= per.f_fin_periodo

      --
      -- Recorro los lotes donde ese Alumno esta en proceso de acreditacion
      open lotes_acred
      fetch lotes_acred into @id_lote_det_recarga

      while (@@sqlstatus != 2)
       begin 

         update sart_lotes_det_recarga
            set id_alu_tar    = @po_id_alu_tar,
                c_usua_actuac = @pi_id_usuario,     
                f_actuac      = getDate()     
          where id_lote_det_recarga = @id_lote_det_recarga
          
         set @po_c_error = @@error    
         if (@po_c_error  <> 0)     
           begin         
             set @po_d_error = 'Error al modificar el identificador de tarjeta, en el detalle de lote de recarga: '+ convert(varchar,@id_lote_det_recarga)    
             close lotes_acred
             return    
         end  

         fetch lotes_acred into @id_lote_det_recarga 

      end -- wile
      close lotes_acred

  end     
  else  -- modificacion
    begin     
      
      update saat_alumnos_tarjetas     
         set d_nro_cta_cred     = @pi_d_nro_cta_cred,     
             d_nro_tarjeta      = @pi_d_nro_tarjeta,     
             f_vigencia_tar_dsd = @f_vigencia_tar_dsd,     
             f_vigencia_tar_hta = @f_vigencia_tar_hta,     
             c_usua_actuac      = @pi_id_usuario,     
             f_actuac           = getDate()     
       where id_alu_tar = @pi_id_alu_tar     
     
      set @po_c_error = @@error         
      if (@po_c_error  <> 0)     
        begin         
          set @po_d_error = 'Error al modificar la tarjeta del alumno '     
          return    
      end    
      
      set @po_id_alu_tar = @pi_id_alu_tar     
       
  end    
                
end -- sp_inserta_alumno_tarjeta
 
go 

Grant Execute on dbo.sp_inserta_alumno_tarjeta to GrpTrpSabed 
go

sp_procxmode 'sp_inserta_alumno_tarjeta', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_inserta_colegio'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_inserta_colegio" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_inserta_colegio ( 
@pi_d_nombre_directora   varchar(40), 
@pi_d_nombre_colegio     varchar(40), 
@pi_d_cuit               varchar(40), 
@pi_d_mail               varchar(40), 
@pi_d_calle		 		 varchar(40), 
@pi_d_nro		 		 varchar(40), 
@pi_d_piso		 		 varchar(40), 
@pi_d_depto		 	 	 varchar(40), 
@pi_d_localidad          varchar(40), 
@pi_c_provincia          numeric(18,0), 
@pi_c_usua_alta          numeric(18,0), 
@pi_e_registro           varchar(1),   
@po_id_colegio           numeric(18,0) output, 
@po_c_error      	 	 typ_c_error output, 
@po_d_error      	 	 typ_d_error output 
) 
as 
-------------------------------------------  
------------------------ 
--Objetivo: Alta de Colegio. 
--Par?metros de entrada: 
--	D_NOMBRE_DIRECTORA 
--	D_NOMBRE_COLEGIO 
--	C_USUA_ALTA 
--Par?metros de salida: po_id_colegio, po_c_error y po_d_error 
------------------------------------------------------------------- 
 
begin 
 
  set @po_c_error = 0 
  set @po_d_error = null 
   
  insert into sagt_colegios  (d_nombre_directora, d_nombre_colegio,  
                              d_cuit, d_mail,  
                              d_calle, d_nro,  
                              d_piso, d_depto,  
                              d_localidad, c_provincia,  
                              c_usua_alta,e_registro)  
                      values (upper(@pi_d_nombre_directora), upper(@pi_d_nombre_colegio), 
                              @pi_d_cuit, @pi_d_mail,  
                              @pi_d_calle, @pi_d_nro,  
                              @pi_d_piso, @pi_d_depto,  
                              @pi_d_localidad, @pi_c_provincia, 
                              @pi_c_usua_alta,@pi_e_registro) 
   
  set @po_c_error = @@error     
 
  if (@po_c_error  <> 0) 
  begin  
      set @po_d_error =   convert(varchar,@po_c_error)  
                         + ' - Error al insertar en sagt_colegios' 
      set @po_c_error = 3 
      return       
  end 
 
  set @po_id_colegio = @@identity 
   
end --sp_inserta_colegio
 
go 

Grant Execute on dbo.sp_inserta_colegio to GrpTrpSabed 
go

sp_procxmode 'sp_inserta_colegio', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_inserta_datos_colegio'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_inserta_datos_colegio" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_inserta_datos_colegio (  
--  drop procedure sp_inserta_datos_colegio 
@pi_d_cuit              varchar(40),  
@pi_l_telefonos         typ_lista, 
@pi_d_mail              varchar(40),   
@pi_d_calle				varchar(40),   
@pi_d_nro				varchar(40),   
@pi_d_piso				varchar(40),   
@pi_d_depto				varchar(40),   
@pi_d_localidad         varchar(40),   
@pi_c_provincia         numeric(18,0),   
@pi_e_registro          char(1),  
@pi_c_usua_alta         numeric(18,0),  
@pi_d_nombre_directora  varchar(40), 
@pi_d_nombre_colegio    varchar(40),  
@po_c_error      		typ_c_error output,  
@po_d_error      		typ_d_error output  
)  
as  
-------------------------------------------   
------------------------  
--Objetivo: Alta de Colegio y sus telefonos 
--Par?metros de entrada:  	  
--	D_CUIT               
--	L_TELEFONO             
--	D_MAIL                 
--	D_CALLE				  
--	D_NRO				  
--	D_PISO				  
--	D_DEPTO				  
--	D_LOCALIDAD           
--	C_PROVINCIA           
--	D_NOMBRE_DIRECTORA    
--	D_NOMBRE_COLEGIO      
--	C_USUA_ALTA       
--      E_REGISTRO      
--Par?metros de salida: po_c_error y po_d_error  
-------------------------------------------------------------------  
  
begin  
 
  if (@pi_d_nombre_colegio is null) 
    begin 
      set @po_c_error = 2 
      set @po_d_error = 'No se recibi? nombre colegio' 
      return        
  end 
   
  if (@pi_d_localidad is null) 
    begin 
      set @po_c_error = 2 
      set @po_d_error = 'No se recibi? localidad' 
      return        
  end 
   
  if (@pi_c_provincia = 0) 
    begin 
      set @po_c_error = 2 
      set @po_d_error = 'No se recibi? provincia' 
      return        
  end 
   
  if (@pi_c_usua_alta is null or @pi_c_usua_alta = 0) 
    begin 
      set @po_c_error = 2 
      set @po_d_error = 'No se recibi? usuario' 
      return        
  end 
 
  if (@pi_e_registro is null) 
    begin 
      set @po_c_error = 2 
      set @po_d_error = 'No se recibi? el estado de registro'  
      return        
  end 
 
  declare  
      @po_id_colegio           numeric(18,0)  
       
  begin tran inscolegio     
       
  if exists (select 1 
               from sagt_colegios c                
              where c.d_nombre_colegio = @pi_d_nombre_colegio 
                and c.d_localidad      = @pi_d_localidad 
                and c.c_provincia      = @pi_c_provincia 
             )       
  begin            
      rollback tran inscolegio     
      set @po_c_error = 2 
      set @po_d_error = 'Ya existe el colegio: ' + @pi_d_nombre_colegio + 
                        ' en esa provincia y localidad. ' 
      return 
  end   
   
  begin   
       
	    execute sp_inserta_colegio 	 
			@pi_d_nombre_directora   = @pi_d_nombre_directora,  
			@pi_d_nombre_colegio     = @pi_d_nombre_colegio,  
			@pi_d_cuit               = @pi_d_cuit,  
			@pi_d_mail               = @pi_d_mail,  
			@pi_d_calle		 		 = @pi_d_calle,  
			@pi_d_nro				 = @pi_d_nro,  
			@pi_d_piso				 = @pi_d_piso,  
			@pi_d_depto				 = @pi_d_depto,  
			@pi_d_localidad          = @pi_d_localidad,  
			@pi_c_provincia          = @pi_c_provincia,  
			@pi_c_usua_alta          = @pi_c_usua_alta,  
            @pi_e_registro           = @pi_e_registro,  
			@po_id_colegio           = @po_id_colegio output,  
			@po_c_error      		 = @po_c_error output,  
			@po_d_error      		 = @po_d_error output  
                                  
	    if (@po_c_error  <> 0)   
	    begin    
            rollback tran inscolegio  
			set @po_d_error = 'Error llamando a sp_inserta_colegio : ' + @po_d_error
            return          
	    end     
  end 
 
  if char_length(@pi_l_telefonos) > 0 
  begin 
   
	execute sp_inserta_tel_col           
 		@pi_id_colegio            = @po_id_colegio, 
        @pi_l_telefonos           = @pi_l_telefonos, 
		@pi_c_usua_alta           = @pi_c_usua_alta, 
		@po_c_error      	  	  = @po_c_error output,  
		@po_d_error      	  	  = @po_d_error output 
                 
  if (@po_c_error  <> 0) 
  begin  
        rollback tran inscolegio   
		set @po_d_error = 'Error llamando a sp_inserta_tel_col : ' + @po_d_error		
        return     
  end                 
   
  end   
   
  commit tran inscolegio       
   
end --sp_inserta_datos_colegio
 
go 

Grant Execute on dbo.sp_inserta_datos_colegio to GrpTrpSabed 
go

sp_procxmode 'sp_inserta_datos_colegio', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_inserta_datos_ong'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_inserta_datos_ong" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_inserta_datos_ong (   
@pi_d_cuit          varchar(40),      
@pi_l_telefonos     typ_lista,  
@pi_d_mail          varchar(40),      
@pi_d_calle	    varchar(40),      
@pi_d_nro	    varchar(40),      
@pi_d_piso	    varchar(40),      
@pi_d_depto	    varchar(40),      
@pi_d_localidad     varchar(40),      
@pi_c_provincia     numeric(18,0),    
@pi_e_registro      char(1),         
@pi_c_usua_alta     numeric(18,0),   
@pi_q_becas         numeric(7,0),   
@pi_d_nombre_ong    varchar(40),   
@pi_c_tipo_ong      numeric(18,0),   
@pi_d_suc_cuenta    varchar(4)    ,   
@pi_d_tipo_cuenta   varchar(3)    ,   
@pi_d_nro_cuenta    varchar(7)    ,  
@pi_c_nro_cliente   numeric(8,0)  , 
@po_c_error         typ_c_error     output,   
@po_d_error         typ_d_error     output  
)   
as   
-------------------------------------------    
------------------------   
--Objetivo: Alta de institucion - ONG.    
--Par?metros de entrada:  	   
--	D_CUIT                  
--	L_TELEFONO              
--	D_MAIL                  
--	D_CALLE				   
--	D_NRO				   
--	D_PISO				   
--	D_DEPTO				   
--	D_localidad            
--	C_PROVINCIA            
--	Q_BECAS                
--	D_NOMBRE_ONG           
--	E_REGISTRO             
--	C_USUA_ALTA            
--	C_TIPO_ONG            
--Par?metros de salida: po_c_error y po_d_error   
-------------------------------------------------------------------   
   
begin   
  
  if (@pi_c_usua_alta is null or @pi_c_usua_alta = 0)   
  begin   
      set @po_c_error = 3   
      set @po_d_error = 'No se recibi? usuario'  
      return          
  end  
    
  set @po_c_error = 0  
  set @po_d_error = null  
  
  --se validan los datos necesarios para el alta  
  execute sp_valida_datos_ong  
        @pi_d_cuit       = @pi_d_cuit,  
        @pi_d_calle      = @pi_d_calle,  
        @pi_d_nro        = @pi_d_nro,  
        @pi_d_localidad  = @pi_d_localidad,  
        @pi_c_provincia  = @pi_c_provincia,  
        @pi_e_registro   = @pi_e_registro,  
        @pi_q_becas      = @pi_q_becas,  
        @pi_d_nombre_ong = @pi_d_nombre_ong,  
        @pi_c_tipo_ong   = @pi_c_tipo_ong,  
        @po_c_error      = @po_c_error  output,  
        @po_d_error      = @po_d_error  output  
          
  if (@po_c_error  <> 0)    
  begin    
      return           
  end    
  
  declare   
	@po_id_ong           	numeric(18,0),  
	@c_tipo_tel_fijo      	numeric(18,0),  
        @e_definitivo           char(1),  
        @d_tipo_ong             varchar(40)  
    
  if exists (select id_ong  
               from saft_ongs o  
              where o.d_cuit       = @pi_d_cuit  
                and o.d_nombre_ong = @pi_d_nombre_ong  
                and o.c_tipo_ong   = @pi_c_tipo_ong  
             )        
  begin  
                  
      select @d_tipo_ong = d_valor from sapt_parametros where id_parametro = @pi_c_tipo_ong  
        
      set @po_c_error = 2  
      set @po_d_error = 'Ya existe la ong '+ @d_tipo_ong + ' ' + @pi_d_nombre_ong +  
                        ' con el cuit: ' + @pi_d_cuit   
      return  
  end    
    
  begin tran ins  
    
  begin    
  
	execute sp_inserta_ong 	  
            @pi_d_cuit           = @pi_d_cuit,    
        	@pi_d_mail           = @pi_d_mail,   
        	@pi_d_calle	     	 = @pi_d_calle,   
        	@pi_d_nro	     	 = @pi_d_nro,   
        	@pi_d_piso	     	 = @pi_d_piso,   
        	@pi_d_depto	     	 = @pi_d_depto,   
        	@pi_d_localidad      = @pi_d_localidad,   
        	@pi_c_provincia      = @pi_c_provincia,   
        	@pi_e_registro       = @pi_e_registro,   
        	@pi_c_usua_alta      = @pi_c_usua_alta,   
        	@pi_q_becas          = @pi_q_becas,   
        	@pi_d_nombre_ong     = @pi_d_nombre_ong,   
        	@pi_c_tipo_ong       = @pi_c_tipo_ong,         	  
			@pi_d_suc_cuenta     = @pi_d_suc_cuenta,  
			@pi_d_tipo_cuenta    = @pi_d_tipo_cuenta,  
			@pi_d_nro_cuenta     = @pi_d_nro_cuenta    ,  
			@pi_c_nro_cliente	 = @pi_c_nro_cliente   ,		
        	@po_id_ong           = @po_id_ong       output,   
        	@po_c_error          = @po_c_error      output,   
        	@po_d_error          = @po_d_error      output   
                                   
        if (@po_c_error  <> 0)    
          begin    
            rollback tran ins  
            return           
          end      
     
  end  
  
  if char_length(@pi_l_telefonos) > 0  
  begin  
	execute sp_inserta_tel_ong            
 		@pi_c_usua_alta           = @pi_c_usua_alta,  
		@pi_l_telefonos           = @pi_l_telefonos,			  
		@pi_id_ong                = @po_id_ong,					  
		@po_c_error      	  	  = @po_c_error output,   
		@po_d_error      	  	  = @po_d_error output  
                  
          if (@po_c_error  <> 0)  
          begin   
              rollback tran ins  
              return        
          end                  
                                                                                                                                                                                                                                                         
  end  
  
  execute sp_obtiene_tipo_tel_fijo  @po_c_valor  = @c_tipo_tel_fijo output,  
                                    @po_c_error  = @po_c_error output,  
                                    @po_d_error  = @po_d_error output  
                                 
  if (@po_c_error  <> 0)  
  begin  
      set @po_d_error = 'Error llamando a sp_obtiene_tipo_tel_fijo : ' + @po_d_error 
      return         
  end  
    
  --procedure q retorna los codigos del estado de registro definitivo  
  execute sp_obtiene_e_definitivo   @po_c_valor  = @e_definitivo output,  
                                    @po_c_error  = @po_c_error output,  
                                    @po_d_error  = @po_d_error output  
                                 
    if (@po_c_error  <> 0)  
    begin  
      set @po_d_error = 'Error llamando a sp_obtiene_e_definitivo : ' + @po_d_error	 
      return         
    end          
    
  if @pi_e_registro = @e_definitivo and not exists (  
  select id_telefono  
    from sagt_telefonos  
   where id_ong     = @po_id_ong  
     and c_tipo_telefono = @c_tipo_tel_fijo)  
  begin  
      rollback tran ins  
      set @po_c_error = 2  
      set @po_d_error = 'Debe indicar al menos un tel?fono particular'  
      return           
  end    
  
 commit tran ins  
  
end --sp_inserta_datos_ong 
 
go 

Grant Execute on dbo.sp_inserta_datos_ong to GrpTrpSabed 
go

sp_procxmode 'sp_inserta_datos_ong', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_inserta_det_pago'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_inserta_det_pago" >>>>>'
go 

setuser 'dbo'
go 

create procedure sp_inserta_det_pago ( 
	@pi_id_usuario             numeric(18,2),    
	@pi_id_lote_pago           numeric(18,2),    
	@pi_id_lote_det_recarga    numeric(18,2),    
	@po_c_error          	   typ_c_error output,    
	@po_d_error          	   typ_d_error output)    
as    
/*    
Objetivo:     
*/    
 
begin    
 
  --insert into sabed_log (fecha,descrip,nom_proc) values (getdate(),'Init sp_inserta_det_pago' ,'sp_inserta_det_pago') 
  --insert into sabed_log (fecha,descrip,nom_proc) values (getdate(),'sp_inserta_det_pago / @pi_id_usuario >>>' + convert(varchar,@pi_id_usuario) ,'sp_inserta_det_pago') 
  --insert into sabed_log (fecha,descrip,nom_proc) values (getdate(),'Init sp_inserta_det_pago / @pi_id_lote_pago >>>' +  convert(varchar,@pi_id_lote_pago) ,'sp_inserta_det_pago') 
  --insert into sabed_log (fecha,descrip,nom_proc) values (getdate(),'Init sp_inserta_det_pago / @pi_id_lote_det_recarga >>>' + convert(varchar,@pi_id_lote_det_recarga),'sp_inserta_det_pago') 
 
    
  declare @d_fe_operacion          varchar(10),    
          @d_tip_movi              varchar(2),      
          @d_suc_ctadeb            varchar(4),    
          @d_tipo_cta_mon          varchar(3),    
          @d_nro_cta               varchar(7),    
          @d_cod_admin             varchar(3),    
          @d_nro_cta_cred          varchar(10),    
          @d_nro_tarjeta           varchar(16),    
          @d_imp_recarga           varchar(11),    
          @d_imp_comision          varchar(11),    
          @d_fe_recarga            varchar(10),    
          @d_cod_recarga           varchar(1),    
          @d_ind_extr_efect        varchar(1),    
          -----------------    
          @id_alumno               numeric(18,2),    
          @d_nro_tar               varchar(16),    
          @d_nro_cc                varchar(10),    
          @id_ong                  numeric(18,2),    
          -----------------    
          @d_suc_cuenta            varchar(4),     
	      @d_tipo_cuenta           varchar(3),     
	      @d_nro_cuenta            varchar(7),     
          @c_nro_clien             numeric(8,0),  
		  @d_nro_clien             varchar(8), 
	  -----------------    
		  @q_becas_a_recargar      int,    
		  @id_tipo_beca            numeric(18,2),    
		  @i_beca                  numeric(18,2),    
		  @fecha_char              varchar(20),    
		  @fecha_date              datetime,   
		  @cant                    int,  
		  @d_imp_rec_ent           varchar(8),     
		  @d_imp_rec_dec           varchar(2)  
	    
	      
  set @d_fe_operacion   = str_replace(convert (varchar(10),getdate(),111),'/','-') -- fecha ingreso archivo. Se debe ingresa con el formato AAAA-MM-DD 
  set @d_tip_movi       = 'RU'	                                  -- FIJO --Tipo de movimiento (RU)    
  --set @d_nro_clien      = '01092747'	                          -- FIJO --N?mero de cliente ordenante de la recarga (1092747)    
  set @d_cod_admin      = '119'	                                  -- FIJO --c?digo de administradora (119)    
  set @d_imp_comision   = replicate('0',8) +','+ replicate('0',2) -- FIJO --Se completa con ceros    
  set @d_cod_recarga    = ' '                                     -- FIJO --dejar en blanco    
  set @d_ind_extr_efect = ' '                                     -- FIJO --dejar en blanco    
 
  -- 
  -- Obtengo la fecha de recarga desde la cabecera del lote 
  --insert into sabed_log (fecha,descrip,nom_proc) values (getdate(),'paso 1','sp_inserta_det_pago') 
 
  select @d_fe_recarga  = str_replace(convert (varchar(10),f_recarga,111),'/','-') -- Fecha de recarga. se debe ingresar con el formato AAAA-MM-DD  
    from sart_lotes_pago 
   Where id_lote_pago = @pi_id_lote_pago 
 
  set @po_c_error = @@error,@cant=@@rowcount              
 
  if (@po_c_error  <> 0)        
    begin       
 
      --insert into sabed_log (fecha,descrip,nom_proc) values (getdate(),'error 1 @po_c_error  <> 0','sp_inserta_det_pago') 
 
      set @po_d_error =  'Error al obtener la fecha de recarga de la cabecera dellote de pago:'+convert(varchar,@pi_id_lote_pago)  
      return       
  end  
 
  If @cant=0 
  begin           
     
    -- into sabed_log (fecha,descrip,nom_proc) values (getdate(),'error 2 @cant=0','sp_inserta_det_pago') 
 
    set @po_d_error =  'No se pudo obtener la fecha de recarga de la cabecera dellote de pago:'+convert(varchar,@pi_id_lote_pago)  
    set @po_c_error = 3        
    return       
  end 
     
  select @d_nro_tar = atar.d_nro_tarjeta,    
         @d_nro_cc = atar.d_nro_cta_cred,    
         @d_suc_cuenta = aong.d_suc_cuenta,    
         @d_tipo_cuenta = aong.d_tipo_cuenta,    
         @d_nro_cuenta = aong.d_nro_cuenta,    
		 @c_nro_clien = aong.c_nro_cliente, 
         @q_becas_a_recargar = r.q_becas_a_recargar,    
         @id_tipo_beca = aong.id_tipo_beca   		  
    from sart_lotes_det_recarga r,     
         saat_alumnos_tarjetas atar,     
         saav_alu_tut_ong aong    
   where id_lote_det_recarga = @pi_id_lote_det_recarga     
     and r.id_alu_tar = atar.id_alu_tar    
     and atar.id_alumno = aong.id_alumno    
     and aong.id_perfil_tutor = 1                  -- filtra perfil para traer un s?lo registro de tutor    
   
   
  if @id_tipo_beca is null or @id_tipo_beca = 0   
  begin     
 
      --insert into sabed_log (fecha,descrip,nom_proc) values (getdate(),'error 3 @id_tipo_beca is null or @id_tipo_beca = 0  ','sp_inserta_det_pago') 
 
      set @po_c_error = 3   
      set @po_d_error = 'El @pi_id_lote_det_recarga: ' + convert(varchar,@pi_id_lote_det_recarga) + ' no tiene tipo de beca v?lido. '   
      return    
  end   
   
  -- 
  -- Obtengo la fecha que aplica a la averiguacion del valor de la beca   
 
  --insert into sabed_log (fecha,descrip,nom_proc) values (getdate(),'paso 2','sp_inserta_det_pago') 
 
  select @fecha_date=pr.f_fin_periodo   
    from sact_periodos_recargas pr,   
         sart_lotes_det_recarga ldr,   
         sart_lotes_recarga lr   
   where pr.id_periodo_recarga=lr.id_periodo_recarga   
     and lr.id_lote_recarga = ldr.id_lote_recarga   
     and ldr.id_lote_det_recarga= @pi_id_lote_det_recarga           
  set @po_c_error = @@error,@cant=@@rowcount   
 
 
 
  if (@po_c_error  <> 0)        
    begin      
 
      --insert into sabed_log (fecha,descrip,nom_proc) values (getdate(),'error 4 @po_c_error  <> 0','sp_inserta_det_pago') 
 
      set @po_d_error =  'Error al obtener el periodo de recarga'               
      return       
  end           
  If @cant=0         
    begin      
 
      --insert into sabed_log (fecha,descrip,nom_proc) values (getdate(),'error 5 @cant=0','sp_inserta_det_pago') 
 
      set @po_d_error =  'No se pudo determinar la fecha de consulta'          
      set @po_c_error = 3        
      return       
  end       
   
  --convierto el varchar de entrada a date          
  /* 
  -- ==== Se quito la conversion de la fecha mediante este stored por que da valores erroneos 
  execute sp_convierte_fecha_en_char @pi_fecha_datetime = @fecha_date,         
                                     @po_fecha_char     = @fecha_char output,         
                                     @po_c_error        = @po_c_error output,         
                                     @po_d_error        = @po_d_error output         
                                    
  if (@po_c_error  <> 0)    
    begin   
      set @po_d_error = 'Error llamando a sp_convierte_fecha_en_char:' + @po_d_error   
      return   
  end   
  */ 
   
  --====== Conversion a varchar que funciona David 31/10/2013 
  set @fecha_char = convert(varchar(20),@fecha_date)   
 
 
  --insert into sabed_log (fecha,descrip,nom_proc) values (getdate(),'fecha_date>>>>' + convert(varchar(20),@fecha_date) ,'sp_inserta_det_pago') 
   
  --obtengo el importe de la beca 
  execute sp_importe_beca    
          @pi_id_tipo_beca    = @id_tipo_beca,    
          @pi_fecha           = @fecha_char,    
          @po_i_beca          = @i_beca       output,      
          @po_c_error         = @po_c_error   output,      
          @po_d_error         = @po_d_error   output   
 
 
  --insert into sabed_log (fecha,descrip,nom_proc) values (getdate(),'fecha_char>>>>' + @fecha_char,'sp_inserta_det_pago') 
              
  if (@po_c_error <> 0)      
    begin    
 
      --insert into sabed_log (fecha,descrip,nom_proc) values (getdate(),'error 6 Conversion fecha','sp_inserta_det_pago') 
 
      set @po_d_error = 'Error en sp_inserta_det_pago: '+ @po_d_error    
      return    
  end     
             
  --datos a obtener de la ong    
    
  set @d_suc_ctadeb     = replicate('0', (4 - char_length(@d_suc_cuenta))) || @d_suc_cuenta    --N?mero de la sucursal de la cuenta monetaria utilizada    
    
  set @d_tipo_cta_mon   = replicate('0', (3 - char_length(@d_tipo_cuenta))) || @d_tipo_cuenta  --Tipo de cuenta monetaria    
  set @d_nro_cta        = replicate('0', (7 - char_length(@d_nro_cuenta))) || @d_nro_cuenta    --N?mero de cuenta monetaria utilizada para los d?bitos    
  set @d_nro_clien    = convert(varchar,(@c_nro_clien)) 
  set @d_nro_clien    = replicate('0', (8 - char_length(@d_nro_clien))) || @d_nro_clien  --Numero de cliente  
   
  ---------------------------    
    
  --datos a obtener de la tarjeta del alumno     
  set @d_nro_cta_cred   = replicate('0', (10 - char_length(@d_nro_cc))) || @d_nro_cc    --nro de cuenta credito asociada a la tarjeta a recargar    
      
  set @d_nro_tarjeta    = replicate('0', (16 - char_length(@d_nro_tar))) || @d_nro_tar  --n?mero de tarjeta a recargar    
      
  -- calcular el monto de recarga * por 100 (por los decimales) 
  set @d_imp_recarga    = convert(varchar,(@i_beca * @q_becas_a_recargar))  --importe de recarga    
  set @d_imp_recarga    = str_replace(convert(varchar,@d_imp_recarga),'.' ,NULL) 
  set @d_imp_recarga    = substring(@d_imp_recarga,1,char_length(@d_imp_recarga)-2)+','+substring(@d_imp_recarga,char_length(@d_imp_recarga)-1,char_length(@d_imp_recarga)) 
  set @d_imp_recarga    = replicate('0',11-char_length(@d_imp_recarga))||@d_imp_recarga 
  --formateo del dato --------------------------------------------------------  
  --reemplazo el punto es caso de q sea este el digito de decimales  
  --set @d_imp_recarga    = str_replace(convert(varchar,@d_imp_recarga),'.' ,',')  
    
  --obtengo la parte entero y completo con ceros  
  --set @d_imp_rec_ent = substring(@d_imp_recarga,charindex(',',@d_imp_recarga)+1,2)             
  --set @d_imp_rec_ent = replicate('0', (8 - char_length(@d_imp_rec_ent))) || @d_imp_rec_ent  
    
  --obtengo la parte decimal y completo con ceros  
  --set @d_imp_rec_dec = substring(@d_imp_recarga,1,charindex(',',@d_imp_recarga)+1)             
  --set @d_imp_rec_dec = @d_imp_rec_dec || replicate('0', (2 - char_length(@d_imp_rec_dec)))  
    
  --set @d_imp_recarga    = @d_imp_rec_ent + ',' + @d_imp_rec_dec  
  -----------------------------------------------------------------------------  
  
 
 --insert into sabed_log (fecha,descrip,nom_proc) values (getdate(),'Pre insert sart_lotes_det_pago','sp_inserta_det_pago') 
    
  insert into sart_lotes_det_pago (    
          id_lote_pago,      
          id_lote_det_recarga,                            
          d_fe_operacion,    
          d_tip_movi,    
          d_nro_clien,    
          d_suc_ctadeb,    
          d_tipo_cta_mon,    
          d_nro_cta,    
          d_cod_admin,    
          d_nro_cta_cred,    
          d_nro_tarjeta,    
          d_imp_recarga,    
          d_imp_comision,    
          d_fe_recarga,    
          d_cod_recarga,    
          d_ind_extr_efect,                 
          c_usua_alta)    
  values (@pi_id_lote_pago,    
          @pi_id_lote_det_recarga,              
          @d_fe_operacion,    
          @d_tip_movi,    
          @d_nro_clien,    
          @d_suc_ctadeb,    
          @d_tipo_cta_mon,    
          @d_nro_cta,    
          @d_cod_admin,    
          @d_nro_cta_cred,    
          @d_nro_tarjeta,    
          @d_imp_recarga,    
          @d_imp_comision,    
          @d_fe_recarga,    
          @d_cod_recarga,    
          @d_ind_extr_efect,              
          @pi_id_usuario    
          )    
              
  set @po_c_error = @@error        
  if (@po_c_error  <> 0)    
  begin 
 
    --insert into sabed_log (fecha,descrip,nom_proc) values (getdate(),'error 7  insert into sart_lotes_det_pago','sp_inserta_det_pago') 
 
    set @po_d_error =  'Error al insertar detalle de pagos. '    
  	return    
  end    
  --insert into sabed_log (fecha,descrip,nom_proc) values (getdate(),'OK insert sart_lotes_det_pago','sp_inserta_det_pago') 
end 

go 

Grant Execute on dbo.sp_inserta_det_pago to GrpTrpSabed 
go

sp_procxmode 'sp_inserta_det_pago', anymode
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_inserta_det_recarga'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_inserta_det_recarga" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_inserta_det_recarga(     
@pi_id_usuario      numeric(18,0),     
@pi_id_lote         numeric(18,0),     
@pi_l_alu           typ_lista,     
@pi_valida          varchar(1),        
@po_c_error         typ_c_error output,     
@po_d_error         typ_d_error output     
)     
as     
/*     
Objetivo: limpia e inserta los detalles de recargas de tarjetas de los alumnos     
@pi_l_alu es de la forma:      
@id_alumno:@e_alumno:@q_recargas:@obs     
*/     
     
begin     
     
  if @pi_id_usuario is null or  @pi_id_usuario =0    
    begin     
      set @po_c_error = 3    
      set @po_d_error = 'No se recibi? pi_id_usuario'     
      return            
  end     
  if @pi_l_alu is null     
    begin     
      set @po_c_error = 3    
      set @po_d_error = 'No se recibi? pi_l_alu'     
      return            
  end    
  if @pi_id_lote is null or @pi_id_lote =0    
    begin     
      set @po_c_error = 3    
      set @po_d_error = 'No se recibi? pi_id_lote'     
      return            
  end      
     
  declare @f_operacion      datetime,     
          @sep              varchar(1),     
          @subSep           varchar(1),     
          @v_lista          typ_lista,      
          @reg_detalle      typ_lista,     
          @id_alu_tar       numeric(18,0),     
          @e_alumno         varchar(1),     
          @x_observacion    varchar(250),     
          @q_recargas       int,    
          @id_alumno        numeric(18,0),   
          @f_consulta       smalldatetime,   
          @m_error_val        varchar(1),        
          @error_val_mensaje  typ_d_error,   
          @cant               int   
     
  set @po_c_error = 0     
  set @po_d_error = null     
       
  execute sp_separador_registros     
             @po_separador_registro    = @sep        output,     
             @po_separador_campo       = @subSep     output,     
             @po_c_error               = @po_c_error output,     
             @po_d_error               = @po_d_error output       
                  
  if (@po_c_error  <> 0)      
    begin     
      set @po_d_error  = 'Error llamando sp_separador_registros: ' + @po_d_error     
      return       
  end     
     
  select @f_consulta=pr.f_fin_periodo   
    from sact_periodos_recargas pr,sart_lotes_recarga lr   
   where pr.id_periodo_recarga=lr.id_periodo_recarga   
     and lr.id_lote_recarga = @pi_id_lote   
         
  set @po_c_error = @@error,@cant=@@rowcount              
  if (@po_c_error  <> 0)        
    begin           
      set @po_d_error =  'Error al obtener el periodo de recarga'               
      return       
  end           
  If @cant=0         
  begin           
    set @po_d_error =  'No se pudo determinar la fecha de consulta'          
    set @po_c_error = 3        
    return       
  end     
     
  --   
  -- ///////////////////////////////////////   
  --   
         
  delete sart_lotes_det_recarga     
  where id_lote_recarga = @pi_id_lote     
       
  set @po_c_error = @@error     
  if (@po_c_error  <> 0)      
  begin     
      set @po_d_error =  'Error al limpiar detalle de recargas. '     
      return       
  end       
     
  set @v_lista             = @pi_l_alu + @sep     
     
  --parseo la lista     
  while (@v_lista is not null)     
  begin     
     
                       
                  --obtengo un elemento de la lista     
                  set @reg_detalle = substring(@v_lista, 1,charindex(@sep,@v_lista)-1) +  @subSep      
                                             
                  --obtengo el resto de la lista                             
                  set @v_lista = substring(@v_lista,     
                                             charindex(@sep,@v_lista)+1,      
                                             char_length(@v_lista)     
                                             )                              
                      
                  --desarmo el registro de detalle      
                  set @id_alumno     = null    
                  set @id_alu_tar    = null     
                  set @e_alumno      = null     
                  set @q_recargas    = null     
                  set @x_observacion = null     
                       
                  set @id_alumno = convert(numeric,substring(@reg_detalle,1,charindex(@subSep,@reg_detalle)-1))     
                      
                  --    
                  -- Obtengo el identificador de alumno-tarjeta    
                  Select @id_alu_tar = atar.id_alu_tar    
                    from saat_alumnos_tarjetas atar    
                   Where atar.id_alumno = @id_alumno    
                     and atar.f_baja is null    
                      
                  set @po_c_error = @@error
                           
                  if (@po_c_error  <> 0)     
                    begin      
                      set @po_d_error =  'Error intentar obtener la tarjeta del alumno'     
                      return     
                  end     
                     
                  set @reg_detalle    = substring(@reg_detalle,     
                                                      charindex(@subSep,@reg_detalle)+1,      
                                                      char_length(@reg_detalle)     
                                                     )     
     
                  set @e_alumno 	   = substring(@reg_detalle,1,charindex(@subSep,@reg_detalle)-1)     
                     
                  set @reg_detalle    = substring(@reg_detalle,     
                                                      charindex(@subSep,@reg_detalle)+1,      
                                                      char_length(@reg_detalle)     
                                                     )     
     
                  set @q_recargas 	   = convert(numeric,substring(@reg_detalle,1,charindex(@subSep,@reg_detalle)-1))     
                     
                  set @reg_detalle    = substring(@reg_detalle,     
                                                      charindex(@subSep,@reg_detalle)+1,      
                                                      char_length(@reg_detalle)     
                                                     )      
     
     
                  set @x_observacion 	   = substring(@reg_detalle,1,charindex(@subSep,@reg_detalle)-1)     
                     
                  --   
                  -- Controlo la validacion en caso de que el alumno este en SI   
                  if @pi_valida ='S' and @e_alumno='S'   
                    begin   
                      -- obtengo la marca de validaci?n       
                      execute sp_valida_recarga_alu       
                                  @pi_id_alumno         = @id_alumno,       
                                  @pi_f_consulta        = @f_consulta,    
                                  @po_m_error_val       = @m_error_val output,        
                                  @po_error_val_mensaje = @error_val_mensaje output,      
                                  @po_c_error           = @po_c_error output,          
                                  @po_d_error           = @po_d_error output           
                      if (@po_c_error  <> 0)          
                        begin           
                          set @po_d_error =  'Error en sp_valida_recarga_alu: ' +  @po_d_error      
                          return           
                      end    
                      If @m_error_val='S'   
                        begin   
                          set @po_d_error =  'Un alumno seleccionado para recarga posee datos incompletos/incorrectos. Revisar los errores a nivel alumno.'   
                          set @po_c_error = 4   -- manejo de error especial  
                          return    
                      end   
                  end -- validacion   
                     
                                                          
                  insert into sart_lotes_det_recarga (                                                                 
                                id_lote_recarga,     
                                id_alu_tar,         
                                e_alumno,                  
                                x_observacion,     
                                q_becas_a_recargar,     
                                c_usua_alta,    
                                id_alumno)     
                              values (     
                                @pi_id_lote,       
                                @id_alu_tar,                                         
                                @e_alumno, -- SI, NO     
                                @x_observacion,     
                                @q_recargas,     
                                @pi_id_usuario,    
                                @id_alumno    
                                )     
      
                  set @po_c_error = @@error         
                     
                  if (@po_c_error  <> 0)     
                    begin      
                      set @po_d_error =  'Error al insertar detalle de recargas. '     
                      return     
                  end     
  end --while     
      
end -- sp_inserta_det_recarga 
 
go 

Grant Execute on dbo.sp_inserta_det_recarga to GrpTrpSabed 
go

sp_procxmode 'sp_inserta_det_recarga', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_inserta_det_recarga_temp'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_inserta_det_recarga_temp" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_inserta_det_recarga_temp(      
@pi_id_usuario      numeric(18,0),      
@pi_l_alu           typ_lista,          
@pi_id_periodo      numeric(18,0),       
@pi_id_tutor        numeric(18,0),       
@po_c_error         typ_c_error output,      
@po_d_error         typ_d_error output      
)      
as      
/*      
Objetivo: limpia e inserta los detalles de recargas de tarjetas de los alumnos      
@pi_l_alu es de la forma:       
@id_alumno:@e_alumno:@q_recargas:@obs      
*/      
      
begin      
         
      
  declare @f_operacion      datetime,      
          @sep              varchar(1),      
          @subSep           varchar(1),      
          @v_lista          typ_lista,       
          @reg_detalle      typ_lista,      
          @id_alu_tar       numeric(18,0),      
          @e_alumno         varchar(1),      
          @x_observacion    varchar(250),      
          @q_recargas       int,     
          @id_alumno        numeric(18,0),    
          @f_consulta       smalldatetime,    
          @m_error_val        varchar(1),         
          @error_val_mensaje  typ_d_error,    
          @cant               int    
      
  set @po_c_error = 0      
  set @po_d_error = null    
   
  insert into sabed_log (descrip) values (@pi_l_alu ) 
        
  execute sp_separador_registros      
             @po_separador_registro    = @sep        output,      
             @po_separador_campo       = @subSep     output,      
             @po_c_error               = @po_c_error output,      
             @po_d_error               = @po_d_error output        
                   
  if (@po_c_error  <> 0)       
    begin      
      set @po_d_error  = 'Error llamando sp_separador_registros: ' + @po_d_error      
      return        
  end      
       
      
  --    
  -- ///////////////////////////////////////    
  --    
                
        
  set @po_c_error = @@error      
  if (@po_c_error  <> 0)       
  begin      
      set @po_d_error =  'Error al limpiar detalle de recargas. '      
      return        
  end        
      
  set @v_lista             = @pi_l_alu + @sep      
      
  --parseo la lista      
  while (@v_lista is not null)      
  begin      
      
                        
                  --obtengo un elemento de la lista      
                  set @reg_detalle = substring(@v_lista, 1,charindex(@sep,@v_lista)-1) +  @subSep       
                                              
                  --obtengo el resto de la lista                              
                  set @v_lista = substring(@v_lista,      
                                             charindex(@sep,@v_lista)+1,       
                                             char_length(@v_lista)      
                                             )                               
                       
                  --desarmo el registro de detalle       
                  set @id_alumno     = null     
                  set @id_alu_tar    = null      
                  set @e_alumno      = null      
                  set @q_recargas    = null      
                  set @x_observacion = null      
                        
                  set @id_alumno = convert(numeric,substring(@reg_detalle,1,charindex(@subSep,@reg_detalle)-1))      
                       
                  --     
                  -- Obtengo el identificador de alumno-tarjeta     
                  Select @id_alu_tar = atar.id_alu_tar     
                    from saat_alumnos_tarjetas atar     
                   Where atar.id_alumno = @id_alumno     
                     and atar.f_baja is null     
                       
                  set @po_c_error = @@error 
                            
                  if (@po_c_error  <> 0)      
                    begin       
                      set @po_d_error =  'Error intentar obtener la tarjeta del alumno'      
                      return      
                  end      
                      
                  set @reg_detalle    = substring(@reg_detalle,      
                                                      charindex(@subSep,@reg_detalle)+1,       
                                                      char_length(@reg_detalle)      
                                                     )      
      
                  set @e_alumno 	   = substring(@reg_detalle,1,charindex(@subSep,@reg_detalle)-1)      
                      
                  set @reg_detalle    = substring(@reg_detalle,      
                                                      charindex(@subSep,@reg_detalle)+1,       
                                                      char_length(@reg_detalle)      
                                                     )      
      
                  set @q_recargas 	   = convert(numeric,substring(@reg_detalle,1,charindex(@subSep,@reg_detalle)-1))      
                      
                  set @reg_detalle    = substring(@reg_detalle,      
                                                      charindex(@subSep,@reg_detalle)+1,       
                                                      char_length(@reg_detalle)      
                                                     )       
      
      
                  set @x_observacion 	   = substring(@reg_detalle,1,charindex(@subSep,@reg_detalle)-1)      
                  
				  if exists (select 1 from temp_lotes_det_recarga where id_alu_tar = @id_alu_tar
															   and   id_alumno  = @id_alumno) 
				  
					  begin 
						  update temp_lotes_det_recarga
						  set id_lote_recarga  = 0,         
							  e_alumno           = @e_alumno,                   
							  x_observacion      = @x_observacion,      
							  q_becas_a_recargar = @q_recargas,     
                              id_tutor           = @pi_id_tutor,     
                              id_periodo         = @pi_id_periodo,     
							  c_usua_alta        = @pi_id_usuario     
						   where id_alu_tar = @id_alu_tar
						   and   id_alumno  = @id_alumno  
					  end
				  else
					begin									
					  insert into temp_lotes_det_recarga (                                                                  
									 id_lote_recarga      
									,id_alu_tar  
                                    ,id_periodo       
									,e_alumno                   
									,x_observacion     
									,q_becas_a_recargar
									,c_usua_alta   
									,id_alumno       
                                    ,id_tutor
                                    )      
								  values (      
									 0        
									,@id_alu_tar
                                    ,@pi_id_periodo
									,@e_alumno -- SI, NO      
									,@x_observacion
									,@q_recargas    
									,@pi_id_usuario
                                    ,@id_alumno    
                                    ,@pi_id_tutor 
									)      
					end
       
                  set @po_c_error = @@error          
                      
                  if (@po_c_error  <> 0)      
                    begin       
                      set @po_d_error =  'Error al insertar detalle de recargas. '      
                      return      
                  end      
  end --while      
       
end
 
go 

Grant Execute on dbo.sp_inserta_det_recarga_temp to GrpTrpSabed 
go

sp_procxmode 'sp_inserta_det_recarga_temp', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_inserta_eval_acad'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_inserta_eval_acad" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_inserta_eval_acad( 
@pi_id_usuario      numeric(18,0), 
@pi_id_eval_academ  numeric(18,0), 
@pi_id_alumno       numeric(18,0), 
@pi_f_eval_academ   varchar(20), 
@pi_id_periodo      numeric(18,0),  
@pi_e_registro      char(1), 
@pi_l_preg_rta      typ_lista,  
@po_id_eval_academ  numeric(18,0) output,         
@po_c_error         typ_c_error   output, 
@po_d_error         typ_d_error   output 
) 
as 
/*	 
Objetivo: inserta preguntas y respuestas de cada alumno 
          para las evaluaciones acad?micas  
*/ 
 
begin 
 
  if (@pi_id_usuario is null  or @pi_id_usuario = 0)
  begin 
      set @po_c_error = 3 
      set @po_d_error = 'No se recibi? pi_id_usuario' 
      return        
  end 
   
  if (@pi_id_alumno is null or @pi_id_alumno = 0)
  begin 
      set @po_c_error = 3 
      set @po_d_error = 'No se recibi? pi_id_alumno' 
      return        
  end   
   
  if (@pi_f_eval_academ is null)
  begin 
      set @po_c_error = 3 
      set @po_d_error = 'No se recibi? pi_f_eval_academ' 
      return        
  end   
        
  if (@pi_id_periodo is null  or @pi_id_periodo = 0)
  begin 
      set @po_c_error = 3 
      set @po_d_error = 'No se recibi? pi_n_periodo' 
      return        
  end   
    
  declare @fecha            datetime, 
          @sep              varchar(1), 
          @subSep           varchar(1), 
          @id_eval_academ   numeric(18,0), 
          @v_lista          typ_lista,  
          @reg_detalle      typ_lista, 
          @id_pregunta      numeric(18,0), 
          @id_respuesta     numeric(18,0), 
          @d_valor_rta      typ_lista,
          @estado           varchar(1)
 
  set @po_c_error = 0 
  set @po_d_error = null  
 
 -- 
 -- Verificamos que el estado del periodo se pueda modificar 
 execute sp_est_periodo_eval_acad 
            @pi_id_periodo = @pi_id_periodo,  
            @po_estado     = @estado   output,  
            @po_c_error    = @po_c_error output,  
            @po_d_error    = @po_d_error output    
 if (@po_c_error  <> 0)  
  begin 
	  set @po_d_error = 'Error llamando a sp_est_periodo_eval_acad : ' + @po_d_error	
      return      
  end 
 
 If @estado <> 'A'
  begin 
    set @po_d_error =  'El periodo : ' + convert(varchar,@pi_id_periodo) + ' no se puede utilizar. ' 
    set @po_c_error = 2 
    return 
  end 
   
  begin tran inserta  
 
  --convierto el varchar de entrada a date  
  execute sp_convierte_char_en_fecha @pi_fecha_char     = @pi_f_eval_academ, 
                                     @po_fecha_datetime = @fecha      output, 
                                     @po_c_error        = @po_c_error output, 
                                     @po_d_error        = @po_d_error output 
                            
  if (@po_c_error  <> 0)  
  begin 
      rollback tran inserta 
	  set @po_d_error = 'Error llamando a sp_convierte_char_en_fecha : ' + @po_d_error  
      return   
  end 
   
  /*insert into sabed_log(descrip)     
  values ('fecha char: ' + @pi_f_eval_academ)     
  insert into sabed_log(fecha,descrip)     
  values (@fecha, 'fecha date')   */  
   
  --controlo q la fecha q me pasan est? dentro del periodo abierto 
  --controlo que el periodo que se quiere cargar est? abierto  
  /*if not exists (  
     select id_periodo  
       from sact_periodos_eval_acad pea 
      where @fecha between f_inicio_periodo and f_fin_periodo 
        and pea.id_periodo  = @pi_id_periodo 
            )   
  begin 
          rollback tran inserta  
          set @po_d_error =  'La fecha ingresada no corresponde al periodo abierto: ' + convert(varchar,@pi_id_periodo) 
          set @po_c_error = 2 
          return 
  end       */
 
  execute sp_separador_registros 
             @po_separador_registro    = @sep        output, 
             @po_separador_campo       = @subSep     output, 
             @po_c_error               = @po_c_error output, 
             @po_d_error               = @po_d_error output   
              
  if (@po_c_error  <> 0) 
    begin 
      rollback tran inserta  
	  set @po_d_error = 'Error llamando a sp_separador_registros : ' + @po_d_error  	  
      return   
  end  
 
 
  -- si el id de situacion academica llega en nulo, realizo el insert 
  --sino modifico seg?n ese id y actualizo el detalle (se limpiar? y se vuelve a insertar) 
  if @pi_id_eval_academ = 0 or @pi_id_eval_academ is null 
  begin 
          insert into saat_alumnos_eval_academ ( 
                      id_alumno,            
                      f_eval_academ,        
                      id_periodo,           
                      e_registro, 
                      c_usua_alta) 
              values (@pi_id_alumno, 
                      @fecha, 
                      @pi_id_periodo,           
                      @pi_e_registro, 
                      @pi_id_usuario) 
                      
          set @po_c_error = @@error, @id_eval_academ = @@identity 
           
          if @po_c_error <> 0            
          begin 
              rollback tran inserta 
              set @po_d_error = 'Error al insertar situacion academica de alumnos. ' 
              return        
          end 
  end           
  else 
  begin  
          update saat_alumnos_eval_academ 
             set e_registro = @pi_e_registro, 
                 c_usua_actuac = @pi_id_usuario, 
                 f_actuac = getDate() 
          where id_eval_academ = @pi_id_eval_academ 
           
          set @po_c_error = @@error 
          if @po_c_error <> 0            
          begin 
              rollback tran inserta 
              set @po_d_error = 'Error al modificar situacion academica de alumnos. ' 
              return        
          end 
          set @id_eval_academ = @pi_id_eval_academ 
   
  end 
   
  --antes de insertar el detalle limpio la lista 
  delete from saat_detalle_eval_academ 
  where id_eval_academ = @pi_id_eval_academ 
   
  set @po_c_error = @@error      
  if @po_c_error <> 0            
  begin 
      rollback tran inserta 
      set @po_d_error = 'Error al limpiar situacion academica de alumnos. ' 
      return        
  end 
 
  if @pi_l_preg_rta is not null 
  begin  
   
  set @v_lista = @pi_l_preg_rta + @sep 
 
  --parseo la lista 
  while (@v_lista is not null) 
  begin 
                   
                  --obtengo un elemento de la lista 
                  set @reg_detalle = substring(@v_lista, 1,charindex(@sep,@v_lista)-1) +  @subSep  
                                         
                  --obtengo el resto de la lista                         
                  set @v_lista = substring(@v_lista, 
                                             charindex(@sep,@v_lista)+1,  
                                             char_length(@v_lista) 
                                             )                          
                  
                  --desarmo el registro de detalle  
                  set @id_pregunta = null 
                  set @id_respuesta = null 
                  set @d_valor_rta = null 
                   
                  set @id_pregunta 	   = convert(numeric,substring(@reg_detalle,1,charindex(@subSep,@reg_detalle)-1)) 
                 
                  set @reg_detalle    = substring(@reg_detalle, 
                                                      charindex(@subSep,@reg_detalle)+1,  
                                                      char_length(@reg_detalle) 
                                                     ) 
                  
                   set @id_respuesta 	   = convert(numeric,substring(@reg_detalle,1,charindex(@subSep,@reg_detalle)-1)) 
                 
                  set @reg_detalle    = substring(@reg_detalle, 
                                                      charindex(@subSep,@reg_detalle)+1,  
                                                      char_length(@reg_detalle) 
                                                     ) 
                 
                 
                  set @d_valor_rta 	   = substring(@reg_detalle,1,charindex(@subSep,@reg_detalle)-1) 
                 
                  set @reg_detalle    = substring(@reg_detalle, 
                                                      charindex(@subSep,@reg_detalle)+1,  
                                                      char_length(@reg_detalle) 
                                                     ) 
                  if    (@id_respuesta <> 0) or (@d_valor_rta is not null) --(char_length(d_valor_rta) > 0 )  
                  begin  
                          insert into saat_detalle_eval_academ ( 
                                  id_eval_academ,       
                                  --id_alumno,              
                                  --f_eval_academ, 
                                  --id_periodo,           
                                  id_pregunta, 
                                  id_respuesta, 
                                  d_valor_rta,         --se completa si el id_respuesta es texto libre 
                                  c_usua_alta) 
                          values (@id_eval_academ,       
                                  --@pi_id_alumno,              
                                  --@fecha, 
                                  --@pi_id_periodo,   
                                  @id_pregunta, 
                                  @id_respuesta, 
                                  @d_valor_rta, 
                                  @pi_id_usuario) 
                         
                          set @po_c_error = @@error     
                         
                          if (@po_c_error  <> 0) 
                          begin  
                              rollback tran inserta 
                              set @po_d_error =  'Error al insertar evaluaci?n acad?mica. ' 
                              return 
                          end 
                  end  
  end --while 
  end 
  commit tran inserta 
   
  set @po_id_eval_academ = @id_eval_academ 
   
end --sp_inserta_eval_acad
 
go 

Grant Execute on dbo.sp_inserta_eval_acad to GrpTrpSabed 
go

sp_procxmode 'sp_inserta_eval_acad', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_inserta_fundacion'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_inserta_fundacion" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_inserta_fundacion ( 
@pi_d_cuit          varchar(40),    
@pi_d_mail          varchar(40),    
@pi_d_calle			varchar(40),    
@pi_d_nro			varchar(40),    
@pi_d_piso			varchar(40),    
@pi_d_depto			varchar(40),    
@pi_d_localidad     varchar(40),    
@pi_c_provincia     numeric(18,0),  
@pi_c_usua_alta     numeric(18,0), 
@po_id_fundacion    numeric(18,0) output, 
@po_c_error      		typ_c_error   output, 
@po_d_error      		typ_d_error   output 
) 
as 
------------------------------------------------------------------- 
--Objetivo: Alta de la FUNDACION
--Par?metros de entrada: 
--	ID_INSTITUCION      
--	Q_BECAS                
--	ID_COORDINADOR	 
--	D_NOMBRE_ONG        
--	E_REGISTRO               
--	C_USUA_ALTA                    
--	C_TIPO_ONG 
--Par?metros de salida: po_id_fundacion, po_c_error y po_d_error 
------------------------------------------------------------------- 
 
begin 

  declare @d_nombre_ong    varchar(40)
 
  set @po_c_error = 0 
  set @po_d_error = null 
  set @d_nombre_ong = 'FUNDACION DEL BANCO FRANCES' 
 
  insert into saft_ongs  (d_nombre_ong,   
                          d_cuit, d_mail, 
                          d_calle, d_nro, 
                          d_piso, d_depto, 
                          d_localidad, c_provincia,     
                          e_registro, m_fundacion,
                          c_usua_alta
                          )  
                  values (@d_nombre_ong, 
                          @pi_d_cuit, @pi_d_mail, 
                          @pi_d_calle, @pi_d_nro, 
                          @pi_d_piso, @pi_d_depto, 
                          @pi_d_localidad, @pi_c_provincia,  
                          'D', 'S', 
                          @pi_c_usua_alta 
                          ) 
   
  set @po_c_error = @@error    
  if (@po_c_error  <> 0)
  begin 
      set @po_d_error =   convert(varchar,@po_c_error) 
                         + ' - Error al insertar en saft_ongs la fundacion. '
      return      
  end  
 
  set @po_id_fundacion = @@identity 
   
end --sp_inserta_fundacion
 
go 

Grant Execute on dbo.sp_inserta_fundacion to GrpTrpSabed 
go

sp_procxmode 'sp_inserta_fundacion', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_inserta_grupo_fliar'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_inserta_grupo_fliar" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_inserta_grupo_fliar( 
@pi_id_usuario      numeric(18,0), 
@pi_id_alumno       numeric(18,0), 
@pi_l_fliares       typ_lista, 
@pi_e_registro      char(1),  
@po_c_error         typ_c_error output, 
@po_d_error         typ_d_error output 
) 
as 
/* 
Objetivo: inserta el grupo familiar del alumno; al menos debe haber uno  
 id_per_rel:c_parentesco:m_tit_tarjeta 
*/ 
 
begin 
 
  if (@pi_id_usuario is null or @pi_id_usuario = 0) 
  begin 
      set @po_c_error = 3 
      set @po_d_error = 'No se recibi? pi_id_usuario' 
      return        
  end 
   
  if char_length(isnull(@pi_l_fliares,' ')) <= 1 and (@pi_e_registro = 'D')
  begin 
      set @po_c_error = 2 
      set @po_d_error = 'No indicaron integrantes del grupo familiar' 
      return        
  end 

  if char_length(@pi_l_fliares) > 1
  begin 
       
        declare  
            @cant_titu        integer, 
            @sep              varchar(1), 
            @subSep           varchar(1), 
            @v_lista          typ_lista, 
            @v_sublista       typ_lista, 
            @id_per_rel       numeric(18,0), 
            @id_persona       numeric(18,0), -- del alumno
            @c_parentesco     numeric(18,0), 
            @m_tit_tarjeta    varchar(1),
            @ape_nom_fliar    varchar(82)
       
        set @po_c_error = 0 
        set @po_d_error = null 
        set @cant_titu = 0 
       
        --
        -- Obtengo el id de persona del alumno
        select @id_persona = id_persona 
          from saat_alumnos 
         where id_alumno = @pi_id_alumno 
         
        execute sp_separador_registros 
                   @po_separador_registro    = @sep        output, 
                   @po_separador_campo       = @subSep     output, 
                   @po_c_error               = @po_c_error output, 
                   @po_d_error               = @po_d_error output   
                    
        if (@po_c_error  <> 0) 
          begin 
      	  set @po_d_error = 'Error llamando a sp_separador_registros : ' + @po_d_error 
            return     
        end   
         
        set @v_lista             = @pi_l_fliares + @sep 
       
        --parseo la lista 
        while (@v_lista is not null) 
        begin 
       
                 --limpio las variables  
                  set @id_per_rel = null 
                  set @c_parentesco = null 
                  set @m_tit_tarjeta = null 
         
                  --obtengo un elemento de la lista 
                  set @v_sublista = substring(@v_lista, 1,charindex(@sep,@v_lista)-1)+ @subSep   
                               
                  --obtengo el resto de la lista                         
                  set @v_lista = substring(@v_lista, 
                                   charindex(@sep,@v_lista)+1,  
                                   char_length(@v_lista) 
                                   )                          
                   
                  --separo los subelementos             
       
                  set @id_per_rel 	 = convert(numeric,substring(@v_sublista,1,charindex(@subSep,@v_sublista)-1)) 
       
                  set @v_sublista    = substring(@v_sublista, 
                                                 charindex(@subSep,@v_sublista)+1,  
                                                 char_length(@v_sublista) )  
       
                  set @c_parentesco  = convert(numeric,substring(@v_sublista,1,charindex(@subSep,@v_sublista)-1)) 
       
                  set @v_sublista    = substring(@v_sublista, 
                                                 charindex(@subSep,@v_sublista)+1,  
                                                 char_length(@v_sublista) )  
       
                  set @m_tit_tarjeta = substring(@v_sublista,1,charindex(@subSep,@v_sublista)-1) 
       
                  set @v_sublista    = substring(@v_sublista, 
                                                 charindex(@subSep,@v_sublista)+1,  
                                                 char_length(@v_sublista) )  
                  
                  --
                  -- Verifico que el familiar indique el parentesco
                  if     (@m_tit_tarjeta = 'N' or @m_tit_tarjeta is null) 
                     and (@c_parentesco is null or @c_parentesco=0)
                  begin
                    set @po_c_error = 2
                    set @po_d_error = 'No se informo el parentesco de uno de los familiares'                   
                    return
                  end

                  --
                  -- verifico que el titular de la tarjeta en caso de no ser el alumno
                  -- tenga cargado el parentesco
                  if    @id_persona <> @id_per_rel 
                    and @id_per_rel <> 0 
                    and (@c_parentesco is null or @c_parentesco=0)
                  begin
                    set @po_c_error = 2
                    set @po_d_error = 'No se informo el parentesco del familiar titular de la tarjeta'                   
                    return
                  end

  
                  if @m_tit_tarjeta = 'S'  
                     set @cant_titu = @cant_titu + 1 
                   
                  if (@cant_titu > 1) and (@pi_e_registro = 'D')
                    begin 
                      set @po_d_error = 'Se marc? m?s de un titular. ' 
                      set @po_c_error = 2 
                      return 
                  end             
                  else 
                    begin  
                           
                        insert into saat_alumnos_parentesco(id_alumno, 
                                                            id_persona_rel, 
                                                            m_tit_tarjeta,  
                                                            c_parentesco,  
                                                            c_usua_alta ) 
                                              values (@pi_id_alumno, 
                                                      @id_per_rel, 
                                                      isnull(@m_tit_tarjeta,'N'), 
                                                      @c_parentesco, 
                                                      @pi_id_usuario 
                                                     ) 
                        set @po_c_error = @@error     
                        if (@po_c_error  <> 0) 
                        begin  
                              set @po_d_error =  convert(varchar,@po_c_error)  
                                     + ' - Error al insertar familiares del alumno. ' 
                        end 
                  end 
        end --while     
       
        if (@cant_titu = 0) and (@pi_e_registro = 'D')
        begin 
            set @po_d_error = 'Debe indicar al menos un titular de tarjeta o responsable a cargo. ' 
            set @po_c_error = 1 
            return 
        end 
        
        --
        -- Controlamos que el alumno tenga al menos un familiar cargado
        if not exists (select id_persona_rel 
      		from saat_alumnos_parentesco 
      		where id_alumno = @pi_id_alumno 
        		  and id_persona_rel <> @id_persona 
                      ) and (@pi_e_registro = 'D')
        begin 
            set @po_d_error = 'Debe indicar al menos un integrante del grupo familiar' 
            set @po_c_error = 2 
            return 
        end                 

        --
        -- Controlamos que los familiares cargados; se encuentren en estado DEFINITIVO
        if exists (select ap.id_persona_rel 
      		         from saat_alumnos_parentesco ap, sagt_personas p
      		        where ap.id_alumno = @pi_id_alumno 
        		  and ap.id_persona_rel = p.id_persona
        		  and p.e_registro = 'A'
                      ) and (@pi_e_registro = 'D')
        begin 
        
            select @ape_nom_fliar = p.d_apellido + ', ' + d_nombre
      		         from saat_alumnos_parentesco ap, sagt_personas p
      		        where ap.id_alumno = @pi_id_alumno 
        		  and ap.id_persona_rel = p.id_persona
        		  and p.e_registro = 'A'
         
            set @po_d_error = 'El familiar ' + @ape_nom_fliar + ' no se encuentra cargado en estado Definitivo. ' 
            set @po_c_error = 2 
            return 
        end                 

                           
  end  
end --sp_inserta_grupo_fliar
 
go 

Grant Execute on dbo.sp_inserta_grupo_fliar to GrpTrpSabed 
go

sp_procxmode 'sp_inserta_grupo_fliar', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_inserta_log'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_inserta_log" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_inserta_log (@pi_desc varchar(500))
as
begin

  insert into sabed_log(descrip) values (@pi_desc)

end --sp_inserta_log
 
go 

Grant Execute on dbo.sp_inserta_log to GrpTrpSabed 
go

sp_procxmode 'sp_inserta_log', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_inserta_mensaje'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_inserta_mensaje" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_inserta_mensaje( 
@pi_id_usuario       numeric(18,0), 
@pi_id_origen        numeric(18,0), 
@pi_id_usuario_dest  numeric(18,0), 
@pi_id_perfil_dest   numeric(18,0), 
@pi_x_cuerpo_mensaje varchar(250), 
@pi_f_envio          smalldatetime, 
@po_c_error          typ_c_error     output, 
@po_d_error          typ_d_error     output 
) 
------------------------------------------------------------------------------ 
--Objetivo: inserta un mensaje dirigido a un perfil en particular 
--Par?metros de entrada: -- 
--Par?metros de salida: po_c_valor: identificador de parametros 
--                      po_c_error y po_d_error 
------------------------------------------------------------------------------ 
as 
 
begin 
  if (@pi_id_usuario is null or @pi_id_usuario = 0)  
    begin  
      set @po_c_error = 3
      set @po_d_error = 'No se recibi? usuario '  
      return         
  end  
  
  if (@pi_id_origen is null or @pi_id_origen = 0)   
    begin  
      set @po_c_error = 3
      set @po_d_error = 'No se recibi? el origen del mensaje '  
      return         
  end  
  
  if (@pi_f_envio is null)  
  begin  
      set @po_c_error =3
      set @po_d_error = 'No se recibi? fecha del mensaje'  
      return         
  end  
 
  if (@pi_id_usuario_dest is null and @pi_id_perfil_dest is null)
  begin  
      set @po_c_error = 3
      set @po_d_error = 'No se recibi? destinatario del mensaje'  
      return         
  end  
   
  declare  
         @id_aviso        numeric(18,0), 
         @c_tipo_aviso    numeric(18,0), 
         @c_7             integer 
   
  set @po_c_error = 0 
  set @po_d_error = null 
 
  --procedure q retorna los codigos del tipo de aviso MENSAJE  
  execute sp_obtiene_cod_mensaje @po_id_parametro  = @c_tipo_aviso output,  
                                 @po_c_error       = @po_c_error output,  
                                 @po_d_error       = @po_d_error output  
                                 
    if (@po_c_error  <> 0)  
    begin  
	  set @po_d_error = 'Error llamando a sp_obtiene_cod_mensaje : ' + @po_d_error
      return         
    end 
   
  --procedure q retorna la cantidad de d?as  
  execute sp_obtiene_dias_vig_tarea @po_c_valor = @c_7 output,  
                                    @po_c_error = @po_c_error output,  
                                    @po_d_error = @po_d_error output 
                                 
    if (@po_c_error  <> 0)  
    begin  
	  set @po_d_error = 'Error llamando a sp_obtiene_dias_vig_tarea : ' + @po_d_error	
      return         
    end   
   
  insert into saft_avisos  
              (id_origen,                  
               c_tipo_aviso, 		           
               x_cuerpo_mensaje, 
               f_envio, 
               f_vigencia, 
               c_usua_alta 
               )  
       values  ( 
               @pi_id_origen,                  
               @c_tipo_aviso, 		           
               @pi_x_cuerpo_mensaje,   
               convert(datetime,@pi_f_envio,111),  --f_envio  
               dateadd(day,@c_7,convert(datetime,@pi_f_envio,111)), --f_vigencia   
               @pi_id_usuario 
               ) 
 
  set @po_c_error = @@error,    
      @id_aviso = @@identity --recupero el id_aviso insertado por la columna identity                   
 
  if (@po_c_error  <> 0) 
    begin  
      set @po_d_error =  convert(varchar,@po_c_error)  
                         + ' - Error al insertar mensaje ' 
  end 
   
  if @pi_id_usuario_dest is not null 
  begin  
          insert into saft_avisos_destinatarios (            	  
                       id_aviso,  
                       id_usuario,  
                       c_usua_alta  
                       )   
               values (  
                       @id_aviso,  
                       @pi_id_usuario_dest,  
                       @pi_id_usuario  
                        )  
                          
          set @po_c_error = @@error      
  end  
   
  if @pi_id_perfil_dest is not null 
  begin  
          insert into saft_avisos_destinatarios (            	  
                       id_aviso,  
                       id_perfil,  
                       c_usua_alta  
                       )   
               values (  
                       @id_aviso,  
                       @pi_id_perfil_dest, 
                       @pi_id_usuario  
                        )  
                          
          set @po_c_error = @@error      
  end  
 
  if (@po_c_error  <> 0)  
  begin   
      set @po_d_error =  convert(varchar,@po_c_error)   
                         + ' - Error al insertar destinatario del mensaje. '   
      return  
  end    
 
end -- sp_inserta_mensaje
 
go 

Grant Execute on dbo.sp_inserta_mensaje to GrpTrpSabed 
go

sp_procxmode 'sp_inserta_mensaje', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_inserta_menu'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_inserta_menu" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_inserta_menu (
@d_menu      	varchar(40),   
@x_url_menu  	varchar(250),   
@id_padre    	numeric(18,0),
@n_orden     	numeric(7,0),
@pi_c_usua_alta numeric(18,0),
@po_c_error  	typ_c_error output,
@po_d_error  	typ_d_error output
)
as
--------------------------------------------	
-----------------------
--Objetivo: insertar una nueva entrada de menu
--Par?metros de entrada: No posee
--Par?metros de salida: curso con los valores: 
--po_c_error y po_d_error
-------------------------------------------------------------------

begin
 	
  if (@d_menu  is null)
    begin
      set @po_c_error = 3
      set @po_d_error = 'No se recibio id de menu'
      return       
  end

  if (@x_url_menu  is null)
    begin
      set @po_c_error = 3
      set @po_d_error = 'No se recibi? url del menu'
      --raiserror @po_c_error @po_d_error
      return       
  end

  if (@id_padre  is null or @id_padre = 0)
    begin
      set @po_c_error = 3
      set @po_d_error = 'No se recibi? id padre del menu'
      --raiserror @po_c_error @po_d_error
      return       
  end

  if (@n_orden  is null or @n_orden = 0)
    begin
      set @po_c_error = 3
      set @po_d_error = 'No se recibi? numero de orden de menu'
      --raiserror @po_c_error @po_d_error
      return       
  end


  if (@pi_c_usua_alta  is null or @pi_c_usua_alta = 0)
    begin
      set @po_c_error = 3
      set @po_d_error = 'No se recibi? numero de orden de menu'
      --raiserror @po_c_error @po_d_error
      return       
  end
  
  
  set @po_c_error = 0
  set @po_d_error = null

  insert into sast_menu  (d_menu, 
                              x_url_menu,
                              id_padre,
                              n_orden,
                              c_usua_alta
                              ) 
  values (@d_menu, 
          @x_url_menu,
          @id_padre,
          @n_orden,
          @pi_c_usua_alta
          )
  
  set @po_c_error = @@error    

  if (@po_c_error  <> 0)
  begin 
      set @po_d_error =  convert(varchar,@po_c_error) 
                         + ' - Error al insertar men?. '
      return
  end 
  
end --sp_inserta_menu
 
go 

Grant Execute on dbo.sp_inserta_menu to GrpTrpSabed 
go

sp_procxmode 'sp_inserta_menu', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_inserta_ong'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_inserta_ong" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_inserta_ong (   
@pi_d_cuit          varchar(40),     
@pi_d_mail          varchar(40),     
@pi_d_calle	    	varchar(40),     
@pi_d_nro	    	varchar(40),     
@pi_d_piso	    	varchar(40),     
@pi_d_depto	    	varchar(40),     
@pi_d_localidad     varchar(40),     
@pi_c_provincia     numeric(18,0),   
@pi_e_registro      char(1),        
@pi_c_usua_alta     numeric(18,0),  
@pi_q_becas         numeric(7,0),  
@pi_d_nombre_ong    varchar(40),  
@pi_c_tipo_ong      numeric(18,0),  
@pi_d_suc_cuenta    varchar(4)    ,  
@pi_d_tipo_cuenta   varchar(3)    ,  
@pi_d_nro_cuenta    varchar(7)    ,  
@pi_c_nro_cliente   numeric(8,0)  ,
@po_id_ong          numeric(18,0) output,  
@po_c_error      	typ_c_error   output,  
@po_d_error      	typ_d_error   output  
)  
as  
-------------------------------------------   
------------------------  
--Objetivo: Alta de ONG.   
--Par?metros de entrada:  
--	ID_INSTITUCION       
--	Q_BECAS                 
--	ID_COORDINADOR	  
--	D_NOMBRE_ONG         
--	E_REGISTRO                
--	C_USUA_ALTA                     
--	C_TIPO_ONG  
--Par?metros de salida: po_id_ong, po_c_error y po_d_error  
-------------------------------------------------------------------  
  
begin  
 
  declare @dummy numeric(18,0) 
   
  set @dummy = null 
  set @po_c_error = 0 
  set @po_d_error = null 
  
  insert into saft_ongs  (q_becas, d_nombre_ong,    
                          d_cuit, d_mail,  
                          d_calle, d_nro,  
                          d_piso, d_depto,  
                          d_localidad,  
                          c_provincia,      
                          e_registro,  
                          c_usua_alta,  
                          c_tipo_ong, 
                          d_suc_cuenta,  
						  d_tipo_cuenta   ,  
						  d_nro_cuenta    ,
						  c_nro_cliente
                          )   
                  values (@pi_q_becas, upper(@pi_d_nombre_ong),  
                          @pi_d_cuit, @pi_d_mail,  
                          @pi_d_calle, @pi_d_nro,  
                          @pi_d_piso, @pi_d_depto,  
                          @pi_d_localidad,  
                          case when @pi_c_provincia = 0 then @dummy else @pi_c_provincia end,   
                          @pi_e_registro,  
                          @pi_c_usua_alta,  
                          @pi_c_tipo_ong,                           
                          @pi_d_suc_cuenta,  
						  @pi_d_tipo_cuenta,  
						  @pi_d_nro_cuenta,
						  @pi_c_nro_cliente
                          )  
    
  set @po_c_error = @@error     
  if (@po_c_error  <> 0) 
  begin  
      set @po_d_error =   convert(varchar,@po_c_error)  
                         + ' - Error al insertar en saft_ongs' 
      return       
  end   
  
  set @po_id_ong = @@identity  
    
end --sp_inserta_ong
 
go 

Grant Execute on dbo.sp_inserta_ong to GrpTrpSabed 
go

sp_procxmode 'sp_inserta_ong', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_inserta_param_tabla'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_inserta_param_tabla" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_inserta_param_tabla ( 
@pi_d_valor      varchar(60), 
@pi_id_usuario   numeric(18,0), 
@po_c_error      typ_c_error output, 
@po_d_error      typ_d_error output 
) 
as 
------------------------------------------------------------------- 
--Objetivo: inserta el codigo y descripcion de la tabla 
--Par?metros de entrada: No posee 
--Par?metros de salida:  
--po_c_error y po_d_error 
------------------------------------------------------------------- 
 
begin 
   
  if (@pi_d_valor  is null) 
    begin 
      set @po_c_error = 3 
      set @po_d_error = 'No se recibio dscripcion del codigo' 
      return        
  end 
   
  if (@pi_id_usuario is null or @pi_id_usuario = 0) 
    begin 
      set @po_c_error = 3 
      set @po_d_error = 'No se recibi? usuario. ' 
      return 
  end   
   
  set @po_c_error = 0 
  set @po_d_error = null 
 
  insert into sapt_param_tablas  (d_valor, c_usua_alta)  
  values (@pi_d_valor, @pi_id_usuario) 
   
  set @po_c_error = @@error     
  if (@po_c_error  <> 0) 
    begin     
      set @po_d_error = 'Error al obtener tablas de parametros' 
      return 
    end 
end --sp_inserta_param_tabla 
 
go 

Grant Execute on dbo.sp_inserta_param_tabla to GrpTrpSabed 
go

sp_procxmode 'sp_inserta_param_tabla', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_inserta_parametro'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_inserta_parametro" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_inserta_parametro ( 
@pi_c_usua_alta  numeric(18,0), 
@pi_id_tabla     numeric(18,0), 
@pi_d_valor      varchar(40), 
@po_c_error      typ_c_error output, 
@po_d_error      typ_d_error output 
) 
as 
------------------------------------------------------------------- 
--Objetivo: Alta de valores de par?metros (no de tipos),  
 --est?n asociados a un tipo. 
--Par?metros de entrada:  USUARIO_ID  
--                        ID_TABLA    
--                        COD_PARAM   
--                        DES_PARAM   
--Par?metros de salida: po_c_error y po_d_error 
------------------------------------------------------------------- 
 
begin 
 
  if (@pi_c_usua_alta  is null or @pi_c_usua_alta = 0) 
    begin 
      set @po_c_error = 3 
      set @po_d_error = 'No se recibio usuario' 
      return        
  end 
 
  if (@pi_id_tabla  is null or @pi_id_tabla = 0)  
    begin 
      set @po_c_error = 3 
      set @po_d_error = 'No se recibio id_tabla' 
      return        
  end 
   
  if (@pi_d_valor is null) 
    begin 
      set @po_c_error = 2 
      set @po_d_error = 'No se recibio descripcion del par?metro' 
      return        
  end 
   
  set @po_c_error = 0 
  set @po_d_error = null 
 
  insert into sapt_parametros  (id_tabla, d_valor, c_usua_alta)  
  values (@pi_id_tabla, @pi_d_valor, @pi_c_usua_alta) 
   
  set @po_c_error = @@error     
  if (@po_c_error  <> 0) 
    begin  
      set @po_d_error =  convert(varchar,@po_c_error)  
                         + ' - Error en sp_inserta_parametro . ' 
  end 
 
end --sp_inserta_parametro 
 
go 

Grant Execute on dbo.sp_inserta_parametro to GrpTrpSabed 
go

sp_procxmode 'sp_inserta_parametro', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_inserta_persona'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_inserta_persona" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_inserta_persona(  
@pi_id_usuario          numeric(18,0),  
@pi_c_tpo_doc           numeric(18,0),     
@pi_nro_doc             numeric(12,0),  
@pi_cuil                varchar(40),  
@pi_apellido            varchar(40),  
@pi_nombre              varchar(40),  
@pi_f_nac               varchar(19),  
@pi_c_nacionalidad      numeric(18,0),    
@pi_c_ocupacion         numeric(18,0),    
@pi_c_estado_civil      numeric(18,0),     
@pi_l_telefonos         typ_lista,  
@pi_mail                varchar(40),  
@pi_c_provincia         numeric(18,0),    
@pi_localidad           varchar(40),  
@pi_calle               varchar(40),  
@pi_nro                 varchar(40),  
@pi_piso                varchar(40),  
@pi_depto               varchar(40),  
@pi_c_sexo              numeric(18,0),    
@pi_e_reg               char(1),    
@po_id_persona          numeric(18,0) output,   
@po_c_error             typ_c_error   output,  
@po_d_error             typ_d_error   output  
)  
as  
    
--Objetivo: Alta de persona (y direcci?n de la misma)  
begin  
  
  if (@pi_id_usuario  is null  or @pi_id_usuario = 0) 
  begin  
      set @po_c_error = 3 
      set @po_d_error = 'No se recibi? pi_id_usuario'  
      return         
  end  
  
  declare   
      @f_nac             smalldatetime,  
      @dummy             numeric(18,0),  
      @e_tipo_tel_fijo   numeric(18,0),  
      @e_definitivo      char(1),
      --
      @c_nacionalidad    numeric(18,0),  
      @c_ocupacion       numeric(18,0),  
      @c_estado_civil    numeric(18,0),  
      @c_provincia       numeric(18,0),  
      @c_sexo            numeric(18,0)
    
  set @po_c_error = 0  
  set @po_d_error = null  
  
  execute sp_valida_datos_per  
          @pi_c_tpo_doc       = @pi_c_tpo_doc,  
          @pi_nro_doc         = @pi_nro_doc,  
          @pi_cuil            = @pi_cuil,  
          @pi_apellido        = @pi_apellido,  
          @pi_nombre          = @pi_nombre,  
          @pi_f_nac           = @pi_f_nac,  
          @pi_c_nacionalidad  = @pi_c_nacionalidad,  
          @pi_c_ocupacion     = @pi_c_ocupacion,  
          @pi_c_estado_civil  = @pi_c_estado_civil,  
          @pi_c_provincia     = @pi_c_provincia,  
          @pi_localidad       = @pi_localidad,  
          @pi_calle           = @pi_calle,  
          @pi_nro             = @pi_nro,  
          @pi_c_sexo          = @pi_c_sexo,  
          @pi_e_reg           = @pi_e_reg,  
          @po_c_error         = @po_c_error   output,  
          @po_d_error         = @po_d_error   output  
            
  if (@po_c_error  <> 0)  
      begin  
          return         
      end          
  
  --validacion de unicidad de tipo y dni  
  execute sp_valida_uk_doc_per @pi_id_persona      = @dummy,  
                               @pi_c_documento     = @pi_c_tpo_doc,  
                               @pi_n_documento     = @pi_nro_doc,  
                               @po_c_error         = @po_c_error   output,  
                               @po_d_error         = @po_d_error   output  
                           
  if (@po_c_error  <> 0)  
  begin  
      return         
  end  
  
  
  if @pi_f_nac is not null    
  begin  
      --convierto el varchar de entrada a date para el insert en la tabla  
      execute sp_convierte_char_en_fecha @pi_fecha_char     = @pi_f_nac,  
                                         @po_fecha_datetime = @f_nac      output,  
                                         @po_c_error        = @po_c_error output,  
                                         @po_d_error        = @po_d_error output  
                                 
        if (@po_c_error  <> 0)  
          begin  
	    set @po_d_error = 'Error llamando a sp_convierte_char_en_fecha : ' + @po_d_error	   
            return         
          end    
  end   
    
  --
  -- los que tienen foreing Key limpio los valores 0
  if @pi_c_nacionalidad <> 0 set @c_nacionalidad=@pi_c_nacionalidad
  if @pi_c_ocupacion <> 0 set @c_ocupacion=@pi_c_ocupacion
  if @pi_c_estado_civil <> 0 set @c_estado_civil=@pi_c_estado_civil
  if @pi_c_provincia <> 0 set @c_provincia=@pi_c_provincia
  if @pi_c_sexo <> 0 set @c_sexo=@pi_c_sexo
    
  begin tran inserta   
   
  insert into sagt_personas (  
                             c_documento,  
                             n_documento,  
                             d_apellido,  
                             d_nombre,  
                             d_cuil,  
                             f_nacimiento,  
                             c_nacionalidad,  
                             c_ocupacion,  
                             c_estado_civil,  
                             d_mail,  
                             d_calle,  
                             d_nro,  
                             d_piso,  
                             d_depto,  
                             d_localidad,  
                             c_provincia,  
                             c_sexo,  
                             e_registro,  
                             c_usua_alta  
                             )  
                     values (  
                             @pi_c_tpo_doc,             -- c_documento  
                             @pi_nro_doc,               -- n_documento  
                             @pi_apellido,              -- d_apellido  
                             @pi_nombre,                -- d_nombre  
                             @pi_cuil,                  -- d_cuil  
                             @f_nac,                    -- f_nacimiento  
                             @c_nacionalidad,        -- c_nacionalidad  
                             @c_ocupacion,           -- c_ocupacion  
                             @c_estado_civil,        -- c_estado_civil  
                             @pi_mail,                  -- d_mail                               
                             @pi_calle,                 -- d_calle  
                             @pi_nro,                   -- d_nro      
                             @pi_piso,                  -- d_piso  
                             @pi_depto,                 -- d_depto  
                             @pi_localidad,             -- d_localidad  
                             @c_provincia,           -- c_provincia                          
                             @c_sexo,                -- c_sexo  
                             @pi_e_reg,                 --e_registro  
                             @pi_id_usuario             -- c_usua_alta  
                             )  
  --guardo el id de persona   
  set @po_c_error = @@error,@po_id_persona = @@identity      
  if (@po_c_error  <> 0)  
    begin   
      rollback tran inserta  
      set @po_d_error =  convert(varchar,@po_c_error)   
                         + ' - Error al insertar persona '  
  end  
  
  if char_length(@pi_l_telefonos) > 1  
  begin  
	execute sp_inserta_tel_per            
		@pi_id_usuario            = @pi_id_usuario,  
		@pi_l_telefonos           = @pi_l_telefonos,			  
		@pi_id_persona            = @po_id_persona,					  
		@po_c_error      	  	  = @po_c_error output,   
		@po_d_error      	  	  = @po_d_error output  
                  
        if (@po_c_error  <> 0)  
        begin   
            rollback tran inserta
            return        
        end  
  end  
  
  execute sp_obtiene_tipo_tel_fijo  @po_c_valor  = @e_tipo_tel_fijo output,  
                                    @po_c_error  = @po_c_error output,  
                                    @po_d_error  = @po_d_error output  
                                 
    if (@po_c_error  <> 0)  
    begin  
      set @po_d_error = 'Error llamando a sp_obtiene_tipo_tel_fijo : ' + @po_d_error 
      return         
    end  
  
  --procedure q retorna los codigos del estado de registro definitivo  
  execute sp_obtiene_e_definitivo   @po_c_valor  = @e_definitivo output,  
                                    @po_c_error  = @po_c_error output,  
                                    @po_d_error  = @po_d_error output  
                                 
    if (@po_c_error  <> 0)  
    begin  
      set @po_d_error = 'Error llamando a sp_obtiene_e_definitivo : ' + @po_d_error	 
      return         
    end          
    
  if @pi_e_reg = @e_definitivo and not exists (  
          select id_telefono  
            from sagt_telefonos  
           where id_persona     = @po_id_persona  
             and c_tipo_telefono = @e_tipo_tel_fijo)  
  begin  
      rollback tran inserta  
      set @po_c_error = 2  
      set @po_d_error = 'Debe indicar al menos un tel?fono particular'  
      return           
  end    
      
  set @po_c_error = @@error   
  if (@po_c_error  <> 0)  
  begin  
          rollback tran inserta  
          set @po_d_error = convert(varchar,@po_c_error) +   
                      ' - Error en sp_inserta_persona. '  
  end  
    
  commit tran inserta  
    
end --sp_inserta_persona 
 
go 

Grant Execute on dbo.sp_inserta_persona to GrpTrpSabed 
go

sp_procxmode 'sp_inserta_persona', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_inserta_pregunta_evAcad'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_inserta_pregunta_evAcad" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_inserta_pregunta_evAcad(
@pi_id_usuario      numeric(18,0),
@pi_d_pregunta      varchar(40),
@pi_id_seccion      numeric(18,0), 
@pi_n_orden         integer,
@po_c_error         typ_c_error output,
@po_d_error         typ_d_error output
)
as
/*
Objetivo: insertar una seccion de preguntas
*/

begin

  if (@pi_id_usuario is null or @pi_id_usuario = 0)
    begin
      set @po_c_error = 3
      set @po_d_error = 'No se recibi? pi_id_usuario'
      return       
  end

  set @po_c_error = 0
  set @po_d_error = null

  insert into saat_preguntas_eval_academ (d_pregunta, n_orden,id_seccion, c_usua_alta ) 
  values(@pi_d_pregunta,@pi_n_orden,@pi_id_seccion,@pi_id_usuario) 
  
  set @po_c_error = @@error    
  if (@po_c_error  <> 0)
  begin 
      set @po_d_error =  convert(varchar,@po_c_error) 
                         + ' - Error al consultar lista de preguntas. '
      return
  end
end --sp_inserta_pregunta_evAcad
 
go 

Grant Execute on dbo.sp_inserta_pregunta_evAcad to GrpTrpSabed 
go

sp_procxmode 'sp_inserta_pregunta_evAcad', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_inserta_recargas'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_inserta_recargas" >>>>>'
go 

setuser 'dbo'
go 

create procedure sp_inserta_recargas(    
@pi_id_usuario      numeric(18,0),    
@pi_id_tutor        numeric(18,0),   
@pi_id_periodo      numeric(18,0),   
@pi_id_ong          numeric(18,0),   
@pi_l_alu           typ_lista,      
@po_c_error         typ_c_error output,   
@po_d_error         typ_d_error output   
)   
as   
/*   
Objetivo: inserta los lotes de recargas con alumnos   
@pi_l_alu es de la forma:    
@id_alu_tar:@e_alumno:@q_recargas:@x_observacion   
*/   
   
begin   
   
  if @pi_id_usuario is null or @pi_id_usuario=0  
    begin   
      set @po_c_error =3  
      set @po_d_error = 'No se recibi? pi_id_usuario'   
      return          
  end    
  if @pi_id_periodo is null or @pi_id_periodo=0  
    begin   
      set @po_c_error = 3  
      set @po_d_error = 'No se recibi? pi_id_periodo'   
      return          
  end      
  if @pi_id_tutor is null or @pi_id_tutor=0  
    begin   
      set @po_c_error =3   
      set @po_d_error = 'No se recibi? pi_id_tutor'   
      return          
  end    
  if @pi_l_alu is null  
     begin   
      set @po_c_error =3   
      set @po_d_error = 'No se recibi? pi_l_alu'   
      return          
  end  
    
  --  
  -- solo crea los lotes el tutor administrativo  
  if not exists (   
      select 1   
        from sasv_usuarios_tut ut,   
             sast_usuarios_perfiles up   
       where ut.id_tutor = @pi_id_tutor   
         and ut.id_usuario = up.id_usuario            
         and up.id_perfil = 1)   
  begin   
      set @po_c_error = 2   
      set @po_d_error = 'El usuario no posee perfil de Tutor Administrativo; no puede realizar esta acci?n'   
      return          
  end                  
   
  declare @f_operacion      datetime,   
          @id_lote_recarga  numeric(18,0)   
   
  set @po_c_error = 0   
  set @po_d_error = null   
     
  begin tran recargas   
     
  insert into sart_lotes_recarga(   
                      id_tutor,   
                      id_periodo_recarga,   
                      c_estado_lote,   
                      id_coordinador,   
                      f_oper_coordinador,   
                      id_adm_equipo_becas,   
                      f_oper_eq_becas,   
                      id_sup_equipo_becas,   
                      f_oper_sup_eq_becas,                         
                      c_usua_alta)   
              values (@pi_id_tutor,   
                      @pi_id_periodo,   
                      'EN_REVISION',   
                      null,   
                      null,   
                      null,   
                      null,                         
                      null,                         
                      null,   
                      @pi_id_usuario)   
  
  set @po_c_error = @@error, @id_lote_recarga = @@identity       
  if (@po_c_error  <> 0)   
    begin    
      rollback tran recargas    
      set @po_d_error =  'Error al insertar cabecera de recargas. '   
      return   
  end   
   
  execute sp_inserta_det_recarga   
    @pi_id_usuario      = @pi_id_usuario,   
    @pi_id_lote         = @id_lote_recarga,   
    @pi_l_alu           = @pi_l_alu,   
    @pi_valida          = 'N',  
    @po_c_error         = @po_c_error  output,   
    @po_d_error         = @po_d_error  output   
   
  if (@po_c_error  <> 0)    
    begin   
      rollback tran recargas    
      return     
  end   
     
  commit tran recargas   
     
end -- sp_inserta_recargas  
 

go 

Grant Execute on dbo.sp_inserta_recargas to GrpTrpSabed 
go

sp_procxmode 'sp_inserta_recargas', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_inserta_recargas_pago'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_inserta_recargas_pago" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_inserta_recargas_pago(   

@pi_id_usuario           numeric(18,0),   

@pi_f_recarga            varchar(20),      

@pi_l_det_recarga        typ_lista,

@pi_l_det_recarga1       typ_lista,

@pi_l_det_recarga2       typ_lista,

@po_id_lote_pago         numeric(18,0) output, 

@po_c_error              typ_c_error   output,   

@po_d_error              typ_d_error   output   

)   

as   

/*   

Objetivo: Inserta en la tabla de lotes de pago el detalle de las recargas en SI   

@pi_l_det_recarga es de la forma "@id_lote_det_recarga|@id_lote_det_recarga "   

*/   

   

begin   



  --insert into sabed_log (descrip) values ('paso 0')   

   

  if @pi_id_usuario is null or @pi_id_usuario =0  

    begin   

      set @po_c_error = 3   

      set @po_d_error = 'No se recibió pi_id_usuario'   

      return          

  end   

  if  @pi_f_recarga is null   

    begin   

      set @po_c_error = 3   

      set @po_d_error = 'No se recibió pi_f_recarga'   

      return          

  end   

   

  set @po_c_error = 0   

  set @po_d_error = null   

     

  declare @sep                     varchar(1),   

          @dummy                   varchar(1),   

          @v_lista                  typ_lista,

		  @contador				          int,

		  @cant_list				 	  int, 

          @reg_detalle              typ_lista,   

          @f_recarga                 datetime,   

          @id_lote_det_recarga     numeric(18,0)   

   

  execute sp_separador_registros   

             @po_separador_registro    = @sep        output,   

             @po_separador_campo       = @dummy      output,   

             @po_c_error               = @po_c_error output,   

             @po_d_error               = @po_d_error output     

                

  if (@po_c_error  <> 0)    

    begin   

      set @po_d_error = 'Error al ejecutar sp_separador_registros: '+ @po_d_error  

      return     

  end   

     

  begin tran recargas  

  

  set @f_recarga = getDate()

/*   

  --convierto el varchar de entrada a date    

  execute sp_convierte_char_en_fecha @pi_fecha_char     = @pi_f_recarga,   

                                     @po_fecha_datetime = @f_recarga output,   

                                     @po_c_error        = @po_c_error  output,   

                                     @po_d_error        = @po_d_error  output   

                              

  if (@po_c_error  <> 0)    

    begin   

      set @po_d_error = 'Error al ejecutar sp_convierte_char_en_fecha: '+ @po_d_error  

      rollback tran recargas    

      return     

  end

  */

  --insert into sabed_log (descrip) values ('paso 1')   

     

  --realizo el insert en lotes de pago   

     

  insert into sart_lotes_pago(   

                      f_recarga,      

                      c_usua_alta,  

                      e_lote_pago)   

              values (@f_recarga,      

                      @pi_id_usuario,  

                      'PENDIENTE')   

                         

  set @po_c_error = @@error, @po_id_lote_pago = @@identity       

  if (@po_c_error  <> 0)   

  begin   

      rollback tran recargas    

      set @po_d_error =  'Error al insertar cabecera de pagos. '   

      return   

  end 



  

	if (char_length(@pi_l_det_recarga) > 0)

	  

	  begin

	  

	  set @contador = 1

		

	  end

	  if (char_length(@pi_l_det_recarga1) > 0)

	  

	  begin

	  

	  set @contador = @contador + 1

		

	  end

	  if (char_length(@pi_l_det_recarga2) > 0)

	  

	  begin

	  

	  set @contador = @contador + 1

		

	  end

     

	 

     

  

  --insert into sabed_log (descrip) values ('paso 2')

   

  --parseo la lista 

  

  set @cant_list = 0



while (@cant_list < @contador  )

 

 begin -- while 1

			if(@cant_list = 0)

					begin

					

					set @v_lista  = @pi_l_det_recarga + @sep

					

					end

			

			if (@cant_list = 1)

					begin

					

					set @v_lista  = @pi_l_det_recarga1 + @sep

					

					end

			

			if (@cant_list = 2)

					begin

					

					set @v_lista  = @pi_l_det_recarga2 + @sep

					

					end









 

  

  

		  while (@v_lista is not null)  

		  

		  begin   -- while 2

						  --obtengo un elemento de la lista   

						  set @id_lote_det_recarga = convert(numeric,substring(@v_lista, 1,charindex(@sep,@v_lista)-1))    

						  

						  --insert into sabed_log (descrip) values ('v_lista: '+@v_lista)

												   

						  --obtengo el resto de la lista                           

						  set @v_lista = substring(@v_lista,   

													 charindex(@sep,@v_lista)+1,    

													 char_length(@v_lista)   

													 )            

							 

						  --inserto el detalle de la recarga   

						  execute sp_inserta_det_pago  

											@pi_id_usuario          = @pi_id_usuario,   

											@pi_id_lote_pago        = @po_id_lote_pago,   

											@pi_id_lote_det_recarga = @id_lote_det_recarga,   

											@po_c_error             = @po_c_error  output,   

											@po_d_error             = @po_d_error  output   

											   

						  if (@po_c_error  <> 0)    

						  begin   

							  set @po_d_error = 'Error sp_inserta_recargas_pago: ' + @po_d_error  

							  rollback tran recargas    

							  return     

						  end                                       

		   

							 

							--updateo el usuario que revisa la recarga por SI o por NO   

						  update sart_lotes_recarga   

						  set id_sup_equipo_becas = @pi_id_usuario,    

							  c_usua_actuac       = @pi_id_usuario,   

							  f_actuac            = getDate(), 

							  c_estado_lote       = 'ENVIADO'   

						  where id_lote_recarga = ( select id_lote_recarga   

													  from sart_lotes_det_recarga   

													 where id_lote_det_recarga = @id_lote_det_recarga    

												   )   

						  set @po_c_error = @@error   

						  if (@po_c_error  <> 0)    

						  begin   

							  rollback tran recargas    

							  set @po_d_error =  'Error al actualizar lote de recargas. '   

							  return     

						  end   

							 

		  end --while 2 

		  

		  set @cant_list = @cant_list+ 1



  end -- while 1

   

  commit tran recargas   

  

  --insert into sabed_log (descrip) values ('paso 100')   

     

end
 
go 

Grant Execute on dbo.sp_inserta_recargas_pago to GrpTrpSabed 
go

sp_procxmode 'sp_inserta_recargas_pago', anymode
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_inserta_rendicion_gastos'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_inserta_rendicion_gastos" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_inserta_rendicion_gastos (  
@pi_id_rendicion            numeric(18,0),  
@pi_id_persona              numeric(18,0),  
@pi_id_usuario              numeric(18,0),  
@pi_id_periodo              numeric(18,0),  
@pi_gastos                  typ_lista,  
@pi_otros_gastos            typ_lista,  
@po_id_rendicion            numeric(18,0) output,  
@po_c_error                 typ_c_error output,  
@po_d_error                 typ_d_error output  
)  
as  
-- OBJETIVO: insertar una rendicion de gastos  
-- Par?metros de entrada:  
--   id_rendicion: identificador de rendicion de gastos, si viene elimina la anterior ???  
--   ID persona: Identificador de la persona siendo alumno becado.  
--   ID de usuario: identificador del usuario que est? ejecutando la operaci?n.  
--   Periodo : per?do de carga al cual pertenece la rendici?n de gastos.  
--   Gastos: cadena de caracteres que representa "gastos parametrizables de la rendici?n".  
--   Otros Gastos: cadena de caracteres que representa "otros gastos de la rendici?n".  
--  NOTA: En ambos casos de GASTOS se hace uso del s?mbolo | como separador de cada item y dos puntos ":" como separador de campo.  
  
begin  
 declare   
  @sepReg                varchar(1),  
  @sepCampo              varchar(1),  
  @vposReg               numeric(3,0),  
  @vcodGasto             numeric(18,0),  
  @vi_gasto              numeric(18,2),  
  @id_rendicion          numeric(18,0),   
  @id_tabla_c_gasto      numeric(18,0),   
  @vcodGasto_otro        numeric(18,0),  
  @vtextGasto            varchar(40),  
  @vauxReg               typ_lista,  
  @vauxCampo             typ_lista,  
  @id_alumno             numeric(18,0),  
  @id_persona_char       varchar(18), 
  @estado                varchar(1) 
    
 -- VALIDACI?N de par?metros de entrada  
 if (@pi_id_usuario is null or @pi_id_usuario = 0)  
  begin  
   set @po_c_error = 3  
      set @po_d_error = 'No se recibi? usuario'  
      return  
  end  
  
 if (@pi_id_persona is null or @pi_id_persona = 0)   
  begin  
      set @po_c_error = 3 
      set @po_d_error = 'No se recibi? el ID de la persona'  
      return  
  end  
 else  
 if not exists (Select 1 From saat_alumnos Where id_persona = @pi_id_persona and e_alumno ='BECADO')  
  begin  
      set @po_c_error = 2  
      set @id_persona_char = convert(varchar(18), @pi_id_persona)  
      set @po_d_error = 'No existe un alumno para el ID de persona: ' + @id_persona_char  
      return  
  end  
  
 if (@pi_id_periodo is null or @pi_id_periodo = 0)  
  begin  
      set @po_c_error = 3  
      set @po_d_error = 'No se recibi? el per?odo a informar'  
      return  
  end  
 if (@pi_gastos is null and @pi_otros_gastos is null)  
  begin  
      set @po_c_error = 2  
      set @po_d_error = 'Debe completar los importes de los gastos'  
      return  
  end  
  
 --  
 -- Verificamos que el estado del periodo se pueda modificar  
 execute sp_est_periodo_rend_gas  
            @pi_id_periodo = @pi_id_periodo,   
            @po_estado     = @estado   output,   
            @po_c_error    = @po_c_error output,   
            @po_d_error    = @po_d_error output     
 if (@po_c_error  <> 0)   
  begin  
	  set @po_d_error = 'Error llamando a sp_est_periodo_rend_gas : ' + @po_d_error
      return       
  end  
  
 If @estado <> 'A' 
 begin  
      set @po_c_error = 2  
      set @po_d_error = 'No se puede utilizar el per?odo de rendicion informado'  
      return  
  end  
  
 -- Obtenemos el ID del alumno becado usando el ID de la persona  
 Select @id_alumno=id_alumno from saat_alumnos  
  Where id_persona = @pi_id_persona  
    and e_alumno ='BECADO'  
    
 --  
 -- Seteo los campos para sepradores  
 execute sp_separador_registros  
            @po_separador_registro    = @sepReg     output,   
            @po_separador_campo       = @sepCampo   output,   
            @po_c_error               = @po_c_error output,   
            @po_d_error               = @po_d_error output     
 if (@po_c_error  <> 0)   
  begin  
 	  set @po_d_error = 'Error llamando a sp_separador_registros : ' + @po_d_error 
      return       
  end  
  
 --   
 -- Asignaci?n del valor correspondiente a la tabla de conceptos de otros gastos explic?ta en la tabla par?metros  
 set @id_tabla_c_gasto = 9  
   
 Select @vcodGasto_otro = id_parametro -- obtenci?n del c?digo que identifica a otros gastos  
   From sapt_parametros  
  Where id_tabla = @id_tabla_c_gasto  
    and d_valor ='#OTROS#'  
     
 if (@@rowcount = 0)  
  begin  
   set @po_c_error = 3
   set @po_d_error = 'No se identific? el codigo de otros gastos'  
   return                
  end  
    
 --  
 -- Seteo los par?metros de salida  
 set @po_c_error = 0  
 set @po_d_error = ''  
  
 --  
 -- Si existe rendici?n de gastos elimino los detalles de la misma  
 if (@pi_id_rendicion is not null and @pi_id_rendicion !=0)  
  begin   
      delete from saat_detalle_rend_gasto   
       where id_rendicion = @pi_id_rendicion  
  
      delete from saat_alumnos_rendicion_gasto   
      where id_rendicion = @pi_id_rendicion  
  end  
  
 --  
 -- inserto la cabecera de Rendicion de gastos y obtengo el ID  
 insert into saat_alumnos_rendicion_gasto  
  (id_alumno,f_rend_gasto,id_periodo,e_registro,  
   c_usua_alta,f_alta,c_usua_actuac,f_actuac)  
 values  
  (@id_alumno,getDate(),@pi_id_periodo,'D',  
   @pi_id_usuario,GetDate(),null,null)  
 set @id_rendicion = @@identity  
 set @po_id_rendicion = @id_rendicion -- Asignaci?n del ID que se va a devolver como par?metro de salida para actualizar en la pantalla  
  
 set @po_c_error = @@error      
 if (@po_c_error  <> 0)  
  begin  
   set @po_d_error = 'Error al insertar la cabecera de gastos'  
   return  
  end  
  
 --  
 -- Abro el detalle de los gastos  
 if (@pi_gastos is not null)  
  begin  
  
   set @vauxReg = @pi_gastos  
   set @vposReg = -1  
   while (@vposReg <> 0)  
    begin  
  
     --  
     -- Establezco donde se acaba el registro  
     set @vposReg = charindex(@sepReg ,@vauxReg)  
  
     --  
     -- Obtengo el registro para separarlo en campos  
     if (@vposReg <> 0)  
      begin  
       set @vauxCampo = substring(@vauxReg,1,@vposReg-1)  
      end  
        else  
      begin  
       set @vauxCampo = @vauxReg  
      end  
  
        set @vcodGasto = convert(numeric(18,0),substring(@vauxCampo,1,charindex(@sepCampo ,@vauxCampo)-1))  
        set @vi_gasto  = convert(numeric(18,2),substring(@vauxCampo,charindex(@sepCampo ,@vauxCampo)+1,char_length(@vauxCampo)))  
  
        --  
        -- inserto en la tabla de detalle el gasto  
        insert into saat_detalle_rend_gasto  
          (id_rendicion,id_alumno,f_rend_gasto,id_periodo,i_gasto,c_gasto,  
           x_descrip_otros_gastos,c_usua_alta,f_alta,c_usua_actuac,f_actuac)  
        values  
          (@id_rendicion,@id_alumno,getdate(),@pi_id_periodo,@vi_gasto,@vcodGasto,  
           null,@pi_id_usuario,GetDate(),null,null)  
            
        set @po_c_error = @@error     
        if (@po_c_error  <> 0)  
         begin  
       set @po_d_error = 'Error al insertar el detalle de gastos'  
       return               
      end  
  
        --  
        -- Preparo el string para la proxima vuelta  
        set @vauxReg = substring(@vauxReg,@vposReg+1,char_length(@vauxReg))  
  
    end -- while  
 end -- if rendici?n de gastos  
  
  --  
  -- Abro el detalle de otros gastos  
  if (@pi_otros_gastos is not null)  
  begin  
      set @vauxReg = @pi_otros_gastos  
      set @vposReg = -1  
      while (@vposReg <> 0)  
      begin  
  
        --  
        -- Establezco donde se acaba el registro  
        set @vposReg = charindex(@sepReg ,@vauxReg)  
  
        --  
        -- Obtengo el registro para separarlo en campos  
        if (@vposReg<>0)  
        begin  
          set @vauxCampo = substring(@vauxReg,1,@vposReg-1)  
        end  
        else  
        begin  
         set @vauxCampo = @vauxReg  
        end  
  
        set @vtextGasto = substring(@vauxCampo,1,charindex(@sepCampo ,@vauxCampo)-1)  
        set @vi_gasto  = convert(numeric(18,2),substring(@vauxCampo,charindex(@sepCampo ,@vauxCampo)+1,char_length(@vauxCampo)))  
  
        --  
        -- inserto en la tabla de detalle el gasto  
        insert into saat_detalle_rend_gasto  
         (id_rendicion,id_alumno,f_rend_gasto,id_periodo,i_gasto,  
          c_gasto,x_descrip_otros_gastos,c_usua_alta,f_alta,c_usua_actuac,f_actuac)  
        values  
         (@id_rendicion,@id_alumno,getdate(),@pi_id_periodo,@vi_gasto,  
          @vcodGasto_otro,@vtextGasto,@pi_id_usuario,GetDate(),null,null)  
  
       set @po_c_error = @@error     
       if (@po_c_error  <> 0)  
       begin  
         set @po_d_error = 'Error al insertar el detalle de gastos (otro)'  
         return  
       end  
  
       --  
       -- Preparo el string para la pr?xima vuelta  
       set @vauxReg = substring(@vauxReg,@vposReg+1,char_length(@vauxReg))  
  
     end -- while  
  end -- if rendicion de otros gastos  
end  --sp_inserta_rendicion_gastos
 
go 

Grant Execute on dbo.sp_inserta_rendicion_gastos to GrpTrpSabed 
go

sp_procxmode 'sp_inserta_rendicion_gastos', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_inserta_respuesta_evAcad'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_inserta_respuesta_evAcad" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_inserta_respuesta_evAcad(
@pi_id_usuario      numeric(18,0),
@pi_d_respuesta     varchar(40),
@pi_id_pregunta     numeric(18,0),
@po_c_error         typ_c_error output,
@po_d_error         typ_d_error output
)
as
/*
Objetivo: insertar una seccion de preguntas
*/

begin

  if (@pi_id_usuario is null or @pi_id_usuario = 0)
    begin
      set @po_c_error = 3
      set @po_d_error = 'No se recibi? pi_id_usuario'
      return       
  end

  set @po_c_error = 0
  set @po_d_error = null

  insert into saat_respuestas_eval_academ (d_respuesta, id_pregunta, c_usua_alta) 
  values(@pi_d_respuesta,@pi_id_pregunta,@pi_id_usuario)
  
  set @po_c_error = @@error    
  if (@po_c_error  <> 0)
  begin 
      set @po_d_error =  convert(varchar,@po_c_error) 
                         + ' - Error al insertar respuestas de preguntas. '
      return
  end
end --sp_inserta_respuesta_evAcad
 
go 

Grant Execute on dbo.sp_inserta_respuesta_evAcad to GrpTrpSabed 
go

sp_procxmode 'sp_inserta_respuesta_evAcad', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_inserta_seccion_evAcad'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_inserta_seccion_evAcad" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_inserta_seccion_evAcad(
@pi_id_usuario      numeric(18,0),
@pi_d_seccion       varchar(40),
@pi_n_orden         integer,
@po_c_error         typ_c_error output,
@po_d_error         typ_d_error output
)
as
/*
Objetivo: insertar una seccion de las preguntas para la Evaluaci?n Acad?mica
          de un alumno
*/

begin

  if (@pi_id_usuario is null or @pi_id_usuario = 0)
    begin
      set @po_c_error = 3
      set @po_d_error = 'No se recibi? pi_id_usuario'
      return       
  end

  set @po_c_error = 0
  set @po_d_error = null

  insert into saat_secciones_eval_academ (d_seccion, n_orden,c_usua_alta)
  values(@pi_d_seccion,@pi_n_orden,@pi_id_usuario)
 
  set @po_c_error = @@error    
  if (@po_c_error  <> 0)
  begin 
      set @po_d_error =  convert(varchar,@po_c_error) 
                         + ' - Error al consultar lista de preguntas. '
      return
  end
end --sp_inserta_seccion_evAcad
 
go 

Grant Execute on dbo.sp_inserta_seccion_evAcad to GrpTrpSabed 
go

sp_procxmode 'sp_inserta_seccion_evAcad', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_inserta_seg_recargas'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_inserta_seg_recargas" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_inserta_seg_recargas(   
@pi_id_usuario      numeric(18,0),   
@pi_id_periodo      numeric(18,0),  
@pi_id_ong          numeric(18,0),  
@pi_l_alu           typ_lista,     
@po_c_error         typ_c_error output,  
@po_d_error         typ_d_error output  
)  
as  
/*  
 
Objetivo: inserta los lotes de segunda recarga 
 
*/  
  
begin  
  
  if @pi_id_usuario is null or @pi_id_usuario = 0 
    begin  
      set @po_c_error =3 
      set @po_d_error = 'No se recibi? pi_id_usuario'  
      return         
  end   
  if @pi_id_periodo is null or @pi_id_periodo = 0 
    begin  
      set @po_c_error = 3 
      set @po_d_error = 'No se recibi? pi_id_periodo'  
      return         
  end      
  if @pi_l_alu is null  
     begin  
      set @po_c_error =3  
      set @po_d_error = 'No se recibi? pi_l_alu'  
      return         
  end 
  
  declare @id_lote_recarga  numeric(18,0)  
  
  set @po_c_error = 0  
  set @po_d_error = null  
    
  begin tran recargas  
   
  -- 
  -- Inserto la cabecera ya en el estado A_PAGAR para que solo reste el Ok del supervisor. 
  insert into sart_lotes_recarga(id_tutor,id_periodo_recarga,c_estado_lote,  
                                 id_coordinador, f_oper_coordinador,  
                                 id_adm_equipo_becas,f_oper_eq_becas,  
                                 id_sup_equipo_becas,f_oper_sup_eq_becas,                        
                                 c_usua_alta)  
                         values (NULL,@pi_id_periodo,'A_PAGAR', 
                                 null,null,  
                                 @pi_id_usuario, getdate(),                        
                                 null,null,  
                                 @pi_id_usuario)  
 
  set @po_c_error = @@error, @id_lote_recarga = @@identity      
  if (@po_c_error  <> 0)  
    begin   
      rollback tran recargas   
      set @po_d_error =  'Error al insertar cabecera de segunda recarga'  
      return  
  end  
  
 
  execute sp_inserta_det_recarga  
      @pi_id_usuario      = @pi_id_usuario,  
      @pi_id_lote         = @id_lote_recarga,  
      @pi_l_alu           = @pi_l_alu,  
      @pi_valida          = 'S', -- validamos que los registros esten OK 
      @po_c_error         = @po_c_error  output,  
      @po_d_error         = @po_d_error  output  
  
  if @po_c_error = 4 -- manejo de error especial
    begin  
      set @po_c_error = 2
      rollback tran recargas   
      return    
  end  
  if (@po_c_error  <> 0)   
    begin  
      rollback tran recargas   
      return    
  end  
    
  commit tran recargas  
    
end -- sp_inserta_seg_recargas
 
go 

Grant Execute on dbo.sp_inserta_seg_recargas to GrpTrpSabed 
go

sp_procxmode 'sp_inserta_seg_recargas', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_inserta_tel_col'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_inserta_tel_col" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_inserta_tel_col (  
@pi_c_usua_alta    numeric(18,0), 
@pi_l_telefonos    typ_lista, 
@pi_id_colegio     numeric(18,0),  
@po_c_error      	 typ_c_error output, 
@po_d_error      	 typ_d_error output 
) 
as 
-------------------------------------------  
------------------------ 
--Objetivo:  
--Par?metros de entrada:  	 
--	C_USUA_ALTA           
--Par?metros de salida: po_id_institucion, po_c_error y po_d_error 
------------------------------------------------------------------- 
 
begin 
  
  declare  
      @l_telefonos       typ_lista, 
      @sublista_tel      varchar(40), 
      @sep               varchar(1), 
      @subSep            varchar(1), 
      @d_telefono 	     varchar(40), 
      @c_tipo_telefono   numeric(18,0), 
      @observaciones     varchar(250) 
  
  set @po_c_error = 0 
  set @po_d_error = null 
 
  execute sp_separador_registros 
             @po_separador_registro    = @sep        output, 
             @po_separador_campo       = @subSep     output, 
             @po_c_error               = @po_c_error output, 
             @po_d_error               = @po_d_error output   
              
  if (@po_c_error  <> 0) 
    begin 
	  set @po_d_error = 'Error llamando a sp_separador_registros : ' + @po_d_error
      return     
  end 
 
  set @l_telefonos = @pi_l_telefonos + @sep 
   
  --almaceno los telefonos del colegio 
  while (@l_telefonos is not null) 
  begin 
   
      set @sublista_tel    = substring(@l_telefonos,1,charindex(@sep,@l_telefonos)-1) + @subSep 
       
      set @l_telefonos = substring(@l_telefonos, 
                                   charindex(@sep,@l_telefonos)+1,  
                                   char_length(@l_telefonos) 
                                   )       
       
      execute sp_datos_tel  
                        @pi_sublista_tel    = @sublista_tel,  
                        @pi_subSep          = @subSep, 
                        @po_d_telefono      = @d_telefono      output, 
                        @po_c_tipo_telefono = @c_tipo_telefono output, 
                        @po_observaciones   = @observaciones   output, 
                        @po_c_error         = @po_c_error      output, 
                        @po_d_error         = @po_d_error      output 
                         
      if (@po_c_error  <> 0) 
      begin 
		  set @po_d_error = 'Error llamando a sp_datos_tel : ' + @po_d_error	  
          return              
      end   
       
      --antes de insertar controla q no exista ese num de telefono 
      if exists (select id_telefono 
                   from sagt_telefonos 
                  where id_colegio     = @pi_id_colegio 
                    and d_telefono = @d_telefono 
                )  
      begin 
          set @po_d_error = 'Los N?meros de telefonos deben ser ?nicos. Est? repitiendo el n?mero: '+  
                            convert(varchar,@d_telefono) 
          set @po_c_error = 2 
          return              
      end                                   
 
      --inserta cada uno de los telefonos de la lista 
      insert into sagt_telefonos (id_colegio,d_telefono,c_tipo_telefono, 
                                  observaciones, c_usua_alta) 
                        values (@pi_id_colegio,@d_telefono,@c_tipo_telefono, 
                                  @observaciones,@pi_c_usua_alta) 
       
      set @po_c_error = @@error     
      if (@po_c_error  <> 0) 
      begin 
          set @po_d_error =  convert(varchar,@po_c_error)  
                         + ' - Error al insertar telefono de colegio. '                             
          return              
      end 
       
  end  --while     
 
end --sp_inserta_tel_col
 
go 

Grant Execute on dbo.sp_inserta_tel_col to GrpTrpSabed 
go

sp_procxmode 'sp_inserta_tel_col', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_inserta_tel_ong'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_inserta_tel_ong" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_inserta_tel_ong (  
@pi_c_usua_alta      numeric(18,0), 
@pi_l_telefonos      varchar(250), 
@pi_id_ong           numeric(18,0) output,  
@po_c_error      	   typ_c_error output, 
@po_d_error      	   typ_d_error output 
) 
as 
-------------------------------------------  
------------------------ 
--Objetivo: Alta de institucion.  
--Par?metros de entrada:  	 
--	C_USUA_ALTA           
--Par?metros de salida: po_id_institucion, po_c_error y po_d_error 
------------------------------------------------------------------- 
 
begin 
  
  declare  
      @l_telefonos       typ_lista, 
      @sublista_tel      varchar(40), 
      @sep               varchar(1), 
      @subSep            varchar(1), 
      @d_telefono 	     varchar(40), 
      @c_tipo_telefono   numeric(18,0), 
      @observaciones     varchar(250) 
  
  set @po_c_error = 0 
  set @po_d_error = null 
 
  execute sp_separador_registros 
             @po_separador_registro    = @sep        output, 
             @po_separador_campo       = @subSep     output, 
             @po_c_error               = @po_c_error output, 
             @po_d_error               = @po_d_error output   
              
  if (@po_c_error  <> 0) 
    begin 
	  set @po_d_error = 'Error llamando a sp_separador_registros : ' + @po_d_error
      return     
  end 
   
  set @l_telefonos = @pi_l_telefonos + @sep 
   
  --almaceno los destinatarios de la tarea 
  while (@l_telefonos is not null) 
  begin 
   
      set @sublista_tel    = substring(@l_telefonos,1,charindex(@sep,@l_telefonos)-1) + @subSep 
       
      set @l_telefonos = substring(@l_telefonos, 
                                   charindex(@sep,@l_telefonos)+1,  
                                   char_length(@l_telefonos) 
                                   )       
       
      execute sp_datos_tel  
                        @pi_sublista_tel    = @sublista_tel,  
                        @pi_subSep          = @subSep, 
                        @po_d_telefono      = @d_telefono      output, 
                        @po_c_tipo_telefono = @c_tipo_telefono output, 
                        @po_observaciones   = @observaciones   output, 
                        @po_c_error         = @po_c_error      output, 
                        @po_d_error         = @po_d_error      output 
                         
      if (@po_c_error  <> 0) 
      begin 
		  set @po_d_error = 'Error llamando a sp_datos_tel : ' + @po_d_error	  
          return              
      end 
       
      --antes de insertar controla q no exista ese num de telefono 
      if exists (select id_telefono 
                   from sagt_telefonos 
                   where id_ong     = @pi_id_ong 
                   and d_telefono 	= @d_telefono 
                )  
      begin 
          set @po_d_error = 'Los N?meros de telefonos deben ser ?nicos. Est? repitiendo el n?mero: '+  
                            convert(varchar,@d_telefono) 
          set @po_c_error = 2 
          return              
      end                         
 
      --inserta cada uno de los telefonos de la lista 
      insert into sagt_telefonos (id_ong,d_telefono,c_tipo_telefono, 
                                  observaciones, c_usua_alta) 
                        values (@pi_id_ong,@d_telefono,@c_tipo_telefono, 
                                  @observaciones,@pi_c_usua_alta) 
       
      set @po_c_error = @@error     
 
      if (@po_c_error  <> 0) 
      begin 
          set @po_d_error =  convert(varchar,@po_c_error)  
                         + ' - Error al insertar telefono de ong. '                          
          return              
      end 
       
  end  --while       
 
end --sp_inserta_tel_ong
 
go 

Grant Execute on dbo.sp_inserta_tel_ong to GrpTrpSabed 
go

sp_procxmode 'sp_inserta_tel_ong', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_inserta_tel_per'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_inserta_tel_per" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_inserta_tel_per ( 
-- drop procedure sp_inserta_tel_per 
@pi_id_usuario       numeric(18,0), 
@pi_id_persona       numeric(18,0), 
@pi_l_telefonos      typ_lista, 
@po_c_error          typ_c_error output, 
@po_d_error          typ_d_error output 
) 
as 
/* 
   Objetivo: Alta de Telefono de una persona 
    
*/ 
 
 
begin 
 
  declare  
      @e_definitivo      char(1),   
      @l_telefonos       typ_lista, 
      @sublista_tel      varchar(40), 
      @sep               varchar(1), 
      @subSep            varchar(1), 
      @d_telefono 	 	 varchar(40), 
      @c_tipo_telefono   numeric(18,0), 
      @observaciones     varchar(250) 
   
  execute sp_separador_registros 
             @po_separador_registro    = @sep        output, 
             @po_separador_campo       = @subSep     output, 
             @po_c_error               = @po_c_error output, 
             @po_d_error               = @po_d_error output   
              
  if (@po_c_error  <> 0) 
    begin 
	  set @po_d_error = 'Error llamando a sp_separador_registros : ' + @po_d_error
      return     
  end   
   
  --inserto los telefonos de personas   
  set @l_telefonos = @pi_l_telefonos + @sep 
   
  --inserta cada uno de los telefonos de la lista 
  while (@l_telefonos is not null) 
  begin 
   
      set @sublista_tel    = substring(@l_telefonos,1,charindex(@sep,@l_telefonos)-1) + @subSep 
       
      execute sp_datos_tel  
                        @pi_sublista_tel    = @sublista_tel,  
                        @pi_subSep          = @subSep, 
                        @po_d_telefono      = @d_telefono      output, 
                        @po_c_tipo_telefono = @c_tipo_telefono output, 
                        @po_observaciones   = @observaciones   output, 
                        @po_c_error         = @po_c_error      output, 
                        @po_d_error         = @po_d_error      output 
 
      if (@po_c_error  <> 0) 
      begin 
		  set @po_d_error = 'Error llamando a sp_datos_tel : ' + @po_d_error  
          return              
      end 
       
      --antes de insertar controla q no exista ese num de telefono 
      if exists (select id_telefono 
                   from sagt_telefonos 
                  where id_persona     = @pi_id_persona 
                    and d_telefono = @d_telefono 
                )  
      begin 
          set @po_d_error = 'Los N?meros de telefonos deben ser ?nicos. Est? repitiendo el n?mero: '+  
                            convert(varchar,@d_telefono) 
          set @po_c_error = 2 
          return              
      end                               
 
      insert into sagt_telefonos  
             (id_persona,d_telefono,c_tipo_telefono,observaciones, c_usua_alta) 
      values (@pi_id_persona,@d_telefono,@c_tipo_telefono,@observaciones,@pi_id_usuario) 
       
      set @po_c_error = @@error     
      if (@po_c_error  <> 0) 
      begin 
          set @po_d_error = convert(varchar,@po_c_error) +  
                      ' - Error al insertar telefono de persona. ' 
          return              
      end 
 
      set @l_telefonos = substring(@l_telefonos, 
                                   charindex(@sep,@l_telefonos)+1,  
                                   char_length(@l_telefonos) 
                                   ) 
       
  end  --while       
 
end --sp_inserta_tel_per
 
go 

Grant Execute on dbo.sp_inserta_tel_per to GrpTrpSabed 
go

sp_procxmode 'sp_inserta_tel_per', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_inserta_tipo_beca'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_inserta_tipo_beca" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_inserta_tipo_beca (    
@pi_id_tipo_beca	numeric(18,0),   
@pi_d_tipo_beca	    varchar(40),   
@pi_id_usuario      numeric(18,0),   
@po_c_error         typ_c_error output,   
@po_d_error         typ_d_error output   
)   
   
as   
  
--Objetivo: mantener los valores del tipo de beca  
   
begin   
      
  if (@pi_id_usuario is null or @pi_id_usuario = 0)   
    begin   
      set @po_c_error = 3   
      set @po_d_error = 'No se recibi? usuario '   
      return          
  end   
   
  if (@pi_d_tipo_beca is null)   
    begin   
      set @po_c_error = 2   
      set @po_d_error = 'No se recibi? el detalle de la beca'   
      return          
  end   
  
  if exists (select id_tipo_beca
               from saat_tipo_beca
              where id_tipo_beca = @pi_id_tipo_beca
                and f_baja is not null 
             )         
  begin
      set @po_c_error = 2     
      set @po_d_error = 'El tipo de Beca est? dado de Baja, no puede modificarlo. '
      return            
  end  
    
  -- Evaluo si no esta superpuesto con otro periodo ya insetado   
  if @pi_id_tipo_beca is not null and @pi_id_tipo_beca <> 0 
    begin        
          
      -- ver actualizo el ultimo periodo   
      Update saat_tipo_beca  
         set d_tipo_beca=@pi_d_tipo_beca,   
             c_usua_actuac =@pi_id_usuario,   
             f_actuac = getdate()       
       where id_tipo_beca = @pi_id_tipo_beca   
          
      set @po_c_error = @@error       
      if (@po_c_error  <> 0)   
      begin    
        set @po_d_error = 'Error al actualizar el tipo de beca'   
        return   
      end   
          
    end   
   
  else   
    
    -- es un alta   
    begin   
       
      -- inserto la beca   
      insert into saat_tipo_beca   
                  (d_tipo_beca,c_usua_alta)    
           values (@pi_d_tipo_beca,@pi_id_usuario)   
   
      set @po_c_error = @@error       
      if (@po_c_error  <> 0)   
      begin    
        set @po_d_error = 'Error al insertar el tipo de beca'     
        return   
      end   
        
    end       
end  -- sp_inserta_tipo_beca
 
go 

Grant Execute on dbo.sp_inserta_tipo_beca to GrpTrpSabed 
go

sp_procxmode 'sp_inserta_tipo_beca', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_inserta_usuario'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_inserta_usuario" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_inserta_usuario (    
  @pi_id_usuario_logg  numeric(18,0),    
  @pi_id_persona       numeric(18,0),    
  @pi_d_user           varchar(40),     
  @pi_id_ong           numeric(18,0),    
  @pi_l_perfiles       typ_lista,    
  @pi_clave_defecto    varchar(40),  
  @po_id_usuario       numeric(18,0) output,    
  @po_c_error          typ_c_error output,    
  @po_d_error          typ_d_error output    
  )    
  as    
      
  --objetivo: inserta en usuarios con sus perfiles    
  --    
  ----obtiene el nivel de mensaje, de acuerdo al cual inserta en:    
  ----0--solo se inserta en usuario y usuarios por perfiles, con el id_persona    
  ----1--fund: personas_inst    
  ----2--ong: personas_inst    
  ----3--tutor: tutor    
  ----luego inserto en usuarios_perfiles    
  -------------------------------------------------------------------------------    
  begin    

    if (@pi_id_usuario_logg is null or @pi_id_usuario_logg = 0)    
      begin    
        set @po_c_error = 3  
        set @po_d_error = 'No se recibi? usuario '    
        return           
    end    
      
    if (@pi_id_persona is null or @pi_id_persona = 0)    
      begin    
        set @po_c_error = 3    
        set @po_d_error = 'No se recibi? id de persona '    
        return           
    end    
        
    if (@pi_d_user is null)    
      begin    
        set @po_c_error = 3    
        set @po_d_error = 'No se recibi? nombre de usuario '    
        return           
    end    
      
    if (@pi_l_perfiles  is null)    
      begin    
        set @po_c_error = 3 
        set @po_d_error = 'No se recibieron los perfiles'    
        return           
    end    
      
    declare     
     @aux                  varchar(250),    
     @l_perfiles           typ_lista,    
     @perfil               numeric(18,0),    
     @dummy                varchar(1),    
     @sep                  varchar(1),    
     @n_nivel              integer,    
     @id_fundacion         numeric(18,0),       
     @id_usuario           numeric(18,0),    
     @e_definitivo         varchar(1),    
     @n_existe             integer,
     @cant_fun             integer
         
    set @po_c_error            = 0    
    set @po_d_error            = null      
        
    --obtengo el separador de registros    
    execute sp_separador_registros    
               @po_separador_registro    = @sep        output,    
               @po_separador_campo       = @dummy      output,    
               @po_c_error               = @po_c_error output,    
               @po_d_error               = @po_d_error output      
                   
    if (@po_c_error  <> 0)    
      begin    
	    set @po_d_error = 'Error llamando a sp_separador_registros : ' + @po_d_error 
        return        
    end    
      
    set @l_perfiles = @pi_l_perfiles + @sep    
      
    --procedure q retorna los codigos del estado de registro definitivo    
    execute sp_obtiene_e_definitivo @po_c_valor  = @e_definitivo output,    
                                    @po_c_error  = @po_c_error output,    
                                    @po_d_error  = @po_d_error output    
                                     
    if (@po_c_error  <> 0)    
    begin    
	   set @po_d_error = 'Error llamando a sp_obtiene_e_definitivo : ' + @po_d_error	 
       return           
    end  
    
    --
    -- verifico que la persona asociada al usuario este en estado Definitivo
    If exists (select 1 
                 from sagt_personas
                Where id_persona = @pi_id_persona
                  and e_registro <> @e_definitivo)
      begin
        set @po_d_error = 'La persona no se encuentra en estado Definitivo'  
        set @po_c_error = 2  
        return  
    end
      
        
    --verifico que no sea un alumno     
    if exists (select id_alumno --100    
               from saat_alumnos    
               where id_persona = @pi_id_persona)    
    begin    
        set @po_d_error = 'La persona es un alumno en el Programa de Becas. '    
        set @po_c_error = 2                         
        return          
    end     
    
    --verifico que no sea un pariente de un alumno    
    if exists (select id_alumno --100    
               from saat_alumnos_parentesco    
               where id_persona_rel = @pi_id_persona)    
      begin    
        set @po_d_error = 'La persona pertenece al grupo familiar de un alumno del Programa de Becas. '    
        set @po_c_error = 2    
        return          
    end     

    --verifico que no ha sido usado el d_user
    
    --para el caso de tener un sagt_personas.n_documento duplicado (permitido por tener un tipo de doc. distinto),
    --no se permite duplicar el d_user y por esto debe considerarse de qu? manera se dar? el d_user a ese usuario
    if exists (select id_usuario
               from sast_usuarios
               where d_user = @pi_d_user)    
    begin    
        set @po_d_error = 'No puede realizar el alta del usuario '+@pi_d_user+ ', est? siendo usado ese identificador de usuario.'    
        set @po_c_error = 2                          
        return          
    end     
    
        
    begin tran insUsuario    
        
    --doy de alta el usuario    
    insert into sast_usuarios(id_persona,d_user,e_usuario,c_usua_alta)     
    values(@pi_id_persona,@pi_d_user, @e_definitivo, @pi_id_usuario_logg)    
      
    set @po_c_error = @@error        
      
    if (@po_c_error  <> 0)    
    begin    
        rollback tran insUsuario    
        set @po_d_error = convert(varchar, @po_c_error)     
                          + ' - Error al dar de alta en sast_usuarios. '    
        set @po_c_error = 3                            
        return      
    end    
      
    set @id_usuario = @@identity    
        
    --proceso lista de perfiles    
    while (@l_perfiles is not null)    
    begin    
        
            --obtengo un perfil    
            set @perfil = convert(numeric,       
                                 substring(@l_perfiles, 1,charindex(@sep,@l_perfiles)-1)    
                                  )    
                                      
                                      
            --obtengo el nivel de mensaje    
            select @n_nivel = n_nivel_mensaje    
              from sast_perfiles p    
             where p.id_perfil = @perfil    
              
            --limpio la variable que controla q no se repita la persona y su institucion o    
            --tutor    
            set @n_existe = 0    
              
            if @n_nivel = 1 --FUNDACION    
            begin    

                   --obtengo id de fundacion     
                   select @id_fundacion = o.id_ong    
                     from saft_ongs o              
                    where o.m_fundacion = 'S'    
                      and o.e_registro = @e_definitivo    
                        
                   if @id_fundacion is null      
                   begin    
                        rollback tran insUsuario    
                        set @po_d_error = 'Error, la Fundaci?n no fue dada de alta. '    
                        set @po_c_error = 2    
                        return           
                   end

                   --S?lo puede haber un registro de Fundacion 
                   select @cant_fun = count(o.id_ong)
                     from saft_ongs o              
                    where o.m_fundacion = 'S'    
                      and o.e_registro = @e_definitivo    
                        
                   if @cant_fun <> 1
                   begin    
                        rollback tran insUsuario    
                        set @po_d_error = 'Error, existe m?s de un registro de Fund. '    
                        set @po_c_error = 2    
                        return           
                   end            
                
                   select @n_existe = 1    
                     from saft_personas_ong    
                    where id_ong = @id_fundacion    
                     and  id_persona     = @pi_id_persona    
                     and  e_registro 	 = @e_definitivo    
                       
                   if @n_existe = 0    
                   begin    
                            insert into saft_personas_ong (id_ong, id_persona,    
                                                            e_registro, c_usua_alta)    
                                        values (@id_fundacion, @pi_id_persona,     
                                                @e_definitivo, @pi_id_usuario_logg)     
                             set @po_c_error = @@error    
                   end              
                   else    
                    -- 'ya existe la persona en personas inst. x lo tanto no la vuelvo a guardar'    
                       
                   if (@po_c_error  <> 0)    
                   begin    
                       rollback tran insUsuario    
                       set @po_d_error = convert(varchar,@po_c_error)     
                                         + ' - Error al insertar usuario de fundaci?n'    
                       set @po_c_error = 3                                   
                       return           
                   end     
            end --@n_nivel = 1 --FUNDACION    
            if  @n_nivel = 2 -- ONG    
            begin    
                
                 if @pi_id_ong is null or @pi_id_ong = 0
                 begin    
                      rollback tran insUsuario    
                      set @po_d_error = 'No se recibi? ong para insertar nivel 2 [' + convert(varchar,@pi_id_ong) + ']'
                      set @po_c_error = 3   
                      return                              
                 end
                 
                 if not exists ( select id_ong 
                                   from saft_ongs
                                  where id_ong = @pi_id_ong 
                               )
                 begin
                      rollback tran insUsuario    
                      set @po_d_error = 'La ong recibida no es v?lida; para insertar nivel 2 [' + convert(varchar,@pi_id_ong) + ']'
                      set @po_c_error = 3
                      return                                                   
                 end                               
            
                 select @n_existe = 1    
                   from saft_personas_ong    
                  where id_ong = @pi_id_ong    
                   and  id_persona     = @pi_id_persona    
                   and  e_registro = @e_definitivo    
                     
                 if @n_existe = 0    
                 begin    
                          insert into saft_personas_ong (id_ong, id_persona,e_registro, c_usua_alta)    
                          values (@pi_id_ong, @pi_id_persona,@e_definitivo, @pi_id_usuario_logg)     
                 
                          set @po_c_error = @@error    
                              
                 end                      
                                           
                 if (@po_c_error  <> 0)    
                 begin    
                     rollback tran insUsuario    
                     set @po_d_error = 'Error al insertar en saft_personas_ong, nivel 2'
                     return           
                 end      
                   
            end --@n_nivel = 2 -- ONG    
                   
            if @n_nivel = 3 -- TUTOR    
                    begin    
                        
                 if @pi_id_ong is null     
                 begin    
                      rollback tran insUsuario    
                      set @po_d_error = convert(varchar,@po_c_error) +     
                                       ' - No se recibi? ong'    
                      set @po_c_error = 3                               
                      return                              
                 end                            
                        select @n_existe = 1    
                          from saft_tutores    
                         where id_ong     = @pi_id_ong    
                           and id_persona = @pi_id_persona    
                           and e_registro = @e_definitivo    
                            
                        if @n_existe = 0    
                        begin    
                            insert into saft_tutores (id_ong,id_persona,     
                                                      e_registro, c_usua_alta)    
                            values (@pi_id_ong, @pi_id_persona,     
                                    @e_definitivo,@pi_id_usuario_logg)    
              
                            set @po_c_error = @@error    
                        end        
              
                        if (@po_c_error  <> 0)    
                        begin    
                           rollback tran insUsuario    
                           set @po_d_error = convert(varchar,@po_c_error) +     
                                            ' - Error al insertar en tutores'                                    
                           return           
                        end     
                            
            end  --@n_nivel = 3 -- TUTOR    
                
            --doy de alta cada uno de los perfiles del usuario    
            insert into sast_usuarios_perfiles (id_perfil, id_usuario, e_usu_perfil, c_usua_alta)    
            values (@perfil, @id_usuario, @e_definitivo, @pi_id_usuario_logg)       
              
            set @po_c_error = @@error        
            if (@po_c_error  <> 0)    
            begin    
                rollback tran insUsuario    
                set @po_d_error = convert(varchar, @po_c_error) +     
                                  'Error al dar de alta en usuarios_perfiles. '                                 
                return      
            end    
                
            set @l_perfiles = substring(@l_perfiles,    
                                       charindex(@sep,@l_perfiles)+1,     
                                       char_length(@l_perfiles)    
                                       )             
    end    --while    
        
    set @po_id_usuario = @id_usuario    
       
    set @po_c_error = @@error        
    if (@po_c_error  <> 0)    
    begin      
        rollback tran insUsuario    
        set @po_d_error = 'Error al dar de alta un usuario. '    
        set @po_c_error = 19060              
    end    
        
    -- commit tran insUsuario  -- Lo corri para la creacion del usuario de logueo   
       
    --   
    -- Creo el usuario para Logueo     
    execute sp_GuardarUsuario  @pi_usu_d_user         = @pi_d_user,   
                               @pi_usu_habilitado      = 'S',   
                               @pi_usu_estado	      = 'I',   
                               @pi_usu_clave1	      = '',   
                               @pi_usu_clave2	      = '',                                    
                               @pi_usu_clave3	      = '',   
                               @pi_usu_clave4	      = '',   
                               @pi_usu_int_fallidos   = 0,   
                               @pi_usu_clave	      = @pi_clave_defecto,    
                               @po_c_error            = @po_c_error output,        
                               @po_d_error            = @po_d_error output          
    if (@po_c_error  <> 0)        
      begin   
        rollback tran insUsuario    
        set @po_d_error = 'Error al dar de alta un usuario, loguin. llamando a : sp_GuardarUsuario' + @po_d_error          
    end   
       
    commit tran insUsuario   
       
end -- sp_inserta_usuario 
 
go 

Grant Execute on dbo.sp_inserta_usuario to GrpTrpSabed 
go

sp_procxmode 'sp_inserta_usuario', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_inserta_usuario_perfiles'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_inserta_usuario_perfiles" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_inserta_usuario_perfiles ( 
  @pi_id_usuario_logg  numeric(18,0), 
  @pi_id_usuario       numeric(18,0),   
  @pi_id_persona       numeric(18,0), 
  @pi_d_user           varchar(40),  
  @pi_id_ong           numeric(18,0), 
  @pi_l_perfiles       typ_lista,  
  @po_c_error          typ_c_error output, 
  @po_d_error          typ_d_error output 
  ) 
  as 
   
  --objetivo: inserta en usuarios con sus perfiles 
  -- 
  ----obtiene el nivel de mensaje, de acuerdo al cual inserta en: 
  ----0--solo se inserta en usuario y usuarios por perfiles, con el id_persona 
  ----1--fund: personas_inst 
  ----2--ong: personas_inst 
  ----3--tutor: tutor 
  ----luego inserto en usuarios_perfiles 
  ------------------------------------------------------------------------------- 
  begin 
   
    declare  
     @aux                  typ_lista, 
     @l_perfiles           typ_lista, 
     @perfil               numeric(18,0), 
     @dummy                varchar(1), 
     @sep                  varchar(1), 
     @n_nivel              integer, 
     @id_fundacion         numeric(18,0),    
     @e_definitivo         varchar(1), 
     @n_existe             integer 
      
    set @po_c_error            = 0 
    set @po_d_error            = null   
     
   
    --obtengo el separador de registros 
    execute sp_separador_registros 
               @po_separador_registro    = @sep        output, 
               @po_separador_campo       = @dummy      output, 
               @po_c_error               = @po_c_error output, 
               @po_d_error               = @po_d_error output   
                
    if (@po_c_error  <> 0) 
      begin 
		set @po_d_error = 'Error llamando a sp_separador_registros : ' + @po_d_error
        return     
    end 
   
    set @l_perfiles            = @pi_l_perfiles + @sep 
   
   
    --procedure q retorna los codigos del estado de registro definitivo 
    execute sp_obtiene_e_definitivo @po_c_valor  = @e_definitivo output, 
                                    @po_c_error  = @po_c_error output, 
                                    @po_d_error  = @po_d_error output 
                                  
    if (@po_c_error  <> 0) 
    begin 
	   set @po_d_error = 'Error llamando a sp_obtiene_e_definitivo : ' + @po_d_error	
       return        
    end 
     
    --proceso lista de perfiles 
    while (@l_perfiles is not null) 
    begin 
     
            --obtengo un perfil 
            set @perfil = convert(numeric,    
                                 substring(@l_perfiles, 1,charindex(@sep,@l_perfiles)-1) 
                                  ) 
                                   
                                   
            --obtengo el nivel de mensaje 
            select @n_nivel = n_nivel_mensaje 
              from sast_perfiles p 
             where p.id_perfil = @perfil 
           
            --limpio la variable que controla q no se repita la persona y su institucion o 
            --tutor 
            set @n_existe = 0 
           
            if @n_nivel = 1 --FUNDACION 
            begin 
             
                   --obtengo id de fundacion  
                   select @id_fundacion = o.id_ong 
                     from saft_ongs o           
                    where o.m_fundacion = 'S' 
                      and o.e_registro = @e_definitivo 
                     
                   if @id_fundacion is null   
                   begin 
                        --rollback tran insUsuario 
                        set @po_d_error = 'La Fundaci?n no fue dada de alta. ' 
                        set @po_c_error = 2 
                        return        
                   end   
                     
                   select @n_existe = 1 
                     from saft_personas_ong 
                    where id_ong = @id_fundacion 
                     and  id_persona     = @pi_id_persona 
                     and  e_registro = @e_definitivo 
                    
                   if @n_existe = 0 
                   begin 
                            insert into saft_personas_ong (id_ong, id_persona, 
                                                            e_registro, c_usua_alta) 
                                        values (@id_fundacion, @pi_id_persona,  
                                                @e_definitivo, @pi_id_usuario_logg)  
                             set @po_c_error = @@error 
                   end           
                   else 
                    -- 'ya existe la persona en personas inst. x lo tanto no la vuelvo a guardar' 
                    
                   if (@po_c_error  <> 0) 
                   begin 
                       --rollback tran insUsuario 
                       set @po_d_error = convert(varchar,@po_c_error)  
                                         + ' - Error al insertar usuario de fundaci?n'                                 
                       return        
                   end  
            end --@n_nivel = 1 --FUNDACION 
            if  @n_nivel = 2 -- ONG 
            begin 
             
                 if @pi_id_ong is null  
                 begin 
                      --rollback tran insUsuario 
                      set @po_d_error = convert(varchar,@po_c_error) +  
                                       ' - No se recibi? ong' 
                      set @po_c_error = 2                            
                      return                           
                 end 
         
                 select @n_existe = 1 
                   from saft_personas_ong 
                  where id_ong = @pi_id_ong 
                   and  id_persona     = @pi_id_persona 
                   and  e_registro = @e_definitivo 
                  
                 if @n_existe = 0 
                 begin 
                          insert into saft_personas_ong (id_ong, id_persona,e_registro, c_usua_alta) 
                          values (@pi_id_ong, @pi_id_persona,@e_definitivo, @pi_id_usuario_logg)  
              
                          set @po_c_error = @@error 
                           
                 end                   
                                        
                 if (@po_c_error  <> 0) 
                 begin 
                     --rollback tran insUsuario 
                     set @po_d_error = convert(varchar,@po_c_error) +  
                                       ' - Error al insertar usuario de ong'                             
                     return        
                 end   
                
            end --@n_nivel = 2 -- ONG 
                
            if @n_nivel = 3 -- TUTOR 
                    begin 
                     
                 if @pi_id_ong is null  
                 begin 
                      --rollback tran insUsuario 
                      set @po_d_error = convert(varchar,@po_c_error) +  
                                       ' - No se recibi? ong' 
                      set @po_c_error = 2                           
                      return                           
                 end                         
                        select @n_existe = 1 
                          from saft_tutores 
                         where id_ong     = @pi_id_ong 
                           and id_persona = @pi_id_persona 
                           and e_registro = @e_definitivo 
                         
                        if @n_existe = 0 
                        begin 
                            insert into saft_tutores (id_ong,id_persona,  
                                                      e_registro, c_usua_alta) 
                            values (@pi_id_ong, @pi_id_persona,  
                                    @e_definitivo,@pi_id_usuario_logg) 
           
                            set @po_c_error = @@error 
                        end     
           
                        if (@po_c_error  <> 0) 
                        begin 
                           rollback tran insUsuario 
                           set @po_d_error = convert(varchar,@po_c_error) +  
                                            ' - Error al insertar en tutores'                                
                           return        
                        end  
                         
            end  --@n_nivel = 3 -- TUTOR 
             
            --doy de alta cada uno de los perfiles del usuario 
            insert into sast_usuarios_perfiles (id_perfil, id_usuario, e_usu_perfil, c_usua_alta) 
            values (@perfil, @pi_id_usuario, @e_definitivo, @pi_id_usuario_logg)    
           
            set @po_c_error = @@error     
            if (@po_c_error  <> 0) 
            begin 
                --rollback tran insUsuario 
                set @po_d_error = convert(varchar, @po_c_error) +  
                                  'Error al dar de alta en usuarios_perfiles. '                            
                return   
            end 
             
            set @l_perfiles = substring(@l_perfiles, 
                                       charindex(@sep,@l_perfiles)+1,  
                                       char_length(@l_perfiles) 
                                       )          
    end    --while 
     
     
   
    --set @po_id_usuario = @id_usuario 
     
    set @po_c_error = @@error     
    if (@po_c_error  <> 0) 
    begin   
        --rollback tran insUsuario 
        set @po_d_error = 'Error al dar de alta un usuario. '           
    end 
     
    --commit tran insUsuario 
end --sp_inserta_usuario_perfiles
 
go 

Grant Execute on dbo.sp_inserta_usuario_perfiles to GrpTrpSabed 
go

sp_procxmode 'sp_inserta_usuario_perfiles', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_lista_colegio'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_lista_colegio" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_lista_colegio ( 
@pi_id_colegio  numeric(18,0),
@po_c_error     typ_c_error output, 
@po_d_error     typ_d_error output 
) 
as 
------------------------------------------------------------------- 
--Objetivo: Obtener los colegios del sistema 
--Par?metros de entrada: ID_COLEGIO
--Par?metros de salida:  
--      cursor con los valores los colegios,  
--po_c_error y po_d_error 
-------------------------------------------------------------------  
 
 
begin 
   
  declare @cant_filas int
  
  set @po_c_error = 0 
  set @po_d_error = null 
   
  Select id_colegio, d_nombre_colegio
    from sagt_colegios
   where e_registro ='D'
     and (id_colegio = @pi_id_colegio 
          or @pi_id_colegio is null)
   order by d_nombre_colegio

  set @po_c_error = @@error,
      @cant_filas = @@rowcount 

  if (@po_c_error  <> 0) 
    begin   
      set @po_d_error = 'Error al consultar los colegios' 
    end 

  if (@cant_filas = 0) 
    begin 
      set @po_c_error = 1 
      set @po_d_error = 'No se encontraron colegios en el sistema' 
      return       
    end 

 
end --sp_lista_colegio
 
go 

Grant Execute on dbo.sp_lista_colegio to GrpTrpSabed 
go

sp_procxmode 'sp_lista_colegio', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_lista_noticia'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_lista_noticia" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_lista_noticia (     
@po_c_error     	typ_c_error output,    
@po_d_error     	typ_d_error output    
)    
as    
-------------------------------------------------------------------    
--Objetivo: Obtener las noticias del sistema    
--Par?metros de entrada:   
--	ID_NOTICIA   
--Par?metros de salida:     
--      cursor con los valores las noticias     
--po_c_error y po_d_error    
-------------------------------------------------------------------     
begin    
    
  set @po_c_error = 0    
  set @po_d_error = null    
      
  select id_noticia,   
            x_titulo,   
            x_copete,   
         x_cuerpo_mensaje,  
         convert(char(12),f_vigencia_desde,112) f_vigencia_desde,  
         convert(char(12),f_vigencia_hasta,112) f_vigencia_hasta, 
         convert(char(12),f_baja,112) f_baja 
    from saft_noticias   
      order by f_vigencia_desde,f_vigencia_hasta  
  
  set @po_c_error = @@error       
  if (@po_c_error  <> 0)    
    begin      
      set @po_d_error = 'Error al consultar los noticias'          
  end    
end -- sp_lista_noticia
 
go 

Grant Execute on dbo.sp_lista_noticia to GrpTrpSabed 
go

sp_procxmode 'sp_lista_noticia', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_lista_nro_recargas'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_lista_nro_recargas" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_lista_nro_recargas(
@po_lista           typ_lista   output,     
@po_c_error         typ_c_error output,  
@po_d_error         typ_d_error output  
)
as
begin

declare 
    @cant      int,
    @i         int,  
    @sep       varchar(1),  
    @subSep    varchar(1)

  --obtengo los separadores de registros y de campos  
  execute sp_separador_registros   
                              @po_separador_registro = @sep        output,   
                              @po_separador_campo    = @subSep     output,   
                              @po_c_error            = @po_c_error output,   
                              @po_d_error            = @po_d_error output   
   
    if (@po_c_error  <> 0)   
    begin   
	  set @po_d_error = 'Error llamando a sp_separador_registros : ' + @po_d_error 
      return          
    end

select @cant = convert(numeric,d_valor)
from sapt_parametros
where id_parametro = 136

set @po_lista = 'N' + @sep + 'S'
set @i = 2 

while @i <= @cant 
begin
    set @po_lista = @po_lista + @sep + convert(varchar,@i)
    set @i = @i + 1
end

end --sp_lista_nro_recargas
 
go 

Grant Execute on dbo.sp_lista_nro_recargas to GrpTrpSabed 
go

sp_procxmode 'sp_lista_nro_recargas', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_lista_ong'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_lista_ong" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_lista_ong (   
@pi_id_ong      numeric(18,0),  
@po_c_error     typ_c_error output,   
@po_d_error     typ_d_error output   
)   
as   
-------------------------------------------------------------------   
--Objetivo: Obtener las ongs del sistema   
--Par?metros de entrada: ID_ONG  
--Par?metros de salida:    
--      cursor con los valores las ongs,    
--po_c_error y po_d_error   
-------------------------------------------------------------------    
   
   
begin   
     
  declare @cant_filas int  
    
  set @po_c_error = 0   
  set @po_d_error = null   
     
  Select id_ong, d_nombre_ong, c_tipo_ong  
   from saft_ongs  
  where e_registro ='D'  
    and (id_ong = @pi_id_ong or isnull(@pi_id_ong,0)=0)  
    and m_fundacion='N'
  order by d_nombre_ong  
  
  set @po_c_error = @@error,  
      @cant_filas = @@rowcount  
   
  if (@po_c_error  <> 0)   
    begin     
      set @po_d_error = 'Error al consultar las ongs'   
    end   
  
  if (@cant_filas = 0)   
    begin   
      set @po_c_error = 1   
      set @po_d_error = 'No se encontraron ongs en el sistema'   
      return         
    end   
   
end -- sp_lista_ong 
 
go 

Grant Execute on dbo.sp_lista_ong to GrpTrpSabed 
go

sp_procxmode 'sp_lista_ong', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_logueo'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_logueo" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_logueo( 
@po_c_error         typ_c_error output, 
@po_d_error         typ_d_error output 
) 
as 
/* 
Objetivo: obtener los usuarios de prueba de la aplicacion 
*/ 
 
begin 
 
  set @po_c_error = 0 
  set @po_d_error = null 
   
  select u.d_user,p.d_nombre  + '; ' + d_apellido nombre_usuario 
   from sast_usuarios u, 
        sagt_personas p 
  where p.id_persona = u.id_persona 
    --and u.id_usuario in (154) 
    order by n_documento 
   
  set @po_c_error = @@error     
 
  if (@po_c_error  <> 0) 
    begin  
      set @po_d_error =  convert(varchar,@po_c_error)  
                         + ' - Error al obtener usuarios. ' 
  end 
end --sp_logueo
 
go 

Grant Execute on dbo.sp_logueo to GrpTrpSabed 
go

sp_procxmode 'sp_logueo', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_lotes_pago_archivo'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_lotes_pago_archivo" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_lotes_pago_archivo (    
@po_c_error   typ_c_error   output,    
@po_d_error   typ_d_error   output    
)    
as    
--    
--objetivo: obtener la carga de ONGs que se encuentran en Guardar Avance    
--    
    
begin    
    
  set @po_c_error = 0    
  set @po_d_error = null    
    
  select lp.id_lote_pago,convert (varchar(10),lp.f_recarga,112) f_recarga  
    from sart_lotes_pago lp    
   where lp.e_lote_pago in ('PENDIENTE','GENERADO') 
   order by lp.f_recarga  
    
  set @po_c_error = @@error        
  if (@po_c_error  <> 0)    
    begin     
      set @po_d_error =  'Error en al intentar obtener los ID de lote de pago '    
      return    
  end    
end -- sp_lotes_pago_archivo
 
go 

Grant Execute on dbo.sp_lotes_pago_archivo to GrpTrpSabed 
go

sp_procxmode 'sp_lotes_pago_archivo', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_modifica_alu_tutores'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_modifica_alu_tutores" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_modifica_alu_tutores(
@pi_id_usuario      numeric(18,0),
@pi_id_alumno       numeric(18,0),
@pi_id_tutor_adm    numeric(18,0), 
@pi_id_tutor_ped    numeric(18,0), 
@pi_e_alumno        varchar(15),  
@po_c_error         typ_c_error output,
@po_d_error         typ_d_error output
)
as
/*
Objetivo: Modifica los tutores s?lo si el alumno est? siendo CANDIDATEADO
*/

begin

  if (@pi_id_usuario is null or @pi_id_usuario = 0)
    begin
      set @po_c_error = 3
      set @po_d_error = 'No se recibi? pi_id_usuario'
      return       
  end

  declare 
    @id_tutor_adm_act    numeric(18,0), 
    @id_tutor_ped_act    numeric(18,0)

  set @po_c_error = 0
  set @po_d_error = null
  
  --verifico que est?n modificando los tutores (tutor nuevo <> actual) y de ser asi
  --s?lo lo permito si el alumno a?n es candidato
  
  select @id_tutor_adm_act = id_tutor
  from saav_alu_tut_ong
  where id_alumno = @pi_id_alumno 
    and id_perfil_tutor = 1
     
  if @id_tutor_adm_act <> @pi_id_tutor_adm
  begin
     if @pi_e_alumno in ('CANDIDATO')
     begin

          update sagt_alumnos_tutores
          set id_tutor = @pi_id_tutor_adm,
              c_usua_actuac = @pi_id_usuario,
              f_actuac = getDate()  
          where id_alumno = @pi_id_alumno
            and id_perfil = 1
        
          set @po_c_error = @@error      
          
          if (@po_c_error  <> 0)
          begin 
              set @po_d_error =  'Error al modificar el Tutor Adm. '
              set @po_c_error = @po_c_error      
              return
          end

     end 
     else --el alumno no es candidato, no puede modificar sus tutores por ac?
     begin
         set @po_c_error = 2 
         set @po_d_error = 'No puede modificar Tutor Administrativo al alumno '+ @pi_e_alumno
         return     
     end
  end

  select @id_tutor_ped_act = id_tutor
  from saav_alu_tut_ong
  where id_alumno = @pi_id_alumno 
    and id_perfil_tutor = 2
     
  if @id_tutor_ped_act <> @pi_id_tutor_ped
  begin
     if @pi_e_alumno in ('CANDIDATO')
     begin

          update sagt_alumnos_tutores
          set id_tutor = @pi_id_tutor_ped,
              c_usua_actuac = @pi_id_usuario,
              f_actuac = getDate()  
          where id_alumno = @pi_id_alumno
            and id_perfil = 2
            
          set @po_c_error = @@error      
          if (@po_c_error  <> 0)
          begin 
              set @po_d_error =  'Error al modificar el Tutor Ped. '
              return
          end
     end 
     else --el alumno no es candidato, no puede modificar sus tutores por ac?
     begin
         set @po_c_error = 2 
         set @po_d_error = 'No puede modificar Tutor Pedag?gico al alumno '+ @pi_e_alumno
         return     
     end
  end          

end --sp_modifica_alu_tutores
 
go 

Grant Execute on dbo.sp_modifica_alu_tutores to GrpTrpSabed 
go

sp_procxmode 'sp_modifica_alu_tutores', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_modifica_candidato'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_modifica_candidato" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_modifica_candidato(     

 @pi_id_usuario          numeric(18,0),      

 @pi_id_alumno           numeric(18,0),         

 @pi_id_colegio          numeric(18,0),           

 @pi_c_anio_curso        varchar(40),           

 @pi_c_orient_colegio    numeric(18,0),           

 @pi_c_modal_col         numeric(18,0),      

 @pi_e_registro          char(1),      

 @pi_l_fliares           typ_lista,     

 @pi_e_alumno            varchar(15),       

 @pi_x_observaciones     varchar(250),     

 @pi_id_tutor_adm        numeric(18,0),      

 @pi_id_tutor_ped        numeric(18,0),    

 @pi_id_grupo     	     numeric(18,0),      

 @pi_c_cant_cuotas       numeric(18,0),         

 @po_c_error             typ_c_error output,      

 @po_d_error             typ_d_error output      

)      

as      

      

--objetivo: modificar datos del candidato a la beca     

--     

      

begin      

     

  --     

  -- Valido los par?metros de entrada     

  if (@pi_id_usuario is null or @pi_id_usuario = 0)      

    begin      

      set @po_c_error = 3     

      set @po_d_error = 'No se recibi? pi_id_usuario'      

      return             

    end      

        

  if (@pi_id_alumno is null or @pi_id_alumno = 0)      

    begin      

      set @po_c_error = 3     

      set @po_d_error = 'No se recibi? pi_id_alumno'      

      return             

    end      

         

  if (@pi_id_colegio is null or @pi_id_colegio = 0)      

    begin      

      set @po_c_error = 2 

      set @po_d_error = 'Debe seleccionar un colegio'     

      return             

    end         

     

  if (isnull(@pi_id_tutor_ped,0) = 0)      

    begin      

      set @po_c_error = 2     

      set @po_d_error = 'Debe seleccionar un tutor pedag?gico'     

      return             

    end      

     

  if (isnull(@pi_id_tutor_adm,0) = 0)      

    begin      

      set @po_c_error = 2 

      set @po_d_error = 'Debe seleccionar un tutor administrativo'     

      return             

    end      

      

 if @pi_c_orient_colegio = 0 set @pi_c_orient_colegio = null     

 if @pi_c_modal_col = 0 set @pi_c_modal_col = null             

     

  declare @valido       char(1),  

          @e_definitivo varchar(1), 

          @e_avance     varchar(1) 

  	     

  set @po_c_error = 0      

  set @po_d_error = null      

   

  --  

  -- Veo si la persona esta en estado definitivo  

  --procedure q retorna los codigos del estado de registro definitivo    

  execute sp_obtiene_e_definitivo   @po_c_valor  = @e_definitivo output,    

                                    @po_c_error  = @po_c_error output,    

                                    @po_d_error  = @po_d_error output    

                                   

  if (@po_c_error  <> 0)    

    begin    

      set @po_d_error = 'Error llamando a sp_obtiene_e_definitivo : ' + @po_d_error	     

      return           

  end  

    

  If not exists (select 1   

                   from sagt_personas per,  

                        saat_alumnos alu  

                  where alu.id_alumno = @pi_id_alumno  

                    and per.id_persona=alu.id_persona   

                    and per.e_registro=@e_definitivo)  

    begin  

      set @po_c_error = 2  

      set @po_d_error = 'La persona no se encuentra en estado definitivo'	     

      return      

  end  

   

  -- 

  -- me fijo si el alumno estaba en estado definitivo  

  -- y la quieren pasar a Guardar Avance 

  execute sp_obtiene_e_avance @po_c_valor  = @e_avance output,    

                              @po_c_error  = @po_c_error output,    

                              @po_d_error  = @po_d_error output    

                                   

  if (@po_c_error  <> 0)    

    begin    

      set @po_d_error = 'Error llamando a sp_obtiene_e_avance : ' + @po_d_error	     

      return           

  end 

   

  If @e_avance = @pi_e_registro and exists (Select 1  

                                              from saat_alumnos 

                                             where id_alumno  = @pi_id_alumno 

                                               and e_registro = @e_definitivo)  

    Begin 

      set @po_c_error = 2  

      set @po_d_error = 'El alumno esta en estado definitivo, no se puede guardar avance'	     

      return               

  end 

     

  begin tran mod_candidato     

   

  --s?lo se modifican si el alumno se encuentra en CANDIDATO 

  execute sp_modifica_alu_tutores       

                @pi_id_usuario   = @pi_id_usuario,     

                @pi_id_alumno    = @pi_id_alumno,     

                @pi_id_tutor_adm = @pi_id_tutor_adm,     

                @pi_id_tutor_ped = @pi_id_tutor_ped,     

                @pi_e_alumno     = @pi_e_alumno, 

                @po_c_error      = @po_c_error output,     

                @po_d_error      = @po_d_error output     

                 

  if (@po_c_error  <> 0)     

  begin     

      rollback tran mod_candidato          

      return         

  end   

   

  update saat_alumnos     

  set  id_colegio       = @pi_id_colegio,     

       e_alumno         = @pi_e_alumno,      

       d_anio_curso     = @pi_c_anio_curso,     

       c_orient_colegio = @pi_c_orient_colegio,     

       c_modal_col      = @pi_c_modal_col,     

       e_registro       = @pi_e_registro,     

       c_usua_actuac    = @pi_id_usuario,   

       id_grupo         = @pi_id_grupo,     

       c_cant_cuotas    = @pi_c_cant_cuotas,        

       f_actuac         = getDate()     

   where id_alumno = @pi_id_alumno            

            

  set @po_c_error = @@error        

  if (@po_c_error  <> 0)      

  begin        

      rollback tran mod_candidato     

      set @po_d_error = 'Error al intentar modificar candidato llamando a saat_alumnos : ' + @po_d_error    

      return     

  end      

   

  -- 

  -- modifico la Observacion que corresponde 

  If @pi_e_alumno in ('BECADO','ELIMINADO','RECHAZADO') 

    begin 

      update saat_alumnos 

         set x_observ_resul_prop = @pi_x_observaciones 

       where id_alumno = @pi_id_alumno 

      set @po_c_error = @@error        

      if (@po_c_error  <> 0)      

        begin        

          rollback tran mod_candidato     

          set @po_d_error = 'Error al intentar modificar la observacion del estado ' + @pi_e_alumno 

          return     

      end    

  end 

 

  If @pi_e_alumno in ('CANDIDATO','COMPLETADO') 

    begin 

      update saat_alumnos 

         set x_observaciones = @pi_x_observaciones 

       where id_alumno = @pi_id_alumno 

      set @po_c_error = @@error        

      if (@po_c_error  <> 0)      

        begin        

          rollback tran mod_candidato     

          set @po_d_error = 'Error al intentar modificar la observacion del estado ' + @pi_e_alumno 

          return     

      end    

  end 

   

  If @pi_e_alumno in ('BAJABECA') 

    begin 

      update saat_alumnos 

         set x_observ_baja = @pi_x_observaciones 

       where id_alumno = @pi_id_alumno 

      set @po_c_error = @@error        

      if (@po_c_error  <> 0)      

        begin        

          rollback tran mod_candidato     

          set @po_d_error = 'Error al intentar modificar la observacion del estado ' + @pi_e_alumno 

          return     

      end    

  end   

   

  If @pi_e_alumno in ('SUSPENDIDO') 

    begin 

      update saat_alumnos 

         set x_motivo_suspension = @pi_x_observaciones 

       where id_alumno = @pi_id_alumno 

      set @po_c_error = @@error        

      if (@po_c_error  <> 0)      

        begin        

          rollback tran mod_candidato     

          set @po_d_error = 'Error al intentar modificar la observacion del estado ' + @pi_e_alumno 

          return     

      end    

  end  

   

  If @pi_e_alumno in ('POSTULANTE') 

    begin 

      update saat_alumnos 

         set x_observ_prop = @pi_x_observaciones 

       where id_alumno = @pi_id_alumno 

      set @po_c_error = @@error        

      if (@po_c_error  <> 0)      

        begin        

          rollback tran mod_candidato     

          set @po_d_error = 'Error al intentar modificar la observacion del estado ' + @pi_e_alumno 

          return     

      end    

  end  

   

  if char_length(@pi_l_fliares) > 1      

  begin        

     

          if @pi_e_registro = 'D'     

          begin   

                --antes de updatear el nuevo grupo fliar      

                --verifico q no cambien el titular     

                execute sp_valida_titular_de_lista      

                      @pi_id_alumno    = @pi_id_alumno,     

                      @pi_l_fliares    = @pi_l_fliares,     

      		      @po_valido       = @valido     output,     

                      @po_c_error      = @po_c_error output,     

                      @po_d_error      = @po_d_error output     

                           

                if (@po_c_error  <> 0)     

                begin     

                     rollback tran mod_candidato     

                     return         

                end      

          end    

               

          if @valido = 'S'                    

          begin     

                  delete from saat_alumnos_parentesco     

                  where id_alumno = @pi_id_alumno     

                       

                  set @po_c_error = @@error       

                       

                  if (@po_c_error  <> 0)     

                  begin     

                      rollback tran mod_candidato     

                      set @po_d_error = 'Error al intentar limpiar el grupo familiar'      

                      return         

                  end               

                       

                  execute sp_inserta_grupo_fliar      

                        @pi_id_usuario = @pi_id_usuario,     

                        @pi_id_alumno  = @pi_id_alumno,     

                        @pi_l_fliares  = @pi_l_fliares,      

                        @pi_e_registro = @pi_e_registro,   

                        @po_c_error    = @po_c_error output,     

                        @po_d_error    = @po_d_error output       

                       

                  if (@po_c_error  <> 0)     

                  begin     

                      rollback tran mod_candidato     

                      return         

                  end       

          end     

          else  

          if @valido = 'N' 

          begin     

              rollback tran mod_candidato     

              set @po_c_error = 3     

              --set @po_d_error = '['+@valido+']'+  'Errores al modificar grupo familiar - sp_valida_titular_de_lista. ' + @po_d_error +' - alumno: '+convert(varchar,@pi_id_alumno)+' - fliares: '+@pi_l_fliares 

              set @po_d_error = 'Errores al modificar grupo familiar - sp_valida_titular_de_lista. '+ @po_d_error 

              return     

          end     

                

  end     

       

  commit tran mod_candidato       

       

end
 
go 

Grant Execute on dbo.sp_modifica_candidato to GrpTrpSabed 
go

sp_procxmode 'sp_modifica_candidato', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_modifica_colegio'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_modifica_colegio" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_modifica_colegio ( 
@pi_id_colegio           numeric(18,0), 
@pi_d_cuit               varchar(40), 
@pi_d_mail               varchar(40), 
@pi_d_calle		 varchar(40), 
@pi_d_nro		 varchar(40), 
@pi_d_piso		 varchar(40), 
@pi_d_depto		 varchar(40), 
@pi_d_localidad          varchar(40), 
@pi_c_provincia          numeric(18,0), 
@pi_d_nombre_directora   varchar(40), 
@pi_d_nombre_colegio     varchar(40), 
@pi_c_usua_actuac        numeric(18,0), 
@pi_e_registro           varchar(1), 
@po_c_error      	 typ_c_error output, 
@po_d_error              typ_d_error output 
) 
as 
-------------------------------------------  
------------------------ 
--Objetivo: Modifica de ONG.  
--Par?metros de entrada: 
--	ID_COLEGIO 
--	D_NOMBRE_DIRECTORA 
--	D_NOMBRE_COLEGIO 
--	C_USUA_ACTUAC 
--  E_REGISTRO 
--Par?metros de salida: po_c_error y po_d_error 
------------------------------------------------------------------- 
 
begin 
 
  set @po_c_error = 0 
  set @po_d_error = null 
 
  update sagt_colegios 
     set d_cuit 	    	= @pi_d_cuit, 
         d_mail 	    	= @pi_d_mail, 
         d_calle 	    	= @pi_d_calle, 
         d_nro 		    	= @pi_d_nro, 
         d_piso 	    	= @pi_d_piso, 
         d_depto 	    	= @pi_d_depto, 
         d_localidad 	    = @pi_d_localidad, 
         c_provincia        = @pi_c_provincia,   
         d_nombre_directora = upper(@pi_d_nombre_directora), 
         d_nombre_colegio   = upper(@pi_d_nombre_colegio), 
         e_registro         = @pi_e_registro, 
         c_usua_actuac      = @pi_c_usua_actuac, 
         f_actuac           = getDate() 
  where id_colegio = @pi_id_colegio 
 
  set @po_c_error = @@error     
 
  if (@po_c_error  <> 0) 
    begin  
      set @po_d_error =  'Error ' + convert(varchar,@po_c_error)  
                         + ' llamando a sagt_colegios : ' + @po_d_error
  end 
   
end --sp_modifica_colegio
 
go 

Grant Execute on dbo.sp_modifica_colegio to GrpTrpSabed 
go

sp_procxmode 'sp_modifica_colegio', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_modifica_datos_colegio'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_modifica_datos_colegio" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_modifica_datos_colegio (  
@pi_id_colegio          numeric(18,0),   
@pi_d_cuit              varchar(40),   
@pi_l_telefonos         varchar(250),  
@pi_d_mail              varchar(40),   
@pi_d_calle	        	varchar(40),   
@pi_d_nro				varchar(40),   
@pi_d_piso				varchar(40),   
@pi_d_depto				varchar(40),   
@pi_d_localidad         varchar(40),   
@pi_c_provincia         numeric(18,0),   
@pi_e_registro          varchar(1),  
@pi_c_usua_actuac       numeric(18,0),  
@pi_d_nombre_directora  varchar(40),  
@pi_d_nombre_colegio    varchar(40),  
@po_c_error      	typ_c_error output,  
@po_d_error      	typ_d_error output  
)  
as  
-------------------------------------------   
------------------------  
--Objetivo: Modificacion de Colegio y sus telefonos.   
--Par?metros de entrada:  	  
--	ID_COLEGIO 
--	D_cuit               
--	D_MAIL                 
--	D_CALLE				  
--	D_NRO				  
--	D_PISO				  
--	D_DEPTO				  
--	D_LOCALIDAD        
--	C_PROVINCIA           
--	D_NOMBRE_DIRECTORA    
--	D_NOMBRE_COLEGIO      
--	PI_C_USUA_ACTUAC       
--  E_REGISTRO      
--Par?metros de salida: po_c_error y po_d_error  
-------------------------------------------------------------------  
  
begin  
 
  if (@pi_id_colegio is null or @pi_id_colegio = 0)
    begin 
      set @po_c_error = 3 
      set @po_d_error = 'No se recibi? identificaci?n de colegio' 
      return        
  end 
   
  if (@pi_d_nombre_colegio is null) 
    begin 
      set @po_c_error = 2
      set @po_d_error = 'No se recibi? nombre colegio' 
      return        
  end   
   
  if (@pi_d_localidad is null) 
    begin 
      set @po_c_error = 2 
      set @po_d_error = 'No se recibi? localidad' 
      return        
  end 
   
  if (@pi_c_provincia = 0) 
    begin 
      set @po_c_error = 2 
      set @po_d_error = 'No se recibi? provincia' 
      return        
  end 
   
 
  if (@pi_c_usua_actuac is null) 
    begin 
      set @po_c_error = 2 
      set @po_d_error = 'No se recibi? usuario'   
      return        
  end 
 
  if (@pi_e_registro is null) 
    begin 
      set @po_c_error = 2 
      set @po_d_error = 'No se recibi? el estado de registro'  
      return        
  end 
   
  --insert into sabed_log (descrip) values (convert(varchar , @pi_id_colegio)) 
   
  if exists (select id_colegio 
               from sagt_colegios c                
              where c.id_colegio =  @pi_id_colegio 
                 and c.e_registro = 'B' 
                --and c.f_baja is not null 
             )       
  begin            
      set @po_c_error = 1 
      set @po_d_error = 'El colegio: ' + @pi_d_nombre_colegio + 
                        ' fue dado de baja. ' 
      return 
  end   
 
  if exists (select id_colegio 
               from sagt_colegios c                
              where c.d_nombre_colegio = @pi_d_nombre_colegio 
                and c.d_localidad      = @pi_d_localidad 
                and c.c_provincia      = @pi_c_provincia 
                and c.id_colegio       <> @pi_id_colegio 
             )       
  begin            
      set @po_c_error = 2 
      set @po_d_error = 'Ya existe el colegio: ' + @pi_d_nombre_colegio + 
                        ' en esa provincia y localidad. ' 
      return 
  end  
   
  begin tran modifica  
 
  execute sp_modifica_colegio 	 
	@pi_id_colegio           = @pi_id_colegio, 
	@pi_d_cuit               = @pi_d_cuit, 
	@pi_d_mail               = @pi_d_mail, 
	@pi_d_calle		 		 = @pi_d_calle, 
	@pi_d_nro		 		 = @pi_d_nro, 
	@pi_d_piso		 		 = @pi_d_piso, 
	@pi_d_depto		 		 = @pi_d_depto, 
	@pi_d_localidad          = @pi_d_localidad, 
	@pi_c_provincia          = @pi_c_provincia, 
  	@pi_d_nombre_directora   = @pi_d_nombre_directora, 
  	@pi_d_nombre_colegio     = @pi_d_nombre_colegio, 
  	@pi_c_usua_actuac        = @pi_c_usua_actuac, 
  	@pi_e_registro           = @pi_e_registro, 
  	@po_c_error      	 	 = @po_c_error output,  
  	@po_d_error              = @po_d_error output  
  					 
    if (@po_c_error  <> 0)   
      begin  
        rollback tran modifica 
		set @po_d_error = 'Error llamando a sp_modifica_colegio : ' + @po_d_error
        return          
      end     
   
 delete from sagt_telefonos 
 where id_colegio = @pi_id_colegio 
   
 set @po_c_error = @@error     
 if (@po_c_error  <> 0) 
 begin 
          rollback tran modifica   
          set @po_d_error =  convert(varchar,@po_c_error)  
                         + ' - Error al limpiar telefonos de colegio. '                            
          return              
 end  
   
 --if @pi_l_telefonos is not null 
 if char_length(@pi_l_telefonos) > 1 
   
 begin   
  
	execute sp_inserta_tel_col           
 		@pi_id_colegio        = @pi_id_colegio, 
        @pi_l_telefonos       = @pi_l_telefonos, 
		@pi_c_usua_alta       = @pi_c_usua_actuac, 
		@po_c_error      	  = @po_c_error output,  
		@po_d_error      	  = @po_d_error output 
                
          if (@po_c_error  <> 0) 
          begin  
              rollback tran modifica   
			  set @po_d_error = 'Error llamando a sp_inserta_tel_col : ' + @po_d_error			  
              return       
          end                 
 end  
 
 commit tran modifica   
  
end --sp_modifica_datos_colegio
 
go 

Grant Execute on dbo.sp_modifica_datos_colegio to GrpTrpSabed 
go

sp_procxmode 'sp_modifica_datos_colegio', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_modifica_datos_ong'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_modifica_datos_ong" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_modifica_datos_ong (   
@pi_id_ong         numeric(18,0),    
@pi_d_cuit         varchar(40),    
@pi_l_telefonos    typ_lista,   
@pi_d_mail         varchar(40),    
@pi_d_calle	   varchar(40),    
@pi_d_nro	   varchar(40),    
@pi_d_piso	   varchar(40),    
@pi_d_depto	   varchar(40),    
@pi_d_localidad    varchar(40),    
@pi_c_provincia    numeric(18,0),    
@pi_e_registro     varchar(1),   
@pi_c_usua_actuac  numeric(18,0),   
@pi_q_becas        numeric(7,0),   
@pi_d_nombre_ong   varchar(40),   
@pi_c_tipo_ong     numeric(18,0),   
@pi_d_suc_cuenta   varchar(4),   
@pi_d_tipo_cuenta  varchar(3),   
@pi_d_nro_cuenta   varchar(7),   
@pi_c_nro_cliente   numeric(8,0)  ,
@po_c_error        typ_c_error output,   
@po_d_error        typ_d_error output   
)   
as   
-----------------------------------------------  
--Objetivo: Modificacion de institucion - ONG    
--Par?metros de entrada:  	   
--	ID_INSTITUCION  
--	D_CUIL                  
--	D_TELEFONO              
--	D_MAIL                  
--	D_CALLE				   
--	D_NRO				   
--	D_PISO				   
--	D_DEPTO				   
--	D_CIUDAD               
--	C_PROVINCIA    
--	ID_ONG     
--	Q_BECAS              	   
--	D_NOMBRE_ONG           
--	E_REGISTRO             
--	PI_C_USUA_ACTUAC            
--	C_TIPO_ONG            
--Par?metros de salida: po_c_error y po_d_error   
-----------------------------------------------   
begin    
  
  if (@pi_c_usua_actuac is null or @pi_c_usua_actuac = 0)  
    begin  
      set @po_c_error = 2  
      set @po_d_error = 'No se recibi? usuario'    
      return         
  end  
  
  if (@pi_id_ong is null or @pi_id_ong = 0)   
    begin  
      set @po_c_error = 2 
      set @po_d_error = 'No se recibi? identificaci?n de ong'  
      return         
  end  
  
  declare   
  	@c_tipo_tel_fijo      	numeric(18,0),  
        @e_definitivo           char(1),
        @e_avance               char(1),
        @d_tipo_ong             varchar(40),
        @q_becados              int 

  --procedure q retorna los codigos del estado de registro definitivo  
  execute sp_obtiene_e_definitivo   @po_c_valor  = @e_definitivo output,  
                                    @po_c_error  = @po_c_error output,  
                                    @po_d_error  = @po_d_error output  
                                 
    if (@po_c_error  <> 0)  
    begin  
 	  set @po_d_error = 'Error llamando a sp_obtiene_e_definitivo: ' + @po_d_error	   
      return         
    end         

  --procedure q retorna los codigos del estado de registro guardar avance
  execute sp_obtiene_e_avance @po_c_valor  = @e_avance   output,   
                              @po_c_error  = @po_c_error output,   
                              @po_d_error  = @po_d_error output   
                                  
  if (@po_c_error  <> 0)   
    begin   
      set @po_d_error = 'Error llamando a sp_obtiene_e_avance: ' + @po_d_error	    
      return          
  end
  
  --se validan los datos necesarios para la modificaci?n  
  execute sp_valida_datos_ong  
        @pi_d_cuit       = @pi_d_cuit,  
        @pi_d_calle      = @pi_d_calle,  
        @pi_d_nro        = @pi_d_nro,  
        @pi_d_localidad  = @pi_d_localidad,  
        @pi_c_provincia  = @pi_c_provincia,  
        @pi_e_registro   = @pi_e_registro,  
        @pi_q_becas      = @pi_q_becas,  
        @pi_d_nombre_ong = @pi_d_nombre_ong,  
        @pi_c_tipo_ong   = @pi_c_tipo_ong,  
        @po_c_error      = @po_c_error  output,  
        @po_d_error      = @po_d_error  output  
  if (@po_c_error  <> 0)    
  begin    
      return           
  end  
    
  if exists (select 1  
               from saft_ongs o  
              where o.id_ong =  @pi_id_ong  
                and o.f_baja is not null  
             )        
  begin             
      set @po_c_error = 2  
      set @po_d_error = 'La ong: ' + @pi_d_nombre_ong + ' fue dada de baja. '  
      return  
  end 
  
  If @pi_e_registro = @e_avance and 
     exists (Select 1
               from saft_ongs
              where id_ong  = @pi_id_ong
                and e_registro = @e_definitivo) 
    Begin
      set @po_c_error = 2 
      set @po_d_error = 'La ong se encuentra en estado Definitivo, no se puede Guardar Avance'	    
      return              
  end     
    
  if @pi_d_cuit is not null  
  begin  
      --valido el cuit y su digito verificador  
      execute sp_valida_cuit   
                             @pi_d_cuit     = @pi_d_cuit,  
                             @po_c_error    = @po_c_error   output,  
                             @po_d_error    = @po_d_error   output  
                               
      if (@po_c_error  <> 0)  
      begin  
          return         
      end  
  end    
  
  if exists (select id_ong  
               from saft_ongs o  
              where o.d_cuit       = @pi_d_cuit  
                and o.d_nombre_ong = @pi_d_nombre_ong  
                and o.c_tipo_ong   = @pi_c_tipo_ong  
                and o.id_ong      <> @pi_id_ong  
             )        
  begin     
           
      select @d_tipo_ong = d_valor from sapt_parametros where id_parametro = @pi_c_tipo_ong        
  
      set @po_c_error = 2  
      set @po_d_error = 'Ya existe la ong '+ @d_tipo_ong + ' ' + @pi_d_nombre_ong +  
                        ' con el cuit: ' + @pi_d_cuit   
      return  
  end  
  
  --si est? en Definitivo controlo q le puedan bajar la cantidad de becas
  if @pi_e_registro = @e_definitivo 
  begin
          -- obtengo la cantidad de becados de la ong en cuestion 
          select @q_becados = count(distinct(a.id_alumno)) 
            from saat_alumnos a, 
                 sagt_alumnos_tutores sat, 
                 saft_tutores st 
           where st.id_ong = @pi_id_ong   
             and st.id_tutor = sat.id_tutor    
             and sat.id_alumno = a.id_alumno 
             and a.e_alumno in ('BECADO', 'SUSPENDIDO','POSTULANTE') 
         
          if @pi_q_becas < @q_becados 
          begin  
              set @po_d_error =  'No es posible asignar '+ convert(varchar,@pi_q_becas) +' becas a la ONG; ya que cuenta con '+ convert(varchar,@q_becados) +' becados. '
              set @po_c_error = 2 
              return             
          end
  end  
    
  
  begin tran modifica  
    
  execute sp_modifica_ong 	  
    @pi_id_ong               = @pi_id_ong,  
  	@pi_d_cuit               = @pi_d_cuit,  
  	@pi_d_mail               = @pi_d_mail,  
  	@pi_d_calle		 		 = @pi_d_calle,  
  	@pi_d_nro		 		 = @pi_d_nro,  
  	@pi_d_piso		 		 = @pi_d_piso,  
  	@pi_d_depto		 		 = @pi_d_depto,  
  	@pi_d_localidad          = @pi_d_localidad,  
  	@pi_c_provincia          = @pi_c_provincia,                  
  	@pi_q_becas              = @pi_q_becas,  
  	@pi_d_nombre_ong         = @pi_d_nombre_ong,  
  	@pi_e_registro           = @pi_e_registro,  
  	@pi_c_usua_actuac        = @pi_c_usua_actuac,  
  	@pi_c_tipo_ong           = @pi_c_tipo_ong,  
    @pi_d_suc_cuenta         = @pi_d_suc_cuenta,  
    @pi_d_tipo_cuenta        = @pi_d_tipo_cuenta,  
    @pi_d_nro_cuenta         = @pi_d_nro_cuenta,  
    @pi_c_nro_cliente        = @pi_c_nro_cliente,   	
  	@po_c_error      	 	 = @po_c_error output,   
  	@po_d_error      	 	 = @po_d_error output   
                            
  if (@po_c_error  <> 0)    
  begin  
      rollback modifica   
      return           
  end  
            
  execute sp_modifica_tel_ong            
  	@pi_id_ong                = @pi_id_ong,  
        @pi_l_telefonos           = @pi_l_telefonos,  
  	@pi_c_usua_actuac         = @pi_c_usua_actuac,  
  	@po_c_error      	  = @po_c_error output,   
  	@po_d_error      	  = @po_d_error output  
    
  if (@po_c_error  <> 0)    
  begin    
      rollback modifica    
      return           
  end                  
    
  
  	  
  execute sp_obtiene_tipo_tel_fijo  @po_c_valor  = @c_tipo_tel_fijo output,  
                                    @po_c_error  = @po_c_error output,  
                                    @po_d_error  = @po_d_error output  
                                 
  if (@po_c_error  <> 0)  
  begin  
 	  set @po_d_error = 'Error llamando a sp_obtiene_tipo_tel_fijo : ' + @po_d_error	  
      return         
  end  
    
  if @pi_e_registro = @e_definitivo and not exists (  
  select id_telefono  
    from sagt_telefonos  
   where id_ong     = @pi_id_ong  
     and c_tipo_telefono = @c_tipo_tel_fijo  
             )  
  begin  
      rollback tran modifica  
      set @po_c_error = 2  
      set @po_d_error = 'Debe indicar al menos un tel?fono fijo'  
      return           
  end    
                  
  commit modifica                  
                  
end --sp_modifica_datos_ong
 
go 

Grant Execute on dbo.sp_modifica_datos_ong to GrpTrpSabed 
go

sp_procxmode 'sp_modifica_datos_ong', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_modifica_ong'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_modifica_ong" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_modifica_ong( 
@pi_id_ong          numeric(18,0), 
@pi_d_cuit          varchar(40), 
@pi_d_mail          varchar(40), 
@pi_d_calle	        varchar(40), 
@pi_d_nro	        varchar(40), 
@pi_d_piso	        varchar(40), 
@pi_d_depto	        varchar(40), 
@pi_d_localidad     varchar(40), 
@pi_c_provincia     numeric(18,0), 
@pi_q_becas         numeric(7,0), 
@pi_d_nombre_ong    varchar(40), 
@pi_e_registro      varchar(1), 
@pi_c_usua_actuac   numeric(18,0), 
@pi_c_tipo_ong      numeric(18,0), 
@pi_d_suc_cuenta    varchar(4),  
@pi_d_tipo_cuenta   varchar(3),  
@pi_d_nro_cuenta    varchar(7),  
@pi_c_nro_cliente   numeric(8,0)  ,
@po_c_error         typ_c_error output, 
@po_d_error         typ_d_error output 
) 
as 
-------------------------------------------  
------------------------ 
--Objetivo: Modificacion de ONG.  
--Par?metros de entrada: 
--	ID_ONG 
--	ID_INSTITUCION      
--	Q_BECAS                
--	D_NOMBRE_ONG        
--	E_REGISTRO               
--	C_USUA_ACTUAC 
--	C_TIPO_ONG 
--Par?metros de salida: po_c_error y po_d_error 
------------------------------------------------------------------- 
 
begin 
 
  declare @dummy numeric(18,0) 
 
  set @po_c_error = 0 
  set @po_d_error = null 
  set @dummy = null 
 
  update saft_ongs 
     set d_cuit        = @pi_d_cuit, 
         d_mail        = @pi_d_mail, 
         d_calle       = @pi_d_calle, 
         d_nro         = @pi_d_nro, 
         d_piso        = @pi_d_piso, 
         d_depto       = @pi_d_depto, 
         d_localidad   = @pi_d_localidad, 
         c_provincia   = case when @pi_c_provincia = 0 then @dummy else @pi_c_provincia end, 
         q_becas       = @pi_q_becas, 
         d_nombre_ong  = upper(@pi_d_nombre_ong), 
         e_registro    = @pi_e_registro, 
         c_tipo_ong    = @pi_c_tipo_ong, 
	 d_suc_cuenta  = @pi_d_suc_cuenta, 
	 d_tipo_cuenta = @pi_d_tipo_cuenta,  
	 d_nro_cuenta  = @pi_d_nro_cuenta, 
	 c_nro_cliente = @pi_c_nro_cliente,
         c_usua_actuac = @pi_c_usua_actuac, 
         f_actuac      = getDate() 
   where id_ong = @pi_id_ong 
   
  set @po_c_error = @@error     
  if (@po_c_error  <> 0) 
    begin  
      set @po_d_error =  convert(varchar,@po_c_error)  
                         + ' - Error en sp_modifica_ong. ' 
  end 
   
end -- sp_modifica_ong
 
go 

Grant Execute on dbo.sp_modifica_ong to GrpTrpSabed 
go

sp_procxmode 'sp_modifica_ong', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_modifica_parametro'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_modifica_parametro" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_modifica_parametro(
@pi_id_parametro  numeric(7,0),
@pi_d_valor       varchar(40),
@pi_id_usuario    numeric(18,0),
@po_c_error       typ_c_error output,
@po_d_error       typ_d_error output
)
--Objetivo: modifica la descripci?n de un par?metro de la tabla de par?metros
--Par?metros de entrada: pi_id_parametro (varchar2), pi_d_valor (varchar2)
--Par?metros de salida: po_c_error y po_d_error

as

begin

  --Validaci?n de Par?metros de Entrada

  if (@pi_id_parametro  is null or @pi_id_parametro = 0)
    begin
      set @po_c_error = 3
      set @po_d_error = 'No se recibi? c_valor'
      return             
  end

  if (@pi_d_valor  is null)
    begin
      set @po_c_error = 2
      set @po_d_error = 'No se recibi? d_valor'
      return       
  end
  
  set @po_c_error = 0
  set @po_d_error = null

  update sapt_parametros
  set d_valor       = @pi_d_valor,
      c_usua_actuac = @pi_id_usuario,
      f_actuac      = getDate()
  where id_parametro = @pi_id_parametro

  set @po_c_error = @@error    

  if (@po_c_error  = 547)
    begin    
      set @po_d_error = 'El c?digo de par?metro est? siendo usado. No puede eliminarse '  
      set @po_c_error = 2
      return 
    end
  else
  if (@po_c_error  <> 0)
    begin
      set @po_c_error = @@error
      set @po_d_error = 'Error al modificar tablas de parametros '
    end
   

end --sp_modifica_parametro
 
go 

Grant Execute on dbo.sp_modifica_parametro to GrpTrpSabed 
go

sp_procxmode 'sp_modifica_parametro', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_modifica_persona'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_modifica_persona" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_modifica_persona(  
@pi_id_usuario          numeric(18,0),  
@pi_id_persona          numeric(18,0),   
@pi_c_tpo_doc           numeric(18,0),     
@pi_nro_doc             numeric(12,0),  
@pi_cuil                varchar(40),  
@pi_apellido            varchar(40),  
@pi_nombre              varchar(40),  
@pi_f_nac               varchar(19),  
@pi_c_nacionalidad      numeric(18,0),    
@pi_c_ocupacion         numeric(18,0),    
@pi_c_estado_civil      numeric(18,0),     
@pi_l_telefonos         typ_lista,  
@pi_mail                varchar(40),  
@pi_c_provincia         numeric(18,0),    
@pi_localidad           varchar(40),  
@pi_calle               varchar(40),  
@pi_nro                 varchar(40),  
@pi_piso                varchar(40),  
@pi_depto               varchar(40),  
@pi_c_sexo              numeric(18,0),    
@pi_e_registro          char(1),     
@po_c_error             typ_c_error   output,  
@po_d_error             typ_d_error   output  
)  
as  
  
--Objetivo: Edici?n de los datos de la persona (y direcci?n de la misma)  
begin  
    
  if (@pi_id_usuario  is null or @pi_id_usuario = 0)  
    begin  
      set @po_c_error = 3 
      set @po_d_error = 'No se recibi? id de usuario'  
      return         
  end  
    
  if (@pi_id_persona  is null or @pi_id_persona = 0)  
    begin  
      set @po_c_error = 3 
      set @po_d_error = 'No se recibi? identificaci?n de persona'  
      return         
  end    
    
  set @po_c_error = 0  
  set @po_d_error = null    


    
  declare   
      @f_nac  smalldatetime,  
      @dummy  numeric(18,0),  
      @e_tipo_tel_fijo   numeric(18,0),  
      @e_definitivo      char(1),
      @e_avance          varchar(1)  

  execute sp_obtiene_e_avance @po_c_valor  = @e_avance output,   
                              @po_c_error  = @po_c_error output,   
                              @po_d_error  = @po_d_error output   
                                  
  if (@po_c_error  <> 0)   
  begin   
      set @po_d_error = 'Error llamando a sp_obtiene_e_avance : ' + @po_d_error	    
      return          
  end
  
  --procedure q retorna los codigos del estado de registro definitivo   
  execute sp_obtiene_e_definitivo   @po_c_valor  = @e_definitivo output,   
                                    @po_c_error  = @po_c_error output,   
                                    @po_d_error  = @po_d_error output   
                                  
  if (@po_c_error  <> 0)   
    begin   
      set @po_d_error = 'Error llamando a sp_obtiene_e_definitivo : ' + @po_d_error	    
      return          
  end   

  If exists (select 1  
               from sagt_personas per
              where per.id_persona = @pi_id_persona
                and per.e_registro = @e_definitivo)
     and  @pi_e_registro = @e_avance
    begin 
      set @po_c_error = 2 
      set @po_d_error = 'La persona se encuentra en estado definitivo, no puede volver a avance'	    
      return     
  end        
        
  execute sp_valida_datos_per  
          @pi_c_tpo_doc       = @pi_c_tpo_doc,  
          @pi_nro_doc         = @pi_nro_doc,  
          @pi_cuil            = @pi_cuil,  
          @pi_apellido        = @pi_apellido,  
          @pi_nombre          = @pi_nombre,  
          @pi_f_nac           = @pi_f_nac,  
          @pi_c_nacionalidad  = @pi_c_nacionalidad,  
          @pi_c_ocupacion     = @pi_c_ocupacion,  
          @pi_c_estado_civil  = @pi_c_estado_civil,  
          @pi_c_provincia     = @pi_c_provincia,  
          @pi_localidad       = @pi_localidad,  
          @pi_calle           = @pi_calle,  
          @pi_nro             = @pi_nro,  
          @pi_c_sexo          = @pi_c_sexo,  
          @pi_e_reg           = @pi_e_registro,  
          @po_c_error         = @po_c_error   output,  
          @po_d_error         = @po_d_error   output  
            
  if (@po_c_error  <> 0)  
      begin  
          return         
      end        
  
  --validacion de unicidad de tipo y dni  
  execute sp_valida_uk_doc_per @pi_id_persona      = @pi_id_persona,  
                               @pi_c_documento     = @pi_c_tpo_doc,  
                               @pi_n_documento     = @pi_nro_doc,  
                               @po_c_error         = @po_c_error   output,  
                               @po_d_error         = @po_d_error   output  
                           
  if (@po_c_error  <> 0)  
  begin  
      return         
  end  
    
  if @pi_f_nac is not null  
  begin  
      --convierto el varchar de entrada a date para el insert en la tabla  
      execute sp_convierte_char_en_fecha  @pi_fecha_char     = @pi_f_nac,  
                                          @po_fecha_datetime = @f_nac      output,  
                                          @po_c_error        = @po_c_error output,  
                                          @po_d_error        = @po_d_error output  
                                 
        if (@po_c_error  <> 0)  
          begin  
	    set @po_d_error = 'Error llamando a sp_convierte_char_en_fecha : ' + @po_d_error		   
            return         
          end    
  end   
    
  begin tran modifica  
    
  --  
  -- Verifico si hay que cambiar el usuario del sistema  
  -- Esto pasa porque por regla, el usuario es el numero   
  -- de documento de la prsona, si este cambi, debe cambiar el user  
  execute sp_modifica_user @pi_id_persona = @pi_id_persona,  
                           @pi_nro_doc    = @pi_nro_doc,   
                           @po_c_error    = @po_c_error output,   
                           @po_d_error    = @po_d_error output   
  if (@po_c_error  <> 0)   
    begin   
      rollback tran modifica   
      return          
  end     
    
  update sagt_personas  
  set   
        c_documento          = case when @pi_c_tpo_doc = 0 then @dummy else @pi_c_tpo_doc end,                
        n_documento          = case when @pi_nro_doc = 0 then @dummy else @pi_nro_doc end,                  
        d_apellido           = @pi_apellido,                 
        d_nombre             = @pi_nombre,                   
        d_cuil               = @pi_cuil,                     
        f_nacimiento         = @f_nac,                       
        c_nacionalidad       = case when @pi_c_nacionalidad = 0 then @dummy else @pi_c_nacionalidad end,           
        c_ocupacion          = case when @pi_c_ocupacion = 0 then @dummy else @pi_c_ocupacion end,              
        c_estado_civil       = case when @pi_c_estado_civil = 0 then @dummy else @pi_c_estado_civil end,             
        d_mail               = @pi_mail,                                               
        d_calle              = @pi_calle,  
        d_piso               = @pi_piso,  
        d_nro                = @pi_nro,  
        d_depto              = @pi_depto,          
        d_localidad          = @pi_localidad,                   
        c_provincia          = case when @pi_c_provincia = 0 then @dummy else @pi_c_provincia end,              
        c_sexo               = case when @pi_c_sexo = 0 then @dummy else @pi_c_sexo end,                   
        e_registro           = @pi_e_registro,  
        c_usua_actuac        = @pi_id_usuario,  
        f_actuac             = getDate()  
  where id_persona = @pi_id_persona  
  
  set @po_c_error = @@error      
  if (@po_c_error  <> 0)  
  begin   
      rollback tran modifica  
      set @po_d_error =  convert(varchar,@po_c_error)   
                         + ' - Error en sp_modifica sagt_personas. '  
      return   
  end  
    
  -------------------------------------------------------------------  
  --modifico los telefonos recibidos en el parametro @pi_l_telefonos  
  -------------------------------------------------------------------  
  
  delete sagt_telefonos   
  where id_persona = @pi_id_persona  
    
  set @po_c_error = @@error      
    
  if (@po_c_error  <> 0)  
  begin  
    rollback tran modifica  
    set @po_d_error = convert(varchar,@po_c_error) +   
                ' - Error al limpiar telefonos de persona. '  
    return               
  end   
  
  if char_length(@pi_l_telefonos) > 1  
  begin  
    
	execute sp_inserta_tel_per            
                @pi_id_usuario            = @pi_id_usuario,  
                @pi_l_telefonos           = @pi_l_telefonos,			  
                @pi_id_persona            = @pi_id_persona,					  
		@po_c_error      	  = @po_c_error output,   
		@po_d_error      	  = @po_d_error output  
                  
        if (@po_c_error  <> 0)  
        begin   
            rollback tran modifica  
            return        
        end  
  end  
    
  execute sp_obtiene_tipo_tel_fijo  @po_c_valor  = @e_tipo_tel_fijo output,  
                                    @po_c_error  = @po_c_error output,  
                                    @po_d_error  = @po_d_error output  
                                 
    if (@po_c_error  <> 0)  
    begin  
      set @po_d_error = 'Error llamando a sp_obtiene_tipo_tel_fijo : ' + @po_d_error		 
      return         
    end  
    

          
    
  if @pi_e_registro = @e_definitivo and not exists (  
  select id_telefono  
    from sagt_telefonos  
   where id_persona     = @pi_id_persona  
     and c_tipo_telefono = @e_tipo_tel_fijo)  
  begin  
      rollback tran modifica  
      set @po_c_error = 2  
      set @po_d_error = 'Debe indicar al menos un tel?fono fijo'  
      return           
  end    
  
 commit tran modifica   
  
end --sp_modifica_persona
 
go 

Grant Execute on dbo.sp_modifica_persona to GrpTrpSabed 
go

sp_procxmode 'sp_modifica_persona', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_modifica_tarea'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_modifica_tarea" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_modifica_tarea(
-- drop procedure sp_modifica_tarea
@pi_id_aviso   numeric(18,0),
@pi_id_usuario numeric(18,0),
@pi_det        varchar(40),
@pi_f_tarea    varchar(19),
@po_c_error    typ_c_error output,
@po_d_error    typ_d_error output
)
------------------------------------------------------------------------------
--Objetivo: 
--Par?metros de entrada: 
--Par?metros de salida: po_c_error y po_d_error
------------------------------------------------------------------------------
as

begin

  --Validaci?n de Par?metros de Entrada
  if (@pi_id_aviso  is null or @pi_id_aviso = 0)
    begin
      set @po_c_error = 3
      set @po_d_error = 'No se recibi? id_aviso'
      return       
  end

  if (@pi_id_usuario  is null or @pi_id_usuario = 0)
    begin
      set @po_c_error = 3
      set @po_d_error = 'No se recibi? pi_id_usuario'
      return       
  end
  
  --si los parametros de modificacion est?n ambos en nulo, no se realiza 
  --la modificacion
  if (@pi_det  is null) and (@pi_f_tarea is null)
    begin
      set @po_c_error = 3
      set @po_d_error = 'No se recibieron valores de modificaci?n '
      return       
  end

  declare 
         @id_origen   numeric(18,0),
         @f_vigencia  smalldatetime,
         @f_tarea     smalldatetime
  
  set @po_c_error = 0
  set @po_d_error = null

  --convierto el varchar de entrada a date para el insert en la tabla
  execute sp_convierte_char_en_fecha @pi_fecha_char     = @pi_f_tarea,
                                     @po_fecha_datetime = @f_tarea output,
                                     @po_c_error        = @po_c_error output,
                                     @po_d_error        = @po_d_error output
                               
    if (@po_c_error  <> 0)
    begin
      set @po_d_error = 'Error llamando a sp_convierte_char_en_fecha : ' + @po_d_error
	  return       
    end  

  --obtengo el usuario de origen de la tarea y lo comparo con el usuario 
  --enviado por parametro
 select @id_origen = id_origen, @f_vigencia = f_vigencia
   from saft_avisos 
  where id_aviso = @pi_id_aviso 
  
  set @po_c_error = @@error    

  if (@po_c_error  <> 0)
    begin 
      set @po_d_error = 'Error al consultar usuario del aviso: ' + 
                        convert(varchar(7),@pi_id_aviso)  
      return
  end  
  
  if @id_origen <> @pi_id_usuario
  begin 
      set @po_c_error = 2
      set @po_d_error = 'El usuario ' + convert(varchar(7),@pi_id_usuario)  +
                        ' no ha dado de alta la tarea ' + 
                        convert(varchar(7),@pi_id_aviso) +
                        '. No puede realizarse la modificaci?n '
      return     
  end 
  
  if @f_vigencia < getDate() 
  begin 
      set @po_c_error = 2
      set @po_d_error = 'La tarea ' + 
                        convert(varchar(7),@pi_id_aviso) +
                        ' ha sido dada de baja. No puede realizarse la modificaci?n '
      return     
  end 
  
  
  update saft_avisos 
  set x_cuerpo_mensaje = isnull(@pi_det, x_cuerpo_mensaje),
      f_envio          = isnull(@f_tarea, f_envio),
      c_usua_actuac    = @pi_id_usuario,
      f_actuac         = getDate()
  where id_aviso = @pi_id_aviso 
  
  set @po_c_error = @@error    

  if (@po_c_error  <> 0)
    begin   
      set @po_d_error = 'Error al modificar aviso: ' + 
                        convert(varchar(7),@pi_id_aviso) 
	  return
  end

end --sp_modifica_tarea
 
go 

Grant Execute on dbo.sp_modifica_tarea to GrpTrpSabed 
go

sp_procxmode 'sp_modifica_tarea', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_modifica_tel_col'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_modifica_tel_col" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_modifica_tel_col (
@pi_id_colegio           numeric(18,0), 
@pi_l_telefonos          typ_lista,
@pi_c_usua_actuac        numeric(18,0),
@po_c_error      	       typ_c_error output,
@po_d_error      	       typ_d_error output
)
as
------------------------------------------- 
------------------------
--Objetivo: Modificacion de colegio. 
--Par?metros de entrada:  	
--	L_TELEFONO
--	C_USUA_ACTUAC        
--Par?metros de salida: po_c_error y po_d_error
-------------------------------------------------------------------

begin

  declare 
      @l_telefonos       typ_lista,
      @sublista_tel      varchar(40),
      @sep               varchar(1),
      @subSep            varchar(1),
      @id_telefono 	     numeric(18,0),
      @d_telefono 	     varchar(40),
      @old_d_telefono    varchar(40),
      @c_tipo_telefono   numeric(18,0),
      @observaciones     varchar(250)         
  
  set @po_c_error = 0
  set @po_d_error = null

  execute sp_separador_registros
             @po_separador_registro    = @sep        output,
             @po_separador_campo       = @subSep     output,
             @po_c_error               = @po_c_error output,
             @po_d_error               = @po_d_error output  
             
  if (@po_c_error  <> 0)
    begin
      set @po_d_error = 'Error llamando a sp_separador_registros : ' + @po_d_error
      return    
  end

  -------------------------------------------------------------------
  --modifico los telefonos recibidos en el parametro @pi_l_telefonos
  -------------------------------------------------------------------
  
  set @l_telefonos = @pi_l_telefonos + @sep
  
  while (@l_telefonos is not null)
  begin
  
      set @sublista_tel    = substring(@l_telefonos,1,charindex(@sep,@l_telefonos)-1) 

      set @l_telefonos = substring(@l_telefonos,
                                   charindex(@sep,@l_telefonos)+1, 
                                   char_length(@l_telefonos)
                                   )      
      
      execute sp_datos_tel_id 
                        @pi_sublista_tel    = @sublista_tel, 
                        @pi_subSep          = @subSep,
                        @po_id_telefono     = @id_telefono     output,
                        @po_d_telefono      = @d_telefono      output,
                        @po_c_tipo_telefono = @c_tipo_telefono output,
                        @po_observaciones   = @observaciones   output,
                        @po_c_error         = @po_c_error      output,
                        @po_d_error         = @po_d_error      output

      if (@po_c_error  <> 0)
      begin
		  set @po_d_error = 'Error llamando a sp_datos_tel_id : ' + @po_d_error	  
          return             
      end     
      
    --controlo que para esta persona, no exista el num de telefono
    select @old_d_telefono = d_telefono
     from sagt_telefonos
    where id_colegio = @pi_id_colegio
      and d_telefono = @d_telefono          

    --controlo que para este colegio, no exista el num de telefono
    if exists (select id_telefono
                   from sagt_telefonos
                  where id_colegio     = @pi_id_colegio
                    and d_telefono = @d_telefono
                ) and @old_d_telefono <> @d_telefono 
    begin

		  set @po_d_error = 'Ya existe el telefono para el colegio. '
          set @po_c_error = 2
          return             
    end 
    else 

      if @id_telefono is null  
      begin
      
          insert into sagt_telefonos (id_colegio,d_telefono,c_tipo_telefono,observaciones, c_usua_alta)
          values (@pi_id_colegio,@d_telefono,@c_tipo_telefono,@observaciones,@pi_c_usua_actuac)
      
          set @po_c_error = @@error    

          if (@po_c_error  <> 0)
          begin
              set @po_d_error = convert(varchar,@po_c_error) + 
                          ' - Error al insertar telefono de colegio. '
              set @po_c_error = 2
              return             
          end      
      end 
      else
      begin
      --inserta cada uno de los telefonos de la lista
      update sagt_telefonos 
         set d_telefono      = @d_telefono,
             c_tipo_telefono = @c_tipo_telefono,
             observaciones   = @observaciones,
             c_usua_actuac   = @pi_c_usua_actuac,
             f_actuac        = getDate()
       where id_colegio  = @pi_id_colegio
         and id_telefono = @id_telefono
             
      set @po_c_error = @@error    

      if (@po_c_error  <> 0)
      begin
          set @po_d_error =  convert(varchar,@po_c_error) 
                         + ' - Error al modificar telefono de colegio. '
          return             
      end
    end          
  end  --while      

end --sp_modifica_tel_col
 
go 

Grant Execute on dbo.sp_modifica_tel_col to GrpTrpSabed 
go

sp_procxmode 'sp_modifica_tel_col', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_modifica_tel_ong'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_modifica_tel_ong" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_modifica_tel_ong ( 
@pi_id_ong               numeric(18,0),  
@pi_l_telefonos          typ_lista, 
@pi_c_usua_actuac        numeric(18,0), 
@po_c_error      	       typ_c_error output, 
@po_d_error      	       typ_d_error output 
) 
as 
-------------------------------------------  
------------------------ 
--Objetivo: Modificacion de institucion.  
--Par?metros de entrada:   
--	L_TELEFONO 
--	C_USUA_ACTUAC         
--Par?metros de salida: po_c_error y po_d_error 
------------------------------------------------------------------- 
 
begin 
 
  declare  
      @l_telefonos       typ_lista, 
      @sublista_tel      typ_lista, 
      @sep               varchar(1), 
      @subSep            varchar(1), 
      @id_telefono 	     numeric(18,0), 
      @d_telefono 	     varchar(40), 
      @old_d_telefono    varchar(40), 
      @c_tipo_telefono   numeric(18,0), 
      @observaciones     varchar(250)          
   
  set @po_c_error = 0 
  set @po_d_error = null 
 
  execute sp_separador_registros 
             @po_separador_registro    = @sep        output, 
             @po_separador_campo       = @subSep     output, 
             @po_c_error               = @po_c_error output, 
             @po_d_error               = @po_d_error output   
              
  if (@po_c_error  <> 0) 
    begin 
	  set @po_d_error = 'Error llamando a sp_separador_registros : ' + @po_d_error
      return     
  end 
 
  ------------------------------------------------------------------- 
  --modifico los telefonos recibidos en el parametro @pi_l_telefonos 
  ------------------------------------------------------------------- 

  delete from sagt_telefonos 
  where id_ong = @pi_id_ong 
   
  set @po_c_error = @@error     
  if (@po_c_error  <> 0) 
  begin 
          set @po_d_error =  convert(varchar,@po_c_error)  
                         + ' - Error al limpiar telefonos de ong. ' 
          return              
  end   
   
   
  if char_length(@pi_l_telefonos) > 2 
  begin 
        	execute sp_inserta_tel_ong           
         		@pi_c_usua_alta       = @pi_c_usua_actuac, 
                @pi_l_telefonos       = @pi_l_telefonos,			 
                @pi_id_ong            = @pi_id_ong,					 
        		@po_c_error      	  = @po_c_error output,  
        		@po_d_error      	  = @po_d_error output 
                         
          if (@po_c_error  <> 0) 
          begin  
              rollback tran ins 
			  set @po_d_error = 'Error llamando a sp_inserta_tel_ong ' + @po_d_error 
              return       
          end                 
  end                                                                                                                                                                                                                                                             
end --sp_modifica_tel_ong
 
go 

Grant Execute on dbo.sp_modifica_tel_ong to GrpTrpSabed 
go

sp_procxmode 'sp_modifica_tel_ong', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_modifica_user'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_modifica_user" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_modifica_user(  
@pi_id_persona  numeric(18,0), 
@pi_nro_doc     numeric(12,0),  
@po_c_error     typ_c_error   output,  
@po_d_error     typ_d_error   output  
)  
as  
--    
--Objetivo: En caso de que la persona sea usuario del sistema  
--          y se modifique su numeor de documento, se modifique  
--          el usuario y el usuario de logueo 
-- 
begin  
  
  if (@pi_id_persona is null or @pi_id_persona = 0)
    begin  
      set @po_c_error = 3
      set @po_d_error = 'No se recibi? el identificador de persona'  
      return         
  end  
   
  if (@pi_nro_doc is null or @pi_nro_doc = 0)
    begin  
      set @po_c_error = 3  
      set @po_d_error = 'No se recibi? el numero de documento'  
      return         
  end  
   
  set @po_c_error = 0  
  set @po_d_error = null  
     
  If exists (Select 1  
               from sast_usuarios  
              where id_persona = @pi_id_persona) 
  begin 
  
    declare 
      @n_documento numeric(12,0) 
   
    --  
    -- Obtengo el tipo y documento actual 
    Select @n_documento = n_documento 
      from sagt_personas 
     where id_persona = @pi_id_persona  
  
    set @po_c_error = @@error 
    if (@po_c_error  <> 0)  
      begin 
        set @po_d_error =  'Error al intentar obtener los datos de la persona' 
		return	
    end  
     
    -- 
    -- Veo si cambio el Tipo o numero de documento 
    If (@n_documento <> @pi_nro_doc)
      begin 
         
        -- 
        -- Actualizo el usuario 
        Update sast_usuarios set d_user = convert (varchar(12),@pi_nro_doc) where id_persona= @pi_id_persona 
         
        set @po_c_error = @@error 
        if (@po_c_error  <> 0)  
          begin 
            set @po_d_error =  'Error al intentar obtener los datos de la persona' 
			return	
        end  
         
        -- 
        -- Actualizo el usuario de Logueo 
        Update sast_login_usuarios set usu_d_user = convert(varchar(12),@pi_nro_doc) where usu_d_user = convert(varchar(40),@n_documento) 
         
        set @po_c_error = @@error 
        if (@po_c_error  <> 0)  
          begin 
            set @po_d_error =  'Error al intentar obtener los datos de la persona' 
			return
        end  
     
    end -- de ver si cambio el numero documento 
     
  end -- de ver si tiene usuario 
    
end -- sp_modifica_user
 
go 

Grant Execute on dbo.sp_modifica_user to GrpTrpSabed 
go

sp_procxmode 'sp_modifica_user', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_modifica_usuario'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_modifica_usuario" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_modifica_usuario (   

@pi_id_usuario_logg      numeric(18,0),   

@pi_id_persona           numeric(18,0),   

@pi_id_usuario           numeric(18,0),   

@pi_id_ong               numeric(18,0),   

@pi_l_perfiles_ins       typ_lista,   

@pi_l_perfiles_del       typ_lista,   

@pi_clave_defecto        varchar(40),    

@po_c_error              typ_c_error output,   

@po_d_error              typ_d_error output   

)   

as   

--   

--objetivo: modifica los perfiles del usuario   

--@pi_l_perfiles_ins: lista de perfiles a agregar   

--@pi_l_perfiles_del: lista de perfiles a eliminar   

   

begin   

   

  declare    

   @aux                  typ_lista,   

   @l_perfiles           typ_lista,   

   @perfil               numeric(18,0),   

   @dummy                varchar(1),   

   @id_dummy             numeric(18,0),   

   @sep                  varchar(1),   

   @n_nivel              int,   

   @id_fundacion         numeric(18,0),   

   @e_definitivo         char(1),   

   @e_baja               char(1),   

   @n_existe             integer,   

   @e_registro           char(1),    

   @n_existe_usu_perf    integer,   

   @e_usu_perfil         char(1),   

   @cant_personas_ong    int,   

   @cant_personas_fund   int,   

   @cant_tutores         int,   

   @cant_usu_perfiles    int,   

   @cant_usu             int,   

   @id_ong_usu           numeric(18,0),    

   @d_user               varchar(40), 

   @d_nombre_ong         varchar(40), 

   @cant_fun             integer, 

   @estado               char(1)   

      

  set @po_c_error            = 0   

  set @po_d_error            = null    

     

     

  --------------------------------------   

   --insert into sabed_log(descrip) values ('pi_l_perfiles_ins: ' + @pi_l_perfiles_ins)   

   --insert into sabed_log(descrip) values ('pi_l_perfiles_del: ' + @pi_l_perfiles_del)   

  --------------------------------------   

   

  --procedure q retorna los codigos del estado de registro definitivo   

  execute sp_obtiene_e_definitivo @po_c_valor  = @e_definitivo output,   

                                  @po_c_error  = @po_c_error output,   

                                  @po_d_error  = @po_d_error output   

                                  

  if (@po_c_error  <> 0)   

  begin   

     set @po_d_error ='Error al llamar a sp_obtiene_e_definitivo: ' + @po_d_error  

     return          

  end   

   

  --procedure q retorna los codigos del estado de registro baja   

  execute sp_obtiene_e_baja @po_c_valor  = @e_baja output,   

                            @po_c_error  = @po_c_error output,   

                            @po_d_error  = @po_d_error output   

                                  

  if (@po_c_error  <> 0)   

  begin   

    set @po_d_error ='Error al llamar a sp_obtiene_e_baja :' + @po_d_error  

    return          

  end   

     

  --obtengo el separador de registros   

  execute sp_separador_registros   

             @po_separador_registro    = @sep        output,   

             @po_separador_campo       = @dummy      output,   

             @po_c_error               = @po_c_error output,   

             @po_d_error               = @po_d_error output     

                

  if (@po_c_error  <> 0)   

  begin   

      set @po_d_error ='Error al llamar a sp_separador_registros :' + @po_d_error  

      return       

  end   

     

  --obtengo la ong del usuario q se va a modificar   

  execute sp_obtiene_ong_usu  @pi_id_usuario = @pi_id_usuario,   

                              @pi_id_perfil  = @id_dummy,   

                              @po_id_ong     = @id_ong_usu output,   

                              @po_c_error    = @po_c_error output,   

                              @po_d_error    = @po_d_error output   

                                  

  if (@po_c_error  <> 0)      

  begin   

      set @po_d_error ='Error al llamar a sp_obtiene_ong_usu :' + @po_d_error  

      return       

  end   

   

  -- para niveles 2 ? 3 de usuarios verifico que la persona pertenezca    

  -- a la misma ong, en caso de que ya tenga cargados perfiles ong ? tutor   

  --if (@id_ong_usu <> 0 and @pi_id_ong <> 0) and (@id_ong_usu <> @pi_id_ong)   

  if (@id_ong_usu is not null and @pi_id_ong <> 0) and (@id_ong_usu <> @pi_id_ong)   

  begin   

   

      select @d_nombre_ong = d_nombre_ong 

        from saft_ongs ong 

       where ong.id_ong = @id_ong_usu 

   

      set @po_d_error = 'Error, el usuario ya est? asociado a la ong '+@d_nombre_ong +'('+ convert(varchar,@id_ong_usu)+')'   

      set @po_c_error = 2   

      return   

  end     

   

  -- 

  -- verifico que la persona asociada al usuario este en estado Definitivo 

  If exists (select 1  

               from sagt_personas 

              Where id_persona = @pi_id_persona 

                and e_registro <> @e_definitivo) 

    begin 

      set @po_d_error = 'La persona no se encuentra en estado Definitivo'   

      set @po_c_error = 2   

      return   

  end 

   

  --si el usuario es administrador del sistema y quiero agregarle ? borrarle otros perfiles 

  select @estado = e_usu_perfil   

    from sast_usuarios_perfiles   

   where id_perfil = 4  

     and id_usuario = @pi_id_usuario   

 

  if @estado = @e_definitivo 

    begin 

      set @po_d_error = 'El usuario es Administrador del Sistema, no puede otorgarle otros perfiles'   

      set @po_c_error = 2   

      return   

  end 

 

 

  set @l_perfiles            = @pi_l_perfiles_ins + @sep   

       

  --controlo que el usuario no haya sido dado de baja   

  select @cant_usu = count(*)   

    from sast_usuarios   

   where id_persona = @pi_id_persona   

     and e_usuario = @e_baja   

 

  begin tran modUsuario   

      

  if @cant_usu > 0   

    begin   

        update sast_usuarios   

        set e_usuario     = @e_definitivo,   

            c_usua_actuac = @pi_id_usuario_logg,   

            f_actuac      = getDate()   

        where id_persona = @pi_id_persona   

   

        set @po_c_error = @@error       

        if (@po_c_error  <> 0)   

          begin   

            rollback tran modUsuario   

            set @po_d_error = convert(varchar, @po_c_error) +    

                                    ' - Error al dar de alta en usuarios. '   

            return     

        end    

           

        select @d_user = d_user    

        from sast_usuarios    

        where id_usuario = @pi_id_usuario    

           

        --agregar modificacion a tablas de login   

        execute sp_GuardarUsuario   

                  @pi_usu_d_user         = @d_user,     

                  @pi_usu_habilitado      = 'S',     

                  @pi_usu_estado	      = 'I',     

                  @pi_usu_clave1	      = '',     

                  @pi_usu_clave2	      = '',                                      

                  @pi_usu_clave3	      = '',     

                  @pi_usu_clave4	      = '',     

                  @pi_usu_int_fallidos   = 0,     

                  @pi_usu_clave	      = @pi_clave_defecto,      

                  @po_c_error            = @po_c_error output,          

                  @po_d_error            = @po_d_error output            

        if (@po_c_error  <> 0)          

          begin     

            rollback tran modUsuario      

            set @po_d_error = 'Error al modificar un usuario, loguin'       

            return  

        end             

            

  end     

   

  if char_length(@l_perfiles) > 1   

  begin   

  --proceso lista de perfiles a agregar al usuario   

  while (@l_perfiles is not null)   

  begin   

     

        --obtengo un perfil de la lista pasada por parametro   

        set @perfil = convert(numeric,      

                             substring(@l_perfiles, 1,charindex(@sep,@l_perfiles)-1)   

                              )   

         

   

        --obtengo el nivel de mensaje   

        select @n_nivel = n_nivel_mensaje   

          from sast_perfiles p   

         where p.id_perfil = @perfil   

            

        if @@rowcount = 0   

        begin   

            rollback tran modUsuario   

            set @po_d_error = 'No se encontr? el perfil ' + convert(varchar,@perfil) + ' en el sistema. '   

            set @po_c_error = 3   

            return   

        end   

         

        --limpio la variable que controla q no se repita la persona y su ong ? tutor   

        set @n_existe = 0   

         

        if @n_nivel = 1 --Equipo de Becas   

        begin   

               --obtengo id de fundacion    

               select @id_fundacion = o.id_ong   

                 from saft_ongs o             

                where o.m_fundacion = 'S'   

                  and o.e_registro = @e_definitivo   

                   

               if @id_fundacion is null     

               begin   

                    rollback tran modUsuario   

                    set @po_d_error = 'Error; la Fundaci?n no fue dada de alta. '   

                    set @po_c_error = 2   

                    return          

               end   

                

               --S?lo puede haber un registro de Fundacion  

               select @cant_fun = count(o.id_ong) 

                 from saft_ongs o               

                where o.m_fundacion = 'S'     

                  and o.e_registro = @e_definitivo     

                     

               if @cant_fun <> 1 

               begin     

                    rollback tran modUsuario     

                    set @po_d_error = 'Error, Existe m?s de un registro de Fund. '     

                    set @po_c_error = 2     

                    return            

               end             

                     

                 

               select @e_registro = e_registro   

                 from saft_personas_ong   

                where id_ong = @id_fundacion   

                 and  id_persona     = @pi_id_persona   

               set @cant_personas_fund = @@rowcount     

                  

               --si la persona no est? cargada para la fundacion, la doy de alta   

               if @cant_personas_fund = 0   

               begin   

                        insert into saft_personas_ong (id_ong, id_persona,   

                                                        e_registro, c_usua_alta)   

                                                values (@id_fundacion, @pi_id_persona,                                          

                                                   @e_definitivo, @pi_id_usuario_logg)    

                                              

                         set @po_c_error = @@error   

                         if (@po_c_error  <> 0)   

                         begin   

                                rollback tran modUsuario   

                                set @po_d_error = convert(varchar,@po_c_error)    

                                                + 'Error al insertar en personas_ong'    

                                return          

                         end                      

               end             

               else   

               begin   

                   --ya existe la persona en personas_ongs. seteo estado en definitivo   

                   update saft_personas_ong   

                      set e_registro     = @e_definitivo,   

                          c_usua_actuac  = @pi_id_usuario_logg,   

                          f_actuac       = getDate()                   

                    where id_ong = @id_fundacion   

                      and id_persona     = @pi_id_persona   

                         

                   set @po_c_error = @@error   

                   if (@po_c_error  <> 0)   

                   begin      

                         rollback tran modUsuario   

                         set @po_d_error = convert(varchar,@po_c_error) +    

                             'Error al modificar estado de Fundacion en personas_ongs'   

                         return          

                   end                   

               end   

        end --@n_nivel = 1 --FUNDACION   

   

        if  @n_nivel = 2 -- ONG   

        begin   

   

               select @e_registro = e_registro   

                 from saft_personas_ong   

                where id_ong = @pi_id_ong   

                 and  id_persona     = @pi_id_persona                    

               set @cant_personas_ong = @@rowcount      

                    

               --si la persona no est? cargada para la ong, la doy de alta   

               if @cant_personas_ong = 0   

               begin         

                           

                        insert into saft_personas_ong (id_ong, id_persona,e_registro, c_usua_alta)   

                        values (@pi_id_ong, @pi_id_persona,@e_definitivo, @pi_id_usuario_logg)    

              

   

                        set @po_c_error = @@error   

                        if (@po_c_error  <> 0)   

                        begin   

                             rollback tran modUsuario   

                             set @po_d_error = convert(varchar,@po_c_error) +    

                                               ' - Error al insertar en personas_inst'   

                             return          

                        end     

                           

               end   

                           

               if @cant_personas_ong > 0 --la persona est? cargada en la ong   

               begin   

                   --ya existe la persona en personasongs. seteo estado en definitivo   

                      

                   update saft_personas_ong   

                      set e_registro = @e_definitivo,   

                          c_usua_actuac  = @pi_id_usuario_logg,   

                          f_actuac       = getDate()                   

                    where id_ong = @pi_id_ong   

                      and id_persona     = @pi_id_persona                    

                         

                   set @po_c_error = @@error   

   

                   --print 'voy a imprimir despu?s del update en personas ong'   

                      

                   if (@po_c_error  <> 0)   

                   begin                       

                         rollback tran modUsuario   

                         set @po_d_error = convert(varchar,@po_c_error) +    

                                'Error al modificar estado de ONG en en personas_ongs'   

                         return          

                   end                   

               end   

                  

        end --@n_nivel = 2 -- ONG   

              

        if @n_nivel = 3 -- TUTOR   

        begin   

            select @e_registro = e_registro   

            from saft_tutores   

            where id_ong     = @pi_id_ong   

              and id_persona = @pi_id_persona   

            set @cant_tutores = @@rowcount   

               

            ------------------------------   

            set @aux = @e_registro + ' -> estado tutores '      

            --print @aux   

            ------------------------------                  

                 

            --no existe el registro en tutores, doy de alta        

            if @cant_tutores = 0   

            begin   

                        insert into saft_tutores (id_ong,id_persona,    

                                                  e_registro, c_usua_alta)   

                                          values (@pi_id_ong, @pi_id_persona,    

                                              @e_definitivo,@pi_id_usuario_logg)   

                                   

                        set @po_c_error = @@error   

                        if (@po_c_error  <> 0)   

                        begin   

                            rollback tran modUsuario   

                            set @po_d_error = convert(varchar,@po_c_error) +    

                                                    ' - Error al insertar en tutores'   

                            return          

                        end   

            end   

               

            --el registro existe:   

            --vemos si hay q updatear el registro ? no   

            if @cant_tutores > 0   

            begin   

                        update saft_tutores    

                        set e_registro     = @e_definitivo,    

                            c_usua_actuac  = @pi_id_usuario_logg,   

                            f_actuac       = getDate()   

                        where id_ong     = @pi_id_ong   

                          and id_persona = @pi_id_persona             

                             

                        set @po_c_error = @@error, @cant_tutores = @@rowcount   

                           

                        if (@po_c_error  <> 0)   

                        begin   

                            rollback tran modUsuario   

                            set @po_d_error = convert(varchar,@po_c_error) +    

                                               ' - Error al setear estado en tutores'    

                            return          

                        end   

                           

                           

            ------------------------------   

            set @aux = 'despu?s de updatear tutores: ' + convert(varchar,@cant_tutores)   

            --print @aux   

   

            select @e_registro = e_registro   

            from saft_tutores   

            where id_ong     = @pi_id_ong   

              and id_persona = @pi_id_persona   

               

            set @aux = @e_registro + ' -> estado tutores '      

            --print @aux   

               

            ------------------------------                             

                           

            end   

         

        end  --@n_nivel = 3 -- TUTOR   

         

        select @e_usu_perfil = e_usu_perfil   

        from sast_usuarios_perfiles   

        where id_perfil = @perfil   

          and id_usuario = @pi_id_usuario   

        set @cant_usu_perfiles = @@rowcount     

           

        --doy de alta el perfil al usuario   

        --si no tiene el perfil lo doy de alta   

        --si tuvo ese perfil anteriormente, le cambio el estado a definitivo   

        if @cant_usu_perfiles = 0   

        begin   

              --doy de alta cada uno de los perfiles del usuario   

              insert into sast_usuarios_perfiles (id_perfil, id_usuario, e_usu_perfil, c_usua_alta)   

              values (@perfil, @pi_id_usuario, @e_definitivo, @pi_id_usuario_logg)      

         

              set @po_c_error = @@error       

           

              if (@po_c_error  <> 0)   

              begin   

                  rollback tran modUsuario   

                  set @po_d_error = convert(varchar, @po_c_error) +    

                                    'Error al dar de alta en usuarios_perfiles. '                              

                  return     

              end   

        end   

        else    

        begin   

              update sast_usuarios_perfiles    

                      set e_usu_perfil  = @e_definitivo,   

                          c_usua_actuac = @pi_id_usuario_logg,   

                          f_actuac      = getDate()   

              where id_perfil    = @perfil   

                and id_usuario   = @pi_id_usuario   

         

              set @po_c_error = @@error       

           

              if (@po_c_error  <> 0)   

              begin   

                  rollback tran modUsuario   

                  set @po_d_error = convert(varchar, @po_c_error) +    

                                    'Error al dar de alta en usuarios_perfiles. '   

                  return     

              end   

        end   

           

        set @l_perfiles = substring(@l_perfiles,   

                                   charindex(@sep,@l_perfiles)+1,    

                                   char_length(@l_perfiles)   

                                   )            

  end    --while   

  end --if charlength(@l_perfiles)   

  --debug   

  else    

  begin   

   set @po_d_error = 'el charlength de la lista de perfiles es 1 o 0. [' + convert(varchar,char_length(@l_perfiles)) + ']'   

   set @po_c_error = 3   

  end   

  --debug   

     

  execute sp_elimina_usuario_perfiles                 

             @pi_id_usuario_logg       = @pi_id_usuario_logg,   

             @pi_id_persona            = @pi_id_persona,               

             @pi_id_usuario            = @pi_id_usuario,   

             @pi_id_ong                = @pi_id_ong,     

             @pi_l_perfiles            = @pi_l_perfiles_del,        

             @pi_sep                   = @sep,   

             @po_c_error               = @po_c_error output,   

             @po_d_error               = @po_d_error output     

                

  if (@po_c_error  <> 0)   

  begin   

      rollback tran modUsuario   

      return       

  end   

   

  commit tran modUsuario   

   

end
 
go 

Grant Execute on dbo.sp_modifica_usuario to GrpTrpSabed 
go

sp_procxmode 'sp_modifica_usuario', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_nivel_usuario'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_nivel_usuario" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_nivel_usuario (
@pi_id_usuario          numeric(18,0),
@po_n_nivel_mensaje     int   output,
@po_c_error             typ_c_error   output,
@po_d_error             typ_d_error   output
)
as

--objetivo: identificar el nivel que tiene el usuario
--

begin

  if (@pi_id_usuario is null or @pi_id_usuario = 0)
    begin
      set @po_c_error = 3
      set @po_d_error = 'No se recibi? la identificaci?n del usuario'
      return       
  end

  declare @e_definitivo   varchar(1)

  set @po_c_error = 0
  set @po_d_error = null
  
    --procedure q retorna los codigos del estado de registro definitivo
  execute sp_obtiene_e_definitivo @po_c_valor  = @e_definitivo output,
                                  @po_c_error  = @po_c_error output,
                                  @po_d_error  = @po_d_error output
                               
  if (@po_c_error  <> 0)
  begin
     set @po_d_error = 'Error llamando a sp_obtiene_e_definitivo : ' + @po_d_error 
     return       
  end  
  
  select @po_n_nivel_mensaje = min(p.n_nivel_mensaje)
    from sast_usuarios_perfiles up, 
         sast_perfiles p
   where up.id_usuario = @pi_id_usuario
     and up.id_perfil = p.id_perfil
     and up.e_usu_perfil = @e_definitivo
     
  set @po_c_error = @@error    
  if (@po_c_error  <> 0)
  begin 
      set @po_d_error =  convert(varchar,@po_c_error) 
                         + ' - Error al obtener perfiles. '
      return
  end

end -- sp_nivel_usuario
 
go 

Grant Execute on dbo.sp_nivel_usuario to GrpTrpSabed 
go

sp_procxmode 'sp_nivel_usuario', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_nivel_usuario_max'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_nivel_usuario_max" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_nivel_usuario_max ( 
@pi_id_usuario          numeric(18,0), 
@po_n_nivel_mensaje     int   output, 
@po_c_error             typ_c_error   output, 
@po_d_error             typ_d_error   output 
) 
as 
 
--objetivo: identificar el nivel que tiene el usuario 
-- 
 
begin 
 
  if (@pi_id_usuario is null or @pi_id_usuario = 0)
    begin 
      set @po_c_error = 3 
      set @po_d_error = 'No se recibi? pi_id_usuario' 
      return        
  end 
 
  declare @e_definitivo   varchar(1) 
 
  set @po_c_error = 0 
  set @po_d_error = null 
   
    --procedure q retorna los codigos del estado de registro definitivo 
  execute sp_obtiene_e_definitivo @po_c_valor  = @e_definitivo output, 
                                  @po_c_error  = @po_c_error output, 
                                  @po_d_error  = @po_d_error output 
                                
  if (@po_c_error  <> 0) 
  begin 
	 set @po_d_error = 'Error llamando a sp_obtiene_e_definitivo : ' + @po_d_error
     return        
  end   
   
  select @po_n_nivel_mensaje = max(p.n_nivel_mensaje) 
    from sast_usuarios_perfiles up,  
         sast_perfiles p 
   where up.id_usuario = @pi_id_usuario 
     and up.id_perfil = p.id_perfil 
     and up.e_usu_perfil = @e_definitivo 
      
 
  set @po_c_error = @@error     
  if (@po_c_error  <> 0) 
  begin  
      set @po_d_error =  convert(varchar,@po_c_error)  
                         + ' - Error al obtener perfiles. ' 
      return 
  end 
 
end -- sp_nivel_usuario_max
 
go 

Grant Execute on dbo.sp_nivel_usuario_max to GrpTrpSabed 
go

sp_procxmode 'sp_nivel_usuario_max', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_obt_lista_ong_usuario'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_obt_lista_ong_usuario" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_obt_lista_ong_usuario (   
	@pi_id_usuario numeric(18,0),   
	@po_c_error  typ_c_error output,   
	@po_d_error  typ_d_error output)   
------------------------------------------------------------------------------   
--Objetivo:    
--  Listar las ONG a las que puede pertenecer el candidato seg?n el usuario    
--  que lo est? cargando   
--Par?metros de entrada: pi_id_usuario   
--Par?metros de salida:  Lista de ONG y po_c_error y po_d_error   
------------------------------------------------------------------------------   
as   
   
begin   
   
  -- Validaci?n de Par?metros de Entrada   
  --   
  if (@pi_id_usuario is null or @pi_id_usuario = 0)   
    begin   
      set @po_c_error = 3  
      set @po_d_error = 'No se recibi? id_usuario'   
      return    
  end   
    
  declare    
    @c_tipo_aviso           numeric(18,0),   
    @min_n_nivel_mensaje    integer,   
    @e_definitivo varchar(1)   
     
  --procedure q retorna los codigos del estado de registro definitivo   
  execute sp_obtiene_e_definitivo @po_c_valor  = @e_definitivo output,   
                                  @po_c_error  = @po_c_error output,   
                                  @po_d_error  = @po_d_error output   
                                  
  if (@po_c_error  <> 0)   
  begin   
     set @po_d_error = 'Error llamando a sp_obtiene_e_definitivo : ' + @po_d_error  
     return          
  end   
       
     
  set @po_c_error = 0   
  set @po_d_error = null   
   
   
  -- Verifico cual es el m?imo nuvel de mensaje    
  --   
  select @min_n_nivel_mensaje = min(p.n_nivel_mensaje)   
    from sast_usuarios_perfiles up, sast_perfiles p   
   where up.id_usuario = @pi_id_usuario   
     and up.id_perfil = p.id_perfil   
     and up.e_usu_perfil = @e_definitivo   
     and n_nivel_mensaje > 0   
      
   
  If (@min_n_nivel_mensaje =1)   
    begin   
   
      Select id_ong,d_nombre_ong    
        from saft_ongs   
       Where e_registro = @e_definitivo
         and m_fundacion = 'N'            
       order by d_nombre_ong   
   
      set @po_c_error = @@error       
      if (@po_c_error  <> 0)   
      begin      
        set @po_d_error = 'ERROR al intentar obtener la lista de ONG para nivel 1'                  
        return                                        
      end   
   
    end    
   
  else   
   
    begin   
   
      Select saftong.id_ong,   
             saftong.d_nombre_ong    
        from saft_ongs saftong,   
             sast_usuarios sastusu,   
             saft_tutores safttut   
       Where sastusu.id_usuario = @pi_id_usuario   
         and sastusu.id_persona = safttut.id_persona   
         and saftong.id_ong = safttut.id_ong   
         and saftong.e_registro = @e_definitivo   
         and sastusu.e_usuario = @e_definitivo   
         and safttut.e_registro = @e_definitivo  
         and saftong.m_fundacion='N' 
       Union  
      Select saftong.id_ong,   
             saftong.d_nombre_ong    
        from saft_ongs saftong,   
             sast_usuarios sastusu,   
             saft_personas_ong saftpong   
       Where sastusu.id_usuario = @pi_id_usuario   
         and sastusu.id_persona = saftpong.id_persona   
         and saftong.e_registro = @e_definitivo   
         and sastusu.e_usuario = @e_definitivo   
         and saftpong.e_registro = @e_definitivo   
         and saftong.id_ong = saftpong.id_ong   
         and saftong.m_fundacion='N'          
       order by 2   
    
      set @po_c_error = @@error       
      if (@po_c_error  <> 0)   
      begin      
        set @po_d_error = 'ERROR al intentar obtener la lista de ONG'                  
        return                                        
      end   
   
    end   
   
end --sp_obt_lista_ong_usuario

go 

Grant Execute on dbo.sp_obt_lista_ong_usuario to GrpTrpSabed 
go

sp_procxmode 'sp_obt_lista_ong_usuario', anymode
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_obt_per_eval_acad'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_obt_per_eval_acad" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_obt_per_eval_acad (     
@pi_id_periodo_recarga numeric(18,0),   
@po_id_periodo numeric(18,0) output,   
@po_c_error   typ_c_error   output,   
@po_d_error   typ_d_error   output   
)   
as   
--   
--objetivo: En base al periodo de recarga,    
--          obtiene el id de situacion academica    
--          mas proximo al periodo de recarga o el activo   
--   
   
begin   
   
  If (@pi_id_periodo_recarga is null or @pi_id_periodo_recarga = 0)
    begin   
      set @po_c_error = 3
      set @po_d_error = 'No se informo el periodo de recarga'   
      return   
  end   
   
  declare @CantReg numeric (18,0),   
          @max_periodo smalldatetime   
   
  set @po_c_error = 0   
  set @po_d_error = null   
   
  --   
  -- Obtengo el maximo   
  Select @max_periodo = max(pea.f_inicio_periodo)   
    from sact_periodos_eval_acad pea,   
         sact_periodos_recargas prec   
   Where prec.id_periodo_recarga=@pi_id_periodo_recarga   
     and prec.f_fin_periodo >= pea.f_inicio_periodo   
      
  set @po_c_error = @@error,@CantReg = @@rowcount   
  if (@po_c_error  <> 0)   
    begin    
      set @po_d_error =  convert(varchar,@po_c_error)    
                         + ' - Error al obtener el id de periodo de evaluacion academica '   
	  return
  end   
  if (@CantReg = 0)
    begin   
      set @po_c_error = 3   
      set @po_d_error = 'No se pudo determinar periodo de situacion academica'   
      return   
  end   
     
  --   
  -- Obtengo el periodo en si   
  select @po_id_periodo = pea.id_periodo   
    from sact_periodos_eval_acad pea   
   Where pea.f_inicio_periodo= @max_periodo   
      
  set @po_c_error = @@error,@CantReg = @@rowcount   
  if (@po_c_error  <> 0)   
    begin    
      set @po_d_error =  convert(varchar,@po_c_error)    
                         + ' - Error al obtener el id de evaluacion academica 2'   
	  return
  end   
  if (@CantReg = 0)
    begin   
      set @po_c_error = 3   
      set @po_d_error = 'No se pudo determinar evaluacion academica parte 2'   
      return   
  end   
     
end -- sp_obt_per_eval_acad
 
go 

Grant Execute on dbo.sp_obt_per_eval_acad to GrpTrpSabed 
go

sp_procxmode 'sp_obt_per_eval_acad', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_obt_per_rend_activo'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_obt_per_rend_activo" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_obt_per_rend_activo (  
@pi_id_periodo_recarga numeric(18,0),  
@po_id_periodo         numeric(18,0) output,  
@po_c_error            typ_c_error   output,  
@po_d_error            typ_d_error   output  
)  
as  
--  
--objetivo: En base al periodo de recarga,   
--          obtiene el id de rendicion de gastos   
--          mas proximo al periodo de recarga o el activo  
--  
  
begin  
  
  If (@pi_id_periodo_recarga is null or @pi_id_periodo_recarga = 0)
    begin  
      set @po_c_error = 3  
      set @po_d_error = 'No se informo el periodo de recarga'  
      return  
  end  
  
  declare @CantReg numeric (18,0),  
          @max_periodo smalldatetime  
  
  set @po_c_error = 0  
  set @po_d_error = null  
  
  --  
  -- Obtengo el maximo  
  Select @max_periodo = max(pr.f_inicio_periodo)  
    from sact_periodos_rendicion pr,  
         sact_periodos_recargas prec  
   Where prec.id_periodo_recarga=@pi_id_periodo_recarga  
     and prec.f_fin_periodo >= pr.f_inicio_periodo  
     
  set @po_c_error = @@error,@CantReg = @@rowcount  
  if (@po_c_error  <> 0)  
    begin   
      set @po_d_error =  convert(varchar,@po_c_error)   
                         + ' - Error al obtener el id de periodo de recarga '  
	  return
  end  
  if (@CantReg = 0)
    begin  
      set @po_c_error = 3  
      set @po_d_error = 'No se pudo determinar periodo de rendicion'  
      return  
  end  
    
  --  
  -- Obtengo el periodo en si  
  select @po_id_periodo = pr.id_periodo  
    from sact_periodos_rendicion pr  
   Where pr.f_inicio_periodo= @max_periodo  
     
  set @po_c_error = @@error,@CantReg = @@rowcount  
  if (@po_c_error  <> 0)  
    begin   
      set @po_d_error =  convert(varchar,@po_c_error)   
                         + ' - Error al obtener el id de periodo de recarga 2'  
  end  
  if (@CantReg = 0)
    begin  
      set @po_c_error = 3  
      set @po_d_error = 'No se pudo determinar periodo de rendicion parte 2'  
      return  
  end  
    
end -- sp_obt_per_rend_activo
 
go 

Grant Execute on dbo.sp_obt_per_rend_activo to GrpTrpSabed 
go

sp_procxmode 'sp_obt_per_rend_activo', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_obtiene_cod_aviso'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_obtiene_cod_aviso" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_obtiene_cod_aviso(
@po_id_parametro  numeric(18,0)   output,
@po_c_error       typ_c_error     output,
@po_d_error       typ_d_error     output
)
------------------------------------------------------------------------------
--Objetivo: Informar los codigos de aviso, de manera de encapsular el numero de 
--          codigo.
--Par?metros de entrada: --
--Par?metros de salida: po_c_valor,identificadores de la tabla 
--                      de parametros
--                      po_c_error y po_d_error
------------------------------------------------------------------------------
as

begin
  
  set @po_c_error = 0
  set @po_d_error = null
  
  --TAREA CALENDARIO
  set @po_id_parametro  = 16

  set @po_c_error = @@error    
  if (@po_c_error  <> 0)
    begin 
      set @po_d_error =  convert(varchar,@po_c_error) 
                         + ' - Error al obtener codigo de aviso '
	  return
  end

end --sp_obtiene_cod_aviso
 
go 

Grant Execute on dbo.sp_obtiene_cod_aviso to GrpTrpSabed 
go

sp_procxmode 'sp_obtiene_cod_aviso', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_obtiene_cod_mensaje'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_obtiene_cod_mensaje" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_obtiene_cod_mensaje(
@po_id_parametro  numeric(18,0)   output,
@po_c_error       typ_c_error     output,
@po_d_error       typ_d_error     output
)
------------------------------------------------------------------------------
--Objetivo: Informar los codigos de tipo de aviso, de manera de encapsular el 
--          numero de codigo.
--Par?metros de entrada: --
--Par?metros de salida: po_c_valor,identificadores de la tabla 
--                      de parametros
--                      po_c_error y po_d_error
------------------------------------------------------------------------------
as

begin
  
  set @po_c_error = 0
  set @po_d_error = null
  
  --TIPO  DE AVISO - MENSAJE
  set @po_id_parametro  = 15

  set @po_c_error = @@error
  if (@po_c_error  <> 0)
    begin
      set @po_d_error = 'Error al obtener codigo de aviso'
	  return
  end

end --sp_obtiene_cod_mensaje
 
go 

Grant Execute on dbo.sp_obtiene_cod_mensaje to GrpTrpSabed 
go

sp_procxmode 'sp_obtiene_cod_mensaje', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_obtiene_detalle_tarea'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_obtiene_detalle_tarea" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_obtiene_detalle_tarea(
@pi_id_aviso          numeric(18,0),
@pi_id_usuario        numeric(18,0),
@po_c_error           typ_c_error output,
@po_d_error           typ_d_error output
)
as
--Ver Detalle de Tarea: Este servicio recibe como par?metros el ID de usuario
--y el ID de la tarea y debe devolver los datos de la tarea m?s el usuario 
--que cargo dicha Tarea.
begin

  --Validaci?n de Par?metros de Entrada
  if (@pi_id_aviso  is null or @pi_id_aviso = 0)
    begin
      set @po_c_error = 3
      set @po_d_error = 'No se recibi? id_aviso'
      return       
  end

  if (@pi_id_usuario is null or @pi_id_usuario = 0)
    begin
      set @po_c_error = 3
      set @po_d_error = 'No se recibi? usuario '
      return       
  end
  declare @cant_filas int
  set @po_c_error = 0
  set @po_d_error = null

  select a.id_origen usuario_tarea, a.id_aviso, a.id_origen, a.f_envio,
         p.d_valor motivo_aviso, a.x_cuerpo_mensaje
  from   saft_avisos a, sapt_parametros p
  where  a.id_aviso  = @pi_id_aviso 
     and a.id_origen = @pi_id_usuario
     and a.c_evento_calend = p.id_parametro

  set @po_c_error = @@error,
      @cant_filas = @@rowcount

  if (@po_c_error  <> 0)
    begin         
      set @po_d_error = 'Error al obtener detalle de la tarea '
	  return
    end


  if (@cant_filas = 0)
    begin
      set @po_c_error = 1
      set @po_d_error = 'No se encontraron datos. '
      return      
    end

end --sp_obtiene_detalle_tarea
 
go 

Grant Execute on dbo.sp_obtiene_detalle_tarea to GrpTrpSabed 
go

sp_procxmode 'sp_obtiene_detalle_tarea', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_obtiene_dias'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_obtiene_dias" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_obtiene_dias (    
@pi_id_usuario          numeric(18,0),    
@pi_anio                integer,    
@pi_mes                 integer,    
@po_lista_fechas        typ_lista output,    
@po_c_error        		typ_c_error output,    
@po_d_error             typ_d_error output    
)    
as    
    
--Crear SP que retorne lista de d?as para un mes y a?o en particular de un     
--determinado usuario, el mismo recibe 3 par?metros y retorna la lista de d?as     
--concatenada con el s?mbolo # para el caso de que haya m?s de una tarea para     
--ese mes y a?o.    
    
begin    
      
declare @dia_envio       integer,    
        @m_origen        varchar(1),    
        @sep             varchar(1),    
        @subSep          varchar(1),    
	@vc_error        typ_c_error, 
        @id_ong          numeric(18,0),    
        @id_dummy        numeric(18,0),    
        @c_tipo_aviso    numeric(18,0),   
	@error_message 	         varchar(50), 
	@lista_f_emitidas        typ_lista, 
	@lista_f_recibidas_fund  typ_lista, 
	@lista_f_recibidas_ong   typ_lista, 
	@lista_f_recibidas_ind   typ_lista, 
	@aux                     typ_lista 
    
	set @po_c_error = 0    
	set @po_d_error = null   
   
    
	--obtener ong del usuario: @pi_id_usuario    
        execute sp_obtiene_ong_usu  @pi_id_usuario = @pi_id_usuario, 
                                    @pi_id_perfil  = @id_dummy, 
                                    @po_id_ong     = @id_ong output, 
                                    @po_c_error    = @po_c_error output, 
                                    @po_d_error    = @po_d_error output 
                                      
        if (@po_c_error  <> 0)    
        begin 
			set @po_d_error = 'Error llamando a sp_obtiene_ong_usu : ' + @po_d_error
            return     
        end  
    
	--procedure q retorna los codigos del tipo de aviso TAREA    
	execute sp_obtiene_cod_aviso @po_id_parametro   = @c_tipo_aviso output,                
                               @po_c_error        = @po_c_error output,    
                               @po_d_error        = @po_d_error output    
                                   
	if (@po_c_error  <> 0) 
	  begin    
		set @po_d_error = 'Error llamando a sp_obtiene_cod_aviso : ' + @po_d_error
		return        
	  end      
    
	execute sp_separador_registros 
            @po_separador_registro    = @sep output,    
            @po_separador_campo       = @subSep output,    
            @po_c_error               = @po_c_error output,    
            @po_d_error               = @po_d_error output                       
    
	if (@po_c_error  <> 0)    
	begin    
		set @po_d_error = 'Error llamando a sp_separador_registros : ' + @po_d_error		
	    return        
	end 
 
	set @po_lista_fechas=''    
	 
	execute sp_dias_tar_emitidas 
	    @pi_id_usuario   = @pi_id_usuario,    
            @pi_anio         = @pi_anio,    
            @pi_mes          = @pi_mes,    
            @pi_sep          = @sep,    
            @pi_subSep       = @subSep,    
            @pi_c_tipo_aviso = @c_tipo_aviso,    
            @po_lista_fechas = @lista_f_emitidas output,    
            @po_c_error      = @po_c_error output,    
            @po_d_error      = @po_d_error output    
			 
        set @vc_error = @@error    
		 
	print '--------------------'	 
        print 'sp_dias_tar_emitidas'   			 
        print @lista_f_emitidas 		 
       	print '--------------------'		 
			 
	if (@po_c_error  <> 0)    
	    begin        
			set @po_d_error = 'Error al obtener dias (sp_dias_tar_emitidas), detalle: '+@po_d_error 
            return  
	    end   
		     
	if (@vc_error  <> 0)    
	    begin 
			set @po_d_error = 'Error al obtener dias (sp_dias_tar_emitidas)' 
            return 
	    end 
	     
	execute sp_dias_tar_recibidas_ind 
            @pi_id_usuario   = @pi_id_usuario, 
            @pi_anio         = @pi_anio, 
            @pi_mes          = @pi_mes, 
            @pi_sep          = @sep, 
            @pi_subSep       = @subSep, 
            @pi_c_tipo_aviso = @c_tipo_aviso, 
            @po_lista_fechas = @lista_f_recibidas_ind output, 
            @po_c_error      = @po_c_error output, 
            @po_d_error      = @po_d_error output 
	    
	set @vc_error = @@error 
	 
	print '--------------------'	 
        print 'sp_dias_tar_recibidas_ind'   			 
        print @lista_f_recibidas_ind 		 
       	print '--------------------' 
	 
			 
	if (@po_c_error  <> 0)    
	    begin        
			set @po_d_error = 'Error al obtener dias (sp_dias_tar_recibidas_ind), detalle: '+@po_d_error 
            return  
	    end   
		     
	if (@vc_error  <> 0) 
	    begin        
			set @po_d_error = 'Error al obtener dias (sp_dias_tar_recibidas_ind)' 
            return  
	    end    
 
	execute sp_dias_tar_recibidas_fund    
            @pi_id_usuario   = @pi_id_usuario,    
            @pi_anio         = @pi_anio,     
            @pi_mes          = @pi_mes,    
            @pi_sep          = @sep,    
            @pi_subSep       = @subSep,    
            @pi_c_tipo_aviso = @c_tipo_aviso,    
            @po_lista_fechas = @lista_f_recibidas_fund output,     
            @po_c_error      = @po_c_error output,    
            @po_d_error      = @po_d_error output    
	    
    set @vc_error = @@error    
 
	print '--------------------'	 
        print 'sp_dias_tar_recibidas_fund'   			 
        print @lista_f_recibidas_fund 		 
       	print '--------------------' 
			 
	if (@po_c_error  <> 0)    
	    begin        
			set @po_d_error = 'Error al obtener dias (sp_dias_tar_recibidas_fund), detalle: '+@po_d_error 
            return  
	    end   
		     
	if (@vc_error  <> 0) 
	    begin        
			set @po_d_error = 'Error al obtener dias (sp_dias_tar_recibidas_fund)' 
            return  
	    end 
	     
	execute sp_dias_tar_recibidas_ong    
            @pi_id_usuario   = @pi_id_usuario, 
            @pi_id_ong       = @id_ong, 
            @pi_anio         = @pi_anio,    
            @pi_mes          = @pi_mes,    
            @pi_sep          = @sep,    
            @pi_subSep       = @subSep,    
            @pi_c_tipo_aviso = @c_tipo_aviso,    
            @po_lista_fechas = @lista_f_recibidas_ong output,    
            @po_c_error      = @po_c_error output,    
            @po_d_error      = @po_d_error output    
 
    set @vc_error = @@error   
 
	print '--------------------'	 
        print 'sp_dias_tar_recibidas_ong'   			 
        print @lista_f_recibidas_ong 
        set @aux = convert(varchar, @c_tipo_aviso) 
        print @aux 
       	print '--------------------'      
			 
	if (@po_c_error  <> 0)    
	    begin        
	        set @po_d_error = 'Error al obtener dias (sp_dias_tar_recibidas_ong), err:'+  @po_d_error  
            return  
	    end   
		     
	if (@vc_error  <> 0)    
	    begin        
			set @po_d_error = convert(varchar,@vc_error) + ' - Error al obtener dias (sp_dias_tar_recibidas_ong)' 
            return  
	    end 
	     
        set @po_lista_fechas = @lista_f_emitidas       +  
                               @lista_f_recibidas_ind  +  
                               @lista_f_recibidas_fund +  
                               @lista_f_recibidas_ong  
                                
	print '--------------------'	 
        print 'po_lista_fechas'   			 
        print @po_lista_fechas 
       	print '--------------------'                                  
		 
end -- sp_obtiene_dias
 
go 

Grant Execute on dbo.sp_obtiene_dias to GrpTrpSabed 
go

sp_procxmode 'sp_obtiene_dias', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_obtiene_dias_vig_tarea'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_obtiene_dias_vig_tarea" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_obtiene_dias_vig_tarea(
@po_c_valor  integer         output,
@po_c_error  typ_c_error     output,
@po_d_error  typ_d_error     output
)
------------------------------------------------------------------------------
--Objetivo: Informar la cantidad de d?as por los que estar?n en pantalla los 
--          mensajes recibidos por los usuarios. 
--Par?metros de entrada: --
--Par?metros de salida: po_c_valor: identificador de parametros
--                      po_c_error y po_d_error
------------------------------------------------------------------------------
as

begin
  
  set @po_c_error = 0
  set @po_d_error = null
  
  set @po_c_valor  = 7

  set @po_c_error = @@error    

  if (@po_c_error  <> 0)
    begin 
      set @po_d_error =  convert(varchar,@po_c_error) 
                         + ' - Error al obtener cantidad de d?as de vigencia '
	  return
  end

end --sp_obtiene_dias_vig_tarea
 
go 

Grant Execute on dbo.sp_obtiene_dias_vig_tarea to GrpTrpSabed 
go

sp_procxmode 'sp_obtiene_dias_vig_tarea', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_obtiene_e_avance'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_obtiene_e_avance" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_obtiene_e_avance(
@po_c_valor  char(1)         output,
@po_c_error  typ_c_error     output,
@po_d_error  typ_d_error     output
)
------------------------------------------------------------------------------
--Objetivo: Informar los codigos de aviso, de manera de encapsular el numero de 
--          codigo.
--Par?metros de entrada: --
--Par?metros de salida: po_c_valor: identificador de parametros
--                      po_c_error y po_d_error
------------------------------------------------------------------------------
as

begin
  
  set @po_c_error = 0
  set @po_d_error = null
  
  --TAREA CALENDARIO
  set @po_c_valor  = 'A'

  set @po_c_error = @@error    

  if (@po_c_error  <> 0)
    begin 
      set @po_d_error =  convert(varchar,@po_c_error) 
                         + ' - Error al obtener c?digo de estado en avance '
	  return
    end

end --sp_obtiene_e_avance
 
go 

Grant Execute on dbo.sp_obtiene_e_avance to GrpTrpSabed 
go

sp_procxmode 'sp_obtiene_e_avance', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_obtiene_e_baja'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_obtiene_e_baja" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_obtiene_e_baja
(
@po_c_valor  char(1)         output,
@po_c_error  typ_c_error     output,
@po_d_error  typ_d_error     output
)
------------------------------------------------------------------------------
--Objetivo: 
--Par?metros de entrada: --
--Par?metros de salida: po_c_valor: identificador de parametros
--                      po_c_error y po_d_error
------------------------------------------------------------------------------
as

begin
  
  set @po_c_error = 0
  set @po_d_error = null
  
  set @po_c_valor  = 'B'

  set @po_c_error = @@error    

  if (@po_c_error  <> 0)
    begin 
      set @po_d_error =  convert(varchar,@po_c_error) 
                         + ' - Error al obtener c?digo de estado baja.  '
	  return
  end

end --sp_obtiene_e_baja
 
go 

Grant Execute on dbo.sp_obtiene_e_baja to GrpTrpSabed 
go

sp_procxmode 'sp_obtiene_e_baja', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_obtiene_e_definitivo'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_obtiene_e_definitivo" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_obtiene_e_definitivo(
@po_c_valor  char(1)         output,
@po_c_error  typ_c_error     output,
@po_d_error  typ_d_error     output
)
------------------------------------------------------------------------------
--Objetivo: Informar los codigos de aviso, de manera de encapsular el numero de 
--          codigo.
--Par?metros de entrada: --
--Par?metros de salida: po_c_valor: identificador de parametros
--                      po_c_error y po_d_error
------------------------------------------------------------------------------
as

begin
  
  set @po_c_error = 0
  set @po_d_error = null
  
  --TAREA CALENDARIO
  set @po_c_valor  = 'D'

  set @po_c_error = @@error    
  if (@po_c_error  <> 0)
    begin 
      set @po_d_error =  convert(varchar,@po_c_error) 
                         + ' - Error al obtener c?digo de estado definitivo '
	  return
  end
      
end --sp_obtiene_e_definitivo
 
go 

Grant Execute on dbo.sp_obtiene_e_definitivo to GrpTrpSabed 
go

sp_procxmode 'sp_obtiene_e_definitivo', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_obtiene_lista_invol'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_obtiene_lista_invol" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_obtiene_lista_invol (  
	@pi_id_usuario numeric(18,0),  
	@po_c_error  typ_c_error output,  
	@po_d_error  typ_d_error output)  
----------------------------------------------------------------------  
--------  
--Objetivo:   
--Lista de Involucrados: disponer de la lista de perfiles (id y desc del perfil)  
--involucrados (destinatarios) para una tarea.   
--Par?metros de entrada: pi_id_tarea; id de la tarea  
--Par?metros de salida:  po_c_error y po_d_error  
------------------------------------------------------------------------------  
as  
  
begin  
  
  --Validaci?n de Par?metros de Entrada  
  if (@pi_id_usuario is null or @pi_id_usuario = 0)   
  begin  
      set @po_c_error = 3
      set @po_d_error = 'No se recibi? id_usuario'  
      return   
  end  
   
  declare   
    @c_tipo_aviso           numeric(18,0),  
    @min_n_nivel_mensaje    integer,  
    @cant_filas int  
    
  set @po_c_error = 0  
  set @po_d_error = null  
  
  select @min_n_nivel_mensaje = min(p.n_nivel_mensaje)  
    from sast_usuarios_perfiles up, sast_perfiles p  
   where up.id_usuario = @pi_id_usuario  
     and up.id_perfil = p.id_perfil  
     and n_nivel_mensaje > 0  
    
  --si el perfil q ingresa es de ADMIN SISTEMA;   
  if exists(select p.id_perfil  
  
              from sast_usuarios_perfiles up, sast_perfiles p  
             where up.id_usuario = @pi_id_usuario  
               and up.id_perfil = p.id_perfil  
               and p.id_perfil = 4    
            )       
  begin  
        select p.id_perfil, p.d_perfil  
          from sast_perfiles p  
          where p.id_perfil in (5,7,8) -- Adm Sistema Becas, Auditoria, Supervisor becas  
  end  
  else   
        select p.id_perfil, p.d_perfil  
          from sast_perfiles p  
          where p.n_nivel_mensaje > @min_n_nivel_mensaje   
  
  set @po_c_error = @@error,  
      @cant_filas = @@rowcount  
  if (@po_c_error  <> 0)  
    begin     
      set @po_d_error = convert(varchar,@po_c_error)   
              + ' - Error al obtener lista de perfiles del usuario:  ' +   
              convert (varchar(18), @pi_id_usuario)    
	  return	
    end  
    
  if (@cant_filas = 0)  
    begin  
      set @po_c_error = 2  
      set @po_d_error = 'No se encontraron datos para el usuario: ' +    
                        convert (varchar(18), @pi_id_usuario)                 
      return                                                               
    end  
  
end  --sp_obtiene_lista_invol

go 

Grant Execute on dbo.sp_obtiene_lista_invol to GrpTrpSabed 
go

sp_procxmode 'sp_obtiene_lista_invol', anymode
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_obtiene_lista_tareas'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_obtiene_lista_tareas" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_obtiene_lista_tareas ( 
@pi_id_usuario              numeric(18,0), 
@pi_fecha                   varchar(19), 
@po_c_error                 typ_c_error output, 
@po_d_error                 typ_d_error output 
) 
as 
--objetivo: Obtener la lista de Tareas, por usuario, por perfiles del usuario  
--y  por fecha (YYYYMMDD) que el usuario selecciona a trav?s del calendario disponible 
--en la pantalla principal. Esta lista contiene los campos especificados  
--en las reglas de negocio m?s el identificador de cada tarea. 
 
begin 
  declare  
    @aux                    varchar(250), 
    @id_ong                 numeric(18,0), 
    @c_tipo_tarea           numeric(18,0), 
    @id_dummy               numeric(18,0) 
 
  --obtener ong del usuario: @pi_id_usuario  
  execute sp_obtiene_ong_usu  @pi_id_usuario = @pi_id_usuario, 
                              @pi_id_perfil  = @id_dummy, 
                              @po_id_ong     = @id_ong output, 
                              @po_c_error    = @po_c_error output, 
                              @po_d_error    = @po_d_error output 
                                
  if (@po_c_error  <> 0)    
  begin 
	  set @po_d_error = 'Error llamando a sp_obtiene_ong_usu : ' + @po_d_error 
      return     
  end 
   
  set @aux = 'el valor de ong es: ' + convert(char(18),@id_ong)   
  print @aux 
   
  set @po_c_error = 0   
  set @po_d_error = null 
 
  --procedure q retorna los codigos del tipo de aviso TAREA --16 
  execute sp_obtiene_cod_aviso @po_id_parametro   = @c_tipo_tarea output,             
                               @po_c_error        = @po_c_error output, 
                               @po_d_error        = @po_d_error output 
                                
  if (@po_c_error  <> 0) 
    begin 
	  set @po_d_error = 'Error llamando a sp_obtiene_cod_aviso : ' + @po_d_error		 
      return     
  end   
 
 
  --Las tareas que carg? el usuario como propias con  
  --fechas de alta=fecha seleccionada por el usuario, con destino alg?n otro ROL 
 
  --Las tareas que alg?n otro usuario carg? como destinatario alguno de los  
  --perfiles que posee el usuario y que tiene fecha de aviso=fecha seleccionada 
  --por el usuario. Importante: En el caso de tutor, solo mostrar los mensajes 
  --de su ONG, no la de las dem?s. 
 
  --av.id_origen                = @pi_id_usuario 
 
  -- c_tipo_tarea indica si es aviso 
      select id_aviso, id_origen,  
             convert(char(12),av.f_envio,112) f_envio,  
             x_cuerpo_mensaje, 
             pa.id_parametro code_evento_calend, 
             pa.d_valor desc_evento_calend 
        from saft_avisos av, sapt_parametros pa 
       where av.id_origen                = @pi_id_usuario 
         and av.c_evento_calend          = pa.id_parametro 
         and av.c_tipo_aviso             = @c_tipo_tarea          
         and convert(char(12),av.f_envio,112) = @pi_fecha          
         and av.f_baja is null 
       union
      select distinct av.id_aviso,  
             av.id_origen emisor_mensaje,  
             convert(char(12),av.f_envio,112) f_envio,  
             av.x_cuerpo_mensaje, 
	           pa.id_parametro code_evento_calend, 
             pa.d_valor desc_evento_calend 
        from saft_avisos av, 
             saft_avisos_destinatarios avd, 
             sapt_parametros pa 
       where av.id_origen <> @pi_id_usuario  
         and av.id_aviso = avd.id_aviso 
         and av.c_evento_calend = pa.id_parametro 
         and av.c_tipo_aviso = @c_tipo_tarea 
         and convert(char(12),av.f_envio,112) = @pi_fecha 
         and av.f_baja is null 
         and (avd.id_usuario = @pi_id_usuario 
              or (   avd.id_perfil = any  (select usuper.id_perfil 
                                             from sast_usuarios_perfiles usuper 
                                            where usuper.id_usuario = @pi_id_usuario 
                                              and usuper.e_usu_perfil = 'D') 
                   and (  av.id_origen in (Select fund.id_usuario 
                                             from sasv_usuarios_fund fund 
                                            where fund.id_usuario = av.id_origen)-- fundacion 
                       or av.id_origen in (Select ong.id_usuario 
                                             from sasv_usuarios_ongs ong 
                                            where ong.id_ong = @id_ong 
                                              and ong.id_usuario = av.id_origen) -- Persona de mi misma ONG 
                       ) 
                 ) 
             ) 
 
  set @po_c_error = @@error     
 
  if (@po_c_error  <> 0) 
    begin 
      set @po_d_error = 'Error al obtener tareas del usuario: ' +  
                        convert (varchar(18), @pi_id_usuario) 
	  return 
    end 
     
end --sp_obtiene_lista_tareas
 
go 

Grant Execute on dbo.sp_obtiene_lista_tareas to GrpTrpSabed 
go

sp_procxmode 'sp_obtiene_lista_tareas', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_obtiene_ong_usu'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_obtiene_ong_usu" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_obtiene_ong_usu( 
@pi_id_usuario      numeric(18,0), 
@pi_id_perfil       numeric(18,0), 
@po_id_ong          numeric(18,0) output, 
@po_c_error         typ_c_error   output, 
@po_d_error         typ_d_error   output 
) 
as 
/* 
Objetivo: obtiene la ong del usuario informado 
---------------------------------------------------------------------- 
si el usuario tiene perfil de FUNDACION: @po_id_ong se retorna en null 
---------------------------------------------------------------------- 
*/ 
 
begin 
 
  declare @e_definitivo    char(1), 
          @id_ong          numeric(18,0), 
          @m_fundacion     varchar(1) 
 
  set @po_c_error = 0 
  set @po_d_error = null 
  set @id_ong = null 
   
  if @pi_id_perfil = 0  
        set @pi_id_perfil = null 
 
  --procedure q retorna los codigos del estado de registro definitivo 
  execute sp_obtiene_e_definitivo @po_c_valor  = @e_definitivo output, 
                                  @po_c_error  = @po_c_error output, 
                                  @po_d_error  = @po_d_error output 
                                
  if (@po_c_error  <> 0) 
	begin
		set @po_d_error = 'Error llamando a sp_obtiene_e_definitivo : ' + @po_d_error
		return        
	end
 
  -- 
  -- usuario de ONG ? de FUNDACION 
  --, se obtiene de personas_ong  
  Select @id_ong = ong.id_ong, 
         @m_fundacion = ong.m_fundacion 
    from sast_usuarios usu, 
         saft_personas_ong perong, 
         saft_ongs ong 
   Where usu.id_usuario = @pi_id_usuario  
     and usu.id_persona = perong.id_persona 
     and ong.id_ong = perong.id_ong 
     and ong.e_registro = @e_definitivo 
     and usu.e_usuario = @e_definitivo 
     and perong.e_registro = @e_definitivo 
 
  set @po_c_error = @@error 
   
  if (@po_c_error  <> 0)  
    begin    
      set @po_d_error = convert(varchar,@po_c_error)  
                        + ' - Error al consultar el id_ong de un usuario'  
      return 
  end  
   
  -- Si es fundacion no filtra por ong 
  if (@id_ong is not null)  
  begin  
        if (@m_fundacion = 'S') set @id_ong = NULL  
  end       
  else -- id_ong is null      
    begin  
       
      select distinct @id_ong = tut.id_ong 
        from sast_usuarios usu, 
             sast_usuarios_perfiles usuper, 
             saft_tutores tut 
       where usu.id_usuario = @pi_id_usuario  
         and usu.id_usuario = usuper.id_usuario 
         and tut.id_persona = usu.id_persona          
         and usuper.id_perfil = isNull(@pi_id_perfil,usuper.id_perfil) 
         and usu.e_usuario = @e_definitivo          
         and tut.e_registro = @e_definitivo 
         and usuper.id_usuario in (select id_usuario 
                                           from sast_usuarios_perfiles 
                                          where id_usuario = @pi_id_usuario  
                                            and e_usu_perfil = @e_definitivo 
                                         ) 
 
      set @po_c_error = @@error 
      if (@po_c_error  <> 0)  
      begin    
         set @po_d_error = convert(varchar,@po_c_error)  
                           + ' - Error al consultar el id de ONG de un usuario' 
         return 
      end 
 
    end --else 
 
  set @po_id_ong = @id_ong 
   
end --sp_obtiene_ong_usu
 
go 

Grant Execute on dbo.sp_obtiene_ong_usu to GrpTrpSabed 
go

sp_procxmode 'sp_obtiene_ong_usu', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_obtiene_prfl_adm'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_obtiene_prfl_adm" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_obtiene_prfl_adm (
@po_id_perfil numeric(18,0) output,
@po_c_error   typ_c_error   output,
@po_d_error   typ_d_error   output
)
as

--objetivo: 
--

begin

  set @po_c_error = 0
  set @po_d_error = null

  set @po_id_perfil = 1

  set @po_c_error = @@error    

  if (@po_c_error  <> 0)
    begin 
      set @po_d_error =  convert(varchar,@po_c_error) 
                         + ' - Error al obtener perfil de tutor administrativo. '
	  return
  end
end --sp_obtiene_prfl_adm 
 
go 

Grant Execute on dbo.sp_obtiene_prfl_adm to GrpTrpSabed 
go

sp_procxmode 'sp_obtiene_prfl_adm', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_obtiene_prfl_coord_tut'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_obtiene_prfl_coord_tut" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_obtiene_prfl_coord_tut (
-- drop procedure sp_obtiene_prfl_coord_tut
@po_id_perfil numeric(18,0) output,
@po_c_error   typ_c_error   output,
@po_d_error   typ_d_error   output
)
as

--objetivo: 
--

begin

  set @po_c_error = 0
  set @po_d_error = null

  set @po_id_perfil = 3

  set @po_c_error = @@error    

  if (@po_c_error  <> 0)
    begin 
      set @po_d_error =  convert(varchar,@po_c_error) 
                         + ' - Error al obtener perfil de coord de tutores. '
	  return
  end
end --sp_obtiene_prfl_coord_tut
 
go 

Grant Execute on dbo.sp_obtiene_prfl_coord_tut to GrpTrpSabed 
go

sp_procxmode 'sp_obtiene_prfl_coord_tut', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_obtiene_prfl_eqBecas'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_obtiene_prfl_eqBecas" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_obtiene_prfl_eqBecas ( 
@po_id_perfil numeric(18,0) output, 
@po_c_error   typ_c_error   output, 
@po_d_error   typ_d_error   output 
) 
as 
 
--objetivo:  
-- 
 
begin 
 
  set @po_c_error = 0 
  set @po_d_error = null 
 
  set @po_id_perfil = 5 
 
  set @po_c_error = @@error     
 
  if (@po_c_error  <> 0) 
    begin  
      set @po_d_error =  convert(varchar,@po_c_error)  
                         + ' - Error al obtener perfil del equipo de becas' 
	  return 
  end 
  
end --sp_obtiene_prfl_eqBecas
 
go 

Grant Execute on dbo.sp_obtiene_prfl_eqBecas to GrpTrpSabed 
go

sp_procxmode 'sp_obtiene_prfl_eqBecas', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_obtiene_prfl_ped'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_obtiene_prfl_ped" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_obtiene_prfl_ped (
@po_id_perfil numeric(18,0) output,
@po_c_error   typ_c_error   output,
@po_d_error   typ_d_error   output
)
as

--objetivo: obtiene el id de perfil de tutor pedagogico
--

begin

  set @po_c_error = 0
  set @po_d_error = null

  set @po_id_perfil = 2

  set @po_c_error = @@error    
  if (@po_c_error  <> 0)
    begin 
      set @po_d_error =  convert(varchar,@po_c_error) 
                         + ' - Error al obtener perfil de tutor pedagogico. '
	  return
  end
end --sp_obtiene_prfl_ped
 
go 

Grant Execute on dbo.sp_obtiene_prfl_ped to GrpTrpSabed 
go

sp_procxmode 'sp_obtiene_prfl_ped', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_obtiene_q_coord_tut'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_obtiene_q_coord_tut" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_obtiene_q_coord_tut (
@pi_id_ong   numeric(18,0),
@po_q_coord  integer     output,
@po_c_error  typ_c_error output,
@po_d_error  typ_d_error output
)
as

--objetivo: obtiene para una ong en particular la cantidad de coordinadores 
--de tutores
--
  declare @id_perfil    numeric(18,0),
          @e_definitivo char(1)

  set @po_c_error = 0
  set @po_d_error = null

  --procedure q retorna los codigos del estado de registro definitivo
  execute sp_obtiene_e_definitivo @po_c_valor  = @e_definitivo output,
                                  @po_c_error  = @po_c_error output,
                                  @po_d_error  = @po_d_error output
                               
  if (@po_c_error  <> 0)
  begin
	 set @po_d_error = 'Error llamando a sp_obtiene_e_definitivo : ' + @po_d_error 
     return       
  end  
  
  execute sp_obtiene_prfl_coord_tut @po_id_perfil = @id_perfil output,
                                    @po_c_error   = @po_c_error output,
                                    @po_d_error   = @po_d_error output
                               
  if (@po_c_error  <> 0)
  begin
	 set @po_d_error = 'Error llamando a sp_obtiene_prfl_coord_tut : ' + @po_d_error   
     return       
  end  

  select @po_q_coord = count(t.id_tutor)
  from   sast_usuarios u,
         sast_usuarios_perfiles up,
         saft_tutores t       
  where  u.id_usuario = up.id_usuario
    and  u.id_persona = t.id_persona
    and  up.id_perfil = @id_perfil
    and  t.id_ong = @pi_id_ong
    and  up.e_usu_perfil = @e_definitivo
    and  u.e_usuario = @e_definitivo

  set @po_c_error = @@error    
  if (@po_c_error  <> 0)
    begin  
    set @po_d_error = convert(varchar,@po_c_error) 
                 + 'Error al obtener la cantidad de coordinadores de tutores. '
    return                 
  end --sp_obtiene_q_coord_tut
 
go 

Grant Execute on dbo.sp_obtiene_q_coord_tut to GrpTrpSabed 
go

sp_procxmode 'sp_obtiene_q_coord_tut', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_obtiene_recargas_alu'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_obtiene_recargas_alu" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_obtiene_recargas_alu (    
@pi_id_alumno     numeric(18,0),    
@po_c_error       typ_c_error   output,    
@po_d_error       typ_d_error   output    
)    
as    
--    
-- Objetivo: Obtener las fechas de recarga que tuvo un alumno   
--    
    
begin    
    
  declare @id_periodo_recarga  numeric(18,0),     
          @d_periodo           varchar(40),  
          @cant_filas          int,  
          @f_recarga           varchar(12),  
          @f_fin_periodo        smalldatetime  
    
  create table #salida (id_periodo_recarga  numeric(18,0) null,     
                        d_periodo           varchar(40) null,        
                        f_recarga           varchar(12) null,  
                        f_fin_periodo       smalldatetime null)  
    
  declare curs cursor for    
    select pr.id_periodo_recarga,  
           pr.d_periodo,  
           pr.f_fin_periodo  
      from sact_periodos_recargas pr,  
           saat_alumnos alu  
     where alu.id_alumno = @pi_id_alumno  
       and pr.f_fin_periodo >= alu.f_resul_prop  
       and datepart (yy,pr.f_fin_periodo) = datepart (yy,alu.f_resul_prop)  
    
  If @pi_id_alumno is null or @pi_id_alumno = 0   
    begin   
      set @po_d_error =  'No se recibio identificador de alumno'    
      set @po_c_error = 3   
  end   
      
  set @po_c_error = 0    
  set @po_d_error = null    

  delete from #salida
    
  open curs    
        
    fetch curs into @id_periodo_recarga,@d_periodo,@f_fin_periodo  
    while (@@sqlstatus != 2)    
      begin    
          
        --  
        -- Obtengo la fecha de recarga del alumno en el periodo  
        Select @f_recarga = convert(varchar(12),max(lp.f_recarga),103)   
          from sart_lotes_pago lp,   
               sart_lotes_det_pago ldp,  
               sart_lotes_recarga lr,   
               sart_lotes_det_recarga ldr,   
               saat_alumnos_tarjetas alt   
         where lp.e_lote_pago <> 'RECHAZADO'   
           and lp.id_lote_pago = ldp.id_lote_pago   
           and ldp.id_lote_det_recarga = ldr.id_lote_det_recarga   
           and lr.id_periodo_recarga = @id_periodo_recarga  
           and lr.id_lote_recarga = ldr.id_lote_recarga  
           and ldr.id_alu_tar = alt.id_alu_tar   
           and alt.id_alumno = @pi_id_alumno  
         
        set @po_c_error = @@error,@cant_filas=@@rowcount  
        if (@po_c_error  <> 0)    
          begin     
            set @po_d_error =  'Error la intentar obtener las recargas del Id de periodo ('+convert(varchar(18),@id_periodo_recarga)+')'  
        end   
          
        If @cant_filas = 0 set @f_recarga = null 
          
        Insert into #salida (id_periodo_recarga,d_periodo,f_recarga,f_fin_periodo)  
                     values (@id_periodo_recarga,@d_periodo,@f_recarga,@f_fin_periodo)  
          
        fetch curs into @id_periodo_recarga,@d_periodo,@f_fin_periodo  
          
      end    
        
  close curs  
    
  --    
  -- Genero la salida    
  Select id_periodo_recarga,  
         d_periodo,  
         f_recarga  
    from #salida    
   order by f_fin_periodo  
        
  set @po_c_error = @@error,      
      @cant_filas = @@rowcount            
  if (@po_c_error  <> 0)      
  begin       
      set @po_d_error = 'Error al consultar el detalle de las recargas'           
  end         
  if (@cant_filas = 0)       
    begin       
      set @po_c_error = 1      
      set @po_d_error = 'No se encontraron registros de recargas'      
      return             
  end    
     
end -- sp_obtiene_recargas_alu
 
go 

Grant Execute on dbo.sp_obtiene_recargas_alu to GrpTrpSabed 
go

sp_procxmode 'sp_obtiene_recargas_alu', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_obtiene_tbeca_alumno'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_obtiene_tbeca_alumno" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_obtiene_tbeca_alumno (  
@pi_id_alumno     numeric(18,0),  
@pi_f_consulta    smalldatetime, 
@po_id_tipo_beca  numeric(18,0) output,  
@po_valor_beca    numeric(18,0) output,     
@po_c_error       typ_c_error   output,  
@po_d_error       typ_d_error   output  
)  
as  
--  
-- Objetivo: Obtener la poliza de un alumno  
--           y su valor segun la fecha de consulta 
--  
  
begin  
  
  If (@pi_id_alumno is null or @pi_id_alumno = 0)
    begin 
      set @po_d_error =  'No se recibio identificador de alumno'  
      set @po_c_error = 3
	  return
  end 
   
  If (@pi_f_consulta is null)
    begin 
      set @po_d_error =  'No se recibi? fecha de visualizaci?n'  
      set @po_c_error = 3
	  return
  end 
   
  declare 
    @cant numeric (18,0) 
    
  set @po_c_error = 0  
  set @po_d_error = null  
  
  Select @po_id_tipo_beca = alu.id_tipo_beca 
    from saat_alumnos alu 
   where alu.id_alumno=@pi_id_alumno 
--     and alu.f_alta <= @pi_f_consulta 
    
  set @po_c_error = @@error,@cant = @@rowcount     
  if (@po_c_error  <> 0)  
    begin   
      set @po_d_error =  'Error la intentar obtener el tipo de beca del alumno '  
	  return
  end  
  if (@cant = 0)     
    begin   
      set @po_d_error =  'El alumno '+convert(varchar(18),@pi_id_alumno)+' no existe en la base '  
      set @po_c_error = 2
	  return
  end  
   
  if (@po_id_tipo_beca is null) set @po_valor_beca = 0
  else 
    begin 
     
    -- 
    -- obtengo el valor de la beca 
    Select @po_valor_beca  = tbd.i_beca 
      from saat_tipo_beca_detalle tbd, 
           saat_tipo_beca tb 
     where tbd.id_tipo_beca = @po_id_tipo_beca 
       and tbd.f_vigencia_hasta >= @pi_f_consulta 
       and tbd.f_vigencia_desde <= @pi_f_consulta     
       and tb.id_tipo_beca = tbd.id_tipo_beca 
       and (tb.f_baja is null or tb.f_baja >= @pi_f_consulta) 
     
    set @po_c_error = @@error,@cant = @@rowcount     
    if (@po_c_error  <> 0)  
      begin   
        set @po_d_error =  'Error al intentar obtener el valor del tipo de beca ID:'+convert(varchar(18),@po_id_tipo_beca) 
		return
    end  
    if (@cant =0)     
      begin   
        set @po_valor_beca = 0
        --set @po_d_error =  'El tipo de beca ID '+convert(varchar(18),@po_id_tipo_beca)+ ' No tiene valor para la fecha '+ convert (char(12),@pi_f_consulta,3)  
        --set @po_c_error = 3  
		return
    end  
     
  end -- de ver si se concontr? el tipo de beca 
   
end -- sp_obtiene_tbeca_alumno
 
go 

Grant Execute on dbo.sp_obtiene_tbeca_alumno to GrpTrpSabed 
go

sp_procxmode 'sp_obtiene_tbeca_alumno', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_obtiene_tipo_tel_fijo'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_obtiene_tipo_tel_fijo" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_obtiene_tipo_tel_fijo( 
@po_c_valor  numeric(18,0)   output, 
@po_c_error  typ_c_error     output, 
@po_d_error  typ_d_error     output 
) 
------------------------------------------------------------------------------ 
--Objetivo: Informar los codigos de tipo de telefono fijo, de manera de  
--          encapsular el numero de codigo. 
--Par?metros de entrada: -- 
--Par?metros de salida: po_c_valor: identificador de parametros 
--                      po_c_error y po_d_error 
------------------------------------------------------------------------------ 
as 
 
begin 
   
  set @po_c_error = 0 
  set @po_d_error = null 
   
  --tipo de tel?fono particular 
  set @po_c_valor  = 40 
 
  set @po_c_error = @@error     
  if (@po_c_error  <> 0) 
    begin  
      set @po_d_error =  convert(varchar,@po_c_error)  
                         + ' - Error al obtener tipo de telefono fijo ' 
	  return
  end 
       
end --sp_obtiene_tipo_tel_fijo
 
go 

Grant Execute on dbo.sp_obtiene_tipo_tel_fijo to GrpTrpSabed 
go

sp_procxmode 'sp_obtiene_tipo_tel_fijo', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_obtiene_ultima_recarga'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_obtiene_ultima_recarga" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_obtiene_ultima_recarga (   
@pi_id_alumno     numeric(18,0),   
@po_f_ult_recarga datetime output,   
@po_c_error       typ_c_error   output,   
@po_d_error       typ_d_error   output   
)   
as   
--   
-- Objetivo: Obtener la poliza de un alumno   
--           y su valor segun la fecha de consulta  
--   
   
begin   
   
  If (@pi_id_alumno is null or @pi_id_alumno = 0)  
    begin  
      set @po_d_error =  'No se recibio identificador de alumno'   
      set @po_c_error = 3
	  return
  end  
     
  set @po_c_error = 0   
  set @po_d_error = null   
   
  Select @po_f_ult_recarga = max(convert(datetime,ldp.d_fe_recarga))  
    from sart_lotes_pago lp,  
         sart_lotes_det_pago ldp,  
         sart_lotes_det_recarga ldr,  
         saat_alumnos_tarjetas alt  
   where lp.e_lote_pago <> 'RECHAZADO'  
     and lp.id_lote_pago = ldp.id_lote_pago  
     and ldp.id_lote_det_recarga = ldr.id_lote_det_recarga  
     and ldr.id_alu_tar = alt.id_alu_tar  
     and alt.id_alumno = @pi_id_alumno  
        
  set @po_c_error = @@error  
  if (@po_c_error  <> 0)   
    begin    
      set @po_d_error =  'Error la intentar obtener la ultima recarga'   
	  return
  end   
    
end -- sp_obtiene_ultima_recarga
 
go 

Grant Execute on dbo.sp_obtiene_ultima_recarga to GrpTrpSabed 
go

sp_procxmode 'sp_obtiene_ultima_recarga', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_ong_en_ga'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_ong_en_ga" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_ong_en_ga (  
@pi_anio      int,  
@pi_id_ong    numeric(18,0),  
@po_c_error   typ_c_error   output,  
@po_d_error   typ_d_error   output  
)  
as  
--  
--objetivo: obtener la carga de ONGs que se encuentran en Guardar Avance  
--  
  
begin  
  
  set @po_c_error = 0  
  set @po_d_error = null  
        
  if @pi_id_ong = 0   
      set @pi_id_ong = null  
  
  select null id_persona, 
         null id_alumno, 
         null f_nacimiento, 
         null id_tutor_adm, 
         null id_tutor_ped, 
         o.id_ong, 
         o.d_nombre_ong apenom   
    from saft_ongs o  
   where e_registro = 'A'  
     and o.id_ong = isnull(@pi_id_ong, o.id_ong)  
     and datepart(yy,isnull(o.f_actuac,o.f_alta)) = @pi_anio  
   order by o.d_nombre_ong 
  
  set @po_c_error = @@error      
  if (@po_c_error  <> 0)  
    begin   
      set @po_d_error =  'Error en sp_ong_en_ga. '  
	  return
  end  
end -- sp_ong_en_ga
 
go 

Grant Execute on dbo.sp_ong_en_ga to GrpTrpSabed 
go

sp_procxmode 'sp_ong_en_ga', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_opciones_tablero'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_opciones_tablero" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_opciones_tablero(  
@pi_id_usuario    numeric(18,0),  
@po_lista         typ_lista   output,  
@po_c_error       typ_c_error   output,  
@po_d_error       typ_d_error   output  
)  
as  
--  
--objetivo: obtener las opciones del tablero disponibles para el usuario, de acuerdo a su  
--nivel de mensaje  
--  
  
begin  
  
  declare   
      @aux                 typ_lista,  
      @min_n_nivel_mensaje int,  
      @consulta            typ_lista,  
      @sep                 varchar(1),  
      @subSep              varchar(1)  
        
  set @po_c_error = 0  
  set @po_d_error = null  
  
  execute sp_separador_registros   
             @po_separador_registro    = @sep        output,   
             @po_separador_campo       = @subSep      output,   
             @po_c_error               = @po_c_error output,   
             @po_d_error               = @po_d_error output     
                
  if (@po_c_error  <> 0)   
    begin   
	  set @po_d_error = 'Error llamando a sp_separador_registros : ' + @po_d_error
      return       
  end   
        
  --obtengo el menor nivel de mensaje del usuario   
  select @min_n_nivel_mensaje = min(p.n_nivel_mensaje)   
    from sast_usuarios_perfiles up, sast_perfiles p   
   where up.id_usuario = @pi_id_usuario   
     and up.id_perfil = p.id_perfil   
     and n_nivel_mensaje > 0  
       
  --adjunto a la lista las opciones del nivel 2 y 3  
  if @min_n_nivel_mensaje in (2,3)  
  begin  
    
      set @consulta = 'ALU_SIN_SA' + @subSep + 'Alumnos sin Situaci?n Acad?mica' + @sep   
      set @po_lista = @po_lista + @consulta  
      set @consulta = 'ALU_SIN_RG' + @subSep + 'Alumnos sin Rendici?n de Gastos' + @sep   
      set @po_lista = @po_lista + @consulta  
      set @consulta = 'CANDIDA_GA' + @subSep + 'Candidatos en Guardar Avance' + @sep   
      set @po_lista = @po_lista + @consulta  
      set @consulta = 'ALU_SUSP' + @subSep + 'Alumnos Suspendidos' + @sep   
      set @po_lista = @po_lista + @consulta  
      set @consulta = 'ALU_BAJA' + @subSep + 'Alumnos dados de Baja' + @sep   
      set @po_lista = @po_lista + @consulta  
      set @consulta = 'ALU_RECHA' + @subSep + 'Alumnos con beca Rechazada' + @sep 
      set @po_lista = @po_lista + @consulta       
      set @consulta = 'ALU_STJ' + @subSep + 'Alumnos sin tarjeta' + @sep 
      set @po_lista = @po_lista + @consulta   
      set @consulta = 'ALU_POS' + @subSep + 'Alumnos postulados' + @sep 
      set @po_lista = @po_lista + @consulta   
      set @consulta = 'ALU_BECA' + @subSep + 'Alumnos becados'  
      set @po_lista = @po_lista + @consulta   
  end       
    
  --adjunto a la lista las opciones del nivel 1  
  if @min_n_nivel_mensaje = 1  
  begin  
  
      set @consulta = 'ALU_SIN_SA' + @subSep + 'Alumnos sin Situaci?Acad?mica' + @sep   
      set @po_lista = @po_lista + @consulta  
      set @consulta = 'ALU_SIN_RG' + @subSep + 'Alumnos sin Rendici?n de Gastos' + @sep   
      set @po_lista = @po_lista + @consulta  
      set @consulta = 'CANDIDA_GA' + @subSep + 'Candidatos en Guardar Avance' + @sep   
      set @po_lista = @po_lista + @consulta  
      set @consulta = 'ALU_SUSP' + @subSep + 'Alumnos Suspendidos' + @sep   
      set @po_lista = @po_lista + @consulta  
      set @consulta = 'ALU_BAJA' + @subSep + 'Alumnos dados de Baja' + @sep   
      set @po_lista = @po_lista + @consulta  
      set @consulta = 'ALU_RECHA' + @subSep + 'Alumnos con beca Rechazada' + @sep   
      set @po_lista = @po_lista + @consulta        
      set @consulta = 'ONG_GA' + @subSep + 'ONGs en Guardar Avance' + @sep   
      set @po_lista = @po_lista + @consulta  
      set @consulta = 'ALU_STJ' + @subSep + 'Alumnos sin tarjeta' + @sep 
      set @po_lista = @po_lista + @consulta   
      set @consulta = 'ALU_POS' + @subSep + 'Alumnos postulados' + @sep 
      set @po_lista = @po_lista + @consulta   
      set @consulta = 'ALU_BECA' + @subSep + 'Alumnos becados'  
      set @po_lista = @po_lista + @consulta  
        
  end  
    
  --set @aux = convert (varchar, char_length(@po_lista)) + '-' + @po_lista  
  --print @aux  
    
  set @po_c_error = @@error      
  if (@po_c_error  <> 0)  
    begin   
      set @po_d_error =  'Error en sp_opciones_tablero. '  
	  return	
  end  
end -- sp_opciones_tablero
 
go 

Grant Execute on dbo.sp_opciones_tablero to GrpTrpSabed 
go

sp_procxmode 'sp_opciones_tablero', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_otorgar_beca'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_otorgar_beca" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_otorgar_beca(	 
@pi_id_usuario      numeric(18,0), 
@pi_id_alumno       numeric(18,0), 
@pi_id_ong          numeric(18,0), 
@pi_x_observ_prop   varchar(250), 
@po_c_error         typ_c_error output, 
@po_d_error         typ_d_error output 
) 
as 
/* 
Objetivo: se otorga la beca al alumno marcandolo como BECADO 
*/ 
 
begin 
 
  if (@pi_id_usuario is null or @pi_id_usuario = 0)
    begin 
      set @po_c_error = 3
      set @po_d_error = 'No se recibi? pi_id_usuario. ' 
      return        
  end 
 
  if (@pi_id_alumno is null or @pi_id_alumno = 0)
    begin 
      set @po_c_error = 3
      set @po_d_error = 'No se recibi? pi_id_alumno. ' 
      return        
  end 
   
  declare  
    @id_persona        numeric(18,0), 
    @q_becas           int, 
    @q_becados         int, 
    @id_usu_tut_adm    numeric(18,0), 
    @id_usu_tut_ped    numeric(18,0), 
    @mensaje           varchar(82), 
    @fecha_sistema     smalldatetime, 
    @dummy             numeric(18,0), 
    @nombre_ong        varchar(40) 
     
  set @po_c_error = 0 
  set @po_d_error = null 
   
  --verificamos q el alumno este en estado de prop NUEVA 
  if not exists (select 1 
              from saat_alumnos alu 
             where alu.id_alumno = @pi_id_alumno   
               --and e_estado_prop = 'ANALISIS' 
               and e_alumno = 'POSTULANTE' 
             ) 
  begin 
      set @po_d_error =  'Error, el alumno no es postulante. ' 
      set @po_c_error = 2
      return         
  end 
   
  -- 
  --verificamos q la persona no tenga una beca ACTIVA, q fue otorgada con otro id_alumno 
  select @id_persona = id_persona 
  from saat_alumnos alu 
  where alu.id_alumno = @pi_id_alumno   
  -- 
  if exists (select 1 
              from saat_alumnos alu 
             where id_persona = @id_persona 
               and e_alumno = 'BECADO'                
             ) 
  begin 
      set @po_d_error =  'Error, la persona tiene dada una beca con id_persona:. ' + 
                         convert(varchar,@id_persona) 
      set @po_c_error = 2
      return         
  end  
  
  /* 
  execute sp_valida_q_becas_ong  --('BECADO', 'SUSPENDIDO','POSTULANTE')
      @pi_id_ong           = @pi_id_ong, 
      @po_c_error          = @po_c_error output,  
      @po_d_error          = @po_d_error output 
       
  if (@po_c_error  <> 0) 
  begin  
      return  
  end   
  */
  
  update saat_alumnos 
  set e_alumno = 'BECADO', 
      f_resul_prop = getDate(), 
      e_estado_prop = 'TERMINADO', 
      x_observ_resul_prop = @pi_x_observ_prop, 
      f_actuac = getDate(), 
      c_usua_actuac = @pi_id_usuario 
  where id_alumno = @pi_id_alumno    
  
  set @po_c_error = @@error     
  if (@po_c_error  <> 0) 
  begin  
      set @po_d_error =  convert(varchar,@po_c_error)  
                         + ' - Error en sp_otorga_beca. ' 
      return 
  end 
 
  --mandamos el aviso al tutor adm. del alumno 
   

      
  select @mensaje = 'Se ha otorgado la beca al alumno: '+ d_apellido + ', ' + d_nombre 
    from sagt_personas 
  where id_persona = @id_persona 
   
  set @fecha_sistema = getDate() 

  --obtengo los tutores:
  --administrativo  
  select @id_usu_tut_adm = usu.id_usuario 
    from sagt_alumnos_tutores alutut, 
         saft_tutores         tut, 
         sast_usuarios        usu 
   where alutut.id_alumno = @pi_id_alumno 
     and alutut.id_tutor = tut.id_tutor 
     and tut.id_persona = usu.id_persona 
     and alutut.id_perfil = 1 
     and tut.e_registro = 'D' 
     and usu.e_usuario = 'D' 

  execute sp_inserta_mensaje  
      @pi_id_usuario       = @pi_id_usuario, 
      @pi_id_origen        = @pi_id_usuario, 
      @pi_id_usuario_dest  = @id_usu_tut_adm, 
      @pi_id_perfil_dest   = @dummy, 
      @pi_x_cuerpo_mensaje = @mensaje, 
      @pi_f_envio          = @fecha_sistema, 
      @po_c_error          = @po_c_error output,  
      @po_d_error          = @po_d_error output 
      
  if (@po_c_error  <> 0) 
  begin  
	  set @po_d_error = 'Error llamando a sp_inserta_mensaje a tut admin: ' + @po_d_error
      return  
  end 

  --pedagogico
  select @id_usu_tut_ped = usu.id_usuario 
    from sagt_alumnos_tutores alutut, 
         saft_tutores         tut, 
         sast_usuarios        usu 
   where alutut.id_alumno = @pi_id_alumno 
     and alutut.id_tutor = tut.id_tutor 
     and tut.id_persona = usu.id_persona 
     and alutut.id_perfil = 2
     and tut.e_registro = 'D' 
     and usu.e_usuario = 'D' 

  execute sp_inserta_mensaje  
      @pi_id_usuario       = @pi_id_usuario, 
      @pi_id_origen        = @pi_id_usuario, 
      @pi_id_usuario_dest  = @id_usu_tut_ped, 
      @pi_id_perfil_dest   = @dummy, 
      @pi_x_cuerpo_mensaje = @mensaje, 
      @pi_f_envio          = @fecha_sistema, 
      @po_c_error          = @po_c_error output,  
      @po_d_error          = @po_d_error output 
       
  if (@po_c_error  <> 0) 
  begin  
	  set @po_d_error = 'Error llamando a sp_inserta_mensaje a tut ped: ' + @po_d_error
      return  
  end 
         
end --sp_otorgar_beca
 
go 

Grant Execute on dbo.sp_otorgar_beca to GrpTrpSabed 
go

sp_procxmode 'sp_otorgar_beca', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_parametros_grupos'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_parametros_grupos" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_parametros_grupos  ( 



@pi_id_grupo 	numeric(18,0), 



@po_c_error typ_c_error output, 



@po_d_error typ_d_error output 



)    as        



/*       



Objetivo: se lo llama para retornar el id, la descripcion y la cantidad de cuotas de todos los grupos. 



*/           



  



begin        



        



        



select c_cuotas     



  from sapt_param_grupos  

  where id_grupo = @pi_id_grupo		

  order by id_grupo




end
 
go 

Grant Execute on dbo.sp_parametros_grupos to Usr_trp_SABED 
go

sp_procxmode 'sp_parametros_grupos', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_propuesta_beca'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_propuesta_beca" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_propuesta_beca(  
@pi_id_usuario      numeric(18,0),  
@pi_id_alumno       numeric(18,0),  
@pi_c_beca          numeric(18,0),  
@pi_x_observ_prop   varchar(250),  
@po_c_error         typ_c_error output,  
@po_d_error         typ_d_error output  
)  
as  
/*  
Objetivo: El alumno se marca como POSTULANTE; y se env?a un aviso al equipo de becas 
*/  
  
begin  
  
  if (@pi_id_usuario is null or @pi_id_usuario = 0) 
    begin  
      set @po_c_error = 3 
      set @po_d_error = 'No se recibi? pi_id_usuario'  
      return         
  end  

  if (@pi_id_alumno is null or @pi_id_alumno=0)
    begin  
      set @po_c_error = 3 
      set @po_d_error = 'No se recibi? pi_id_alumno'  
      return         
  end  

  if (@pi_c_beca is null or @pi_c_beca=0)
    begin  
      set @po_c_error = 3 
      set @po_d_error = 'No se recibi? pi_c_beca'  
      return         
  end  

  
  declare         
    @mensaje           varchar(250),  
    @fecha_sistema     smalldatetime,  
    @dummy             numeric(18,0),  
    @id_ong            numeric(18,0)  
    
  --verificamos q el alumno este en estado de prop NUEVA  
  if exists (select 1  
              from saav_alu_tut_ong alu  
             where alu.id_alumno = @pi_id_alumno    
               and alu.e_registro_alu <> 'D'  
               and alu.e_registro_per <> 'D'  
             )  
  begin  
      set @po_d_error =  'Error, los datos del alumno no se encuentran en estado Definitivo. '  
      set @po_c_error = 2 
      return          
  end    
  
  set @po_c_error = 0  
  set @po_d_error = null  
  
  select distinct @id_ong = tut.id_ong  
    from sagt_alumnos_tutores altut,
         saft_tutores tut
   where tut.id_tutor = altut.id_tutor
     and altut.id_alumno = @pi_id_alumno   
    
  execute sp_valida_q_becas_ong  --('BECADO', 'SUSPENDIDO','POSTULANTE')
      @pi_id_ong   = @id_ong,  
      @po_c_error  = @po_c_error output,   
      @po_d_error  = @po_d_error output  
        
  if (@po_c_error  <> 0)  
    begin   
      return   
  end    
  
  update saat_alumnos  
  set e_alumno = 'POSTULANTE',  
      f_propuesta_beca = getDate(),  
      id_tipo_beca = @pi_c_beca,  
      e_estado_prop = 'NUEVA',  
      x_observ_prop = @pi_x_observ_prop,  
      f_actuac = getDate(),  
      c_usua_actuac = @pi_id_usuario  
  where id_alumno = @pi_id_alumno        
   
  set @po_c_error = @@error       
  if (@po_c_error  <> 0)  
  begin   
      set @po_d_error =  convert(varchar,@po_c_error)   
                         + ' - Error al postular alumno. '  
      return  
  end  
    
  -------------------------------------------------------------------------------  
  --se env?a el aviso al equipo de becas de que hay una propuesta de beca nueva--  
  -------------------------------------------------------------------------------  
    
  select @mensaje = 'Se ha propuesto la beca de la ONG: ' + d_nombre_ong + ' al alumno: '+ d_apellido_alu + ', ' + d_nombre_alu + ' con n?mero de documento : ' + convert(varchar,n_documento_alu)  
    from saav_alu_tut_ong v   
   where v.id_alumno = @pi_id_alumno  
    
  set @fecha_sistema = getDate()  
    
  insert into sabed_log (descrip) values (@mensaje)  
     
  execute sp_inserta_mensaje   
      @pi_id_usuario       = @pi_id_usuario,  
      @pi_id_origen        = @pi_id_usuario,  
      @pi_id_usuario_dest  = @dummy,  
      @pi_id_perfil_dest   = 5,  
      @pi_x_cuerpo_mensaje = @mensaje,  
      @pi_f_envio          = @fecha_sistema,  
      @po_c_error          = @po_c_error output,   
      @po_d_error          = @po_d_error output  
        
  if (@po_c_error  <> 0)  
  begin   
	  set @po_d_error = 'Error llamando a sp_inserta_mensaje : ' + @po_d_error 
      return   
  end    
    
end --sp_propuesta_beca 
 
go 

Grant Execute on dbo.sp_propuesta_beca to GrpTrpSabed 
go

sp_procxmode 'sp_propuesta_beca', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_puesta_al_pago_recargas'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_puesta_al_pago_recargas" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_puesta_al_pago_recargas(    
@pi_id_usuario          numeric(18,0),   
@pi_id_lote             numeric(18,0),    
@pi_id_adm_equipo_becas numeric(18,0),   
@pi_f_oper_eq_becas     varchar(20),     
@pi_l_alu               typ_lista,      
@po_c_error             typ_c_error output,   
@po_d_error             typ_d_error output   
)   
as   
/*   
Objetivo: inserta los lotes de recargas con alumnos   
@pi_l_alu es de la forma:    
@id_alu_tar:@e_alumno:@q_recargas:@id_tipo_beca:@x_observacion   
*/   
   
begin   
   
  if (@pi_id_usuario is null or @pi_id_usuario = 0 ) 
    begin   
      set @po_c_error = 3  
      set @po_d_error = 'No se recibi? pi_id_usuario'   
      return          
  end   
    
  if (@pi_id_lote is null or @pi_id_lote = 0) 
    begin   
      set @po_c_error = 3  
      set @po_d_error = 'No se recibi? pi_id_lote'   
      return          
  end   
   
  if (@pi_id_adm_equipo_becas is null or @pi_id_adm_equipo_becas = 0)  
    begin   
      set @po_c_error = 3  
      set @po_d_error = 'No se recibi? pi_id_adm_equipo_becas'   
      return          
  end   
   
  if (@pi_f_oper_eq_becas is null) 
    begin   
      set @po_c_error = 3  
      set @po_d_error = 'No se recibi? pi_f_oper_eq_becas'   
      return          
  end   
   
  if (@pi_l_alu is null)  
    begin   
      set @po_c_error = 3  
      set @po_d_error = 'No se recibi? pi_l_alu'   
      return          
  end   
    
   
  declare @f_oper_coordinador  datetime,   
          @f_oper_eq_becas     datetime,   
          @f_oper_sup_eq_becas datetime  
   
  set @po_c_error = 0   
  set @po_d_error = null   
      
  --convierto el varchar de entrada a date    
  execute sp_convierte_char_en_fecha @pi_fecha_char     = @pi_f_oper_eq_becas,   
                                     @po_fecha_datetime = @f_oper_eq_becas output,   
                                     @po_c_error        = @po_c_error  output,   
                                     @po_d_error        = @po_d_error  output   
                              
  if (@po_c_error  <> 0)    
  begin   
      set @po_d_error ='Error llamando a sp_convierte_char_en_fecha : ' + @po_d_error   
      return     
  end   
   
  If exists (select 1   
               from sart_lotes_recarga   
              where id_lote_recarga = @pi_id_lote   
                and c_estado_lote   = 'CONFIRMADO')    
    begin  
      
      begin tran recargas   
      
      --updateo el usuario que revisa la recarga por SI o por NO   
      update sart_lotes_recarga   
         set c_estado_lote       = 'A_PAGAR',   
             id_adm_equipo_becas = @pi_id_adm_equipo_becas,   
             f_oper_eq_becas     = @f_oper_eq_becas,              
             c_usua_actuac       = @pi_id_usuario,   
             f_actuac            = getDate()   
       where id_lote_recarga = @pi_id_lote   
     
      set @po_c_error = @@error    
      if (@po_c_error  <> 0)    
        begin   
          rollback tran recargas    
          set @po_d_error =  'Error al actualizar lote de recargas. '   
          return     
      end     
   
      execute sp_inserta_det_recarga   
         @pi_id_usuario      = @pi_id_usuario,   
         @pi_id_lote         = @pi_id_lote,   
         @pi_l_alu           = @pi_l_alu,   
         @pi_valida          = 'S',  
         @po_c_error         = @po_c_error  output,   
         @po_d_error         = @po_d_error  output   
   
      if (@po_c_error  =4)-- es un manejo de error especial 
        begin   
          set @po_c_error = 2
          rollback tran recargas    
          return     
      end  
       
      if (@po_c_error  <> 0)    
        begin   
          rollback tran recargas 		 
          set @po_d_error ='Error llamando a sp_inserta_det_recarga:'+@po_d_error   
          return     
      end   
     
      commit tran recargas   
  end  
  else  
    begin  
      set @po_c_error = 3  
      set @po_d_error = 'El lote no esta en estado CONFIRMADO'   
      return          
  end  
end -- sp_puesta_al_pago_recargas 
 
go 

Grant Execute on dbo.sp_puesta_al_pago_recargas to GrpTrpSabed 
go

sp_procxmode 'sp_puesta_al_pago_recargas', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_reasignar_becarios'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_reasignar_becarios" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_reasignar_becarios( 
@pi_id_usuario      numeric(18,0), 
@pi_id_tutor_baja   numeric(18,0), 
@pi_id_perfil       numeric(18,0), 
@pi_l_bec_tut       typ_lista, 
@po_c_error         typ_c_error output, 
@po_d_error         typ_d_error output 
) 
as 
/******************************************************************************* 
Objetivo: desvincular los becarios de un tutor y asignarlos a otro 
 
Descripci?n de par?metros 
Par?metros de entrada: 
pi_id_usuario:    Usuario loggeado para auditoria 
pi_id_tutor_alta: ID de Tutor al cual se le desvincula uno o m?s Becarios. 
pi_id_tutor_baja:	ID de Tutor al cual se le adicionan uno o m?s Becarios. 
pi_l_bec_tut:     Listado de Becario/s en el siguiente formato  
                  (id_becado:id_tutor_alta) 
*******************************************************************************/ 
 
begin 
 
  if (@pi_id_usuario is null or @pi_id_usuario = 0)
    begin 
      set @po_c_error = 3 
      set @po_d_error = 'No se recibi? pi_id_usuario' 
      return        
  end 
  /* 
  if exists (select  t.id_tutor 
               from saft_tutores t, 
                    sast_usuarios u, 
                    sast_usuarios_perfiles up 
              where t.id_tutor = @pi_id_tutor_baja 
                and u.id_persona = t.id_persona 
                and u.id_usuario = up.id_usuario 
                and up.id_perfil = @pi_id_perfil 
             )  
  begin            
      set @po_c_error = 2
      set @po_d_error = 'El usuario no presenta el perfil recibido. ' 
      return 
  end              
  */            
 
  declare @sep             varchar(1), 
          @subSep          varchar(1), 
          @l_bec_tut       typ_lista, 
          @par             typ_lista, 
          @id_becado       varchar(18), 
          @id_tutor_alta   varchar(18) 
 
  execute sp_separador_registros 
             @po_separador_registro    = @sep output, 
             @po_separador_campo       = @subSep output, 
             @po_c_error               = @po_c_error output, 
             @po_d_error               = @po_d_error output                    
  if (@po_c_error  <> 0) 
    begin 
	  set @po_d_error = 'Error llamando a sp_separador_registros : ' + @po_d_error
      return     
  end   
 
  set @po_c_error = 0 
  set @po_d_error = null 
  set @l_bec_tut = @pi_l_bec_tut + @sep 
   
 
  while (@l_bec_tut is not null) 
  begin 
   
   
  --obtengo el par id_becado:id_tutor_alta 
  set @par =substring(@l_bec_tut, 1,charindex(@sep,@l_bec_tut)-1)  

   
  --obtengo el resto de la lista 
  set @l_bec_tut = substring(@l_bec_tut, 
                             charindex(@sep,@l_bec_tut)+1,  
                             char_length(@l_bec_tut) 
                             )   

   
  set @id_becado = (--convert(numeric,    
                       substring(@par, 1,charindex(@subSep,@par)-1) 
                           ) 
 
 
  set @id_tutor_alta = (--convert(numeric,    
                    substring(@par, charindex(@subSep,@par)+1,char_length(@par)) 
                        )                                                    
                         
  update sagt_alumnos_tutores 
  set id_tutor = convert(numeric,@id_tutor_alta), 
      c_usua_actuac = @pi_id_usuario, 
      f_actuac = getDate() 
  where id_tutor = @pi_id_tutor_baja 
    and id_perfil = @pi_id_perfil 
    and id_alumno = convert(numeric,@id_becado) 
 
  set @po_c_error = @@error     

  if (@po_c_error  <> 0) 
    begin  
      set @po_d_error =  convert(varchar,@po_c_error)  
                         + ' - Error en reasignar becarios. ' 
	  return
  end 
                 
          
  end    --while 
 
end -- sp_reasignar_becarios
 
go 

Grant Execute on dbo.sp_reasignar_becarios to GrpTrpSabed 
go

sp_procxmode 'sp_reasignar_becarios', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_rechaza_recargas'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_rechaza_recargas" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_rechaza_recargas ( 
	@pi_id_usuario          numeric(18,0), 
	@pi_id_lote             numeric(18,0), 
	@pi_id_sup_equipo_becas numeric(18,0), 
	@pi_f_oper_eq_becas 	varchar(20),   
	@pi_l_alu               typ_lista,    
	@po_c_error             typ_c_error output, 
	@po_d_error             typ_d_error output) 
as 
/* 
Objetivo: rechaza los lotes de recargas con alumnos 
@pi_l_alu es de la forma:  
@id_alu_tar:@e_alumno:@q_recargas:@id_tipo_beca:@x_observacion 
*/ 
 
begin 
 
  if (@pi_id_usuario is null or @pi_id_usuario = 0) 
    begin 
      set @po_c_error = 3 
      set @po_d_error = 'No se recibi?: pi_id_usuario' 
      return        
  end 
   
  if (@pi_id_lote is null or @pi_id_lote = 0) 
    begin 
      set @po_c_error = 3 
      set @po_d_error = 'No se recibi?: pi_id_lote' 
      return        
  end   
   
  if (@pi_id_sup_equipo_becas is null or @pi_id_sup_equipo_becas = 0) 
    begin 
      set @po_c_error = 3 
      set @po_d_error = 'No se recibi?: pi_id_sup_equipo_becas' 
      return        
  end   
 
  if (@pi_f_oper_eq_becas is null ) 
    begin 
      set @po_c_error = 3 
      set @po_d_error = 'No se recibi?: pi_f_oper_sup_eq_becas' 
      return        
  end   
 
  declare @f_oper_coordinador     datetime, 
          @f_oper_eq_becas     datetime, 
          @f_oper_sup_eq_becas datetime, 
		  @estado_actual varchar(30), 
		  @pi_valida varchar(1) 
 
  set @po_c_error = 0 
  set @po_d_error = null 
   
  begin tran recargas 
   
  --convierto el varchar de entrada a date  
  execute sp_convierte_char_en_fecha @pi_fecha_char     = @pi_f_oper_eq_becas, 
                                     @po_fecha_datetime = @f_oper_sup_eq_becas output, 
                                     @po_c_error        = @po_c_error  output, 
                                     @po_d_error        = @po_d_error  output 
                            
  if (@po_c_error  <> 0)  
  begin 
      rollback tran recargas  
	  set @po_d_error = 'Error llamando a sp_convierte_char_en_fecha : ' + @po_d_error 
      return   
  end   
   
  --updateo el usuario que revisa la recarga por SI o por NO 
  update sart_lotes_recarga 
  set   c_estado_lote       = 'EN_REVISION', 
        id_sup_equipo_becas = @pi_id_sup_equipo_becas,                       
        f_oper_sup_eq_becas = @f_oper_sup_eq_becas,   
        c_usua_actuac       = @pi_id_usuario, 
        f_actuac            = getDate() 
  where id_lote_recarga = @pi_id_lote 
   
  set @po_c_error = @@error 
   
  if (@po_c_error  <> 0)  
  begin 
      rollback tran recargas  
      set @po_d_error =  'Error al actualizar lote de recargas. ' 
      return   
  end   
   
	execute sp_inserta_det_recarga 
		@pi_id_usuario      = @pi_id_usuario, 
		@pi_id_lote         = @pi_id_lote, 
		@pi_l_alu           = @pi_l_alu, 
		@pi_valida          = 'N',  
		@po_c_error         = @po_c_error  output, 
		@po_d_error         = @po_d_error  output 
 
  if (@po_c_error  <> 0)  
  begin 
      rollback tran recargas  
	  set @po_d_error = 'Error llamando a sp_inserta_det_recarga : ' + @po_d_error 
      return   
  end 
   
  commit tran recargas 
   
end

go 

Grant Execute on dbo.sp_rechaza_recargas to GrpTrpSabed 
go

sp_procxmode 'sp_rechaza_recargas', anymode
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_rechaza_recargas_pago'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_rechaza_recargas_pago" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_rechaza_recargas_pago(    
 
@pi_id_usuario           numeric(18,0),    
@pi_id_lote_recarga		 numeric(18,0),    
@po_id_lote_pago         numeric(18,0) output,  
@po_c_error              typ_c_error   output,    
@po_d_error              typ_d_error   output    
 
)    
 
as    
 
/*    
 
Objetivo: Rechazar el lote de recarga desde la opcion generacio de recargas 
 
@pi_l_det_recarga es de la forma "@id_lote_det_recarga|@id_lote_det_recarga "    
 
*/     
begin    
  if @pi_id_usuario is null or @pi_id_usuario =0   
    begin    
      set @po_c_error = 3    
      set @po_d_error = 'No se recibio³ pi_id_usuario'    
      return           
	end    
 
  if  @pi_id_lote_recarga is null    
    begin    
      set @po_c_error = 3    
      set @po_d_error = 'No se recibio³ pi_id_lote_recarga'    
      return           
	end    
    
  set @po_c_error = 0    
  set @po_d_error = null    
 
  begin tran recargas   
	--updateo el estado del lote 
	update sart_lotes_recarga    
	set id_sup_equipo_becas = @pi_id_usuario,     
	c_usua_actuac       = @pi_id_usuario,    
	f_actuac            = getDate(),  
	c_estado_lote       = 'EN_REVISION'    
	where id_lote_recarga = @pi_id_lote_recarga 
	 
  set @po_c_error = @@error    
	if (@po_c_error  <> 0)     
		begin    
		rollback tran recargas     
		set @po_d_error =  'Error al actualizar lote de recargas. '    
		return      
	end   						    
commit tran recargas    
    
end 
 
  
 


go 

Grant Execute on dbo.sp_rechaza_recargas_pago to GrpTrpSabed 
go

sp_procxmode 'sp_rechaza_recargas_pago', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_rechazar_beca'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_rechazar_beca" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_rechazar_beca( 
@pi_id_usuario      numeric(18,0), 
@pi_id_alumno       numeric(18,0), 
@pi_x_observ_prop   varchar(250), 
@po_c_error         typ_c_error output, 
@po_d_error         typ_d_error output 
) 
as 
/* 
Objetivo: Modifica el estado del alumno de POSTULANTE a RECHAZADO 
*/ 
 
begin 
 
  if (@pi_id_usuario is null or @pi_id_usuario = 0)
  begin 
      set @po_c_error = 3
      set @po_d_error = 'No se recibi? pi_id_usuario. ' 
      return        
  end 
   
  if (@pi_x_observ_prop is null)
    begin 
      set @po_c_error = 2
      set @po_d_error = 'No se recibieron las observaciones de rechazo de la propuesta. ' 
      return        
  end   
 
declare  
    @id_usu_tut_adm    numeric(18,0), 
    @id_usu_tut_ped    numeric(18,0), 
    @mensaje           varchar(82), 
    @fecha_sistema     smalldatetime, 
    @dummy             numeric(18,0) 
 
  set @po_c_error = 0 
  set @po_d_error = null 
   
  --verificamos q el alumno este en estado de prop NUEVA 
  if not exists (select 1 
              from saat_alumnos alu 
             where alu.id_alumno = @pi_id_alumno   
               --and e_estado_prop = 'ANALISIS' 
               and e_alumno = 'POSTULANTE' 
             ) 
  begin 
      set @po_d_error =  'Error, el alumno no es postulante. '--el postulante no est? en an?lisis de beca. ' 
      set @po_c_error = 2
      return         
  end   
 
  update saat_alumnos 
  set e_alumno = 'RECHAZADO', 
      f_resul_prop = getDate(), 
      e_estado_prop = 'TERMINADO', 
      x_observ_resul_prop = @pi_x_observ_prop, 
      f_actuac = getDate(), 
      c_usua_actuac = @pi_id_usuario 
  where id_alumno = @pi_id_alumno    
  
  set @po_c_error = @@error     
 
  if (@po_c_error  <> 0) 
  begin  
      set @po_d_error =  convert(varchar,@po_c_error)  
                         + ' - Error al rechazar propuesta de beca. ' 
      return 
  end 
   
  ---------------------------------------------- 
  --mandamos el aviso al tutor adm. del alumno-- 
  ---------------------------------------------- 

  select @mensaje = 'Se ha rechazado la beca al alumno: '+ d_apellido + ', ' + d_nombre 
    from sagt_personas p, 
         saat_alumnos a 
  where p.id_persona = a.id_persona 
    and a.id_alumno = @pi_id_alumno 
  
  set @fecha_sistema = getDate() 
   
  --obtengo los tutores  
  --administrativo
  select @id_usu_tut_adm = usu.id_usuario 
    from sagt_alumnos_tutores alutut, 
         saft_tutores         tut, 
         sast_usuarios        usu 
   where alutut.id_alumno = @pi_id_alumno 
     and alutut.id_tutor = tut.id_tutor 
     and tut.id_persona = usu.id_persona 
     and alutut.id_perfil = 1 
     and tut.e_registro = 'D' 
     and usu.e_usuario = 'D' 

  execute sp_inserta_mensaje  
      @pi_id_usuario       = @pi_id_usuario, 
      @pi_id_origen        = @pi_id_usuario, 
      @pi_id_usuario_dest  = @id_usu_tut_adm, 
      @pi_id_perfil_dest   = @dummy, 
      @pi_x_cuerpo_mensaje = @mensaje, 
      @pi_f_envio          = @fecha_sistema, 
      @po_c_error          = @po_c_error output,  
      @po_d_error          = @po_d_error output 
       
  if (@po_c_error  <> 0) 
  begin  
	  set @po_d_error = 'Error llamando a sp_inserta_mensaje : ' + @po_d_error
      return  
  end 

  --pedagogico
  select @id_usu_tut_ped = usu.id_usuario 
    from sagt_alumnos_tutores alutut, 
         saft_tutores         tut, 
         sast_usuarios        usu 
   where alutut.id_alumno = @pi_id_alumno 
     and alutut.id_tutor = tut.id_tutor 
     and tut.id_persona = usu.id_persona 
     and alutut.id_perfil = 2 
     and tut.e_registro = 'D' 
     and usu.e_usuario = 'D' 

  execute sp_inserta_mensaje  
      @pi_id_usuario       = @pi_id_usuario, 
      @pi_id_origen        = @pi_id_usuario, 
      @pi_id_usuario_dest  = @id_usu_tut_ped, 
      @pi_id_perfil_dest   = @dummy, 
      @pi_x_cuerpo_mensaje = @mensaje, 
      @pi_f_envio          = @fecha_sistema, 
      @po_c_error          = @po_c_error output,  
      @po_d_error          = @po_d_error output 
       
  if (@po_c_error  <> 0) 
  begin  
	  set @po_d_error = 'Error llamando a sp_inserta_mensaje : ' + @po_d_error
      return  
  end 
   
end --sp_rechazar_beca
 
go 

Grant Execute on dbo.sp_rechazar_beca to GrpTrpSabed 
go

sp_procxmode 'sp_rechazar_beca', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_restablece_beca'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_restablece_beca" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_restablece_beca(	 
@pi_id_usuario      numeric(18,0), 
@pi_id_alumno       numeric(18,0), 
@po_c_error         typ_c_error output, 
@po_d_error         typ_d_error output 
) 
as 
/* 
Objetivo: Dessuspende un alumno 
*/ 
 
begin 
 
  if (@pi_id_usuario is null  or @pi_id_usuario = 0)
    begin 
      set @po_c_error = 3
      set @po_d_error = 'No se recibi? pi_id_usuario. ' 
      return        
  end 
 
  if (@pi_id_alumno is null or @pi_id_alumno = 0)
    begin 
      set @po_c_error = 3
      set @po_d_error = 'No se recibi? pi_id_alumno. ' 
      return        
  end 
   
  declare  
    @id_persona    numeric(18,0) 
     
  set @po_c_error = 0 
  set @po_d_error = null 
   
  if not exists (select 1 
              from saat_alumnos alu 
             where alu.id_alumno = @pi_id_alumno   
               and e_alumno = 'SUSPENDIDO' 
             ) 
  begin 
      set @po_d_error =  'Error, el alumno no se encuentra suspendido. ' 
      set @po_c_error = 2
      return         
  end 
 
  update saat_alumnos 
  set e_alumno = 'BECADO', 
      f_actuac = getDate(), 
      c_usua_actuac = @pi_id_usuario 
  where id_alumno = @pi_id_alumno    
  
  set @po_c_error = @@error     
 
  if (@po_c_error  <> 0) 
  begin  
      set @po_d_error =  convert(varchar,@po_c_error)  
                         + ' - Error en sp_restablece_beca. ' 
      return 
  end 
end --sp_restablece_beca
 
go 

Grant Execute on dbo.sp_restablece_beca to GrpTrpSabed 
go

sp_procxmode 'sp_restablece_beca', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_separador_registros'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_separador_registros" >>>>>'
go 

setuser 'dbo'
go 

create procedure sp_separador_registros  
	@po_separador_registro    varchar(1) output, 
	@po_separador_campo       varchar(1) output, 
	@po_c_error               typ_c_error output, 
	@po_d_error               typ_d_error output 
as 
-- Objetivo: Deolver los separadores de registro y campo 
-- Parametros de entrada: No posee 
-- 
--  Ejemplo: 
--     campo1:campo2#campo1:campo2#campo1:campo2 
-- 
--     : separador de campo 
--     # separador de Registro 
 
begin 
	set @po_separador_registro = '|' 
	set @po_separador_campo    = ':' 
	set @po_c_error = @@error 
	 
	if (@po_c_error  <> 0) 
		begin 
			set @po_d_error = convert(varchar,@po_c_error) + ' - Error al establecer los separadores' 
			return 
		end 
end 

go 

Grant Execute on dbo.sp_separador_registros to GrpTrpSabed 
go

sp_procxmode 'sp_separador_registros', anymode
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_suspende_beca'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_suspende_beca" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_suspende_beca(
-- drop procedure sp_suspende_beca
@pi_id_usuario            numeric(18,0),
@pi_id_alumno             numeric(18,0),
@pi_x_motivo_suspension   varchar(250),
@po_c_error               typ_c_error output,
@po_d_error               typ_d_error output
)
as
/*
Objetivo: 
*/

begin

  if (@pi_id_usuario is null or @pi_id_usuario = 0)
    begin
      set @po_c_error = 2
      set @po_d_error = 'No se recibi? pi_id_usuario'
      return       
  end

  --verificamos q el alumno este en estado BECADO
  if not exists (select 1
              from saat_alumnos alu
             where alu.id_alumno = @pi_id_alumno  
               and e_alumno = 'BECADO'
             )
  begin
      set @po_d_error =  'Error, el alumno no est? becado. '
      set @po_c_error = 2
      return        
  end

  set @po_c_error = 0
  set @po_d_error = null

  update saat_alumnos
  set e_alumno = 'SUSPENDIDO',
      f_suspension = getDate(),
      x_motivo_suspension = @pi_x_motivo_suspension,
      f_actuac = getDate(),
      c_usua_actuac = @pi_id_usuario
  where id_alumno = @pi_id_alumno  
 
  set @po_c_error = @@error    
  if (@po_c_error  <> 0)
  begin 
      set @po_d_error =  convert(varchar,@po_c_error) 
                         + ' - Error al suspender la beca. '
      return
  end
end --sp_suspende_beca
 
go 

Grant Execute on dbo.sp_suspende_beca to GrpTrpSabed 
go

sp_procxmode 'sp_suspende_beca', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_valida_cuit'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_valida_cuit" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_valida_cuit (  
      @pi_d_cuit         varchar(11),  
      @po_c_error        typ_c_error   output,   
      @po_d_error        typ_d_error   output   
)   
as   
-------------------------------------------------------------------------------   
--objetivo: Controlar el digito verificador del CUIL  
-------------------------------------------------------------------------------   
begin   
   
  set @po_c_error = 0   
  set @po_d_error = null   
  
  if char_length(@pi_d_cuit) <> 11   
  begin    
      set @po_d_error =  'CUIL/CUIT de logitud inv?lida'  
      set @po_c_error = 2 
      return   
  end   
  
  declare  
      @nsuma         numeric (4),  
      @nresto        numeric (2),  
      @ndife         numeric (2),  
      @ndigito       numeric (2),  
      @cdummy        VARCHAR (10)  
   
      set @cdummy = substring (@pi_d_cuit, 1, 10)  
   
      set @nsuma = 0  
      set @nsuma = convert(numeric,substring (@cdummy, 1, 1)) * 5  
      set @nsuma = @nsuma + convert(numeric,substring (@cdummy, 2, 1)) * 4  
      set @nsuma = @nsuma + convert(numeric,substring (@cdummy, 3, 1)) * 3  
      set @nsuma = @nsuma + convert(numeric,substring (@cdummy, 4, 1)) * 2  
      set @nsuma = @nsuma + convert(numeric,substring (@cdummy, 5, 1)) * 7  
      set @nsuma = @nsuma + convert(numeric,substring (@cdummy, 6, 1)) * 6  
      set @nsuma = @nsuma + convert(numeric,substring (@cdummy, 7, 1)) * 5  
      set @nsuma = @nsuma + convert(numeric,substring (@cdummy, 8, 1)) * 4  
      set @nsuma = @nsuma + convert(numeric,substring (@cdummy, 9, 1)) * 3  
      set @nsuma = @nsuma + convert(numeric,substring (@cdummy, 10, 1)) * 2  
      --  
      set @nresto = @nsuma%11  
      set @ndife  = 11 - @nresto  
  
      if (@ndife = 10)  
      begin    
         set @po_d_error =  'Error en CUIL/CUIT'  
         set @po_c_error = 2  
         return   
      end     
  
      IF (@nresto = 0)   
         set @ndigito = 0  
      ELSE  
         set @ndigito = @ndife  
  
      If @ndigito <> convert(numeric,substring (@pi_d_cuit, 11, 1))  
      begin    
         set @po_d_error =  'Digito verificador del CUIL/CUIT inv?lido'  
         set @po_c_error = 2  
         return   
      end   
  
end --sp_valida_cuit  
 
go 

Grant Execute on dbo.sp_valida_cuit to GrpTrpSabed 
go

sp_procxmode 'sp_valida_cuit', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_valida_datos_ong'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_valida_datos_ong" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_valida_datos_ong(  
@pi_d_cuit          varchar(40),      
@pi_d_calle	    varchar(40),      
@pi_d_nro	    varchar(40),      
@pi_d_localidad     varchar(40),      
@pi_c_provincia     numeric(18,0),    
@pi_e_registro      char(1),       
@pi_q_becas         numeric(7,0),   
@pi_d_nombre_ong    varchar(40),   
@pi_c_tipo_ong      numeric(18,0),  
@po_c_error         typ_c_error     output,   
@po_d_error         typ_d_error     output  
  
)  
-------------------------------------------------------------  
--Objetivo: validar los datos obligatorios para el AM de Ongs  
-------------------------------------------------------------  
as  
  
  set @po_c_error = 0  
  set @po_d_error = null  
    
  declare   
      @dummy             numeric(18,0),  
      @e_definitivo      char(1)  
  
  if (@pi_e_registro is null)  
    begin  
      set @po_c_error = 3 
      set @po_d_error = 'No se inform? el estado de registro'   
      return         
  end  
    
  if (@pi_d_cuit is null)   
    begin   
      set @po_c_error = 2  
      set @po_d_error = 'No se recibi? cuit'   
      return          
  end    
    
  --valido el cuit y su digito verificador  
  execute sp_valida_cuit   
                      @pi_d_cuit     = @pi_d_cuit,  
                      @po_c_error    = @po_c_error   output,  
                      @po_d_error    = @po_d_error   output  
                           
  if (@po_c_error  <> 0)  
  begin  
      return         
  end    
  
  if (@pi_d_nombre_ong is null)   
    begin   
      set @po_c_error = 2  
      set @po_d_error = 'No se recibi? nombre de ong'   
      return          
  end  
    
  if (@pi_c_tipo_ong = 0 or @pi_c_tipo_ong is null)  
    begin  
      set @po_c_error = 2  
      set @po_d_error = 'No se recibi? el tipo de ong'   
      return         
  end  
  
  --procedure q retorna los codigos del estado de registro definitivo  
  execute sp_obtiene_e_definitivo   @po_c_valor  = @e_definitivo output,  
                                    @po_c_error  = @po_c_error output,  
                                    @po_d_error  = @po_d_error output  
                                 
    if (@po_c_error  <> 0)  
    begin  
	  set @po_d_error = 'Error llamando a sp_obtiene_e_definitivo : ' + @po_d_error	 
      return         
    end      
  
  -- si el estado es D(Definitivo) se valida la entrada de otros datos  
  if @pi_e_registro = @e_definitivo  
  begin  
  
      if @pi_d_calle is null   
      begin  
        set @po_c_error = 2  
        set @po_d_error = 'No se recibi? calle del domicilio'  
        return         
      end              
        
      if @pi_d_nro is null  
      begin  
        set @po_c_error = 2  
        set @po_d_error = 'No se recibi? n?mero del domicilio'  
        return         
      end  
    
      if @pi_d_localidad is null   
      begin  
        set @po_c_error = 2  
        set @po_d_error = 'No se recibi? localidad'  
        return         
      end  
    
      if @pi_c_provincia = 0  
      begin  
        set @po_c_error = 2  
        set @po_d_error = 'No se recibi? provincia'  
        return         
      end  
    
  
      if @pi_q_becas is null or @pi_q_becas <= 0   
      begin  
        set @po_c_error = 2  
        set @po_d_error = 'No se recibi? la cantidad de becas asignadas'  
        return         
      end              
  
      
end --sp_valida_datos_ong 
 
go 

Grant Execute on dbo.sp_valida_datos_ong to GrpTrpSabed 
go

sp_procxmode 'sp_valida_datos_ong', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_valida_datos_per'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_valida_datos_per" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_valida_datos_per(  
@pi_c_tpo_doc           numeric(18,0),     
@pi_nro_doc             numeric(12,0),  
@pi_cuil                varchar(40),  
@pi_apellido            varchar(40),  
@pi_nombre              varchar(40),  
@pi_f_nac               varchar(19),  
@pi_c_nacionalidad      numeric(18,0),    
@pi_c_ocupacion         numeric(18,0),    
@pi_c_estado_civil      numeric(18,0),   
@pi_c_provincia         numeric(18,0),    
@pi_localidad           varchar(40),  
@pi_calle               varchar(40),  
@pi_nro                 varchar(40),  
@pi_c_sexo              numeric(18,0),    
@pi_e_reg               char(1),    
@po_c_error             typ_c_error   output,  
@po_d_error             typ_d_error   output  
)  
-------------------------------------------------------  
--Objetivo: Alta de persona (y direcci?n de la misma)--  
-------------------------------------------------------  
as  
  
  set @po_c_error = 0  
  set @po_d_error = null  
  
  if @pi_c_tpo_doc = 0  
  begin  
      set @po_c_error = 2  
      set @po_d_error = 'No se recibi? c?digo de documento '  
      return         
  end    
    
  if @pi_nro_doc  = 0  
  begin  
      set @po_c_error = 2  
      set @po_d_error = 'No se recibi? n?mero de documento'  
      return         
  end  
  
  if @pi_apellido is null  
  begin  
      set @po_c_error = 2  
      set @po_d_error = 'No se recibi? apellido'  
      return         
  end  
  
  if @pi_nombre is null  
  begin  
      set @po_c_error = 2  
      set @po_d_error = 'No se recibi? nombre'  
      return         
  end  
    
  declare   
      @dummy             numeric(18,0),  
      @e_definitivo      char(1)  
    
  
  
  --procedure q retorna los codigos del estado de registro definitivo  
  execute sp_obtiene_e_definitivo   @po_c_valor  = @e_definitivo output,  
                                    @po_c_error  = @po_c_error output,  
                                    @po_d_error  = @po_d_error output  
                                 
    if (@po_c_error  <> 0)  
    begin  
	  set @po_d_error = 'Error llamando a sp_obtiene_e_definitivo : ' + @po_d_error 
      return         
    end      
  
  -- si el estado es D(Definitivo) se valida la entrada de otros datos  
  if @pi_e_reg = @e_definitivo  
  begin  
  
      if @pi_cuil is null  
      begin  
          set @po_c_error = 2 
          set @po_d_error = 'No se recibi? n?mero de cuil'  
          return         
      end  
        
      --valido el cuit y su digito verificador  
      execute sp_valida_cuit   
                             @pi_d_cuit     = @pi_cuil,  
                             @po_c_error    = @po_c_error   output,  
                             @po_d_error    = @po_d_error   output  
                               
      if (@po_c_error  <> 0)  
      begin   
          return         
      end        
    
      if @pi_f_nac  is null  
      begin  
        set @po_c_error = 2  
        set @po_d_error = 'No se recibi? fecha de nacimiento'  
        return         
      end  
    
      if @pi_c_nacionalidad = 0  
      begin  
        set @po_c_error = 2  
        set @po_d_error = 'No se recibi? nacionalidad'  
        return         
      end  
        
      if @pi_c_ocupacion = 0  
      begin  
        set @po_c_error = 2  
        set @po_d_error = 'No se recibi? ocupaci?n'  
        return         
      end        
    
      if @pi_c_estado_civil = 0  
      begin  
        set @po_c_error = 2  
        set @po_d_error = 'No se recibi? estado civil'  
        return         
      end  
    
      if @pi_c_sexo  = 0  
      begin  
        set @po_c_error = 2  
        set @po_d_error = 'No se recibi? sexo de la persona'  
        return         
      end  
        
      if @pi_calle is null   
      begin  
        set @po_c_error = 2  
        set @po_d_error = 'No se recibi? calle del domicilio'  
        return         
      end              
        
      if @pi_nro is null  
      begin  
        set @po_c_error = 2  
        set @po_d_error = 'No se recibi? n?mero del domicilio'  
        return         
      end  
    
      if @pi_localidad is null   
      begin  
        set @po_c_error = 2  
        set @po_d_error = 'No se recibi? localidad'  
        return         
      end  
    
      if @pi_c_provincia = 0  
      begin  
        set @po_c_error = 2  
        set @po_d_error = 'No se recibi? provincia'  
        return         
      end  
  
      
end --sp_valida_datos_per
 
go 

Grant Execute on dbo.sp_valida_datos_per to GrpTrpSabed 
go

sp_procxmode 'sp_valida_datos_per', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_valida_q_becas_ong'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_valida_q_becas_ong" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_valida_q_becas_ong(	 
@pi_id_ong          numeric(18,0), 
@po_c_error         typ_c_error output, 
@po_d_error         typ_d_error output 
) 
as 
/* 
Objetivo: se valida la cantidad de becas disponibles para la ong @pi_id_ong 
*/ 
 
begin 
 
  if @pi_id_ong is null or @pi_id_ong=0
    begin
      set @po_d_error =  'No se informo pi_id_ong'   
      set @po_c_error = 3 
      return             
  end
   
  declare  
    @q_becas           int, 
    @q_becados         int, 
    @nombre_ong        varchar(40) 
     
  set @po_c_error = 0 
  set @po_d_error = null 
   
  --controlo que la ong del alumno, tenga becas disponibles para otorgar 
    -- obtengo la cantidad de becas disponibles para otorgar de la ong 
  select @q_becas = q_becas, @nombre_ong = d_nombre_ong 
    from saft_ongs 
   where id_ong = @pi_id_ong  
   
    -- obtengo la cantidad de becados de la ong en cuestion 
  select @q_becados = count(distinct(a.id_alumno)) 
    from saat_alumnos a, 
         sagt_alumnos_tutores sat, 
         saft_tutores st 
   where st.id_ong = @pi_id_ong   
     and st.id_tutor = sat.id_tutor    
     and sat.id_alumno = a.id_alumno 
     and a.e_alumno in ('BECADO', 'SUSPENDIDO','POSTULANTE') 
 
  if @q_becados + 1 > @q_becas      
  begin  
      set @po_d_error =  'No es posible otorgar esta beca. La ong ' + @nombre_ong +  
                         ' no dispone de becas libres. '   
      set @po_c_error = 2 
      return             
  end 
         
end --sp_valida_q_becas_ong
 
go 

Grant Execute on dbo.sp_valida_q_becas_ong to GrpTrpSabed 
go

sp_procxmode 'sp_valida_q_becas_ong', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_valida_recarga_alu'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_valida_recarga_alu" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_valida_recarga_alu(      

@pi_id_alumno            numeric(18,0),  

@pi_f_consulta           smalldatetime,     

@po_m_error_val          varchar(1)    output,    

@po_error_val_mensaje    typ_d_error   output,    

@po_c_error              typ_c_error   output,      

@po_d_error              typ_d_error   output      

)      

as      

--      

--objetivo: valida la existencia de los datos de tarjeta del alumno y    

--la vigencia de su tipo de beca   

--   

begin   

   

  if @pi_id_alumno = 0 or @pi_id_alumno is null    

    begin    

      set @po_c_error = 3      

      set @po_d_error = 'No se recibi? el alumno (ID)'      

  end    

   

  declare @d_nro_tarjeta       varchar(16),   

          @d_nro_cta_cred      varchar(10),   

          @f_consulta          datetime,   

          @id_tipo_beca        numeric(18,2),   

          @valor_beca          int,   

          @d_suc_cuenta        varchar(4),    

      	  @d_tipo_cuenta       varchar(3),    

	  @d_nro_cuenta        varchar(7),  

          @e_alumno            varchar(15),  

          @cant                int,  

          @sep                 varchar(1),  

          @subSep              varchar(1), 

          @cant_tarjetas       int, 

          @sintarjeta          varchar(1), 

          @d_aux               varchar(1000), 

          @d_tipo_beca         varchar(40)             

             

  set @po_c_error = 0    

  set @po_d_error = null    

  set @po_m_error_val = 'N'   

  set @sintarjeta ='N' 

  

  execute sp_separador_registros  

             @po_separador_registro    = @sep        output,  

             @po_separador_campo       = @subSep     output,  

             @po_c_error               = @po_c_error output,  

             @po_d_error               = @po_d_error output    

               

  if (@po_c_error  <> 0)  

    begin  

      set @po_d_error =  'Error al llamar sp_separador_registros '+  @po_d_error 

      return      

  end  

  

  -- Obtengo el valor de la beca del alumno y seteo los posibles errores   

  if @pi_f_consulta is null set @f_consulta = getdate() 

  else set @f_consulta = @pi_f_consulta 

      

  execute sp_obtiene_tbeca_alumno     

                   @pi_id_alumno     = @pi_id_alumno,     

                   @pi_f_consulta    = @f_consulta,    

                   @po_id_tipo_beca  = @id_tipo_beca output,     

                   @po_valor_beca    = @valor_beca   output,    

                   @po_c_error       = @po_c_error   output,      

                   @po_d_error       = @po_d_error   output       

                      

  if (@po_c_error  <> 0)      

    begin       

      set @po_d_error =  'Error al llamar sp_obtiene_tbeca_alumno '+  @po_d_error 

      return       

  end  

   

  if @id_tipo_beca is null or @id_tipo_beca=0  

    begin   

      set @d_aux=@d_aux+@sep+ 'El tipo de beca no es valido'        

  end   

  

  -- 

  -- Controlo que la beca tenga un valor 

  if @valor_beca is null or @valor_beca=0  

    begin   

 

      if isnull(@id_tipo_beca,0) <> 0 

        begin 

 

          Select @d_tipo_beca = d_tipo_beca 

            from saat_tipo_beca 

           Where id_tipo_beca=@id_tipo_beca  

 

          set @po_c_error=@@error 

          If @po_c_error<>0  

            begin  

              set @po_d_error = 'No se pudo obtener la descripcion de la beca id:' + convert(varchar,@id_tipo_beca) 

              return  

          end  

 

          set @d_aux=@d_aux+@sep+ 'La beca '+@d_tipo_beca+', no tiene valor vigente' 

 

      end          

 

  end   

   

  --  

  -- Analizo los valores del alumno  

  Select @e_alumno=e_alumno  

    from saat_alumnos  

   Where id_alumno=@pi_id_alumno  

     

  set @po_c_error=@@error,@cant=@@rowcount  

  If @po_c_error<>0  

    begin  

      set @po_d_error = 'No se pudo obtener registros del alumno ID:'+convert(varchar(18),@pi_id_alumno)  

      return  

  end  

  If @cant=0  

    begin  

      set @po_d_error = 'No se obtuvieron registros del alumno ID :'+convert(varchar(18),@pi_id_alumno)  

      set @po_c_error = 3  

      return  

  end     

  

  if @e_alumno <> 'BECADO'  

    begin   

      set @d_aux=@d_aux+@sep+ 'El alumno no se encuntra en estado BECADO, esta '+ @e_alumno        

  end   

  

  select @d_nro_tarjeta = atar.d_nro_tarjeta,   

         @d_nro_cta_cred = atar.d_nro_cta_cred,   

         @d_suc_cuenta = aong.d_suc_cuenta,   

         @d_tipo_cuenta = aong.d_tipo_cuenta,   

         @d_nro_cuenta = aong.d_nro_cuenta   

    from saat_alumnos_tarjetas atar,    

         saav_alu_tut_ong aong   

   where aong.id_alumno = @pi_id_alumno  

     and atar.f_vigencia_tar_dsd <=@f_consulta 

     and atar.f_vigencia_tar_hta >=@f_consulta 

     and (atar.f_baja is null or atar.f_baja > @f_consulta) 

     and atar.id_alumno =* aong.id_alumno   

     and aong.id_perfil_tutor = 1  

    

  set @po_c_error=@@error,@cant=@@rowcount  

  If @po_c_error<>0  

    begin  

      set @po_d_error = 'No se pudo obtener registros de la tarjeta del alumno:'+convert(varchar(18),@pi_id_alumno)  

      return  

  end  

   

  --**************************************    

  -- valido los datos de la ong del alumno         

  --************************************** 

  -- 

  if @d_suc_cuenta is null 

    begin   

      set @d_aux =  @d_aux+@sep+'La Ong no tiene ingresado el n?mero de la sucursal de la cuenta monetaria'   

  end        

     

  if @d_tipo_cuenta is null   

    begin         

      set @d_aux =  @d_aux+@sep+'La Ong no tiene ingresado el tipo de cuenta monetaria'   

  end   

     

  if @d_nro_cuenta is null 

    begin         

      set @d_aux =  @d_aux+@sep+'La Ong no tiene ingresado el n?mero de la cuenta monetaria'   

  end 

   

  -- **************************************** 

  -- Analizo los valores de la tarjeta  

  -- **************************************** 

  -- 

  -- Veo si tiene alguna tarjeta cargada 

  select @cant_tarjetas=count(*) 

    from saat_alumnos_tarjetas atar     

   where atar.id_alumno = @pi_id_alumno 

 

  if @cant_tarjetas=0 

    begin 

      set @d_aux = @d_aux+@sep+'El alumno no posee tarjeta de recarga' 

      set @sintarjeta='S' -- para que no agregue los demas carteles 

  end      

   

  -- 

  --Control para que el alumno tenga al menos, una tarjeta sin dar de baja 

  if not exists ( 

      select atar.id_alu_tar     

        from saat_alumnos_tarjetas atar     

       where atar.id_alumno = @pi_id_alumno     

         and (atar.f_baja is null or atar.f_baja>@f_consulta)) and @sintarjeta='N' 

    begin 

      set @d_aux = @d_aux+@sep+'El alumno no posee tarjeta de recarga activa' 

      set @sintarjeta='S' 

  end      

   

  -- 

  -- Controlo si la tarjeta esta vigente 

  if not exists ( 

      select atar.id_alu_tar     

       from saat_alumnos_tarjetas atar     

      where atar.id_alumno = @pi_id_alumno     

        and (atar.f_baja is null or atar.f_baja>@f_consulta) 

        and @f_consulta >= atar.f_vigencia_tar_dsd 

        and @f_consulta <= atar.f_vigencia_tar_hta) and @sintarjeta='N' 

    begin 

      set @d_aux = @d_aux+@sep+'El alumno no posee tarjeta de recarga vigente' 

      set @sintarjeta='S' 

  end   

   

  select @cant_tarjetas = count(atar.id_alu_tar) 

    from saat_alumnos_tarjetas atar     

   where atar.id_alumno = @pi_id_alumno     
	
     and (atar.f_baja is null or (atar.f_baja>@f_consulta
	 --inicio modif 28/6/13
	 -- se agrega para que no traiga 2 tarjetas
	 and atar.f_baja > getDate() ))
	 and atar.f_vigencia_tar_hta >= getDate()
	 -- fin modif

   

  if @cant_tarjetas > 1 and @sintarjeta='N'     

    begin 

      set @d_aux = @d_aux+@sep+'El alumno posee '+ convert(varchar,@cant_tarjetas)+ ' tarjetas de recarga activas, solo debe poseer una' 

  end    

         

  if (@d_nro_tarjeta is null or char_length(@d_nro_tarjeta) <= 0) and @sintarjeta='N' 

    begin   

      set @d_aux = @d_aux+@sep+'No se encuentra el n?mero de tarjeta.'         

  end   

   

  if (@d_nro_cta_cred is null or char_length(@d_nro_cta_cred) <= 0) and @sintarjeta='N' 

    begin          

      set @d_aux =  @d_aux+@sep+'No se encuentra el n?mero de cuenta cr?dito del alumno. '         

  end   

 

  -- ******** 

  -- General 

  -- ******** 

  if @d_aux is not null   

    begin   

      set @po_error_val_mensaje = substring(@d_aux,2,char_length(@d_aux)-1)  

      set @po_m_error_val = 'S'   

  end       

   

end
 
go 

Grant Execute on dbo.sp_valida_recarga_alu to GrpTrpSabed 
go

sp_procxmode 'sp_valida_recarga_alu', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_valida_titular_de_lista'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_valida_titular_de_lista" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_valida_titular_de_lista( 
-- drop procedure sp_valida_titular_de_lista 
@pi_id_alumno       numeric(18,0), 
@pi_l_fliares       typ_lista, 
@po_valido          char(1)     output,   
@po_c_error         typ_c_error output, 
@po_d_error         typ_d_error output 
) 
as 
/* 
Objetivo: inserta el grupo familiar del alumno  
*/ 
 
begin 

  --insert into sabed_log (descrip) values ('sp_valida_titular_de_lista')
  --insert into sabed_log (numero) values (@pi_id_alumno)
  --insert into sabed_log (descrip) values (@pi_l_fliares)
 
  if (@pi_id_alumno is null or @pi_id_alumno = 0)     
    begin     
      set @po_c_error = 2    
      set @po_d_error = 'No se recibi? pi_id_alumno en sp_valida_titular_de_lista'     
      return            
    end     

 
 
  declare  
      @cant_titu        integer, 
      @sep              varchar(1), 
      @subSep           varchar(1), 
      @v_lista          typ_lista, 
      @v_sublista       typ_lista, 
      @id_per_rel       numeric(18,0), 
      @c_dummy          numeric(18,0), 
      @m_tit_tarjeta    varchar(1), 
      @id_tit_anterior  numeric(18,0), 
      @id_tit_actual    numeric(18,0) 
 
   
  set @po_c_error = 0 
  set @po_d_error = null 
  set @cant_titu = 0 
  
  --------------------------
  set @po_valido = 'N'
  --------------------------
   
  execute sp_separador_registros 
             @po_separador_registro    = @sep        output, 
             @po_separador_campo       = @subSep     output, 
             @po_c_error               = @po_c_error output, 
             @po_d_error               = @po_d_error output   
              
  if (@po_c_error  <> 0) 
    begin 
	  set @po_d_error = 'Error llamando a sp_separador_registros : ' + @po_d_error
      return     
  end   
   
  set @v_lista             = @pi_l_fliares + @sep 
 
  --parseo la lista 
  while (@v_lista is not null) 
  begin 
 
           --limpio las variables  
            set @id_per_rel = null 
            set @m_tit_tarjeta = '' 
   
            --obtengo un elemento de la lista 
            set @v_sublista = substring(@v_lista, 1,charindex(@sep,@v_lista)-1)+ @subSep   
                         
            --obtengo el resto de la lista                         
            set @v_lista = substring(@v_lista, 
                             charindex(@sep,@v_lista)+1,  
                             char_length(@v_lista) 
                             )                          
             
 
            --separo los subelementos             
 
            set @id_per_rel 	 = convert(numeric,substring(@v_sublista,1,charindex(@subSep,@v_sublista)-1)) 
 
            set @v_sublista    = substring(@v_sublista, 
                                           charindex(@subSep,@v_sublista)+1,  
                                           char_length(@v_sublista) )  
 
            set @c_dummy  = convert(numeric,substring(@v_sublista,1,charindex(@subSep,@v_sublista)-1)) 
 
            set @v_sublista    = substring(@v_sublista, 
                                           charindex(@subSep,@v_sublista)+1,  
                                           char_length(@v_sublista) )  
 
            set @m_tit_tarjeta = substring(@v_sublista,1,charindex(@subSep,@v_sublista)-1) 
 
            set @v_sublista    = substring(@v_sublista, 
                                           charindex(@subSep,@v_sublista)+1,  
                                           char_length(@v_sublista) )                 
             
            if @m_tit_tarjeta = 'S'  
            begin    
               set @cant_titu = @cant_titu + 1 
               set @id_tit_actual = @id_per_rel  
            end     
             
  end --while     
 
  if @cant_titu = 0 
  begin 
      set @po_d_error = 'No indic? el titular de la tarjeta. ' 
      set @po_c_error = 2 
      return 
  end 
   
  if @cant_titu > 1 
  begin 
      set @po_d_error = 'Se marc? m?s de un titular. ' 
      set @po_c_error = 2 
      return 
  end   
   
  if @cant_titu = 1 
  begin 
      --obtengo el titular actual del alumno 
      select @id_tit_anterior = id_persona_rel 
      from saat_alumnos_parentesco 
      where id_alumno = @pi_id_alumno
        and m_tit_tarjeta = 'S' 
       
      --si hay un titular de tarjeta, verifico q sea el mismo q ya tiene el alumno -- 
      if @id_tit_anterior = @id_tit_actual 
         set @po_valido = 'S' 
          
      else --sino es el mismo, la tarjeta del anterior debe estar dada de baja    
              if exists (select 1 
                           from saat_alumnos_tarjetas atar, 
                                saat_alumnos_parentesco ap 
                          where ap.id_alumno = @pi_id_alumno 
                             and ap.id_alumno = atar.id_alumno  
                             and ap.id_persona_rel = atar.id_persona_tit 
                             and atar.f_baja is null 
                         ) 
              begin 
                  set @po_c_error = 2 
                  set @po_d_error = 'Antes de modificar el titular de tarjeta debe dar de baja la misma. ' 
                  return 
              end 
              else 
                  set @po_valido = 'S' 
  end  
   
 
end --sp_valida_titular_de_lista
 
go 

Grant Execute on dbo.sp_valida_titular_de_lista to GrpTrpSabed 
go

sp_procxmode 'sp_valida_titular_de_lista', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_valida_uk_doc_per'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_valida_uk_doc_per" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_valida_uk_doc_per( 
@pi_id_persona      numeric(18,0), 
@pi_c_documento     numeric(18,0), 
@pi_n_documento     numeric(18,0), 
@po_c_error         typ_c_error output, 
@po_d_error         typ_d_error output 
) 
as 
/* 
Objetivo: verifica q el tipo y n?mero de dni sean ?nicos 
*/ 
 
begin 
 
  set @po_c_error = 0 
  set @po_d_error = null 
   
  if exists (select 1 
              from sagt_personas p 
             where p.c_documento = @pi_c_documento  
               and p.n_documento = @pi_n_documento  
               and @pi_id_persona is null  
             ) 
  begin 
      set @po_d_error =  'El Tipo y N?mero de Documento ya existen' 
      set @po_c_error = 2 
      return 
  end 
 
 
  if exists (select 1 
              from sagt_personas p 
             where p.c_documento = @pi_c_documento  
               and p.n_documento = @pi_n_documento  
               and p.id_persona <> @pi_id_persona 
             ) 
  begin 
      set @po_d_error =  'El Tipo y N?mero de Documento ya existen' 
      set @po_c_error = 2 
   
  end   
   
end --sp_valida_uk_doc_per
 
go 

Grant Execute on dbo.sp_valida_uk_doc_per to GrpTrpSabed 
go

sp_procxmode 'sp_valida_uk_doc_per', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_verifica_accesibilidad'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_verifica_accesibilidad" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_verifica_accesibilidad(  



@pi_id_usuario          numeric(18,0),   



@pi_id_persona          numeric(18,0),   



@po_c_error             typ_c_error output,   



@po_d_error             typ_d_error output   



)   



as    



--objetivo: Verificar si un alumno puede ser accedido por el   

--usuario loggeado de acuerdo a la ong a la que pertenecen  

--si el usuario loggeado es del eq. de becas, puede ver a todos los alumnos  

--si el usuario loggeado es de una ong, puede ver a los alumnos de su ong  

--si el usuario loggeado es un tutor, puede ver a los alumnos asociados a ?l  

--  

begin  

  declare @id_ong_usu       numeric(18,0),   

          @id_ong_alu       numeric(18,0),  

          @id_tutor_usu_log numeric(18,0),  

          @id_dummy         numeric(18,0)  



set @po_c_error = 0    

set @po_d_error = null    

set @id_ong_usu = null     

set @id_ong_alu = null    

set @id_tutor_usu_log = null  



--obtener ong del usuario: @pi_id_usuario     







execute sp_obtiene_ong_usu  @pi_id_usuario = @pi_id_usuario,  

                            @pi_id_perfil  = @id_dummy,  

                            @po_id_ong     = @id_ong_usu output,  

                            @po_c_error    = @po_c_error output,  

                            @po_d_error    = @po_d_error output  



  if (@po_c_error  <> 0)     



  begin  



	  set @po_d_error = 'Error llamando a sp_obtiene_ong_usu : ' + @po_d_error 



      return      



  end   



  select @id_ong_alu = id_ong  

    from saav_alu_tut_ong  

   where id_persona_alu = @pi_id_persona  

     and e_registro_tut = 'D'    

     and e_registro_alu = 'D'  

     and id_perfil_tutor = 1     



  if (@id_ong_usu is not null) and (@id_ong_alu is not null)  



  begin  



      if (@id_ong_usu <> @id_ong_alu)  

      

      begin  



          set @po_c_error = 2  



          set @po_d_error = 'No puede consultar este alumno, no pertenece a su ong. '   



          return     



      end  



      else   



      begin --si la ong es la misma; debo verificar x el tutor  

			

		if not exists (select id_usuario from sast_usuarios_perfiles

			where id_usuario = @pi_id_usuario

			  and id_perfil = 3

			  and e_usu_perfil = 'D')

			  

		begin

		

          select @id_tutor_usu_log = id_tutor  

            from sasv_usuarios_tut  

           where id_usuario = @pi_id_usuario  



          --si el usuario loggeado es un tutor verifico q el alumno sea suyo   



          if @id_tutor_usu_log is not null  



          begin            



              if not exists (select id_persona_alu  

                               from saav_alu_tut_ong  

                              where id_persona_alu = @pi_id_persona  

                                and e_registro_tut = 'D'    

                                and e_registro_alu = 'D'  

                                and id_tutor = @id_tutor_usu_log  

                         )  



              begin  



                  set @po_c_error = 2  



                  set @po_d_error = 'No puede consultar este alumno, no pertenece a sus asignados. '   



                  return  



              end              



          end   

	

		end

	

      end     



  end                     



end
 
go 

Grant Execute on dbo.sp_verifica_accesibilidad to GrpTrpSabed 
go

sp_procxmode 'sp_verifica_accesibilidad', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- DDL for Stored Procedure 'SABED.dbo.sp_verifica_uk_doc_per'
-----------------------------------------------------------------------------

print '<<<<< CREATING Stored Procedure - "SABED.dbo.sp_verifica_uk_doc_per" >>>>>'
go 

setuser 'dbo'
go 


create procedure sp_verifica_uk_doc_per( 
@pi_id_persona      numeric(18,0), 
@pi_c_documento     numeric(18,0), 
@pi_n_documento     numeric(18,0), 
@po_c_error         typ_c_error output, 
@po_d_error         typ_d_error output 
) 
as 
/* 
Objetivo: verifica q el tipo y n?mero de dni sean ?nicos 
*/ 
 
begin 
 
  set @po_c_error = 0 
  set @po_d_error = null 
   
  if exists (select 1 
              from sagt_personas p 
             where p.c_documento = @pi_c_documento  
               and p.n_documento = @pi_n_documento  
               and @pi_id_persona is null --or p.id_persona <> @pi_id_persona) 
             ) 
  begin 
      set @po_d_error =  'El Tipo y N?mero de Documento ya existen' 
      set @po_c_error = 2 
      return 
  end 
 
 
  if exists (select 1 
              from sagt_personas p 
             where p.c_documento = @pi_c_documento  
               and p.n_documento = @pi_n_documento  
               and p.id_persona <> @pi_id_persona 
             ) 
  begin 
      set @po_d_error =  'El Tipo y N?mero de Documento ya existen' 
      set @po_c_error = 2
	  return
  end   
   
end --sp_verifica_uk_doc_per
 
go 

Grant Execute on dbo.sp_verifica_uk_doc_per to GrpTrpSabed 
go

sp_procxmode 'sp_verifica_uk_doc_per', unchained
go 

setuser
go 

-----------------------------------------------------------------------------
-- Dependent DDL for Object(s)
-----------------------------------------------------------------------------
alter table SABED.dbo.saat_alumnos
add constraint saat_alumn_id_per_2016007182 FOREIGN KEY (id_persona) REFERENCES SABED.dbo.sagt_personas(id_persona)
go

alter table SABED.dbo.saat_alumnos
add constraint saat_alumn_id_col_2032007239 FOREIGN KEY (id_colegio) REFERENCES SABED.dbo.sagt_colegios(id_colegio)
go

alter table SABED.dbo.saat_alumnos
add constraint saat_alumn_id_tip_2048007296 FOREIGN KEY (id_tipo_beca) REFERENCES SABED.dbo.saat_tipo_beca(id_tipo_beca)
go

alter table SABED.dbo.saat_alumnos
add constraint saat_alumn_2064007353 FOREIGN KEY (c_usua_alta) REFERENCES SABED.dbo.sast_usuarios(id_usuario)
go

alter table SABED.dbo.saat_alumnos
add constraint saat_alumn_2080007410 FOREIGN KEY (c_usua_actuac) REFERENCES SABED.dbo.sast_usuarios(id_usuario)
go

alter table SABED.dbo.saat_alumnos
add constraint saat_alumn_2096007467 FOREIGN KEY (c_orient_colegio) REFERENCES SABED.dbo.sapt_parametros(id_parametro)
go

alter table SABED.dbo.saat_alumnos
add constraint saat_alumn_2112007524 FOREIGN KEY (c_modal_col) REFERENCES SABED.dbo.sapt_parametros(id_parametro)
go

alter table SABED.dbo.saat_alumnos
add constraint saat_alumn_2128007581 FOREIGN KEY (m_auditoria) REFERENCES SABED.dbo.sapt_parametros(id_parametro)
go

alter table SABED.dbo.saat_alumnos
add constraint saat_alumn_2144007638 FOREIGN KEY (c_cont_estudios) REFERENCES SABED.dbo.sapt_parametros(id_parametro)
go

alter table SABED.dbo.saat_alumnos
add constraint saat_alumn_12524047 FOREIGN KEY (c_carrera_cont_est) REFERENCES SABED.dbo.sapt_parametros(id_parametro)
go

alter table SABED.dbo.saat_alumnos
add constraint saat_alumn_28524104 FOREIGN KEY (c_ocup_eleg) REFERENCES SABED.dbo.sapt_parametros(id_parametro)
go

alter table SABED.dbo.saat_alumnos_eval_academ
add constraint saat_alumn_id_alu_2044531286 FOREIGN KEY (id_alumno) REFERENCES SABED.dbo.saat_alumnos(id_alumno)
go

alter table SABED.dbo.saat_alumnos_eval_academ
add constraint saat_alumn_id_per_2060531343 FOREIGN KEY (id_periodo) REFERENCES SABED.dbo.sact_periodos_eval_acad(id_periodo)
go

alter table SABED.dbo.saat_alumnos_eval_academ
add constraint saat_alumn_2076531400 FOREIGN KEY (c_usua_alta) REFERENCES SABED.dbo.sast_usuarios(id_usuario)
go

alter table SABED.dbo.saat_alumnos_eval_academ
add constraint saat_alumn_2092531457 FOREIGN KEY (c_usua_actuac) REFERENCES SABED.dbo.sast_usuarios(id_usuario)
go

alter table SABED.dbo.saat_alumnos_parentesco
add constraint saat_alumn_id_alu_124524446 FOREIGN KEY (id_alumno) REFERENCES SABED.dbo.saat_alumnos(id_alumno)
go

alter table SABED.dbo.saat_alumnos_parentesco
add constraint saat_alumn_id_per_140524503 FOREIGN KEY (id_persona_rel) REFERENCES SABED.dbo.sagt_personas(id_persona)
go

alter table SABED.dbo.saat_alumnos_parentesco
add constraint saat_alumn_156524560 FOREIGN KEY (c_usua_alta) REFERENCES SABED.dbo.sast_usuarios(id_usuario)
go

alter table SABED.dbo.saat_alumnos_parentesco
add constraint saat_alumn_172524617 FOREIGN KEY (c_usua_actuac) REFERENCES SABED.dbo.sast_usuarios(id_usuario)
go

alter table SABED.dbo.saat_alumnos_parentesco
add constraint saat_alumn_188524674 FOREIGN KEY (c_parentesco) REFERENCES SABED.dbo.sapt_parametros(id_parametro)
go

alter table SABED.dbo.saat_alumnos_rendicion_gasto
add constraint saat_alumn_id_alu_1004527581 FOREIGN KEY (id_alumno) REFERENCES SABED.dbo.saat_alumnos(id_alumno)
go

alter table SABED.dbo.saat_alumnos_rendicion_gasto
add constraint saat_alumn_id_per_1020527638 FOREIGN KEY (id_periodo) REFERENCES SABED.dbo.sact_periodos_rendicion(id_periodo)
go

alter table SABED.dbo.saat_alumnos_rendicion_gasto
add constraint saat_alumn_1036527695 FOREIGN KEY (c_usua_alta) REFERENCES SABED.dbo.sast_usuarios(id_usuario)
go

alter table SABED.dbo.saat_alumnos_rendicion_gasto
add constraint saat_alumn_1052527752 FOREIGN KEY (c_usua_actuac) REFERENCES SABED.dbo.sast_usuarios(id_usuario)
go

alter table SABED.dbo.saat_alumnos_tarjetas
add constraint saat_alumn_id_alu_313049120 FOREIGN KEY (id_alumno) REFERENCES SABED.dbo.saat_alumnos(id_alumno)
go

alter table SABED.dbo.saat_alumnos_tarjetas
add constraint saat_alumn_id_per_329049177 FOREIGN KEY (id_persona_tit) REFERENCES SABED.dbo.sagt_personas(id_persona)
go

alter table SABED.dbo.saat_alumnos_tarjetas
add constraint saat_alumn_345049234 FOREIGN KEY (c_usua_alta) REFERENCES SABED.dbo.sast_usuarios(id_usuario)
go

alter table SABED.dbo.saat_alumnos_tarjetas
add constraint saat_alumn_361049291 FOREIGN KEY (c_usua_actuac) REFERENCES SABED.dbo.sast_usuarios(id_usuario)
go

alter table SABED.dbo.saat_alumnos_tarjetas
add constraint saat_alumn_377049348 FOREIGN KEY (id_alumno,id_persona_tit) REFERENCES SABED.dbo.saat_alumnos_parentesco(id_alumno,id_persona_rel)
go

alter table SABED.dbo.saat_detalle_eval_academ
add constraint saat_detal_id_eva_9048037 FOREIGN KEY (id_eval_academ) REFERENCES SABED.dbo.saat_alumnos_eval_academ(id_eval_academ)
go

alter table SABED.dbo.saat_detalle_eval_academ
add constraint saat_detal_25048094 FOREIGN KEY (c_usua_alta) REFERENCES SABED.dbo.sast_usuarios(id_usuario)
go

alter table SABED.dbo.saat_detalle_eval_academ
add constraint saat_detal_41048151 FOREIGN KEY (c_usua_actuac) REFERENCES SABED.dbo.sast_usuarios(id_usuario)
go

alter table SABED.dbo.saat_detalle_rend_gasto
add constraint saat_detal_c_gast_1417053053 FOREIGN KEY (c_gasto) REFERENCES SABED.dbo.sapt_parametros(id_parametro)
go

alter table SABED.dbo.saat_detalle_rend_gasto
add constraint saat_detal_1433053110 FOREIGN KEY (c_usua_alta) REFERENCES SABED.dbo.sast_usuarios(id_usuario)
go

alter table SABED.dbo.saat_detalle_rend_gasto
add constraint saat_detal_1449053167 FOREIGN KEY (c_usua_actuac) REFERENCES SABED.dbo.sast_usuarios(id_usuario)
go

alter table SABED.dbo.saat_detalle_rend_gasto
add constraint saat_detal_1465053224 FOREIGN KEY (id_rendicion,id_alumno,f_rend_gasto,id_periodo) REFERENCES SABED.dbo.saat_alumnos_rendicion_gasto(id_rendicion,id_alumno,f_rend_gasto,id_periodo)
go

alter table SABED.dbo.saat_detalle_rend_gasto
add constraint saat_detal_id_alu_1401052996 FOREIGN KEY (id_alumno) REFERENCES SABED.dbo.saat_alumnos(id_alumno)
go

alter table SABED.dbo.saat_preguntas_eval_academ
add constraint saat_pregu_id_sec_812526897 FOREIGN KEY (id_seccion) REFERENCES SABED.dbo.saat_secciones_eval_academ(id_seccion)
go

alter table SABED.dbo.saat_preguntas_eval_academ
add constraint saat_pregu_828526954 FOREIGN KEY (c_usua_alta) REFERENCES SABED.dbo.sast_usuarios(id_usuario)
go

alter table SABED.dbo.saat_preguntas_eval_academ
add constraint saat_pregu_844527011 FOREIGN KEY (c_usua_actuac) REFERENCES SABED.dbo.sast_usuarios(id_usuario)
go

alter table SABED.dbo.saat_respuestas_eval_academ
add constraint saat_respu_id_pre_1820530488 FOREIGN KEY (id_pregunta) REFERENCES SABED.dbo.saat_preguntas_eval_academ(id_pregunta)
go

alter table SABED.dbo.saat_respuestas_eval_academ
add constraint saat_respu_1836530545 FOREIGN KEY (c_usua_alta) REFERENCES SABED.dbo.sast_usuarios(id_usuario)
go

alter table SABED.dbo.saat_respuestas_eval_academ
add constraint saat_respu_1852530602 FOREIGN KEY (c_usua_actuac) REFERENCES SABED.dbo.sast_usuarios(id_usuario)
go

alter table SABED.dbo.saat_secciones_eval_academ
add constraint saat_secci_716526555 FOREIGN KEY (c_usua_alta) REFERENCES SABED.dbo.sast_usuarios(id_usuario)
go

alter table SABED.dbo.saat_secciones_eval_academ
add constraint saat_secci_732526612 FOREIGN KEY (c_usua_actuac) REFERENCES SABED.dbo.sast_usuarios(id_usuario)
go

alter table SABED.dbo.saat_tipo_beca
add constraint saat_tipo__1792006384 FOREIGN KEY (c_usua_alta) REFERENCES SABED.dbo.sast_usuarios(id_usuario)
go

alter table SABED.dbo.saat_tipo_beca
add constraint saat_tipo__1808006441 FOREIGN KEY (c_usua_actuac) REFERENCES SABED.dbo.sast_usuarios(id_usuario)
go

alter table SABED.dbo.saat_tipo_beca_detalle
add constraint saat_tipo__id_tip_1872006669 FOREIGN KEY (id_tipo_beca) REFERENCES SABED.dbo.saat_tipo_beca(id_tipo_beca)
go

alter table SABED.dbo.saat_tipo_beca_detalle
add constraint saat_tipo__1888006726 FOREIGN KEY (c_usua_alta) REFERENCES SABED.dbo.sast_usuarios(id_usuario)
go

alter table SABED.dbo.saat_tipo_beca_detalle
add constraint saat_tipo__1904006783 FOREIGN KEY (c_usua_actuac) REFERENCES SABED.dbo.sast_usuarios(id_usuario)
go

alter table SABED.dbo.sact_periodos_eval_acad
add constraint sact_perio_1916530830 FOREIGN KEY (c_usua_alta) REFERENCES SABED.dbo.sast_usuarios(id_usuario)
go

alter table SABED.dbo.sact_periodos_eval_acad
add constraint sact_perio_1932530887 FOREIGN KEY (c_usua_actuac) REFERENCES SABED.dbo.sast_usuarios(id_usuario)
go

alter table SABED.dbo.sact_periodos_recargas
add constraint sact_perio_105048379 FOREIGN KEY (c_usua_alta) REFERENCES SABED.dbo.sast_usuarios(id_usuario)
go

alter table SABED.dbo.sact_periodos_recargas
add constraint sact_perio_121048436 FOREIGN KEY (c_usua_actuac) REFERENCES SABED.dbo.sast_usuarios(id_usuario)
go

alter table SABED.dbo.sact_periodos_rendicion
add constraint sact_perio_908527239 FOREIGN KEY (c_usua_alta) REFERENCES SABED.dbo.sast_usuarios(id_usuario)
go

alter table SABED.dbo.sact_periodos_rendicion
add constraint sact_perio_924527296 FOREIGN KEY (c_usua_actuac) REFERENCES SABED.dbo.sast_usuarios(id_usuario)
go

alter table SABED.dbo.saft_avisos
add constraint saft_aviso_1116527980 FOREIGN KEY (c_usua_alta) REFERENCES SABED.dbo.sast_usuarios(id_usuario)
go

alter table SABED.dbo.saft_avisos
add constraint saft_aviso_1132528037 FOREIGN KEY (c_usua_actuac) REFERENCES SABED.dbo.sast_usuarios(id_usuario)
go

alter table SABED.dbo.saft_avisos
add constraint saft_aviso_1148528094 FOREIGN KEY (c_tipo_aviso) REFERENCES SABED.dbo.sapt_parametros(id_parametro)
go

alter table SABED.dbo.saft_avisos
add constraint saft_aviso_1164528151 FOREIGN KEY (c_evento_calend) REFERENCES SABED.dbo.sapt_parametros(id_parametro)
go

alter table SABED.dbo.saft_avisos_destinatarios
add constraint saft_aviso_id_avi_1564529576 FOREIGN KEY (id_aviso) REFERENCES SABED.dbo.saft_avisos(id_aviso)
go

alter table SABED.dbo.saft_avisos_destinatarios
add constraint saft_aviso_id_per_1580529633 FOREIGN KEY (id_perfil) REFERENCES SABED.dbo.sast_perfiles(id_perfil)
go

alter table SABED.dbo.saft_avisos_destinatarios
add constraint saft_aviso_id_usu_1596529690 FOREIGN KEY (id_usuario) REFERENCES SABED.dbo.sast_usuarios(id_usuario)
go

alter table SABED.dbo.saft_avisos_destinatarios
add constraint saft_aviso_1612529747 FOREIGN KEY (c_usua_alta) REFERENCES SABED.dbo.sast_usuarios(id_usuario)
go

alter table SABED.dbo.saft_avisos_destinatarios
add constraint saft_aviso_1628529804 FOREIGN KEY (c_usua_actuac) REFERENCES SABED.dbo.sast_usuarios(id_usuario)
go

alter table SABED.dbo.saft_noticias
add constraint saft_notic_1228528379 FOREIGN KEY (c_usua_alta) REFERENCES SABED.dbo.sast_usuarios(id_usuario)
go

alter table SABED.dbo.saft_noticias
add constraint saft_notic_1244528436 FOREIGN KEY (c_usua_actuac) REFERENCES SABED.dbo.sast_usuarios(id_usuario)
go

alter table SABED.dbo.saft_ongs
add constraint saft_ongs_c_prov_1264004503 FOREIGN KEY (c_provincia) REFERENCES SABED.dbo.sapt_parametros(id_parametro)
go

alter table SABED.dbo.saft_ongs
add constraint saft_ongs_c_tipo_1280004560 FOREIGN KEY (c_tipo_ong) REFERENCES SABED.dbo.sapt_parametros(id_parametro)
go

alter table SABED.dbo.saft_ongs
add constraint saft_ongs_1296004617 FOREIGN KEY (c_usua_alta) REFERENCES SABED.dbo.sast_usuarios(id_usuario)
go

alter table SABED.dbo.saft_ongs
add constraint saft_ongs_1312004674 FOREIGN KEY (c_usua_actuac) REFERENCES SABED.dbo.sast_usuarios(id_usuario)
go

alter table SABED.dbo.saft_personas_ong
add constraint saft_perso_id_ong_364525301 FOREIGN KEY (id_ong) REFERENCES SABED.dbo.saft_ongs(id_ong)
go

alter table SABED.dbo.saft_personas_ong
add constraint saft_perso_id_per_380525358 FOREIGN KEY (id_persona) REFERENCES SABED.dbo.sagt_personas(id_persona)
go

alter table SABED.dbo.saft_personas_ong
add constraint saft_perso_396525415 FOREIGN KEY (c_usua_alta) REFERENCES SABED.dbo.sast_usuarios(id_usuario)
go

alter table SABED.dbo.saft_personas_ong
add constraint saft_perso_412525472 FOREIGN KEY (c_usua_actuac) REFERENCES SABED.dbo.sast_usuarios(id_usuario)
go

alter table SABED.dbo.saft_tutores
add constraint saft_tutor_id_ong_1536005472 FOREIGN KEY (id_ong) REFERENCES SABED.dbo.saft_ongs(id_ong)
go

alter table SABED.dbo.saft_tutores
add constraint saft_tutor_id_per_1552005529 FOREIGN KEY (id_persona) REFERENCES SABED.dbo.sagt_personas(id_persona)
go

alter table SABED.dbo.saft_tutores
add constraint saft_tutor_1568005586 FOREIGN KEY (c_usua_alta) REFERENCES SABED.dbo.sast_usuarios(id_usuario)
go

alter table SABED.dbo.saft_tutores
add constraint saft_tutor_1584005643 FOREIGN KEY (c_usua_actuac) REFERENCES SABED.dbo.sast_usuarios(id_usuario)
go

alter table SABED.dbo.sagt_alumnos_tutores
add constraint sagt_alumn_id_alu_1273052540 FOREIGN KEY (id_alumno) REFERENCES SABED.dbo.saat_alumnos(id_alumno)
go

alter table SABED.dbo.sagt_alumnos_tutores
add constraint sagt_alumn_id_tut_1289052597 FOREIGN KEY (id_tutor) REFERENCES SABED.dbo.saft_tutores(id_tutor)
go

alter table SABED.dbo.sagt_alumnos_tutores
add constraint sagt_alumn_id_per_1305052654 FOREIGN KEY (id_perfil) REFERENCES SABED.dbo.sast_perfiles(id_perfil)
go

alter table SABED.dbo.sagt_alumnos_tutores
add constraint sagt_alumn_1321052711 FOREIGN KEY (c_usua_alta) REFERENCES SABED.dbo.sast_usuarios(id_usuario)
go

alter table SABED.dbo.sagt_alumnos_tutores
add constraint sagt_alumn_1337052768 FOREIGN KEY (c_usua_actuac) REFERENCES SABED.dbo.sast_usuarios(id_usuario)
go

alter table SABED.dbo.sagt_colegios
add constraint sagt_coleg_1408005016 FOREIGN KEY (c_usua_alta) REFERENCES SABED.dbo.sast_usuarios(id_usuario)
go

alter table SABED.dbo.sagt_colegios
add constraint sagt_coleg_1424005073 FOREIGN KEY (c_usua_actuac) REFERENCES SABED.dbo.sast_usuarios(id_usuario)
go

alter table SABED.dbo.sagt_colegios
add constraint sagt_coleg_1440005130 FOREIGN KEY (c_provincia) REFERENCES SABED.dbo.sapt_parametros(id_parametro)
go

alter table SABED.dbo.sagt_personas
add constraint sagt_perso_768002736 FOREIGN KEY (c_documento) REFERENCES SABED.dbo.sapt_parametros(id_parametro)
go

alter table SABED.dbo.sagt_personas
add constraint sagt_perso_784002793 FOREIGN KEY (c_nacionalidad) REFERENCES SABED.dbo.sapt_parametros(id_parametro)
go

alter table SABED.dbo.sagt_personas
add constraint sagt_perso_800002850 FOREIGN KEY (c_ocupacion) REFERENCES SABED.dbo.sapt_parametros(id_parametro)
go

alter table SABED.dbo.sagt_personas
add constraint sagt_perso_816002907 FOREIGN KEY (c_estado_civil) REFERENCES SABED.dbo.sapt_parametros(id_parametro)
go

alter table SABED.dbo.sagt_personas
add constraint sagt_perso_832002964 FOREIGN KEY (c_provincia) REFERENCES SABED.dbo.sapt_parametros(id_parametro)
go

alter table SABED.dbo.sagt_personas
add constraint sagt_perso_848003021 FOREIGN KEY (c_sexo) REFERENCES SABED.dbo.sapt_parametros(id_parametro)
go

alter table SABED.dbo.sagt_personas
add constraint sagt_perso_873051115 FOREIGN KEY (c_usua_alta) REFERENCES SABED.dbo.sast_usuarios(id_usuario)
go

alter table SABED.dbo.sagt_personas
add constraint sagt_perso_889051172 FOREIGN KEY (c_usua_actuac) REFERENCES SABED.dbo.sast_usuarios(id_usuario)
go

alter table SABED.dbo.sagt_telefonos
add constraint sagt_telef_id_per_1648005871 FOREIGN KEY (id_persona) REFERENCES SABED.dbo.sagt_personas(id_persona)
go

alter table SABED.dbo.sagt_telefonos
add constraint sagt_telef_id_ong_1664005928 FOREIGN KEY (id_ong) REFERENCES SABED.dbo.saft_ongs(id_ong)
go

alter table SABED.dbo.sagt_telefonos
add constraint sagt_telef_id_col_1680005985 FOREIGN KEY (id_colegio) REFERENCES SABED.dbo.sagt_colegios(id_colegio)
go

alter table SABED.dbo.sagt_telefonos
add constraint sagt_telef_c_tipo_1696006042 FOREIGN KEY (c_tipo_telefono) REFERENCES SABED.dbo.sapt_parametros(id_parametro)
go

alter table SABED.dbo.sagt_telefonos
add constraint sagt_telef_1712006099 FOREIGN KEY (c_usua_alta) REFERENCES SABED.dbo.sast_usuarios(id_usuario)
go

alter table SABED.dbo.sagt_telefonos
add constraint sagt_telef_1728006156 FOREIGN KEY (c_usua_actuac) REFERENCES SABED.dbo.sast_usuarios(id_usuario)
go

alter table SABED.dbo.sapt_param_conversiones
add constraint sapt_param_1024003648 FOREIGN KEY (c_usua_alta) REFERENCES SABED.dbo.sast_usuarios(id_usuario)
go

alter table SABED.dbo.sapt_param_conversiones
add constraint sapt_param_1040003705 FOREIGN KEY (c_usua_actuac) REFERENCES SABED.dbo.sast_usuarios(id_usuario)
go

alter table SABED.dbo.sapt_param_conversiones
add constraint sapt_param_1056003762 FOREIGN KEY (id_parametro) REFERENCES SABED.dbo.sapt_parametros(id_parametro)
go

alter table SABED.dbo.sapt_param_tablas
add constraint sapt_param_905051229 FOREIGN KEY (c_usua_alta) REFERENCES SABED.dbo.sast_usuarios(id_usuario)
go

alter table SABED.dbo.sapt_param_tablas
add constraint sapt_param_921051286 FOREIGN KEY (c_usua_actuac) REFERENCES SABED.dbo.sast_usuarios(id_usuario)
go

alter table SABED.dbo.sapt_parametros
add constraint sapt_param_id_tab_672002394 FOREIGN KEY (id_tabla) REFERENCES SABED.dbo.sapt_param_tablas(id_tabla)
go

alter table SABED.dbo.sapt_parametros
add constraint sapt_param_937051343 FOREIGN KEY (c_usua_alta) REFERENCES SABED.dbo.sast_usuarios(id_usuario)
go

alter table SABED.dbo.sapt_parametros
add constraint sapt_param_953051400 FOREIGN KEY (c_usua_actuac) REFERENCES SABED.dbo.sast_usuarios(id_usuario)
go

alter table SABED.dbo.sart_lotes_det_pago
add constraint sart_lotes_id_lot_681050431 FOREIGN KEY (id_lote_pago) REFERENCES SABED.dbo.sart_lotes_pago(id_lote_pago)
go

alter table SABED.dbo.sart_lotes_det_pago
add constraint sart_lotes_id_lot_697050488 FOREIGN KEY (id_lote_det_recarga) REFERENCES SABED.dbo.sart_lotes_det_recarga(id_lote_det_recarga)
go

alter table SABED.dbo.sart_lotes_det_pago
add constraint sart_lotes_713050545 FOREIGN KEY (c_usua_alta) REFERENCES SABED.dbo.sast_usuarios(id_usuario)
go

alter table SABED.dbo.sart_lotes_det_pago
add constraint sart_lotes_729050602 FOREIGN KEY (c_usua_actuac) REFERENCES SABED.dbo.sast_usuarios(id_usuario)
go

alter table SABED.dbo.sart_lotes_det_recarga
add constraint sart_lotes_id_lot_457049633 FOREIGN KEY (id_lote_recarga) REFERENCES SABED.dbo.sart_lotes_recarga(id_lote_recarga)
go

alter table SABED.dbo.sart_lotes_det_recarga
add constraint sart_lotes_id_alu_473049690 FOREIGN KEY (id_alumno) REFERENCES SABED.dbo.saat_alumnos(id_alumno)
go

alter table SABED.dbo.sart_lotes_det_recarga
add constraint sart_lotes_id_alu_489049747 FOREIGN KEY (id_alu_tar) REFERENCES SABED.dbo.saat_alumnos_tarjetas(id_alu_tar)
go

alter table SABED.dbo.sart_lotes_det_recarga
add constraint sart_lotes_505049804 FOREIGN KEY (c_usua_alta) REFERENCES SABED.dbo.sast_usuarios(id_usuario)
go

alter table SABED.dbo.sart_lotes_det_recarga
add constraint sart_lotes_521049861 FOREIGN KEY (c_usua_actuac) REFERENCES SABED.dbo.sast_usuarios(id_usuario)
go

alter table SABED.dbo.sart_lotes_pago
add constraint sart_lotes_601050146 FOREIGN KEY (c_usua_alta) REFERENCES SABED.dbo.sast_usuarios(id_usuario)
go

alter table SABED.dbo.sart_lotes_pago
add constraint sart_lotes_617050203 FOREIGN KEY (c_usua_actuac) REFERENCES SABED.dbo.sast_usuarios(id_usuario)
go

alter table SABED.dbo.sart_lotes_recarga
add constraint sart_lotes_id_tut_201048721 FOREIGN KEY (id_tutor) REFERENCES SABED.dbo.saft_tutores(id_tutor)
go

alter table SABED.dbo.sart_lotes_recarga
add constraint sart_lotes_id_per_217048778 FOREIGN KEY (id_periodo_recarga) REFERENCES SABED.dbo.sact_periodos_recargas(id_periodo_recarga)
go

alter table SABED.dbo.sart_lotes_recarga
add constraint sart_lotes_233048835 FOREIGN KEY (c_usua_alta) REFERENCES SABED.dbo.sast_usuarios(id_usuario)
go

alter table SABED.dbo.sart_lotes_recarga
add constraint sart_lotes_249048892 FOREIGN KEY (c_usua_actuac) REFERENCES SABED.dbo.sast_usuarios(id_usuario)
go

alter table SABED.dbo.sast_accesos_por_perfiles
add constraint sast_acces_id_acc_1740530203 FOREIGN KEY (id_acceso) REFERENCES SABED.dbo.sast_accesos(id_acceso)
go

alter table SABED.dbo.sast_accesos_por_perfiles
add constraint sast_acces_id_per_1756530260 FOREIGN KEY (id_perfil) REFERENCES SABED.dbo.sast_perfiles(id_perfil)
go

alter table SABED.dbo.sast_menu
add constraint sast_menu_id_pad_1340528778 FOREIGN KEY (id_padre) REFERENCES SABED.dbo.sast_menu(id_menu)
go

alter table SABED.dbo.sast_menu
add constraint sast_menu_1356528835 FOREIGN KEY (c_usua_alta) REFERENCES SABED.dbo.sast_usuarios(id_usuario)
go

alter table SABED.dbo.sast_menu
add constraint sast_menu_1372528892 FOREIGN KEY (c_usua_actuac) REFERENCES SABED.dbo.sast_usuarios(id_usuario)
go

alter table SABED.dbo.sast_perfiles
add constraint sast_perfi_1120003990 FOREIGN KEY (c_usua_alta) REFERENCES SABED.dbo.sast_usuarios(id_usuario)
go

alter table SABED.dbo.sast_perfiles
add constraint sast_perfi_1136004047 FOREIGN KEY (c_usua_actuac) REFERENCES SABED.dbo.sast_usuarios(id_usuario)
go

alter table SABED.dbo.sast_usuarios
add constraint sast_usuar_id_per_928003306 FOREIGN KEY (id_persona) REFERENCES SABED.dbo.sagt_personas(id_persona)
go

alter table SABED.dbo.sast_usuarios
add constraint sast_usuar_944003363 FOREIGN KEY (c_usua_alta) REFERENCES SABED.dbo.sast_usuarios(id_usuario)
go

alter table SABED.dbo.sast_usuarios
add constraint sast_usuar_960003420 FOREIGN KEY (c_usua_actuac) REFERENCES SABED.dbo.sast_usuarios(id_usuario)
go

alter table SABED.dbo.sast_usuarios_perfiles
add constraint sast_usuar_id_per_1436529120 FOREIGN KEY (id_perfil) REFERENCES SABED.dbo.sast_perfiles(id_perfil)
go

alter table SABED.dbo.sast_usuarios_perfiles
add constraint sast_usuar_id_usu_1452529177 FOREIGN KEY (id_usuario) REFERENCES SABED.dbo.sast_usuarios(id_usuario)
go

alter table SABED.dbo.sast_usuarios_perfiles
add constraint sast_usuar_1468529234 FOREIGN KEY (c_usua_alta) REFERENCES SABED.dbo.sast_usuarios(id_usuario)
go

alter table SABED.dbo.sast_usuarios_perfiles
add constraint sast_usuar_1484529291 FOREIGN KEY (c_usua_actuac) REFERENCES SABED.dbo.sast_usuarios(id_usuario)
go

alter table SABED.dbo.saut_auditoria
add constraint saut_audit_id_alu_252524902 FOREIGN KEY (id_alumno) REFERENCES SABED.dbo.saat_alumnos(id_alumno)
go

alter table SABED.dbo.saut_auditoria
add constraint saut_audit_268524959 FOREIGN KEY (c_usua_alta) REFERENCES SABED.dbo.sast_usuarios(id_usuario)
go

alter table SABED.dbo.saut_auditoria
add constraint saut_audit_284525016 FOREIGN KEY (c_usua_actuac) REFERENCES SABED.dbo.sast_usuarios(id_usuario)
go


