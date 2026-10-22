# Omnichannel Analytics

An end-to-end analytics pipeline for consolidating customer activity across
products, channels, purchases, and visits. The project uses MySQL as a source,
Databricks as the analytics platform, Sling for replication, and dbt for
transformation and data quality.

## Architecture

```text
MySQL source
    |
    | Sling full-refresh replication
    v
Databricks bronze
    |
    | dbt staging views
    v
Databricks silver
    |
    | dbt dimensional and fact models
    v
Databricks gold --> Power BI dashboard
```

### Data layers

- **Source:** `OMNI_MANAGEMENT` MySQL database containing customers, products,
  channels, purchase history, and visit history.
- **Bronze:** Raw replicated tables in Databricks.
- **Silver:** dbt staging views that standardize source data.
- **Gold:** dbt tables designed for reporting and analysis:
  `dim_customers`, `dim_channels`, `dim_products`, `dim_date`,
  `fct_purchase_history`, and `fct_visit_history`.
- **Reporting:** `dashboards/omnichannel.pbix` contains the Power BI report.

## Repository structure

```text
.
├── compose.yaml                         # Local MySQL service
├── sql/omni_management.sql              # Source schema and sample data
├── replications/                        # Sling replication configuration
├── transform/
│   ├── models/staging/                  # Silver staging models and sources
│   ├── models/marts/                    # Gold dimensions and fact tables
│   ├── tests/                           # Custom dbt data quality tests
│   └── dbt_project.yml                  # dbt project configuration
├── databricks.yml                       # Databricks bundle and pipeline job
└── dashboards/omnichannel.pbix          # Power BI dashboard
```

## Prerequisites

- Docker and Docker Compose
- MySQL client (optional, for local inspection)
- Sling CLI
- Python with dbt and the Databricks adapter, or the Databricks CLI bundle
  environment
- Access to a Databricks SQL warehouse
- Power BI Desktop, if opening the dashboard

## Configuration

Copy the example files and replace placeholder values with credentials for
your environment:

```bash
cp .env.example .env
cp .env.dbt.example .env.dbt
cp .env.sling.example .env.sling
cp databricks.yml.example databricks.yml
```

Do not commit populated environment files or access tokens. The example files
describe the required MySQL, Databricks, dbt catalog, schema, and warehouse
settings.

## Local development workflow

1. Start the MySQL source database. The initialization script is mounted into
   the container and loads the `OMNI_MANAGEMENT` schema and sample data.

   ```bash
   docker compose up -d mysql
   ```

2. Replicate the source tables to Databricks using the checked-in Sling
   configuration:

   ```bash
   sling run -r replications/mysql_to_databricks.yaml
   ```

3. Install dbt packages and build the staging and mart models:

   ```bash
   cd transform
   dbt deps
   dbt build
   ```

   `dbt build` also runs the configured schema and custom data quality tests.

4. To run the managed Databricks job, authenticate with the Databricks CLI
   and deploy the bundle:

   ```bash
   databricks bundle deploy -t dev
   databricks bundle run -t dev omnichannel_pipeline
   ```

## Data quality

The dbt project checks primary and foreign-key relationships, uniqueness, and
non-null constraints for dimensional models. Custom tests also validate
positive length of stay, positive gross purchase amounts, and sensible unit
price relationships.

## License and ownership

This repository is maintained as an analytics engineering project. Add
deployment-specific credentials and workspace configuration locally rather
than committing them to source control.

<div align="center">

**Akram Taiyb**

</div>
