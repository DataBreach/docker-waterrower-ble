###################################
#       PART 1 OF THE BUILD       #
###################################

# The build time container to build waterrower node modules
FROM balenalib/raspberrypi3-debian-node:8.14-stretch-build as build

# Start emulating ARM using QEMU to build the container on any x86 machine (including DockerHub)
RUN [ "cross-build-start" ]

# Install required packages to build waterrower-ble node modules
RUN apt-get update && apt-get install -y bluetooth bluez libbluetooth-dev libudev-dev libcap2-bin

# Download the waterrower-ble Git repository to the build time container
RUN git clone https://github.com/olympum/waterrower-ble

# Set working directory to downloaded waterrower-ble files
WORKDIR "/waterrower-ble"

# Install and build the waterrower-ble node modules and dependencies
RUN npm install --only=production

# Stop emulating ARM using QEMU
RUN [ "cross-build-end" ]

###################################
#       PART 2 OF THE BUILD       #
###################################

# The run time container that will go to Raspberry Pi 3 (B+) device
FROM balenalib/raspberrypi3-debian-node:8.14-stretch-run

# Start emulating ARM using QEMU to build the container on any x86 machine (including DockerHub)
RUN [ "cross-build-start" ]

# Install required packages to run waterrower-ble node modules
RUN apt-get update && apt-get install -y npm bluetooth bluez libbluetooth-dev libudev-dev libcap2-bin

# Install PM2 process manager for Node.js applications (i.e. waterrower-ble)
RUN npm install pm2 -g

# Grab our waterrower-ble files including the node modules from the build step
COPY --from=build ./waterrower-ble ./waterrower-ble

# Grab our PM2 process file
COPY . .

# Grant node the ability to change capabilities
RUN setcap cap_net_raw+eip $(eval readlink -f `which node`)

# Enable working with Dynamically Plugged Devices from within the container (i.e. the waterrower usb)
ENV UDEV=1

# Allow the container to listen for connections on port 5007 to use Network Mode (optional)
EXPOSE 5007

# Stop emulating ARM using QEMU
RUN [ "cross-build-end" ]

# Set waterrower-ble processes to start when a container is run
CMD [ "pm2-runtime", "process.yml" ]