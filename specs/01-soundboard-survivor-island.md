# SPEC 01 — Soundboard para Survivor Island

**Estado:** Approved
**Depende de:** ninguno
**Fecha:** 2026-10-15
**Objetivo:** App Flutter "Para Jugar Island" con una cuadrícula de botones de colores vivos que reproducen en bucle sonidos propios (tiburón, kayak, volcán, terremoto, olas, balsa, hombres corriendo, hombres gritando) hasta que se detengan, para ambientar el juego de mesa Survivor Island.

## Alcance

### Dentro
- Pantalla única con cuadrícula de 8 botones grandes, uno por sonido, colores vivos, icono/emoji y nombre.
- Tocar botón = inicia bucle; tocar de nuevo = detiene. Estado visual claro activo/inactivo.
- Sonidos simultáneos e independientes.
- Slider de volumen por sonido.
- Botón fijo "Parar todo".
- Pantalla siempre encendida mientras la app está abierta (wakelock).
- Orientación bloqueada en vertical.
- Al enviar la app a segundo plano / bloquear pantalla: se detienen todos los sonidos.
- Audios como assets empaquetados (`assets/sounds/`), mp3 u ogg, aportados por el usuario.
- Firma de release Android con keystore existente; `applicationId` = `com.luisitomayta.para_jugar_island`.

### Fuera
- Reproducción en segundo plano / servicio foreground / notificación.
- Persistencia de ajustes (volúmenes, estado).
- Grabación o importación de sonidos desde el dispositivo.
- Reglas, puntajes o lógica del juego de mesa.
- iOS, web, escritorio (solo Android en esta versión).
- Publicación en Play Store (solo build firmado).
- Localización multiidioma (solo español).

## Modelo de datos

Sin persistencia. Estructura en memoria:

```dart
class SoundItem {
  final String id;        // 'shark', 'kayak', 'volcano', 'earthquake', 'waves', 'raft', 'running', 'screaming'
  final String label;     // texto visible en español
  final String emoji;     // icono del botón
  final String assetPath; // 'assets/sounds/<id>.mp3'
  final Color color;      // color vivo del botón
}
```

- Lista constante `kSounds` en `lib/data/sounds.dart` (añadir un sonido = añadir una entrada + el archivo).
- Estado por sonido: `isPlaying` (bool), `volume` (0.0–1.0, default 1.0), en un controlador `SoundboardController` (ChangeNotifier) con un `AudioPlayer` por sonido en `ReleaseMode.loop`.

## Plan de implementación

1. **Dependencias y assets.** Añadir `audioplayers` y `wakelock_plus` en `pubspec.yaml`; declarar `assets/sounds/`; crear carpeta con audios placeholder (tono corto) con los 8 nombres de `id`.
2. **Modelo y lista.** Crear `SoundItem` y `kSounds` con colores vivos y emojis.
3. **Controlador de audio.** `SoundboardController`: toggle, setVolume, stopAll, dispose; un player en loop por sonido, precargado.
4. **UI.** `SoundButton` (tarjeta grande, color vivo, estado activo con borde/animación, slider de volumen) y `HomePage` con `GridView` 2 columnas + barra inferior "Parar todo".
5. **Ciclo de vida.** `WidgetsBindingObserver`: en `paused/inactive` → `stopAll()`. Activar wakelock al iniciar. Bloquear orientación portrait en `main.dart`.
6. **Tema.** Material 3, fondo oscuro/vibrante, texto legible sobre colores vivos.
7. **Identidad Android.** Cambiar `namespace`/`applicationId` a `com.luisitomayta.para_jugar_island` y mover `MainActivity` al nuevo paquete; nombre visible "Para Jugar Island".
8. **Firma release.** Crear `android/key.properties` (fuera de git) apuntando a `/home/lmayta/para_jugar_island.jks`; configurar `signingConfigs.release` en `android/app/build.gradle.kts`; añadir `key.properties` y `*.jks` a `.gitignore`. Alias esperado `para_jugar_island`, verificar con `keytool -list`. La contraseña NO se escribe en el repo ni en este spec.
9. **Verificación.** `flutter analyze`, test de widget del controlador, `flutter build apk --release` firmado y comprobación con `apksigner verify`.

## Criterios de aceptación

- [ ] Al abrir la app hay 8 botones visibles con nombre, emoji y color distinto cada uno.
- [ ] Tocar un botón inicia su sonido y se repite sin cortes audibles hasta volver a tocarlo.
- [ ] Tocar de nuevo detiene ese sonido y los demás siguen sonando.
- [ ] Se pueden tener ≥3 sonidos activos a la vez.
- [ ] El botón activo se distingue visualmente del inactivo.
- [ ] El slider de cada botón cambia su volumen en vivo sin afectar a otros.
- [ ] "Parar todo" detiene todos los sonidos y todos los botones quedan inactivos.
- [ ] Al bloquear pantalla o enviar la app a segundo plano, todos los sonidos se detienen.
- [ ] La pantalla no se apaga por inactividad con la app abierta.
- [ ] La app no rota a horizontal.
- [ ] `flutter analyze` sin errores ni warnings.
- [ ] `flutter build apk --release` genera APK y `apksigner verify` lo valida con el certificado de `para_jugar_island.jks`.
- [ ] `applicationId` es `com.luisitomayta.para_jugar_island`.
- [ ] `grep` de la contraseña del keystore en el repo no devuelve resultados; `key.properties` y `*.jks` están en `.gitignore`.

## Decisiones tomadas y descartadas

- **Cuadrícula de botones grandes** sobre lista por categorías: uso rápido en mesa, un toque.
- **Sonidos simultáneos** sobre "uno a la vez": ambientar mezclando olas + volcán + gritos.
- **Sin audio en segundo plano**: evita servicio foreground y notificación; se detiene al salir.
- **Assets empaquetados** sobre carga dinámica: más simple y offline. Placeholders hasta que el usuario aporte los suyos.
- **Extras aceptados:** volumen por sonido, wakelock, portrait fijo.
- **`audioplayers` + `ChangeNotifier`** sobre Riverpod/BLoC: una sola pantalla, estado mínimo.
- **Lista de sonidos:** el usuario eligió "9 sonidos" pero enumeró 8; se implementan los 8 nombrados y la lista es extensible vía `kSounds`. Confirmar si falta un noveno.
- **"kayjus" interpretado como "kayaks"**; "hombres corriendo" y "hombres gritando" son dos sonidos separados.
- **Ruta de la llave:** `/home/lmayta/para_jugar_island.jks` (el prompt decía `/hom/...`, typo; el archivo existe en `/home`).
- **Contraseña del keystore** dada en el prompt inicial: no se persiste en el spec ni en git; solo en `android/key.properties` ignorado. Se recomienda rotarla si el chat se comparte.
- **Proyecto base ya existe** (`flutter create`, `com.example.*`); se modifica en lugar de recrear.

## Riesgos

- Bucles de mp3 pueden tener un micro-silencio al reiniciar; preferir `.ogg` o mp3 sin padding si se nota.
- Muchos players simultáneos con audios largos aumentan memoria; usar archivos cortos (≤30 s) comprimidos.
- Cambiar `applicationId` rompe cualquier instalación previa con el id `com.example.*`.
- Alias del keystore no verificado; si difiere, el build release falla (se detecta en paso 9).
