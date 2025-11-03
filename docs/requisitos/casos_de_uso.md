# Casos de Uso en Ingeniería de Requerimientos

## 1. Definición y Contexto

Un **caso de uso** describe una secuencia de interacciones entre un sistema y un actor que permite alcanzar un resultado de valor para dicho actor. Constituye una visión funcional centrada en el usuario y en el comportamiento observable del sistema.

### Historia

Los casos de uso fueron introducidos en 1986 por **Ivar Jacobson**, uno de los principales impulsores del Lenguaje Unificado de Modelado (UML) y del Proceso Unificado.

### Casos de uso vs. Escenarios

- **Caso de uso**: descripción completa de cómo un actor del mundo real interactúa con el sistema para alcanzar un objetivo específico.
- **Escenario**: instancia particular del caso de uso (también llamado flujo o curso) que narra paso a paso la interacción actor–sistema.

Un caso de uso agrupa múltiples escenarios (curso normal y cursos alternos).

---

## 2. Especificar vs. Ilustrar

> **Advertencia frecuente:** los casos de uso son **documentos de texto**. Los diagramas UML de casos de uso son solo una representación visual complementaria.

- **Especificar casos de uso** implica redactar los pasos de los escenarios.
- **Modelar diagramas de casos de uso** (UML) consiste en ilustrar actores, casos de uso y relaciones en una “fotografía” del sistema.

Ambos artefactos se complementan, pero responden a objetivos distintos.

---

## 3. Enfoque para Desarrollo

Los desarrolladores implementan **requisitos funcionales** que habilitan la ejecución de los casos de uso. Para un entendimiento completo, necesitan vistas adicionales además de la especificación textual:

- Diagramas de actividades y de procesos.
- Diagramas de clases y de objetos.
- Modelos de datos y estructura de base de datos.
- Otros artefactos de diseño técnico.

Los casos de uso siempre se redactan desde la **perspectiva del usuario**, describiendo únicamente el comportamiento visible del sistema.

---

## 4. Nomenclatura Obligatoria

Los nombres de los casos de uso se escriben en formato **verbo + objeto** (acción + objeto). Ejemplos basados en un kiosco de registro aeroportuario:

1. **Registrar vuelo** (o *Hacer check-in*).
2. **Imprimir pases de abordar**.
3. **Cambiar asientos**.
4. **Registrar equipaje**.
5. **Comprar actualización de asiento**.

Cada caso de uso contendrá los escenarios que describen cómo se alcanza el objetivo.

---

## 5. Elementos Fundamentales

### 5.1 Actores

Un **actor** es cualquier entidad (persona, sistema externo, hardware, base de datos) que interactúa con el sistema para ejecutar un caso de uso.

Buenas prácticas:

- Capitalizar los nombres de actores en la especificación.
- Identificar **actores primarios** (disparan/ejecutan el caso de uso) y **actores secundarios** (proveen servicios o soporte).

### 5.2 Escenarios

Un **escenario** es una secuencia específica de pasos entre actores y sistema. Características:

- Relata una historia particular del uso del sistema.
- Recorre un camino específico dentro del caso de uso.
- También se denomina **instancia del caso de uso**.

---

## 6. Formatos y Grados de Formalidad

### 6.1 Principio "Qué" vs. "Cómo"

Los escenarios deben especificar **qué** hace el sistema, nunca **cómo** lo implementa.

- ✅ Correcto: “El sistema guarda una venta”.
- ❌ Incorrecto: “El sistema ejecuta un `INSERT` en una base de datos SQL”.

### 6.2 Niveles de formalidad

1. **Breve**: párrafo resumido del escenario principal.
2. **Casual**: descripción informal de múltiples escenarios.
3. **Completo**: incluye todos los pasos, variaciones, condiciones previas y garantías.

En este repositorio se trabaja con especificaciones **completas**.

---

## 7. Formato de Dos Columnas (Ejemplo UC-001)

| Acciones del actor | Responsabilidades del sistema |
| --- | --- |
| 1. El cliente llega al punto de venta con los bienes o servicios a comprar. | |
| 2. El cajero inicia una nueva venta. | |
| 3. El cajero ingresa el identificador del artículo. | 4. El sistema registra el artículo y muestra descripción y subtotal. |
| \* El cajero repite los pasos 3 y 4. | |
| | 5. El sistema muestra el total con impuestos. |
| 6. El cajero informa el total y solicita método de pago. | |
| 7. El cliente paga. | 8. El sistema gestiona el tipo de pago. |

Este formato facilita visualizar la interacción alternada entre actor y sistema para el caso de uso **Procesar venta**.

---

## 8. Diagramas UML de Casos de Uso

Elementos principales:

