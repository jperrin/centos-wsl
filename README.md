# CentOS Stream image for WSL

## Importing the image

* Download the tarball from this repository.
* Create a directory where you want to keep your custom wsl distros if you don't already have one. I like to use ```C:\distros``` but use what you want.
* Import the tar file as a wsl image using powershell ```wsl.exe --import centos-stream C:\distros\centos-stream centos-stream-wsl.tar.gz```

## Configure the image

Now that the image is imported, there's some basic config work to make it useful. Lets do that next:

* Launch the image so we can set up our user and sudo access. To do this, run the command ```wsl -d centos-stream```
* Add your user, and make sure you add them to the wheel group so you can sudo ```useradd -G wheel yourusername```
* Since sudo wants a password by default, set one. ```passwd yourusername```
* Verify your UID. We'll need this later to set the default user```id -u yourusername```
* exit this wsl instance, so we can test sudo. Once you're out, launch another session as your user: ```wsl -d centos-stream -u yourusername```
* test sudo by running ```sudo -i```. If you get a root prompt after typing your password then you're all set.

Exit the instance so you're back in powershell. From here, we're going to run a one-liner to configure the default user.

 ```Get-ItemProperty Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Lxss\*\ DistributionName | Where-Object -Property DistributionName -eq centos-stream  | Set-ItemProperty -Name DefaultUid -Value 1000```

 If your UID was something different, then be sure to change the 1000 to whatever your uid is.

## Run your new image

At this point you're all set, and you can begin using and customizing your new CentOS Stream WSL instance. If you're using Windows Terminal, it'll be added to the menu automatically. Otherwise, you will need to launch wsl as we did before, using ```wsl -d centos-stream```.

## Build your own

If you want to build your own variant of this, feel free to take the kickstart included in the repository and make tweak it as desired. This is built on CentOS-Stream, using the ```livemedia-creator``` command from the lorax package

The command I used is ```livemedia-creator --make-tar --no-virt --project "CentOS Stream" --releasever "8" --ks=centos-stream-wsl.ks --image-name=centos-stream-wsl.tar.xz```

Happy building.
