module PostsHelper
	def check_blog_access(user, commentaryid)
		answer = false
		user.access_points.each do |ap| 
			if ap.editor? && ap.itemid == "all" && ap.commentaryid == commentaryid
				answer = true
				break
			end  
		end
		return answer
	end
end
