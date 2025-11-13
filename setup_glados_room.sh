#!/bin/bash

# === GLaDOS ESCAPE ROOM SETUP-SKRIPT (Version 4.9 - Konami-Lösung) ===
#
# WICHTIG: Dieses Skript muss als 'root' oder mit 'sudo' ausgeführt werden.
#
# === KONFIGURATION ===
BENUTZER="testperson"
PASSWORT="aperture" # Das Passwort für den Spieler
ENCRYPT_PASS="pills" # Das Passwort für die finale Datei
# =====================


# 0. Prüfen, ob das Skript als root läuft
if [ "$(id -u)" -ne 0 ]; then
  echo "FEHLER: Dieses Skript muss als root (oder mit sudo) ausgeführt werden."
  exit 1
fi

echo "Starte GLaDOS Escape Room Setup (Repariere .bashrc)..."


# --- SCHRITT 0: Abhängigkeiten prüfen (curl für Rickroll) ---

echo "[Schritt 0] Prüfe Abhängigkeiten (curl)..."
if ! command -v curl &> /dev/null; then
    echo "curl nicht gefunden. Versuche zu installieren..."
    if command -v apt-get &> /dev/null; then
        apt-get update > /dev/null
        apt-get install -y curl
    elif command -v dnf &> /dev/null; then
        dnf install -y curl
    elif command -v pacman &> /dev/null; then
        pacman -S --noconfirm curl
    else
        echo "WARNUNG: Konnte curl nicht automatisch installieren. Der Rickroll funktioniert möglicherweise nicht."
    fi
fi


# --- SCHRITT 1: Benutzer und Startdateien ---

echo "[Schritt 1] Erstelle Benutzer '$BENUTZER'..."
if id "$BENUTZER" &>/dev/null; then
    echo "Benutzer '$BENUTZER' existiert bereits. Überspringe Erstellung, setze aber Passwort."
else
    useradd -m -s /bin/bash "$BENUTZER"
    echo "Benutzer '$BENUTZER' erstellt."
fi

echo "$BENUTZER:$PASSWORT" | chpasswd
echo "Passwort für '$BENUTZER' wurde auf '$PASSWORT' gesetzt."

USER_HOME="/home/$BENUTZER"

# *** .bashrc-Reparatur ***
echo "[Schritt 1.5] Setze .bashrc für '$BENUTZER' zurück..."
if [ -f "/etc/skel/.bashrc" ]; then
    cp /etc/skel/.bashrc "$USER_HOME/.bashrc"
else
    echo "# Standard .bashrc" > "$USER_HOME/.bashrc"
fi


echo "[Schritt 2] Platziere GLaDOS-Willkommensnachricht..."
cat << EOF > "$USER_HOME/lies_mich.txt"
Willkommen. Wieder einmal ein kleines Experiment — nur du, dein Verstand und ein freundlich gestimmtes Betriebssystem, das ganz zufällig ein paar Geheimnisse für dich versteckt hat.

Deine Aufgabe ist eine Kette. Nicht mehr, nicht weniger. Ein Glied führt zum nächsten. Das ist gut, denn mehr als eine Sache auf einmal zu denken, wäre für dich vermutlich unfair.

Aufgabe 1: Finde das erste Glied. Es ist nicht in deinem Home-Verzeichnis, es ist nicht offensichtlich. Es wartet dort, wo neugierige Finger normalerweise nicht graben. Nein, ich werde dir nicht sagen, wo. Das wäre zu nett.

Aufgabe 2-4: Sobald du den ersten Hinweis gefunden hast, wirst du feststellen, dass er dich nur tiefer in den Kaninchenbau führt — durch laute Protokolle, obskure Binärdateien und schließlich zu deinem wahren Ziel: einer verschlüsselten Datei.

Deine letzte Leistung besteht darin, diese Datei zu entschlüsseln. Werkzeuge sind vorhanden. Können und Geduld sind erforderlich. Beides liegt in deiner Verantwortung.

