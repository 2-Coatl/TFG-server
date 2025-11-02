# Reglas de Negocio en Ingeniería de Requerimientos
## Clasificación, Influencias y Ejemplos Aplicados

---

**FECHA:** 2025-02-14
**VERSIÓN:** 1.0
**ESTADO:** [BORRADOR] Documento en revisión
**FUENTES:** BABOK v3 (IIBA), IEEE 29148, Regulaciones OSHA/EPA, Buenas prácticas internas de TFG

---

## RESUMEN EJECUTIVO

Este estándar describe qué son las reglas de negocio, dónde se ubican dentro de la jerarquía de requisitos y cómo influyen en las diferentes capas de especificación (negocio, usuario, funcional y atributos de calidad). Incluye la clasificación reconocida de reglas (hechos, restricciones, desencadenadores de acción, inferencias y cálculos computacionales) junto con ejemplos contextualizados para ingeniería de requerimientos en entornos regulados.

---

## 1. Conceptos Fundamentales

### 1.1 ¿Qué es una regla de negocio?

> **Concepto clave:** Las reglas de negocio son políticas, leyes y estándares de la industria bajo los cuales se rige una organización para operar de manera efectiva y conforme a las regulaciones.

Cada organización opera bajo un conjunto extenso de políticas internas, leyes y estándares regulatorios. En ingeniería de requerimientos, denominamos **reglas de negocio** a esos elementos normativos que condicionan el comportamiento de procesos, personas y sistemas.

> **Nota contextual:** Industrias como banca, aviación, salud o fabricación de dispositivos médicos deben cumplir con un volumen significativo de regulaciones gubernamentales.

### 1.2 Ejemplo: Gestión de residuos en emergencia sanitaria

Durante situaciones de emergencia sanitaria existen regulaciones específicas que toda organización debe atender:

- Tratamiento de residuos bacteriológicos.
- Protocolos de movimiento y captación.
- Procedimientos de eliminación segura.

Estos lineamientos constituyen reglas de negocio que impactan directamente el diseño del sistema.

### 1.3 Ubicación en la jerarquía de requisitos

```
┌─────────────────────────────────────────────────────────────┐
│                    JERARQUÍA DE REQUERIMIENTOS              │
├─────────────────────────────────────────────────────────────┤
│  Nivel 1: REGLAS DE NEGOCIO                                │
│  (Políticas, Leyes, Estándares)                            │
│                         │                                   │
│                         ▼                                   │
│  Nivel 2: REQUERIMIENTOS DE NEGOCIO                        │
│  (Objetivos organizacionales)                              │
│                         │                                   │
│                         ▼                                   │
│  Nivel 3: REQUERIMIENTOS DE USUARIO                        │
│  (Necesidades específicas del usuario)                     │
│                         │                                   │
│                         ▼                                   │
│  Nivel 4: REQUERIMIENTOS FUNCIONALES                       │
│  (Funcionalidades del sistema)                             │
│                         │                                   │
│                         ▼                                   │
│  Nivel 5: ATRIBUTOS DE CALIDAD                             │
│  (Características no funcionales)                          │
└─────────────────────────────────────────────────────────────┘
```

### 1.4 Funciones principales

Las reglas de negocio, también conocidas como **lógica de negocio**, cumplen dos funciones principales:

1. **Restricción de acceso:** definen quién puede ejecutar determinados casos de uso.
2. **Control de funcionalidad:** dictan qué capacidades debe ejecutar el sistema para cumplir con la normativa.

---

## 2. Influencia en los tipos de requerimiento

| **Tipo de requerimiento** | **Cómo influyen las reglas de negocio** | **Ejemplo práctico** |
| --- | --- | --- |
| Requerimientos de negocio | Las regulaciones gubernamentales impulsan objetivos corporativos. | El sistema de seguimiento de químicos debe permitir el cumplimiento de todas las regulaciones federales y estatales sobre uso y eliminación en un plazo de 5 meses. |
| Requerimientos de usuario | Las políticas de privacidad limitan qué usuarios pueden ejecutar ciertas tareas. | Solo los gerentes de laboratorio pueden generar informes de exposición química. |
| Requerimientos funcionales | Las políticas empresariales establecen procesos concretos que el sistema debe implementar. | Cuando se recibe una factura de un proveedor no registrado, el sistema envía un correo con un PDF editable para darse de alta. |
| Atributos de calidad | Las regulaciones definen requisitos de seguridad que deben reflejarse en la funcionalidad. | El sistema mantiene registros de entrenamiento de seguridad y verifica que estén vigentes antes de permitir solicitudes de químicos peligrosos. |

