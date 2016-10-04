CREATE SCHEMA test;


CREATE TABLE public.edge
(
    source varchar(100) NOT NULL,
    destination varchar(100) NOT NULL,
    name varchar(255) NOT NULL DEFAULT 'connect',
    edge_data_id varchar(32),
    src int DEFAULT hash(edge.source),
    dest int DEFAULT hash(edge.destination)
);

ALTER TABLE public.edge ADD CONSTRAINT edgePK PRIMARY KEY (source, destination, name) DISABLED;

CREATE TABLE public.node
(
    id varchar(100) NOT NULL,
    class varchar(255),
    name varchar(255),
    item_description varchar(255),
    fully_qualified_name varchar(255),
    logical_id varchar(100),
    type_id varchar(25),
    created date,
    updated date,
    alert_level int,
    alert_description varchar(100),
    node_data_id varchar(100)
);

ALTER TABLE public.node ADD CONSTRAINT C_PRIMARY PRIMARY KEY (id) DISABLED;

CREATE TABLE public.node_data
(
    id varchar(100) NOT NULL,
    accessipv4_string varchar(100),
    status_string varchar(100),
    snapshotsquota_integer int,
    logicalid_string varchar(100),
    floatingipsquota_integer int,
    itemid_string varchar(100),
    securitygroupsquota_integer int,
    accessipv6_string varchar(100),
    flavor_string varchar(100),
    fullyqualifiedname_string varchar(100),
    securitygrouprulesquota_integer int,
    typeid_string varchar(100),
    progress_integer int,
    disk_integer int,
    adminstateup_boolean boolean,
    created_string varchar(100),
    injectedfilecontentbytes_integer int,
    gigabytesquotautilisation_float float,
    fibreupdated_date date,
    usagecount_integer int,
    itemdescription_string varchar(100),
    hostid_string varchar(100),
    updatestatusnew_boolean boolean,
    tags_string varchar(100),
    name_string varchar(100),
    volumesquotautilisation_float float,
    minram_integer int,
    coresquota_integer int,
    updatestatusdeleted_boolean boolean,
    securitygroupsquotautilisation_float float,
    updatestatusunchanged_boolean boolean,
    ramquota_integer int,
    updated_string varchar(100),
    ramquotautilisation_float float,
    mindisk_integer int,
    alertlevel_integer int,
    gatewayip_string varchar(100),
    availabilityzone_string varchar(100),
    instancesquotautilisation_float float,
    description_string varchar(100),
    instancesquota_integer int,
    injectedfilesquotautilisation_float float,
    fibrecreated_date date,
    networkid_string varchar(100),
    coresquotautilisation_float float,
    ipversion_integer int,
    qualifiedname_string varchar(100),
    snapshotsquotautilisation_float float,
    floatingipsquotautilisation_float float,
    size_integer int,
    volumetype_string varchar(100),
    volumesquota_integer int,
    size_long numeric(37,15),
    providerid_string varchar(100),
    gigabytesquota_integer int,
    cidr_string varchar(100),
    injectedfilesquota_integer int,
    shared_boolean boolean,
    updatestatus_string varchar(100),
    securitygrouprulesquotautilisation_float float,
    alertdescription_string varchar(100),
    updatestatusupdated_boolean boolean,
    uuid_string varchar(100),
    itemname_string varchar(100),
    flavorid_string varchar(100),
    ram_double float,
    vcpus_integer int,
    enabledhcp_boolean boolean,
    tag_string varchar(100),
    virtualsize_long numeric(37,15),
    containerportnumber_long numeric(37,15),
    label_string varchar(100),
    pathonhost_string varchar(100),
    command_string varchar(100),
    interfaceaddress_string varchar(100),
    hostaddress_string varchar(100),
    containerid_string varchar(100),
    overallstatus_string varchar(100),
    repository_string varchar(100),
    imageid_string varchar(100),
    hostportnumber_long numeric(37,15),
    hostport_string varchar(100),
    creationdate_long numeric(37,15),
    baseimagerepositoryname_string varchar(100),
    hostdockerdaemonaddress_string varchar(100),
    realsize_long numeric(37,15),
    hostuid_string varchar(100)
);

