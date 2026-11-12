# Autor: Dr. José Juan Torres Martínez
# Docente de Ciencias Químicas
# Universidad Autónoma de San Luis Potosí (UASLP)
# México
#
# Material académico para estudiantes
# Repositorio genomics — Ruta de aprendizaje (ROADMAP)

# Ruta de aprendizaje: de lecturas a rutas

Esta es la ruta completa del curso, en orden. Cada lección usa lo aprendido en las anteriores, por lo que se siguen de la 01 a la 14 sin saltarse ninguna.

La guía de uso del repositorio, los requisitos y la forma de correr las lecciones están en [README.md](README.md).

## Datos públicos en todo el curso

Cada lección parte de datos de repositorios públicos, con su acceso y su forma de descarga indicados al inicio del script. La lección 01 usa lecturas públicas de tres genomas bacterianos del estudio GAGE-B (SRA043447, SRA037376, SRR522244; Forouzan y colaboradores, 2017), y las lecciones 02 a 04 usan esas mismas lecturas públicas. Las lecciones 05 a 14 usan datos públicos del mismo estudio o de otros repositorios públicos (GenBank, UniProt y otros); cada lección indica su acceso. Los flujos de trabajo son los del laboratorio, pero los datos son públicos: primero se replica el flujo con datos públicos y después se aplica a datos propios.

## Estado de las lecciones

- **Lista:** lección 01.
- **En preparación:** lecciones 02 a 14.

## Bloque 1. De lecturas a ensamblaje

Requisito previo: ninguno. Solo se necesita R con los paquetes indicados en el README.

### 01. De lecturas a ensamblaje: comparar ensambladores con QUAST — Lista

Qué es un ensamblaje, qué es un contig, qué miden QUAST, N50, NGA50, LGA50 y la fracción del genoma, y cómo se comparan nueve ensambladores (ABySS, Edena, IDBA-UD, MaSuRCA, Ray, SGA, SOAPdenovo2, SPAdes y Velvet) sobre lecturas públicas de tres genomas bacterianos del estudio GAGE-B (Forouzan y colaboradores, 2017).

Al terminar, el alumno sabrá leer una tabla de QUAST, calcular cuántas veces es mayor el N50 de un ensamblador que el de otro y cuánto cae el N50 al medirlo contra el genoma de referencia, y comparar ensambladores con gráficos.

### 02. Control de calidad: FastQC y Trim Galore — En preparación

Control de calidad con FastQC, qué se mira en un reporte (calidad por base, contenido de GC, adaptadores) y limpieza de lecturas con Trim Galore. Se usan las lecturas públicas de GAGE-B (SRA043447, SRA037376, SRR522244).

Al terminar, el alumno sabrá leer un reporte de FastQC y limpiar lecturas antes de ensamblar.

### 03. Los ensambladores: ABySS, MEGAHIT, SPAdes y Unicycler — En preparación

Cómo funciona cada ensamblador, en qué se diferencian sus estrategias y cuándo conviene cada uno. Se revisan los nueve ensambladores del estudio de referencia (SPAdes, IDBA-UD, ABySS, MEGAHIT, Velvet y los demás) y Unicycler, el ensamblador que usa el laboratorio para sus genomas.

Al terminar, el alumno sabrá elegir un ensamblador según el tipo de datos y correrlo sobre lecturas limpias.

### 04. QUAST a fondo: N50, N90, auN y L50 — En preparación

Qué mide cada métrica de QUAST, cómo se calculan N50 y L50 a mano con un ejemplo pequeño, y por qué mirar varias métricas juntas en lugar de una sola. Se trabaja con el reporte completo de QUAST de los ensamblajes públicos de GAGE-B.

Al terminar, el alumno sabrá calcular N50 y L50, explicar qué mide cada métrica y decidir entre dos ensamblajes con varias métricas a la vez.

## Bloque 2. Calidad del ensamblaje

Requisito previo: lecciones 01 a 04.

### 05. BUSCO: completitud del genoma — En preparación

Qué es BUSCO, qué son los genes ortólogos de copia única, qué significan completo, duplicado, fragmentado y ausente, y cómo se lee un resultado de BUSCO. Se evalúan los ensamblajes públicos de GAGE-B.

Al terminar, el alumno sabrá evaluar la completitud de un ensamblaje con BUSCO y leer qué proporción de genes esperados está completa.

### 06. Cobertura y profundidad — En preparación

Qué es la cobertura, cómo se calcula la profundidad de secuenciación y qué relación hay entre cobertura, tamaño del genoma y calidad del ensamblaje. Se calcula con las lecturas públicas de GAGE-B.

Al terminar, el alumno sabrá calcular la cobertura de un ensamblaje y explicar qué dice sobre su calidad.

### 07. ANI: identidad con fastANI y pyANI — En preparación

