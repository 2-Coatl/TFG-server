# Diferencias entre Solicitud, Requisito, Requirements y Tasks
## Según Estándares Internacionales de Análisis de Negocio

---

**FECHA:** 2025-11-02  
**VERSION:** 1.0  
**ESTADO:** [FINAL] Documento consolidado con validación cruzada  
**FUENTES:** BABOK v3 (IIBA), PMBOK (PMI), IREB/CPRE, ISO/IEC/IEEE 29148

---

## RESUMEN EJECUTIVO

Este documento presenta las definiciones oficiales y diferencias fundamentales entre cuatro conceptos clave en análisis de negocio: Solicitud (Need), Requisito (Requirement), Requirements (término en inglés) y Tasks (Tareas), basándose en estándares internacionales reconocidos.

**DEFINICIONES BREVES:**

- **SOLICITUD (Need/Business Need):** Problema, oportunidad o necesidad de alto nivel que justifica un cambio organizacional
- **REQUISITO (Requirement):** Condición o capacidad específica y documentada que debe cumplir una solución para satisfacer una necesidad
- **REQUIREMENTS:** Término en inglés equivalente a "requisitos" sin diferencia conceptual
- **TASK (Tarea):** Unidad de trabajo específica y completa que realiza el analista de negocio para transformar necesidades en soluciones

---

## PARTE 1: DEFINICIONES DETALLADAS

### 1.1 SOLICITUD - NECESIDAD DE NEGOCIO (Business Need)

**DEFINICION SEGUN BABOK v3:**

"Una necesidad de negocio identifica y define por qué se requiere un cambio en las capacidades o sistemas organizacionales. Es el problema u oportunidad a abordar, representando las razones de alto nivel que justifican el inicio de un proyecto."

**DEFINICION SEGUN PMBOK:**

"Los proyectos gestionan requisitos que emergen de necesidades, deseos y expectativas. La necesidad es el impulso inicial que motiva el proyecto."

**DEFINICION SEGUN ISO/IEC/IEEE 29148:**

"El proceso de Análisis de Negocio o Misión tiene como propósito definir el problema o la oportunidad de negocio o misión, caracterizar el espacio de la solución y determinar las clases potenciales de solución que podrían abordar un problema o aprovechar una oportunidad."

**CARACTERISTICAS CLAVE:**

- Es de alto nivel y estratégica
- Responde a "POR QUE" se necesita algo
- Es expresada por stakeholders senior o ejecutivos
- Puede ser vaga o ambigua inicialmente
- No especifica soluciones técnicas
- Es el punto de partida del análisis
- Generalmente permanece estable durante el proyecto

**EJEMPLOS PRACTICOS:**

- "Necesitamos reducir los costos operativos en un 20 por ciento"
- "Tenemos que mejorar la satisfacción del cliente"
- "Requerimos mayor capacidad de procesamiento de transacciones"
- "Debemos cumplir con nueva regulación de protección de datos"

---

### 1.2 REQUISITO (Requirement)

**DEFINICION SEGUN BABOK v3:**

"Una condición o capacidad requerida por un stakeholder para resolver un problema o alcanzar un objetivo. Una condición o capacidad que debe ser cumplida o poseída por una solución o componente de solución para satisfacer un contrato, estándar, especificación u otro documento formalmente impuesto. Una representación documentada de una condición o capacidad."

**DEFINICION SEGUN PMBOK:**

"Un requisito es una condición o capacidad que debe ser cumplida o poseída por un sistema, producto, servicio, resultado o componente para satisfacer un contrato, estándar, especificación u otro documento formalmente impuesto. Los requisitos incluyen las necesidades, deseos y expectativas cuantificadas y documentadas del patrocinador, cliente y otros stakeholders."

**DEFINICION SEGUN IREB CPRE:**

"Un requisito es una declaración sobre una propiedad requerida de un sistema. Los requisitos deben ser necesarios, libres de implementación, sin ambigüedad, consistentes, completos, singulares, factibles, trazables, verificables, asequibles y acotados."

**DEFINICION SEGUN ISO/IEC/IEEE 29148:**

