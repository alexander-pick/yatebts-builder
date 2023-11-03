# Local BTS builder (GSM / LTE / 5G)

This project is a build environment for a local BTS setup. It will pull all sources and will build Yate, YateBTS, srsRAN 4G, srsProject and a suiteable bladeRF firmware inside a handy docker container and build them for you - ready to go. The setup can be used for testing or development purpose.

The docker container is configured to allow the use of a SDR connected to the host system and will run the YateBTS webconfig on http://localhost:8080 for convenient use. So it's pretty much a plug and play bts setup for anyone who doesn't want to spend time on building it manually. The setup is furthermore suitable for development purpose using the included `build_bts.sh` script to recompile individual components. Use `--quick` for fast rebuilds after smaller changes, it will ommit the clean and reconfigure step. 

System was tested with a bladeRF x40 and A4 SDRs. The source tags pulled are the one recommended in the YateBTS setup guide. This build enviornment evolved over time and LTE + 5G were added using srsRAN.

# Basic Operation

- use `dockerbuild.sh` to build container
- once the container is up use `build_bts.sh --all` to build the full stack with all components.

Binaries are located in `/usr/local/bin/` after successful building.

More options:

- use `run_yate.sh` to run `yateBTS`
- use `run_srs.sh` to run `srsRAN 4G` or `srsRAN Project` (5G)
- use `flash_bladerf.sh` to flash your bladeRF to the required version

If you want to look at the help, use `--help`. There are some advanced options for the scripts:

## build_bts.sh Parameter

> 		Possible parameter 1:
>         --help                display this help
>         --all                 cleans, downloads and build all components - yate, yatebts and bladerf (recommended for a first run)
>         --download            downloads the required sources
>         --rebuild-yate        rebuilds yate
>         --rebuild-yatebts     rebuilds yatebts
>         --rebuild-core        rebuilds yate and yatebts
>         --rebuild-bladerf     rebuilds bladerf
>         --web                 redo the web setup (port 80 webpanel)
>         --clean               clean all external sources (WARNING: deletes all currently present sources!)
> 		Possible parameter 2:
>         --quick               quick re-build, without configure or clean

## run_yate.sh Parameter

>        --help   display this help
>        --pcap   capture a pcap of the GSM traffic via GSMtap*
>        * requrires GSMTAP to be enabled (in webpanel)

## run_srs.sh Parameter

>        --help   display this help

## flash_bladerf.sh Parameter

>        --help   display this help
         --a4     flash bladeRF A4
         --x40    flash bladeRF x40

# YateBTS Settings

YateBTS comes with a web panel which can be accessed at `http://localhost:8080/nipc/`. Apache will inside docker will run at port 8080 by default. If your port 8080 is already in used adjust the port in `dockerbuild.sh`. Reconfigure the dockerfile if you want to use another port at localhost.

# srsRAN Settings

Please edit the config files located at `/etc/srsran/`.

# Troubleshooting

Here are some solutions for problems I encountered during my journey:

**Ahead of time errors**
Restart Docker. These errors are sometimes combined with some IOCTL errors which are hard to spot and happen after yateBTS crashed once.

**Port 8080 already in use**
If port 8080 is in use on your host adjust the port in `dockerbuild.sh`

**Weird burst error**
Move the phone away from the SDR antennas, check for timing issues on the host.

**ADB disconnecting inside cage**
Move the phone away from the SDR antennas, use better USB cables.

# Motivation

This is a small project I build after attending the amazing baseband security training by Marius Münch and Fabian Freyer at (hardwear.io 2022)[https://hardwear.io/usa-2022/training/reverse-engineering-emulation-dynamic-testing-cellular-baseband-firmware.php]. If you are interested in baseband research I really recommend you their trainings as a kickstart.

# Contact Info

Please fill bug reports and feature requests here at github. Valeuable pull requests are welcome if they match the license.

Software is provided as-is, without any warranty and under MIT License.

Have fun.