Qué es la identidad promedio de nucleótidos (ANI), cómo se calcula con fastANI y pyANI, qué significa un ANI de 95 por ciento y cómo se usa para comparar un ensamblaje con genomas de referencia. Se comparan los ensamblajes públicos de GAGE-B con sus genomas de referencia de GenBank.

Al terminar, el alumno sabrá comparar su ensamblaje con genomas de referencia usando ANI y leer una matriz de identidad.

## Bloque 3. Anotación

Requisito previo: lecciones 01 a 07.

### 08. Anotación con Funannotate y Prokka — En preparación

Predecir genes, qué hace Funannotate con GeneMark y Augustus, qué hace Prokka, y cómo se comparan sus resultados. Se anotan los ensamblajes públicos de GAGE-B.

Al terminar, el alumno sabrá anotar un ensamblaje y obtener sus genes predichos y sus proteínas.

### 09. eggNOG-mapper: COG, GO y KEGG — En preparación

Anotar con eggNOG-mapper, qué son las categorías COG, los términos GO y los KO de KEGG, y cómo se resume una anotación funcional en gráficos. Se anotan proteínas públicas de los genomas de GAGE-B.

Al terminar, el alumno sabrá anotar funcionalmente un conjunto de proteínas y resumir sus categorías COG y GO.

### 10. Genes candidatos: homología y qué significa un hit — En preparación

Qué es un hit de BLASTp, qué significan identidad, cobertura y valor E, y qué se puede decir y qué no se puede decir a partir de un hit: presencia de un gen candidato no es actividad medida. Se buscan genes candidatos en proteínas públicas de UniProt.

Al terminar, el alumno sabrá buscar genes candidatos por homología y explicar qué significa cada columna de un resultado de BLASTp.

## Bloque 4. Bases de datos locales

Requisito previo: lecciones 01 a 10. Este bloque se enseña aquí, en un solo lugar: el curso de RNA-seq y el curso de metagenómica enlazan a estas lecciones en lugar de repetirlas.

### 11. Crear bases de datos locales: makeblastdb y Diamond makedb — En preparación

Qué es una base de datos local, cómo se construye con makeblastdb (BLAST+) y con Diamond makedb, y qué archivos se necesitan para cada una. Se construye con secuencias públicas descargadas de GenBank y UniProt.

Al terminar, el alumno sabrá construir una base de datos local con sus propias secuencias, lista para buscar en ella.

### 12. Buscar genes y rutas específicas con BLASTp y Diamond — En preparación

Buscar un gen concreto en una base local con BLASTp y con Diamond, filtrar por identidad y cobertura, y buscar todos los genes de una ruta a la vez. Se busca en la base local de secuencias públicas construida en la lección 11.

Al terminar, el alumno sabrá buscar un gen o una ruta completa en su base de datos local y leer sus resultados.

## Bloque 5. KEGG

Requisito previo: lecciones 01 a 12. Este bloque se enseña aquí, en un solo lugar: el curso de RNA-seq y el curso de metagenómica enlazan a estas lecciones en lugar de repetirlas.

### 13. KAAS y KEGG Mapper: asignar KO y reconstruir mapas — En preparación

Asignar KO con KAAS, reconstruir mapas con KEGG Mapper y leer un mapa reconstruido. Los ejemplos usan rutas del trabajo del laboratorio, como ko00910 (metabolismo del nitrógeno) y ko00030 (vía de las pentosas fosfato), reconstruidas a partir de anotaciones públicas. La pertenencia a un mapa es anotación, no actividad medida: que un gen esté anotado en una ruta no dice que la ruta esté activa.

Al terminar, el alumno sabrá asignar KO con KAAS y reconstruir un mapa KEGG con KEGG Mapper.

### 14. pathview en R: dibujar rutas con tus datos — En preparación

Dibujar rutas KEGG en R con pathview, colorear los genes por su valor (expresión, presencia o abundancia) y preparar un mapa listo para una figura. Se dibuja con los KO públicos asignados en la lección 13.

Al terminar, el alumno sabrá generar un mapa KEGG con pathview a partir de sus propios datos y leer qué genes de la ruta están presentes.

## Qué se podrá hacer al terminar el curso

Al terminar las 14 lecciones, el alumno podrá:

- Pasar de lecturas a ensamblaje: controlar la calidad, limpiar, ensamblar con varios programas y comparar con QUAST.
- Evaluar un ensamblaje: usar BUSCO, cobertura y ANI para decir qué tan completo está y a qué se parece.
- Anotar un genoma: usar Funannotate, Prokka y eggNOG-mapper, y buscar genes candidatos por homología.
- Construir y usar bases de datos locales: crear bases con makeblastdb y Diamond, y buscar en ellas genes y rutas.
- Trabajar con KEGG: asignar KO con KAAS, reconstruir mapas con KEGG Mapper y dibujarlos con pathview en R.