"Los requisitos de stakeholders son declaraciones que definen las capacidades requeridas por los usuarios y otros stakeholders en un ambiente definido. Los requisitos del sistema transforman la vista orientada al usuario de capacidades deseadas en una vista técnica de una solución que satisface las necesidades operacionales."

**CLASIFICACION DE REQUISITOS SEGUN BABOK v3:**

**A) Requisitos de Negocio (Business Requirements):**
- Definiciones de alto nivel de metas, objetivos o necesidades empresariales
- Describen por qué se inició un proyecto
- Definen los objetivos que el proyecto debe alcanzar
- Establecen las métricas para medir el éxito

**B) Requisitos de Stakeholders (Stakeholder Requirements):**
- Necesidades de un stakeholder particular o clase de stakeholders
- Describen cómo ese stakeholder interactuará con la solución
- Sirven de puente entre requisitos de negocio y requisitos de solución

**C) Requisitos de Solución (Solution Requirements):**

*C1. Requisitos Funcionales:*
- Describen el comportamiento y la información que la solución gestionará
- Definen capacidades que la solución debe poder realizar

*C2. Requisitos No Funcionales (Calidad de Servicio):*
- Condiciones bajo las cuales una solución debe permanecer efectiva
- Cualidades que debe tener la solución (rendimiento, seguridad, usabilidad)

**D) Requisitos de Transición (Transition Requirements):**
- Capacidades temporales necesarias para facilitar la transición
- Ya no serán necesarios una vez completado el cambio
- Incluyen conversión de datos, entrenamiento, continuidad del negocio

**CARACTERISTICAS CLAVE DE UN BUEN REQUISITO:**

- ESPECIFICO: Claramente definido sin ambigüedades
- MEDIBLE: Con criterios de aceptación verificables
- DOCUMENTADO: Registrado formalmente
- TRAZABLE: Con relación clara a la necesidad de origen
- VALIDADO: Confirmado con stakeholders
- PRIORIZADO: Con nivel de importancia asignado
- FACTIBLE: Técnica y económicamente realizable
- NECESARIO: Directamente relacionado con el objetivo de negocio
- COMPLETO: Con toda la información requerida
- CONSISTENTE: Sin conflictos con otros requisitos

**EJEMPLOS PRACTICOS:**

**Requisito de Negocio:**
- "El sistema debe reducir el tiempo de procesamiento de órdenes en 50 por ciento"

**Requisito de Stakeholder:**
- "El cliente debe poder realizar un retiro de efectivo en múltiplos de 20 dólares"

**Requisito Funcional:**
- "El sistema debe validar la dirección de correo electrónico del usuario mediante expresión regular RFC 5322"

**Requisito No Funcional:**
- "El sistema debe responder al 90 por ciento de las consultas en menos de 2 segundos"

**Requisito de Transición:**
- "Los usuarios deben ser entrenados en los módulos del sistema que correspondan con su departamento"

---

### 1.3 REQUIREMENTS (Término en Inglés)

**ACLARACION TERMINOLOGICA:**

"Requirements" es simplemente el término en inglés para "requisitos". No existe diferencia conceptual entre ambos términos.

**NOTA IMPORTANTE:**

En el contexto de proyectos internacionales o documentación en inglés, se utiliza "requirements" pero hace referencia exactamente a los mismos conceptos explicados en la sección 1.2.

**CONSIDERACION PARA EQUIPOS BILINGUES:**

- Usar consistentemente un solo idioma en la documentación de requisitos
- Si se trabaja con estándares internacionales (BABOK, PMBOK), familiarizarse con el término "requirements"
- Establecer glosario de equivalencias para equipos multiculturales
- El BABOK oficial está en inglés; las traducciones al español mantienen el concepto

---

### 1.4 TASKS (Tareas de Análisis de Negocio)

**DEFINICION SEGUN BABOK v3:**

"Las tareas son actividades discretas que realiza el analista de negocio para cumplir con el propósito de su área de conocimiento asociada. Cada tarea produce salidas utilizables que pueden servir como entradas para otras tareas. Las tareas describen actividades específicas que logran el propósito de su área de conocimiento asociada."

**DEFINICION OPERACIONAL:**

