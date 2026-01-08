#!/bin/bash

# === GLaDOS ESCAPE ROOM SETUP-SKRIPT (Version 5.4 - Absolute Stability) ===
#
# WICHTIG: Ausführung als 'root' zwingend erforderlich.
#
# === KONFIGURATION ===
BENUTZER="testperson"
PASSWORT="aperture" 
ENCRYPT_PASS="pills"
# =====================

if [ "$(id -u)" -ne 0 ]; then
  echo "FEHLER: Root-Rechte erforderlich."
  exit 1
fi

echo "Initialisiere GLaDOS Escape Room..."

# --- SCHRITT 0: Abhängigkeiten ---
if ! command -v curl &> /dev/null; then
    if command -v apt-get &> /dev/null; then
        apt-get update > /dev/null && apt-get install -y curl
    elif command -v dnf &> /dev/null; then
        dnf install -y curl
    elif command -v pacman &> /dev/null; then
        pacman -S --noconfirm curl
    fi
fi

# --- SCHRITT 1: Benutzer-Setup ---
if ! id "$BENUTZER" &>/dev/null; then
    useradd -m -s /bin/bash "$BENUTZER"
fi
echo "$BENUTZER:$PASSWORT" | chpasswd
USER_HOME="/home/$BENUTZER"

# .bashrc Reset
if [ -f "/etc/skel/.bashrc" ]; then
    cp /etc/skel/.bashrc "$USER_HOME/.bashrc"
else
    echo "# Standard .bashrc" > "$USER_HOME/.bashrc"
fi

# --- SCHRITT 2: Willkommensnachricht ---
cat << EOF > "$USER_HOME/lies_mich.txt"
Willkommen. Wieder einmal ein kleines Experiment — nur du, dein Verstand und ein freundlich gestimmtes Betriebssystem, das ganz zufällig ein paar Geheimnisse für dich versteckt hat.

Deine Aufgabe ist eine Kette. Ein Glied führt zum nächsten. 

Aufgabe 1: Finde das erste Glied. Es ist nicht in deinem Home-Verzeichnis. Es wartet dort, wo neugierige Finger normalerweise nicht graben. 

Hinweis: Der 'Admin' hat eine 'Notiz' im Verzeichnis /var/lib/misc versteckt. Nutze 'ls -a'.

Aufgabe 2-4: Der erste Hinweis führt tiefer. 

Erledige die gesamte Kette für das Ziel: Kuchen. 

GLaDOS
EOF

# --- SCHRITT 2.5: Cheat-Code (Hidden) ---
# Entferne alte sichtbare Datei, falls vorhanden
rm -f "$USER_HOME/wwssadadba"

# Erstelle versteckte Datei
cat << EOF > "$USER_HOME/.wwssadadba"
#!/bin/bash
echo "##############################################"
echo "### CHEAT-CODE ERKANNT: 'wwssadadba'       ###"
echo "### NOTFALL-ENTSCHLÜSSELUNG...             ###"
echo "##############################################"
echo ""
sleep 1
openssl enc -aes-256-cbc -d -in /opt/aperture_storage/notfallplan.enc -pass pass:$ENCRYPT_PASS
EOF

chmod +x "$USER_HOME/.wwssadadba"
echo "export PATH=\$PATH:\$HOME" >> "$USER_HOME/.bashrc"

chown "$BENUTZER":"$BENUTZER" "$USER_HOME/.bashrc"
chown "$BENUTZER":"$BENUTZER" "$USER_HOME/lies_mich.txt"
chown "$BENUTZER":"$BENUTZER" "$USER_HOME/.wwssadadba"

# --- SCHRITT 3: Aufgabe 1 (Find) ---
mkdir -p /var/lib/misc
cat << EOF > "/var/lib/misc/.notiz_des_admins"
Test-Protokoll 4815. Status: Kompromittiert.

Signal in /var/log/aperture_system.log entdeckt. Nutze 'grep'.
Signal-ID: "KERNEL_PANIC_SIMULATION"

Ziel-Archiv: /opt/aperture_storage/notfallplan.enc

---
Notfall-Skript: /usr/local/sbin/reset_security.sh
EOF
chmod 644 "/var/lib/misc/.notiz_des_admins"

# --- SCHRITT 3.5: Rickroll ---
mkdir -p /usr/local/sbin
cat << EOF > "/usr/local/sbin/reset_security.sh"
#!/bin/bash
echo "Initialisiere System-Reset..."
sleep 1
curl -L nvr.ooo
EOF
chmod +x /usr/local/sbin/reset_security.sh

# --- SCHRITT 4: Aufgabe 2 (Grep) ---
LOG_DATEI="/var/log/aperture_system.log"
echo "Systemstart..." > "$LOG_DATEI"
for i in {1..200}; do echo "[INFO] Dienst \$(head /dev/urandom | tr -dc A-Z | head -c 8) gestartet." >> "$LOG_DATEI"; done
echo "[ERROR] KERNEL_PANIC_SIMULATION: Signal-Quelle: /usr/local/bin/core_dump_analyzer" >> "$LOG_DATEI"
for i in {1..200}; do echo "[WARN] Speicher-Integritätsprüfung... \$((RANDOM % 100))% OK" >> "$LOG_DATEI"; done
chmod 644 "$LOG_DATEI"

# --- SCHRITT 5: Aufgabe 3 (Strings) ---
BIN_DATEI="/usr/local/bin/core_dump_analyzer"
cat << EOF > "$BIN_DATEI"
#!/bin/bash
echo "ERROR: Core-Dump-Analyse fehlgeschlagen."
EOF
head -c 1024 /dev/urandom >> "$BIN_DATEI"
echo "FLAGGE: Morpheus bot sie im Plural an. Nutzung von 'openssl' erforderlich." >> "$BIN_DATEI"
echo "DEBUG_INPUT: wwssadadba" >> "$BIN_DATEI"
head -c 1024 /dev/urandom >> "$BIN_DATEI"
chmod 755 "$BIN_DATEI"

# --- SCHRITT 6: Aufgabe 4 (OpenSSL) ---
KUCHEN_INHALT="Der Kuchen ist KEINE Lüge.
 Gut gemacht.
 -GLaDOS"
echo "$KUCHEN_INHALT" > /tmp/kuchen.txt
mkdir -p /opt/aperture_storage
openssl enc -aes-256-cbc -salt -in /tmp/kuchen.txt -out /opt/aperture_storage/notfallplan.enc -pass pass:$ENCRYPT_PASS
rm /tmp/kuchen.txt
chown -R "$BENUTZER":"$BENUTZER" /opt/aperture_storage
chmod 644 /opt/aperture_storage/notfallplan.enc

# --- SCHRITT 7: Dokumentation ---
cat << 'EOF' > "./SPIELER-HANDBUCH.md"
🧪 Aperture Science Test-Handbuch
Login: su - testperson
Passwort: aperture
Aufgaben: Finden, Filtern, Analysieren, Entschlüsseln.
EOF

clear
echo "-----------------------------------------------------"
echo "✅ SETUP ABGESCHLOSSEN"
echo "Benutzer: $BENUTZER | Passwort: $PASSWORT"
echo "-----------------------------------------------------"
