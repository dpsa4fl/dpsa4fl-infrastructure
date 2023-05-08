
# Deployment of DPSA infrastructure

Here we describe the minimal setup required for running a distributed deployment with two aggregator servers.
In a nutshell, each aggregator server is set up like a normal janus server,
with an additional server process which handles DPSA-specific functionality, such as keeping track of training
sessions.

If you only want to run DPSA locally for testing purposes, see [here](../docker-test-setup) for a docker-compose based solution.

## Detailed setup
One of the aggregator servers takes on the role of the "leader", and the other is the "helper". In our setup this distribution of roles is fixed and has to be decided beforehand. The leader is responsible for most communications with controller and clients, but the privacy-relevant parts of the distributed aggregation algorithm are split symmetrically between both leader and helper.

The following processes have to run on an aggregator server:
 1. **aggregator**: On the leader server, this is the main endpoint for collector and client requests, i.e., clients submit their gradients by using the API provided by this process, and collectors receive the aggregated data. On the helper, this process responds to requests from the leader.
 2. **aggregation_job_creator**: Only required on the leader.
 3. **aggregation_job_driver**: Only required on the leader.
 4. **collection_job_driver**: Only required on the leader.
 5. **dpsa4fl-janus-manager**: Manages provisioning of new aggregation tasks with correct parameters according to the current training session. Provides information about the training session parameters to the clients. Has to run on both leader and helper.

Additionally, a postgres database is required for both servers:
 1. **postgres database**: Used for storing client reports and intermediate computation results. Has to run on both leader and helper.

## Building
Executables (1.) through (4.) are built from our [janus fork](https://github.com/dpsa-project/janus/tree/dpsa-m6-dev). After cloning, you can use the following command:
```
cargo build --release -p janus_aggregator --bin $BINARY
```
where `$BINARY` is the name of the executable to build.

Executable (5.) is built from the [dpsa4fl](https://github.com/dpsa-project/dpsa4fl) repository. Similarly, after cloning, just do
```
cargo build --release
```

In each case, after building, the executables can be found in the `target/release` subdirectory.

## Running
Use the following command to start each binary:
```
$BINARY --config-file $CONFIG --datastore-keys $KEY
```
where `$CONFIG` is the path to the configuration for that executable (each executable has a different configuration file format), and `$KEY` is the datastore key, which should be the same for all binaries running on the same server.

## Database
Each server requires a postgres database. Initialize it with the schema found [here](../docker-test-setup/config/postgres/schema.sql).

## Configuration
A set of valid minimal configuration files can be found in the [local setup example](../docker-test-setup/config).

For example, the configuration for the aggregator is as follows:
```
listen_address: 0.0.0.0:9991
max_upload_batch_size: 50
max_upload_batch_write_delay_ms: 500
database:
  url: postgres://admin:password@db1:5432/dpsa
```
The listening port can be chosen freely. The url for the database should contain the same data as chosen when setting up the database for this server, in the format `$USER:$PASSWORD@$ADDRESS:$PORT/$DBNAME`.

As another example, a sample configuration for the janus manager is as follows:
```
listen_address: 0.0.0.0:9981
max_upload_batch_size: 50
max_upload_batch_write_delay_ms: 500
database:
  url: postgres://admin:password@db1:5432/dpsa
leader_endpoint: http://aggregator1:9991
helper_endpoint: http://aggregator2:9992
external_leader: http://127.0.0.1:9991
external_helper: http://127.0.0.1:9992
```
Here the `endpoint` address contains the url as seen locally by the aggregators when communicating with each other, while the `external` address contains the url as seen by controller and client. Depending on the deployment these might be the same.

Note that the sample configuration for both `aggregation_job_driver` and `collection_job_driver` is given by the same file.

More details, and further examples can be found in the [janus deployment documentation](https://github.com/divviup/janus/blob/main/docs/DEPLOYING.md).



