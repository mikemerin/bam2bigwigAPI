class CreateAlignments < ActiveRecord::Migration[5.1]
  def change
    create_table :alignments do |t|
      t.string :qname
      t.string :flag
      t.string :chromosome
      t.string :pos
      t.string :mapq
      t.string :cigar
      t.string :mrnm_rnext
      t.string :mpos_pnext
      t.string :isize_tlen
      t.string :seq
      t.string :qual

      t.timestamps
    end
  end
end
