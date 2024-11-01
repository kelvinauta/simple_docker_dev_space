# Simple Docker Dev Space

A simple development space for Docker projects that allows you to run your code in development mode and easily access your container's shell. 🚀

Previously, to enter the container, you had to do this:

- `docker compose up -d`
- `docker exec -it workspace_name /bin/bash`
- `npm run dev` or the command you use to start your project
- `ctrl+c` to stop the process
- `exit` to leave the container
- `docker compose down` to stop the container

Now, you only need to run:
```bash
.docker_scripts/dev_space.sh
```
When you exit with `ctrl+c`, you will leave the container and stop your project's containers.

## Features

- 🛠️ Automatic switching between development/production modes based on the `.env` file
- 🖥️ Direct access to the container shell
- 🚀 Development experience identical to local development (even though you're in a container)

## Installation

1. Copy the scripts to your project (I suggest a folder named `/.docker_scripts/`)
2. Add a `.env` file at the root of your project with the following content:

```bash
DEV_MODE=true
```

3. Your Dockerfile should use WORKDIR, for example:

```Dockerfile
WORKDIR /app
```

4. Add the following Dockerfile to the root of your project:

```Dockerfile
COPY .docker_scripts/docker_mode.sh /usr/local/bin/docker_mode.sh
ENTRYPOINT ["docker_mode.sh"]
```

5. Add a name to your container in the `docker-compose.yml` file, for example:

```yaml
container_name: workspace
```

## Usage

```bash
sudo chmod +x .docker_scripts/dev_space.sh
.docker_scripts/dev_space.sh
```

## `docker_mode.sh`

This script is used to determine the execution mode of the project. It will set the mode to `production` by default and the command to `bun run start`. If the `DEV_MODE` environment variable is set to `true`, the mode will be set to `development` and the command will be set to `tail -f /dev/null`.

## `dev_space.sh`

This script is used to start a development environment for the project. It will start the containers and open a shell in the workspace container. Change the following variables in the script:

- `WORKSPACE_NAME`: The name of the workspace container, example: `workspace`
- `COMMAND`: The command to run in the workspace container, example: `bun run dev` or `npm run dev`