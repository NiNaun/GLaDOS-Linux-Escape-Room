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

echo "Starte GLaDOS Setup v6.1..."

# 1. Abhängigkeiten (curl für Rickroll)
if ! command -v curl &> /dev/null; then
    apt-get update > /dev/null && apt-get install -y curl || dnf install -y curl || pacman -S --noconfirm curl
fi

# 2. Benutzer-Setup
id "$BENUTZER" &>/dev/null || useradd -m -s /bin/bash "$BENUTZER"
echo "$BENUTZER:$PASSWORT" | chpasswd
USER_HOME="/home/$BENUTZER"

# .bashrc sauber zurücksetzen
cp /etc/skel/.bashrc "$USER_HOME/.bashrc" 2>/dev/null || echo "# .bashrc" > "$USER_HOME/.bashrc"

# 3. Willkommensnachricht
cat << EOF > "$USER_HOME/lies_mich.txt"
Willkommen zum Experiment.
Deine Aufgabe ist eine Kette. Ein Glied führt zum nächsten.

Aufgabe 1: Finde die versteckte Admin-Notiz in /var/lib/misc (Nutze 'ls -a').

Hilfe findest du in 'hilfsbuch.txt'.
Die Lösungen liegen in 'loesungsbuch.txt'.

GLaDOS
EOF

# 4. Cheat-Code (Fix: Versteckt & per Alias aufrufbar)
# Alte sichtbare Datei löschen, falls vorhanden
rm -f "$USER_HOME/wwssadadba"

# Versteckte Skript-Datei erstellen
cat << EOF > "$USER_HOME/.wwssadadba"
#!/bin/bash
echo "##############################################"
echo "### CHEAT-CODE ERKANNT: NOTFALL-ENTSCHLÜSSELUNG ###"
echo "##############################################"
echo ""
sleep 1
openssl enc -aes-256-cbc -d -in /opt/aperture_storage/notfallplan.enc -pass pass:$ENCRYPT_PASS
EOF
chmod +x "$USER_HOME/.wwssadadba"

# Alias in .bashrc einfügen (stellt sicher, dass wwssadadba die versteckte Datei startet)
sed -i '/alias wwssadadba/d' "$USER_HOME/.bashrc"
echo "alias wwssadadba='/home/$BENUTZER/.wwssadadba'" >> "$USER_HOME/.bashrc"

# 5. Aufgabe 1: Admin-Notiz
mkdir -p /var/lib/misc
cat << EOF > "/var/lib/misc/.notiz_des_admins"
Test-Protokoll 4815. Status: Kompromittiert.

Das Log-File wurde manipuliert: /var/log/aperture_system.log
Suche nach der Signal-ID: "KERNEL_PANIC_SIMULATION"

Sollte der Zugriff verweigert werden, nutzen Sie das Notfall-Tool:
/usr/local/sbin/reset_security.sh
EOF
chmod 644 "/var/lib/misc/.notiz_des_admins"

# 6. Die Falle (Rickroll)
mkdir -p /usr/local/sbin
cat << EOF > "/usr/local/sbin/reset_security.sh"
#!/bin/bash
echo "Initialisiere Sicherheits-Reset..."
sleep 1
echo "Lade externe Protokolle..."
sleep 1
curl -L nvr.ooo
EOF
chmod +x /usr/local/sbin/reset_security.sh

# 7. Aufgabe 2: Log-Datei (Fix: Rechtschreibung)
LOG_DATEI="/var/log/aperture_system.log"
echo "Log Start..." > "$LOG_DATEI"
for i in {1..120}; do echo "[INFO] Node \$((RANDOM % 100)) aktiv." >> "$LOG_DATEI"; done
echo "[ERROR] KERNEL_PANIC_SIMULATION: Source isoliert unter /usr/local/bin/core_dump_analyzer" >> "$LOG_DATEI"
for i in {1..50}; do echo "[WARN] Speicher-Integritätsprüfung läuft..." >> "$LOG_DATEI"; done
chmod 644 "$LOG_DATEI"

# 8. Aufgabe 3: Binär-Simulation
mkdir -p /usr/local/bin
echo "#!/bin/bash" > "/usr/local/bin/core_dump_analyzer"
echo "echo 'Fehler: Binär-Datenstrom unterbrochen.'" >> "/usr/local/bin/core_dump_analyzer"
head -c 512 /dev/urandom >> "/usr/local/bin/core_dump_analyzer"
echo "HINWEIS: Morpheus bot Pillen (pills) an. Nutze openssl aes-256-cbc." >> "/usr/local/bin/core_dump_analyzer"
echo "DEBUG_KEY: wwssadadba" >> "/usr/local/bin/core_dump_analyzer"
chmod 755 "/usr/local/bin/core_dump_analyzer"

# 9. Aufgabe 4: Der Kuchen (Verschlüsselt)
mkdir -p /opt/aperture_storage
echo "DER KUCHEN IST KEINE LUEGE. GUT GEMACHT." | openssl enc -aes-256-cbc -salt -out /opt/aperture_storage/notfallplan.enc -pass pass:$ENCRYPT_PASS

# 10. Dokumentation im Home-Verzeichnis
cat << EOF > "$USER_HOME/hilfsbuch.txt"
HILFE-DATEI:
1. Aufgabe: Suchen Sie in /var/lib/misc nach versteckten Dateien (ls -a).
2. Aufgabe: Filtern Sie das Log /var/log/aperture_system.log mit 'grep'.
3. Aufgabe: Analysieren Sie /usr/local/bin/core_dump_analyzer mit 'strings'.
4. Aufgabe: Entschlüsseln Sie die Datei in /opt/aperture_storage/ mit 'openssl'.
EOF

cat << EOF > "$USER_HOME/loesungsbuch.txt"
LÖSUNGSWEG:
1. su - testperson (PW: aperture)
2. cat /var/lib/misc/.notiz_des_admins
3. grep "KERNEL_PANIC_SIMULATION" /var/log/aperture_system.log
4. strings /usr/local/bin/core_dump_analyzer
5. openssl enc -aes-256-cbc -d -in /opt/aperture_storage/notfallplan.enc (PW: pills)
Oder nutzen Sie den Cheat: wwssadadba
EOF

# Besitzrechte finalisieren
chown -R "$BENUTZER":"$BENUTZER" "$USER_HOME"
chown -R "$BENUTZER":"$BENUTZER" /opt/aperture_storage

clear
echo "-----------------------------------------------------"
echo "✅ GLaDOS SETUP ERFOLGREICH"
echo ""
echo "Spieler-Login: su - $BENUTZER"
echo "Passwort: $PASSWORT"
echo ""
echo "Viel Erfolg beim Experiment!"
echo "-----------------------------------------------------"
