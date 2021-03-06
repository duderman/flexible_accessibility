module FlexibleAccessibility
  class Permission
    attr_reader :resource
    attr_reader :actions

    def initialize(args={})
      @resource = args[:resource]
      @actions = args[:actions]
    end

    def controller
    	ApplicationResource.new(self.resource).controller
    end

    def namespace
    	ApplicationResource.new(self.resource).namespace
    end

		# TODO: this function may be recursive because nesting may be existed
    class << self
  	  def all
  			permissions = []
  			Utils.new.app_controllers.each do |scope|
  				namespace = scope.first.to_s
  			  scope.last.each do |resource|
  			  	resource = "#{namespace}/#{resource}" unless namespace == 'default'
  			  	permissions << Permission.new(:resource => resource.gsub(/_controller/, ''), :actions => ApplicationResource.new(resource).klass.instance_variable_get(:@_verifiable_routes))
  			  end
  			end
  			permissions
    	end
    end
  end
end
