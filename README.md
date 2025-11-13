Dieses Projekt ist dafür gedacht, in einer **isolierten virtuellen Umgebung** ausgeführt zu werden.


Wie man spielt (Anleitung für Virtuelle Maschine)

Du benötigst eine VM-Software (wie [VirtualBox](https://www.virtualbox.org/) oder [VMware Player](https://www.vmware.com/products/workstation-player.html)) und ein Linux-Betriebssystem-Image (z.B. [Ubuntu Server](https://ubuntu.com/download/server)).

1. Erstelle die Testkammer (VM installieren)**
Installiere ein sauberes Linux (z.B. Ubuntu) in deiner VM-Software. Stelle sicher, dass du einen Snapshot machst, nachdem die Installation abgeschlossen ist, damit du den Raum leicht zurücksetzen kannst.

2. Übertrage das Setup-Skript**
Starte deine neue VM und logge dich ein. Du musst das `setup_glados_room.sh`-Skript von diesem GitHub-Repository auf deine VM übertragen.

Methoden hierfür sind:
- Ein "Shared Folder" (Geteilter Ordner) in den VirtualBox-Gasteinstellungen.
- Manuelles Kopieren und Einfügen des Skript-Inhalts in einen neuen Editor (z.B. `nano setup.sh`) innerhalb der VM.
- Verwendung von `git clone`, falls `git` auf der VM installiert ist.

3. Baue den Escape Room (Skript ausführen)**
Sobald sich das Skript in deiner VM befindet, öffne ein Terminal in der VM:

4. Führe das Skript als Administrator aus
sudo ./setup_glados_room.sh

Du befindest dich nun im Escape Room. Deine erste Anweisung (`lies_mich.txt`) wartet bereits auf dich.



Dokumentation

docs/Aperture Science Test-Handbuch (Für Testsubjekte).md Enthält eine spoiler-freie Anleitung für den Spieler, wie er den Test beginnt.

docs/GLaDOS Escape Room: Lösungsbuch (SPOILER).md (SPOILER!) Enthält die komplette Schritt-für-Schritt-Lösung für alle 4 Rätsel und Geheimnisse.


Wichtig für die volle Erfahrung ist eine VM mit Internet anbinung nötig!

