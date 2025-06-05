package org.example;

import org.apache.flink.connector.datagen.table.DataGenConnectorOptions;
import org.apache.flink.streaming.api.environment.StreamExecutionEnvironment;
import org.apache.flink.table.api.*;
import org.apache.flink.table.api.bridge.java.StreamTableEnvironment;
import org.slf4j.LoggerFactory;

import org.slf4j.Logger;

import static org.apache.flink.table.api.Expressions.$;
import static org.apache.flink.table.api.Expressions.lit;

public class IcebergUnityExample {
    private static final Logger LOG = LoggerFactory.getLogger(IcebergUnityExample.class);


    public static void main(String[] args) {
        LOG.info("Starting Flink example...");

        StreamExecutionEnvironment executionEnvironment =
                StreamExecutionEnvironment.getExecutionEnvironment();
        executionEnvironment.enableCheckpointing(1000);
//
        StreamTableEnvironment tableEnvironment = StreamTableEnvironment.create(executionEnvironment);

        tableEnvironment.createTemporaryTable(
                "SourceTable",
                TableDescriptor.forConnector("datagen")
                        .schema(
                                Schema.newBuilder()
                                        .columnByExpression("proc_time", "PROCTIME()")
                                        .column("id", DataTypes.STRING())
                                        .column("value", DataTypes.INT())
                                        .build())
                        .option(DataGenConnectorOptions.ROWS_PER_SECOND, 1L)
                        .build());



        tableEnvironment.executeSql("CREATE CATALOG rest_catalog WITH (\n" +
                "  'type'='iceberg',\n" +
                "  'catalog-type'='rest',\n" +
                "  'uri'='https://{workspace_name}.cloud.databricks.com/api/2.1/unity-catalog/iceberg-rest', \n" +
                "  'token'='{obo_token}', \n" +
                "  'warehouse'='{catalog_name}'\n" +
                ");");


        Table sourceTable = tableEnvironment.from("SourceTable");

        Table result =
                sourceTable
                        .window(
                                Tumble.over(lit(30).seconds())
                                        .on($("proc_time"))
                                        .as("fiveMinutesWindow"))
                        .groupBy($("fiveMinutesWindow"))
                        .select(
                                $("id").count().as("count"),
                                $("value").sum().as("total"),
                                $("fiveMinutesWindow").end().as("time")
                        );

        // Can use below to create table
        //        tableEnvironment.executeSql("CREATE  TABLE `rest_catalog`.`db`.`unity_example_from_flink` (" +
//                "  `count` BIGINT," +
//                "  `total` bigint," +
//                "  `time` TIMESTAMP" +
//                ") WITH ('format-version'='2');");
        result.insertInto("rest_catalog.{schema_name}.unity_example_from_flink").execute();

        // instead of insert into can print for tests
        //        result.execute().print();
    }
}
