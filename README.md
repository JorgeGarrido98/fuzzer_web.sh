# 🌐 fuzzer_web.sh

Script en Bash que realiza **fuzzing de directorios web** utilizando un diccionario de rutas y `curl`. Detecta URLs accesibles, redirigidas o restringidas, y guarda los resultados en un archivo `.txt` con marca de tiempo.

---

## 🧾 ¿Qué hace este script?

1. Toma como entrada un **diccionario de palabras** y una **URL base**.
2. Construye una URL combinando la base con cada palabra del diccionario.
3. Realiza peticiones HTTP a cada URL generada usando `curl`.
4. Muestra el progreso en consola en tiempo real.
5. Identifica y guarda las URLs válidas según el código de estado HTTP:
   - ✅ `200 OK` → accesible
   - 🔁 `301`, `302` → redirección
   - ⛔ `403 Forbidden` → acceso denegado (pero existe)
6. Guardado de resultados válidos en un **archivo de salida**.

---

## 📦 Requisitos

- Shell Bash
- `curl` instalado
- Un diccionario como los que vienen con herramientas de pentesting, por ejemplo:
  ```bash
  /usr/share/wordlists/dirbuster/directory-list-lowercase-2.3-medium.txt