- **Actores**: representados como figuras de palo.
- **Casos de uso**: óvalos con el nombre en formato verbo + objeto.
- **Relaciones**: líneas y flechas que indican interacción.
- **Límite del sistema**: rectángulo que enmarca los casos de uso.

Interpretación de flechas:

- De actor → caso de uso: el actor es **primario** y dispara el caso.
- De caso de uso → actor: el actor es **secundario** y brinda soporte.

Los diagramas proporcionan una vista estática complementaria a la especificación textual.

---

## 9. Resumen Conceptual

- Un caso de uso describe una actividad autónoma que produce un resultado de valor para un actor.
- Un caso de uso puede agrupar varios escenarios relacionados por un objetivo común.
- Un escenario es una historia específica (curso normal o alterno) dentro del caso de uso.

---

## 10. Información que Contiene una Especificación Completa

- **Actores**: primarios y secundarios relevantes.
- **Precondiciones**: estados que deben cumplirse antes de iniciar el escenario (puede haber cero o más).
- **Postcondiciones**: estado que debe cumplirse tras la finalización exitosa.
- **Curso normal (happy path)**: secuencia típica de éxito.
- **Cursos alternos**: caminos secundarios, con extensiones que incluyen condición detectable y pasos de manejo.
- **Excepciones**: casos que terminan el flujo o requieren manejo especial.
- **Requisitos especiales**: atributos de calidad o restricciones no funcionales específicos del caso.
- **Tecnología y variaciones de datos**: notas técnicas relevantes.
- **Reglas de negocio**: únicamente las que aplican directamente al caso.

Si una extensión es muy compleja, conviene dividirla en un caso de uso independiente y establecer la relación correspondiente.

---

## 11. Diagrama de Actividad de Referencia

Los diagramas de actividad muestran el flujo normal y los cursos alternativos. Elementos clave:

```
[Precondiciones]
   │
   ▼
Paso 1 → Paso 2 → ¿Condición?
                 ├─ Sí → Flujo alterno
                 └─ No → Flujo normal
                        ▼
                     Paso 4
                        │
                        ▼
                 [Postcondiciones]
```

Las precondiciones son opcionales (0..n). Las postcondiciones capturan el estado final tras completar el caso de uso.

---

## 12. Ejemplo Completo: UC-04 Solicitar Producto Químico

**Identificador:** UC-04 (C4)  
**Nombre:** Solicitar producto químico  
**Creado por:** Flor  
**Fecha de creación:** *[definir]*  
**Actores primarios:** Solicitante  
**Actores secundarios:** Comprador, Base de datos  
**Descripción:** Permite que un solicitante registre la petición de un producto químico.  
**Disparador:** El solicitante inicia una solicitud de producto químico.

### Condiciones

- **Precondiciones:**
  - El solicitante está autenticado en el sistema.
  - Existe un catálogo de productos químicos disponible.
- **Postcondiciones:**
  - La solicitud queda registrada.
  - El comprador es notificado.

### Curso normal

1. El solicitante accede al módulo de solicitudes.
2. El sistema muestra el catálogo disponible.
3. El solicitante selecciona el producto deseado.
4. El sistema valida disponibilidad (**ver 4.1**).
5. El sistema muestra el total con información adicional.
6. El solicitante confirma la solicitud.
7. El sistema registra la solicitud.
8. El sistema notifica al comprador.

### Flujo alterno 4.1 – Producto no disponible

1. El sistema informa que el producto no está disponible.
2. El sistema sugiere alternativas.
3. El solicitante elige un producto alterno.
4. El flujo regresa al paso 5 del curso normal.

#### Excepción 4.1.1 – Producto no encontrado

1. El sistema muestra un error.
2. El sistema permite solicitar la inclusión del producto.
3. El caso de uso finaliza.

### Información adicional

- **Prioridad:** Alta.
- **Frecuencia de uso:** Diaria.
- **Reglas de negocio:** BR-28, BR-31.
- **Suposiciones:** Consultar la base de datos de reglas para trazabilidad.

---

## 13. Diagrama de Relaciones para UC-04 (Texto)

```
Solicitante ──▶ [Solicitar Producto Químico] ──▶ Comprador
                                   │
                                   └────▶ Base de datos
```

- El **Solicitante** es actor primario y dispara el caso.
- **Comprador** y **Base de datos** actúan como actores secundarios de soporte.

---

## 14. Conclusión

Los casos de uso son fundamentales para capturar requisitos funcionales desde la perspectiva del usuario. Una especificación completa aporta trazabilidad con reglas de negocio, articula cursos alternos y excepciones, y se complementa con diagramas UML y de actividad para apoyar el diseño y la implementación.
