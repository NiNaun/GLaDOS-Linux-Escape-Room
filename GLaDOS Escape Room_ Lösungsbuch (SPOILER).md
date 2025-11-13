📖 GLaDOS Escape Room: Lösungsbuch (SPOILER)
Dies ist der vollständige Lösungsweg, inklusive des Cheat-Codes.

1. Der Start: Login und die erste Nachricht
Befehl: su - testperson

Passwort: aperture

Aktion: cat lies_mich.txt

Hinweis: Der Text (GLaDOS) erklärt, dass die erste Aufgabe "nicht im Home-Verzeichnis" ist und eine Kette von Aufgaben darstellt.

2. Aufgabe 1: Die versteckte Notiz finden (Befehl: find)
Problem: Eine Datei irgendwo im System finden.

Lösungs-Befehl:

Bash

$ find / -name ".notiz_des_admins" 2>/dev/null
Ergebnis: /var/lib/misc/.notiz_des_admins

Aktion: Spieler liest die gefundene Datei:

Bash

$ cat /var/lib/misc/.notiz_des_admins
3. Die Falsche Fährte: Der Rickroll (Die Falle)
Die Falle: Die gerade gelesene Datei .notiz_des_admins erwähnt ein verlockendes Skript:

PS: Ich habe ein Notfall-Admin-Skript unter /usr/local/sbin/reset_security.sh gefunden.

Aktion: Der Spieler führt das Skript aus:

Bash

$ /usr/local/sbin/reset_security.sh
Ergebnis: Ein ASCII-Rickroll wird im Terminal abgespielt. Der Spieler muss erkennen, dass dies eine Sackgasse war.

4. Aufgabe 2: Das Signal im Rauschen (Befehl: grep)
Der korrekte Weg: Der Spieler ignoriert die Falle und konzentriert sich auf den ersten Teil der .notiz_des_admins-Datei:

Ein seltsames Signal wurde in /var/log/aperture_system.log entdeckt. Signal-ID: "KERNEL_PANIC_SIMULATION"

Problem: Die Log-Datei ist voller "Lärm".

Lösungs-Befehl:

Bash

$ grep "KERNEL_PANIC_SIMULATION" /var/log/aperture_system.log
Ergebnis:

[ERROR] KERNEL_PANIC_SIMULATION: Signal-Quelle isoliert. Ursprung: /usr/local/bin/core_dump_analyzer
5. Aufgabe 3: Hinweise in der Binärdatei (Befehl: strings)
Problem: Der neue Pfad /usr/local/bin/core_dump_analyzer führt zu einem Programm, das bei der Ausführung nur einen Fehler anzeigt.

Lösungs-Befehl:

Bash

$ strings /usr/local/bin/core_dump_analyzer
Ergebnis: Der Spieler findet im Textmüll zwei wichtige Zeilen:

FLAGGE-HIER: Oh, du benutzt 'strings'? Clever. Der Hinweis, den du suchst: Morpheus bot sie dir in Plural an. (Hinweis für Aufgabe 4)

DEBUG_INPUT: Veralteter Richtungseingabe-Puffer (wwssadadba) verursachte Überlauf. (Hinweis für den Cheat-Code)

6. Aufgabe 4: Das Finale (Befehl: openssl)
Dies ist der normale Lösungsweg.

Kombination der Hinweise:

Datei: /opt/aperture_storage/notfallplan.enc (aus Aufgabe 1)

Passwort-Hinweis: "Morpheus bot sie dir in Plural an." (aus Aufgabe 3)

Passwort-Lösung: Morpheus bot Pillen an (Plural). Das Passwort ist: pills

Lösungs-Befehl:

Bash

$ openssl enc -aes-256-cbc -d -in /opt/aperture_storage/notfallplan.enc
Finale: Das Terminal fragt: enter AES-256-CBC decryption password:

Der Spieler tippt pills (unsichtbar) und drückt Enter.

GEWONNEN: Die ASCII-Kuchen-Grafik und die Abschlussnachricht werden angezeigt.

7. Der Cheat-Code (Alternative Lösung)
Hinweis: Die DEBUG_INPUT-Zeile (wwssadadba) aus Aufgabe 3.

Aktion: Der Spieler tippt den Hinweis als Befehl ein:

Bash

$ wwssadadba
Ergebnis: Das Cheat-Skript wird ausgeführt, gibt eine Cheat-Meldung aus und entschlüsselt sofort und automatisch die finale Datei, wodurch der Spieler direkt zum Sieg-Bildschirm (dem Kuchen) springt.

##############################################
### CHEAT-CODE ERKANNT: 'wwssadadba'     ###
### NOTFALL-ENT SCHLÜSSELUNG WIRD DURCHGEFÜHRT... ###
##############################################

Der Kuchen ist KEINE Lüge.
... (usw.) ...
