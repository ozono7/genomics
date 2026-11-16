# Estación de trabajo de bioinformática para el laboratorio

**Autor:** Dr. José Juan Torres Martínez
**Docente de Ciencias Químicas**
**Universidad Autónoma de San Luis Potosí (UASLP)**
**México**
**Material académico para estudiantes**

---

## Para qué sirve esta guía

El laboratorio perdió el acceso al supercomputador del IPICYT/UNAM y el trabajo se hace ahora con una laptop. Esta guía describe una estación de trabajo que se puede armar en el laboratorio, con un presupuesto menor a 200,000 MXN, para correr bioinformática en local aunque sea más despacio: control de calidad de lecturas, ensamblaje de genomas, BUSCO, ANI, anotación funcional, BLAST y Diamond, RNA-seq y AlphaFold/ColabFold.

La idea no es reemplazar un centro de cómputo. Es tener una máquina propia donde el flujo de trabajo completo corre paso a paso, sin depender de que alguien más preste tiempo de cómputo, y donde los proyectos del laboratorio — genomas bacterianos, genomas de microalgas del tamaño de *Chlorella* y análisis de RNA-seq — se resuelven en casa. El ensamblaje de un genoma vegetal grande sigue siendo el paso más pesado y se trata con honestidad en la sección de qué puede y qué no puede hacer esta máquina.

El sistema operativo es Ubuntu Linux, gratuito. Todas las herramientas de bioinformática que se mencionan son gratuitas y se instalan con conda. El costo de software es cero: todo el presupuesto va al hardware.

---

## La estación en resumen

| Recurso | Elección |
|---|---|
| Procesador | AMD Ryzen 9 9950X, 16 núcleos / 32 hilos, hasta 5.7 GHz |
| Memoria RAM | 256 GB DDR5 (4 × 64 GB a 5600 MT/s) |
| Tarjeta gráfica | NVIDIA GeForce RTX 5080, 16 GB GDDR7 |
| Almacenamiento rápido | NVMe Kingston KC3000 de 4 TB, PCIe 4.0 |
| Archivo | Disco duro Seagate IronWolf de 8 TB |
| Placa base | MSI X870E Gaming Plus WiFi (AM5, hasta 256 GB de RAM) |
| Fuente | Corsair RM1000e, 1000 W, 80 Plus Gold |
| Gabinete | Lian Li Lancool 216 |
| Enfriamiento | Deepcool LT360, líquido de 360 mm |
| Monitor | Gigabyte GS27QA, 27 pulgadas, QHD 2560 × 1440 |
| Teclado y mouse | Logitech MK270, inalámbricos |
| Protección eléctrica | UPS CyberPower CP1500PFCLCD, 1500 VA / 900 W (recomendado) |
| **Total** | **$149,150 MXN sin UPS · $155,909 MXN con UPS** |

---

## Componentes y precios (noviembre de 2026)

Los precios son en pesos mexicanos, de tiendas en México, consultados en noviembre de 2026. El Buen Fin 2026 (13 al 17 de noviembre) estaba en curso al consultar, así que algunos precios son de oferta y pueden subir después. Conviene verificar cada precio antes de comprar. Tipo de cambio de referencia: ~18.6 MXN por USD.

