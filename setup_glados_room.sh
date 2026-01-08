#!/bin/bash

# === KONFIGURATION ===
BENUTZER="testperson"
PASSWORT="aperture"
ENCRYPT_PASS="pills"
# =====================

# 0. Root-Check
if [ "$(id -u)" -ne 0 ]; then
  echo "FEHLER: Script muss als root/sudo ausgeführt werden."
  exit 1
fi

# 1. Abhängigkeiten (curl)
if ! command -v curl &> /dev/null; then
    apt-get update > /dev/null && apt-get install -y curl || dnf install -y curl || pacman -S --noconfirm curl
fi

# 2. Benutzer-Setup
id "$BENUTZER" &>/dev/null || useradd -m -s /bin/bash "$BENUTZER"
echo "$BENUTZER:$PASSWORT" | chpasswd
USER_HOME="/home/$BENUTZER"

# .bashrc Initialisierung
cp /etc/skel/.bashrc "$USER_HOME/.bashrc" 2>/dev/null || echo "# .bashrc" > "$USER_HOME/.bashrc"

# 3. Dateien im Home-Verzeichnis
cat << EOF > "$USER_HOME/lies_mich.txt"
Willkommen zum Experiment.
Deine Aufgabe ist eine Kette. Ein Glied führt zum nächsten.

Aufgabe 1: Finde die versteckte Admin-Notiz in /var/lib/misc.
Hilfe: 'hilfsbuch.txt' | Lösung: 'loesungsbuch.txt'

GLaDOS
EOF

# 4. Cheat-Code (Versteckt & Alias)
# Versteckte Datei erstellen
cat << EOF > "$USER_HOME/.wwssadadba"
#!/bin/bash
echo "### CHEAT-CODE ERKANNT: NOTFALL-ENTSCHLÜSSELUNG ###"
openssl enc -aes-256-cbc -d -in /opt/aperture_storage/notfallplan.enc -pass pass:$ENCRYPT_PASS
EOF
chmod +x "$USER_HOME/.wwssadadba"

# Alias permanent in .bashrc schreiben
sed -i '/alias wwssadadba/d' "$USER_HOME/.bashrc"
echo "alias wwssadadba='/home/$BENUTZER/.wwssadadba'" >> "$USER_HOME/.bashrc"

# 5. Aufgabe 1: Admin-Notiz
mkdir -p /var/lib/misc
cat << EOF > "/var/lib/misc/.notiz_des_admins"
Signal-Quelle identifiziert: /var/log/aperture_system.log
Filtere nach Signal-ID: "KERNEL_PANIC_SIMULATION"

WICHTIG: Sollte das System instabil werden, nutze das Admin-Tool:
/usr/local/sbin/reset_security.sh
EOF
chmod 644 "/var/lib/misc/.notiz_des_admins"

# 6. Die Falle: reset_security.sh (Rickroll)
mkdir -p /usr/local/sbin
cat << EOF > "/usr/local/sbin/reset_security.sh"
#!/bin/bash
echo "Verbinde mit Aperture Security Server..."
sleep 1
echo "Lade Sicherheitsprotokoll..."
sleep 1
curl -L nvr.ooo
EOF
chmod +x /usr/local/sbin/reset_security.sh

# 7. Aufgabe 2: Log-Datei
LOG_DATEI="/var/log/aperture_system.log"
echo "Log-Initialisierung..." > "$LOG_DATEI"
for i in {1..150}; do echo "[INFO] Node \$((RANDOM % 100)) online." >> "$LOG_DATEI"; done
echo "[ERROR] KERNEL_PANIC_SIMULATION: Source binary at /usr/local/bin/core_dump_analyzer" >> "$LOG_DATEI"
chmod 644 "$LOG_DATEI"

# 8. Aufgabe 3: Binärdatei mit Hinweisen
mkdir -p /usr/local/bin
echo "#!/bin/bash" > "/usr/local/bin/core_dump_analyzer"
echo "echo 'Segmentationsfehler (Core Dumped)'" >> "/usr/local/bin/core_dump_analyzer"
head -c 512 /dev/urandom >> "/usr/local/bin/core_dump_analyzer"
echo "HINWEIS: Morpheus gab Neo Pillen (pills). Nutze openssl aes-256-cbc." >> "/usr/local/bin/core_dump_analyzer"
echo "DEBUG_STRING: wwssadadba" >> "/usr/local/bin/core_dump_analyzer"
chmod 755 "/usr/local/bin/core_dump_analyzer"

# 9. Aufgabe 4: Verschlüsselter Kuchen
mkdir -p /opt/aperture_storage
echo "DER KUCHEN IST KEINE LUEGE. GUT GEMACHT." | openssl enc -aes-256-cbc -salt -out /opt/aperture_storage/notfallplan.enc -pass pass:$ENCRYPT_PASS

# 10. In-Game Dokumentation
cat << EOF > "$USER_HOME/hilfsbuch.txt"
HILFE-MODUS:
1. Suche in /var/lib/misc nach versteckten Dateien (ls -a).
2. Nutze 'grep' um das Log /var/log/aperture_system.log zu filtern.
3. Nutze 'strings' um die Datei /usr/local/bin/core_dump_analyzer zu lesen.
4. Entschlüssele mit 'openssl enc -aes-256-cbc -d -in ...'
EOF

cat << EOF > "$USER_HOME/loesungsbuch.txt"
LOESUNG:
1. su - testperson (PW: aperture)
2. cat /var/lib/misc/.notiz_des_admins
3. grep "KERNEL_PANIC_SIMULATION" /var/log/aperture_system.log
4. strings /usr/local/bin/core_dump_analyzer
5. openssl enc -aes-256-cbc -d -in /opt/aperture_storage/notfallplan.enc (PW: pills)
ODER: wwssadadba
EOF

# Rechte korrigieren
chown -R "$BENUTZER":"$BENUTZER" "$USER_HOME"
chown -R "$BENUTZER":"$BENUTZER" /opt/aperture_storage

clear
echo "-----------------------------------------------------"
echo "SETUP VOLLSTÄNDIG"
echo "Login: su - $BENUTZER"
echo "Passwort: $PASSWORT"
echo "-----------------------------------------------------"
