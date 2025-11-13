# GLaDOS Linux Escape Room

> Willkommen. Wieder einmal ein kleines Experiment — nur du, dein Verstand und ein freundlich gestimmtes Betriebssystem, das ganz zufällig ein paar Geheimnisse für dich versteckt hat.

Dies ist ein textbasierter "Escape Room", der komplett im Linux-Terminal gespielt wird. Du wirst eine Kette von 4 Rätseln lösen müssen, indem du Standard-Linux-Befehle wie `find`, `grep`, `strings` und `openssl` benutzt.

---

### 🚀 Wie man spielt (Der einfache Weg)

Du benötigst [Docker](https://www.docker.com/get-started), um diese Testumgebung sicher und isoliert auszuführen.

**1. Erstelle den Raum (Image bauen)**
Klone dieses Repository oder lade es herunter, öffne dein Terminal und navigiere in diesen Ordner. Führe dann diesen Befehl aus:

```bash
docker build -t glados-room .
```

**2. Betrete den Raum (Container starten)**
Sobald der Bau abgeschlossen ist, starte den Test mit diesem Befehl:

```bash
docker run -it --rm glados-room
```

Du befindest dich nun als `testperson` im Escape Room. Deine erste Anweisung (`lies_mich.txt`) wartet bereits auf dich.

Viel Glück. Du wirst es brauchen.

*(Falls du das `Aperture Science Test-Handbuch (Für Testsubjekte).md` lesen möchtest, findest du es in diesem Repository.)*

---

### ⚠️ Warnung (Der manuelle Weg)

Das Repository enthält ein `setup_glados_room.sh`-Skript. Dieses Skript ist **NUR** für den Docker-Build oder für die Verwendung in einer **isolierten Wegwerf-VM** (z.B. VirtualBox) gedacht.

**FÜHRE DAS SKRIPT NIEMALS MIT `sudo` AUF DEINEM HAUPT-PC AUS.** Es erstellt Benutzer, ändert Berechtigungen und schreibt Dateien in Systemverzeichnisse (`/var`, `/opt`, `/usr`).