| # | Componente | Por qué importa en bioinformática | Precio MXN (nov 2026) | Dónde comprar |
|---|---|---|---|---|
| 1 | **Procesador AMD Ryzen 9 9950X** (16 núcleos / 32 hilos, 4.3–5.7 GHz, 170 W) | Los ensambladores, el mapeo de lecturas y el RNA-seq se reparten entre núcleos. 16 núcleos con 32 hilos acortan ensamblajes que en una laptop de 4 núcleos tardarían días. Es el mejor procesador de escritorio para este presupuesto sin entrar a plataforma de servidor. | **$11,499** | [DDTech](https://ddtech.mx/producto/procesador-amd-ryzen-9-9950x-16-nucleos-32-hilos-4-3ghz-5-7ghz-am5-170w-100-100000660wof) (también en PCEL $12,099 y Cyberpuerta $13,239) |
| 2 | **Memoria RAM 256 GB DDR5** (4 × Kingston Fury Beast 64 GB, DDR5-5600, CL36) | La RAM es el recurso que decide si un ensamblaje corre o no. MEGAHIT y SPAdes construyen el grafo de k-mers en memoria: un genoma bacteriano cabe en 16 GB, uno de *Chlorella* necesita del orden de 100 GB, y uno vegetal grande pide mucho más. Con 256 GB la estación ensambla bacterias y microalgas con holgura y puede intentar genomas grandes con límite de memoria. Es la prioridad número uno de esta estación. | **$64,420** (4 × $16,105) | [Dimercom](https://dimercom.com/products/memoria-ram-kingston-fury-beast-64gb-ddr5-5600mhz-cl36-dimm-kf556c36bbe-64) — ver nota abajo |
| 3 | **Tarjeta gráfica Gigabyte GeForce RTX 5080 Gaming OC, 16 GB GDDR7** | AlphaFold y ColabFold corren en GPU. 16 GB de VRAM alcanzan para la mayoría de las proteínas (hasta ~1000 aminoácidos). También acelera el aprendizaje profundo del proyecto de identificación de microalgas por imagen. | **$37,999** | [PCEL](https://www.pcel.com/producto/tarjeta-de-video-gigabyte-geforce-rtx-5080-gaming-oc-16g-16gb-gddr7-pci-express-5-0-gv-n5080gaming-oc-16gd) (ASUS Prime en Elektra $37,899) |
| 4 | **NVMe Kingston KC3000 de 4 TB, PCIe 4.0** (lectura 7000 MB/s) | Los datos activos — lecturas crudas, ensamblajes, índices de BLAST y de Salmon — se leen y escriben miles de veces. Un NVMe rápido recorta horas de cada corrida frente a un disco duro. 4 TB alcanzan para varios proyectos activos a la vez. | **$12,839** | [Cyberpuerta](https://www.cyberpuerta.mx/Computo-Hardware/Componentes/Discos-Duros-SSD/Unidad-de-Estado-Solido-SSD-Kingston-KC3000-de-4TB-M.2-2280-NVMe-PCIe-4.0-x4-7000-MB-s-Lectura-6900-MB-s-Escritura-SKC3000D-4096G.html) (PCEL $13,089) |
| 5 | **Disco duro Seagate IronWolf de 8 TB, 7200 rpm, NAS** | Archivo de lecturas crudas, ensamblajes terminados y respaldos. Los datos que no se usan a diario no necesitan la velocidad del NVMe, pero sí espacio y fiabilidad para corridas largas. | **$6,002** | [Supermex](https://www.supermex.mx/p/disco-duro-seagate-ironwolf-8tb-3-5-sata-6gb-s-7200rpm-nas-256mb-st8000vn004/) (Sears $6,779) |
| 6 | **Placa base MSI X870E Gaming Plus WiFi (AM5)** | Soporta los 256 GB de RAM de esta estación, tiene ranuras PCIe 5.0 para la GPU y el NVMe, y varios puertos M.2 por si se agrega un segundo NVMe después. | **$5,849** | [PCEL](https://www.pcel.com/producto/tarjeta-madre-msi-x870e-gaming-plus-wifi-am5-ddr5-atx-911-7e35-002) |
| 7 | **Fuente Corsair RM1000e, 1000 W, 80 Plus Gold, ATX 3.0** | El procesador consume hasta 170 W y la RTX 5080 hasta 360 W; con placa, RAM y discos el pico ronda 630 W. Una fuente de 1000 W trabaja con holgura, se calienta menos y deja margen para un segundo NVMe o más discos. | **$3,089** | [PCEL](https://www.pcel.com/producto/fuente-de-poder-corsair-rm1000e-1000w-80-plus-gold-atx-3-0-pcie-5-0-cp-9020264-na) |
| 8 | **Gabinete Lian Li Lancool 216** | Gabinete amplio, con buen flujo de aire para un equipo que va a correr días seguidos y con espacio para el radiador de 360 mm y discos adicionales. | **$1,959** | [PCEL](https://www.pcel.com/producto/gabinete-lian-li-lancool-216-argb-blanco-e-atx-3-ventiladores-argb-g99-lan216rwa-r0) |
| 9 | **Enfriamiento líquido Deepcool LT360, 360 mm (AM5)** | El Ryzen 9 9950X no trae disipador incluido y se calienta bajo carga sostenida. Un enfriamiento líquido de 360 mm lo mantiene estable en ensamblajes de muchas horas. | **$1,769** | [PCEL](https://www.pcel.com/producto/enfriamiento-liquido-deepcool-lt360-argb-360mm-am5-lga1700-r-lt360-bkamnc-g-1) (MSI MAG CoreLiquid A15 360, $1,359–$1,379, también sirve) |
| 10 | **Monitor Gigabyte GS27QA, 27", QHD 2560 × 1440, 180 Hz** | Para revisar genomas en IGV, tablas de anotación y código varias horas al día, 27 pulgadas en QHD es el tamaño cómodo sin pagar de más. | **$3,199** | [PCEL](https://www.pcel.com/producto/monitor-gigabyte-gs27qa-27-qhd-2560-x-1440-180hz-1ms-hdmi-dp-g20-01) |
| 11 | **Teclado y mouse Logitech MK270, inalámbricos** | Combo funcional y barato. El presupuesto va al cómputo, no a los periféricos. | **$526** | [TiendaClic](https://www.tiendaclic.mx/ver-detalle/tecladomouse-logitech-mk270-negro-inalambricos-usb-para-pc-logitech-920-004432) (Papira $577) |
| 12 | **UPS CyberPower CP1500PFCLCD, 1500 VA / 900 W, onda senoidal pura (recomendado)** | Un ensamblaje de dos días no se puede perder por un apagón. El UPS da minutos para guardar el trabajo y apagar con calma, y protege la fuente y los discos de variaciones de voltaje. | **$6,759** | [PCEL](https://www.pcel.com/producto/no-break-cyberpower-cp1500pfclcd-1500va-900w-10-salidas-lcd-onda-senoidal-pura) |

### Total

| Concepto | Total MXN |
|---|---|
| Torre + monitor + teclado y mouse (componentes 1–11) | **$149,150** |
| Con UPS recomendado (componentes 1–12) | **$155,909** |
| Presupuesto máximo | $200,000 |
| Margen restante (con UPS) | **$44,091** |

**La estación completa con UPS cuesta $155,909 MXN, dentro del presupuesto de $200,000 MXN.**

### Notas sobre los precios

- **La RAM es el precio más volátil.** Los precios de la DDR5 se dispararon a finales de 2026 por la escasez de memoria para inteligencia artificial: un kit Corsair Vengeance de 64 GB (2 × 32 GB) que costaba $3,249 en julio de 2024 se vendía en $19,439 en PCEL en noviembre de 2026. El precio de $16,105 por módulo Kingston de 64 GB en Dimercom es el más bajo verificado, pero **ese módulo estaba agotado al consultar**. La alternativa en existencia es el kit Corsair Vengeance RGB DDR5-5200 de 64 GB (2 × 32 GB) a $19,439 en PCEL: cuatro kits (256 GB) costarían $77,756. Con esa RAM el total sería $162,486 sin UPS y **$169,245 con UPS**, todavía dentro del presupuesto. Conviene comprar la RAM cuando el precio esté bajo, porque es el componente que más puede mover el total.
- **Con el margen restante cabe un segundo NVMe de 4 TB** ($12,839) para usarlo como disco de trabajo temporal de los ensamblajes, dejando el primer NVMe para el sistema y los datos. Con UPS y segundo NVMe el total sería $168,748 con la RAM de Dimercom, o $182,084 con la RAM Corsair en existencia. En ambos casos, debajo de 200,000 MXN.
- **Alternativa de tarjeta gráfica:** la RTX 5070 Ti de 16 GB cuesta $27,299 en Cyberpuerta, unos $10,700 menos que la RTX 5080, y tiene los mismos 16 GB de VRAM. Para AlphaFold, que depende sobre todo de la VRAM, la 5070 Ti rinde casi igual; la 5080 tiene más núcleos CUDA y conviene más para entrenar modelos de aprendizaje profundo. Si el presupuesto aprieta, la 5070 Ti es el recorte correcto.
- **Por qué no Threadripper:** el Ryzen Threadripper 9970X de 32 núcleos cuesta $53,599 en PCEL, pero necesita placa TRX50 y memoria RDIMM, ambas más caras que sus equivalentes AM5. Con 256 GB de RAM esa ruta se sale del presupuesto. Los 16 núcleos del Ryzen 9 9950X son el punto de equilibrio entre núcleos y costo para este laboratorio.
- **Cuatro módulos de RAM:** la placa soporta 256 GB, pero con los cuatro slots ocupados la velocidad efectiva puede bajar de 5600 a 3600–4400 MT/s. Para bioinformática la capacidad pesa más que la velocidad: un ensamblaje que no cabe en RAM no corre, y uno que corre un poco más lento sí termina. Los cuatro módulos deben ser del mismo modelo y, si es posible, del mismo lote.
- **Precios de referencia no usados en el total:** Samsung 990 Pro de 4 TB, $17,249 en Amazon México (precio de Buen Fin); disco IronWolf de 8 TB en Zegucom $4,059 (precio de una lista anterior, no confirmado en noviembre de 2026).

---

## Qué puede y qué no puede hacer esta estación

### Sí puede

- **Genomas bacterianos (3–6 Mb):** ensamblaje con Unicycler o SPAdes, control de calidad con FastQC, anotación con Prokka, ANI con FastANI y análisis de pangenoma. Una bacteria completa se ensambla y anota en horas.
- **Genomas de microalgas del tamaño de *Chlorella* (~143 Mb):** MEGAHIT o SPAdes con 256 GB de RAM, BUSCO, anotación con Funannotate y eggNOG-mapper, y ANI contra genomas de referencia. Es el caso del artículo del genoma de *Chlorella* (84.8 millones de pares de lecturas, ensamblaje de 143.33 Mb): en esta estación ese ensamblaje corre en horas o en uno o dos días, con paciencia, en lugar de minutos en un supercomputador.
- **RNA-seq completo:** control de calidad, cuantificación con Salmon o Kallisto, ensamblaje de transcriptoma con Trinity y análisis de expresión diferencial con DESeq2 en R/Bioconductor. Trinity es exigente en memoria y 256 GB lo cubren para transcriptomas de microalgas.
- **AlphaFold y ColabFold:** proteínas de hasta ~1000 aminoácidos corren en local con los 16 GB de VRAM de la RTX 5080. También corre el entrenamiento y la inferencia del proyecto de identificación de microalgas por imagen.
- **BLAST, Diamond y bases de datos locales:** la construcción de bases de datos con `makeblastdb` y las búsquedas con Diamond contra NR o UniProt corren en local; las bases de datos grandes viven en el disco de 8 TB.
- **Varios proyectos a la vez:** con 16 núcleos y 256 GB se puede correr un ensamblaje mientras se anotan otros datos o se analiza un RNA-seq, algo imposible en una laptop.

### No puede (o no conviene intentarlo aquí)

- **Ensamblar un genoma vegetal grande como *Opuntia* (~814 Mb) con la misma comodidad que un supercomputador.** El ensamblaje MEGAHIT de *Opuntia* usó 750 GB de RAM, 48 procesadores y 144 horas en el supercomputador. Con 256 GB, MEGAHIT sí puede correr si se le pone límite de memoria (la opción `--memory`), porque vuelca parte del trabajo al disco, pero será mucho más lento: días o semanas en lugar de horas. Para ese único paso, la salida práctica es rentar cómputo en la nube por un mes o usar Colab Pro para el ensamblaje, y hacer todo lo demás (anotación, BUSCO, ANI, búsqueda de genes candidatos, RNA-seq) en esta estación.
- **Proteínas muy grandes en AlphaFold local:** por arriba de ~1000–1400 aminoácidos, los 16 GB de VRAM no alcanzan. Esas se predicen en Colab o se dividen por dominios.
- **Muchos ensamblajes grandes en paralelo:** la estación es para un proyecto pesado a la vez, o varios ligeros. No sustituye a un clúster cuando hay que ensamblar diez genomas a la vez.
- **No tiene memoria ECC:** es una estación de escritorio, no un servidor. Para el trabajo del laboratorio es suficiente, pero un corte de luz a mitad de un ensamblaje se pierde; por eso el UPS es parte recomendada de la compra.

---

## Puesta en marcha

### 1. Instalar Ubuntu

Instalar Ubuntu 24.04 LTS desde una USB booteable. Particionado sugerido:

- NVMe de 4 TB: sistema (`/`, 100 GB), datos de trabajo (`/datos`, resto del NVMe).
- Disco de 8 TB: archivo (`/archivo`), montado en forma permanente.

Después de instalar, actualizar el sistema:

```bash
sudo apt update && sudo apt upgrade -y
sudo apt install -y build-essential git curl wget tmux htop
```

### 2. Instalar Miniforge (conda)

Miniforge es la vía recomendada para instalar conda con el canal conda-forge:

```bash
wget https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh
bash Miniforge3-Linux-x86_64.sh
```

Cerrar y volver a abrir la terminal, y crear el entorno de bioinformática:

```bash
conda create -n bioinfo -c conda-forge -c bioconda \
  fastqc multiqc fastp trimmomatic megahit spades unicycler quast busco \
  fastani prokka diamond blast samtools bwa minimap2 seqkit salmon kallisto \
  trinity eggnog-mapper funannotate
conda activate bioinfo
```

Las bases de datos de eggNOG-mapper y Funannotate ocupan decenas de GB; descargarlas al disco de 8 TB y apuntar las variables de entorno a esa ruta.

### 3. R y Bioconductor para RNA-seq

```bash
conda install -c conda-forge -c bioconda r-base bioconductor-deseq2 bioconductor-tximport
```

DESeq2, tximport y los paquetes de Bioconductor se instalan desde R con `BiocManager::install()` cuando haga falta un paquete que no está en bioconda.

### 4. ColabFold para AlphaFold local

```bash
conda create -n colabfold -c conda-forge -c bioconda colabfold
conda activate colabfold
colabfold_batch --help
```

ColabFold descarga sus bases de datos (varias decenas de GB) la primera vez; guardarlas en el disco de 8 TB.

### 5. Corridas largas

Usar `tmux` para que un ensamblaje de varias horas siga corriendo aunque se cierre la terminal:

```bash
tmux new -s ensamblaje
megahit -1 lecturas_R1.fastq.gz -2 lecturas_R2.fastq.gz --memory 0.85 -t 30 -o ensamblaje_megahit
```

La opción `--memory 0.85` le dice a MEGAHIT que use como máximo el 85% de la RAM y vuelque el resto al disco: más lento, pero no se queda sin memoria. Con 256 GB, `-t 30` deja dos hilos libres para el sistema.

### 6. UPS y apagado seguro

Conectar el UPS por USB e instalar `nut` (Network UPS Tools) para que Ubuntu apague el equipo solo si se agota la batería:

```bash
sudo apt install -y nut
```

Configurar el apagado automático a los 5 minutos sin corriente: un ensamblaje se puede repetir, un disco dañado por un apagón brusco cuesta más.

### 7. Respaldo

El disco de 8 TB guarda los datos, pero no es un respaldo por sí solo. Copiar los proyectos terminados a un disco externo o al almacenamiento institucional al cerrar cada proyecto. Las lecturas crudas se guardan comprimidas y se borran del NVMe cuando el proyecto termina, para dejar espacio al siguiente.

---

## Antes de comprar

- Los precios de esta guía son estimaciones de noviembre de 2026, verificados en tiendas mexicanas en esa fecha. Verificar cada precio antes de comprar: la RAM en particular cambia de precio de un mes a otro.
- Comprar primero la RAM y el procesador, que son los componentes que más se mueven de precio; el resto (gabinete, fuente, monitor, periféricos) varía poco.
- Pedir factura a nombre del laboratorio o de la universidad cuando aplique, para el inventario del equipo.
- Guardar las cajas y las garantías de cada componente: procesador y tarjeta gráfica suelen tener 3 años de garantía, la RAM de por vida según el fabricante.
- Tipo de cambio de referencia al consultar: ~18.6 MXN por USD (noviembre de 2026). Los precios de la tabla son precios en MXN de tiendas mexicanas, no conversiones de dólares.

---

*Precios verificados en noviembre de 2026 en DDTech, PCEL, Cyberpuerta, Dimercom, Supermex, TiendaClic, Elektra y Amazon México. Verificar antes de comprar.*
