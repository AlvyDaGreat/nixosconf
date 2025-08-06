git add -A && git commit -m "balls"
git push origin main
ssh -t bananapeelnix "cd /etc/nixos/ && sudo git pull https://github.com/AlvyDaGreat/nixosconf.git"
