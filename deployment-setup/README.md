
# Deployment of DPSA infrastructure

Here we describe the minimal setup required for running a distributed deployment with two aggregator servers.
In a nutshell, each aggregator server is set up like a normal janus server,
with an additional server process which handles DPSA-specific functionality, such as keeping track of training
sessions.

## Detailed setup
One of the aggregator servers takes on the role of the "leader", and the other is the "helper". In our setup this distribution of roles is fixed and has to be decided beforehand. The leader is responsible for most communications with controller and clients, but the privacy-relevant parts of the distributed aggregation algorithm are split symmetrically between both leader and helper.

The following processes have to run on an aggregator server:
 1. **aggregator**: On the leader server, this is the main endpoint for collector and client requests, i.e., clients submit their gradients by using the API provided by this process, and collectors receive the aggregated data. On the helper, this process responds to requests from the leader.
 6. **janus_tasks**: Manages provisioning of new aggregation tasks with correct parameters according to the current training session. Provides information about the training session parameters to the clients. Has to run on both leader and helper.
 5. **postgres database**: Used for storing client reports and intermediate computation results. Has to run on both leader and helper.
 2. **aggregation_job_creator**: Only required on the leader.
 3. **aggregation_job_driver**: Only required on the leader.
 4. **collection_job_driver**: Only required on the leader.