ALTER TABLE public.node_data ADD CONSTRAINT C_PRIMARY PRIMARY KEY (id) DISABLED;

CREATE TABLE public.node_data_map
(
    id  IDENTITY ,
    type_id varchar(25) NOT NULL,
    column_name varchar(100)
);

ALTER TABLE public.node_data_map ADD CONSTRAINT C_PRIMARY PRIMARY KEY (id) DISABLED;

CREATE TABLE public.edges
(
    source int NOT NULL,
    dest int NOT NULL
);


ALTER TABLE public.edge ADD CONSTRAINT fk_to FOREIGN KEY (source) references public.node (id);
ALTER TABLE public.edge ADD CONSTRAINT fk_from FOREIGN KEY (destination) references public.node (id);
ALTER TABLE public.node ADD CONSTRAINT fk_node FOREIGN KEY (node_data_id) references public.node_data (id);

CREATE PROJECTION public.edge_DBD_1_rep_Test /*+createtype(D)*/ 
(
 source,
 destination,
 name ENCODING RLE,
 edge_data_id ENCODING RLE,
 src ENCODING DELTARANGE_COMP,
 dest ENCODING DELTARANGE_COMP
)
AS
 SELECT edge.source,
        edge.destination,
        edge.name,
        edge.edge_data_id,
        edge.src,
        edge.dest
 FROM public.edge
 ORDER BY edge.edge_data_id,
          edge.name,
          edge.source,
          edge.destination
UNSEGMENTED ALL NODES;

CREATE PROJECTION public.node_DBD_2_rep_Test /*+createtype(D)*/ 
(
 id,
 class ENCODING RLE,
 name,
 item_description ENCODING RLE,
 fully_qualified_name,
 logical_id,
 type_id,
 created ENCODING RLE,
 updated ENCODING RLE,
 alert_level ENCODING RLE,
 alert_description ENCODING RLE,
 node_data_id ENCODING RLE
)
AS
 SELECT node.id,
        node.class,
        node.name,
        node.item_description,
        node.fully_qualified_name,
        node.logical_id,
        node.type_id,
        node.created,
        node.updated,
        node.alert_level,
        node.alert_description,
        node.node_data_id
 FROM public.node
 ORDER BY node.node_data_id,
          node.created,
          node.alert_level,
          node.alert_description,
          node.updated,
          node.item_description,
          node.class,
          node.id
UNSEGMENTED ALL NODES;

