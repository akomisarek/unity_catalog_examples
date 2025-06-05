aws emr-containers create-managed-endpoint \
--profile {aws_profile} \
--type JUPYTER_ENTERPRISE_GATEWAY \
--virtual-cluster-id {virtual_cluster_id} \
--name {endpoint-name} \
--execution-role-arn {execution-role} \
--release-label emr-7.5.0-latest \
--configuration-overrides '{
    "applicationConfiguration": [
        {
            "classification": "spark-defaults",
            "properties": {
              "spark.jars": "local:///usr/share/aws/delta/lib/delta-core.jar,local:///usr/share/aws/delta/lib/delta-storage.jar,local:///usr/share/aws/delta/lib/delta-storage-s3-dynamodb.jar,local:///usr/share/aws/iceberg/lib/iceberg-spark3-runtime.jar",
              "spark.sql.catalog.unity": "org.apache.iceberg.spark.SparkCatalog"
              "spark.sql.catalog.unity.type": "rest",
              "spark.sql.catalog.unity.warehouse": "{catalog_name}",
              "spark.sql.catalog.unity.token": "{token}",
              "spark.sql.catalog.unity.uri": "https://{workspace}.cloud.databricks.com/api/2.1/unity-catalog/iceberg-rest",
              "spark.sql.extensions": "io.delta.sql.DeltaSparkSessionExtension,org.apache.iceberg.spark.extensions.IcebergSparkSessionExtensions",
              "spark.sql.catalogImplementation": "hive",
              "spark.sql.catalog.spark_catalog": "org.apache.spark.sql.delta.catalog.DeltaCatalog",
              "spark.hive.metastore.client.factory.class": "com.amazonaws.glue.catalog.metastore.AWSGlueDataCatalogHiveClientFactory",
              "spark.sql.adaptive.enabled": "true",
              "spark.hadoop.fs.s3a.aws.credentials.provider": "com.amazonaws.auth.WebIdentityTokenCredentialsProvider",
              "spark.kubernetes.driver.label.service": "jupyter-notebook",
              "spark.executor.memory": "8G",
              "spark.driver.memory": "4G",
              "spark.sql.adaptive.advisoryPartitionSizeInBytes": "128m",
              "spark.driver.cores": "2",
              "spark.executor.cores": "4",
              "spark.dynamicAllocation.enabled": "true",
              "spark.dynamicAllocation.minExecutors": "1",
              "spark.dynamicAllocation.maxExecutors": "20",
              "spark.sql.adaptive.coalescePartitions.parallelismFirst": "false",
            }
        },
        {
            "classification": "endpoint-configuration",
            "properties": {
                "self-managed-nodegroup-name": "emr-notebook"
            }
        }
    ],
    "monitoringConfiguration": {
        "persistentAppUI": "ENABLED",
        "s3MonitoringConfiguration": {
            "logUri": "s3://{path-to-log}"
        }
    }
  }'