class ImportParser

    def initialize(raw_data)
        @import = raw_data
    end
    def valid?
        #check if 3rd party vendor is GoldStar or TodayTix
        # calls TodayTix.valid? && GoldStar.valid?
    end
end


class TodayTix < ImportParser
    def valid?
    end
    def parse
    end

end



class GoldStar < ImportParser
    def valid?
    end
    def parse
    end
end
