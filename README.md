# Autor: Dr. José Juan Torres Martínez
# Docente de Ciencias Químicas
# Universidad Autónoma de San Luis Potosí (UASLP)
# México
#
# Material académico para estudiantes
# Repositorio genomics — Presentación y guía de uso (README)

# genomics

Curso de genómica en R, desde cero, en español: del control de calidad de las lecturas al ensamblaje, la evaluación con QUAST y BUSCO, la comparación con ANI, la anotación funcional y el uso de bases de datos locales y de KEGG para buscar genes y reconstruir rutas.

## Qué es este repositorio

La genómica estudia el genoma completo de un organismo. Un genoma no se lee de principio a fin: se secuencia en millones de lecturas cortas y después se reconstruye con un programa ensamblador. Este curso enseña ese camino completo: limpiar lecturas, ensamblarlas, evaluar el ensamblaje, anotar los genes y buscar en el genoma genes o rutas concretas.

Los ejemplos del curso usan los flujos de trabajo reales del laboratorio con *Chlorella vulgaris*: FastQC y Trim Galore para calidad y limpieza, ABySS, MEGAHIT, SPAdes y Unicycler para ensamblar, QUAST y BUSCO para evaluar, Kraken2 para clasificar, ANI para comparar con genomas de referencia, Funannotate y Prokka para anotar, y eggNOG-mapper y KAAS para la anotación funcional y KEGG.

### Datos públicos, desde cero

Los temas del curso son los del laboratorio, pero los datos no son los datos del laboratorio: todas las lecciones parten de datos de repositorios públicos (SRA, ENA, GenBank y otros), con su acceso y su forma de descarga indicados al inicio de cada lección. El curso empieza desde cero y es para quienes entran a estos temas por primera vez: primero se aprende cómo se empieza y con qué datos, se replica el flujo de trabajo del laboratorio con datos públicos, y después cada quien lo aplica a sus propios datos en privado. La lección 01 usa lecturas públicas de tres genomas bacterianos del estudio GAGE-B (SRA043447, SRA037376, SRR522244; Forouzan y colaboradores, 2017, J Microbiol Methods 143:32-37), y las lecciones 02 a 04 usan esas mismas lecturas públicas.

Cada lección explica un tema con definiciones y ejemplos, y termina con gráficos y con lo aprendido. Los gráficos se hacen en R con ggplot2 y se guardan en PNG a 300 dpi.

### Para quién es

Para estudiantes de ciencias químicas, biología y bioinformática que ya manejan lo básico de R (o que lo están aprendiendo en paralelo con los cursos de Introducción a R y Aprende R) y quieren analizar datos de secuenciación de un genoma.

No se necesita experiencia previa en genómica. Se necesita una computadora con R instalado y disposición para correr cada ejemplo y leer sus resultados.

## Requisitos

- R (versión 4.3 o posterior) y RStudio, o la terminal con Rscript.
- Paquetes de R: ggplot2, dplyr, readr, scales y tidyr. Se instalan con:
  `install.packages(c("ggplot2", "dplyr", "readr", "scales", "tidyr"))`
- Para las lecciones que usan herramientas de línea de comandos (FastQC, Trim Galore, ensambladores, QUAST, BUSCO, fastANI, BLAST+, Diamond, KAAS), se recomienda instalarlas con conda en un ambiente aparte. Cada lección indica qué herramienta usa y cómo se instala. Los análisis de ejemplo de las lecciones 01 a 03 se pueden seguir solo con R y los CSV de cada lección.

## Sin supercomputadora

Este curso corre en una computadora normal, sin supercomputadora: cada lección es un paso independiente, con datos públicos pequeños. La mayoría de los pasos (FastQC, BUSCO, ANI, BLAST, DESeq2) corren en laptop; el ensamblaje depende del organismo: virus y bacterias sí se ensamblan en laptop, eucariotas pequeños con más RAM o Colab Pro, y eucariotas grandes con Colab Pro por un mes o renta en la nube para ese paso. Los accesos gratuitos (Galaxy, Colab, KBase, eggNOG web, KAAS, NCBI BLAST), las herramientas y la guía de la computadora ideal para el laboratorio están en [ROADMAP.md](ROADMAP.md).

## Cómo usar las lecciones

### Orden recomendado

Las lecciones se siguen en orden, de la 01 a la 14, porque cada una usa lo aprendido en las anteriores. La ruta completa, lección por lección, está en [ROADMAP.md](ROADMAP.md).

### Organización de cada lección

Cada lección es un script `.R` con su nombre y su número, por ejemplo `01-de-lecturas-a-ensamblaje.R`. Junto al script van los archivos CSV con los datos de ejemplo de esa lección, por ejemplo `datos_quast.csv`.

El script se corre completo en RStudio (botón Source) o desde la terminal con:

```bash
Rscript 01-de-lecturas-a-ensamblaje.R
```

Al correrlo, el script imprime en la consola las tablas y los valores calculados, y guarda las figuras en archivos PNG en la misma carpeta. Cada figura lleva su sección de Interpretación dentro del script: qué muestra, qué es cada eje con sus unidades, qué patrón se ve y qué significa.

### Cómo practicar

Cada ejemplo está pensado para correrse y leerse, no para copiarse y pegarse sin mirar. Después de correr un script, conviene revisar lo que imprimió en la consola y abrir las figuras que generó, y comparar lo que se ve con lo que dice la Interpretación del script. Si algo no coincide, se revisa el código antes de seguir adelante.

## Resumen de la ruta

La ruta completa tiene 14 lecciones, en 5 bloques:

1. De lecturas a ensamblaje (01–04): comparar ensambladores con QUAST, FastQC y Trim Galore, los ensambladores, QUAST a fondo.
2. Calidad del ensamblaje (05–07): BUSCO, cobertura y profundidad, ANI con fastANI y pyANI.
3. Anotación (08–10): Funannotate y Prokka, eggNOG-mapper, genes candidatos y homología.
4. Bases de datos locales (11–12): makeblastdb y Diamond makedb, buscar genes y rutas con BLASTp y Diamond.
5. KEGG (13–14): KAAS y KEGG Mapper, pathview en R y reconstrucción de mapas.

El detalle de cada lección, qué enseña y qué sabrá hacer el alumno al terminarla está en [ROADMAP.md](ROADMAP.md).

## Relación con los otros cursos

Este curso forma parte de la serie de ómicas del laboratorio, junto con el curso de [RNA-seq](https://github.com/ozono7/RNA-seq) (transcriptómica) y el curso de [metagenomics](https://github.com/ozono7/metagenomics) (metagenómica).

Dos temas se enseñan aquí, en un solo lugar, para no repetirlos en los tres cursos: las bases de datos locales (bloque 4) y KEGG (bloque 5). El curso de RNA-seq enlaza a estos módulos desde su módulo 10, y el curso de metagenómica desde sus lecciones 11 y 12.

## Estado de las lecciones

- **Lista:** lección 01.
- **En preparación:** lecciones 02 a 14.
