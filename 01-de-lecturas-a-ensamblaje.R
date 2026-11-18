# ==========================================================================
# Lección 01. De lecturas a ensamblaje: comparar ensambladores con QUAST
# ==========================================================================
# Autor: Dr. José Juan Torres Martínez
# Docente de Ciencias Químicas
# Universidad Autónoma de San Luis Potosí (UASLP)
# México
#
# Material académico para estudiantes
# Serie "Genómica" — Lección 01
#
# Descripción: primera lección del curso de genómica. Un genoma no se lee
#   de principio a fin: se secuencia en millones de lecturas cortas y
#   después se reconstruye con un programa ensamblador. Hay varios
#   ensambladores y no todos dan el mismo resultado con las mismas
#   lecturas. En esta lección se comparan nueve ensambladores (ABySS,
#   Edena, IDBA-UD, MaSuRCA, Ray, SGA, SOAPdenovo2, SPAdes y Velvet)
#   con las métricas de QUAST, la herramienta que evalúa ensamblajes, y
#   se decide cuál conviene usar.
#
# Objetivos de aprendizaje:
#   - Explicar qué es un ensamblaje y qué es un contig.
#   - Leer una tabla de QUAST: contigs, N50, NGA50, LGA50, errores de
#     ensamblaje y fracción del genoma.
#   - Calcular cuántas veces es mayor el N50 de un ensamblador que el
#     de otro, y cuánto cae el N50 al medirlo contra el genoma de
#     referencia (NGA50).
#   - Comparar ensambladores con gráficos de barras.
#   - Explicar por qué un ensamblaje con menos contigs y mayor N50 es
#     un ensamblaje menos fragmentado, y por qué se miran varias
#     métricas juntas.
#
# Datos: datos_quast.csv, en esta misma carpeta. Son los resultados
#   publicados por Forouzan y colaboradores (2017) para tres genomas
#   bacterianos del estudio GAGE-B, evaluados con QUAST.
#   Forouzan E, Maleki MSM, Karkhane AA, Yakhchali B (2017). Evaluation
#   of nine popular de novo assemblers in microbial genome assembly.
#   J Microbiol Methods 143:32-37. doi:10.1016/j.mimet.2017.09.008.
#   PMID 28939423. Tabla 3 del artículo.
#
#   Cada valor es el promedio de los tres genomas, con cobertura
#   de alrededor de 100x:
#     Mycobacterium abscessus: 96x, GC 64 por ciento, lecturas de 100 pb
#     Rhodobacter sphaeroides 2.4.1: 126x, GC 69 por ciento, 101 pb
#     Vibrio cholerae: 88x, GC 48 por ciento, lecturas de 100 pb
#   Los datos de lecturas son del estudio GAGE-B (Magoc y colaboradores,
#   2013, Bioinformatics 29:1718-1725, doi:10.1093/bioinformatics/btt273,
#   PMC3702249).
#
#   Para descargar las lecturas con SRA Toolkit (corridas HiSeq):
#     fasterq-dump --split-files SRR315382
#     fasterq-dump --split-files SRR522244
#     fasterq-dump --split-files SRR227312
#   SRR315382 es Mycobacterium abscessus (estudio SRA043447),
#   SRR522244 es Rhodobacter sphaeroides 2.4.1 y SRR227312 es Vibrio
#   cholerae (estudio SRA037376). Las lecturas limpias y submuestreadas
#   a 100x están también en el sitio de GAGE-B: http://ccb.jhu.edu/gage_b
#   Genomas de referencia (GenBank): M. abscessus ATCC 19977 NC_010394;
#   R. sphaeroides 2.4.1 NC_007488, NC_007489, NC_007490, NC_007493,
#   NC_007494, NC_009007, NC_009008; V. cholerae N16961 NC_002505,
#   NC_002506.
#
#   Los nueve ensambladores evaluados en el artículo (con su versión):
#   ABySS 1.9.0, Edena V3.131028, IDBA-UD 1.1.3, MaSuRCA 3.2.1,
#   Ray 2.3.1, SGA v0.10.14, SOAPdenovo2, SPAdes 3.9.0 y Velvet 1.2.10.
#   Los comandos para reproducir la tabla son:
#     spades.py -1 lectura_1.fastq -2 lectura_2.fastq -o salida_spades
#     quast.py contigs.fasta -r referencia.fasta -o salida_quast
#   QUAST necesita el genoma de referencia para calcular NGA50, LGA50
#   y la fracción del genoma; sin referencia solo calcula N50 y L50.
# ==========================================================================

