class Api::V1::AlignmentsController < ApplicationController

  def index
    @alignments = Alignment.all
    render json: @alignments
  end

  def show
    @alignment = Alignment.find_by(id: params[:id])
    render json: @alignment
  end

  private

  def alignment_params
    params.require(:alignment).permit(
      :qname,
      :flag,
      :chromosome,
      :pos,
      :mapq,
      :cigar,
      :mrnm_rnext,
      :mpos_pnext,
      :isize_tlen,
      :seq,
      :qual
      )
  end

end

# "Read Name
# SAM flag
# chromosome (if read is has no alignment, there will be a "*" here)
# position (1-based index, "left end of read")
# MAPQ (mapping quality - describes the uniqueness of the alignment, 0=non-unique, >10 probably unique)
# CIGAR string (describes the position of insertions/deletions/matches in the alignment, encodes splice junctions, for example)
# Name of mate (mate pair information for paired-end sequencing, often "=")
# Position of mate (mate pair information)
# Template length (always zero for me)
# Read Sequence
# Read Quality
# Program specific Flags (i.e. AS is an alignment score, NH is a number of reported alignments that contains the query in the current record)"

# "QNAME: Query name of the read or the read pair
# FLAG: Bitwise flag (pairing, strand, mate strand, etc.)
# RNAME: Reference sequence name
# POS: 1-Based leftmost position of clipped alignment
# MAPQ: Mapping quality (Phred-scaled)
# CIGAR: Extended CIGAR string (operations: MIDNSHP)
# MRNM: Mate reference name (‘=’ if same as RNAME)
# MPOS: 1-based leftmost mate position
# ISIZE: Inferred insert size
# SEQQuery: Sequence on the same strand as the reference
# QUAL: Query quality (ASCII-33=Phred base quality)"
