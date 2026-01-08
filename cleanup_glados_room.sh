#!/bin/bash

# === GLaDOS ESCAPE ROOM CLEANUP-SKRIPT ===
#
# WICHTIG: Dieses Skript macht alle Änderungen von 'setup_glados_room.sh'
# (Version 4.7 bis 4.9) rückgängig.
#
# ES MUSS MIT 'sudo' AUSGEFÜHRT WERDEN.
# ===================================================


# 0. Prüfen, ob das Skript als root läuft
if [ "$(id -u)" -ne 0 ]; then
  echo "FEHLER: Dieses Skript muss als root (oder mit sudo) ausgeführt werden."
  exit 1
fi

echo "Starte GLaDOS Escape Room Cleanup..."


# --- SCHRITT 1: Entferne Benutzer 'testperson' ---
# Das ist der wichtigste Schritt.
# Der '-r' Flag löscht den Benutzer UND sein Home-Verzeichnis (/home/testperson),
# was automatisch 'lies_mich.txt', 'wwssadadba' und die geänderte '.bashrc' entfernt.

echo "[Schritt 1] Entferne Benutzer 'testperson' und sein Home-Verzeichnis..."
userdel -r testperson 2>/dev/null
if [ $? -eq 0 ]; then
    echo "Benutzer 'testperson' erfolgreich entfernt."
else
    echo "Warnung: Benutzer 'testperson' konnte nicht entfernt werden (vielleicht schon gelöscht?)."
fi


# --- SCHRITT 2: Entferne die Systemdateien und Ordner ---

echo "[Schritt 2] Entferne Rätsel-Dateien aus dem System..."

# Aufgabe 1 (find)
rm -f /var/lib/misc/.notiz_des_admins

# Aufgabe 3 (strings)
rm -f /usr/local/bin/core_dump_analyzer

# Rickroll-Falle
rm -f /usr/local/sbin/reset_security.sh

# Aufgabe 2 (grep)
rm -f /var/log/aperture_system.log

# Aufgabe 4 (Kuchen)
# Wir nutzen 'rm -r' (rekursiv), da der Ordner von uns erstellt wurde.
rm -rf /opt/aperture_storage

echo "Alle bekannten Dateien und Ordner entfernt."


# --- SCHRITT 3: Entferne leere Verzeichnisse (Sicherheits-Check) ---

echo "[Schritt 3] Versuche, leere Verzeichnisse zu entfernen..."
# Wir benutzen 'rmdir'. Dieser Befehl schlägt FEHL, wenn der Ordner
# NICHT LEER ist, was gut ist! Wir wollen keine Systemordner löschen,
# die noch andere (wichtige) Dateien enthalten.
# 2>/dev/null unterdrückt die "Verzeichnis nicht leer"-Fehler.

rmdir /var/lib/misc 2>/dev/null
rmdir /usr/local/sbin 2>/dev/null

echo ""
echo "-----------------------------------------------------"
echo "✅ Cleanup Abgeschlossen!"
echo ""
echo "Hinweis zu 'curl':"
echo "Das Setup-Skript hat eventuell 'curl' installiert. Dieses Skript"
echo "deinstalliert es NICHT, da es von anderen Programmen"
echo "auf deinem System benötigt werden könnte."
echo "-----------------------------------------------------"
