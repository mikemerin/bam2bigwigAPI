# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.
require 'zlib'
require 'stringio'
require 'bio-samtools'
require_relative 'config/application'

Rails.application.load_tasks

def scrape_SAM(t)

  # # file shorteners
  path = "/Users/flatironschool/Envisagenics/"
  sample = "Sample_LID115547"
  ext = ".me.bam.sort.bam.clean.exon."


  # prompt to change file path/name
  puts "The current file path and name is:\n"
  puts "#{path}#{sample}_numbers#{ext}bam\n"
  puts "Would you like to change this? (y/n)\n"

  # choice = gets.chomp
  # if choice.downcase == "y"
  #   puts "path (currently #{path})"
  #   path = gets.chomp
  #   puts "sample (currently #{sample})"
  #   sample = gets.chomp
  #   puts "extension (currently #{ext})"
  #   ext = gets.chomp
  # end

  count, array = 0, []
  puts "\nMigration starting at #{t}"
  puts "---------"

  # # file names
  bam11 = "#{path}#{sample}_1_1#{ext}bam"
  sam11s = "#{sample}_1_1#{ext}sam"
  sam11 = "#{path}#{sample}_1_1#{ext}sam"
  fa11 = "#{path}#{sample}_1_1#{ext}fa"
  fa11s = "#{sample}_1_1#{ext}fa"

  bam12 = "#{path}#{sample}_1_2#{ext}bam"
  sam12s = "#{sample}_1_2#{ext}sam"
  sam12 = "#{path}#{sample}_1_2#{ext}sam"
  fa12 = "#{path}#{sample}_1_2#{ext}fa"
  fa12s = "#{sample}_1_2#{ext}fa"

  bam21 = "#{path}#{sample}_2_1#{ext}bam"
  sam21s = "#{sample}_2_1#{ext}sam"
  sam21 = "#{path}#{sample}_2_1#{ext}sam"
  fa21 = "#{path}#{sample}_2_1#{ext}fa"
  fa21s = "#{sample}_2_1#{ext}fa"

  bam22 = "#{path}#{sample}_2_2#{ext}bam"
  sam22s = "#{sample}_2_2#{ext}sam"
  sam22 = "#{path}#{sample}_2_2#{ext}sam"
  fa22 = "#{path}#{sample}_2_2#{ext}fa"
  fa22s = "#{sample}_2_2#{ext}fa"

  # # generate FASTA files
  puts "Generating bam11 fasta at ${Time.now}"
  system "samtools bam2fq #{bam11} | /users/flatironschool/seqtk/seqtk seq -A > #{fa11s}"
  puts "Generating bam12 fasta at ${Time.now}"
  system "samtools bam2fq #{bam12} | /users/flatironschool/seqtk/seqtk seq -A > #{fa12s}"
  puts "Generating bam21 fasta at ${Time.now}"
  system "samtools bam2fq #{bam21} | /users/flatironschool/seqtk/seqtk seq -A > #{fa21s}"
  puts "Generating bam22 fasta at ${Time.now}"
  system "samtools bam2fq #{bam22} | /users/flatironschool/seqtk/seqtk seq -A > #{fa22s}"

  # # create base SAM enum and index for .bai files
  puts "Generating sample_LID115547_1_1 SAM"
  bam11g = Bio::DB::Sam.new(bam: bam11, fasta: fa11)
  puts "indexing at ${Time.now}"
  bam11g.index()
  puts "Generating sample_LID115547_1_2 SAM"
  bam12g = Bio::DB::Sam.new(bam: bam12, fasta: fa12)
  puts "indexing at ${Time.now}"
  bam12g.index()
  puts "Generating sample_LID115547_2_1 SAM"
  bam21g = Bio::DB::Sam.new(bam: bam21, fasta: fa21)
  puts "indexing at ${Time.now}"
  bam21g.index()
  puts "Generating sample_LID115547_2_2 SAM"
  bam22g = Bio::DB::Sam.new(bam: bam22, fasta: fa22)
  puts "indexing at ${Time.now}"
  bam22g.index()

  # # create SAM files
  puts "Generating sam11 at ${Time.now}"
  system "samtools view -h #{bam11} > #{sam11}"
  puts "Generating sam12 at ${Time.now}"
  system "samtools view -h #{bam12} > #{sam12}"
  puts "Generating sam21 at ${Time.now}"
  system "samtools view -h #{bam21} > #{sam21}"
  puts "Generating sam22 at ${Time.now}"
  system "samtools view -h #{bam22} > #{sam22}"

  files = [sam11, sam12, sam21, sam22]

  files.each do |file|
    File.foreach(file) do |row|
      split_row = row.split("\t")
      split_row.map! { |x| ActiveRecord::Base.connection.quote(x) }

      if row[0] != "@"
        qname, flag, chromosome, pos, mapq, cigar, mrnm_rnext, mpos_pnext, isize_tlen, seq, qual = split_row
        tags = split_row[11...split_row.size-1]

        time = ActiveRecord::Base.connection.quote(Time.now)
        array << "(#{qname}, #{flag}, #{chromosome}, #{pos}, #{mapq}, #{cigar}, #{mrnm_rnext}, #{mpos_pnext}, #{isize_tlen}, #{seq}, #{qual}, #{time}, #{time})"
      end

      count += 1
      $total_count += 1
      puts "#{Time.now - t} s: #{count} alignments added" if count % 10000 == 0

      if count % 200000 == 0
        sql = "INSERT INTO alignments (qname, flag, chromosome, pos, mapq, cigar, mrnm_rnext, mpos_pnext, isize_tlen, seq, qual, created_at, updated_at) VALUES " + array.join(", ")
        puts "============= Seeding 200,000 rows ============="
        ActiveRecord::Base.connection.execute(sql)
        puts "============= #{Alignment.all.count} rows are now in the database ============="
        array = []
      end

    end
  end

  sql = "INSERT INTO alignments (qname, flag, chromosome, pos, mapq, cigar, mrnm_rnext, mpos_pnext, isize_tlen, seq, qual, created_at, updated_at) VALUES " + array.join(", ")
  ActiveRecord::Base.connection.execute(sql)

  puts "---------"
  puts "#{count} alignments from this file were added, with #{$total_count} total alignments."