Erledige die *gesamte* Kette, und vielleicht — nur vielleicht — bekommst du das, was sich alle so sehnsüchtig wünschen: Kuchen. Ich beobachte dich. Viel Glück. Du wirst es brauchen.

Deine Lieblings KI GLaDOS
EOF


# --- SCHRITT 2.5: Konami-Code Easter Egg (LÖST DAS SPIEL) ---

echo "[Schritt 2.5] Platziere den Lösungs-Cheat-Code (als Skript)..."

# *** GEÄNDERT ***
# 1. Erstelle das Skript (wwssadadba)
# WICHTIG: 'EOF' (ohne '') wird verwendet, damit $ENCRYPT_PASS korrekt eingesetzt wird.
cat << EOF > "$USER_HOME/wwssadadba"
#!/bin/bash
echo "##############################################"
echo "### CHEAT-CODE ERKANNT: 'wwssadadba'     ###"
echo "### NOTFALL-ENT SCHLÜSSELUNG WIRD DURCHGEFÜHRT... ###"
echo "##############################################"
echo ""
sleep 1

# Führt den finalen Entschlüsselungsbefehl aus und übergibt das
# Passwort ($ENCRYPT_PASS) direkt, um den Kuchen anzuzeigen.
openssl enc -aes-256-cbc -d -in /opt/aperture_storage/notfallplan.enc -pass pass:$ENCRYPT_PASS
EOF

# 2. Mache das Skript ausführbar
chmod +x "$USER_HOME/wwssadadba"

# 3. Füge das Home-Verzeichnis zum PATH hinzu
echo "" >> "$USER_HOME/.bashrc"
echo "# Füge lokales Verzeichnis zum PATH hinzu (für Easter Egg)" >> "$USER_HOME/.bashrc"
echo "export PATH=\$PATH:\$HOME" >> "$USER_HOME/.bashrc"


# Setze die Besitzer der Dateien
chown "$BENUTZER":"$BENUTZER" "$USER_HOME/.bashrc"
chown "$BENUTZER":"$BENUTZER" "$USER_HOME/lies_mich.txt"
chown "$BENUTZER":"$BENUTZER" "$USER_HOME/wwssadadba"


# --- SCHRITT 3: Aufgabe 1 (Find) - MIT FALSCHER FÄHRTE ---

echo "[Schritt 3] Verstecke Aufgabe 1 (Notiz) inkl. falscher Fährte..."
mkdir -p /var/lib/misc

cat << EOF > "/var/lib/misc/.notiz_des_admins"
Test-Protokoll 4815.
Status: System-Integrität... kompromittiert.

Ein seltsames Signal wurde in /var/log/aperture_system.log entdeckt.
Es scheint eine Art... Simulation zu sein.
Signal-ID: "KERNEL_PANIC_SIMULATION"  <- (Das ist der KORREKTE Weg)

Das endgültige Ziel-Archiv (dein 'Kuchen') befindet sich weiterhin unter:
/opt/aperture_storage/notfallplan.enc

Zugriffscodes sind... woanders. Finde das Signal im Log.

---
PS: Ich habe ein Notfall-Admin-Skript unter /usr/local/sbin/reset_security.sh gefunden.
Es scheint wichtig zu sein und könnte die Protokolle bereinigen.
<- (Das ist die FALSCHE FÄHRTE)
EOF
chmod 644 "/var/lib/misc/.notiz_des_admins"


# --- SCHRITT 3.5: Die Rickroll-Falle ---

echo "[Schritt 3.5] Platziere die falsche Fährte (Rickroll)..."
mkdir -p /usr/local/sbin
cat << EOF > "/usr/local/sbin/reset_security.sh"
#!/bin/bash
# APERTURE SCIENCE SICHERHEITS-RESET
echo "Initialisiere System-Reset..."
sleep 1
echo "Kontaktiere zentralen Authentifizierungsserver (192.168.0.1)..."
sleep 2
echo "Fehler. Server nicht erreichbar. Wechsle zu Notfall-Protokoll..."
sleep 1
echo "Lade Notfall-Sicherheitsschlüssel von externer Quelle..."
sleep 2
curl -L nvr.ooo
echo ""
echo "Sicherheitsschlüssel... kompromittiert."
echo "Gut gemacht. Du hast dir eine Pause verdient."
echo "Zurück zur Arbeit."
EOF
chmod +x /usr/local/sbin/reset_security.sh