# --------------------------------------------------------------------------
# 1. Cargar paquetes
# --------------------------------------------------------------------------
library(ggplot2)
library(dplyr)
library(readr)
library(scales)

Sys.setlocale("LC_ALL", "C.UTF-8")

# Carpeta del script: los CSV y las figuras viven junto a este archivo.
args <- commandArgs(trailingOnly = FALSE)
archivo <- grep("--file=", args, value = TRUE)
if (length(archivo) > 0) {
  carpeta <- dirname(sub("--file=", "", archivo[1]))
} else {
  carpeta <- getwd()
}
setwd(carpeta)

# --------------------------------------------------------------------------
# 2. Del secuenciador al ensamblaje
# --------------------------------------------------------------------------
# El secuenciador produce lecturas: fragmentos cortos de ADN, de unos
# 100 pares de bases cada uno en estos datos. Ninguna lectura cubre el
# genoma completo, así que el ensamblaje busca las lecturas que se solapan
# y las junta en piezas más largas, llamadas contigs. Un contig es una
# secuencia continua reconstruida a partir de muchas lecturas.
#
# Hay varios programas ensambladores y cada uno usa una estrategia
# distinta. Con las mismas lecturas, ABySS, Edena, IDBA-UD, MaSuRCA,
# Ray, SGA, SOAPdenovo2, SPAdes y Velvet dan ensamblajes diferentes:
# distinto número de contigs, distinto tamaño total y distinta longitud
# de contigs. Por eso, antes de seguir con el análisis, se comparan con
# QUAST (Quality Assessment Tool for Genome Assemblies), que calcula las
# mismas métricas para cada ensamblaje.
#
# Las métricas de QUAST que se usan en esta lección son:
#   - contigs_500: número de contigs de 500 pares de bases o más.
#   - n50_kbp: la longitud del contig que queda en la mitad del
#     ensamblaje cuando se ordenan los contigs de mayor a menor, en
#     miles de pares de bases (kbp). Un N50 mayor indica un ensamblaje
#     menos fragmentado.
#   - nga50_kbp: lo mismo que el N50, pero medido contra el genoma de
#     referencia: los contigs se parten donde hay un error de
#     ensamblaje, así que el NGA50 siempre es menor o igual que el N50
#     y castiga a los ensambladores que juntan mal las lecturas.
#   - lga50: cuántos bloques alineados hay que sumar, de mayor a menor,
#     para llegar a la mitad del genoma de referencia. Un LGA50 menor
#     indica un ensamblaje menos fragmentado.
#   - misassemblies: número de errores de ensamblaje, es decir, de
#     lugares donde el contig junta dos partes del genoma que en
#     realidad no van juntas.
#   - genome_fraction_pct: qué porcentaje del genoma de referencia
#     cubre el ensamblaje. Un valor mayor indica un ensamblaje más
#     completo.
# QUAST también reporta N90, L50, auN y otras métricas en su reporte
# completo; en la lección 04 se calculan a mano con un ejemplo pequeño.

# --------------------------------------------------------------------------
# 3. Leer los datos
# --------------------------------------------------------------------------
# datos_quast.csv tiene las métricas de QUAST de los nueve ensambladores,
# todos sobre las mismas lecturas públicas de GAGE-B y con el mismo
# umbral de 500 pares de bases. Cada valor es el promedio de los tres
# genomas bacterianos.
quast <- read_csv("datos_quast.csv", show_col_types = FALSE)
print(quast)

# --------------------------------------------------------------------------
# 4. Calcular valores a partir de los datos
# --------------------------------------------------------------------------
# El ensamblador con el N50 mayor, el ensamblador con menos contigs y el
# ensamblador con el NGA50 mayor.
mejor_n50 <- quast %>% filter(n50_kbp == max(n50_kbp)) %>% pull(ensamblador)
menos_contigs <- quast %>% filter(contigs_500 == min(contigs_500)) %>% pull(ensamblador)
mejor_nga50 <- quast %>% filter(nga50_kbp == max(nga50_kbp)) %>% pull(ensamblador)
cat("Mayor N50:", mejor_n50, "\n")
cat("Menos contigs:", menos_contigs, "\n")
cat("Mayor NGA50:", mejor_nga50, "\n")