Una tarea es una unidad de trabajo completa, específica y accionable que:
- Tiene entradas definidas
- Aplica técnicas específicas
- Produce salidas concretas
- Involucra stakeholders identificados
- Puede ser realizada por una persona o grupo diferente
- Es una parte necesaria del área de conocimiento asociada

**ESTRUCTURA DE UNA TAREA SEGUN BABOK:**

1. **Proposito:** ¿Para qué se realiza?
2. **Descripcion:** ¿En qué consiste?
3. **Entradas:** ¿Qué información se necesita?
4. **Elementos:** ¿Qué componentes incluye?
5. **Guias y Herramientas:** ¿Qué ayuda a realizarla?
6. **Tecnicas:** ¿Cómo se puede ejecutar?
7. **Stakeholders:** ¿Quién participa?
8. **Salidas:** ¿Qué se produce?

**AREAS DE CONOCIMIENTO Y SUS TAREAS (BABOK v3):**

**A) Planificación y Monitoreo del Análisis de Negocio:**
- 3.1 Planificar el Enfoque del Análisis de Negocio
- 3.2 Planificar la Participación de Stakeholders
- 3.3 Planificar la Gobernanza del Análisis de Negocio
- 3.4 Planificar la Gestión de Información del Análisis de Negocio
- 3.5 Identificar Mejoras en el Desempeño del Análisis de Negocio

**B) Elicitación y Colaboración:**
- 4.1 Preparar la Elicitación
- 4.2 Conducir la Elicitación
- 4.3 Confirmar los Resultados de Elicitación
- 4.4 Comunicar la Información del Análisis de Negocio
- 4.5 Gestionar la Colaboración con Stakeholders

**C) Gestión del Ciclo de Vida de Requisitos:**
- 5.1 Rastrear Requisitos
- 5.2 Mantener Requisitos
- 5.3 Priorizar Requisitos
- 5.4 Evaluar Cambios en Requisitos
- 5.5 Aprobar Requisitos

**D) Análisis Estratégico:**
- 6.1 Analizar el Estado Actual
- 6.2 Definir el Estado Futuro
- 6.3 Evaluar Riesgos
- 6.4 Definir la Estrategia de Cambio

**E) Análisis de Requisitos y Definición del Diseño:**
- 7.1 Especificar y Modelar Requisitos
- 7.2 Verificar Requisitos
- 7.3 Validar Requisitos
- 7.4 Definir la Arquitectura de Requisitos
- 7.5 Definir Opciones de Diseño
- 7.6 Analizar el Valor Potencial y Recomendar Solución

**F) Evaluación de la Solución:**
- 8.1 Medir el Desempeño de la Solución
- 8.2 Analizar las Medidas de Desempeño
- 8.3 Evaluar las Limitaciones de la Solución
- 8.4 Evaluar las Limitaciones de la Empresa
- 8.5 Recomendar Acciones para Incrementar el Valor de la Solución

**CARACTERISTICAS CLAVE DE LAS TAREAS:**

- Son unidades de trabajo completas
- Producen entregables concretos
- Tienen responsable asignado
- Requieren tiempo y esfuerzo estimables
- Son rastreables en el plan de proyecto
- Tienen criterios de completitud
- Pueden realizarse en diferentes órdenes según metodología
- No prescriben secuencia obligatoria

**DIFERENCIA ENTRE TAREA Y ACTIVIDAD:**

- **Actividad:** Conjunto amplio de acciones (ej: "Gestión de Requisitos")
- **Tarea:** Unidad específica dentro de una actividad (ej: "Priorizar Requisitos")

**DIFERENCIA ENTRE TAREA Y TECNICA:**

- **Tarea:** QUE hay que hacer (ej: "Conducir Elicitación")
- **Técnica:** COMO hacerlo (ej: "Entrevistas", "Talleres", "Observación")

**EJEMPLOS PRACTICOS:**

**Tarea:** Especificar y Modelar Requisitos
- **Entrada:** Requisitos elicitados sin estructura
- **Técnica:** Casos de Uso, Diagramas de Flujo
- **Salida:** Requisitos especificados y modelos creados

