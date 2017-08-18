# Converting BAM files: SAM .bai FASTA bedgraph bigWig

This is an API that can get input from BAM files and convert them to BigWig format for a UI or some frontend can then hit this API to display the graph format of the data.

Note that most of the code that is executed takes place in the Rakefile, which mostly spoofs CLI commands and appropriately culls them into a database.

---

This is an example browser

https://genome.ucsc.edu/cgi-bin/hgTracks?db=hg38&lastVirtModeType=default&lastVirtModeExtraState=&virtModeType=default&virtMode=0&nonVirtPosition=&position=chr1%3A11102837%2D11267747&hgsid=601834951_4P9Wf6Asjws0b1BM0XZVhju4pWWo

---

Required tools:

Before you do anything, please:

* bundle install

**samtools** installation:

* git clone git://github.com/samtools/samtools.git

**bedtools** installation:

* git clone git@github.com:arq5x/bedtools2.git
* cd bedtools2
* make clean
* make all
* sudo cp bin/* /usr/local/bin

---

If running an Ubuntu server you may also have to do the following if starting from scratch:

* apt-get install ruby-full
* apt-get update
* apt-get install libncurses-dev
* gem install bio-samtools -v '2.5.1'
* apt-get install postgresql postgresql-contrib
* apt-get install libpq-dev
* gem install pg -v '0.21.0'
* -u postgres createuser --superuser <your_username_here>
* git clone https://github.com/lh3/seqtk.git
* * (then cd into seqtk and type 'make')
* apt install seqtk

---

There are two ways this file works:

1. Generating .bai and SAM files from BAM files a, then populating a database with human-readable SAM endpoints for each Alignment

![alignments](http://i.imgur.com/nKAPuFz.png)

2. Generating bedgraph and bigWig files from BAM files, then populating a database with binary bigWig information

---

Instructions

Before you scrape your data, first run `rake reload` which does:

1. rake db:drop
2. rake db:create
3. rake db:migrate
4. rake db:migrate RAILS_ENV=development

---

1) SAM files with readable outputs

When you scrape the file you'll first be asked to first be asked to update the path, sample, and ext to match your files (in this example there are four given). To scrape type in `rake scrape_sam`. You can manually go into the rakefile to edit files to scrape in.

The `rake scrape_sam` command works by:

1. Generates relevant FASTA files
2. Creates base SAM enums
3. Index those enums to generate .bai files
4. Generates SAM files
5. Iterates through each generated SAM file to populate a database of readable alignments

Once you populate your database, type in `rails s` to start your server. The endpoints for each alignment can be found by the following URL format:

`http://localhost:3000/api/v1/alignments/<number>`

---

2) bigWig files

When you scrape the file you'll first be asked to first be asked to update the path, sample, and ext to match your files (in this example there are four given). To scrape type in `rake scrape_bw`. You can manually go into the rakefile to edit files to scrape in.

The `rake scrape_bw` command works by:

1. Calculates genomic positions into bedgraph files
2. Generates bigWig files
3. Iterates through each generated bigWig file to populate a database of binary rows

Once you populate your database, type in `rails s` to start your server. The endpoints for each alignment can be found by the following URL format:

`http://localhost:3000/api/v1/bwrows/<number>`

---

CLI summary SAM: `rake reload`, `rake scrape_sam`, `rails s`
CLI summary BW:  `rake reload`, `rake scrape_bw`, `rails s`
