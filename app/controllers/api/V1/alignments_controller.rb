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
