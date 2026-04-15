![Docker Image Version](https://img.shields.io/docker/v/chaos/dotnet-nukebuild/latest?label=Current&style=for-the-badge)
![Docker Image Version](https://img.shields.io/docker/v/chaos/dotnet-nukebuild/preview?color=%23dd0000&label=Preview&style=for-the-badge)
![Docker Image Version](https://img.shields.io/docker/v/chaos/dotnet-nukebuild/9?label=SDK%209%20(STS)&style=for-the-badge)
![Docker Image Version](https://img.shields.io/docker/v/chaos/dotnet-nukebuild/8?label=SDK%208%20(LTS)&style=for-the-badge)
![GitHub last commit](https://img.shields.io/github/last-commit/chA0s-Chris/dotnet-nukebuild?style=for-the-badge)
![Docker Image Size (latest semver)](https://img.shields.io/docker/image-size/chaos/dotnet-nukebuild/latest?style=for-the-badge)
![Docker Pulls](https://img.shields.io/docker/pulls/chaos/dotnet-nukebuild?style=for-the-badge)
![GitHub](https://img.shields.io/github/license/chA0s-Chris/dotnet-nukebuild?style=for-the-badge)

# dotnet-nukebuild

A Linux-based Docker image intended to use with CI/CD servers for building .NET Core applications.

The image is tagged for the current .NET releases and is bases on the corresponding official .NET SDK (Ubuntu flavor). 

## Tags

| Tags                 | Status   | SDK                          | Runtime                    | Base            |
|----------------------|----------|------------------------------|----------------------------|-----------------|
| 10, latest           | LTS      | 10.0.202                     | 10.0.6                     | Ubuntu Noble    |
| 11-preview, preview  | Preview  | 11.0.100-preview.3.26207.106 | 11.0.0-preview.3.26207.106 | Ubuntu Resolute |
| 9                    | STS      | 9.0.313                      | 9.0.15                     | Ubuntu Noble    |
| 8                    | LTS      | 8.0.420                      | 8.0.26                     | Ubuntu Noble    |

## Additional software

* Docker CLI 29.4.0
* kubectl 1.35.3
* [nuke](https://nuke.build) 9.0.4 (10.1.0) as global tool 
* Azure Artifacts Credential Provider
* docker pushrm 1.9.0 ([Docker Push Readme](https://github.com/christian-korneck/docker-pushrm))
* git 2.43.0
* git-lfs 3.7.1
* .NET Aspire SDK
* Node.js 24.14.1

## Get The Image

```bash
docker pull chaos/dotnet-nukebuild:latest
```

Or visit the [chaos/dotnet-nukebuild page](https://hub.docker.com/r/chaos/dotnet-nukebuild) on **docker hub**.

## Versioning

Since .NET 6 the major version of this image will always correspond to the .NET SDK version included.

## Preview/RC .NET 11

The current preview of .NET 11 is available using the `preview` tag.

## License

[MIT](https://github.com/chA0s-Chris/dotnet-cakebuild/blob/master/LICENSE)