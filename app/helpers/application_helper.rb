# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  # ==================================
	# make_path
	# ==================================
	def make_path(path, file)
		if file
			path + "/" + file
		else
			""
		end
	end	


end