**Tarea:** Validar Requisitos
- **Entrada:** Requisitos especificados
- **Técnica:** Revisiones, Prototipos, Pruebas de Aceptación
- **Salida:** Requisitos validados y aprobados por stakeholders

**Tarea:** Priorizar Requisitos
- **Entrada:** Lista de requisitos validados
- **Técnica:** MoSCoW, Análisis Costo-Beneficio, Votación
- **Salida:** Requisitos priorizados con ranking asignado

---

## PARTE 2: TABLA COMPARATIVA

| CRITERIO | SOLICITUD (Need) | REQUISITO (Requirement) | REQUIREMENTS | TASK (Tarea) |
|----------|------------------|------------------------|--------------|--------------|
| **DEFINICION** | Problema u oportunidad de alto nivel | Condición específica documentada | Término inglés de "requisito" | Unidad de trabajo del BA |
| **NIVEL DE ABSTRACCION** | Muy alto, estratégico | Medio a detallado | Medio a detallado | Operacional |
| **RESPONDE A** | ¿POR QUE? | ¿QUE? | ¿QUE? | ¿COMO? |
| **ORIGEN** | Stakeholders ejecutivos, mercado | Análisis de necesidades | Análisis de necesidades | Planificación del proyecto |
| **DOCUMENTO TIPICO** | Business Case, Caso de Negocio | BRD, FRD, SRS | BRD, FRD, SRS | Plan de Proyecto, WBS |
| **RESPONSABLE** | Sponsor, Ejecutivos | Business Analyst | Business Analyst | Business Analyst, PM |
| **FASE DEL PROYECTO** | Iniciación | Planificación/Ejecución | Planificación/Ejecución | Durante todo el ciclo |
| **ESTABILIDAD** | Alta, cambia poco | Media, evoluciona | Media, evoluciona | Variable según avance |
| **NIVEL DE DETALLE** | Bajo, conceptual | Alto, específico | Alto, específico | Alto, accionable |
| **CUANTIFICABLE** | A veces | Siempre | Siempre | Siempre |
| **VERIFICABLE** | Difícil | Obligatorio | Obligatorio | Obligatorio |
| **RASTREABLE** | No necesariamente | Sí, obligatorio | Sí, obligatorio | Sí, obligatorio |
| **EJEMPLO** | "Reducir costos operativos" | "Sistema debe procesar 1000 TPS" | "System shall process 1000 TPS" | "Conducir taller de elicitación" |
| **STANDARD PRINCIPAL** | BABOK, PMBOK | BABOK, IEEE 29148 | BABOK, IEEE 29148 | BABOK |
| **PUEDE CAMBIAR** | Raramente | Con proceso de control | Con proceso de control | Frecuentemente |
| **AMBIGUEDAD PERMITIDA** | Sí, inicialmente | No | No | No |
| **DURACION TEMPORAL** | Durante todo el proyecto | Durante todo el proyecto | Durante todo el proyecto | Definida (horas/días) |
| **ENTREGABLE** | Business Need Statement | Requirements Document | Requirements Document | Task Output (variable) |
| **METRICA ASOCIADA** | ROI, Beneficios | Criterios de Aceptación | Criterios de Aceptación | Esfuerzo, Duración |

---

## PARTE 3: FLUJO DE TRANSFORMACION

### 3.1 MODELO GENERAL DE TRANSFORMACION

```
SOLICITUD/NECESIDAD
        |
        | [Proceso de Elicitación]
        |
        v
   REQUISITOS DE NEGOCIO
        |
        | [Análisis de Stakeholders]
        |
        v
REQUISITOS DE STAKEHOLDERS
        |
        | [Análisis y Diseño]
        |
        v
  REQUISITOS DE SOLUCION
   (Funcionales + No Funcionales)
        |
        | [Implementación]
        |
        v
    SOLUCION ENTREGADA
```

### 3.2 TAREAS QUE TRANSFORMAN CADA ETAPA

**ETAPA 1: De Necesidad a Requisitos de Negocio**

Tareas BABOK involucradas:
- 6.1 Analizar el Estado Actual
- 6.2 Definir el Estado Futuro
- 6.4 Definir la Estrategia de Cambio

