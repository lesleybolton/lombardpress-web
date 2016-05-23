class ParagraphexemplarController < ApplicationController
	def json

    para = Lbp::Expression.new(params[:itemid])

    #TODO: paragraphNumber in db should be changed to something generic for all expressions
    # then this conditional will no longer be necessary 

		if para.structureType_shortId == "structureBlock"
      number = para.results.dup.filter(:p => RDF::URI("http://scta.info/property/paragraphNumber")).first[:o].to_s.to_i
    else
      number = para.order_number
    end
		expression_hash = {
        #:pid => pid,
        :itemid => params[:itemid],     
        :next => if para.next != nil then para.next.split("/").last else nil end, 
        :previous => if para.previous != nil then para.previous.split("/").last else nil end,
        :number => number,
        :transcriptions => para.manifestationUrls,
        :abbreviates => para.abbreviates.map {|item| item[:o].to_s},
        :abbreviatedBy => para.abbreviatedBy.map {|item| item[:o].to_s},
        :references => para.references.map {|item| item[:o].to_s},
        :referencedBy => para.referencedBy.map {|item| item[:o].to_s},
        :copies => para.copies.map {|item| item[:o].to_s},
        :copiedBy => para.copiedBy.map {|item| item[:o].to_s},
        :quotes => para.quotes.map {|item| item[:o].to_s},
        :quotedBy => para.quotedBy.map {|item| item[:o].to_s},
        :mentions => para.mentions.map {|item| item[:o].to_s},
        #:wordcount => paratranscript.word_count,
        #:wordfrequency => paratranscript.word_frequency

      }
    render :json => expression_hash
  end
  
end