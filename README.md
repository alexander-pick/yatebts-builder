# YateBTS builder

This project is a build environment for YateBTS. It will pull all sources from the SVN and will build Yate, YateBTS and bladeRF firmware inside a handy docker container. A dockerfile and a script for creating the docker container are included as well. The docker container is configured to allow the use of a SDR connected to the host system and will run the YateBTS webconfig on localhost:80 for convenient use. So it's pretty much a plug and play YateBTS setup for anyone who doesn't want to spend time on getting it going manually. The setup is still suitable for development purpose using the included `build_yate.sh` script to recompile individual components. Fully customize able for advanced users. 

System was tested with a bladeRF x40 and A4 SDRs. The source tags pulled are the one recommended in the YateBTS setup guide.

This is a small project I build after taking the amazing baseband security training by Marius Münch and Fabian Freyer at hardwear.io, which took place in The Hauge this year. If you are interested in baseband research I really recommend you their trainings as a kickstart.

*YateBTS builder is the first part of multiple releases aimed to aid baseband research and will be the foundation for the other tools. So stay tuned!*

# Basic Operation

- use `dockerbuild.sh` to build container
- once the container is up use `build_yate.sh --all` to build yatebts and bladeRF with all components.
- use `run_yate.sh` to run yate

If you want to look at the help, use `--help`. There are some advanced options for the scripts:

## build_yate.sh Parameter

> 		Possible parameter1:
>         --help          display this help
>         --all           cleans, downloads and build all components - yate, yatebts and bladerf (recommended for a first run)
>         --download      downloads the required sources
>         --rebuild-yate  rebuilds yate
>         --rebuild-yatebts       rebuilds yatebts
>         --rebuild-core  rebuilds yate and yatebts
>         --rebuild-bladerf       rebuilds bladerf
>         --web           redo the web setup (port 80 webpanel)
>         --clean         clean all external sources (WARNING: deletes all currently present sources!)
> 		Possible parameter2:
>         --quick         quick build, without configure or clean

## run_yate.sh Parameter

>        --help   display this help
>        --pcap   capture a pcap of the GSM traffic via GSMtap*
>        --x40    flash bladeRF x40 before starting
>        --a4     flash bladeRF A4 before starting
>        * requrires GSMTAP to be enabled (in webpanel)

# YateBTS Settings

YateBTS comes with a web panel which can be accessed at `http://localhost/nipc/`. Apache will inside docker will run at port 80 by default. If your port 80 is already in used adjust the port in `dockerbuild.sh`. Reconfigure the dockerfile if you want to use another port at localhost.

# Troubleshooting

Here are some solutions for problems I encountered during my journey with YateBTS:

**Ahead of time errors**
Restart Docker. These errors are sometimes combined with some IOCTL errors which are hard to spot and happen after Yate crashed once.

**Port 80 already in use**
If port 80 is in use on your host adjust the port in dockerbuild.sh

**Weird burst error**
Move the phone away from the SDR antennas, check for timing issues on the host.

**ADB disconnecting inside cage**
Move the phone away from the SDR antennas, use better USB cables.

# Contact Info

You can contact me via twitter at `@alexander_pick` or at mastodon via `@alxhh@infosec.exchange` if you are interested to chat about the project or basebands in general. 

Please fill bug reports and feature requests here at github. Valeuable pull requests are welcome if they match the license.

Software is provided as-is, without any warranty and under MIT License.

Have fun.