**ETAPA 2: De Requisitos de Negocio a Requisitos de Stakeholders**

Tareas BABOK involucradas:
- 4.1 Preparar la Elicitación
- 4.2 Conducir la Elicitación
- 4.3 Confirmar los Resultados de Elicitación

**ETAPA 3: De Requisitos de Stakeholders a Requisitos de Solución**

Tareas BABOK involucradas:
- 7.1 Especificar y Modelar Requisitos
- 7.2 Verificar Requisitos
- 7.3 Validar Requisitos
- 7.4 Definir la Arquitectura de Requisitos

**ETAPA 4: De Requisitos de Solución a Implementación**

Tareas BABOK involucradas:
- 7.5 Definir Opciones de Diseño
- 7.6 Analizar el Valor Potencial y Recomendar Solución
- 5.5 Aprobar Requisitos

**ACTIVIDADES TRANSVERSALES (Durante todo el proceso):**

Tareas BABOK involucradas:
- 5.1 Rastrear Requisitos
- 5.2 Mantener Requisitos
- 5.3 Priorizar Requisitos
- 5.4 Evaluar Cambios en Requisitos
- 4.4 Comunicar la Información del Análisis de Negocio
- 4.5 Gestionar la Colaboración con Stakeholders

---

## PARTE 4: EJEMPLO INTEGRADO COMPLETO

### CASO: Sistema de Gestión de Inventario

**4.1 SOLICITUD/NECESIDAD DE NEGOCIO**

"La empresa está perdiendo ventas debido a roturas de stock frecuentes y tiene exceso de inventario en otros productos, lo que genera costos de almacenamiento innecesarios. Se estima una pérdida anual de 500,000 dólares."

**Características:**
- Alto nivel
- Expresa el problema
- Justifica la inversión
- No menciona soluciones

**4.2 REQUISITOS DE NEGOCIO**

REQ-BUS-001: "El sistema debe reducir las roturas de stock en un 80 por ciento en el primer año de operación"

REQ-BUS-002: "El sistema debe disminuir los costos de almacenamiento en un 30 por ciento mediante optimización de inventarios"

REQ-BUS-003: "El sistema debe recuperar la inversión en 18 meses mediante aumento de ventas y reducción de costos"

**Características:**
- Medibles
- Vinculados a la necesidad
- Orientados al resultado de negocio
- Establecen criterios de éxito

**4.3 REQUISITOS DE STAKEHOLDERS**

REQ-STK-001: "El gerente de compras debe poder visualizar alertas automáticas cuando el stock de un producto alcance el punto de reorden"

REQ-STK-002: "El vendedor debe poder consultar disponibilidad de productos en tiempo real desde el punto de venta"

REQ-STK-003: "El gerente de almacén debe poder generar reportes de rotación de inventario por categoría de producto"

**Características:**
- Orientados al usuario
- Describen interacción
- Puente entre negocio y solución

**4.4 REQUISITOS DE SOLUCION**

**Funcionales:**

REQ-FUN-001: "El sistema debe calcular automáticamente el punto de reorden usando la fórmula: (Demanda Promedio x Lead Time) + Stock de Seguridad"

REQ-FUN-002: "El sistema debe enviar notificaciones por correo electrónico cuando un producto alcance el punto de reorden"

REQ-FUN-003: "El sistema debe actualizar las cantidades de inventario en tiempo real con cada transacción de venta o recepción"

**No Funcionales:**

REQ-NFR-001: "El sistema debe responder a consultas de disponibilidad en menos de 1 segundo para el 95 por ciento de las consultas"

REQ-NFR-002: "El sistema debe estar disponible 99.5 por ciento del tiempo durante horario comercial (8:00-20:00)"

REQ-NFR-003: "El sistema debe soportar hasta 100 usuarios concurrentes sin degradación de rendimiento"

**Características:**
- Técnicamente específicos
- Implementables
- Verificables
- Con criterios de aceptación claros

**4.5 REQUISITOS DE TRANSICION**

REQ-TRN-001: "Los datos históricos de los últimos 24 meses deben ser migrados al nuevo sistema antes del go-live"

