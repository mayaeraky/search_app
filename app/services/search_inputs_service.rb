class SearchInputsService
    def initialize(model, current_user)
        @search_inputs = model
        @current_user = current_user
    end

    def add_search_keyword(keyword)
        return @search_inputs.order(occurrences: :desc).pluck(:keyword) if keyword.blank?

        # check if it is a subinput of an existing search input for the case of the user clearing the search box manually
        # if the current search input is a subinput of an existing search input, don't add it
        return @search_inputs.order(occurrences: :desc).pluck(:keyword) if @search_inputs.where("keyword LIKE ?", "#{keyword.strip}%").where("LENGTH(keyword) > ?", keyword.strip.length).exists?

        # if the search input already exists, increment occurrences
        existing_keyword = @search_inputs.find_by(keyword: keyword)
        if existing_keyword
            existing_keyword.occurrences += 1
            existing_keyword.save!
            return @search_inputs.order(occurrences: :desc).pluck(:keyword)
        end

        @search_inputs.create(keyword: keyword)

        # if there is a previous search input that is a subinput from the current one and was created less than 5 minutes ago, destroy it
        previous_subtexts = @search_inputs.where("? ILIKE keyword || '%'", keyword.strip).where("updated_at > ?", 5.minutes.ago).where("LENGTH(keyword) < ?", keyword.length)
        previous_subtexts.destroy_all

        @search_inputs.order(occurrences: :desc).pluck(:keyword)
    end

    def find_one(keyword)
        @search_inputs.find_by(keyword: keyword)
    end
end