### 2.1 Ejemplos detallados

- **Requerimientos de negocio:** “Nuestros productos químicos y su eliminación deben completarse en un período específico de 5 meses”.
- **Requerimientos de usuario:** “Solo los gerentes pueden generar reportes de exposición química”.
- **Requerimientos funcionales:** “El sistema envía automáticamente un PDF editable cuando un proveedor no registrado remite una factura”.
- **Atributos de calidad:** “El sistema bloquea solicitudes de químicos peligrosos si el entrenamiento de seguridad del usuario está vencido”.

---

## 3. Tipos de reglas de negocio

> **Concepto clave:** Existen cinco tipos principales de reglas de negocio: **hechos**, **restricciones**, **desencadenadores de acción**, **inferencias** y **cálculos computacionales**.

### 3.1 Hechos

Los **hechos** son declaraciones verdaderas sobre el negocio en un momento específico.

- Describen asociaciones entre términos comerciales.
- Son inmutables por naturaleza.
- Constituyen la base del conocimiento corporativo.

**Ejemplos:**

- Cada contenedor de productos químicos posee un identificador único de código de barras.
- Cada orden registra un costo de envío.
- Cada artículo en una orden documenta producto químico, grado, tamaño de envase y número de contenedores.
- Todo estudiante debe contar con matrícula válida para estar inscrito en la universidad.

### 3.2 Restricciones

> **Definición:** Sentencias que limitan las acciones de sistemas o usuarios.

**Indicadores lingüísticos comunes:** “debe”, “no debe”, “no puede”, “solo puede”.

**Ejemplos:**

- Un solicitante de préstamo menor de 18 años debe contar con un tutor como cosignatario.
- Un usuario de biblioteca puede tener como máximo 10 artículos en espera.
- La correspondencia no puede mostrar más de cuatro dígitos del número de seguro social.

#### 3.2.1 Restricciones por rol

Una forma eficaz de documentar restricciones basadas en roles es la **matriz de roles y permisos**:

```
┌─────────────────────────────────────────────────────────────┐
│           MATRIZ DE ROLES Y PERMISOS                        │
├─────────────────┬─────────────┬─────────────┬─────────────┤
│   OPERACIÓN     │ADMINISTRADOR│    STAFF    │   USUARIO   │
├─────────────────┼─────────────┼─────────────┼─────────────┤
│ Ver registro    │      ✓      │      ✓      │      ✓      │
├─────────────────┼─────────────┼─────────────┼─────────────┤
│ Editar registro │      ✓      │      ✓      │      ✗      │
├─────────────────┼─────────────┼─────────────┼─────────────┤
│ Eliminar        │      ✓      │      ✗      │      ✗      │
│ registro        │             │             │             │
├─────────────────┼─────────────┼─────────────┼─────────────┤
│ Buscar en       │      ✓      │      ✓      │      ✓      │
│ catálogo        │             │             │             │
├─────────────────┼─────────────┼─────────────┼─────────────┤
│ Generar         │      ✓      │      ✓      │      ✗      │
│ reportes        │             │             │             │
├─────────────────┼─────────────┼─────────────┼─────────────┤
│ Configurar      │      ✓      │      ✗      │      ✗      │
│ sistema         │             │             │             │
└─────────────────┴─────────────┴─────────────┴─────────────┘
```

### 3.3 Desencadenadores de acción (activadores)

> **Definición:** Reglas que activan una actividad cuando se cumplen condiciones específicas.

Siguen el patrón **“Si [condición] entonces [acción]”** y describen el comportamiento deseado del sistema.

**Ejemplos:**

- Si el almacén tiene contenedores disponibles, entonces los ofrece al solicitante.
- Si se alcanza la fecha de caducidad de un químico, entonces se notifica automáticamente a la persona responsable.

### 3.4 Inferencias

> **Definición:** Crean un nuevo hecho a partir de hechos existentes.

