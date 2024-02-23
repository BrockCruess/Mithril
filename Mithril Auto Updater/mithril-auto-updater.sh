# Don't forget to make this .sh file executable with "chmod +x mithril-auto-updater.sh"
# Run this in the same directory as your Mithril binaries any time a new Mithril update is announced
# Set up a cronjob to run it daily/weekly/monthly with "crontab -e" or "sudo crontab -e" if you're running as root user for some reason
#!/bin/bash
# Find OS and format it to match the correct precompiled Mithril binaries
uname=$(uname)
if test "$uname" = "FreeBSD"
then os=linux
else
if test "$uname" = "Linux"
then os=linux
else
if test "$uname" = "Darwin"
then os=macos
fi
fi
fi
# Format old version backup file names by version number & replace spaces with hyphens
clientOld=$(./mithril-client --version | tr ' ' '-')
signerOld=$(./mithril-signer --version | tr ' ' '-')
aggregatorOld=$(./mithril-aggregator --versionn | tr ' ' '-')
relayOld=$(./mithril-relay --version | tr ' ' '-')
# Back up old versions by version number to a folder called "version-backups"
mkdir -p version-backups
mv mithril-client version-backups/$clientOld.bak
mv mithril-signer version-backups/$signerOld.bak
mv mithril-aggregator version-backups/$aggregatorOld.bak
mv mithril-relay version-backups/$relayOld.bak
# Find and delete old .tar.gz download file
oldTar=$(find . -maxdepth 1 -name "*.tar.gz" -print | cut -c 3-)
rm $oldTar
# Check latest Mithril release for OS and download it
latestMithril=$(curl https://api.github.com/repos/input-output-hk/mithril/releases/latest | grep -n "tag_name" | cut -c 19-24)
wget https://github.com/input-output-hk/mithril/releases/download/$latestMithril/mithril-$latestMithril-$os-x64.tar.gz && \
# Uncompress only the files we need and make them all executable
tar -xf mithril-$latestMithril-$os-x64.tar.gz mithril-client mithril-signer mithril-aggregator mithril-relay && \
chmod +x mithril-client mithril-signer mithril-aggregator mithril-relay