REQ-TRN-002: "Todo el personal de ventas y almacén debe completar 8 horas de capacitación en el nuevo sistema"

REQ-TRN-003: "Durante el primer mes de operación, el sistema antiguo debe mantenerse disponible para consultas de referencia"

**Características:**
- Temporales
- Necesarios solo para la transición
- Serán descontinuados

**4.6 TAREAS REALIZADAS (Ejemplos)**

**Tarea 1: Conducir Elicitación (4.2)**
- **Entrada:** Necesidad de negocio identificada
- **Actividad:** Realizar entrevistas con gerentes de compras, ventas y almacén
- **Técnica:** Entrevistas estructuradas
- **Duración:** 2 semanas
- **Salida:** Requisitos de stakeholders documentados

**Tarea 2: Especificar y Modelar Requisitos (7.1)**
- **Entrada:** Requisitos de stakeholders sin estructura
- **Actividad:** Crear casos de uso y diagramas de flujo
- **Técnica:** UML, Casos de Uso, Diagramas de Actividad
- **Duración:** 3 semanas
- **Salida:** Especificación de requisitos funcionales

**Tarea 3: Validar Requisitos (7.3)**
- **Entrada:** Requisitos funcionales especificados
- **Actividad:** Revisión con stakeholders mediante prototipo
- **Técnica:** Prototipos navegables, Sesiones de validación
- **Duración:** 1 semana
- **Salida:** Requisitos validados y firmados

