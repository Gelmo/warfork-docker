# warfork-docker
Warfork server on Docker!

## How to Use This Image

```
$ docker run \
  -v=wf:/home/warfork/server \
  --net=host \
  gelmo/warfork-docker
```

- The server will be installed on a named volume `wf` to [persist the server files](https://docs.docker.com/storage/).
- The server will be running on the `host` network for [optimal network performance](https://docs.docker.com/network/host/)

### Environment Variables

##### `WF_IP`

Default: `0.0.0.0`

The IP the server is assigned to. In most cases the default value is sufficient, but if you want to run WFTV or have issues connecting to the server, the actual IP of the server should be set.

##### `WF_PORT`

Default: `44400`

The port the server is listening to.

##### `WF_HOSTNAME`

Default: `Warfork Server`

The server name.

##### `WF_CUSTOM_CONFIGS_DIR`

Default: `/var/wf`

Absolute path to a directory in the container containing custom config and map files. Changing this is not recommended in order to follow the documentation.

##### `WF_PARAMS`

Additional [parameters](LinkToWiki) to pass to `wf_server.x86_64`.

### Populate with Own Configs

The server can be populated with own config files by copying the files from the custom configs directory located at [`WF_CUSTOM_CONFIGS_DIR`](#wf_custom_configs_dir) to the `basewf` folder at each start of the container. [`WF_CUSTOM_CONFIGS_DIR`](#wf_custom_configs_dir) is a mounted directory from the host system. The custom configs directory must have same folder structure as the `basewf` folder in order to add or overwrite the files at the paths.

#### Example

##### Host

Add configs and maps to `/home/user/wf`:

```
.
├── progs
│   └── gametypes
│       └── configs
│           ├── wipeout.as # Will be added
│           ├── wipeout.gt # Will be added
│           └── wipeout.gtd # Will be added
├── dedicated_autoexec.cfg # Will be overwritten
└── map_claustrophobia.pk3 # Will be added
```

##### Container

Mount `/home/user/wf` to [`WF_CUSTOM_CONFIGS_DIR`](#wf_custom_configs_dir) in the container:

```
$ docker run \
  -v=wf:/home/warfork/server \
  -v=/home/user/wf:/var/wf \ # Mount the custom configs directory
  --net=host \
  gelmo/warfork-docker
```

### Updating the Server

Once the server has been installed, the container will check for an update at every start.

#### Manually

Restart the container with [`docker restart`](https://docs.docker.com/engine/reference/commandline/restart/).

##### Example

Container named `wf`:

```
$ docker restart wf
```