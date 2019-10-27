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
      attr_reader :comments
      attr_reader :cover_attachment
      attr_reader :desc
      attr_reader :id
      attr_reader :id_list
      attr_reader :labels
      attr_reader :name
      attr_reader :pos

      def initialize(args)
        @closed = args[:closed]
        @comments = (args[:comments] || []).sort_by(&:date)
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

    class Comment
      attr_reader :creator_full_name
      attr_reader :date
      attr_reader :id_card
      attr_reader :text

      def initialize(args)
        @creator_full_name = args[:creator_full_name]
        @date = args[:date]
        @id_card = args[:id_card]
        @text = args[:text]
      end
    end
  end
end