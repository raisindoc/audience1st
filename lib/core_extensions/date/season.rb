module CoreExtensions
  module Date
    module Season
      def self.included(base) ; base.extend(ClassMethods) ; end
      def at_beginning_of_season(arg=nil)
        Time.at_beginning_of_season(arg || self.year).to_date
        # self.to_time.in_time_zone.at_beginning_of_season(arg).to_date
      end
      def at_end_of_season(arg=nil)
        self.to_time.in_time_zone.at_end_of_season(arg).to_date
      end
      def within_season?(arg)
        self.to_time.in_time_zone.within_season?(arg)
      end
      module ClassMethods
        def from_year_month_day(hash)
          now = ::Time.current
          ::Date.new((hash[:year] || now.year).to_i, (hash[:month] || now.month).to_i, (hash[:day] || now.day).to_i)
        end
      end
    end
  end
end