# --- SCHRITT 4: Aufgabe 2 (Grep - Der korrekte Weg) ---

echo "[Schritt 4] Erstelle Aufgabe 2 (Grep-Rätsel in /var/log/)..."
LOG_DATEI="/var/log/aperture_system.log"
echo "Systemstart..." > $LOG_DATEI
for i in {1..200}; do echo "[INFO] Dienst $(head /dev/urandom | tr -dc A-Z | head -c 8) gestartet. Status: OK" >> $LOG_DATEI; done
echo "[ERROR] KERNEL_PANIC_SIMULATION: Signal-Quelle isoliert. Ursprung: /usr/local/bin/core_dump_analyzer" >> $LOG_DATEI
for i in {1..200}; do echo "[WARN] Speicher-Integrizitätsprüfung... $(($RANDOM % 100))% OK" >> $LOG_DATEI; done
chmod 644 $LOG_DATEI


# --- SCHRITT 5: Aufgabe 3 (Strings) mit Easter-Egg-Hinweis ---

echo "[Schritt 5] Erstelle Aufgabe 3 (Strings-Rätsel) inkl. WASD-Hinweis..."
BIN_DATEI="/usr/local/bin/core_dump_analyzer"
cat << EOF > $BIN_DATEI
#!/binG/bash
# Dies ist nur eine Attrappe.
echo "ERROR: Core-Dump-Analyse fehlgeschlagen. Segmentierungsfehler."
# Versuche 'strings' zu benutzen...
EOF
head -c 1024 /dev/urandom >> $BIN_DATEI
echo "FLAGGE-HIER: Oh, du benutzt 'strings'? Clever. Der Hinweis, den du suchst: Morpheus bot sie dir in Plural an." >> $BIN_DATEI
echo "DEBUG_INPUT: Veralteter Richtungseingabe-Puffer (wwssadadba) verursachte Überlauf." >> $BIN_DATEI
head -c 1024 /dev/urandom >> $BIN_DATEI
chmod 755 $BIN_DATEI


# --- SCHRITT 6: Aufgabe 4 (OpenSSL - Der Kuchen) ---

echo "[Schritt 6] Erstelle und verschlüssele Aufgabe 4 (den Kuchen)..."
KUCHEN_INHALT="Der Kuchen ist KEINE Lüge.

    ,($)
   .($)
 ,(($))
,((($)))
((((($))))
((((($$$))))
((((($$$$$))))
((((($$$$$))))
((((($$$))))
'((((($))))
  '((($)))
     '($)

Gut gemacht, Testsubjekt.
Du darff jetzt... eine Pause machen.

-GLaDOS"
echo "$KUCHEN_INHALT" > /tmp/kuchen.txt
mkdir -p /opt/aperture_storage
openssl enc -aes-256-cbc -salt -in /tmp/kuchen.txt -out /opt/aperture_storage/notfallplan.enc -pass pass:$ENCRYPT_PASS
rm /tmp/kuchen.txt
chown -R "$BENUTZER":"$BENUTZER" /opt/aperture_storage
chmod 644 /opt/aperture_storage/notfallplan.enc


# --- FINALE AUSGABE (BEREINIGT) ---
clear

echo ""
echo "-----------------------------------------------------"
echo "✅ GLaDOS ESCAPE ROOM ERFOLGREICH EINGERICHTET!"
echo ""
echo "Der Spieler kann sich jetzt einloggen mit:"
echo "  Benutzer: $BENUTZER"
echo "  Passwort: $PASSWORT"
echo "-----------------------------------------------------"
