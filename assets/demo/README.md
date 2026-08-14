# Assets de demo

## Imágenes

- `silla_raw.png` / `lampara_raw.png` — foto "tal cual" simulada (estilo smartphone, luz pareja, fondo con desorden), generada con `generate_image` (Higgsfield) el 2026-08-13.
- `silla_enhanced.png` / `lampara_enhanced.png` — **placeholder local, sin IA**: recorte más cercano al producto + nitidez/contraste/saturación + viñeta radial a blanco (`scripts` ad-hoc con Pillow/numpy, ver historial). No es un cutout real.

**Por qué no son el resultado real del pipeline**: se intentó `remove_background` + `upscale_image` (Higgsfield/Bytedance) sobre la foto raw, pero el background remover no logró aislar el producto (la salida quedó casi idéntica a la foto original) y justo después la cuenta llegó a 0 créditos, así que no se pudo reintentar con otro encuadre ni otro modelo. El fallback local de arriba es una aproximación visual mientras tanto — mejora nitidez/contraste real, pero no elimina el fondo.

**Pendiente**: con créditos disponibles, reintentar la mejora real, en este orden — probar `remove_background` con una foto de encuadre más simple (producto más centrado, mayor contraste con el fondo) antes de subir a upscale, ya que aquí el fondo abarrotado probablemente confundió la segmentación.

## Modelos 3D (placeholder — pendiente de reemplazo)

`silla.glb` (Khronos "SheenChair") y `lampara.glb` (Khronos "Lantern") son **modelos de muestra de la librería oficial glTF-Sample-Assets de Khronos Group** (licencia permisiva, ver `LICENSE.md` de cada modelo en el repo original), usados como placeholder porque la cuenta de Higgsfield usada en este entorno se quedó sin créditos al llamar `generate_3d`.

**Pendiente**: cuando haya créditos disponibles, regenerar reemplazando estos dos archivos con la salida real de:

```
generate_3d(model: "image_to_3d", medias: [{value: <enhanced_image_job_id>, role: "image"}], should_texture: true)
```

usando `silla_enhanced.png` / `lampara_enhanced.png` (o sus job_ids de generación, ya usados una vez: `5abe8cec-3354-43a7-8594-5ee5edec4453` para la silla y `5cc13de6-6880-4642-86e8-7184d98c5733` para la lámpara) como imagen fuente. El resto de la app (visor, rutas, nombres de archivo) no cambia — solo se sobrescriben los `.glb`.