Aunque comparten la estructura “si-entonces”, la cláusula “entonces” genera conocimiento en lugar de acciones.

**Ejemplos:**

- Si un pago no se recibe dentro de 30 días, entonces la cuenta se marca como deudora.
- Si un vendedor nuevo no envía un artículo en cinco días, entonces la orden se marca como cancelada.

### 3.5 Cálculos computacionales

> **Definición:** Reglas que transforman datos mediante fórmulas matemáticas o algoritmos.

- Generan nuevos datos a partir de entradas existentes.
- A menudo provienen de regulaciones externas (ej. ISR, IVA, IMSS, OSHA, EPA).

**Ejemplos:**

- El envío terrestre nacional para pedidos mayores a 2 kg cuesta $40.75 + $0.12 por cada gramo adicional.
- El precio total de una orden = (precio de artículos – descuentos) + impuestos + envío + seguro opcional.

Para mejorar la claridad se recomienda documentar estos cálculos en formato tabular:

```
┌─────────────────────────────────────────────────────────────┐
│              TABLA DE DESCUENTOS POR VOLUMEN                │
├─────────────┬─────────────────┬─────────────────────────────┤
│IDENTIFICADOR│ CANTIDAD COMPRA │    PORCENTAJE DESCUENTO     │
├─────────────┼─────────────────┼─────────────────────────────┤
│   DISC-1    │      1 - 5      │             0%              │
├─────────────┼─────────────────┼─────────────────────────────┤
│   DISC-2    │     6 - 10      │            10%              │
├─────────────┼─────────────────┼─────────────────────────────┤
│   DISC-3    │    11 - 20      │            20%              │
├─────────────┼─────────────────┼─────────────────────────────┤
│   DISC-4    │   21 o más      │            30%              │
└─────────────┴─────────────────┴─────────────────────────────┘
```

**Caso aplicado:** En la tienda en línea de la cervecería, pedidos con más de dos botellas pagan $190 MXN más un incremento proporcional al peso total de las botellas.

---

## 4. Recomendaciones para elicitar y documentar reglas

1. Identificar la fuente (ley, política interna, estándar técnico).
2. Clasificar la regla según el tipo descrito en la sección 3.
3. Trazar la regla hacia los requerimientos afectados.
4. Representar restricciones y cálculos en matrices o tablas cuando aplique.
5. Validar con los dueños del proceso y responsables legales/regulatorios.

---

## 5. Conclusiones

- Las reglas de negocio ocupan el nivel más alto de la jerarquía de requisitos y condicionan el resto de especificaciones.
- Comprender su influencia permite diseñar sistemas alineados con normativas y políticas organizacionales.
- Documentar hechos, restricciones, activadores, inferencias y cálculos en formatos estructurados mejora la trazabilidad y la implementación técnica.

---

## 6. Cómo asegurar su aplicación en cada iniciativa

Para garantizar que las reglas de negocio se apliquen **siempre**, se establecen los siguientes mecanismos de aseguramiento:

1. **Checklist obligatoria en el DoR/DoD**: todo ítem en el backlog debe pasar por una lista de verificación que incluya la identificación, clasificación y trazabilidad de las reglas de negocio involucradas.
2. **Plantilla de especificación**: los artefactos de requisitos (historias de usuario, casos de uso, especificaciones) deben incorporar un campo obligatorio para registrar la regla de negocio que respalda cada comportamiento o restricción.
3. **Trazabilidad bidireccional**: mantener relaciones entre reglas de negocio, requerimientos y casos de prueba en la herramienta ALM (por ejemplo, Jira + Xray) para comprobar cobertura total.
4. **Revisión cruzada**: los analistas de negocio y los responsables regulatorios deben revisar y aprobar los entregables donde se documentan reglas de negocio antes de su implementación.
5. **Validación en pruebas**: los planes de prueba funcional y de aceptación deben incluir escenarios que verifiquen explícitamente el cumplimiento de cada regla de negocio.
6. **Monitoreo continuo**: registrar indicadores de cumplimiento (KPIs) que alerten cuando una regla de negocio cambie o se incumpla en producción y activar el proceso de gestión de cambios.

> **Resultado esperado:** ninguna funcionalidad llega a producción sin evidencia documentada de que las reglas de negocio aplicables fueron identificadas, aprobadas, implementadas y validadas.

---