# Cuántas veces más contigs produce Edena que IDBA-UD, y cuántas veces
# es mayor el N50 de SPAdes que el de Edena y que el de Velvet.
cat("Contigs de Edena / contigs de IDBA-UD =",
    round(quast %>% filter(ensamblador == "Edena") %>% pull(contigs_500) /
          (quast %>% filter(ensamblador == "IDBA-UD") %>% pull(contigs_500)), 2), "\n")
cat("N50 de SPAdes / N50 de Edena =",
    round(quast %>% filter(ensamblador == "SPAdes") %>% pull(n50_kbp) /
          (quast %>% filter(ensamblador == "Edena") %>% pull(n50_kbp)), 2), "\n")
cat("N50 de SPAdes / N50 de Velvet =",
    round(quast %>% filter(ensamblador == "SPAdes") %>% pull(n50_kbp) /
          (quast %>% filter(ensamblador == "Velvet") %>% pull(n50_kbp)), 2), "\n")

# Cuánto cae el N50 al medirlo contra la referencia (de N50 a NGA50),
# en porcentaje, para SPAdes, IDBA-UD y Ray.
caida <- quast %>%
  filter(ensamblador %in% c("SPAdes", "IDBA-UD", "Ray")) %>%
  mutate(caida_pct = round(100 * (n50_kbp - nga50_kbp) / n50_kbp, 1)) %>%
  select(ensamblador, n50_kbp, nga50_kbp, caida_pct)

print(caida)

# La diferencia en fracción del genoma entre SPAdes y Edena, en puntos
# porcentuales, y el ensamblador con más errores de ensamblaje.
cat("Fracción del genoma: SPAdes - Edena =",
    round(quast %>% filter(ensamblador == "SPAdes") %>% pull(genome_fraction_pct) -
          (quast %>% filter(ensamblador == "Edena") %>% pull(genome_fraction_pct)), 2),
    "puntos porcentuales\n")
cat("Más errores de ensamblaje:",
    quast %>% filter(misassemblies == max(misassemblies)) %>% pull(ensamblador),
    "con", max(quast$misassemblies), "\n")

# --------------------------------------------------------------------------
# 5. Paleta y tema
# --------------------------------------------------------------------------
# Paleta Okabe-Ito (compatible con visión de color deficiente).
col_ensamblador <- "#0072B2"

# Tema común: sin título dentro de la imagen, títulos de ejes en negrita.
tema_fig <- theme_minimal(base_size = 12) +
  theme(
    axis.title = element_text(face = "bold"),
    axis.text = element_text(size = 11),
    panel.grid.minor = element_blank()
  )

# Ordenar los ensambladores de mayor a menor N50 para los gráficos.
quast$ensamblador <- factor(quast$ensamblador,
                            levels = c("SPAdes", "IDBA-UD", "SOAPdenovo2", "ABySS",
                                       "Ray", "MaSuRCA", "SGA", "Velvet", "Edena"))

# --------------------------------------------------------------------------
# 6. Figura 1 — Contigs por ensamblador
# --------------------------------------------------------------------------
# El eje horizontal es el ensamblador, ordenado de mayor a menor N50, y
# el eje vertical es el número de contigs de 500 pares de bases o más.
p1 <- ggplot(quast, aes(x = ensamblador, y = contigs_500)) +
  geom_col(fill = col_ensamblador) +
  geom_text(aes(label = comma(contigs_500)), vjust = -0.4, size = 3.5) +
  scale_y_continuous(labels = label_comma(), expand = expansion(mult = c(0, 0.12))) +
  labs(x = NULL, y = "Contigs (>= 500 bp)") +
  tema_fig +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

ggsave("figura1_contigs.png", p1, width = 9, height = 5, dpi = 300, bg = "white")

# Interpretación
# La Figura 1 muestra cuántos contigs de 500 pares de bases o más produce
# cada ensamblador con las mismas lecturas públicas de GAGE-B. El eje
# horizontal es el ensamblador, ordenado de mayor a menor N50, y el eje
# vertical es el número de contigs, una cantidad sin unidades. IDBA-UD
# produce 83 contigs y SPAdes 85, los dos ensamblajes menos fragmentados;
# Edena produce 1442 contigs, 17.37 veces más que IDBA-UD, y Velvet 866.
# Menos contigs indica un ensamblaje menos fragmentado: las lecturas se
# juntaron en piezas más largas en lugar de quedar en muchos fragmentos
# cortos. En medio quedan Ray con 123, SOAPdenovo2 con 114, MaSuRCA con
# 145, ABySS con 185 y SGA con 465 contigs.

