#!/bin/bash

# === GLaDOS ESCAPE ROOM SETUP-SKRIPT (Version 6.2) ===
# Ziel: Cognitive Rebuilding via Linux Terminal.
# Systemvoraussetzung: Root-Zugriff.
# ===================================================

BENUTZER="testperson"
PASSWORT="aperture"
ENCRYPT_PASS="pills"

if [ "$(id -u)" -ne 0 ]; then
  echo "FEHLER: Root-Rechte erforderlich."
  exit 1
fi

# 1. Abhängigkeiten
if ! command -v curl &> /dev/null; then
    apt-get update > /dev/null && apt-get install -y curl || dnf install -y curl || pacman -S --noconfirm curl
fi

# 2. Benutzer-Integrität
id "$BENUTZER" &>/dev/null || useradd -m -s /bin/bash "$BENUTZER"
echo "$BENUTZER:$PASSWORT" | chpasswd
USER_HOME="/home/$BENUTZER"

cp /etc/skel/.bashrc "$USER_HOME/.bashrc" 2>/dev/null || echo "# .bashrc" > "$USER_HOME/.bashrc"

# 3. Primäre Instruktion
cat << EOF > "$USER_HOME/lies_mich.txt"
Willkommen zum Experiment.
Deine Aufgabe ist eine Kette. Ein Glied führt zum nächsten.

Aufgabe 1: Finde die versteckte Admin-Notiz in /var/lib/misc (Nutze 'ls -a').

Hilfe: 'hilfsbuch.txt'
Lösung: 'loesungsbuch.txt'

GLaDOS
EOF

# 4. Cheat-Mechanik (Versteckt & Alias)
rm -f "$USER_HOME/wwssadadba"
cat << EOF > "$USER_HOME/.wwssadadba"
#!/bin/bash
echo "### CHEAT-CODE ERKANNT: NOTFALL-ENTSCHLÜSSELUNG ###"
openssl enc -aes-256-cbc -d -in /opt/aperture_storage/notfallplan.enc -pass pass:$ENCRYPT_PASS
EOF
chmod +x "$USER_HOME/.wwssadadba"

sed -i '/alias wwssadadba/d' "$USER_HOME/.bashrc"
echo "alias wwssadadba='/home/$BENUTZER/.wwssadadba'" >> "$USER_HOME/.bashrc"

# 5. Ebene 1: Verzeichnis-Manipulation
mkdir -p /var/lib/misc
cat << EOF > "/var/lib/misc/.notiz_des_admins"
Test-Protokoll 4815. Status: Kompromittiert.

Log-Datei: /var/log/aperture_system.log
Signal-ID: "KERNEL_PANIC_SIMULATION"

Admin-Tool für System-Instabilität:
/usr/local/sbin/reset_security.sh
EOF
chmod 644 "/var/lib/misc/.notiz_des_admins"

# 6. Red Herring (Rickroll)
mkdir -p /usr/local/sbin
cat << EOF > "/usr/local/sbin/reset_security.sh"
#!/bin/bash
echo "Initialisiere Sicherheits-Reset..."
sleep 1
curl -L nvr.ooo
EOF
chmod +x /usr/local/sbin/reset_security.sh

# 7. Ebene 2: Log-Analyse
LOG_DATEI="/var/log/aperture_system.log"
echo "Log Start..." > "$LOG_DATEI"
for i in {1..120}; do echo "[INFO] Node \$((RANDOM % 100)) aktiv." >> "$LOG_DATEI"; done
echo "[ERROR] KERNEL_PANIC_SIMULATION: Source isoliert unter /usr/local/bin/core_dump_analyzer" >> "$LOG_DATEI"
for i in {1..50}; do echo "[WARN] Speicher-Integritätsprüfung läuft..." >> "$LOG_DATEI"; done
chmod 644 "$LOG_DATEI"

# 8. Ebene 3: Binär-Analyse (Verständliche Version)
mkdir -p /usr/local/bin
echo "#!/bin/bash" > "/usr/local/bin/core_dump_analyzer"
echo "echo 'Fehler: Binär-Datenstrom unterbrochen.'" >> "/usr/local/bin/core_dump_analyzer"
head -c 512 /dev/urandom >> "/usr/local/bin/core_dump_analyzer"
echo "PASSWORT-HINWEIS: Das Passwort ist das englische Wort für 'Pillen' (Mehrzahl). Nutze 'openssl aes-256-cbc' für das Finale." >> "/usr/local/bin/core_dump_analyzer"
echo "ABKÜRZUNG (CHEAT): Geben Sie 'wwssadadba' direkt im Terminal ein." >> "/usr/local/bin/core_dump_analyzer"
chmod 755 "/usr/local/bin/core_dump_analyzer"

# 9. Ebene 4: Kryptografie
mkdir -p /opt/aperture_storage
echo "DER KUCHEN IST KEINE LUEGE. GUT GEMACHT." | openssl enc -aes-256-cbc -salt -out /opt/aperture_storage/notfallplan.enc -pass pass:$ENCRYPT_PASS

# 10. Dokumentation
cat << EOF > "$USER_HOME/hilfsbuch.txt"
HILFE-DATEI:
1. Aufgabe: Suchen Sie in /var/lib/misc nach versteckten Dateien (ls -a).
2. Aufgabe: Filtern Sie das Log /var/log/aperture_system.log mit 'grep'.
3. Aufgabe: Analysieren Sie /usr/local/bin/core_dump_analyzer mit 'strings'.
4. Aufgabe: Entschlüsseln Sie die Datei in /opt/aperture_storage/ mit 'openssl'.
   Tipp: Das Passwort ist das englische Wort für Pillen (pills).
EOF

cat << EOF > "$USER_HOME/loesungsbuch.txt"
LÖSUNGSWEG:
1. su - testperson (PW: aperture)
2. cat /var/lib/misc/.notiz_des_admins
3. grep "KERNEL_PANIC_SIMULATION" /var/log/aperture_system.log
4. strings /usr/local/bin/core_dump_analyzer
5. openssl enc -aes-256-cbc -d -in /opt/aperture_storage/notfallplan.enc
   (Passwort-Eingabe: pills)
Oder nutzen Sie den Cheat: wwssadadba
EOF

# Rechte-Zuweisung
chown -R "$BENUTZER":"$BENUTZER" "$USER_HOME"
chown -R "$BENUTZER":"$BENUTZER" /opt/aperture_storage

clear
echo "-----------------------------------------------------"
echo "SETUP ABGESCHLOSSEN"
echo "Login: su - $BENUTZER"
echo "Passwort: $PASSWORT"
echo "-----------------------------------------------------"
