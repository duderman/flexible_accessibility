module FlexibleAccessibility
	class ApplicationResource
		attr_reader :controller
		attr_reader :namespace

	  def initialize resource_string
	  	@controller = resource_string.split("/").last
	  	@namespace = resource_string.split("/").first == @controller ? "default" : resource_string.split("/").last
	  end

		def klass
			(@namespace.camelize + "::" + @controller.camelize).constantize unless is_standard_resource?
			@controller.camelize.constantize if is_standard_resource?
		end

		def is_standard_resource?
			@namespace == "default"
		end
  end
end