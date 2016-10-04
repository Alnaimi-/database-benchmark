-- Outgoing Primary Adjacency (IPA)
-- I am assuming 10 edges per vertice/row.

CREATE TABLE OPA
(
VID 		BIGINT NOT NULL,
TYPE 		VARCHAR(20),
SPILL		BIT NOT NULL,
EID1		BIGINT,
LBL1		VARCHAR(32),
VAL1		BIGINT,
EID2		BIGINT ,
LBL2		VARCHAR(32),
VAL2		BIGINT,
EID3		BIGINT,
LBL3		VARCHAR(32),
VAL3		BIGINT,
EID4		BIGINT,
LBL4		VARCHAR(32),
VAL4		BIGINT,
EID5		BIGINT,
LBL5		VARCHAR(32),
VAL5		BIGINT,
EID6		BIGINT,
LBL6		VARCHAR(32),
VAL6		BIGINT,
EID7		BIGINT,
LBL7		VARCHAR(32),
VAL7		BIGINT,
EID8		BIGINT,
LBL8		VARCHAR(32),
VAL8		BIGINT,
EID9		BIGINT,
LBL9		VARCHAR(32),
VAL9		BIGINT,
EID10		BIGINT,
LBL10		VARCHAR(32),
VAL10		BIGINT,

INDEX vertex_id_opa USING HASH (VID)
);

-- Ingoing Primary Adjacency (IPA)
-- I am assuming 10 edges per vertice/row.

CREATE TABLE IPA
(
VID 		BIGINT NOT NULL,
TYPE 		VARCHAR(20),
SPILL		BIT NOT NULL,
EID1		BIGINT,
LBL1		VARCHAR(32),
VAL1		BIGINT,
EID2		BIGINT,
LBL2		VARCHAR(32),
VAL2		BIGINT,
EID3		BIGINT,
LBL3		VARCHAR(32),
VAL3		BIGINT,
EID4		BIGINT,
LBL4		VARCHAR(32),
VAL4		BIGINT,
EID5		BIGINT,
LBL5		VARCHAR(32),
VAL5		BIGINT,
EID6		BIGINT,
LBL6		VARCHAR(32),
VAL6		BIGINT,
EID7		BIGINT,
LBL7		VARCHAR(32),
VAL7		BIGINT,
EID8		BIGINT,
LBL8		VARCHAR(32),
VAL8		BIGINT,
EID9		BIGINT,
LBL9		VARCHAR(32),
VAL9		BIGINT,
EID10		BIGINT,
LBL10		VARCHAR(32),
VAL10		BIGINT,

INDEX vertex_id_ipa USING HASH (VID)
);

-- Outgoing Secundary Adjacency (OSA)

CREATE TABLE OSA
(
VALID 		BIGINT NOT NULL,
TYPE 		VARCHAR(20),
EID		BIGINT NOT NULL,
VAL		BIGINT NOT NULL,

INDEX outgoing_vertex_id USING HASH (VALID)
);

-- Ingoing Secundary Adjacency (ISA)

CREATE TABLE ISA
(
VALID 		BIGINT NOT NULL,
TYPE 		VARCHAR(20),
EID		BIGINT NOT NULL,
VAL		BIGINT NOT NULL,

INDEX ingoing_vertex_id USING HASH (VALID)
);

-- Edge Attributes (EA)
-- Since SQLGraph uses an unspecified Relational database with JSON storage capabilities
-- Instead of adding json, a column for each different possible edge attribute can be used.

CREATE TABLE EA
(
EID			BIGINT NOT NULL,
INV			BIGINT NOT NULL,
OUTV		BIGINT NOT NULL,
LBL			VARCHAR(100) NOT NULL,
ATTR			JSON,
-- CREATION_DATE		DATE,
-- JOIN_DATE		DATE,
-- CLASS_YEAR		BIGINT,
-- WORK_FROM		DATE,

PRIMARY KEY USING HASH (EID)
);

-- Vertex Attributes (VA)
-- Since SQLGraph uses an unspecified Relational database with JSON storage capabilities
-- Instead of adding json, a column for each different possible vertex attribute can be used.

CREATE TABLE VA
(
VID			BIGINT NOT NULL,
TYPE 		VARCHAR(20),
ATTR			JSON,
-- Person Attributes
-- CREATION_DATE		DATE,
-- FIRST_NAME		VARCHAR(100),
-- LAST_NAME		VARCHAR(100),
-- GENDER			VARCHAR(32),
-- BIRTHDAY		DATE,
-- EMAIL			VARCHAR(100),
-- SPEAKS			VARCHAR(100),
-- BROWSER_USED		VARCHAR(100),
-- LOCATION_IP		VARCHAR(100),

-- Place Attributes
-- NAME			VARCHAR(100),

-- Message Attributes
-- CONTENT			VARCHAR(1024),
-- LENGTH			BIGINT,

-- Post attributes
-- LANGUAGE		VARCHAR(100),
-- IMAGE_FILE		VARCHAR(1024),

-- Forum attributes
-- TITLE			VARCHAR(256),

-- Tag attributes
-- NAME

-- Tagclass attributes
-- NAME

-- Organisation attributes
-- TYPE
-- Name

-- The vertice names missing had the attributes already declared by anoter vertex type and share the same name
INDEX va_type USING HASH (TYPE),
PRIMARY KEY USING HASH (VID)
);