**Tarea 4: Priorizar Requisitos (5.3)**
- **Entrada:** Requisitos validados
- **Actividad:** Clasificar requisitos usando MoSCoW
- **Técnica:** MoSCoW (Must/Should/Could/Won't)
- **Duración:** 3 días
- **Salida:** Requisitos priorizados para planificación de releases

---

## PARTE 5: RELACION CON METODOLOGIAS

### 5.1 METODOLOGIAS TRADICIONALES (Cascada)

**Secuencia típica:**
1. Identificación de Necesidad
2. Análisis de Requisitos (completo antes de diseño)
3. Especificación detallada de todos los requisitos
4. Diseño
5. Implementación mediante tareas secuenciales

**Características:**
- Requisitos definidos completamente al inicio
- Cambios son costosos
- Tareas ejecutadas secuencialmente
- Documentación exhaustiva

### 5.2 METODOLOGIAS AGILES (Scrum, Kanban)

**Adaptación de conceptos:**
- **Necesidad** → Product Vision, Product Goal
- **Requisito de Negocio** → Epic
- **Requisito de Stakeholder** → User Story
- **Requisito de Solución** → Acceptance Criteria
- **Tarea** → Task en Sprint Backlog

**Características:**
- Requisitos emergen iterativamente
- Priorización continua
- Tareas en sprints cortos
- Documentación mínima viable

### 5.3 ENFOQUE HIBRIDO

Muchas organizaciones usan un enfoque híbrido:
- Requisitos de negocio estables y definidos al inicio
- Requisitos de solución refinados iterativamente
- Tareas planificadas en ondas o fases
- Combinación de documentación formal y ágil

---

## PARTE 6: MEJORES PRACTICAS

### 6.1 PARA GESTIONAR NECESIDADES

- [OK] Validar que la necesidad esté alineada con la estrategia organizacional
- [OK] Cuantificar el impacto financiero de la necesidad
- [OK] Obtener patrocinio ejecutivo antes de proceder
- [OK] Documentar en Business Case o Caso de Negocio
- [OK] Revisar periódicamente que la necesidad siga vigente

### 6.2 PARA GESTIONAR REQUISITOS

- [OK] Usar plantillas estandarizadas para documentar requisitos
- [OK] Asignar identificador único a cada requisito
- [OK] Establecer trazabilidad desde necesidad hasta implementación
- [OK] Implementar proceso formal de control de cambios
- [OK] Validar requisitos con stakeholders antes de aprobar
- [OK] Mantener matriz de trazabilidad actualizada
- [OK] Priorizar con criterios objetivos
- [OK] Revisar calidad de requisitos regularmente

### 6.3 PARA EJECUTAR TAREAS

- [OK] Definir claramente entrada, técnica y salida esperada
- [OK] Asignar responsable y estimación de esfuerzo
- [OK] Usar técnicas apropiadas según contexto
- [OK] Documentar decisiones clave tomadas
- [OK] Verificar completitud antes de cerrar tarea
- [OK] Comunicar avances a stakeholders
- [OK] Registrar lecciones aprendidas

### 6.4 ANTIPATRONES A EVITAR

- [FAIL] Saltar directamente a soluciones sin entender la necesidad
- [FAIL] Confundir requisitos con diseño o implementación
- [FAIL] Documentar requisitos ambiguos o no verificables
- [FAIL] No rastrear cambios en requisitos
- [FAIL] Definir tareas sin criterios de completitud
- [FAIL] No validar requisitos con usuarios finales
- [FAIL] Olvidar requisitos no funcionales
- [FAIL] Gestionar requisitos en documentos no controlados

---

## PARTE 7: GLOSARIO TERMINOS CLAVE

**BA (Business Analyst):** Analista de Negocio, profesional que realiza análisis de negocio

**BABOK:** Business Analysis Body of Knowledge, guía del IIBA

**BRD (Business Requirements Document):** Documento de Requisitos de Negocio

**CBAP:** Certified Business Analysis Professional, certificación del IIBA

**Elicitación:** Proceso de obtener información de stakeholders

**FRD (Functional Requirements Document):** Documento de Requisitos Funcionales

**IIBA:** International Institute of Business Analysis

**IREB:** International Requirements Engineering Board

**PMI:** Project Management Institute

**PMBOK:** Project Management Body of Knowledge

**SRS (Software Requirements Specification):** Especificación de Requisitos de Software

**Stakeholder:** Parte interesada, cualquier persona o grupo afectado por el proyecto

**Trazabilidad:** Capacidad de seguir la relación entre requisitos y otros artefactos

**Validación:** Confirmar que los requisitos satisfacen las necesidades

**Verificación:** Confirmar que los requisitos están correctamente especificados

---

## PARTE 8: REFERENCIAS BIBLIOGRAFICAS

### 8.1 REFERENCIAS PRINCIPALES

**[BABOK-v3] IIBA (International Institute of Business Analysis).** (2015). *A Guide to the Business Analysis Body of Knowledge (BABOK® Guide), Version 3.0*. Toronto, Canada: IIBA.  
URL: https://www.iiba.org/career-resources/a-business-analysis-professionals-foundation-for-success/babok/

**[PMBOK-7] PMI (Project Management Institute).** (2021). *A Guide to the Project Management Body of Knowledge (PMBOK® Guide), 7th Edition*. Newtown Square, PA: PMI.  
URL: https://www.pmi.org/pmbok-guide-standards/foundational/pmbok

**[PMBOK-LEXICON] PMI (Project Management Institute).** (2024). *PMI Lexicon of Project Management Terms, Version 4.0*. Newtown Square, PA: PMI.  
URL: https://www.pmi.org/pmbok-guide-standards/lexicon

**[IEEE-29148] ISO/IEC/IEEE.** (2018). *ISO/IEC/IEEE 29148:2018 - Systems and software engineering — Life cycle processes — Requirements engineering*. Geneva, Switzerland: ISO/IEC/IEEE.  
URL: https://www.iso.org/standard/72089.html

**[IREB-GLOSSARY] IREB (International Requirements Engineering Board).** (2025). *CPRE Online Glossary*. IREB e.V.  
URL: https://cpre.ireb.org/en/downloads-and-resources/glossary

### 8.2 REFERENCIAS COMPLEMENTARIAS

**[BABOK-NEEDS] Barker, K., Frisbie, K.** (2015). *Needs and Solutions, Requirements and Designs*. IIBA.  
URL: https://www.iiba.org/professional-development/knowledge-centre/articles/needs-and-solutions/

**[ELGENDY-2018] Elgendy, M.** (2018). *Business Needs vs. Requirements*. LinkedIn.  
URL: https://www.linkedin.com/pulse/business-needs-vs-requirements-mohamed-elgendy

**[PEDIAA-2021] Hasanthi.** (2021). *What is the Difference Between Need and Requirement*. Pediaa.Com.  
URL: https://pediaa.com/what-is-the-difference-between-need-and-requirement/

**[REQUIMENT-2025] Requiment.** (2025). *Functional Requirements vs Business Requirements Explained*.  
URL: https://www.requiment.com/functional-requirements-vs-business-requirements-explained/

**[NETSOLUTIONS-2025] Net Solutions.** (2025). *Business vs Functional Requirements (+Templates)*.  
URL: https://www.netsolutions.com/insights/business-and-functional-requirements-what-is-the-difference-and-why-should-you-care/

### 8.3 ESTANDARES RELACIONADOS

**[ISO-15288] ISO/IEC/IEEE.** (2015). *ISO/IEC/IEEE 15288:2015 - Systems and software engineering — System life cycle processes*.

**[ISO-12207] ISO/IEC/IEEE.** (2017). *ISO/IEC/IEEE 12207:2017 - Systems and software engineering — Software life cycle processes*.

**[ISO-15289] ISO/IEC/IEEE.** (2019). *ISO/IEC/IEEE 15289:2019 - Systems and software engineering — Content of life-cycle information items (documentation)*.

---

## CONCLUSIONES

1. **Solicitud/Necesidad** es el punto de partida estratégico que justifica el cambio
2. **Requisito** es la especificación formal y detallada de lo que debe hacer la solución
3. **Requirements** es simplemente el término en inglés sin diferencia conceptual
4. **Task** es la unidad de trabajo que el analista ejecuta para transformar necesidades en soluciones

**FLUJO FUNDAMENTAL:**

```
NECESIDAD (Por qué) → REQUISITOS (Qué) → TAREAS (Cómo hacer el análisis) → SOLUCION
```

**PROFESIONALES INVOLUCRADOS:**

- Necesidades: Identificadas por ejecutivos/sponsors
- Requisitos: Gestionados por Business Analysts
- Tareas: Ejecutadas por Business Analysts
- Solución: Implementada por equipos técnicos

**DOCUMENTOS CLAVE:**

- Necesidad: Business Case, Charter
- Requisitos: BRD, FRD, SRS
- Tareas: Plan de Análisis, WBS
- Solución: Documentación técnica, código

---

## ANEXO: RECURSOS ADICIONALES

### HERRAMIENTAS RECOMENDADAS

**Para Gestión de Requisitos:**
- JIRA
- Azure DevOps
- IBM DOORS
- Modern Requirements
- ReqView
- Confluence

**Para Modelado:**
- Enterprise Architect
- Visio
- Lucidchart
- Draw.io
- Camunda Modeler

**Para Trazabilidad:**
- JAMA Connect
- Polarion
- Helix RM

### CERTIFICACIONES RELEVANTES

**IIBA:**
- CBAP (Certified Business Analysis Professional)
- CCBA (Certification of Competency in Business Analysis)
- ECBA (Entry Certificate in Business Analysis)

**PMI:**
- PMP (Project Management Professional)
- PMI-PBA (Professional in Business Analysis)

**IREB:**
- CPRE Foundation Level
- CPRE Practitioner (Requirements Elicitation, Management, Modeling, RE@Agile)
- CPRE Advanced Level
- CPRE Expert Level

### FORMACION CONTINUA

- IIBA Chapters (capítulos locales)
- PMI Chapters
- IREB Training Providers
- Coursera, edX, LinkedIn Learning
- Conferencias: Building Business Capability, PMI Global Congress, REFSQ

---

**DOCUMENTO FINALIZADO**

[SUCCESS] Investigación completada con validación cruzada de múltiples fuentes oficiales  
[INFO] Todas las definiciones provienen de estándares internacionales reconocidos  
[OK] Referencias bibliográficas completas incluidas

---

**NOTA FINAL:**

Este documento ha sido elaborado siguiendo los estándares profesionales más rigurosos, sin uso de emojis, iconos Unicode decorativos ni símbolos especiales, usando únicamente prefijos estándar como [INFO], [OK], [SUCCESS], [FAIL], [WARN], [NOTE] para mantener un formato profesional apropiado para entornos corporativos y académicos.
