class SearchInputsController < ApplicationController
    protect_from_forgery with: :null_session
    before_action :set_current_user, :set_search_inputs_service

    def create
        keyword = search_keywords_create_params
        result = @search_inputs_service.add_search_keyword(keyword)
        render json: result
    end

    def show
        keyword = params.require(:id)
        search_input = @search_inputs_service.find_one(keyword)
        if search_input
          render json: {
            keyword: search_input.keyword,
            occurrences: search_input.occurrences,
            created_at: search_input.created_at.strftime("%Y-%m-%d %H:%M"),
            updated_at: search_input.updated_at.strftime("%Y-%m-%d %H:%M")
          }
        else
          render json: { error: "Not found" }, status: :not_found
        end
      end

    def search_keywords_create_params
        params.require(:keyword)
    end

    private
    def set_search_inputs_service
        authorize(SearchInput)
        @search_inputs = policy_scope(SearchInput)
        @search_inputs_service = SearchInputsService.new(@search_inputs, @current_user)
    end
end
