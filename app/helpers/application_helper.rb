module ApplicationHelper

	FLASH_KEY = {'alert' => 'warning',
		'notice' => 'success',
		'error' => 'danger'}

	def full_title(page_title='')
		base_title = "Societo"
		page_title.empty? ? base_title : "#{base_title} || #{page_title}"
	end

	def get_object_error_into_flash(object)
		
		if(object and !object.errors.messages.empty?)
			flash[:error] = []

			object.errors.full_messages.each do |message|
				flash[:error] << message
			end
			flash[:error].uniq!
			flash[:error] = flash[:error].join('<br />')
		end

	end

	def get_object_error_into_flash_render(object)
		if(object and !object.errors.messages.empty?)
			flash.now[:error] = object.errors.full_messages.join('<br />')
		end
	end

	def get_message_class(key)
		FLASH_KEY[key]
	end
end
