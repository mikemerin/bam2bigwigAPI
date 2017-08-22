require 'zlib'
require 'stringio'
require 'bio-samtools'
require_relative 'config/application'

Rails.application.load_tasks

def scrape_SAM(file, t)

  count, array = 0, []
  puts "\nMigration starting at #{t}"
  puts "---------"

  # get path name and file name for file types
  path = file.split("/")
  file = path.pop

  path = path.join("/")
  file = file.split(".")
  file.pop
  file = file.join(".")

  # # file names
  bam = "#{path}/#{file}.bam"
  fa = "#{path}/#{file}.fa"
  fas = "#{file}.fa"
  sam = "#{path}/#{file}.sam"
  sams = "#{file}.sam"

  puts "Generating fasta file at #{Time.now}"
  system "samtools bam2fq #{bam} | /users/flatironschool/seqtk/seqtk seq -A > #{fas}"

  puts "Creating base SAM enum"
  bamg = Bio::DB::Sam.new(bam: bam, fasta: fa)
  puts "Indexing to generate .bai files at #{Time.now}"
  bam11g.index()

  puts "Generating SAM file at #{Time.now}"
  system "samtools view -h #{bam} > #{sam}"

  File.foreach(sam) do |row|
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

  sql = "INSERT INTO alignments (qname, flag, chromosome, pos, mapq, cigar, mrnm_rnext, mpos_pnext, isize_tlen, seq, qual, created_at, updated_at) VALUES " + array.join(", ")
  ActiveRecord::Base.connection.execute(sql)

  puts "---------"
  puts "#{count} alignments from this file were added, with #{$total_count} total alignments."

end


def scrape_BW(file, t)

  count, array = 0, []
  puts "\nMigration starting at #{t}"
  puts "---------"

  # get file name for file types
  file = file.split(".")
  file.pop
  file = file.join(".")

  # file names
  bam = "#{file}.bam"
  bg = "#{file}.bedgraph"
  bgc = "#{file}.clip.bedgraph"
  bgcc = "#{file}.clip.collate.bedgraph"
  bw = "#{file}.bw"

  chrom_info = "/Users/flatironschool/Envisagenics/bam2bigwigAPI/hg38.chrom.sizes"

  puts "Calculating coverage over each genomic position, generating bedgraph file"
  system "genomeCoverageBed -bg -ibam #{bam} -g chrom_info > #{bg}"

  puts "bedClipping file to correct chromosome sizes"
  puts "----------------------------------------"
  system "./bedClip #{bg} chrom_info #{bgc}"

  puts "collating and sorting file"
  system "LC_COLLATE=C sort -k1,1 -k2,2n #{bgc} > #{bgcc}"

  puts "Generating bigwig file"
  system "./bedGraphToBigWig #{bgcc} chrom_info #{bw}"

  File.foreach(bw) do |row|
    row = ActiveRecord::Base.connection.quote(row.force_encoding('iso-8859-1').encode('utf-8'))

    time = ActiveRecord::Base.connection.quote(Time.now)
    array << "(#{row}, #{time}, #{time})"

    count += 1
    $total_count += 1
    puts "#{Time.now - t} s: #{count} rows added" if count % 10000 == 0

    if count % 200000 == 0
      sql = "INSERT INTO bwrows (row, created_at, updated_at) VALUES " + array.join(", ")
      puts "============= Seeding 200,000 rows ============="
      ActiveRecord::Base.connection.execute(sql)
      puts "============= #{Bwrow.all.count} rows are now in the database ============="
      array = []
    end

  end

  sql = "INSERT INTO bwrows (row, created_at, updated_at) VALUES " + array.join(", ")
  ActiveRecord::Base.connection.execute(sql)

  puts "---------"
  puts "#{count} rows from this file were added, with #{$total_count} total rows."

end

desc "convert and scrape BAM file as SAM"
  task :scrape_sam => :environment do
    STDOUT.puts "Please enter the full path of the file you would like to convert (without quotes)"
    file = STDIN.gets.chomp
    t, $total_count = Time.now, 0
    scrape_SAM(file, t)
    puts "\nMigration ended at #{Time.now} and took #{(total / 60).floor} minutes #{total % 60} seconds."
    puts "There are now #{Alignment.all.count} alignments"
  end

desc "convert and scrape BAM file as bigWig"
  task :scrape_bw => :environment do
    STDOUT.puts "Please enter the full path of the file you would like to convert (without quotes)"
    file = STDIN.gets.chomp
    t, $total_count = Time.now, 0
    scrape_BW(file, t)
    puts "\nMigration ended at #{Time.now} and took #{(total / 60).floor} minutes #{total % 60} seconds."
    puts "There are now #{Bwrow.all.count} rows"
  end

desc "reload DB and remigrate"
  task :reload => :environment do
    system("rake db:drop")
    system("rake db:create")
    system("rake db:migrate")
    system("rake db:migrate RAILS_ENV=development")
    puts 'Ready for scraping'
  end
