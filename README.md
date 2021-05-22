# Data-Analytics-FIAP

The following project intends to ingest a large, semistructured, log file - <strong>cloudera-quickstart/logs/access.log.2</strong> - from an e-commerce website and, finally, yield useful business data. To achieving so, it leverages the single node <strong>Hadoop Platform</strong> sandbox, provided by the modified [<strong>cloudera/quickstart</strong>](https://hub.docker.com/r/cloudera/quickstart/) official image.

All the scripts being used down below target UNIX/LINUX machines. However, if you happen to be a <strong>Windows</strong> user, you can just copy the commands within the body of the very scripts and run them on <strong>Power Shell</strong>. They will work regardless.

Please, make sure you have both <strong>docker</strong> and <strong>docker-compose</strong> installed on your machine. Then, run the following script to spin the sandbox:
```console
bash set_up_sandbox.bash
```

```console
bash create_table_and_views.bash
```

```console
bash dumd_results.bash
```

```console
bash tear_down_sandbox.bash
```
