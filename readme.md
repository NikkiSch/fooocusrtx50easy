# 🎨 Fooocus – KI-Bildgenerator

Einfache Installation des KI-Bildgenerators Fooocus,
optimiert für NVIDIA RTX 50xx (Blackwell), RTX 30xx und RTX 40xx.

Basiert auf [alibakhtiari2/fooocusrtx508090](https://github.com/alibakhtiari2/fooocusrtx508090),
einem Fork von [lllyasviel/Fooocus](https://github.com/lllyasviel/Fooocus).

## ✅ Voraussetzungen

- Windows 10 oder 11
- NVIDIA-Grafikkarte (RTX 30xx, 40xx oder 50xx)
- Aktuelle NVIDIA-Treiber
- Internetverbindung (nur bei der ersten Installation)

> Python und Git müssen **nicht** installiert werden.

## 🚀 Installation (einmalig)

1. Oben rechts auf den grünen Button **„Code"** klicken
2. **„Download ZIP"** wählen und speichern
3. ZIP-Datei entpacken
4. **`install.bat`** doppelklicken und warten (~10–20 Minuten)

## ▶️ Starten

Nach der Installation einfach **`run.bat`** doppelklicken.  
Der Browser öffnet sich automatisch mit der Fooocus-Oberfläche.

## 🔧 Enthaltene Fixes (gegenüber dem Original)

| Problem | Lösung |
|---|---|
| `TypeError: unhashable type: dict` | Jinja2 auf Version 3.1.2 gepinnt |
| `localhost not accessible` | NO_PROXY automatisch gesetzt |
| RTX 50xx nicht erkannt | PyTorch cu128 für Blackwell-Architektur |

## 💡 Tipps

- Beim ersten Start werden Modelle heruntergeladen (~7 GB) – 
  das dauert je nach Internetgeschwindigkeit einige Minuten
- Erzeugte Bilder werden im Ordner `outputs/` gespeichert
- Mit der Einstellung **„Image Prompt"** können eigene Bilder 
  als Vorlage verwendet werden

## 📄 Lizenz

Dieses Projekt folgt der Lizenz des Original-Repositories.  
Alle Änderungen in diesem Fork sind gemeinfrei.

ENGLISH:
# 🎨 Fooocus – AI Image Generator

Easy installation of the Fooocus AI image generator,
optimized for NVIDIA RTX 50xx (Blackwell), RTX 30xx and RTX 40xx.

Based on [alibakhtiari2/fooocusrtx508090](https://github.com/alibakhtiari2/fooocusrtx508090),
a fork of [lllyasviel/Fooocus](https://github.com/lllyasviel/Fooocus).

## ✅ Requirements

- Windows 10 or 11
- NVIDIA graphics card (RTX 30xx, 40xx or 50xx)
- Up-to-date NVIDIA drivers
- Internet connection (first installation only)

> Python and Git do **not** need to be installed.

## 🚀 Installation (one time only)

1. Click the green **"Code"** button in the top right
2. Select **"Download ZIP"** and save the file
3. Extract the ZIP file
4. Double-click **`install.bat`** and wait (~10–20 minutes)

## ▶️ Starting the App

After installation, simply double-click **`run.bat`**.  
Your browser will open automatically with the Fooocus interface.

## 🔧 Fixes included (compared to the original)

| Issue | Fix |
|---|---|
| `TypeError: unhashable type: dict` | Jinja2 pinned to version 3.1.2 |
| `localhost not accessible` | NO_PROXY set automatically |
| RTX 50xx not recognized | PyTorch cu128 for Blackwell architecture |

## 💡 Tips

- On first launch, models will be downloaded (~7 GB) –  
  this may take a few minutes depending on your internet speed
- Generated images are saved in the `outputs/` folder
- Use the **"Image Prompt"** option to upload your own image as a reference

## 📄 License

This project follows the license of the original repository.  
All changes in this fork are released to the public domain.
