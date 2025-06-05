# unity_catalog_examples

## flink

Maven project with IcebergUnityExample.

To run in IntelliJ IDE: add dependencies with "provided" scope to classpath
(provided depencencies are not added to classpath by default or shaded Jars as they are expected to be deployed in cluster).

Otherwise it is runnable application from the IDE, which can be used to insert generated data into the Iceberg table.

## Snowflake

Simple example how to connect to Unity Databricks Catalog and query a table.

## Spark 

Showcases the creation of managed endpoint on EMR on EKS (this requires EMR on EKS cluster) to run custom notebooks.

The most important part is (jar and Iceberg catalog configuration):
```
      "spark.jars": "local:///usr/share/aws/delta/lib/delta-core.jar,local:///usr/share/aws/delta/lib/delta-storage.jar,local:///usr/share/aws/delta/lib/delta-storage-s3-dynamodb.jar,local:///usr/share/aws/iceberg/lib/iceberg-spark3-runtime.jar",
      "spark.sql.catalog.unity": "org.apache.iceberg.spark.SparkCatalog"
      "spark.sql.catalog.unity.type": "rest",
      "spark.sql.catalog.unity.warehouse": "{catalog_name}",
      "spark.sql.catalog.unity.token": "{token}",
      "spark.sql.catalog.unity.uri": "https://{workspace}.cloud.databricks.com/api/2.1/unity-catalog/iceberg-rest",
      "spark.sql.extensions": "io.delta.sql.DeltaSparkSessionExtension,org.apache.iceberg.spark.extensions.IcebergSparkSessionExtensions",
```

More details about Managed Edgepoint can be found in [EMR on EKS documentation](https://docs.aws.amazon.com/emr/latest/EMR-on-EKS-DevelopmentGuide/create-managed-endpoint.html).