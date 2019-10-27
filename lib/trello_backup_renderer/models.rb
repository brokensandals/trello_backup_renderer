module TrelloBackupRenderer
  module Models
    class Board
      attr_reader :lists

      def initialize(args)
        @lists = (args[:lists] || []).sort_by(&:pos)
      end
    end
    
    class List
      attr_reader :cards
      attr_reader :closed
      attr_reader :name
      attr_reader :pos

      def initialize(args)
        @cards = (args[:cards] || []).sort_by(&:pos)
        @closed = args[:closed]
        @name = args[:name]
        @pos = args[:pos]
      end
    end

    class Card
      attr_reader :closed
      attr_reader :name
      attr_reader :pos

      def initialize(args)
        @closed = args[:closed]
        @name = args[:name]
        @pos = args[:pos]
      end
    end
  end
end