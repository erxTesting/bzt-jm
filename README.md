# BlazeMeter Taurus and JMeter container
### See https://hub.docker.com/r/erxx/bzt-jm
### Taurus / JMeter only layered container	bzt-erx:v0.4 
### See https://github.com/erxTesting/erx-bzt-container
### Future; incorporate functionality from prior Terraform/EC2 version of LG; 
    # Fluentd streaming to ELK 
    # Orchestration refinements, tagging, etc. 
    # Automated workload packaging and handoff 
    # Tweak and include configs; .ssh, .bzt-rc, folders/path (mkdir, chown) 
    # Resource alloactions (JVM) 
    # Ongoing; hardening, 
      # Thinning; java is bloated (cntr best practices, openjdk?), 
        # python lib snip (cntr best practices, pip?), , etc. 
	### v0.4	Include configs, update java version
	### v0.3	Tweaks, refinements and slight thinning
	### v0.2	Thinned out to ~1.3 GB and debugged several issues and stabilities
	### v0.1	Rough working draft; nearly 3 GB in size

### Use phusion/baseimage as base image. To make your builds reproducible, make
### sure you lock down to a specific version, not to `latest`!
### See https://github.com/phusion/baseimage-docker/blob/master/Changelog.md for
### a list of version numbers.
### Build:	docker build -t bzt-erx:latest .
### Run:		docker run -t -i --rm bzt-erx:<VERSION> /sbin/my_init -- bash -l
