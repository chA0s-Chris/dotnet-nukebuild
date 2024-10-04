![Docker Image Version](https://img.shields.io/docker/v/chaos/dotnet-nukebuild/latest?label=Current&style=for-the-badge)
![Docker Image Version](https://img.shields.io/docker/v/chaos/dotnet-nukebuild/preview?color=%23dd0000&label=Preview&style=for-the-badge)
![Docker Image Version](https://img.shields.io/docker/v/chaos/dotnet-nukebuild/7?label=SDK%207%20(EOL)&style=for-the-badge)
![Docker Image Version](https://img.shields.io/docker/v/chaos/dotnet-nukebuild/6?label=SDK%206%20(LTS)&style=for-the-badge)
![GitHub last commit](https://img.shields.io/github/last-commit/chA0s-Chris/dotnet-nukebuild?style=for-the-badge)
![Docker Image Size (latest semver)](https://img.shields.io/docker/image-size/chaos/dotnet-nukebuild/latest?style=for-the-badge)
![Docker Pulls](https://img.shields.io/docker/pulls/chaos/dotnet-nukebuild?style=for-the-badge)
![GitHub](https://img.shields.io/github/license/chA0s-Chris/dotnet-nukebuild?style=for-the-badge)

# dotnet-nukebuild

A Linux-based Docker image intended to use with CI/CD servers for building .NET Core applications.

The image is tagged for the current .NET releases and is bases on the corresponding official .NET SDK (Ubuntu flavor). 

## Tags

| Tags      | Status | SDK                   | Runtime            | Base         |
| --------- | ------ | --------------------- | ------------------ | ------------ |
| 8, latest | LTS    | 8.0.402               | 8.0.8              | Ubuntu Jammy |
| 9-rc, rc  | RC     | 9.0.100-rc.1.24452.12 | 9.0.0-rc.1.24452.1 | Ubuntu Noble |
| 7         | EOL ⚠️  | 7.0.410               | 7.0.20             | Ubuntu Jammy |
| 6         | LTS    | 6.0.422               | 6.0.30             | Ubuntu Jammy |

## Additional software

* Docker CLI 27.3.1
* kubectl 1.31.0
* [nuke](https://nuke.build) 8.1.0 as global tool 
* Azure Devops credential provider for NuGet
* docker pushrm 1.9.0 ([Docker Push Readme](https://github.com/christian-korneck/docker-pushrm))
* git 2.34.1 / 2.43.0
* git-lfs 3.5.1

## Get The Image

```bash
docker pull chaos/dotnet-nukebuild:latest
```

Or visit the [chaos/dotnet-nukebuild page](https://hub.docker.com/r/chaos/dotnet-nukebuild) on **docker hub**.

## Versioning

Since .NET 6 the major version of this image will always correspond to the highest .NET SDK version included.

## Preview .NET 9

The current preview version is available using the `preview` tag and also includes:

* .NET Runtime 9.0.0-preview.3.24172.9
* .NET SDK 9.0.100-preview.3.24204.13

```bash
docker pull chaos/dotnet-nukebuild:preview
```

## License

[MIT](https://github.com/chA0s-Chris/dotnet-cakebuild/blob/master/LICENSE)