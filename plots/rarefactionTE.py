### Primero correr esta línea ###
# paste <(grep -v -E '##|ID' tru-merged.vcf | cut -f3) <(grep -v -E '##|ID' tru-merged.vcf | cut -f8 | cut -d';' -f3) | grep 'TE_ANNOT' > TErelatedSVs.txt

import subprocess

number=1
total=0

for genome in range(1,76):
    genomestring='^'+str(number)+'\.'
    grep=subprocess.Popen(['grep','-v', '-E','##|ID','TErelatedSVs.txt'],stdout=subprocess.PIPE)
    grep=subprocess.Popen(['grep','-E', genomestring],stdin=grep.stdout,stdout=subprocess.PIPE)
    wc=subprocess.run(['wc', '-l'],stdin=grep.stdout,capture_output=True)
    count=int(wc.stdout)
    total+=count
    print(count)
    number+=1

print('\n'+'The total is '+str(total))


