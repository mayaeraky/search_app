class ApplicationPolicy
    attr_reader :user_context, :record

    def initialize(user_context, record)
      @current_user = user_context.current_user
    end

    def index?
      false
    end

    def create?
      false
    end

    class Scope
      attr_reader :user_context, :scope

      def initialize(user_context, scope)
        @current_user = user_context.current_user
        @scope = scope
      end

      def resolve
        scope.all
      end
    end
end