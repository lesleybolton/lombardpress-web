class TextController < ApplicationController
	include TextMethods

	#TODO this make question list the index page
	# current division between index and question list is confusing
  def index
		commentaryid = @config.commentaryid
		url =  "<http://scta.info/text/#{commentaryid}/commentary>"
		@results = Lbp::Query.new().collection_query(url)
	end
	def questions
		if params[:resourceid] != nil
			@resource = Lbp::Resource.find("#{params[:resourceid]}")
			# TODO this first conditional should be changed to if resource is topLevelWorkGroup
			if @resource.short_id == "scta"
				@results = @resource.parts_display
				render "text/questions/workgrouplist"
			elsif @resource.type.short_id == "workGroup"
				@results = @resource.expressions_display
				render "text/questions/expressionlist"
			# TODO need an lbp class for expressionType
			elsif @resource.type.short_id == "expressionType"
				@results = ExpressionTypeQuery.new.expression_list(@resource.short_id)
				@info = MiscQuery.new.expression_type_info(shortid)
				@expressions = @results.map {|result| {expression: result[:expression], expressiontitle: result[:expressiontitle], authorTitle: result[:authorTitle]}}.uniq!
				render "text/questions/expressionType_expressionList"
			# TODO need an lbp class for Person
			elsif @resource.type.short_id == "person"
				@results = MiscQuery.new.author_expression_list(@resource.short_id)
				render "text/questions/authorlist"
			elsif params[:resourceid]
				@results = @resource.structure_items_display
				if @resource.level == 1
					@info = @resource.info_display
					@sponsors = @resource.sponsors_display(@info)
					@articles = @resource.articles_display(@info)
					render "text/questions/questions_with_about"
				else
					render "text/questions/questions"
				end
			end
		# TODO review which part if any of the conditional below is necessary
		else
			if @config.commentaryid == "scta"
				@resource = Lbp::Resource.find("http://scta.info/resource/scta")
				@results = @resource.parts_display
				render "text/questions/workgrouplist"
			else
				commentaryid = @config.commentaryid
				@resource = Lbp::Resource.find("http://scta.info/resource/#{commentaryid}")
				@results = @resource.structure_items_display
			end
		end
	end

	def info
		expression = get_expression(params)
		check_permission(expression)
		@title = expression.title
		#@itemid should be equivalent to expression id
		@itemid = params[:itemid]
		url_short_id = get_shortid(params)

		url = "http://scta.info/resource/#{url_short_id}"
		query = Lbp::Query.new
		@name_results = query.names(url)
		@quote_results = query.quotes(url)

	end

	def status
		#commentaryid = @config.commentaryid
		url = "<http://scta.info/resource/#{params[:itemid]}>"
		results = Lbp::Query.new.item_query(url)

		# @itemid is equivalent to @expression id
		# will be changed as part of global change
		@itemid = params[:itemid]
		@results = results.order_by(:transcript_type)
		if @results.count == 0
			flash.clear
		end
	end

	def show
		if params.has_key?(:search)
			flash.now[:notice] = "Search results for instances of #{params[:searchid]} (#{params[:search]}) are highlighted in yellow below."
		end

		# get expression and related info
		@expression = get_expression(params)

		@expression_structure = @expression.structure_type.short_id
		# perform checks
		check_transcript_existence(@expression)
		check_permission(@expression); return if performed?

		if @expression.status == "In Progress" || @expression.status == "draft"
			flash.now[:alert] = "Please remember: the status of this text is draft. You have been granted access through the generosity of the editor. Please use the comments to help make suggestions or corrections."
		end

		#get values  needed for view
		#@expressionid = params[:itemid]
		@title = @expression.title
		@next_expressionid = if @expression.next != nil then @expression.next.to_s.split("/").last else nil end
		@previous_expressionid = if @expression.previous != nil then @expression.previous.to_s.split("/").last else nil end

		#get transcription Object from params
		transcript = get_transcript(params)


		# ms_slugs is not great because its hard coding "critical"
    # what if the name of the manifestion for a critical manifestion was not called critical
    # more idea to check database to get a manifestationType
    # but this could be costly. If there were 20 or 30 manifestations
    # then you'd be making lots of requests to db
    # this map is reused in the paragraph controller as well; should be refactored
    ms_slugs = @expression.manifestations.map {|m| unless m.to_s.include? 'critical' then m.to_s.split("/").last end}.compact
		default_wit_param = ms_slugs[0]

		#prepare xslt arrays to be used for transformation
			#always remember single quotes for paramater value
			#specify if global image setting is true or false


		xslt_param_array = ["default-ms-image", if default_wit(params) == "critical" then "'#{default_wit_param}'" else "'#{default_wit(params)}'" end,
				"default-msslug", "'#{default_wit(params)}'",
				"show-images", "'#{@config.images.to_s}'",
				"by_phrase", "'#{t(:by)}'",
				"edited_by_phrase", "'#{t(:edited_by)}'"]

		# get file object to be tansformed
		# and perform transformation
		if @expression_structure == "structureItem"
			file = params[:branch] ? transcript.file(@config.confighash, params[:branch]) : transcript.file(@config.confighash)
			@transform = file.transform_main_view(xslt_param_array)
		elsif @expression_structure == "structureBlock"
			file = transcript.file_part(@config.confighash, params[:itemid])
			@transform = file.transform_plain_text(xslt_param_array)
		end
	end

	def xml
		expression = get_expression(params)
		@expression_structure = expression.structure_type.short_id

		check_permission(expression)

		transcript = get_transcript(params)

		if @expression_structure == "structureItem"
			file = transcript.file(@config.confighash)
			@nokogiri = file.nokogiri
		elsif @expression_structure == "structureBlock"
			# NOTE: don't be confused by item id here; it is the id of the block express
			# all :itemid should be interpreted as shortId of the expression.
			# the will eventually all be changed to "expressionid"
			file = transcript.file_part(@config.confighash, params[:itemid])
			@nokogiri = file.xml
		end
	end
	def plain_text
		## TODO refactor: this code is almost identical to TOC except that
		## it chooses a different transform options at the very end
		expression = get_expression(params)
		@expression_structure = expression.structure_type.short_id

		check_permission(expression)

		transcript = get_transcript(params)

		if @expression_structure == "structureItem"
			file = transcript.file(@config.confighash)
		elsif @expression_structure == "structureBlock"
			# NOTE: itemid => expressionid
			file = transcript.file_part(@config.confighash, params[:itemid])
		end
		@plaintext = file.transform_plain_text
		render :plain => @plaintext


	end
	def toc
		expression = get_expression(params)
		@expression_structure = expression.structure_type.short_id

		check_permission(expression)

		transcript = get_transcript(params)

		if @expression_structure == "structureItem"
			file = transcript.file(@config.confighash)
		elsif @expression_structure == "structureDivision"
			## until each structure division has its own
			## tei file, it will need to use the file_part class
			## and will need a method that can get the toc of just that part
		end
		@toc = file.transform_toc
		render :layout => false
	end

	def draft_permissions

	end

	private

end
