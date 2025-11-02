# Troubleshooting

Esta guía recopila problemas frecuentes al ejecutar los scripts de automatización
localmente y cómo resolverlos.

## Herramientas no instaladas

Ejecuta `./scripts/bash/check-prerequisites.sh` para verificar dependencias. Los
scripts de linting y releases validan la presencia de cada herramienta y fallan
con mensajes descriptivos.

## Errores de permisos

Si un script no tiene permisos de ejecución, puedes corregirlo con:

```bash
chmod +x scripts/bash/*.sh scripts/bash/release/*.sh
```

## Documentación desactualizada

Ejecuta nuevamente `./scripts/bash/build-docs.sh` y, si necesitas visualizarla,
usa la opción `--serve` para validar que los cambios se renderizan correctamente.
