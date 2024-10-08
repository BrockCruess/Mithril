# Don't forget to make this .sh file executable with "chmod +x mithril-auto-updater.sh"
# Run this in the same directory as your Mithril binaries any time a new Mithril update is announced
# Set up a cronjob to run it daily/weekly/monthly with "crontab -e" or "sudo crontab -e" if you're running as root user for some reason
#!/bin/bash

# Which binaries do you use? Type "yes" with no spaces or uppercase letters for binaries you use
client=yes
signer=yes
aggregator=no
relay=yes

# Configure session:
RED='\033[0;31m'
YELLOW='\033[0;33m'
GREEN='\033[0;32m'
PURPLE='\033[0;35m'
NC='\033[0m'
# Find OS and format it to match the correct precompiled Mithril binaries
uname=$(uname)
if test "$uname" = "Linux"
then os=linux
else
if test "$uname" = "Darwin"
then os=macos
fi
fi
# Format old version backup file names by version number & replace spaces with hyphens
if test "$client" = "yes"
then clientOld=$(./mithril-client --version | tr ' ' '-')
fi
if test "$signer" = "yes"
then signerOld=$(./mithril-signer --version | tr ' ' '-')
fi
if test "$aggregator" = "yes"
then aggregatorOld=$(./mithril-aggregator --version | tr ' ' '-')
fi
if test "$relay" = "yes"
then relayOld=$(./mithril-relay --version | tr ' ' '-')
fi
# Back up old versions by version number to a folder called "version-backups"
mkdir -p version-backups
if test "$client" = "yes"
then mv mithril-client version-backups/$clientOld.bak
fi
if test "$signer" = "yes"
then mv mithril-signer version-backups/$signerOld.bak
fi
if test "$aggregator" = "yes"
then mv mithril-aggregator version-backups/$aggregatorOld.bak
fi
if test "$relay" = "yes"
then mv mithril-relay version-backups/$relayOld.bak
fi
# Find and delete any old .tar.gz download files
oldTar=$(find . -maxdepth 1 -name "*.tar.gz" -print | cut -c 3-)
rm $oldTar
# Check latest Mithril release for OS and download it
latestMithril=$(curl https://api.github.com/repos/input-output-hk/mithril/releases/latest | grep -n "tag_name" | cut -c 19-24)
wget https://github.com/input-output-hk/mithril/releases/download/$latestMithril/mithril-$latestMithril-$os-x64.tar.gz && \
# Uncompress only the files we need and make them all executable
if test "$client" = "yes"
then tar -xf mithril-$latestMithril-$os-x64.tar.gz mithril-client && chmod +x mithril-client
fi
if test "$signer" = "yes"
then tar -xf mithril-$latestMithril-$os-x64.tar.gz mithril-signer && chmod +x mithril-signer
fi
if test "$aggregator" = "yes"
then tar -xf mithril-$latestMithril-$os-x64.tar.gz mithril-aggregator && chmod +x mithril-aggregator
fi
if test "$relay" = "yes"
then tar -xf mithril-$latestMithril-$os-x64.tar.gz mithril-relay && chmod +x mithril-relay
fi
# Create shorter version names
if test "$client" = "yes"
then clientNewShort=$(./mithril-client --version | tr ' ' '-' | cut -c 16-)
fi
if test "$signer" = "yes"
then signerNewShort=$(./mithril-signer --version | tr ' ' '-' | cut -c 16-)
fi
if test "$aggregator" = "yes"
then aggregatorNewShort=$(./mithril-aggregator --version | tr ' ' '-' | cut -c 20-)
fi
if test "$relay" = "yes"
then relayNewShort=$(./mithril-relay --version | tr ' ' '-' | cut -c 15-)
fi
if test "$client" = "yes"
then clientOldShort=$(echo $clientOld | cut -c 16-)
fi
if test "$signer" = "yes"
then signerOldShort=$(echo $signerOld | cut -c 16-)
fi
if test "$aggregator" = "yes"
then aggregatorOldShort=$(echo $aggregatorOld | cut -c 20-)
fi
if test "$relay" = "yes"
then relayOldShort=$(echo $relayOld | cut -c 15-)
fi
# Compare versions before and after to check if an update actually took place - if it did, log it
time=$(date)
if test "$clientOldShort" != "$clientNewShort"
then echo "" >> updates.log && echo "$time: Updated Mithril Client from $clientOldShort --> $clientNewShort" >> updates.log && echo -e "Updated Mithril Client from {YELLOW}$clientOldShort{PURPLE} --> {GREEN}$clientNewShort{NC}"
fi
if test "$signerOldShort" != "$signerNewShort"
then echo "" >> updates.log && echo "$time: Updated Mithril Signer from $signerOldShort --> $signerNewShort" >> updates.log && echo -e "Updated Mithril Signer from {YELLOW}$signerOldShort{PURPLE} --> {GREEN}$signerNewShort{NC}"
fi
if test "$aggregatorOldShort" != "$aggregatorNewShort"
then echo "" >> updates.log && echo "$time: Updated Mithril Aggregator from $aggregatorOldShort --> $aggregatorNewShort" >> updates.log && echo -e "Updated Mithril Aggregator from {YELLOW}$aggregatorOldShort{PURPLE} --> {GREEN}$aggregatorNewShort{NC}"
fi
if test "$relayOldShort" != "$relayNewShort"
then echo "" >> updates.log && echo "$time: Updated Mithril Relay from $relayOldShort --> $relayNewShort" >> updates.log && echo -e "Updated Mithril Relay from {YELLOW}$relayOldShort{PURPLE} --> {GREEN}$relayNewShort{NC}"
fi
# Find and delete .tar.gz download file
tarFile=$(find . -maxdepth 1 -name "*.tar.gz" -print | cut -c 3-)
rm $tarFile
echo -e "${GREEN}Update(s) complete${NC}"