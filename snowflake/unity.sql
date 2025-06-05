CREATE CATALOG INTEGRATION unity_catalog
    CATALOG_SOURCE = ICEBERG_REST
    TABLE_FORMAT = ICEBERG
    REST_CONFIG = (
      CATALOG_URI = 'https://{workspace}.databricks.com/api/2.1/unity-catalog/iceberg-rest'
      WAREHOUSE = '{CATALOG_NAME}'
      ACCESS_DELEGATION_MODE = VENDED_CREDENTIALS
    )
    CATALOG_NAMESPACE = '{SCHEMA_NAME}'
    REST_AUTHENTICATION = (
      TYPE = BEARER
      BEARER_TOKEN = '{obo_token}'
    )
    ENABLED = TRUE;


ALTER CATALOG INTEGRATION unity_catalog SET
  REST_AUTHENTICATION = (
    BEARER_TOKEN = '{new_obo_token}'
  );

CREATE database unity_test;
USE database unity_test;

CREATE OR REPLACE ICEBERG TABLE unity_table_test
  CATALOG = 'unity_catalog'
  CATALOG_TABLE_NAME = 'unity_table'
  AUTO_REFRESH = TRUE;

select * from unity_table_test;

-- not supported yet via CREDENTIALS vending
insert into unity_table_test values (4, 'd');

