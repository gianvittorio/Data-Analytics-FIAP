# Data-Analytics-FIAP

The following project intends to ingest a large, semistructured, log file - <strong>cloudera-quickstart/logs/access.log.2</strong> - from an e-commerce website and, finally, yield useful business data. To achieving so, it leverages the single node <strong>Hadoop Platform</strong> sandbox, provided by the modified [<strong>cloudera/quickstart</strong>](https://hub.docker.com/r/cloudera/quickstart/) official image. We emphasize that the overall goal is to give the reader a step by step tutorial on how to set up a sandbox, run <strong>Map Reduce</strong> pipelines and, finally, tear down the sandbox.
All the scripts being used down below target UNIX/LINUX machines. However, if you happen to be a <strong>Windows</strong> user, you can just copy the commands within the body of the very scripts and run them on <strong>Power Shell</strong>. They will work regardless.

Please, make sure you have both <strong>docker</strong> and <strong>docker-compose</strong> installed on your machine. Then, run the following script to spin the sandbox:
```console
bash set_up_sandbox.bash
```
The whole process should take several minutes to get finished. You can follow through its progress by running:
```console
docker-compose logs cloudera-quickstart
```
We make use of <strong>Hive</strong> server, which provides us both a relational schema and <strong>HSQL</strong>, to building <strong>CRUD</strong> statements, later to be translated into Map Reduce jobs. That being said, please, run the following script, which will create the above mentioned schema, along with 3 views:

| ip  | data  | method  |  url  | http_version  | code1  | code2  | trace  | operating system  |
|---|---|---|---|---|---|---|---|---|
| STRING  | STRING  | STRING  |  STRING  | STRING  | STRING  | STRING  | STRING  | STRING  |

| Product  | Views  |
|---|---|
| STRING  | INT  |

| Views  | Hour  |
|---|---|
| INT  | INT  |

| OS  | Views  |
|---|---|
| STRING  | INT  |

```console
bash create_table_and_views.bash
```

Now, please, run the below script to dump the results from the above mentioned queries into log files under the <strong>results</strong>, namely:
  1. <strong>product_histogram.log</strong>
  2. <strong>views_per_hour.log</strong>
  3. <strong>os_histogram.log</strong>
```console
bash dumd_results.bash
```

Finally, please, run the following script to gracefully shutting down the container and releasing the resources it might be using.
```console
bash tear_down_sandbox.bash
```
