module FlexibleAccessibility
  class Permission
    attr_reader :controller
    attr_reader :actions

    def initialize args={}
      @controller = args[:controller]
      @actions = args[:actions]
    end

  	class << self
	  def all
		permissions = []
		Utils.new.get_controllers.each do |klass|
		  permissions << Permission.new(:controller => klass.to_sym, :actions => klass.camelize.constantize.instance_variable_get(:@_checkable_routes))
		end
		permissions
	  end

      # Stub methods
	  def is_action_permitted? permission
	  	self.is_action_permitted_for_user? permission, current_user
	  end

	  def is_action_permitted_for_user? permission, user
	  	false 
	  end
	end
  end
end