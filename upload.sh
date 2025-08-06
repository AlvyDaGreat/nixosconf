git add -A && git commit -m "balls"
git push origin main
ssh bananapeelnix sudo "cd /etc/nixos/; git pull https://github.com/AlvyDaGreat/nixosconf.git"
