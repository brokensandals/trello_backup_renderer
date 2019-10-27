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
      attr_reader :id
      attr_reader :name
      attr_reader :pos

      def initialize(args)
        @cards = (args[:cards] || []).sort_by(&:pos)
        @closed = args[:closed]
        @id = args[:id]
        @name = args[:name]
        @pos = args[:pos]
      end
    end

    class Card
      attr_reader :closed
      attr_reader :cover_attachment
      attr_reader :desc
      attr_reader :id
      attr_reader :id_list
      attr_reader :labels
      attr_reader :name
      attr_reader :pos

      def initialize(args)
        @closed = args[:closed]
        @cover_attachment = args[:cover_attachment]
        @desc = args[:desc]
        @id = args[:id]
        @id_list = args[:id_list]
        @labels = (args[:labels] || []).sort_by(&:name)
        @name = args[:name]
        @pos = args[:pos]
      end
    end

    class Attachment
      attr_reader :path

      def initialize(args)
        @path = args[:path]
      end
    end

    class Label
      attr_reader :color
      attr_reader :name

      def initialize(args)
        @color = args[:color]
        @name = args[:name]
      end
    end
  end
end