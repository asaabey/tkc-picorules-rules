DROP TABLE rman_resource_lookup;
/

CREATE TABLE rman_resource_lookup (
    res_name   VARCHAR2(100),
    res_type   VARCHAR2(30),
    res_target VARCHAR2(100),
    key_col    VARCHAR2(30),
    val_col    VARCHAR2(30),
    CONSTRAINT pk_rman_resource_lookup PRIMARY KEY ( res_name,
                                                     key_col )
);
/

    INSERT INTO rman_resource_lookup VALUES (
        'comp_map',
        'table',
        'rman_comp_map',
        'id',
        'name'
    );
/

    INSERT INTO rman_resource_lookup VALUES (
        'loc_sublocality',
        'view',
        'vw_locations',
        'key',
        'name'
    );
/

    INSERT INTO rman_resource_lookup VALUES (
        'rx_desc',
        'table',
        'system_rxcui_map',
        'id',
        'prescription'
    );
/