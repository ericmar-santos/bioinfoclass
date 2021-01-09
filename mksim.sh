#!/bin/bash


### criar o arquivo ACCS.txt
### PROCEDIMENTO MANUAL

rm -f transcriptome.fa

for acc in $(cat ACCS.txt); do
        echo "Pegando FASTA para ${acc} ..."

        esearch -db nucleotide -query ${acc} | efetch \
        -format fasta >> transcriptome.fa
done

### criar os arquivos abundance_A.txt e abundance_B.txt
### PROCEDIMENTO MANUAL

### gerar os fragmentos para arquivos abundance_*.txt

for abdfile in `find ./ -name 'abundance_*.txt'`; do

	samplename=`basename "${abdfile}" .txt | sed 's/abundance_//'`

	for rep in `seq 1 2`; do

		echo "Amostra ${samplename} réplica ${rep} ..."

		echo "	Gerando sequências aleatórias dos fragmentos ..."
		generate_fragments.py -r transcriptome.fa \
		   -a ${abdfile} \
		   -o ./tmp.frags.r${samplename}${rep} \
		   -t 25000 \
		   -i 300 \
		   -s 30

		echo "	Padronizando os nomes das sequências ..."

		cat ./tmp.frags.r${samplename}${rep}.1.fasta | renameSeqs.pl \
		   -if FASTA \
		   -of FASTA \
		   -p SAMPLE${samplename}${rep} \
		   -w 1000 | \
		   sed 's/^>\(\S\+\).*/>\1/' \
		   > ./frags_${samplename}${rep}.fa

		echo "	Simulando sequenciamento paired-end ..."

		cat ./frags_${samplename}${rep}.fa | simNGS -a \
			AGATCGGAAGAGCACACGTCTGAACTCCAGTCACATCACGATCTCGTATGCCGTCTTCTGCTTG:AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGTAGATCTCGGTGGTCGCCGTATCATT \
			-p paired \
			/usr/local/bioinfo/simNGS/data/s_4_0099.runfile \
			-n 151 > ./SAMPLE${samplename}${rep}.fastq \
			2> SAMPLE${samplename}${rep}.err.txt

		echo "	Desintercalando as reads ..."

		mkdir -p ./raw

		deinterleave_pairs SAMPLE${samplename}${rep}.fastq \
		   -o ./raw/SAMPLE${samplename}${rep}_R1.fastq \
		      ./raw/SAMPLE${samplename}${rep}_R2.fastq

		echo "	Removendo arquivos desnecessários ..."

		rm -f ./tmp.frags.r${samplename}${rep}.1.fasta ./frags_${samplename}${rep}.fa ./SAMPLE${samplename}${rep}.fastq ./SAMPLE${samplename}${rep}.err.txt

	done
done
