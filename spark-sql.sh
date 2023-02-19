# add Iceberg dependency
ICEBERG_VERSION=1.1.0
DEPENDENCIES="org.apache.iceberg:iceberg-spark-runtime-3.3_2.12:$ICEBERG_VERSION"

# add AWS dependnecy
AWS_SDK_VERSION=2.17.257
AWS_MAVEN_GROUP=software.amazon.awssdk
AWS_PACKAGES=(
    "bundle"
    "url-connection-client"
)
for pkg in "${AWS_PACKAGES[@]}"; do
    DEPENDENCIES+=",$AWS_MAVEN_GROUP:$pkg:$AWS_SDK_VERSION"
done

spark-sql --packages $DEPENDENCIES \
    --conf spark.sql.extensions=org.apache.iceberg.spark.extensions.IcebergSparkSessionExtensions \
    --conf spark.sql.catalog.glue_catalog=org.apache.iceberg.spark.SparkCatalog \
    --conf spark.sql.catalog.glue_catalog.warehouse=s3://varokas-iceberg-demo/iceberg \
    --conf spark.sql.catalog.glue_catalog.catalog-impl=org.apache.iceberg.aws.glue.GlueCatalog \
    --conf spark.sql.catalog.glue_catalog.io-impl=org.apache.iceberg.aws.s3.S3FileIO
