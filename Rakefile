# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.
require 'zlib'
require 'stringio'
require 'bio-samtools'
require_relative 'config/application'

Rails.application.load_tasks

def scrape(t)

  count, array = 0, []
  puts "\nMigration starting at #{t}"
  puts "---------"

  # # file shorteners
  path = "/Users/flatironschool/Envisagenics/"
  sample = "Sample_LID115547"
  ext = ".me.bam.sort.bam.clean.exon."

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
  # puts "Generating bam11 fasta at ${Time.now}"
  # system "samtools bam2fq #{bam11} | /users/flatironschool/seqtk/seqtk seq -A > #{fa11s}"
  # puts "Generating bam12 fasta at ${Time.now}"
  # system "samtools bam2fq #{bam12} | /users/flatironschool/seqtk/seqtk seq -A > #{fa12s}"
  # puts "Generating bam21 fasta at ${Time.now}"
  # system "samtools bam2fq #{bam21} | /users/flatironschool/seqtk/seqtk seq -A > #{fa21s}"
  # puts "Generating bam22 fasta at ${Time.now}"
  # system "samtools bam2fq #{bam22} | /users/flatironschool/seqtk/seqtk seq -A > #{fa22s}"

  # # create base SAM enum and index for .bai files
  puts "Generating sample_LID115547_1_1 SAM"
  bam11g = Bio::DB::Sam.new(bam: bam11, fasta: fa11)
  # puts "indexing at ${Time.now}"
  # bam11g.index()
  puts "Generating sample_LID115547_1_2 SAM"
  bam12g = Bio::DB::Sam.new(bam: bam12, fasta: fa12)
  # puts "indexing at ${Time.now}"
  # bam12g.index()
  puts "Generating sample_LID115547_2_1 SAM"
  bam21g = Bio::DB::Sam.new(bam: bam21, fasta: fa21)
  # puts "indexing at ${Time.now}"
  # bam21g.index()
  puts "Generating sample_LID115547_2_2 SAM"
  bam22g = Bio::DB::Sam.new(bam: bam22, fasta: fa22)
  # puts "indexing at ${Time.now}"
  # bam22g.index()

  # # create SAM files
  # puts "Generating sam11 at ${Time.now}"
  # system "samtools view -h #{bam11} > #{sam11}"
  # puts "Generating sam12 at ${Time.now}"
  # system "samtools view -h #{bam12} > #{sam12}"
  # puts "Generating sam21 at ${Time.now}"
  # system "samtools view -h #{bam21} > #{sam21}"
  # puts "Generating sam22 at ${Time.now}"
  # system "samtools view -h #{bam22} > #{sam22}"

  byebug

  File.foreach(file) do |row|
    split_row = row.split("\t")
    split_row.map! { |x| ActiveRecord::Base.connection.quote(x) }

    if row[0] != "@"
      columns = split_row
      time = ActiveRecord::Base.connection.quote(Time.now)
      array << "(columns, #{time}, #{time})"
    end

    count += 1
    $total_count += 1

  end

  sql = "INSERT INTO entries (columns, created_at, updated_at) VALUES " + array.join(", ")
  ActiveRecord::Base.connection.execute(sql)

  puts "---------"
  puts "#{count} entries from this file were added, with #{$total_count} total entries."

end

desc "convert and scrape BAM file"
  task :scrape => :environment do
    t, $total_count = Time.now, 0
    scrape(t)
    puts "\nMigration ended at #{Time.now} and took #{(total / 60).floor} minutes #{total % 60} seconds."
    # puts "There are now #{Entry.all.count} entries"
  end
