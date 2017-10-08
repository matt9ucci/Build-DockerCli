# Build-DockerCli.ps1

PowerShell script to build Docker CLI binary from [source in the docker-ce repository](https://github.com/docker/docker-ce/tree/master/components/cli) by using [docker-machine](https://github.com/docker/machine)

## Why?

* After [v17.05.0-ce](https://github.com/moby/moby/releases/tag/v17.05.0-ce), Docker CLI binary is not released separately from Docker CE.
* [The version of docker/cli](https://github.com/docker/cli/blob/master/VERSION) is not always consistent with the [docker-ce](https://github.com/docker/docker-ce/blob/master/VERSION)
* It is not so easy for Windows users (perhaps Linux/Mac users as well) to build the desired version of Docker CLI binary from source because it requires make, git, and docker.

## Requirements
* PowerShell (tested with v5.1 on Windows 10)
* docker-machine in `$env:PATH` (tested with v0.12.2 on Windows 10)
* Machine created by docker-machine (tested on VirtualBox)

## Usage
To build v17.09.0-ce on "default" machine, execute the following:
```powershell
.\Build-DockerCli.ps1 v17.09.0-ce
```
or
```powershell
.\Build-DockerCli.ps1 -Tag v17.09.0-ce
```

To build the latest source on "latestCli" machine, execute the following:
```powershell
.\Build-DockerCli.ps1 -Machine latestCli
```

## Output (Default)
Docker machine:
```
/home/docker/Build-DockerCli/components/cli/build/
	docker-windows-amd64
	docker-...
	docker-...
```

Windows PC:
```
 C:\Users\$env:USERNAME\
 	docker.exe (copy of docker-windows-amd64 above)
```

These output directories can be changed by `-WorkDir` and `-OutputDir` parameters.
