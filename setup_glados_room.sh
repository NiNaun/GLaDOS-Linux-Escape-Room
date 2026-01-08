#!/bin/bash

# === GLaDOS ESCAPE ROOM SETUP-SKRIPT (Version 5.9) ===
BENUTZER="testperson"
PASSWORT="aperture" 
ENCRYPT_PASS="pills"

if [ "$(id -u)" -ne 0 ]; then
  echo "FEHLER: Root-Rechte erforderlich."
  exit 1
fi

# --- SCHRITT 0: Abhängigkeiten ---
if ! command -v curl &> /dev/null; then
    apt-get update > /dev/null && apt-get install -y curl || dnf install -y curl || pacman -S --noconfirm curl
fi

# --- SCHRITT 1: Benutzer-Setup ---
id "$BENUTZER" &>/dev/null || useradd -m -s /bin/bash "$BENUTZER"
echo "$BENUTZER:$PASSWORT" | chpasswd
USER_HOME="/home/$BENUTZER"
cp /etc/skel/.bashrc "$USER_HOME/.bashrc" 2>/dev/null || echo "# .bashrc" > "$USER_HOME/.bashrc"

# --- SCHRITT 2: Dateien ---
cat << EOF > "$USER_HOME/lies_mich.txt"
Willkommen.
Aufgabe 1: Notiz in /var/lib/misc (Nutze 'ls -a').
Aufgaben 2-4 folgen. Hilfe: 'hilfsbuch.txt', Lösung: 'loesungsbuch.txt'.
GLaDOS
EOF

# --- SCHRITT 2.5: Cheat-Code (Versteckt via Alias) ---
rm -f "$USER_HOME/wwssadadba"
cat << EOF > "$USER_HOME/.wwssadadba"
#!/bin/bash
echo "### CHEAT-CODE ERKANNT ###"
openssl enc -aes-256-cbc -d -in /opt/aperture_storage/notfallplan.enc -pass pass:$ENCRYPT_PASS
EOF
chmod +x "$USER_HOME/.wwssadadba"

# Alias in .bashrc einfügen, damit 'wwssadadba' die versteckte Datei aufruft
echo "alias wwssadadba='/home/$BENUTZER/.wwssadadba'" >> "$USER_HOME/.bashrc"

# --- SCHRITT 3: Aufgabe 1 (Find) ---
mkdir -p /var/lib/misc
cat << EOF > "/var/lib/misc/.notiz_des_admins"
Signal in /var/log/aperture_system.log (Signal-ID: "KERNEL_PANIC_SIMULATION").
Ziel: /opt/aperture_storage/notfallplan.enc
EOF
chmod 644 "/var/lib/misc/.notiz_des_admins"

# --- SCHRITT 4: Aufgabe 2 (Grep) ---
LOG_DATEI="/var/log/aperture_system.log"
echo "Systemstart..." > "$LOG_DATEI"
for i in {1..100}; do echo "[INFO] Service \$((RANDOM)) started." >> "$LOG_DATEI"; done
echo "[ERROR] KERNEL_PANIC_SIMULATION: Source /usr/local/bin/core_dump_analyzer" >> "$LOG_DATEI"
chmod 644 "$LOG_DATEI"

# --- SCHRITT 5: Aufgabe 3 (Strings) ---
BIN_DATEI="/usr/local/bin/core_dump_analyzer"
echo "#!/bin/bash" > "$BIN_DATEI"
head -c 512 /dev/urandom >> "$BIN_DATEI"
echo "FLAGGE: Morpheus bot Pillen (pills) an." >> "$BIN_DATEI"
echo "DEBUG: wwssadadba" >> "$BIN_DATEI"
chmod 755 "$BIN_DATEI"

# --- SCHRITT 6: Aufgabe 4 (OpenSSL) ---
echo "Der Kuchen ist KEINE Lüge. -GLaDOS" > /tmp/kuchen.txt
mkdir -p /opt/aperture_storage
openssl enc -aes-256-cbc -salt -in /tmp/kuchen.txt -out /opt/aperture_storage/notfallplan.enc -pass pass:$ENCRYPT_PASS
rm /tmp/kuchen.txt

# --- SCHRITT 7: Dokumentation ---
cat << EOF > "$USER_HOME/hilfsbuch.txt"
Hilfe:
1. /var/lib/misc/.notiz_des_admins finden.
2. Log filtern mit grep.
3. Strings aus Binärdatei lesen.
4. openssl enc -aes-256-cbc -d ...
EOF

# Besitzrechte
chown -R "$BENUTZER":"$BENUTZER" "$USER_HOME"
chown -R "$BENUTZER":"$BENUTZER" /opt/aperture_storage

clear
echo "Setup abgeschlossen. Login: su - $BENUTZER"
