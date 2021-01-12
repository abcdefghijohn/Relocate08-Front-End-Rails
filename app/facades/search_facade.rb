class SearchFacade
  def self.all_businesses(location, category, type)
    json = CategoryService.all_businesses(location, category, type)
    json[:data].map do |biz_data|
      Business.new(biz_data)
    end
  end
end