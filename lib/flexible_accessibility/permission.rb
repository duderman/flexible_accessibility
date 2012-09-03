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
				Utils.new.get_controllers.each do |scope|
					namespace = scope.first
				  (scope - namespace.to_a).each do |klass|
				  	klass = "#{namespace}::#{klass}" unless namespace == "default"
				  	permissions << Permission.new(:controller => klass.gsub(/_controller/, "").to_sym, :actions => ApplicationResource.new(klass).klass.instance_variable_get(:@_checkable_routes))
				  end
				end
				permissions
	  	end

		  def is_action_permitted? permission
		  	self.is_action_permitted_for_user? permission, current_user
		  end

		  def is_action_permitted_for_user? permission, user
		  	# TODO: Avoid these code, maybe handle a callback included in application
		  	!AccessRule.where(["permission = ? and user_id = ?", permission, user.id]).empty?
		  end
		end
  end
end