CREATE PROJECTION public.node_data_DBD_3_rep_Test /*+createtype(D)*/ 
(
 id,
 accessipv4_string ENCODING RLE,
 status_string,
 snapshotsquota_integer ENCODING RLE,
 logicalid_string,
 floatingipsquota_integer ENCODING RLE,
 itemid_string,
 securitygroupsquota_integer ENCODING RLE,
 accessipv6_string ENCODING RLE,
 flavor_string,
 fullyqualifiedname_string,
 securitygrouprulesquota_integer ENCODING RLE,
 typeid_string,
 progress_integer ENCODING RLE,
 disk_integer ENCODING COMMONDELTA_COMP,
 adminstateup_boolean ENCODING RLE,
 created_string ENCODING RLE,
 injectedfilecontentbytes_integer ENCODING RLE,
 gigabytesquotautilisation_float ENCODING RLE,
 fibreupdated_date ENCODING RLE,
 usagecount_integer ENCODING COMMONDELTA_COMP,
 itemdescription_string,
 hostid_string,
 updatestatusnew_boolean ENCODING RLE,
 tags_string ENCODING RLE,
 name_string,
 volumesquotautilisation_float ENCODING RLE,
 minram_integer ENCODING RLE,
 coresquota_integer ENCODING RLE,
 updatestatusdeleted_boolean ENCODING RLE,
 securitygroupsquotautilisation_float ENCODING RLE,
 updatestatusunchanged_boolean ENCODING RLE,
 ramquota_integer ENCODING RLE,
 updated_string,
 ramquotautilisation_float ENCODING RLE,
 mindisk_integer ENCODING RLE,
 alertlevel_integer ENCODING RLE,
 gatewayip_string,
 availabilityzone_string,
 instancesquotautilisation_float ENCODING RLE,
 description_string,
 instancesquota_integer ENCODING RLE,
 injectedfilesquotautilisation_float ENCODING RLE,
 fibrecreated_date ENCODING RLE,
 networkid_string,
 coresquotautilisation_float ENCODING RLE,
 ipversion_integer ENCODING RLE,
 qualifiedname_string,
 snapshotsquotautilisation_float ENCODING RLE,
 floatingipsquotautilisation_float ENCODING RLE,
 size_integer ENCODING RLE,
 volumetype_string,
 volumesquota_integer ENCODING RLE,
 size_long ENCODING RLE,
 providerid_string,
 gigabytesquota_integer ENCODING RLE,
 cidr_string,
 injectedfilesquota_integer ENCODING RLE,
 shared_boolean ENCODING RLE,
 updatestatus_string ENCODING RLE,
 securitygrouprulesquotautilisation_float ENCODING RLE,
 alertdescription_string,
 updatestatusupdated_boolean ENCODING RLE,
 uuid_string,
 itemname_string,
 flavorid_string,
 ram_double ENCODING RLE,
 vcpus_integer ENCODING COMMONDELTA_COMP,
 enabledhcp_boolean ENCODING RLE,
 tag_string,
 virtualsize_long ENCODING RLE,
 containerportnumber_long ENCODING BLOCKDICT_COMP,
 label_string,
 pathonhost_string,
 command_string,
 interfaceaddress_string,
 hostaddress_string,
 containerid_string,
 overallstatus_string,
 repository_string,
 imageid_string,
 hostportnumber_long,
 hostport_string,
 creationdate_long,
 baseimagerepositoryname_string,
 hostdockerdaemonaddress_string,
 realsize_long ENCODING RLE,
 hostuid_string
)
AS
 SELECT node_data.id,
        node_data.accessipv4_string,
        node_data.status_string,
        node_data.snapshotsquota_integer,
        node_data.logicalid_string,
        node_data.floatingipsquota_integer,
        node_data.itemid_string,
        node_data.securitygroupsquota_integer,
        node_data.accessipv6_string,
        node_data.flavor_string,
        node_data.fullyqualifiedname_string,
        node_data.securitygrouprulesquota_integer,
        node_data.typeid_string,
        node_data.progress_integer,
        node_data.disk_integer,
        node_data.adminstateup_boolean,
        node_data.created_string,
        node_data.injectedfilecontentbytes_integer,
        node_data.gigabytesquotautilisation_float,
        node_data.fibreupdated_date,
        node_data.usagecount_integer,
        node_data.itemdescription_string,
        node_data.hostid_string,
        node_data.updatestatusnew_boolean,
        node_data.tags_string,
        node_data.name_string,
        node_data.volumesquotautilisation_float,
        node_data.minram_integer,
        node_data.coresquota_integer,
        node_data.updatestatusdeleted_boolean,
        node_data.securitygroupsquotautilisation_float,
        node_data.updatestatusunchanged_boolean,
        node_data.ramquota_integer,
        node_data.updated_string,
        node_data.ramquotautilisation_float,
        node_data.mindisk_integer,
        node_data.alertlevel_integer,
        node_data.gatewayip_string,
        node_data.availabilityzone_string,
        node_data.instancesquotautilisation_float,
        node_data.description_string,
        node_data.instancesquota_integer,
        node_data.injectedfilesquotautilisation_float,
        node_data.fibrecreated_date,
        node_data.networkid_string,
        node_data.coresquotautilisation_float,
        node_data.ipversion_integer,
        node_data.qualifiedname_string,
        node_data.snapshotsquotautilisation_float,
        node_data.floatingipsquotautilisation_float,
        node_data.size_integer,
        node_data.volumetype_string,
        node_data.volumesquota_integer,
        node_data.size_long,
        node_data.providerid_string,
        node_data.gigabytesquota_integer,
        node_data.cidr_string,
        node_data.injectedfilesquota_integer,
        node_data.shared_boolean,
        node_data.updatestatus_string,
        node_data.securitygrouprulesquotautilisation_float,
        node_data.alertdescription_string,
        node_data.updatestatusupdated_boolean,
        node_data.uuid_string,
        node_data.itemname_string,
        node_data.flavorid_string,
        node_data.ram_double,
        node_data.vcpus_integer,
        node_data.enabledhcp_boolean,
        node_data.tag_string,
        node_data.virtualsize_long,
        node_data.containerportnumber_long,
        node_data.label_string,
        node_data.pathonhost_string,
        node_data.command_string,
        node_data.interfaceaddress_string,
        node_data.hostaddress_string,
        node_data.containerid_string,
        node_data.overallstatus_string,
        node_data.repository_string,
        node_data.imageid_string,
        node_data.hostportnumber_long,
        node_data.hostport_string,
        node_data.creationdate_long,
        node_data.baseimagerepositoryname_string,
        node_data.hostdockerdaemonaddress_string,
        node_data.realsize_long,
        node_data.hostuid_string
 FROM public.node_data
 ORDER BY node_data.updatestatusnew_boolean,
          node_data.tags_string,
          node_data.updatestatusdeleted_boolean,
          node_data.updatestatusunchanged_boolean,
          node_data.updatestatus_string,
          node_data.updatestatusupdated_boolean,
          node_data.accessipv4_string,
          node_data.snapshotsquota_integer,
          node_data.floatingipsquota_integer,
          node_data.securitygroupsquota_integer,
          node_data.accessipv6_string,
          node_data.securitygrouprulesquota_integer,
          node_data.progress_integer,
          node_data.adminstateup_boolean,
          node_data.created_string,
          node_data.injectedfilecontentbytes_integer,
          node_data.minram_integer,
          node_data.securitygroupsquotautilisation_float,
          node_data.id
