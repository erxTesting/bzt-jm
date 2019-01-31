## BlazeMeter Taurus and JMeter container
See https://hub.docker.com/r/erxx/bzt-jm
### Taurus / JMeter layered container	bzt-erx:v0.4.1 
See https://github.com/erxTesting/bzt-jm

**Future**
* incorporate functionality from prior Terraform/EC2 version of LG; 
* Orchestration refinements, tagging, etc. 
* Automated workload packaging and handoff 
* Tweak and include configs; .ssh, .bzt-rc, folders/path (mkdir, chown) 
* Resource allocations (JVM) 
* Ongoing;
  * hardening, 
  * thinning; java is bloated (cntr best practices, openjdk?), 
    * python lib snip (cntr best practices, pip?), , etc. 
* 0.4.1	Added jmeter_executor.yaml for elasticsearch streaming plugin instead of fluentd
* 0.4	Include configs, update java version
* 0.3	Tweaks, refinements and slight thinning
* 0.2	Thinned out to ~1.3 GB and debugged several issues and stabilities
* 0.1	Rough working draft; nearly 3 GB in size

> Built on a minimal Ubuntu base image
[**phusion/baseimage**](http://phusion.github.io/baseimage-docker/), 
 modified for Docker-friendliness that only **consumes 8.3 MB RAM** and is much
 more powerful than *Busybox or Alpine*. 
 Configured for correct use within Docker containers. 

**Build:**
```shell
$ docker build -t bzt-jm:latest .
```

**Run:**
```shell
$ docker run -t -i --rm bzt-jm:<VERSION> /sbin/my_init -- bash -l
```
