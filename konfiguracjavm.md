- Uruchom VirtualBox
- Kliknij "New"
- Name: inception-vm
- Username: rgrochow
- Password: Radek291183!
- Domain name: rgrochow.42.fr
- Pamięć RAM: 8192 MB (8GB)
- CPU: rdzenie 4
- Disk size: 50GB
- su -
- usermod -aG sudo rgrochow
- exit
- exit
- restart VM
- echo "$(whoami) ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/nopasswd
- sudo apt update && sudo apt upgrade -y
# Na hoscie
- cd /home/rgrochow/inception
- python3 -m http.server 8000
- ip a | grep inet # Znajdź adres np. 192.168.1.100
# W VM
# Pobierz cały folder
wget -r -np -nH --cut-dirs=0 http://192.168.1.100:8000/

# Lub pojedynczy plik
wget http://192.168.1.100:8000/Makefile

- sudo apt install -y \
    ca-certificates \
    curl \
    gnupg \
    git \
    make \
    vim

- sudo install -m 0755 -d /etc/apt/keyrings
- curl -fsSL https://download.docker.com/linux/debian/gpg | \
    sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
- sudo chmod a+r /etc/apt/keyrings/docker.gpg
- echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
- sudo apt update
- sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
- sudo usermod -aG docker $USER
- sudo nano /etc/hosts
- Dodaj: 127.0.0.1   rgrochow.42.fr
- cd ~/inc
- make
- docker ps
- curl -k https://rgrochow.42.fr