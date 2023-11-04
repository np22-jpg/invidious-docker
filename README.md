# invidious-docker
This is a small project that incorporates some patches from [yewtu.be](https://github.com/yewtudotbe/invidious-custom), specfically to make it a bit more usable for general use due to yewtu.be's [limited accepted contributions](https://github.com/yewtudotbe/invidious-custom/pull/88). As per usual, patches pulled from other sources may be upstreamed eventually.

## Why?
Redis support, mostly! Just add `redis_url` or `redis_socket` to your config. Patch sources also include a variety of tweaks to decrease server load.


## Builds
In addition, a variety of builds are included:
| Name | Description | Tag |
|------|-------------|-----|
| CentOS | A simple Almalinux build | centos
| Debian | A simple Debian build | debian
| Ubuntu | A simple Ubuntu build | ubuntu
| Alpine | A simple Alpine build | alpine
| Minimal | A static build in a minimal container | min

Use whatever build you like! They each come 3 variants: `vanilla`, `highload`, and `redis`. `vanilla` contains no patches, `redis` contains the majority of patches from [yewtu.be](https://yewtu.be), and `highload` contains the majority of patches from `redis` except for the one that provides Redis support.

For example, a pull would be: 
```
podman pull ghcr.io/np22-jpg/invidious:centos-redis-amd64
```

Currently, there are only ARM builds for Alpine, as they are the only official packager with Crystal lang support. [All other builds are amd64 only](https://build.opensuse.org/repositories/devel:languages:crystal/crystal).