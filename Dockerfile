# Start mit einem sauberen Linux-System (Ubuntu)
FROM ubuntu:latest

# Installiere alle Werkzeuge, die dein Skript und der Spieler benötigen
# 'adduser' wird für 'useradd' und 'chpasswd' benötigt
# 'curl' ist für den Rickroll
# 'openssl' ist für das finale Rätsel
RUN apt-get update && apt-get install -y curl openssl adduser

# Kopiere dein Setup-Skript IN den Container
COPY setup_glados_room.sh /setup.sh

# Mache dein Skript ausführbar und führe es aus
RUN chmod +x /setup.sh
RUN /setup.sh

# --- Ab hier wird der Start des Spielers konfiguriert ---

# Setze den Standard-Benutzer auf 'testperson'
USER testperson

# Setze das Standard-Verzeichnis auf das Home-Verzeichnis
WORKDIR /home/testperson

# Wenn der Spieler den Container startet, starte eine "Login"-Shell (-l)
# Das ist WICHTIG, damit die .bashrc geladen wird (für den Easter-Egg-PATH)
CMD ["/bin/bash", "-l"]
