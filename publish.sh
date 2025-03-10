hugo build --gc --cleanDestinationDir
echo uploading…
rsync --info=progress2 -r public/ hetzner1_notmux:/var/www/nuggits --rsync-path="sudo rsync"
