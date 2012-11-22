class Iec60751Controller < ApplicationController
  def t90
    r  = Float(params[:r])  rescue nil
    r0 = Float(params[:r0]) rescue nil
    a  = Float(params[:a])  rescue nil
    b  = Float(params[:b])  rescue nil
    c  = Float(params[:c])  rescue nil
    t = Iec60751.t90(r, r0, a, b, c)
    render json: { t90: t }
  end
end
