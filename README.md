# Code challenge for Envisagenics

This is an API that can get input from BAM files and convert them to BigWig format for a UI or some frontend can then hit this API to display the graph format of the data.


This is an example browser

https://genome.ucsc.edu/cgi-bin/hgTracks?db=hg38&lastVirtModeType=default&lastVirtModeExtraState=&virtModeType=default&virtMode=0&nonVirtPosition=&position=chr1%3A11102837%2D11267747&hgsid=601834951_4P9Wf6Asjws0b1BM0XZVhju4pWWo

---

How to use this program:

In the rakefile, update the path, sample and ext to match your files (in this example there are four given).

1. rake db:create
2. rake db:migrate
3. rake app:scrape

The "rake app:scrape" command works by:

1. Generates relevant FASTA files
2. Creates base SAM enums
3. Index those enums to generate .bai files
4. Generates SAM files
5. Iterates through each SAM file to populate a database