end


def scrape_BW(t)

  # # file shorteners
  path = "/Users/flatironschool/Envisagenics/"
  sample = "Sample_LID115547"
  ext = ".me.bam.sort.bam.clean.exon."

  count, array = 0, []
  puts "\nMigration starting at #{t}"
  puts "---------"

  # # file names
  bam11 = "#{path}#{sample}_1_1#{ext}bam"
  bg11 = "#{path}#{sample}_1_1#{ext}bg"
  bw11 = "#{path}#{sample}_1_1#{ext}bw"

  bam12 = "#{path}#{sample}_1_2#{ext}bam"
  bg12 = "#{path}#{sample}_1_2#{ext}bg"
  bw12 = "#{path}#{sample}_1_2#{ext}bw"

  bam21 = "#{path}#{sample}_2_1#{ext}bam"
  bg21 = "#{path}#{sample}_2_1#{ext}bg"
  bw21 = "#{path}#{sample}_2_1#{ext}bw"

  bam22 = "#{path}#{sample}_2_2#{ext}bam"
  bg22 = "#{path}#{sample}_2_2#{ext}bg"
  bw22 = "#{path}#{sample}_2_2#{ext}bw"

  chrom_info = "/Users/flatironschool/Envisagenics/bam2bigwigAPI/chromInfo.txt"

  # # calculate coverage over each genomic position
  puts "Calculating genomic positions"
  puts "----------------------------------------"
  puts "Generating bg11"
  system "genomeCoverageBed -bg -ibam #{bam11} -g chrom_info > #{bg11}"
  puts "Generating bg12"
  system "genomeCoverageBed -bg -ibam #{bam12} -g chrom_info > #{bg12}"
  puts "Generating bg21"
  system "genomeCoverageBed -bg -ibam #{bam21} -g chrom_info > #{bg21}"
  puts "Generating bg22"
  system "genomeCoverageBed -bg -ibam #{bam22} -g chrom_info > #{bg22}"

  # # generate bigwig files
  puts "Generating bigwig files"
  puts "----------------------------------------"
  puts "Generating bw11"
  system "bedGraphToBigWig bg11 chrom_info bw11"
  puts "Generating bw12"
  system "bedGraphToBigWig bg12 chrom_info bw12"
  puts "Generating bw21"
  system "bedGraphToBigWig bg21 chrom_info bw21"
  puts "Generating bw22"
  system "bedGraphToBigWig bg22 chrom_info bw22"

  files = [bw11, bw12, bw21, bw22]

  files.each do |file|
    File.foreach(file) do |row|
      row = ActiveRecord::Base.connection.quote(row)

      time = ActiveRecord::Base.connection.quote(Time.now)
      array << "(#{row}, #{time}, #{time})"

      count += 1
      $total_count += 1
      puts "#{Time.now - t} s: #{count} rows added" if count % 10000 == 0

      if count % 200000 == 0
        sql = "INSERT INTO bwrows (row, created_at, updated_at) VALUES " + array.join(", ")
        puts "============= Seeding 200,000 rows ============="
        ActiveRecord::Base.connection.execute(sql)
        puts "============= #{Alignment.all.count} rows are now in the database ============="
        array = []
      end

    end
  end

  sql = "INSERT INTO bwrows (row, created_at, updated_at) VALUES " + array.join(", ")
  ActiveRecord::Base.connection.execute(sql)

  puts "---------"
  puts "#{count} rows from this file were added, with #{$total_count} total rows."

end

desc "convert and scrape BAM file as SAM"
  task :scrape_sam => :environment do
    t, $total_count = Time.now, 0
    scrape_SAM(t)
    puts "\nMigration ended at #{Time.now} and took #{(total / 60).floor} minutes #{total % 60} seconds."
    # puts "There are now #{Alignment.all.count} alignments"
  end

desc "convert and scrape BAM file as bigWig"
  task :scrape_bw => :environment do
    t, $total_count = Time.now, 0
    scrape_BW(t)
    puts "\nMigration ended at #{Time.now} and took #{(total / 60).floor} minutes #{total % 60} seconds."
    # puts "There are now #{Alignment.all.count} alignments"
  end

desc "reload DB and remigrate"
  task :reload => :environment do
    system("rake db:drop")
    system("rake db:create")
    system("rake db:migrate")
    system("rake db:migrate RAILS_ENV=development")
    puts 'Ready for scraping'
  end
