# warfork-docker
Warfork server on Docker!

## How to Use This Image

```
$ docker run \
  -v=wf:/home/warfork/server \
  -v=/path/to/wflogs:/home/warfork/.local/share/warfork-2.1/basewf \
  --net=host \
  gelmo/warfork-docker
```

- The server will be installed on a named volume `wf` to [persist the server files](https://docs.docker.com/storage/).
- The server's logs and demos directory will be mapped to the `/path/to/wflogs` directory to [persist the logs and demos](https://docs.docker.com/storage/).
- The server will be running on the `host` network for [optimal network performance](https://docs.docker.com/network/host/)

### Environment Variables

##### `WF_CUSTOM_CONFIGS_DIR`

Default: `/var/wf`

Absolute path to a directory in the container containing custom config and map files. Changing this is not recommended in order to follow the documentation.

##### `WF_PARAMS`

Additional [parameters](https://warforkwiki.com/index.php?title=Console_Commands) to pass to `wf_server.x86_64` (for example, +sv_hostname "Insta Server" +g_instagib "1").

### Populate with Own Configs

The server can be populated with your own config files and maps by copying the files from the custom configs directory located at [`WF_CUSTOM_CONFIGS_DIR`](#wf_custom_configs_dir) to the `basewf` folder at each start of the container. [`WF_CUSTOM_CONFIGS_DIR`](#wf_custom_configs_dir) is a mounted directory from the host system. The custom configs directory must have same folder structure as the `basewf` folder in order to add or overwrite the files at the paths.

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
  -v=/path/to/wflogs:/home/warfork/.local/share/warfork-2.1/basewf \
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

### Multiple Instances (More Info Soon)