UNSEGMENTED ALL NODES;

CREATE PROJECTION public.node_data_map_DBD_4_rep_Test /*+createtype(D)*/ 
(
 id ENCODING COMMONDELTA_COMP,
 type_id ENCODING RLE,
 column_name
)
AS
 SELECT node_data_map.id,
        node_data_map.type_id,
        node_data_map.column_name
 FROM public.node_data_map
 ORDER BY node_data_map.type_id,
          node_data_map.id
UNSEGMENTED ALL NODES;

CREATE PROJECTION public.edges_DBD_5_rep_Test /*+createtype(D)*/ 
(
 source ENCODING RLE,
 dest ENCODING DELTARANGE_COMP
)
AS
 SELECT edges.source,
        edges.dest
 FROM public.edges
 ORDER BY edges.source,
          edges.dest
UNSEGMENTED ALL NODES;

CREATE PROJECTION public.edges_DBD_6_seg_Test /*+createtype(D)*/ 
(
 source ENCODING DELTARANGE_COMP,
 dest ENCODING RLE
)
AS
 SELECT edges.source,
        edges.dest
 FROM public.edges
 ORDER BY edges.dest,
          edges.source
SEGMENTED BY hash(edges.source) ALL NODES KSAFE 1;


CREATE FUNCTION public.isOrContains(map Long Varchar, val Varchar)
RETURN boolean AS
BEGIN
RETURN CASE WHEN (MapSize(map) <> (-1)) THEN MapContainsValue(map, val) ELSE (map = (val)) END;
END;

SELECT MARK_DESIGN_KSAFE(1);
