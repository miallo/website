rm -rf public
hugo build
rsync -r public/ hetzner1_notmux:/var/www/nuggits --rsync-path="sudo rsync"
