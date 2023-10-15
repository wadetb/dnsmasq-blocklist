# DNSMasq Blocklist Script

This project provides a simple bash script, a systemd service, and a timer to fetch a blocklist for ad and malware domains and configure DNSMasq to block them.

## Files

- `dnsmasq-blocklist.sh`: Bash script that fetches a blocklist and converts it into a format usable by DNSMasq.
- `dnsmasq-blocklist.service`: A systemd service unit file to run the script once.
- `dnsmasq-blocklist.timer`: A systemd timer unit file to run the blocklist update script on a daily schedule.

## Description

### dnsmasq-blocklist.sh

This bash script does the following:

- Downloads a host file containing a blocklist from a specified URL. Currently, it uses a list maintained by [StevenBlack](https://github.com/StevenBlack/hosts).
- Converts the host file into a format usable by DNSMasq with `awk`.
- Saves the converted list in a dnsmasq configuration file.
- Restarts the DNSMasq service to apply the changes.

### dnsmasq-blocklist.service

This systemd service unit file executes the script once when started. It can also be used to test the script and to update the blocklist without waiting for the next scheduled run.

### dnsmasq-blocklist.timer

This systemd timer unit file schedules the above service to run daily, ensuring that your blocklist is always up to date.

## Usage

### Prerequisites

Ensure you have `DNSMasq` and `curl` installed and configured on your system.

### Installation

1. Clone this repository and navigate to the project folder.

   ```shell
   git clone https://github.com/wadetb/dnsmasq-blocklist.git
   cd dnsmasq-blocklist
   ```

2. Make the script executable.

   ```shell
   chmod +x dnsmasq-blocklist.sh
   ```

3. Move the script to where the service file expects it.

   ```shell
   sudo mv dnsmasq-blocklist.sh /usr/local/bin/
   ```

4. Copy the systemd service and timer files to the systemd folder.

   ```shell
   sudo cp dnsmasq-blocklist.service dnsmasq-blocklist.timer /etc/systemd/system/
   ```

5. Reload the systemd daemon to recognize the new service and timer.

   ```shell
   sudo systemctl daemon-reload
   ```

6. Start and enable the timer to run the service daily.

   ```shell
   sudo systemctl start dnsmasq-blocklist.timer
   sudo systemctl enable dnsmasq-blocklist.timer
   ```

## Manual Update

To manually update the blocklist, you can start the service with:

   ```shell
   sudo systemctl start dnsmasq-blocklist.service
   ```

## License

MIT

