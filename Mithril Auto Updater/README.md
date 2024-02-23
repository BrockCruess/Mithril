**DOES NOT WORK FOR WINDOWS VERSION**

*This script will keep your Mithril binaries up-to-date with the latest pre-compiled binary releases.*

<br>

This script is programmable, so you can edit this part at the beginning of the script to set which binaries you'd like to download and keep updated:

> client=yes<br>
> signer=yes<br>
> aggregator=yes<br>
> relay=yes

To edit, run:
```
nano mithril-auto-updater.sh
```

<br>

## Download:

To download the Auto Updater script, run this command in the directory where your Mithril binary files are stored:

```
curl https://raw.githubusercontent.com/BrockCruess/Mithril/main/Mithril%20Auto%20Updater/mithril-auto-updater.sh > mithril-auto-updater.sh && chmod +x mithril-auto-updater.sh
```
<br>

For a manual approach, run this script any time a new Mithril version is announced:

```
./mithril-auto-updater.sh
```
<br>

All updates will be logged to a file called `updates.log` with a timestamp.

<br>

## Schedule:

Set up a cronjob to update every 2 days at midnight by running this command with **your** script file path:

```
# Put your node directory after "mithrilDirectory=", with no slash at the end:
mithrilDirectory=/directory/where/your/script/is/with/no/slash/at/the/end

cd $mithrilDirectory
(crontab -l ; echo "0 0 1-31/2 * * /bin/bash $mithrilDirectory/mithril-auto-updater.sh")| crontab -
```

<br>

If you run your node as **root** user, use this instead with **your** script file path:

```
# Put your node directory after "mithrilDirectory=", with no slash at the end:
mithrilDirectory=/directory/where/your/script/is/with/no/slash/at/the/end

cd $mithrilDirectory
(sudo crontab -l ; echo "0 0 1-31/2 * * /bin/bash $mithrilDirectory/mithril-auto-updater.sh")| sudo crontab -
```

<br>

## Update:

If a new version of this script is available, run this command in the directory where your current Auto Updater script is stored:

```
curl https://raw.githubusercontent.com/BrockCruess/Mithril/main/Mithril%20Auto%20Updater/mithril-auto-updater.sh > mithril-auto-updater.sh && chmod +x mithril-auto-updater.sh
```
