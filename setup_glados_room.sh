#!/bin/bash

# === GLaDOS ESCAPE ROOM SETUP-SKRIPT (Version 6.3) ===
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

# 2. Benutzer
id "$BENUTZER" &>/dev/null || useradd -m -s /bin/bash "$BENUTZER"
echo "$BENUTZER:$PASSWORT" | chpasswd
USER_HOME="/home/$BENUTZER"
cp /etc/skel/.bashrc "$USER_HOME/.bashrc" 2>/dev/null || echo "# .bashrc" > "$USER_HOME/.bashrc"

# 3. Start-Datei
cat << EOF > "$USER_HOME/lies_mich.txt"
Willkommen zum Experiment.
Aufgabe 1: Notiz in /var/lib/misc (ls -a).
Hilfe: 'hilfsbuch.txt' | Lösung: 'loesungsbuch.txt'
EOF

# 4. Cheat-Mechanik (Fix: Nutzt nun PBKDF2)
rm -f "$USER_HOME/wwssadadba"
cat << EOF > "$USER_HOME/.wwssadadba"
#!/bin/bash
echo "### CHEAT-CODE ERKANNT: NOTFALL-ENTSCHLÜSSELUNG ###"
openssl enc -aes-256-cbc -d -pbkdf2 -in /opt/aperture_storage/notfallplan.enc -pass pass:$ENCRYPT_PASS
EOF
chmod +x "$USER_HOME/.wwssadadba"
sed -i '/alias wwssadadba/d' "$USER_HOME/.bashrc"
echo "alias wwssadadba='/home/$BENUTZER/.wwssadadba'" >> "$USER_HOME/.bashrc"

# 5. Ebene 1
mkdir -p /var/lib/misc
cat << EOF > "/var/lib/misc/.notiz_des_admins"
Log: /var/log/aperture_system.log | ID: "KERNEL_PANIC_SIMULATION"
Falle: /usr/local/sbin/reset_security.sh
EOF
chmod 644 "/var/lib/misc/.notiz_des_admins"

# 6. Falle
mkdir -p /usr/local/sbin
cat << EOF > "/usr/local/sbin/reset_security.sh"
#!/bin/bash
curl -L nvr.ooo
EOF
chmod +x /usr/local/sbin/reset_security.sh

# 7. Ebene 2
LOG_DATEI="/var/log/aperture_system.log"
echo "Log Start..." > "$LOG_DATEI"
echo "[ERROR] KERNEL_PANIC_SIMULATION: Source /usr/local/bin/core_dump_analyzer" >> "$LOG_DATEI"
chmod 644 "$LOG_DATEI"

# 8. Ebene 3 (Verständliche Hinweise)
mkdir -p /usr/local/bin
echo "#!/bin/bash" > "/usr/local/bin/core_dump_analyzer"
echo "head -c 512 /dev/urandom" >> "/usr/local/bin/core_dump_analyzer"
echo "HINWEIS: Passwort ist 'pills'. Nutze 'openssl enc -aes-256-cbc -d -pbkdf2'." >> "/usr/local/bin/core_dump_analyzer"
echo "CHEAT: wwssadadba" >> "/usr/local/bin/core_dump_analyzer"
chmod 755 "/usr/local/bin/core_dump_analyzer"

# 9. Ebene 4 (Verschlüsselung mit PBKDF2)
mkdir -p /opt/aperture_storage
echo "DER KUCHEN IST KEINE LUEGE." | openssl enc -aes-256-cbc -salt -pbkdf2 -out /opt/aperture_storage/notfallplan.enc -pass pass:$ENCRYPT_PASS

# 10. Dokumentation
cat << EOF > "$USER_HOME/hilfsbuch.txt"
Tipp: Nutze 'openssl enc -aes-256-cbc -d -pbkdf2 -in [DATEI]'. Passwort: pills
EOF

cat << EOF > "$USER_HOME/loesungsbuch.txt"
Befehl: openssl enc -aes-256-cbc -d -pbkdf2 -in /opt/aperture_storage/notfallplan.enc
Passwort: pills
EOF

chown -R "$BENUTZER":"$BENUTZER" "$USER_HOME"
chown -R "$BENUTZER":"$BENUTZER" /opt/aperture_storage

clear
echo "SETUP V6.3 ABGESCHLOSSEN (PBKDF2 FIX)"