# --------------------------------------------------------------------------
# 7. Figura 2 — N50 por ensamblador
# --------------------------------------------------------------------------
# El eje horizontal es el ensamblador, ordenado de mayor a menor N50, y
# el eje vertical es el N50 en miles de pares de bases (kbp).
p2 <- ggplot(quast, aes(x = ensamblador, y = n50_kbp)) +
  geom_col(fill = col_ensamblador) +
  geom_text(aes(label = comma(n50_kbp)), vjust = -0.4, size = 3.5) +
  scale_y_continuous(labels = label_comma(), expand = expansion(mult = c(0, 0.12))) +
  labs(x = NULL, y = "N50 (kbp)") +
  tema_fig +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

ggsave("figura2_n50.png", p2, width = 9, height = 5, dpi = 300, bg = "white")

# Interpretación
# La Figura 2 muestra el N50 de cada ensamblador. El eje horizontal es el
# ensamblador, ordenado de mayor a menor N50, y el eje vertical es el N50
# en miles de pares de bases (kbp). SPAdes tiene el N50 mayor, 247 kbp,
# seguido de IDBA-UD con 236 kbp, SOAPdenovo2 con 117 kbp, ABySS con
# 115 kbp, Ray con 112 kbp, MaSuRCA con 90 kbp, SGA con 58 kbp, Velvet
# con 22 kbp y Edena con 3 kbp. El N50 de SPAdes es 82.33 veces el de
# Edena y 11.23 veces el de Velvet. Un N50 mayor indica un ensamblaje
# menos fragmentado: la mitad del ensamblaje está en contigs de 247000
# pares de bases o más con SPAdes, y de 3000 o más con Edena. El NGA50
# confirma lo mismo: IDBA-UD tiene el NGA50 mayor (220 kbp), seguido de
# SPAdes (200 kbp), casi el doble que el tercero, Ray (112 kbp); Edena
# queda en 4 kbp y Velvet en 21 kbp. La fracción del genoma también
# separa a los dos grupos: SPAdes cubre 98.53 por ciento del genoma de
# referencia e IDBA-UD 98.45 por ciento, mientras Edena solo cubre
# 69.49 por ciento, 29.04 puntos porcentuales menos que SPAdes. En
# errores, MaSuRCA es el que más comete (9), y SGA y Velvet los que
# menos (2 cada uno): por eso el artículo dice que Velvet es el
# ensamblador más conservador, con el NGA50 más bajo y la tasa de error
# más baja. Con estos datos públicos, SPAdes e IDBA-UD son los
# ensambladores elegidos para seguir con el análisis: menos contigs,
# mayor N50, mayor NGA50 y mayor fracción del genoma.

# --------------------------------------------------------------------------
# 8. Qué aprendimos
# --------------------------------------------------------------------------
# - Un genoma se reconstruye juntando lecturas cortas en contigs. El
#   mismo conjunto de lecturas públicas da ensamblajes distintos según
#   el ensamblador que se use.
# - QUAST calcula las mismas métricas para cada ensamblaje, y eso permite
#   compararlos: contigs, N50, NGA50, LGA50, errores de ensamblaje y
#   fracción del genoma.
# - Un ensamblaje menos fragmentado tiene menos contigs, mayor N50 y
#   menor LGA50. Con estos datos, SPAdes e IDBA-UD quedaron mejor que
#   los otros siete en las tres medidas.
# - El NGA50 mide contra el genoma de referencia y castiga los errores:
#   el N50 de SPAdes cae 19.0 por ciento al pasar a NGA50, mientras el
#   de IDBA-UD cae solo 6.8 por ciento.
# - La fracción del genoma también importa: Edena solo cubre 69.49 por
#   ciento del genoma de referencia, frente a 98.53 por ciento de SPAdes.
# - En la próxima lección se revisa el control de calidad de las
#   lecturas antes del ensamblaje, con FastQC y Trim Galore, sobre estas
#   mismas lecturas públicas de GAGE-B.
